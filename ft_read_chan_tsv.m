function channels = ft_read_chan_tsv(filename)

% Script for importing data from the following text file:
%
%    filename: D:\MATLAB\Analysis\Data\testData\channelss.tsv
%
% Auto-generated by MATLAB on 28-Jan-2020 10:07:39

%% Setup the Import Options
opts        = detectImportOptions(filename,'filetype','text');
tsv         = readtable(filename, opts); 
tsv         = table2struct(tsv);

%% Reformat into FT-like structure with cell array
channels = [];

fn = fieldnames(tsv);
for i = 1:length(fn)
    if ischar(tsv(1).(fn{i}))
        channels.(fn{i}) = {tsv(:).(fn{i})}';
    end
end

%% Try to determine the orientation of the sensors
for i = 1:length(channels.name)
    chan_end = channels.name{i}(end-2:end);
    if strcmp(chan_end,'TAN')
        channels.fieldori{i,1} = chan_end;
    elseif strcmp(chan_end,'RAD')
        channels.fieldori{i,1} = chan_end;
    else
        channels.fieldori{i,1} = 'UNKNOWN';
    end
end

%% Replace default names with Fieldtrip names
% Replace 'MEG' with 'megmag'
try
    indx = find(contains(channels.type,'MEG'));
    channels.type(indx) = {'megmag'};
catch
    ft_warning('Cannot replace MEG with megmag');
end

% Replace 'REF' with 'refmag'
try
    indx = find(contains(channels.type,'REF'));
    channels.type(indx) = {'refmag'};
catch
    ft_warning('Cannot replace REF with refmag');
end

% Replace 'TRIG' with 'trigger
try
    indx = find(contains(channels.type,'TRIG'));
    channels.type(indx) = {'trigger'};
catch
    ft_warning('Cannot replace TRIG with trigger');
end




