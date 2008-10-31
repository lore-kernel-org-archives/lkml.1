Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYJaJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYJaJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYJaJcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:32:04 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:28360 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYJaJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:32:01 -0400
X-Greylist: delayed 1590 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2008 05:32:00 EDT
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2008 10:05:11 +0100
MIME-Version: 1.0
Subject: Ideas on printk_ratelimit()
Message-ID: <490AD85B.15446.FDA5D58@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.29/Sophos-P=4.34.0+V=4.34+U=2.07.214+R=06 October 2008+T=515190@20081031.085044Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ever since I saw the first implementation on printk_ratelimit, I felt like having 
to comment on it. Eventuelly I do:

The implementation uses a global setting to limit the number of messages output by 
printk() to avoid overflowing the syslog.

I felt a more object-oriented approach might make sense. In simple words: I'd 
suggest to pass a pointer to some structure describing the throttling details for 
the "event" (i.e. message). Thus one could throttle messages based on a subsystem 
or message (event) base, not just globally.

I did implement a thing like that in Perl, and I'll present it here for reference. 
Maybe someone would like to implement it in C for the Linux kernel.

I'm talking about "events" not "messages" from here on. My events have a state 
which can be "off (-1)", "unknown (0)", and "on (1)". Detecting some problem would 
set the event "on", while detecting the problem is gone would reset the event.

For printk(), any attempt to print something could count as an event being 
detected, and events are never reset.

So far we would just set and count things, but print nothing. In my little 
framework, one would query the event whether it has been "acknowledged" (i.e. 
printed). And there's the trick: The flag whether the event is acknowledged 
depends on the time of the last event, the number of events counted so far, and 
the time of the last acknowledge.

OK, let's see some code:

# make new object with acknowledge interval definitions
sub new($$)
{
    my ($class, $interval_def) = @_;
    my $self = {
        'intd' => $interval_def || DEFAULT_ACK,
                                # interval difinitions for acknowledgements
        'intr' => 0,            # current interval between acknowledgements
        'stat' => 0,            # status (-1=off, 0=unknown, 1=on)
        'frst' => -1,           # time of first occurrence
        'last' => -1,           # time of lasst occurrence
        'next' => -1,           # time of next occurrence
        'ecnt' => 0             # event count
    };

    bless $self, $class;
    $self->reset();
    return $self;
}

The hash keys are the object's features (as described in the comments). Let's have 
a look at my DEFAULT_ACK, the definitions of when to acknowledge events:

# default acknowledgement interval, al list of [counter, pause]
use constant DEFAULT_ACK => [[5, 0], [1, 10], [3, 15], [4, 30], [2, 60],
                             [2, 300], [3, 900], [4, 1800], [4, 3600],
                             [2, 2 * 3600], [4, 4 * 3600], [3, 8 * 3600],
                             [7, 24 * 3600]];

The list consists of pair elements. Each pair describes a count of events and the 
ignore interval. Reading the list above means: For the first five events, ignore 
none. then, for the next event, ignore for 10 seconds. Then after further three 
events, ignore for 15 seconds, ... until finally ignoring events for a whole day.

The 'intr' key defines the current interval in which events are ignored. The 
reset() code is this:

# reset state
sub reset($)
{
    my ($self) = @_;

    $self->{'ecnt'} = 0;
    $self->{'stat'} = -1;
    $self->{'intr'} = $self->{'intd'}->[0]->[1]; # first pair
    $self->{'frst'} = -1;
    $self->{'last'} = -1;
    $self->{'next'} = -1;
}

Now it's time to look how I set up things if an event happens:

# set event status, returning the number of non-off stati counted so far
sub set($$)
{
    my ($self, $status) = @_;

    if ($status > -1) {
        my $t = time();

        if ($self->{'ecnt'}++ == 0) {
            $self->{'stat'} = $status;
            $self->{'frst'} = $t;
            $self->{'next'} = $t + $self->{'intr'};
        }
        $self->{'last'} = $t;
        return $self->{'ecnt'};         # just because it's handy...
    } else {
         my $ecnt = $self->{'ecnt'};

        if ($self->{'stat'} != -1) {
            $self->reset();
        }
        return $ecnt;                   # just because it's handy...
    }
}

So when setting an event, we count events, remember the status and time of the 
event, and set up the acknowledgement deadline. When resetting, we forget about 
everything, but return the events counted (just for convenience here).

The obvious test whether an acknowledgement is (not) needed is this:
# is event already acknowledged (i.e. to be ignored)?
sub is_ack($)
{
    my ($self) = @_;

    return $self->{'last'} < $self->{'next'};
}

Finally when ack-ing an event, this happens:

# acknowledge event
sub ack($)
{
    my ($self) = @_;

    if ($self->{'stat'} != -1) {
        $self->grow_interval()
            if ($self->{'last'} > $self->{'next'});
        $self->{'next'} = $self->{'last'} + $self->{'intr'};
    }
}

So basically we refresh the time when the next acknowledgement is needed, possibly 
updating the interval. So that code follows:

# increase interval for acknowledgements
sub grow_interval($)
{
    my ($self) = @_;
    my $cnt = $self->{'ecnt'};

    foreach my $ar (@{$self->{'intd'}}) {
        if (($cnt -= $ar->[0]) < 0) {
            $self->{'intr'} = $ar->[1];
            return;
        }
    }
    $self->{'intr'} = $self->{'intd'}->[-1]->[1];
}

So basically we use the event count to advance in the list far enough to get the 
desired element. If not enough elements are there, use the last one. Note that 
this is not highly efficient; to improve things, one could store a count of 
"consumed events" and an index or pointer to the "current" element in the list to 
speed up the decision.

So basically that's all the event code. Now let's see a use sample:

        $event->set($status);
        if ($status != -1) {
            $self->LogEvent($event, 2, 'W', $logger,
                            "We have some problem (status is $status)");

Eventually LogEvent does some magic with events:

# Call Log() to print a message if the EventState needs an acknowledgement.
sub LogEvent($$$$$@)
{
    my ($self, $evt, @rest) = @_;

    unless ($evt->is_ack()) {
        $self->Log(@rest);
        $self->Log(0, 'I', undef, '(Event count', $evt->count(), '(' .
                   strftime('%Y-%m-%d %X', localtime($evt->time_first())) .
                   ' - ' .
                   strftime('%Y-%m-%d %X', localtime($evt->time_last())) .
                   ')')
            if ($evt->count() > 1);
        $evt->ack();
        $self->Log(0, 'I', undef, '(Ignored until',
                   strftime('%Y-%m-%d %X', localtime($evt->time_next_ack())) .
                   ' [' . $evt->interval() . '])')
            if ($evt->interval() > 0);
    }
}

That code above means: If the event is not acknowledged, Log it and acknowledge 
it. For convenience the count of events is printed together with the times when 
the event occurred first and last (maybe use the duration instead), as well as an 
announcement how long further events of the same type will be ignored.

I've left out the obvious access functions for event attributes, but that should 
be obvious.

For the kernel, one would use ticks instead of seconds, most likely.

If you like the idea, feel free to implement a new throttling printk() and maybe 
some event handling framework.

Finally here's a sample on how things might look in my log:
Manager@host[PID](2008-10-30 08:15:24):W:(Monitor):(Some Problem)
Manager@host[PID](2008-10-30 08:15:54):W:(Monitor):(Some Problem)
Manager@host[PID]:I: (Event count 2 (2008-10-30 08:15:24 - 2008-10-30 08:15:54)
Manager@host[PID](2008-10-30 08:16:24):W:(Monitor):(Some Problem)
Manager@host[PID]:I: (Event count 3 (2008-10-30 08:15:24 - 2008-10-30 08:16:24)
[...]
Manager@host[PID](2008-10-30 08:17:54):W:(Monitor):(Some Problem)
Manager@host[PID]:I: (Event count 6 (2008-10-30 08:15:24 - 2008-10-30 08:17:54)
Manager@host[PID]:I: (Ignored until 2008-10-30 08:18:09 [15])

Enjoy,
Ulrich
P.S. Not subscribed to the list, so if you want to reach me, use CC:
P.P.S. No need to send SPAM, I have enough already ;-)

