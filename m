Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZIUNld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZIUNld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZIUNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:41:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZIUNl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:41:29 -0400
Date: Mon, 21 Sep 2009 15:41:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC] [GIT PULL] "Performance Counters" -> "Performance Events"
	rename
Message-ID: <20090921134111.GA25578@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the following tree (which is relative to the 
perfcounters-fixes-for-linus pull request i just sent) that renames 
"performance counters" to "performance events":

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-rename-for-linus

We waited with this until the end of the merge window, to let all 
pending perfcounters and architecture patches drain. (The rename commit 
also includes a script that helps pending changes to be converted as 
well, should there be any changes we dont know about yet.)

We tried to shape it carefully, so that users are not impacted: the 
CONFIG_PERF_COUNTERS Kconfig settings (and defaults) survive from old 
.config's and influence the CONFIG_PERF_EVENTS default setting, the ABI 
is not changed, and we kept source code API compatibility wrappers in 
place as well.

This time in the kernel cycle is pretty much the only moment when such 
big renames can be done - if you agree with it.

I've cross-built the resulting tree to most non-x86 architectures as 
well, and it passes various tests on x86.

As for why we'd like to do it, here's the explanation from the commit 
log:

<...>

In the past few months the perfcounters subsystem has grown out its
initial role of counting hardware events, and has become (and is
becoming) a much broader generic event enumeration, reporting, logging,
monitoring, analysis facility.

Naming its core object 'perf_counter' and naming the subsystem
'perfcounters' has become more and more of a misnomer. With pending
code like hw-breakpoints support the 'counter' name is less and
less appropriate.

All in one, we've decided to rename the subsystem to 'performance
events' and to propagate this rename through all fields, variables
and API names. (in an ABI compatible fashion)

The word 'event' is also a bit shorter than 'counter' - which makes
it slightly more convenient to write/handle as well.

Thanks goes to Stephane Eranian who first observed this misnomer and
suggested a rename.

User-space tooling and ABI compatibility is not affected - this patch
should be function-invariant. (Also, defconfigs were not touched to
keep the size down.)

This patch has been generated via the following script [plus a few false 
positive were omitted manually]:

  FILES=$(find * -type f | grep -vE 'oprofile|[^K]config')

  sed -i \
    -e 's/PERF_EVENT_/PERF_RECORD_/g' \
    -e 's/PERF_COUNTER/PERF_EVENT/g' \
    -e 's/perf_counter/perf_event/g' \
    -e 's/nb_counters/nb_events/g' \
    -e 's/swcounter/swevent/g' \
    -e 's/tpcounter_event/tp_event/g' \
    $FILES

  for N in $(find . -name perf_counter.[ch]); do
    M=$(echo $N | sed 's/perf_counter/perf_event/g')
    mv $N $M
  done

  FILES=$(find . -name perf_event.*)

  sed -i \
    -e 's/COUNTER_MASK/REG_MASK/g' \
    -e 's/COUNTER/EVENT/g' \
    -e 's/\<event\>/event_id/g' \
    -e 's/counter/event/g' \
    -e 's/Counter/Event/g' \
    $FILES

... to keep it as correct as possible. This script can also be
used by anyone who has pending perfcounters patches - it converts
a Linux kernel tree over to the new naming. We tried to time this
change to the point in time where the amount of pending patches
is the smallest: the end of the merge window.

Namespace clashes were fixed up in a preparatory patch - and some
stylistic fallout will be fixed up in a subsequent patch.

( NOTE: 'counters' are still the proper terminology when we deal
  with hardware registers - and these sed scripts are a bit
  over-eager in renaming them. I've undone some of that, but
  in case there's something left where 'counter' would be
  better than 'event' we can undo that on an individual basis
  instead of touching an otherwise nicely automated patch. )
<...>

 Thanks,

	Ingo

------------------>
Ingo Molnar (4):
      perf_counter: Rename list_entry -> group_entry, counter_list -> group_list
      perf_counter: Rename 'event' to event_id/hw_event
      perf: Do the big rename: Performance Counters -> Performance Events
      perf: Tidy up after the big rename


 MAINTAINERS                                        |    2 +-
 arch/arm/include/asm/unistd.h                      |    2 +-
 arch/arm/kernel/calls.S                            |    2 +-
 arch/blackfin/include/asm/unistd.h                 |    2 +-
 arch/blackfin/mach-common/entry.S                  |    2 +-
 arch/frv/Kconfig                                   |    2 +-
 .../include/asm/{perf_counter.h => perf_event.h}   |   10 +-
 arch/frv/include/asm/unistd.h                      |    2 +-
 arch/frv/kernel/entry.S                            |    2 +-
 arch/frv/lib/Makefile                              |    2 +-
 arch/frv/lib/{perf_counter.c => perf_event.c}      |    8 +-
 arch/m68k/include/asm/unistd.h                     |    2 +-
 arch/m68k/kernel/entry.S                           |    2 +-
 arch/m68knommu/kernel/syscalltable.S               |    2 +-
 arch/microblaze/include/asm/unistd.h               |    2 +-
 arch/microblaze/kernel/syscall_table.S             |    2 +-
 arch/mips/include/asm/unistd.h                     |    6 +-
 arch/mips/kernel/scall32-o32.S                     |    2 +-
 arch/mips/kernel/scall64-64.S                      |    2 +-
 arch/mips/kernel/scall64-n32.S                     |    2 +-
 arch/mips/kernel/scall64-o32.S                     |    2 +-
 arch/mn10300/include/asm/unistd.h                  |    2 +-
 arch/mn10300/kernel/entry.S                        |    2 +-
 arch/parisc/Kconfig                                |    2 +-
 arch/parisc/include/asm/perf_counter.h             |    7 -
 arch/parisc/include/asm/perf_event.h               |    7 +
 arch/parisc/include/asm/unistd.h                   |    4 +-
 arch/parisc/kernel/syscall_table.S                 |    2 +-
 arch/powerpc/Kconfig                               |    2 +-
 arch/powerpc/include/asm/hw_irq.h                  |   22 +-
 arch/powerpc/include/asm/paca.h                    |    2 +-
 .../include/asm/{perf_counter.h => perf_event.h}   |   26 +-
 arch/powerpc/include/asm/systbl.h                  |    2 +-
 arch/powerpc/include/asm/unistd.h                  |    2 +-
 arch/powerpc/kernel/Makefile                       |    2 +-
 arch/powerpc/kernel/asm-offsets.c                  |    2 +-
 arch/powerpc/kernel/entry_64.S                     |    8 +-
 arch/powerpc/kernel/irq.c                          |    8 +-
 arch/powerpc/kernel/mpc7450-pmu.c                  |    2 +-
 arch/powerpc/kernel/perf_callchain.c               |    2 +-
 .../kernel/{perf_counter.c => perf_event.c}        |  582 +++---
 arch/powerpc/kernel/power4-pmu.c                   |    2 +-
 arch/powerpc/kernel/power5+-pmu.c                  |    2 +-
 arch/powerpc/kernel/power5-pmu.c                   |    2 +-
 arch/powerpc/kernel/power6-pmu.c                   |    2 +-
 arch/powerpc/kernel/power7-pmu.c                   |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c                   |    2 +-
 arch/powerpc/kernel/time.c                         |   30 +-
 arch/powerpc/mm/fault.c                            |    8 +-
 arch/powerpc/platforms/Kconfig.cputype             |    4 +-
 arch/s390/Kconfig                                  |    2 +-
 arch/s390/include/asm/perf_counter.h               |   10 -
 arch/s390/include/asm/perf_event.h                 |   10 +
 arch/s390/include/asm/unistd.h                     |    2 +-
 arch/s390/kernel/compat_wrapper.S                  |    8 +-
 arch/s390/kernel/syscalls.S                        |    2 +-
 arch/s390/mm/fault.c                               |    8 +-
 arch/sh/Kconfig                                    |    2 +-
 arch/sh/include/asm/perf_counter.h                 |    9 -
 arch/sh/include/asm/perf_event.h                   |    9 +
 arch/sh/include/asm/unistd_32.h                    |    2 +-
 arch/sh/include/asm/unistd_64.h                    |    2 +-
 arch/sh/kernel/syscalls_32.S                       |    2 +-
 arch/sh/kernel/syscalls_64.S                       |    2 +-
 arch/sh/mm/fault_32.c                              |    8 +-
 arch/sh/mm/tlbflush_64.c                           |    8 +-
 arch/sparc/Kconfig                                 |    4 +-
 arch/sparc/include/asm/perf_counter.h              |   14 -
 arch/sparc/include/asm/perf_event.h                |   14 +
 arch/sparc/include/asm/unistd.h                    |    2 +-
 arch/sparc/kernel/Makefile                         |    2 +-
 arch/sparc/kernel/nmi.c                            |    4 +-
 arch/sparc/kernel/pcr.c                            |   10 +-
 arch/sparc/kernel/{perf_counter.c => perf_event.c} |  178 +-
 arch/sparc/kernel/systbls_32.S                     |    2 +-
 arch/sparc/kernel/systbls_64.S                     |    4 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/ia32/ia32entry.S                          |    2 +-
 arch/x86/include/asm/entry_arch.h                  |    2 +-
 .../include/asm/{perf_counter.h => perf_event.h}   |   30 +-
 arch/x86/include/asm/unistd_32.h                   |    2 +-
 arch/x86/include/asm/unistd_64.h                   |    4 +-
 arch/x86/kernel/apic/apic.c                        |    6 +-
 arch/x86/kernel/cpu/Makefile                       |    2 +-
 arch/x86/kernel/cpu/common.c                       |    4 +-
 .../kernel/cpu/{perf_counter.c => perf_event.c}    |  556 +++---
 arch/x86/kernel/cpu/perfctr-watchdog.c             |    2 +-
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/irqinit.c                          |    2 +-
 arch/x86/kernel/syscall_table_32.S                 |    2 +-
 arch/x86/mm/fault.c                                |    8 +-
 arch/x86/oprofile/op_model_ppro.c                  |    4 +-
 arch/x86/oprofile/op_x86_model.h                   |    2 +-
 drivers/char/sysrq.c                               |    4 +-
 fs/exec.c                                          |    6 +-
 include/asm-generic/unistd.h                       |    4 +-
 include/linux/init_task.h                          |   14 +-
 include/linux/perf_counter.h                       |  497 +----
 include/linux/perf_event.h                         |  858 +++++++
 include/linux/prctl.h                              |    4 +-
 include/linux/sched.h                              |   12 +-
 include/linux/syscalls.h                           |    6 +-
 include/trace/ftrace.h                             |   10 +-
 init/Kconfig                                       |   45 +-
 kernel/Makefile                                    |    2 +-
 kernel/exit.c                                      |    8 +-
 kernel/fork.c                                      |    8 +-
 kernel/{perf_counter.c => perf_event.c}            | 2449 ++++++++++----------
 kernel/sched.c                                     |   14 +-
 kernel/sys.c                                       |   10 +-
 kernel/sys_ni.c                                    |    2 +-
 kernel/sysctl.c                                    |   22 +-
 kernel/timer.c                                     |    4 +-
 kernel/trace/trace_syscalls.c                      |    6 +-
 mm/mmap.c                                          |    6 +-
 mm/mprotect.c                                      |    4 +-
 tools/perf/Makefile                                |    2 +-
 tools/perf/builtin-annotate.c                      |   28 +-
 tools/perf/builtin-record.c                        |   22 +-
 tools/perf/builtin-report.c                        |   48 +-
 tools/perf/builtin-sched.c                         |   20 +-
 tools/perf/builtin-stat.c                          |   10 +-
 tools/perf/builtin-timechart.c                     |   14 +-
 tools/perf/builtin-top.c                           |   12 +-
 tools/perf/builtin-trace.c                         |   22 +-
 tools/perf/design.txt                              |   58 +-
 tools/perf/perf.h                                  |   12 +-
 tools/perf/util/event.h                            |    4 +-
 tools/perf/util/header.c                           |    6 +-
 tools/perf/util/header.h                           |    8 +-
 tools/perf/util/parse-events.c                     |   32 +-
 tools/perf/util/parse-events.h                     |    2 +-
 tools/perf/util/trace-event-info.c                 |    8 +-
 tools/perf/util/trace-event.h                      |    2 +-
 134 files changed, 3258 insertions(+), 2801 deletions(-)
 rename arch/frv/include/asm/{perf_counter.h => perf_event.h} (69%)
 rename arch/frv/lib/{perf_counter.c => perf_event.c} (72%)
 delete mode 100644 arch/parisc/include/asm/perf_counter.h
 create mode 100644 arch/parisc/include/asm/perf_event.h
 rename arch/powerpc/include/asm/{perf_counter.h => perf_event.h} (84%)
 rename arch/powerpc/kernel/{perf_counter.c => perf_event.c} (60%)
 delete mode 100644 arch/s390/include/asm/perf_counter.h
 create mode 100644 arch/s390/include/asm/perf_event.h
 delete mode 100644 arch/sh/include/asm/perf_counter.h
 create mode 100644 arch/sh/include/asm/perf_event.h
 delete mode 100644 arch/sparc/include/asm/perf_counter.h
 create mode 100644 arch/sparc/include/asm/perf_event.h
 rename arch/sparc/kernel/{perf_counter.c => perf_event.c} (68%)
 rename arch/x86/include/asm/{perf_counter.h => perf_event.h} (76%)
 rename arch/x86/kernel/cpu/{perf_counter.c => perf_event.c} (75%)
 create mode 100644 include/linux/perf_event.h
 rename kernel/{perf_counter.c => perf_event.c} (52%)

 [ diff omitted due to lkml size limits. ]
