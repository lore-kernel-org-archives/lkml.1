Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYBHVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYBHVpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYBHVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:45:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYBHVpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:45:36 -0500
Date: Fri, 8 Feb 2008 22:45:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] latency tracer
Message-ID: <20080208214522.GA31101@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latency tracer tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Find the shortlog below.

This is the latency tracer from -rt, split up and much cleaned up by 
Steve Rostedt, Arnaldo Carvalho and myself. The main motivation of this 
tracer is to be utilized by high-level user tools such as LatencyTOP, to 
analyze system behavior and to enable users to give feedback to kernel 
developers.

It has been in -rt for years and was found to be very useful there, and 
in the last month it has been posted to lkml by Steve about 10 times. 
[This final version is simpler and cleaner than the last lkml version 
(v10) - lets start simple. ]

It does include one very interesting new feature that deserves to be 
mentioned outside of the shortlog: 'dynamic ftrace' - which is a 
transparent kernel-image-patcher mechanism that lazily patches out 
mcount callsites from all functions that get executed. [if tracing is 
disabled] These patched out callsites are remembered, and are patched 
back in when tracing is enabled.

This technique does not just accelelerate the "tracing disabled" case 
enormously, we were in fact unable to measure _any_ performance 
difference (within noise) between an mcount-enabled dyn-ftrace [but 
tracing-disabled] and a vanilla kernel (!), on modern CPUs.

There is still the cost of the +5 byte function size that mcount causes, 
and the resulting +~1% kernel text size increase, but the overhead was 
not measurable in micro or macro benchmarks that we tried. (probably 
because there are no branches added to the hot paths and the only 
overhead is the NOP that is inserted into the prologue of the function - 
which modern CPUs will just eat up as if it didnt exist.)

All in one, i think this is one of the most promising developments in 
terms of Linux kernel instrumentation that happened in the past few 
years:

- it gives us full, very meaningful instrumentation (there are 
  70,000+ function calls in an allyesconfig kernel)

- the instrumentation sites can be flexibly selected and there's no 
  measurable performance overhead (that we could measure)

- there's near zero "collateral" maintenance overhead to other 
  subsystems (!)

- the technique [of mcount based tracing] has been tested in -rt for 
  years so we know the impact pretty well.

- the mcount call sites [on exported functions] can be used by
  SystemTap to do low-overhead patching as well and to access the
  function parameters in a predictable way. [as long as the parameter 
  signature of the function does not change.]

And no, i'm not biased at all ;-)

there are 6 tracers available with this pull:

  # cat /debug/tracing/available_tracers
  wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none

these are the well-known and popular tracer variants from -rt. (But i'd 
expect more tracers to show up - the design is extensible.)

the patch does change generic include files too, so i made a test-build 
on ppc64 as well (besides the usual x86 grind), and it built fine. No 
architectures are supposed to (or expected to) break.

( This tree also includes the RCU enhancements for NO_HZ - Steve's box 
  was locking up under PREEMPT_RCU without this. These bits have been 
  under testing for months too. )

Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      ftrace: add basic support for gcc profiler instrumentation
      ftrace: annotate core code that should not be traced

Ingo Molnar (3):
      sched: add latency tracer callbacks to the scheduler
      ftrace: output formatting
      ftrace: dyn overflow debug

Steven Rostedt (19):
      rcu: add support for dynamic ticks and preempt rcu
      printk: dont wake up klogd with the rq locked
      ftrace: add preempt_enable/disable notrace macros
      x86: add notrace annotations to vsyscall.
      ftrace: latency tracer infrastructure
      ftrace: function tracer
      ftrace: make the task state char-string visible to all
      ftrace: add tracing of context switches
      ftrace: tracer for scheduler wakeup latency
      ftrace: trace irq disabled critical timings
      ftrace: trace preempt off critical timings
      ftrace: have ftrace use its ret as the dummy function
      ftrace: remove ftrace_enabled variable
      ftrace: add notrace annotations for NMI routines
      ftrace: dynamic enabling/disabling of function calls
      ftrace: add ftrace_enabled sysctl to disable mcount function
      ftrace: calculate instruction instead of storing it
      ftrace: use an atomic counter for sorting
      ftrace: make "none" the default tracer

 Makefile                          |    3 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/kernel/Makefile          |    1 +
 arch/x86/kernel/entry_32.S        |   27 +
 arch/x86/kernel/entry_64.S        |   37 +
 arch/x86/kernel/ftrace.c          |  237 ++++++
 arch/x86/kernel/nmi_32.c          |    3 +-
 arch/x86/kernel/nmi_64.c          |    6 +-
 arch/x86/kernel/process_32.c      |    3 +
 arch/x86/kernel/process_64.c      |    3 +
 arch/x86/kernel/traps_32.c        |   12 +-
 arch/x86/kernel/traps_64.c        |   11 +-
 arch/x86/kernel/vsyscall_64.c     |    3 +-
 arch/x86/lib/Makefile             |    1 +
 arch/x86/lib/thunk_32.S           |   47 ++
 arch/x86/lib/thunk_64.S           |   19 +-
 arch/x86/vdso/vclock_gettime.c    |   15 +-
 arch/x86/vdso/vgetcpu.c           |    3 +-
 include/asm-x86/irqflags.h        |   24 +-
 include/asm-x86/vsyscall.h        |    3 +-
 include/linux/ftrace.h            |   92 +++
 include/linux/hardirq.h           |   10 +
 include/linux/irqflags.h          |   13 +-
 include/linux/linkage.h           |    8 +
 include/linux/preempt.h           |   34 +-
 include/linux/rcuclassic.h        |    3 +
 include/linux/rcupreempt.h        |   22 +
 include/linux/sched.h             |   30 +
 kernel/Makefile                   |    2 +
 kernel/fork.c                     |    2 +-
 kernel/lockdep.c                  |   23 +-
 kernel/printk.c                   |   16 +-
 kernel/rcupreempt.c               |  224 ++++++-
 kernel/sched.c                    |   47 ++-
 kernel/softirq.c                  |    1 +
 kernel/sysctl.c                   |   11 +
 kernel/time/tick-sched.c          |    3 +
 kernel/trace/Kconfig              |  111 +++
 kernel/trace/Makefile             |   10 +
 kernel/trace/ftrace.c             |  521 +++++++++++++
 kernel/trace/trace.c              | 1547 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h              |  185 +++++
 kernel/trace/trace_functions.c    |   73 ++
 kernel/trace/trace_irqsoff.c      |  505 ++++++++++++
 kernel/trace/trace_sched_switch.c |  125 +++
 kernel/trace/trace_sched_wakeup.c |  310 ++++++++
 lib/Kconfig.debug                 |    2 +
 lib/smp_processor_id.c            |    2 +-
 48 files changed, 4324 insertions(+), 67 deletions(-)
 create mode 100644 arch/x86/kernel/ftrace.c
 create mode 100644 arch/x86/lib/thunk_32.S
 create mode 100644 include/linux/ftrace.h
 create mode 100644 kernel/trace/Kconfig
 create mode 100644 kernel/trace/Makefile
 create mode 100644 kernel/trace/ftrace.c
 create mode 100644 kernel/trace/trace.c
 create mode 100644 kernel/trace/trace.h
 create mode 100644 kernel/trace/trace_functions.c
 create mode 100644 kernel/trace/trace_irqsoff.c
 create mode 100644 kernel/trace/trace_sched_switch.c
 create mode 100644 kernel/trace/trace_sched_wakeup.c

