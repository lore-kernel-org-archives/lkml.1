Return-Path: <linux-kernel-owner+w=401wt.eu-S934558AbZKYHP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558AbZKYHP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934293AbZKYHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:15:56 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35501 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbZKYHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GFpI0utjj4z8Z+ylcKO9FK6IwC0dFLtF2axCx0TBWZL6syOLN8XeZClfcCxOWpvyjM
         UkJGdOCl2sZsII8VBvY6YWTXoO+ZB1kcAcFDcGLLs6qkqEgiBbOp+47WhmSZIS/wwHnD
         opgk4xjGs7RKqJ8CCvNmwhyQo2AoLlBBwHu5o=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [RFC][PATCH 0/7] perf trace: general-purpose scripting support, v2
Date: Wed, 25 Nov 2009 01:15:45 -0600
Message-Id: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a belated update to v1 of the trace stream scripting support
patches I posted last month; I had meant to get this out sooner but
got too busy with other things...

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
trace_scripting_ops and supporting functions (more details below).

Changes from v1:

- uses the -M (multiplex) option of perf record instead of the sorting
  hack in v1 to order events.

- makes the command-line option for specifying scripts (-s) more
  flexible and scalable to the addition of other scripting languages.

- adds a Perl->C interface to provide scripts a way to access event
  data not included in event handlers; this, along with a related
  context param now passed to handlers, could also be used to access
  metadata in the parent perf executable.

- for usability, adds centralized documentation and some simple shell
  scripts to avoid having to remember long command lines.

- upgrades the licensing of the Perl modules to GPL

Installation:

For the Perl scripting support to work, you first need to install the
Perl development library, libperl (e.g. apt-get install liberl-dev in
ubuntu), then make and install perf.

Known problems:

None with the code itself, AFAIK, but I do see some strange results in
some scripts when using the perf timestamps.  For example, the
wakeup-latency.pl script, if run for a long enough time, will show
output like the following:

root@tropicana:~# wakeup-latency-record
^C[ perf record: Woken up 76 times to write data ]
[ perf record: Captured and wrote 10.831 MB perf.data (~473227 samples) ]

root@tropicana:~# wakeup-latency-report
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/wakeup-

wakeup_latency stats:

total_wakeups: 458359
avg_wakeup_latency (ns): 27974
min_wakeup_latency (ns): 18446744073709546323
max_wakeup_latency (ns): 55234235

perf trace Perl script stopped

Obviously, something is wrong with the min_wakeup_latency stat.  To
dig a little further, I added some printing code, which I conveniently
took from the code generated by the new perf trace -g option:

root@tropicana:~# perf trace -g perl
generated Perl script: perf-trace.pl

I copied the generated print() and print_header() code from
perf-trace.pl for the sched_switch() and sched_wakeup() handler
functions and added a line to print the $min_wakeup_latency value
whenever it changes (I've attached the diff from wakeup-latency.pl
below).

After doing that and re-running the wakeup-latency script, I got the
below output, which is the snippet surrounding a negative latency (see
min_wakeup_latency: -5293).

Looking at the two events preceding it, you can see that the
sched_switch has an earlier timestamp than the sched_wakeup event that
preceded it:

sched::sched_wakeup      1 01238.657172818     6186 firefox              comm=firefox, pid=7140, prio=120, success=1, target_cpu=1
sched::sched_switch      1 01238.657197514     6186 firefox              prev_comm=firefox, prev_pid=6186, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=7140, next_prio=120
sched::sched_switch      0 01238.657881346     4555 kondemand/0          prev_comm=kondemand/0, prev_pid=4555, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6183, next_prio=120

sched::sched_wakeup      0 01238.657997033     6183 firefox              comm=firefox, pid=6199, prio=120, success=1, target_cpu=1
sched::sched_switch      1 01238.657991740     7140 firefox              prev_comm=firefox, prev_pid=7140, prev_prio=120, prev_state=S, next_comm=firefox, next_pid=6199, next_prio=120

min_wakeup_latency: -5293

sched::sched_wakeup      0 01238.658063038     6183 firefox              comm=Xorg, pid=5536, prio=140, success=1, target_cpu=0
sched::sched_wakeup      0 01238.658232707     6183 firefox              comm=npviewer.bin, pid=6998, prio=120, success=1, target_cpu=1
sched::sched_switch      1 01238.658311152     6199 firefox              prev_comm=firefox, prev_pid=6199, prev_prio=120, prev_state=S, next_comm=npviewer.bin, next_pid=6998, next_prio=120
sched::sched_switch      0 01238.658397358     6183 firefox              prev_comm=firefox, prev_pid=6183, prev_prio=120, prev_state=S, next_comm=Xorg, next_pid=5536, next_prio=140
sched::sched_wakeup      0 01238.658460734     5536 Xorg                 comm=firefox, pid=6183, prio=120, success=1, target_cpu=0
sched::sched_switch      1 01238.658311152     6998 npviewer.bin         prev_comm=npviewer.bin, prev_pid=6998, prev_prio=120, prev_state=S, next_comm=swapper, next_pid=0, next_prio=140
sched::sched_switch      0 01238.664043515     5536 Xorg                 prev_comm=Xorg, prev_pid=5536, prev_prio=140, prev_state=R, next_comm=firefox, next_pid=6183, next_prio=120
sched::sched_switch      0 01238.664059065     6183 firefox              prev_comm=firefox, prev_pid=6183, prev_prio=120, prev_state=S, next_comm=Xorg, next_pid=5536, next_prio=140
sched::sched_wakeup      0 01238.665301440     5536 Xorg                 comm=metacity, pid=5924, prio=140, success=1, target_cpu=1
sched::sched_switch      1 01238.665313262        0 init                 prev_comm=swapper, prev_pid=0, prev_prio=140, prev_state=R, next_comm=metacity, next_pid=5924, next_prio=140
sched::sched_wakeup      0 01238.665314341     5536 Xorg                 comm=gnome-settings-, pid=5923, prio=140, success=1, target_cpu=0
sched::sched_switch      0 01238.665320692     5536 Xorg                 prev_comm=Xorg, prev_pid=5536, prev_prio=140, prev_state=R, next_comm=gnome-settings-, next_pid=5923, next_prio=140

So the event ordering seems right, but the timestamps don't.  To get
some idea what might be happening, I added a couple of printks to
perf_event_output(), one at the beginning and one at the end and
recorded perf_clock() at those points (since the actual event
timestamping happens somewhere in between).

Whenever the negative latency happens in the script, the perf_clock()
values on the sched_switch cpu seem to get stuck for awhile during
that time.  Below is the output from cpu1 - note the timestamp of the
event (01238.657991740), which matches the timestamp at both the
beginning and end of perf_event_output().

The values for cpu0 around that time are also shown for completeness.

cpu1:

perf_event_output begin: ts 1238657171430 cpu 1
perf_event_output   end: ts 1238657173618 cpu 1
perf_event_output begin: ts 1238657196431 cpu 1
perf_event_output   end: ts 1238657198193 cpu 1

perf_event_output begin: ts 1238657991740 cpu 1
perf_event_output   end: ts 1238657991740 cpu 1

perf_event_output begin: ts 1238658311152 cpu 1
perf_event_output   end: ts 1238658311152 cpu 1
perf_event_output begin: ts 1238658311152 cpu 1
perf_event_output   end: ts 1238658311152 cpu 1
perf_event_output begin: ts 1238665312062 cpu 1
perf_event_output   end: ts 1238665314481 cpu 1
perf_event_output begin: ts 1238665414056 cpu 1

cpu0:

perf_event_output   end: ts 1238656044814 cpu 0
perf_event_output begin: ts 1238657879958 cpu 0
perf_event_output   end: ts 1238657882306 cpu 0
perf_event_output begin: ts 1238657995453 cpu 0
perf_event_output   end: ts 1238657997881 cpu 0
perf_event_output begin: ts 1238658061886 cpu 0
perf_event_output   end: ts 1238658064203 cpu 0
perf_event_output begin: ts 1238658231296 cpu 0
perf_event_output   end: ts 1238658233676 cpu 0
perf_event_output begin: ts 1238658395923 cpu 0

So anyway, it looks like what happens is that clock0 gets stuck at
time t0, event 1 happens on the normally advancing clock1 at time t1 >
t0, event 2 happens after event 1 but because t0 is stuck at t0, gets
time t0 < t1 and thus the negative result.

I haven't investigated any further at this point, except to put in a
few more printks that show it is using the tsc, and to note that you
only get out-of-order timestamps between cpus, though you do get
0-difference timestamps between events on the same cpu, which amounts
to the same thing - I'm hoping someone else might have a better idea
about what's happening and how to fix it, as it obviously limits the
value of the timetamps for analysis.

Other than that things seem to work pretty well.  The rest of this
e-mail provides a short introduction to help get you started writing
scripts; as always please see the code for details.  There's also
perf-trace-perl Documentation included with this patchset, which might
also be helpful.  All of the scripts described below can be found in
~/libexec/perf-core/scripts/perl after you install perf.

The first step in a normal trace session is to run 'perf record' with
a set of tracepoint events you're interested in e.g.:

root@tropicana:~# perf record -c 1 -f -a -M -R -e kmem:kmalloc -e kmem:kfree  -e irq:softirq_entry -e irq:softirq_exit -e sched:sched_switch
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.485 MB perf.data (~21198 samples) ]

Next, you can use the -g perl option of perf trace to have it generate
a script with one handler function for each event in the trace:

root@tropicana:~# perf trace -g perl

The name of the generated script will be 'perf-trace.pl':

root@tropicana:~# perf trace -g perl
generated Perl script: perf-trace.pl

Here's a portion of the Perl code generated for this trace, to give
some idea of what a trace script looks like:

# perf trace event handlers, generated by perf trace -g perl
# Licensed under the terms of the GNU GPL License version 2

# The common_* event handler fields are the most useful fields common to
# all events.  They don't necessarily correspond to the 'common_*' fields
# in the format files.  Those fields not available as handler params can
# be retrieved using Perl functions of the form common_*($context).
# See Context.pm for the list of available functions.

use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
use lib "./Perf-Trace-Util/lib";
use Perf::Trace::Core;
use Perf::Trace::Context;
use Perf::Trace::Util;

sub trace_begin
{
	# optional
}

sub trace_end
{
	# optional
}

sub sched::sched_switch
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm,
	    $prev_comm, $prev_pid, $prev_prio, $prev_state, 
	    $next_comm, $next_pid, $next_prio) = @_;

	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
	             $common_pid, $common_comm);

	printf("prev_comm=%s, prev_pid=%d, prev_prio=%d, prev_state=%s, ".
	       "next_comm=%s, next_pid=%d, next_prio=%d\n",
	       $prev_comm, $prev_pid, $prev_prio, 
	       flag_str("sched::sched_switch", "prev_state", $prev_state), 
	       $next_comm, $next_pid, $next_prio);
}

sub irq::softirq_exit
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm,
	    $vec) = @_;

	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
	             $common_pid, $common_comm);

	printf("vec=%s\n",
	       symbol_str("irq::softirq_exit", "vec", $vec));
}

sub irq::softirq_entry
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm,
	    $vec) = @_;

	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
	             $common_pid, $common_comm);

	printf("vec=%s\n",
	       symbol_str("irq::softirq_entry", "vec", $vec));
}

sub kmem::kfree
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm,
	    $call_site, $ptr) = @_;

	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
	             $common_pid, $common_comm);

	printf("call_site=%u, ptr=%u\n",
	       $call_site, $ptr);
}

sub kmem::kmalloc
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm,
	    $call_site, $ptr, $bytes_req, $bytes_alloc, 
	    $gfp_flags) = @_;

	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
	             $common_pid, $common_comm);

	printf("call_site=%u, ptr=%u, bytes_req=%u, bytes_alloc=%u, ".
	       "gfp_flags=%s\n",
	       $call_site, $ptr, $bytes_req, $bytes_alloc, 
	       
	       flag_str("kmem::kmalloc", "gfp_flags", $gfp_flags));
}
.
.
.

For each event in the trace, the generated event handlers will print
the event name along with all the fields for the event.

To run the script, run perf trace with the -p option:

root@tropicana:~# perf trace -s perf-trace.pl

The output should look something like this:

kmem::kmalloc            1 01041.022132636    11822 perf                 call_site=18446744071579892671, ptr=18446612134886444032, bytes_req=704, bytes_alloc=1024, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 01041.022157859    11822 perf                 call_site=18446744071579892671, ptr=18446612134886455296, bytes_req=704, bytes_alloc=1024, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 01041.022186965    11822 perf                 call_site=18446744071579892671, ptr=18446612134886447104, bytes_req=704, bytes_alloc=1024, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 01041.022219512    11822 perf                 call_site=18446744071579892671, ptr=18446612134886452224, bytes_req=704, bytes_alloc=1024, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 01041.022317930    11822 perf                 call_site=18446744072100923040, ptr=18446612135313073728, bytes_req=64, bytes_alloc=64, gfp_flags=GFP_WAIT | GFP_IO
sched::sched_switch      1 01041.022514835    11822 perf                 prev_comm=perf, prev_pid=11822, prev_prio=140, prev_state=D, next_comm=swapper, next_pid=0, next_prio=140
irq::softirq_entry       0 01041.024022805        0 swapper              vec=TIMER
irq::softirq_exit        0 01041.024029784        0 swapper              vec=TIMER
irq::softirq_entry       0 01041.024031978        0 swapper              vec=SCHED
irq::softirq_exit        0 01041.024035551        0 swapper              vec=SCHED
irq::softirq_entry       1 01041.024538754        0 init                 vec=TIMER
irq::softirq_exit        1 01041.024545467        0 init                 vec=TIMER
irq::softirq_entry       1 01041.025896765        0 init                 vec=BLOCK
irq::softirq_exit        1 01041.025944221        0 init                 vec=BLOCK
sched::sched_switch      1 01041.025958098        0 init                 prev_comm=swapper, prev_pid=0, prev_prio=140, prev_state=R, next_comm=perf, next_pid=11822, next_prio=140
kmem::kmalloc            1 01041.026372194    11822 perf                 call_site=18446744071580383712, ptr=18446612135006028448, bytes_req=32, bytes_alloc=32, gfp_flags=GFP_WAIT | GFP_IO
kmem::kmalloc            1 01041.026376141    11822 perf                 call_site=18446744071580382581, ptr=18446612134887800192, bytes_req=104, bytes_alloc=128, gfp_flags=GFP_WAIT | GFP_IO
kmem::kmalloc            1 01041.026400928    11822 perf                 call_site=18446744071580383440, ptr=18446612134887923712, bytes_req=4096, bytes_alloc=4096, gfp_flags=GFP_WAIT | GFP_IO
kmem::kfree              1 01041.026581992    11822 perf                 call_site=18446744071580379757, ptr=18446612134887923712
kmem::kfree              1 01041.026586236    11822 perf                 call_site=18446744071580379765, ptr=18446612134887800192
kmem::kfree              1 01041.026588755    11822 perf                 call_site=18446744071580379904, ptr=18446612135006028448
kmem::kmalloc            1 01041.026654934    11822 perf                 call_site=18446744071580626944, ptr=18446612135006028448, bytes_req=24, bytes_alloc=32, gfp_flags=GFP_WAIT | GFP_IO | GFP_ZERO
kmem::kmalloc            1 01041.026657946    11822 perf                 call_site=18446744071580382581, ptr=18446612134887800192, bytes_req=104, bytes_alloc=128, gfp_flags=GFP_WAIT | GFP_IO
kmem::kmalloc            1 01041.026672236    11822 perf                 call_site=18446744071580383440, ptr=18446612135312744448, bytes_req=4096, bytes_alloc=4096, gfp_flags=GFP_WAIT | GFP_IO
kmem::kfree              1 01041.026889195    11822 perf                 call_site=18446744071580379823, ptr=18446612135006028448
kmem::kfree              1 01041.026892212    11822 perf                 call_site=18446744071580379757, ptr=18446612135312744448
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

# perf trace event handlers, generated by perf trace -g perl
# Licensed under the terms of the GNU GPL License version 2

# The common_* event handler fields are the most useful fields common to
# all events.  They don't necessarily correspond to the 'common_*' fields
# in the format files.  Those fields not available as handler params can
# be retrieved using Perl functions of the form common_*($context).
# See Context.pm for the list of available functions.

use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
use lib "./Perf-Trace-Util/lib";
use Perf::Trace::Core;
use Perf::Trace::Context;
use Perf::Trace::Util;

my %unhandled;

sub trace_end
{
    print_unhandled();
}

sub trace_unhandled
{
	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
	    $common_pid, $common_comm) = @_;

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

root@tropicana:~# perf trace -s perf-trace.pl
perf trace started with Perl script perf-trace.pl

unhandled events:

event                                          count
----------------------------------------  -----------
kmem::kfree                                      973
irq::softirq_entry                               458
kmem::kmalloc                                    971
sched::sched_switch                              511
irq::softirq_exit                                458

perf trace Perl script stopped

The main point of being able to script the trace stream, however, is
to use the power of the scripting language to do more useful analysis.
One simple example would be to display the total r/w activity for all
processes on the system:

root@tropicana:~# perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write
^C[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 0.748 MB perf.data (~32694 samples) ]

root@tropicana:~# perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/rw-by-pid.pl

read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
 12029  perf                        1087     1106144      917550
  5537  Xorg                          83        1992        1992
 11296  wterm                          7       28672          64
  5973  gnome-screensav                8       32768          64
  5926  gnome-settings-                3       12288          32

failed reads by pid:

   pid                  comm  error #    # errors
------  --------------------  ------  ----------
 12029  perf                       0         111
 11296  wterm                    -11           5
  5926  gnome-settings-          -11           2
  5973  gnome-screensav          -11           6

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  -----------  ----------
 12029  perf                        2187      148952
 11296  wterm                          1           1

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

root@tropicana:~# perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_enter_write
^C[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 33.299 MB perf.data (~1454834 samples) ]

root@tropicana:~# perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/rw-by-file.pl

file read counts for perf:

    fd     # reads  bytes_requested
------  ----------  -----------
     9        1710     1751040
     6           1          32
     7           1          32
     5           1          32

file write counts for perf:

    fd    # writes  bytes_written
------  ----------  -----------
     3      391246    34916416

perf trace Perl script stopped

>From the above, we see that most of the reads are coming from fd 9 and
most of the writes are going to fd 3.  At this point, we don't have
any further information about what those files actually are - to do
that we'd need to be able to get it from either the open() system call
tracepoint (preferably, but the filename isn't yet available from that
source) or from reading /proc during the trace.

Actually, we probably don't really event want to see the events from
perf itself, so should also have a way to filter out anything from
perf in the kernel.

Another simple example could be to use a script to track wakeup
latencies:

root@tropicana:~# perf record -c 1 -f -a -M -R -e sched:sched_switch -e sched:sched_wakeup
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.365 MB perf.data (~15952 samples) ]

root@tropicana:~# perf trace -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/wakeup-latency.

wakeup_latency stats:

total_wakeups: 430
avg_wakeup_latency (ns): 12807
min_wakeup_latency (ns): 2745
max_wakeup_latency (ns): 154435

perf trace Perl script stopped

This script tracks the time differences between sched_wakeup and
sched_switch events and prints out the totals when the script is done.

One of the nice things about using trace data to do this kind of
analysis is that the individual trace records can be displayed at any
time, so for instance if one was interested in seeing exactly which
events caused the min an max latencies displayed in the output, the
individual events could be viewed by simply uncommenting the
auto-generated print statements.

Finally, here's another example that displays workqueue stats for a
trace run:

root@tropicana:~# perf record -c 1 -f -a -M -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.285 MB perf.data (~12470 samples) ]

root@tropicana:~# perf trace -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/workqueue-stats

workqueue work stats:

cpu    ins   exec       name                
---    ---   ----       ----                
  0      4      4       kblockd/0           
  0     62     62       ata/0               
  0     90     91       events/0            
  0     58     58       kondemand/0         
  1     36     36       ata/1               
  1      1      0       events/0            
  1     42     42       events/1            
  1     18     18       kblockd/1           

workqueue lifecycle stats:

cpu created destroyed   name                
--- ------- ---------   ----                

perf trace Perl script stopped

There's also a check-perf-trace.pl script in the
libexec/perf-core/scripts/perl directory that doesn't do anything
interesting but contains code that's meant to exercise all of the
functionality available for the Perl scripting support.  Looking at
that, along with the other example scripts in that directory should
provide a basic starting point for writing scripts of your own.

Note also that the final patch adds a 'bin' directory containing some
shell scripts so you can run the above scripts without typing in the
full command lines.  So, with libexec/perf-core/scripts/perl in your
path, you could for example run the perf record/report commands for
the workqueue-stats script like this:

root@tropicana:~# workqueue-stats-record
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.238 MB perf.data (~10389 samples) ]

root@tropicana:~# workqueue-stats-report
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/workqueue-stats

workqueue work stats:

cpu    ins   exec       name                
---    ---   ----       ----                
  0      2      2       kblockd/0           
  0     14     14       ata/0               
  0      2      2       events/0            
  0      5      5       kondemand/0         
  1      2      2       events/1            

workqueue lifecycle stats:

cpu created destroyed   name                
--- ------- ---------   ----                

perf trace Perl script stopped


Thanks,

Tom

timestamp debugging code:

--- libexec/perf-core/scripts/perl/wakeup-latency.pl~	2009-11-23 19:37:53.000000000 -0600
+++ libexec/perf-core/scripts/perl/wakeup-latency.pl	2009-11-23 19:45:56.000000000 -0600
@@ -32,6 +32,15 @@
 	$prev_comm, $prev_pid, $prev_prio, $prev_state, $next_comm, $next_pid,
 	$next_prio) = @_;
 
+	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
+	             $common_pid, $common_comm);
+
+	printf("prev_comm=%s, prev_pid=%d, prev_prio=%d, prev_state=%s, ".
+	       "next_comm=%s, next_pid=%d, next_prio=%d\n",
+	       $prev_comm, $prev_pid, $prev_prio, 
+	       flag_str("sched::sched_switch", "prev_state", $prev_state), 
+	       $next_comm, $next_pid, $next_prio);
+
     my $wakeup_ts = $last_wakeup{$common_cpu}{ts};
     if ($wakeup_ts) {
 	my $switch_ts = nsecs($common_secs, $common_nsecs);
@@ -41,6 +50,7 @@
 	}
 	if ($wakeup_latency < $min_wakeup_latency) {
 	    $min_wakeup_latency = $wakeup_latency;
+            print("min_wakeup_latency: $min_wakeup_latency\n");
 	}
 	$total_wakeup_latency += $wakeup_latency;
 	$total_wakeups++;
@@ -54,6 +64,14 @@
 	$common_pid, $common_comm,
 	$comm, $pid, $prio, $success, $target_cpu) = @_;
 
+	print_header($event_name, $common_cpu, $common_secs, $common_nsecs,
+	             $common_pid, $common_comm);
+
+	printf("comm=%s, pid=%d, prio=%d, success=%d, ".
+	       "target_cpu=%d\n",
+	       $comm, $pid, $prio, $success, 
+	       $target_cpu);
+
     $last_wakeup{$target_cpu}{ts} = nsecs($common_secs, $common_nsecs);
 }
 
@@ -101,3 +119,11 @@
 
     $unhandled{$event_name}++;
 }
+
+sub print_header
+{
+	my ($event_name, $cpu, $secs, $nsecs, $pid, $comm) = @_;
+
+	printf("%-20s %5u %05u.%09u %8u %-20s ",
+	       $event_name, $cpu, $secs, $nsecs, $pid, $comm);
+}

Tom Zanussi (7):
  perf trace: Add scripting ops
  perf trace: Add flag/symbolic format_flags
  perf trace: Add Perl scripting support
  perf trace: Add perf trace scripting support modules for Perl
  perf trace: Add interface to access perf data from Perl handlers
  perf trace: Add Documentation for perf trace Perl support
  perf trace: Add a scripts/perl/bin for perf trace shell scripts

 tools/perf/Documentation/perf-trace-perl.txt       |  219 +++++++
 tools/perf/Documentation/perf-trace.txt            |   11 +-
 tools/perf/Makefile                                |   26 +-
 tools/perf/builtin-trace.c                         |  250 ++++++++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |  134 +++++
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   41 ++
 .../perf/scripts/perl/Perf-Trace-Util/Makefile.PL  |   17 +
 tools/perf/scripts/perl/Perf-Trace-Util/README     |   59 ++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |   55 ++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |  192 +++++++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   88 +++
 tools/perf/scripts/perl/Perf-Trace-Util/typemap    |    1 +
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +
 .../perf/scripts/perl/bin/check-perf-trace-report  |    5 +
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +
 tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    6 +
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +
 tools/perf/scripts/perl/bin/workqueue-stats-report |    6 +
 tools/perf/scripts/perl/check-perf-trace.pl        |  106 ++++
 tools/perf/scripts/perl/rw-by-file.pl              |  105 ++++
 tools/perf/scripts/perl/rw-by-pid.pl               |  170 ++++++
 tools/perf/scripts/perl/wakeup-latency.pl          |  103 ++++
 tools/perf/scripts/perl/workqueue-stats.pl         |  129 +++++
 tools/perf/util/trace-event-parse.c                |   41 ++-
 tools/perf/util/trace-event-perl.c                 |  596 ++++++++++++++++++++
 tools/perf/util/trace-event-perl.h                 |   51 ++
 tools/perf/util/trace-event.h                      |   23 +
 31 files changed, 2450 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-trace-perl.txt
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Context.c
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Makefile.PL
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/README
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/typemap
 create mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-record
 create mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-file-record
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-file-report
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-pid-record
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-pid-report
 create mode 100644 tools/perf/scripts/perl/bin/wakeup-latency-record
 create mode 100644 tools/perf/scripts/perl/bin/wakeup-latency-report
 create mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-record
 create mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-report
 create mode 100644 tools/perf/scripts/perl/check-perf-trace.pl
 create mode 100644 tools/perf/scripts/perl/rw-by-file.pl
 create mode 100644 tools/perf/scripts/perl/rw-by-pid.pl
 create mode 100644 tools/perf/scripts/perl/wakeup-latency.pl
 create mode 100644 tools/perf/scripts/perl/workqueue-stats.pl
 create mode 100644 tools/perf/util/trace-event-perl.c
 create mode 100644 tools/perf/util/trace-event-perl.h

