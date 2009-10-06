Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZJFGKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZJFGKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZJFGKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:10:41 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:61798 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZJFGKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=th+5KjK6MLVaQ9T0wA9vGNRQP5nAHB8fzKHUYiHO3AmieRzFTEZGPXjlu9v7RVTG0q
         hNcvqBmmDbX3/z5eBnNdMW/UTh4nCCu+Y5N29qioq1TwZ0krzgcuR51zpn7VcpXxhaYb
         6pvYxl2l2tNRaIu3wyjJ2yqQ+i0TnE9/DI+Z8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 0/9] perf trace: support for general-purpose scripting
Date: Tue,  6 Oct 2009 01:09:49 -0500
Message-Id: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset defines a generic interface for processing the binary
output of 'perf trace' and making it directly available to
user-defined scripts written in general-purpose scripting languages
such as Perl or Python.  It also builds a general-purpose Perl
scripting trace processor on top of the new interface and provides a
few example scripts that exercise the basic functionality.

The main motivation behind it is to provide a more efficient and
powerful alternative to the popular method of parsing the ascii trace
output in order to extract useful information from it.  To avoid the
overhead and complexity of all that, this patchset provides a
direct-to-script-interpreter pathway for doing the same thing, but in
a more regularized fashion, one that takes advantage of all the event
meta-info provided by the tracing infrustructure, such as the
event/field info contained in the 'format files' designed for that
purpose.

Anyone who still wants to deal with the trace stream as straight ascii
text can still have the scripts generate it (and in fact the interface
provides a way to have event printing code auto-generated.  Also, the
original ascii output mode is preserved when the scripting options
aren't used), but for anyone wanting to do something more interesting
with the data using a rapid prototyping language such as Perl, this
patchset makes it easy to do so.  It allows the full power of
general-purpose scripting languages to be applied to the trace stream
to do non-trivial analyses, and suddenly makes available huge
libraries of useful tools and modules (e.g. CPAN for Perl) to be
applied to the problem of creating new and interesting trace
applications.

This patchset only implements a Perl interface, but the intention is
to make it relatively easy to add support for other languages such as
Python, Ruby, etc, etc - all they need to do is follow the example of
the Perl implementation and provide their own implementations of the
trace_scripting_operations (more details below).

It's loosely based on the 'zedtrace' tracer I posted awhile back and
still has some rough edges, but it should be useful enough to try out
and get something useful out of.

Known problems/shortcomings:

Probably the biggest problem right now is the sorting hack I added as
the last patch.  It's just meant as a temporary thing, but is there
because tracing scripts in general want to see events in the order
they happened i.e. timestamp order.  Considering that all this would
probably be much more useful if the script handling could happen in
essentially real time i.e. in 'live-mode', some work probably needs to
be done to create a sort that can work on small batches of events, as
they come in (and making sure no older ones can sneak in after a batch
has been processed).

For the Perl implemention I decided not to pass all of the available
event fields to the script handlers, only the ones that I thought
would be commonly used.  So for example, common_flags and
common_preempt_count aren't passed.  The idea would be that these
unpassed fields should still be available to the event handler, but
via a library function available to the script.  This would also be
true for any other metadata it might be useful to give scripts access
to.  It should be easy to do, but I'll have to do some more looking
into the Perl->C interface.

Even with some of the simple examples provided here, its apparent that
the recording code needs to be able to specify that some filtering be
done in the kernel.  Maybe have a higher-level command that invokes
both 'perf record', passing it filters defined in a 'perf trace'
script and piping the binary output to 'perf trace' instead of writing
it to a file.

Anyway, here are some simple examples to get started...

First, you should build and install perf after installing the perl
development library, libperl (e.g. apt-get install liberl-dev in
ubuntu).

Having done that, you can run 'perf record' with a set of tracepoint
events you're interested in e.g.:

root@tropicana:~# perf record -c 1 -f -a -R -e kmem:kmalloc -e kmem:kfree  -e irq:softirq_entry -e irq:softirq_exit -e sched:sched_switch
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.485 MB perf.data (~21198 samples) ]

Next, you can use the -p -g options of perf trace to have it generate
a script with one handler function for each event in the trace:

root@tropicana:~# perf trace -p -g

The name of the generated script will be 'perf-trace.pl':

root@tropicana:~# ls -al *.pl
-rw-r--r-- 1 root root 2904 2009-10-04 20:24 perf-trace.pl

Here's a portion of the Perl code generated for this trace, to give
some idea of what a trace script looks like:

# perf trace event handlers, generated by perf trace -p -g

# The common_* event handler fields are the most useful fields common to
# all events.  They don't necessarily correspond to the 'common_*' fields
# in the status files.  Those fields not available as handler params can
# be retrieved via script functions of the form get_common_*().

use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
use lib "./Perf-Trace-Util/lib";
use Perf::Trace::Core;
use Perf::Trace::Util;

sub trace_begin
{
    # optional
}

sub trace_end
{
    # optional
}

sub irq::softirq_entry
{
    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
        $common_comm, $vec) = @_;

    print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
        $common_pid, $common_comm);

    printf("vec=%s\n", symbol_str("irq::softirq_entry", "vec", $vec));
}

sub kmem::kfree
{
    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
        $common_comm, $call_site, $ptr) = @_;

    print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
        $common_pid, $common_comm);

    printf("call_site=%u, ptr=%u\n", $call_site, $ptr);
}

sub kmem::kmalloc
{
    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
        $common_comm,
        $call_site, $ptr, $bytes_req, $bytes_alloc, $gfp_flags) = @_;

    print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
        $common_pid, $common_comm);

    printf("call_site=%u, ptr=%u, bytes_req=%u, bytes_alloc=%u, gfp_flags=%s\n",
        $call_site, $ptr, $bytes_req, $bytes_alloc,
        flag_str("kmem::kmalloc", "gfp_flags", $gfp_flags));
}
.
.
.

For each event in the trace, the generated event handlers will print
the event name along with all the fields for the event.  To have the
script do that, run perf trace with the -p -s options:

root@tropicana:~# perf trace -p -s perf-trace.pl

The output should look something like this:

kmem::kmalloc            1 04751.387886420     7249 perf                 call_site=18446744071579906539, ptr=18446612133245372416, bytes_req=640, bytes_alloc=1024, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 04751.387947149     7249 perf                 call_site=18446744071579905993, ptr=18446612134690881536, bytes_req=1112, bytes_alloc=2048, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
irq::softirq_entry       0 04751.388019731        0 swapper              vec=TIMER
irq::softirq_exit        0 04751.388025089        0 swapper              vec=TIMER
sched::sched_switch      1 04751.422756873     7249 perf                 prev_comm=perf, prev_pid=7249, prev_prio=120, prev_state=R, next_comm=apache2, next_pid=5659, next_prio=120
sched::sched_switch      1 04751.422783231     5659 apache2              prev_comm=apache2, prev_pid=5659, prev_prio=120, prev_state=S, next_comm=perf, next_pid=7249, next_prio=120
.
.
.

Notice the gfp_flags and vec fields in the previous trace snippet.
Not only does the generated script display the normal string and
numeric fields, but it also automatically figures out that certain
fields, though numeric, should be interpreted as flags or symbols
instead, and generates the code to do that (using the flag and
symbolic enumerations defined in the event's format file).

Running the autogenerated script and displaying the printed events is
only marginally useful; at the least it can be used to see what's
there and verify that things basically work.

One of the other things that might be marginally useful might be to
remove all the handlers from the generated script and replace it with
a single handler for the 'unhandled_trace' event which is available to
every script.  Here's a complete script for doing that:

# perf trace event handlers, generated by perf trace -p -g

# The common_* event handler fields are the most useful fields common to
# all events.  They don't necessarily correspond to the 'common_*' fields
# in the status files.  Those fields not available as handler params can
# be retrieved via script functions of the form get_common_*().

use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
use lib "./Perf-Trace-Util/lib";
use Perf::Trace::Core;
use Perf::Trace::Util;

my %unhandled;

sub trace_end
{
    print_unhandled();
}

sub trace_unhandled
{
    my ($event_name, $common_cpu, $common_secs, $common_nsecs, $common_pid,
	$common_comm) = @_;

    $unhandled{$event_name}++;
}

sub print_unhandled
{
    if ((scalar keys %unhandled) == 0) {
	return;
    }

    print "\nunhandled events:\n\n";

    printf("%-40s  %10s\n", "event", "count");
    printf("%-40s  %10s\n", "----------------------------------------",
	   "-----------");

    foreach my $event_name (keys %unhandled) {
	printf("%-40s  %10d\n", $event_name, $unhandled{$event_name});
    }
}

For every unhandled event (every event for this script, since we
removed all the real handlers), the total counts for each are hashed
by event name and printed out at the end of the trace (in the
'trace_end' handler, which can also be defined for each script.
Here's some example output for this script:

root@tropicana:~# perf trace -p -s perf-trace-unhandled.pl
perf trace started with Perl script perf-trace.pl


unhandled events:

event                                          count
----------------------------------------  -----------
kmem::kfree                                      927
irq::softirq_entry                               288
kmem::kmalloc                                    929
sched::sched_switch                              222
irq::softirq_exit                                288

perf trace Perl script stopped

The main point of being able to script the trace stream, however, is
to use the power of the scripting language to do more useful analyses.
One simple example would be to display the total r/w activity for all
processes on the system:

root@tropicana:~# perf record -c 1 -f -a -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write
^C[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 8.540 MB perf.data (~373127 samples) ]

root@tropicana:~# perf trace -p -s libexec/perf-core/scripts/perl/rw-by-pid.pl
perf trace started with Perl script libexec/perf-core/scripts/perl/rw-by-pid.pl

read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
  8565  perf                        1886     1928288     1683584
  5520  Xorg                          54        1296        1296
  6242  gvfsd-trash                    2        4096         194
  6637  wterm                          7       28672          64
  6225  gnome-screensav                8       32768          64
  6202  nautilus                       5       16384          48
  6169  gnome-settings-                3       12288          32
  6200  gnome-panel                    1        4096            

failed reads by pid:

   pid                  comm  error #    # errors
------  --------------------  ------  ----------
  6202  nautilus                 -11           4
  6169  gnome-settings-          -11           2
  6200  gnome-panel              -11           1
  6637  wterm                    -11           5
  8565  perf                       0         144
  6225  gnome-screensav          -11           6
  6242  gvfsd-trash              -11           1

write counts by pid:

   pid                  comm    # writes  bytes_written            
------  --------------------  -----------  ----------            
  8565  perf                      122604    20204544
  6242  gvfsd-trash                    2          93
  8566  gvfsd-trash                    1          35
  6637  wterm                          1           1

failed writes by pid:

   pid                  comm  error #    # errors
------  --------------------  ------  ----------

perf trace Perl script stopped

The above output shows sorted tables of reads and write activity, and
also tracks counts of each different read/write return error seen by
each process.

We can use the results of a higher-level trace analysis like the one
above to create other scripts that drill down to get more detailed
output.  For example, the above results show that perf itself was
responsible for a lot of reading and writing.  To see more detail
about which files it's reading from/writing to, we can write and run
another script:

root@tropicana:~# perf trace -p -s libexec/perf-core/scripts/perl/rw-by-file.pl
perf trace started with Perl script libexec/perf-core/scripts/perl/rw-by-file.pl

file read counts for perf:

    fd     # reads  bytes_requested
------  ----------  -----------
    19        1883     1928192
     3          22       90112
    30           2        4096
    13           2        4096
    12          54        1296
    16           1          32
    17           1          32
    15           1          32

file write counts for perf:

    fd    # writes  bytes_written
------  ----------  -----------
     3      122604    20204544
     1           3         128
     4           1           1

unhandled events:

event                                          count
----------------------------------------  -----------
syscalls::sys_exit_read                         1965
syscalls::sys_exit_write                      122608

perf trace Perl script stopped

>From the above, we see that most of the reads are coming from fd 19
and most of the writes are going to fd 3.  At this point, we don't
have any further information about what those files actually are - to
do that we'd need to be able to get it from either the open() system
call tracepoint (preferably, but the filename isn't yet available from
that source) or from reading /proc during the trace.

Actually, we probably don't really event want to see the events from
perf itself, so should also have a way to filter out anything from
perf in the kernel, another todo item.

Another simple example could be to use a script to track wakeup
latencies:

root@tropicana:~# perf record -c 1 -f -a -R -e sched:sched_switch -e sched:sched_wakeup
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.375 MB perf.data (~16379 samples) ]

root@tropicana:~# perf trace -p -s libexec/perf-core/scripts/perl/wakeup-latency.pl

perf trace started with Perl script libexec/perf-core/scripts/perl/wakeup-latency.pl

wakeup_latency stats:

total_wakeups: 323
avg_wakeup_latency (ns): 12844
min_wakeup_latency (ns): 2229
max_wakeup_latency (ns): 360072

perf trace Perl script stopped

This script tracks the time differences between sched_wakeup and
sched_switch events and prints out the totals when the script is done.

One of the nice things about using trace data to do this kind of
analysis is that the individual trace records can be displayed at any
time, so for instance if one was interested in seeing exactly which
events caused the min an max latencies displayed in the output, the
individual events could be viewed by simply uncommenting the
auto-generated print statements.

See the wakeup-latency.pl script for details.

Finally, here's another example that displays workqueue stats for a
trace run:

root@tropicana:~# perf record -c 1 -f -a -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.312 MB perf.data (~13631 samples) ]

root@tropicana:~# perf trace -p -s libexec/perf-core/scripts/perl/workqueue-stats.pl
perf trace started with Perl script libexec/perf-core/scripts/perl/workqueue-stats.pl

workqueue work stats:

cpu    ins   exec       name                
---    ---   ----       ----                
  0     99     99       kondemand/0         
  0     33     33       events/0            
  0     10     10       ata/0               
  1     30     30       kblockd/1           
  1    102    102       ata/1               
  1     35     35       events/1            

workqueue lifecycle stats:

cpu created destroyed   name                
--- ------- ---------   ----                

perf trace Perl script stopped

See the workqueue-stats.pl script for details.


Adding support for a new language
---------------------------------

It should be relatively easy to add support for a new language,
especially if the language implementation supports an interface
allowing an interpreter to be 'embedded' inside another program (in
this case the containing program will be 'perf trace') and have
user-defined script-level functions invoked with the parameters
associated with an event.  The event and field type information
exported by the event tracing infrastructure (via the event 'format'
files) should be enough to parse and send any piece of trace data to
the user script.  The easiest way to see how this can be done would be
to look at the Perl implementation contained in
perf/util/trace-event-perl.c/.h.

The minimum that needs to be done do add support for a new language is
to implement the trace_scripting_operations interface:

    start_script()
    stop_script()
    process_event()
    generate_event_handlers()

start_script() is called before any events are processed, and is meant
to give the scripting language support an opportunity to set things up
to receive events e.g. create and initialize an instance of a language
interpreter.

stop_script() is called after all events are processed, and is meant
to give the scripting language support an opportunity to clean up
e.g. destroy the interpreter instance, etc.

process_event() is called once for each event and takes as its main
parameter a pointer to the binary trace event record to be processed.
The implementation is responsible for picking out the binary fields
from the event record and sending them to the script handler function
associated with that event e.g. a function derived from the event name
it's meant to handle e.g. 'sched::sched_switch()'.  It's probably not
as much work as you'd think to parse the binary data and map it into a
form usable by a given scripting language - on the 'perf trace' side
you have extensive information about the field data types and on the
scripting language side you probably only have a few data types to
worry about, since dynamically typed languages are typically pretty
loose about typing e.g. for the Perl implementation, only 3
type-related interpreter functions were used, one each for signed,
unsigned, and string variables.

generate_event_handlers() should generate a ready-to-run script for
the current set of events in the trace, preferably with bodies that
print out every fields for every event.  Again, look at the Perl
implementation for clues as to how that can be done.  This is an
optional, but very useful op.

There are a couple of other things that aren't covered by the
trace_scripting_operations because different implementations might
want to do things differently, but that should be implemented anyway.
One of these is support for 'flag' and 'symbolic' fields e.g. being
able to use more human-readable values such as 'GFP_KERNEL' or
HI/BLOCK_IOPOLL/TASKLET in place of raw flag values.  See the Perl
implementation to see how this might be done.  Again, it shouldn't be
too painful if you can follow that example.

The final thing would be to provide a library of functions that script
writers could call to get trace meta-information or unpassed fields,
but even the Perl implementation hasn't gotten to that yet, so there's
nothing to look at there...

Thanks,

Tom


Tom Zanussi (9):
  tracing/events: Add 'signed' field to format files
  perf trace: Add subsystem string to struct event
  perf trace: Add string/dynamic cases to format_flags
  perf trace: Add trace scripting ops
  perf trace: Add Perl scripting support
  perf trace: Add scripting op for generating empty event handling
    scripts
  perf trace: Add FIELD_IS_FLAG/SYMBOLIC cases to format_flags
  perf trace: Add perf trace scripting support modules for Perl
  perf trace: Add throwaway timestamp sorting

 include/trace/ftrace.h                             |   15 +-
 kernel/trace/ring_buffer.c                         |   15 +-
 kernel/trace/trace_events.c                        |   24 +-
 kernel/trace/trace_export.c                        |   25 +-
 kernel/trace/trace_syscalls.c                      |   20 +-
 tools/perf/Makefile                                |   25 +
 tools/perf/builtin-trace.c                         |  610 +++++++++++++++++++-
 tools/perf/scripts/perl/Perf-Trace-Util/Changes    |    6 +
 tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST   |    6 +
 .../perf/scripts/perl/Perf-Trace-Util/Makefile.PL  |   12 +
 tools/perf/scripts/perl/Perf-Trace-Util/README     |   30 +
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |  165 ++++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   97 +++
 .../perl/Perf-Trace-Util/t/Perf-Trace-Util.t       |   15 +
 tools/perf/scripts/perl/rw-by-file.pl              |   95 +++
 tools/perf/scripts/perl/rw-by-pid.pl               |  151 +++++
 tools/perf/scripts/perl/wakeup-latency.pl          |   94 +++
 tools/perf/scripts/perl/workqueue-stats.pl         |  121 ++++
 tools/perf/util/trace-event-parse.c                |   87 +++-
 tools/perf/util/trace-event-perl.c                 |  514 +++++++++++++++++
 tools/perf/util/trace-event-perl.h                 |   37 ++
 tools/perf/util/trace-event.h                      |   23 +-
 22 files changed, 2135 insertions(+), 52 deletions(-)
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Changes
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/MANIFEST
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/README
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/t/Perf-Trace-Util.t
 create mode 100644 tools/perf/scripts/perl/rw-by-file.pl
 create mode 100644 tools/perf/scripts/perl/rw-by-pid.pl
 create mode 100644 tools/perf/scripts/perl/wakeup-latency.pl
 create mode 100644 tools/perf/scripts/perl/workqueue-stats.pl
 create mode 100644 tools/perf/util/trace-event-perl.c
 create mode 100644 tools/perf/util/trace-event-perl.h

