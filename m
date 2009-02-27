Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZB0QqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZB0QqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 11:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZB0QqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 11:46:12 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:45483 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZB0QqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 11:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g2OaGpNPFhT80NOgH7gf5/a16mtJKI2QUB2WqfnqNMbKwbuO0/8A0mgDpErectI/zr
         JBW+tgiZ7kf88krpdMBYlna65snQBMjWAaXRduFgFjPxsmsJ1DVxjVxuU8IADn+ymAJe
         wFPrfTgv8ymqVSaBNUG4aM1+2ngjdeFiBG0PE=
Date: Fri, 27 Feb 2009 17:46:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE][PATCH 0 of 4] zedtrace, a general-purpose binary
	tracer
Message-ID: <20090227164559.GB5856@nowhere>
References: <1235725238.8512.86.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235725238.8512.86.camel@charm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 03:00:38AM -0600, Tom Zanussi wrote:
> Since everyone seems to be posting binary tracers lately, I thought I'd
> post the current version of mine too.  It's called zedtrace and is
> based on utt, the generic tracing framework derived from the powerful
> blktrace tracing infrastructure.  The details are below and in the
> code, but in a nutshell what it does, in addition to providing the
> standard tracing-to-disk/network/live-mode per-cpu tracing enabled by
> utt, is to provide a very efficient way to move data pretty much
> directly from the kernel into native variables defined in
> high-level-language event-handling scripts, where they can then be
> manipulated using the full power of the high-level-language being
> used.  This is done via self-describing events, the definition of which
> make for very efficient logging functions (basically 'direct to the
> wire', avoiding anything like run-time binary printk() overhead).  The
> design also makes it trivially easy to add new event definitions when
> new tracepoints come online, and also to create new userspace
> high-level-language event-handling support (see the zedperl code, which
> should be easily ported to create a zedpython or zedruby, for
> instance).


Ah, that's a good idea.
API interface with high level existing script languages and event handling
directly from them is really convenient. So that you can work directly with
you events.
Will look at your patches to see how it is performed.

 
> I haven't had much time to write many useful scripts yet, though
> hopefully the few examples described below would give some idea of what
> kinds of things could be done.  I'll probably start by porting my
> version of blktrace-in-the-kernel that I did a couple of years ago:
> http://sources.redhat.com/ml/systemtap/2007-q1/msg00485.html
> 
> Here's the blurb from the config option, which describes it in a little
> more detail.  Following that are some examples and usage details.
> 
> zedtrace is a low-overhead general-purpose kernel tracing option
> that allows you to selectively trace any/all tracepoints currently
> defined in the kernel, with generic kernel or userspace filtering, as
> desired.  Trace events from different subsystems
> e.g. sched/block/workqueue appear together seamlessly in the trace
> output, allowing interactions between subsystems to be identified and
> providing an overall view of system-wide activity.
> 
> All trace events are self-describing; there are a number of userspace
> tools available in the zedtrace tarball that take advantage of this
> and make all of the events and event fields available to
> general-purpose language interpreters as native types and event
> handler funtions.  For instance, the 'zedperl' event interpreter
> allows the full power of Perl to be used to aggregate and analyze
> either a saved set of per-cpu trace files or or a live trace stream in
> real-time.  There are also simpler utilities that can be used to do
> the same thing but that simply print the data in a generic way.  In
> any case, because the data is self-describing, these tools don't need
> to be recompiled when new events are added to the kernel.  Users can
> also trivially write their own front-ends to display and/or
> aggregate/analyze the trace stream in custom ways by plugging in to
> the modular Zed architecture; interpreters for other languages such as
> Python, Ruby, etc. are expected soon.
> 
> Because Zed is based on the best-of-breed blktrace-derived UTT
> userspace tracing library, users can trace not only to local disk but
> over the network in several different ways, and as mentioned can also
> do 'live tracing' using the combined per-cpu data stream.
> 
> See kernel/trace/trace_binary/zedtrace.h for the current set of event
> definitions, which can be used as examples for adding your own.
> 
> See http://utt.sourceforge.net/zedtrace.html for userspace tools,
> examples and further documentation.
> 
> Usage
> -----
> 
> The simplest thing to do is trace to disk, which you can do by simply
> invoking zedtrace with a set of events to trace.  To find out what
> events are available, use the -t zedtrace option:
> 
> # ./zedtrace -t
> 
> Available tracepoints:
> 
> sched
>   sched:kthread_stop
>   sched:kthread_stop_ret
>   sched:wait_task
>   sched:wakeup
>   sched:wakeup_new
>   sched:switch
>   sched:migrate_task
>   sched:process_free
>   sched:process_exit
>   sched:process_wait
>   sched:process_fork
>   sched:signal_send
> block
>   block:rq_abort
>   block:rq_insert
>   block:rq_issue
>   block:rq_requeue
>   block:rq_complete
>   block:bio_bounce
>   block:bio_complete
>   block:bio_backmerge
>   block:bio_frontmerge
>   block:bio_queue
>   block:getrq
>   block:sleeprq
>   block:plug
>   block:unplug_io
>   block:unplug_timer
>   block:split
>   block:remap
> workqueue
>   workqueue:insertion
>   workqueue:execution
>   workqueue:creation
>   workqueue:destruction


You already wrote the subsystem, so I guess the subsystem: prefix
is a bit too much. Anyway, sorting the tracepoints by subsystem is a good
idea too.


> 
> You can specify any or all of these to tell zedtrace which events to
> trace.  You can specify complete subsystems to trace, using the
> top-level (unindented) items in the event listing, or individual
> events using the same syntax as displayed in the listing e.g.
> 
> # ./zedtrace sched block workqueue
> # ./zedtrace sched:switch sched:process_fork
> 
> This results in a set of per-cpu trace files in the current directory:
> 
> -rw-r--r--  1 root root   18432 2009-02-26 22:36 trace.zed.0
> -rw-r--r--  1 root root   39152 2009-02-26 22:36 trace.zed.1
> 
> You can use zedprint to print all the events along with the raw values
> for each event, by simply specifying the first common part of the
> per-cpu trace files (e.g. trace).  Because events are self-describing,
> you can use the same zedprint executable to print any event even if it
> was added to the kernel at a later time (the same is also true for
> zedperl as well, see below).  Note that the output of zedprint is not
> pretty, and it wasn't meant to be - it's a simple program used to
> generically dump trace records:
> 
> # ./zedprint trace
> 
> wakeup               cpu = 1, time =     4.107217716, sequence = 2991, wakeup_pid = 12172, success = 1, 
> switch               cpu = 1, time =     4.107237155, sequence = 2992, prev_pid = 0, next_pid = 12172, 
> remap                cpu = 1, time =     4.115181242, sequence = 2993, dev = 8388614, what = 1048591,
> 		     rw = 0, errors = 0, sector = 212057636, bytes = 61440, pdu_len = 16, pdu[0] = blob, 
> bio_queue            cpu = 1, time =     4.115183032, sequence = 2994, dev = 0, what = 1048577, rw = 0,
> 		     errors = 0, sector = 212057636, bytes = 61440, 
> getrq                cpu = 1, time =     4.115190306, sequence = 2995, dev = 0, what = 1048580, rw = 0,
> 		     errors = 0, sector = 212057636, bytes = 61440, 
> plug                 cpu = 1, time =     4.115194683, sequence = 2996, dev = 0, what = 1048585, 
> rq_insert            cpu = 1, time =     4.115198413, sequence = 2997, dev = 8388608, what = 17891340,
> 		     rw = 0, errors = 0, sector = 212057636, bytes = 61440, pdu_len = 0, pdu[0] = blob, 
> unplug_io            cpu = 1, time =     4.115204344, sequence = 2998, dev = 0, what = 1048586, pdu_len = 8, pdu[0] = blob, 
> rq_issue             cpu = 1, time =     4.115211814, sequence = 2999, dev = 8388608, what = 21037063, rw = 0,
> 		     errors = 0, sector = 212057636, bytes = 61440, pdu_len = 0, pdu[0] = blob, 
> switch               cpu = 1, time =     4.115240756, sequence = 3000, prev_pid = 12172, next_pid = 0, 
> insertion            cpu = 1, time =     4.117371692, sequence = 3001, pid = 2872, 
> wakeup               cpu = 1, time =     4.117378249, sequence = 3002, wakeup_pid = 2872, success = 1, 
> switch               cpu = 1, time =     4.117382526, sequence = 3003, prev_pid = 0, next_pid = 2872, 
> execution            cpu = 1, time =     4.117384668, sequence = 3004, pid = 2872, 
> switch               cpu = 1, time =     4.117397292, sequence = 3005, prev_pid = 2872, next_pid = 0, 
> wakeup               cpu = 0, time =     4.119145967, sequence = 500, wakeup_pid = 12159, success = 1, 
> switch               cpu = 0, time =     4.119152068, sequence = 501, prev_pid = 0, next_pid = 12159, 
> switch               cpu = 0, time =     4.119161459, sequence = 502, prev_pid = 12159, next_pid = 0, 
> rq_complete          cpu = 1, time =     4.125063131, sequence = 3006, dev = 8388608, what = 25231368, rw = 0,
> 		     errors = 0, sector = 212057636, bytes = 61440, pdu_len = 0, pdu[0] = blob, 
> wakeup               cpu = 1, time =     4.125068423, sequence = 3007, wakeup_pid = 12172, success = 1, 
> switch               cpu = 1, time =     4.125084887, sequence = 3008, prev_pid = 0, next_pid = 12172, 
> 
> You can also pass the same trace files to more powerful analysis tools
> such as zedperl, which is a tool that contains an embedded perl
> interpreter that makes the trace data available to event handler


So it's not performed through a library but with an embedded interpreter.
It could be pain to maintain.


> functions contained in arbitrary user scripts.  The self-describing
> event data here allows the trace fields to be passed directly to the
> script as native param variables.  Here's an example of a typical
> handler function as used in the printall.pl script (which has handlers
> for all known event types, as does countall.pl).  The handler function
> starts with the subsystem name followed by the event name.  The first
> 'my' line defines the parameters that will be passed to the function
> by the scripting engine:
> 
> sub sched::switch {
>     my ($cpu, $secs, $nsecs, $sequence, $prev_pid, $next_pid) = @_;
> 
>     $this = (caller(0)) [3];
>     print_header($this, $cpu, $secs, $nsecs, $sequence);
>     printf("prev_pid=%-5u prev_pid=%-5u\n", $prev_pid, $next_pid);
> }
> 
> The full power of Perl is now at your disposal for processing the
> event data.


And moreover the subsystem::tracepoint done is the way of class::method
is very intuitive.

 
> The trace files from the previous example can be passed instead to
> zedperl and processed using the printall.pl script.  The output in
> this case isn't much prettier, mainly because the script is
> unfinished, but in any case printing is the least interesting thing
> you can do with the data.
> 
> # ./zedperl trace printall.pl
> 
> event                    cpu   timestamp   sequence
> -----                    ---   ---------   --------
> sched::wakeup            1     4.107217716     2991 wake_pid=12172 success=1
> sched::switch            1     4.107237155     2992 prev_pid=0     prev_pid=12172
> block::remap             1     4.115181242     2993 dev=8,6     pid=x rwbs=R  212057636 + 120 <- r.dev=(x,x) r.sector=x
> block::bio_queue         1     4.115183032     2994 dev=0,0     pid=x rwbs=R  sector+size=212057636 + 120 []
> block::getrq             1     4.115190306     2995 dev=0,0     pid=x rwbs=R  sector+size=212057636 + 120 []
> block::plug              1     4.115194683     2996 dev=0,0     pid=x rwbs=N  []
> block::rq_insert         1     4.115198413     2997 dev=8,0     pid=x rwbs=R  sector+size=212057636 + 120 []
> block::unplug_io         1     4.115204344     2998 dev=0,0     pid=x rwbs=N  [] 99
> block::rq_issue          1     4.115211814     2999 dev=8,0     pid=x rwbs=R  sector+size=212057636 + 120 []
> sched::switch            1     4.115240756     3000 prev_pid=12172 prev_pid=0    
> sched::switch            1     4.117371692     3001 pid=2872  wq_cpu=0
> sched::wakeup            1     4.117378249     3002 wake_pid=2872  success=1
> sched::switch            1     4.117382526     3003 prev_pid=0     prev_pid=2872 
> sched::switch            1     4.117384668     3004 pid=2872  wq_cpu=0
> sched::switch            1     4.117397292     3005 prev_pid=2872  prev_pid=0    
> sched::wakeup            0     4.119145967      500 wake_pid=12159 success=1
> sched::switch            0     4.119152068      501 prev_pid=0     prev_pid=12159
> sched::switch            0     4.119161459      502 prev_pid=12159 prev_pid=0    
> block::rq_complete       1     4.125063131     3006 dev=8,0     pid=x rwbs=R  sector+size=212057636 + 120 [0]
> sched::wakeup            1     4.125068423     3007 wake_pid=12172 success=1
> sched::switch            1     4.125084887     3008 prev_pid=0     prev_pid=12172
> 
> zedtrace can also be used in a pipeline with zedperl or zedprint to do
> 'live tracing', where the output doesn't go to per-cpu files on disk
> but instead the per-cpu data coming from the kernel is combined in
> real-time and processed by the scripted handlers as it comes in.
> Running the following results in the printed event data being
> displayed on the console as it comes in:
> 
> # ./zedtrace sched block workqueue -o - | ./zedperl -i - printall.pl
> 
> NOTE: known bug/todo: sometimes get broken pipes when starting, try a
> couple more times if that happens.
> 
> Of course, if printing were the only thing you could do, it wouldn't
> be too interesting.  Since you now have the power of a full-fledged
> language at your disposal, you can do literally anything the language
> allows with the trace data coming in.  The countall.pl script isn't
> too interesting either, but it does start to show the potential of the
> kinds of things you can do.  Here's the same handler as above but in
> the context of the countall script:
> 
> sub sched::switch {
>     my ($cpu, $secs, $nsecs, $sequence, $prev_pid, $next_pid) = @_;
> 
>     $this = (caller(0)) [3];
>     $counts{$this}++;
> }
> 
> Invoking the following will simply count each event as it comes in
> (counts are hashed by handler name) and on Ctrl-C will dump out the
> counts contained in the hash.  The trace_begin() and trace_end()
> functions are special-purpose functions that are invoked, if present,
> at the beginning end of the trace - here the trace_end() function
> dumps out the results:
> 
> # ./zedtrace sched block workqueue -o - | ./zedperl -i - countall.pl
> zedperl started with Perl script countall.pl
> ^Cevent counts:
>   block::unplug_timer: 5
>   block::bio_backmerge: 46
>   block::remap: 89
>   block::rq_insert: 411
>   block::unplug_io: 5
>   sched::wakeup_new: 65
>   block::rq_issue: 411
>   sched::migrate_task: 172
>   sched::process_exit: 65
>   sched::wakeup: 7844
>   block::bio_queue: 89
>   block::getrq: 411
>   sched::process_wait: 145
>   sched::signal_send: 79
>   block::rq_complete: 89
>   sched::process_free: 65
>   block::plug: 383
>   workqueue::execution: 1850
>   sched::switch: 13226
>   workqueue::insertion: 1850
>   sched::process_fork: 65
> 
> The same thing can be accomplished without the pipeline as such:
> 
> # ./zedtrace sched block workqueue
> % ./zedperl trace countall.pl
> 
> A slightly more interesting example is the workqueue-stats.pl script,
> which basically replicates the kernel's ftrace-based workqueue tracer.
> The workqueue-stats script is very small and simple but it shows the
> power of being able to use a real language for either live- or
> post-processed tracing - it uses an array of nested hashes to
> accomplish its results, which is something beyond even DTrace's
> capabilities.
> 
> # ./zedtrace workqueue -o - | ./zedperl -i - workqueue-stats.pl
> 
> or
> 
> # ./zedtrace workqueue
> # ./zedperl trace workqueue-stats.pl
> 
> zedperl started with Perl script workqueue-stats.pl
> workqueue counts:
> cpu    ins   exec    pid
>   0      4      6   2872
>   0     90     90     10
>   1    867    864   2872
>   1     91     91     11
>   1      3      3     73
>   1    630    630   1184
>   1     90     90   5516
> 
> Because zedtrace userspace code is based on libutt, which is a
> generalized version of the powerful blktrace userspace code, it also
> inherits from it the ability to trace over the network e.g. on the
> server side:
> 
> root@bookworm:/home/trz/zedtrace# ./zedtrace -l
> server: waiting for connections...
> server: connection from 127.0.0.1
> server: end of run for trace
> Channel: trace
>   CPU  0:                    0 events,       18 KiB data
>   CPU  1:                    0 events,       39 KiB data
>   Total:                     0 events (dropped 0),       57 KiB data
> 
> And on the client side:
> 
> root@bookworm:/home/trz/zedtrace# ./zedtrace -h localhost sched
> zed: connecting to localhost
> zed: connected!
> ^CChannel: trace
>   CPU  0:                    0 events,       18 KiB data
>   CPU  1:                    0 events,       39 KiB data
>   Total:                     0 events (dropped 0),       57 KiB data
> 
> This produces a directory on the server with a name made up of the
> client's IP address and timestamp, e.g. 127.0.0.1-2009-02-27-04:36:06,
> that contains the trace files.  These can be processed using the same
> tools as on a local system.
> 
> TODO: need to save event descriptions in remote directory, for now you
> have to manually copy them over.
> 
> Finally, because even the most efficient tracing system can become
> overwhelmed at times by large volumes of trace data, zedtrace provides
> a generic filtering capability in the kernel.  To make use of it,
> you'll need to know a little about the internals of how event
> descriptions are represented in the debugfs filesystem.  All of the
> event descriptions are arranged by subsystem, as defined in the event
> definitions in the kernel, and live under
> /sys/kernel/debug/zed/trace/events:
> 
> # ls -al /sys/kernel/debug/zed/trace/events
> total 0
> drwxr-xr-x 6 root root 0 2009-02-25 15:55 .
> drwxr-xr-x 3 root root 0 2009-02-25 22:38 ..
> ---------- 1 root root 0 2009-02-25 15:55 all
> drwxr-xr-x 2 root root 0 2009-02-25 15:55 block
> drwxr-xr-x 2 root root 0 2009-02-25 15:55 power
> drwxr-xr-x 2 root root 0 2009-02-25 15:55 sched
> drwxr-xr-x 2 root root 0 2009-02-25 15:55 workqueue
> 
> TODO: for now, some of the code assumes the /sys/kernel/debug path,
> need to remove that restriction.
> 
> Contained within each 'subsystem' directory is a list of all the
> events available for that subsystem along with an 'all' file e.g. for
> the 'sched' subsystem, here's what you should see:
> 
> # ls -al /sys/kernel/debug/zed/trace/events/sched
> total 0
> drwxr-xr-x 2 root root 0 2009-02-25 15:55 .
> drwxr-xr-x 6 root root 0 2009-02-25 15:55 ..
> ---------- 1 root root 0 2009-02-25 22:37 all
> ---------- 1 root root 0 2009-02-25 15:55 kthread_stop_ret_trace
> ---------- 1 root root 0 2009-02-25 15:55 kthread_stop_trace
> ---------- 1 root root 0 2009-02-25 15:55 migrate_task_trace
> ---------- 1 root root 0 2009-02-25 15:55 process_exit_trace
> ---------- 1 root root 0 2009-02-25 15:55 process_fork_trace
> ---------- 1 root root 0 2009-02-25 15:55 process_free_trace
> ---------- 1 root root 0 2009-02-25 15:55 process_wait_trace
> ---------- 1 root root 0 2009-02-25 15:55 signal_send_trace
> ---------- 1 root root 0 2009-02-25 15:55 switch_trace
> ---------- 1 root root 0 2009-02-25 15:55 wait_task_trace
> ---------- 1 root root 0 2009-02-25 15:55 wakeup_new_trace
> ---------- 1 root root 0 2009-02-25 15:55 wakeup_trace
> 
> To enable or disable all events for a subsystem, you write 0 or 1 to
> the 'all' file.  To enable or disable a particular event, you write 0
> or 1 to the relevant event file:
> 
> # echo 1 > /sys/kernel/debug/zed/trace/events/all
> # echo 0 > /sys/kernel/debug/zed/trace/events/signal_send_trace
> 
> If you cat an event description file, you'll see a bunch of
> information about the event's fields and state:
> 
> ~# cat /sys/kernel/debug/zed/trace/events/sched/switch_trace
> switch_trace    5       40      disabled
>         magic   u32     0       4
>         id      u16     4       2
>         cpu     u32     8       4
>         time    timestamp       16      8
>         sequence        u32     24      4
>         prev_pid        pid_t   28      4
>         next_pid        pid_t   32      4
> filters:
>         none
> 
> At the end of each event description, there's a filter: section, which
> displays the state of any filtering set for that event.  Any field in
> the event can be filtered on using statements containing '==' or '!='.
> There may be up to 8 such statement for an event and they can be
> combined using 'and' or 'or'.  Only events that pass the compound
> statement are passed to userspace; failing events are simply
> discarded.  As with enabling/disabling, echoing the statements to the
> 'all' file will cause the filter to be applied to all events in the
> subsystem, and echoing to an individual event will affect only that
> event.  To clear the filter on an event, simply disable the event.
> The statement below will allow only block events on cpu1 and for
> device 8388608 through:
> 
> # echo "cpu == 1" > /sys/kernel/debug/zed/trace/events/block/all
> # echo "and dev != 8388608" > /sys/kernel/debug/zed/trace/events/block/all
> # cat /sys/kernel/debug/zed/trace/events/block/bio_backmerge_trace
> 
> Note that the syntax is exact, unforgiving, and not particularly
> user-friendly - it's meant mainly to be used internally by the tracing
> tools similarly to how zedtrace handles event enable/disable i.e. the
> user never knows of their existence but through a nicer interface
> exposed by the tool.
> 
> bio_backmerge_trace     19      64      disabled
>         magic   u32     0       4
>         id      u16     4       2
>         cpu     u32     8       4
>         time    timestamp       16      8
>         sequence        u32     24      4
>         dev     dev_t   28      4
>         what    u32     32      4
>         rw      int     36      4
>         errors  int     40      4
>         sector  sector_t        48      8
>         bytes   int     56      4
> filters:
>         cpu == 1
>         and dev != 8388608
> 
> It's a blunt instrument for filtering, but is meant to be
> coarse-grained - finer grained filtering is basically what the rest of
> the infrastructure is there for. ;-)
> 
> 


Great work.
 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

