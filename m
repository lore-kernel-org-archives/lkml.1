Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZFKQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZFKQDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZFKQDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:03:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZFKQDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:03:44 -0400
Date: Thu, 11 Jun 2009 18:03:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611160329.GA3366@elte.hu>
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

Please consider pulling the performance counters Git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-for-linus

The -v8 version was announced at:

   http://lwn.net/Articles/336542/

[ Changes since -v8: cleanups of the ABI, broader cachemiss-counter
  enumeration support, Power7 arch support, Jato JIT dynamic symbols
  support, improved auto-freq sampling, gentler fall-back in tools
  in case of missing PMU features, and general tidyups. ]

Performance Counters for Linux is a new subsystem that offers 
unified handling and tooling for all things performance analysis: it 
provides an fd based 'counter' abstraction to expose a wide set of 
performance measurement features:

 - The counting of hardware and software events

 - Sampling/tracing of events

 - Various counter-scheduling and workload-measurement features (per
   task, per CPU, per child hierarchy, etc.)

 - Self and remote measurements

 - CPU-independent abstraction/enumeration of hardware and software
   events that tries to distill a more or less uniformly available
   set of events.

Perfcounters are supported on PowerPC and on x86 (sw counters are 
unconditionally supported, hw counters are supported on Intel Core2 
and later, and on most AMD CPUs).

The subsystem also offers the 'perf' tool in tools/perf/, which is 
an integrated collection of subcommands that allow various levels of 
inspection and analysis - form the ten-miles-high statistics to the 
per assembly statistics and to the raw trace itself.

The tooling tries to be friendly, intuitive and very fast - and does 
not try to get in the way of getting work done. Its main focus is on 
measuring/profilig user-space apps, without an artificial separation 
of 'kernel-space' and 'user-space' activities. There's ELF symbol 
and debuginfo/annotation support.

The counter concept got objected to in past discussions on lkml, by 
DaveM and by Stephane Eranian (i've Cc:-ed them) - so this code was 
not eligible for linux-next testing - nevertheless we gave it good 
testing on PowerPC and x86 and i've done a wide cross-build test as 
well to try to make sure it breaks no other architecture.

Any architecture can add support for perfcounters it by hooking up 
the syscall - without any PMU feature - the software events and 
hrtimer based sampling will be available and all the tools will work 
transparently.

I tested its merge interaction with pending trees in linux-next: it 
only conflicted with the scheduler and x86 trees (which trees i 
already sent earlier today), and a trivial conflict with two pending 
cleanup patches in atomic.h. I.e. the interaction is minimal.

CONFIG_PERF_COUNTER is default-disabled.

The tree shows some more frequent merge commits a few months ago - 
later portions were kept clean as the other -tip branches. There's 
one stray looking (and harmless) commit i noticed:

  b09d250: mutex: drop "inline" from mutex_lock() inside kernel/mutex.c

This got there due the atomic_dec_and_mutex_lock() API being first 
used in and originating from perfcounters. That API went upstream in 
the previous merge window already, it was cherry-picked out of the 
perfcounters tree, the upstream commit is:

  b1fca26: mutex: add atomic_dec_and_mutex_lock()

There's also interactions with the irqinit unification which went 
upstream yesterday. (There were so many non-trivial conflicts that i 
pre-merged your current latest tree into this tree and tested the 
result.)

Please pull if you find it acceptable.

 Thanks,

	Ingo

------------------>

Arjan van de Ven (2):
      perf_counter tools: Warning fixes on 32-bit
      perf_counter tools: Initialize a stack variable before use

Arnaldo Carvalho de Melo (26):
      perf record: Allow specifying a pid to record
      perf_counter: First part of 'perf report' conversion to C + elfutils
      perf_counter: Implement dso__load using libelf
      perf_counter: Use rb_trees in perf report
      perf_counter: Add our private copy of list.h
      perf_counter: Use rb_tree for symhists and threads in report
      perf report: Fix kernel symbol resolution
      perf: Don't assume /proc/kallsyms is ordered
      perf report: Sort output by symbol usage
      perf report: Use hex2long instead of sscanf
      perf report: Only load text symbols from kallsyms
      perf report: Show the IP only in --verbose mode
      perf_counter tools: Move symbol resolution classes from report to libperf
      perf_counter tools: struct symbol priv area
      perf_counter tools: Consolidate dso methods to load kernel symbols
      perf_counter tools: Optionally pass a symbol filter to the dso load routines
      perf_counter tools: Convert builtin-top to use libperf symbol routines
      perf_counter tools: Shorten the DSO names using cwd
      perf_counter tools: Add locking to perf top
      perf_counter tools: Add string.[ch]
      perf_counter tools: Use hex2u64 in more places
      perf_counter tools: Add missing rb_erase in dso__delete_symbols
      perf_counter tools: Cover PLT symbols too
      perf_counter tools: Fix off-by-one bug in symbol__new
      perf report: Fix rbtree bug
      perf report: Add -vvv to print the list of threads and its mmaps

Erdem Aktas (1):
      perf_counter tools: fix buffer overwrite problem for perf top command

Eric Paris (1):
      mutex: add atomic_dec_and_mutex_lock()

Frederic Weisbecker (4):
      perf_counter: Sleep before refresh using poll in perf top
      perf_counter tools: Fix warn_unused_result warnings
      perf top: Fix zero or negative refresh delay
      perf top: Wait for a minimal set of events before reading first snapshot

H. Peter Anvin (1):
      mutex: drop "inline" from mutex_lock() inside kernel/mutex.c

Hidetoshi Seto (1):
      x86: smarten /proc/interrupts output for new counters

Ingo Molnar (194):
      performance counters: documentation
      performance counters: x86 support
      x86, perfcounters: read out MSR_CORE_PERF_GLOBAL_STATUS with counters disabled
      perfcounters: select ANON_INODES
      perfcounters, x86: simplify disable/enable of counters
      perfcounters, x86: clean up debug code
      perfcounters: consolidate global-disable codepaths
      perf counters: restructure the API
      perf counters: add support for group counters
      perf counters: group counter, fixes
      perf counters: hw driver API
      perf counters: implement PERF_COUNT_CPU_CLOCK
      perf counters: consolidate hw_perf save/restore APIs
      perf counters: implement PERF_COUNT_TASK_CLOCK
      perf counters: add prctl interface to disable/enable counters
      perf counters: clean up state transitions
      perf counters: update docs
      x86: implement atomic64_t on 32-bit
      perfcounters: restructure x86 counter math
      perfcounters: implement "counter inheritance"
      perfcounters: fix task clock counter
      perfcounters: add context switch counter
      perfcounters: add task migrations counter
      perfcounters: add nr-of-faults counter
      perfcounters: fix non-intel-perfmon CPUs
      perfcounters, x86: fix sw counters on non-PMC CPUs
      perfcounters: fix lapic initialization
      perfcounters: release CPU context when exiting task counters
      perfcounters: flush on setuid exec
      perfcounters: use hw_event.disable flag
      perfcounters: remove warnings
      perfcounters: tweak group scheduling
      x86, perfcounters: rename intel_arch_perfmon.h => perf_counter.h
      x86, perfcounters: prepare for fixed-mode PMCs
      perfcounters: add fixed-mode PMC enumeration
      x86, perfcounters: refactor code for fixed-function PMCs
      perfcounters: hw ops rename
      perfcounters: fix task clock counter
      perfcounters: pull inherited counters
      perfcounters: fix init context lock
      perfcounters: enable lowlevel pmc code to schedule counters
      x86, perfcounters: print out the ->used bitmask
      perfcounters: remove ->nr_inherited
      perfcounters: generalize the counter scheduler
      perfcounters: add PERF_COUNT_BUS_CYCLES
      x86, perfcounters: add support for fixed-function pmcs
      perfcounters: include asm/perf_counter.h only if CONFIG_PERF_COUNTERS=y
      perfcounters: fix "perf counters kills oprofile" bug, v2
      perfcounters: remove duplicate definition of LOCAL_PERF_VECTOR
      perfcounters: fix acpi_idle_do_entry() workaround
      perfcounters: fix reserved bits sizing
      perf_counter: fix crash on perfmon v1 systems
      perf_counter: create Documentation/perf_counter/ and move perfcounters.txt there
      perf_counter: add sample user-space to Documentation/perf_counter/
      perf_counter tools: tidy up in-kernel dependencies
      perf_counter tools: fix build warning in kerneltop.c
      perf_counter tools: increase cpu-cycles again
      x86, perfcounters: add atomic64_xchg()
      perf_counter: fix off task->comm by one
      perf_counter tools: include PID in perf-report output, tweak user/kernel printut
      perf_counter: copy in Git's top Makefile
      perf_counter tools: add in basic glue from Git
      perf_counter tools: clean up after introduction of the Git command framework
      perf_counter tools: separate kerneltop into 'perf top' and 'perf stat'
      perf_counter tools: add help texts
      perf_counter tools: add 'perf record' command
      perf_counter tools: fix --version
      perf_counter tools: add 'perf help'
      perf_counter tools: fix 'make install'
      perfcounters, sched: remove __task_delta_exec()
      perf_counter tools: move helper library to util/*
      perf_counter: add/update copyrights
      perf_counter tools: add perf-report to the Makefile
      perf_counter tools: perf stat: make -l default-on
      perf_counter tools: fix infinite loop in perf-report on zeroed event records
      perf_counter tools: fix x86 syscall numbers
      perf_counter: round-robin per-CPU counters too
      perf_counter: initialize the per-cpu context earlier
      perf_counter: convert perf_resource_mutex to a spinlock
      perf_counter: fix fixed-purpose counter support on v2 Intel-PERFMON
      perf_counter tools: remove debug code from builtin-stat.c
      perf_counter: x86: Fix throttling
      perf_counter: x86: Disallow interval of 1
      perf_counter: x86: Protect against infinite loops in intel_pmu_handle_irq()
      perf_counter: Remove ACPI quirk
      perf stat: handle Ctrl-C
      perf_counter: fix threaded task exit
      perf_counter, x86: fix zero irq_period counters
      perf_counter, x86: speed up the scheduling fast-path
      perf_counter: fix counter freeing logic
      perf_counter: fix counter inheritance race
      perf_counter: Fix context removal deadlock
      perf_counter: fix !PERF_COUNTERS build failure
      perf_counter tools: increase limits
      perf_counter: Increase mmap limit
      perf_counter tools: increase limits, fix
      perf_counter: Move child perfcounter init to after scheduler init
      perf stat: flip around ':k' and ':u' flags
      Revert "perf_counter, x86: speed up the scheduling fast-path"
      perf_counter: fix warning & lockup
      perf_counter, x86: Fix APIC NMI programming
      perf_counter, x86: Make NMI lockups more robust
      perf_counter: Initialize ->oncpu properly
      perf record: Straighten out argv types
      perf stat: Remove unused variable
      perf record: Convert to Git option parsing
      perf_counter tools: Librarize event string parsing
      perf stat: Convert to Git option parsing
      perf top: Convert to Git option parsing
      perf_counter tools: remove the standalone perf-report utility
      perf record: Convert to Git option parsing
      perf report: Add help/manpage
      perf report: add --dump-raw-trace option
      perf report: add counter for unknown events
      perf report: add more debugging
      perf report: Only load text symbols from kallsyms, fix
      perf_counter tools: Introduce stricter C code checking
      perf_counter tools: Rename output.perf to perf.data
      perf_counter tools: Add built-in pager support
      perf report: Remove <ctype.h> include
      pref_counter: tools: report: Add header printout & prettify
      pref_counter: tools: report: Robustify in case of weird events
      perf_counter: Fix perf_counter_init_task() on !CONFIG_PERF_COUNTERS
      perf_counter tools: report: Add help text for --sort
      perf_counter tools: Clean up builtin-stat.c's do_perfstat()
      perf_counter tools: Split display into reading and printing
      perf_counter tools: Also display time-normalized stat results
      perf_counter: Fix cpuctx->task_ctx races
      perf_counter: Robustify counter-free logic
      perf_counter tools: Print 'CPU utilization factor' in builtin-stat
      perf_counter tools: Fix 'make install'
      perf_counter tools: Generate per command manpages (and pdf/html, etc.)
      perf_counter tools: Fix unknown command help text
      perf_counter: Tidy up style details
      perf report: Clean up the default output
      perf report: Fix column width/alignment of dsos
      perf record: Add --append option
      perf record: Increase mmap buffering default
      perf report: Print more info instead of <unknown> entries
      perf_counter tools: Make source code headers more coherent
      perf record: Print out the number of events captured
      perf report: Print -D to stdout
      perf report: Improve sort key recognition
      perf report: Handle vDSO symbols properly
      perf_counter tools: Clean up old kerneltop references
      perf record: Refine capture printout
      perf report: Display 100% correctly
      perf stat: Print out all arguments
      perf report: Add front-entry cache for lookups
      perf help: Fix bug when there's no perf-* command around
      perf_counter tools: Optimize harder
      perf_counter tools: Work around warnings in older GCCs
      perf_counter: Fix throttling lock-up
      perf report: Clean up event processing
      perf report: Split out event processing helpers
      perf report: Handle all known event types
      perf top: Reduce default filter threshold
      perf record/report: Fix PID/COMM handling
      perf_counter tools: Build with native optimization
      perf_counter tools: Print out symbol parsing errors only if --verbose
      perf report: Print out the total number of events
      perf_counter tools: Add color terminal output support
      perf_counter tools: Dont output in color on !tty
      perf report: Bail out if there are unrecognized options/arguments
      perf stat: Update help text
      perf record: Split out counter creation into a helper function
      perf record, top: Implement --freq
      perf report: Display user/kernel differentiator
      perf_counter tools: Clarify events/samples naming
      perf_counter tools: Remove -march=native
      perf_counter tools: Sample and display frequency adjustment changes
      perf record: Set frequency correctly
      perf_counter: Separate out attr->type from attr->config
      perf_counter: Implement generalized cache event types
      perf_counter tools: Fix cache-event printout
      perf_counter tools: Uniform help printouts
      perf_counter tools: Tidy up manpage details
      perf_counter tools: Prepare for 'perf annotate'
      perf_counter tools: Add 'perf annotate' feature
      perf_counter tools: Move from Documentation/perf_counter/ to tools/perf/
      perf_counter tools: Fix error condition in parse_aliases()
      perf annotate: Automatically pick up vmlinux in the local directory
      perf annotate: Fix command line help text
      perf stat: Continue even on counter creation error
      perf top: Fall back to cpu-clock-tick hrtimer sampling if no cycle counter available
      perf record: Fall back to cpu-clock-ticks if no PMU
      perf_counter tools: Handle kernels with !CONFIG_PERF_COUNTER
      perf report: Print more expressive message in case of file open error
      perf stat: Print out instructins/cycle metric
      perf_counter: Clean up x86 boot messages
      perf_counter tools: Standardize color printing
      perf_counter tools: Clean up u64 usage
      perf_counter: Better align code
      perf_counter: Turn off by default

Jaswinder Singh (1):
      x86: perf_counter.c intel_perfmon_event_map and max_intel_perfmon_events should be static

Jaswinder Singh Rajput (7):
      x86: perf_counter remove unwanted hw_perf_enable_all
      x86: irqinit_32.c fix compilation warning
      x86: prepare perf_counter to add more cpus
      x86: AMD Support for perf_counter
      x86: decent declarations in perf_counter.c
      x86: use pr_info in perf_counter.c
      x86: perf_counter cleanup

Luis Henriques (1):
      perf_counter: fix alignment in /proc/interrupts

Mike Galbraith (23):
      perfcounters: throttle on too high IRQ rates
      perfcounters: ratelimit performance counter interrupts
      perfcounters fix section mismatch warning in perf_counter.c::perf_counters_lapic_init()
      perfcounters: fix refcounting bug
      perfcounters: fix "perf counters kill oprofile" bug
      perf_counters: account NMI interrupts
      perfcounters: fix use after free in perf_release()
      perf_counter tools: kerneltop: add real-time data acquisition thread
      perf_counter tools: kerneltop: display per function percentage along with event count
      perf_counter tools: fix build error
      perf_counter, x86: clean up throttling printk
      perf top: fix segfault
      perf top: Reduce display overhead
      perf top: Remove leftover NMI/IRQ bits
      perf top: fix typo in -d option
      perf record: Fix the profiling of existing pid or whole box
      perf_counter tools: Document '--' option parsing terminator
      perf_counter tools: Fix top symbol table dump typo
      perf_counter tools: Fix top symbol table max_ip typo
      perf_counter tools: Guard against record damaging existing files
      perf_counter tools: Make .gitignore reflect perf_counter tools files
      perf_counter tools: Cleanup Makefile
      perf_counter tools: Fix uninitialized variable in perf-report.c

Paul Mackerras (64):
      perf_counter: Fix return value from dummy hw_perf_counter_init
      perf_counter: Fix the cpu_clock software counter
      perf_counter: Add optional hw_perf_group_sched_in arch function
      perf_counter: Add dummy perf_counter_print_debug function
      powerpc/perf_counter: Add perf_counter system call on powerpc
      powerpc: Provide a way to defer perf counter work until interrupts are enabled
      powerpc/perf_counter: Add generic support for POWER-family PMU hardware
      powerpc/perf_counter: Add support for PPC970 family
      powerpc/perf_counter: Add support for POWER6
      perf_counter: Always schedule all software counters in
      powerpc/perf_counter: Make sure PMU gets enabled properly
      perf_counter: Add support for pinned and exclusive counter groups
      perf_counter: Add counter enable/disable ioctls
      perf_counters: make software counters work as per-cpu counters
      perf_counters: allow users to count user, kernel and/or hypervisor events
      perfcounters: fix refcounting bug, take 2
      perfcounters: make context switch and migration software counters work again
      perfcounters/powerpc: Make exclude_kernel bit work on Apple G5 processors
      perfcounters/powerpc: Add support for POWER5 processors
      perfcounters: fix a few minor cleanliness issues
      perfcounters: provide expansion room in the ABI
      perfcounters/powerpc: fix oops with multiple counters in a group
      perfcounters/powerpc: add support for POWER5+ processors
      perfcounters/powerpc: add support for POWER4 processors
      perf_counter: abstract wakeup flag setting in core to fix powerpc build
      perf_counter: powerpc: clean up perc_counter_interrupt
      perf_counter: fix type/event_id layout on big-endian systems
      perf_counter: add an mmap method to allow userspace to read hardware counters
      perf_counter tools: remove glib dependency and fix bugs in kerneltop.c
      perf_counter: update documentation
      perf_counter: record time running and time enabled for each counter
      perf_counter: powerpc: only reserve PMU hardware when we need it
      perf_counter: make it possible for hw_perf_counter_init to return error codes
      perf_counter tools: optionally scale counter values in perfstat mode
      perf_counter: fix powerpc build
      perf_counter: powerpc: set sample enable bit for marked instruction events
      perf_counter: add MAINTAINERS entry
      perf_counter: powerpc: add nmi_enter/nmi_exit calls
      perf_counter: powerpc: allow use of limited-function counters
      perf_counter: update copyright notice
      perf_counter: Put whole group on when enabling group leader
      perf_counter: don't count scheduler ticks as context switches
      perf_counter: call atomic64_set for counter->count
      perf_counter: call hw_perf_save_disable/restore around group_sched_in
      perf_counter: powerpc: use u64 for event codes internally
      perf_counter: allow arch to supply event misc flags and instruction pointer
      perf_counter: powerpc: supply more precise information on counter overflow events
      perf_counter: powerpc: initialize cpuhw pointer before use
      perf_counter: Dynamically allocate tasks' perf_counter_context struct
      perf_counter: Optimize context switch between identical inherited contexts
      perf_counter: powerpc: Implement interrupt throttling
      perf_counter: Fix race in attaching counters to tasks and exiting
      perf_counter: Don't swap contexts containing locked mutex
      perf_counter: Provide functions for locking and pinning the context for a task
      perf_counter: Allow software counters to count while task is not running
      perf_counter: Initialize per-cpu context earlier on cpu up
      perf_counter: Fix cpu migration counter
      perf_counter: Remove unused prev_state field
      perf_counter: powerpc: Fix event alternative code generation on POWER5/5+
      perf_counter: powerpc: Fix race causing "oops trying to read PMC0" errors
      perf_counter: powerpc: Use new identifier names in powerpc-specific code
      perf_counter: Fix lockup with interrupting counters
      perf_counters: powerpc: Add support for POWER7 processors
      perf_counter: powerpc: Implement generalized cache events for POWER processors

Pekka Enberg (1):
      perf report: Add support for profiling JIT generated code

Peter Zijlstra (183):
      perfcounters: IRQ and NMI support on AMD CPUs
      perfcounters: IRQ and NMI support on AMD CPUs, fix
      x86: perf_counter cleanup
      perf_counter: x86: fix 32-bit irq_period assumption
      perf_counter: use list_move_tail()
      perf_counter: add comment to barrier
      perf_counter: x86: use ULL postfix for 64bit constants
      perf_counter: software counter event infrastructure
      perf_counter: provide pagefault software events
      perf_counter: provide major/minor page fault software events
      perf_counter: hrtimer based sampling for software time events
      perf_counter: add an event_list
      perf_counter: fix hrtimer sampling
      perf_counter: fix uninitialized usage of event_list
      perf_counter: generic context switch event
      perf_counter: fix up counter free paths
      perf_counter: hook up the tracepoint events
      perf_counter: revamp syscall input ABI
      perf_counter: unify irq output code
      perf_counter: remove the event config bitfields
      perf_counter: avoid recursion
      perf_counter: new output ABI - part 1
      perf_counter tools: update to new syscall ABI
      perf_counter tools: use mmap() output
      perf_counter tools: remove glib dependency and fix bugs in kerneltop.c, fix poll()
      perf_counter: fix perf_poll()
      perf_counter: more elaborate write API
      perf_counter: output objects
      perf_counter: sanity check on the output API
      perf_counter: optionally provide the pid/tid of the sampled task
      perf_counter: kerneltop: mmap_pages argument
      perf_counter: kerneltop: output event support
      perf_counter: allow and require one-page mmap on counting counters
      perf_counter: unify and fix delayed counter wakeup
      perf_counter: fix update_userpage()
      perf_counter: kerneltop: simplify data_head read
      perf_counter: executable mmap() information
      perf_counter: kerneltop: parse the mmap data stream
      perf_counter: x86: proper error propagation for the x86 hw_perf_counter_init()
      perf_counter: small cleanup of the output routines
      perf_counter: re-arrange the perf_event_type
      perf_counter tools: kerneltop: update event_types
      perf_counter: provide generic callchain bits
      perf_counter: x86: callchain support
      perf_counter: pmc arbitration
      perf_counter: move the event overflow output bits to record_type
      perf_counter: per event wakeups
      perf_counter: kerneltop: update to new ABI
      perf_counter: add more context information
      perf_counter: update mmap() counter read
      perf_counter: update mmap() counter read, take 2
      perf_counter: add more context information
      perf_counter: SIGIO support
      perf_counter: generalize pending infrastructure
      perf_counter: x86: self-IPI for pending work
      perf_counter: theres more to overflow than writing events
      perf_counter: fix the mlock accounting
      perf_counter: PERF_RECORD_TIME
      perf_counter: counter overflow limit
      perf_counter: comment the perf_event_type stuff
      perf_counter: change event definition
      perf_counter: rework context time
      perf_counter: rework the task clock software counter
      perf_counter: remove rq->lock usage
      perf_counter: minimize context time updates
      perf_counter: fix NMI race in task clock
      perf_counter: provide misc bits in the event header
      perf_counter: use misc field to widen type
      perf_counter: kerneltop: keep up with ABI changes
      perf_counter: add some comments
      perf_counter: track task-comm data
      perf_counter: some simple userspace profiling
      perf_counter: move PERF_RECORD_TIME
      perf_counter: allow for data addresses to be recorded
      perf_counter: optimize mmap/comm tracking
      perf_counter: sysctl for system wide perf counters
      perf_counter: log full path names
      perf_counter tools: fix Documentation/perf_counter build error
      perf_counter: fix race in perf_output_*
      perf_counter: fix nmi-watchdog interaction
      perf_counter: tool: handle 0-length data files
      perf_counter: documentation update
      perf_counter: x86: fixup nmi_watchdog vs perf_counter boo-boo
      perf_counter: uncouple data_head updates from wakeups
      perf_counter: add ioctl(PERF_COUNTER_IOC_RESET)
      perf_counter: provide an mlock threshold
      perf_counter: fix the output lock
      perf_counter: inheritable sample counters
      perf_counter: tools: update the tools to support process and inherited counters
      perf_counter: optimize perf_counter_task_tick()
      perf_counter: rework ioctl()s
      perf_counter: add PERF_RECORD_CONFIG
      perf_counter: add PERF_RECORD_CPU
      perf_counter: fix print debug irq disable
      perf_counter: x86: More accurate counter update
      perf_counter: x86: Allow unpriviliged use of NMIs
      perf_counter: Fix perf_output_copy() WARN to account for overflow
      perf_counter: x86: Fix up the amd NMI/INT throttle
      perf_counter: Rework the perf counter disable/enable
      perf_counter: x86: Robustify interrupt handling
      perf_counter: remove perf_disable/enable exports
      perf_counter: per user mlock gift
      perf_counter: frequency based adaptive irq_period
      perf top: update to use the new freq interface
      perf_counter: frequency based adaptive irq_period, 32-bit fix
      perf_counter: Fix inheritance cleanup code
      perf_counter: Fix counter inheritance
      perf_counter: Solve the rotate_ctx vs inherit race differently
      perf_counter: Log irq_period changes
      perf_counter: Optimize disable of time based sw counters
      perf_counter: Optimize sched in/out of counters
      perf_counter: Fix dynamic irq_period logging
      perf_counter: Sanitize counter->mutex
      perf_counter: Sanitize context locking
      perf_counter: Fix userspace build
      perf_counter: Simplify context cleanup
      perf_counter: Change pctrl() behaviour
      perf_counter: Remove perf_counter_context::nr_enabled
      perf_counter: Fix perf-$cmd invokation
      perf_counter: Remove unused ABI bits
      perf_counter: Make pctrl() affect inherited counters too
      perf_counter: Propagate inheritance failures down the fork() path
      perf_counter: Fix PERF_COUNTER_CONTEXT_SWITCHES for cpu counters
      perf_counter: x86: Expose INV and EDGE bits
      perf_counter: x86: Remove interrupt throttle
      perf_counter: Generic per counter interrupt throttle
      perf report: Fix segfault on unknown symbols
      perf report: Fix ELF symbol parsing
      perf report: More robust error handling
      perf_counter: tools: /usr/lib/debug%s.debug support
      perf_counter: tools: report: Add vmlinux support
      perf_counter: tools: report: Rework histogram code
      perf_counter: tools: report: Dynamic sort/print bits
      pref_counter: tools: report: Add --sort option
      perf_counter: tools: report: Add comm sorting
      pref_counter: tools: report: Add dso sorting
      perf_counter tools: report: Implement header output for --sort variants
      perf_counter: Fix COMM and MMAP events for cpu wide counters
      perf_counter: Clean up task_ctx vs interrupts
      perf_counter: Ammend cleanup in fork() fail
      perf_counter: Use PID namespaces properly
      perf_counter: tools: Expand the COMM,MMAP event synthesizer
      perf_counter: tools: Better handle existing data files
      perf_counter tools: Remove the last nmi bits
      x86: Fix atomic_long_xchg() on 64bit
      perf_counter: Add unique counter id
      perf_counter: Rename various fields
      perf_counter: Remove the last nmi/irq bits
      perf_counter: x86: Emulate longer sample periods
      perf_counter: Change data head from u32 to u64
      perf_counter: Add ioctl for changing the sample period/frequency
      perf_counter: Rename perf_counter_hw_event => perf_counter_attr
      perf_counter tools: Fix up the ABI shakeup
      perf report: Separate out idle threads
      perf_counter: Add a comm hook for pure fork()s
      perf record: Use long arg for counter period
      perf report: Fix comm sorting
      perf_counter: Fix race in counter initialization
      perf report: Simplify symbol output
      perf report: Add consistent spacing rules
      perf_counter: Add fork event
      perf_counter: Remove munmap stuff
      perf_counter tools: Use fork and remove munmap events
      x86: Set context.vdso before installing the mapping
      perf_counter: Generate mmap events for install_special_mapping()
      perf report: Deal with maps
      perf_counter: Change PERF_SAMPLE_CONFIG into PERF_SAMPLE_ID
      perf_counter: Add PERF_SAMPLE_PERIOD
      perf_counter: Fix frequency adjustment for < HZ
      perf_counter: Add mmap event hooks to mprotect()
      perf_counter: More aggressive frequency adjustment
      perf_counter tools: Small frequency related fixes
      perf_counter tools: Propagate signals properly
      perf_counter: Annotate exit ctx recursion
      perf_counter tools: Normalize data using per sample period data
      perf_counter: Introduce struct for sample data
      perf_counter: Accurate period data
      perf_counter: More paranoia settings
      perf_counter: Rename perf_counter_limit sysctl
      perf_counter: Rename enums
      perf_counter: Standardize event names
      perf_counter: Rename L2 to LL cache
      perf_counter: Add counter->id to the throttle event

Robert Richter (30):
      perf_counter, x86: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus
      perf_counter, x86: declare perf_max_counters only for CONFIG_PERF_COUNTERS
      perf_counter, x86: add default path to cpu detection
      perf_counter, x86: rework pmc_amd_save_disable_all() and pmc_amd_restore_all()
      perf_counter, x86: protect per-cpu variables with compile barriers only
      perfcounters: rename struct hw_perf_counter_ops into struct pmu
      perf_counter, x86: rename struct pmc_x86_ops into struct x86_pmu
      perf_counter, x86: make interrupt handler model specific
      perf_counter, x86: remove get_status() from struct x86_pmu
      perf_counter, x86: remove ack_status() from struct x86_pmu
      perf_counter, x86: rename __hw_perf_counter_set_period into x86_perf_counter_set_period
      perf_counter, x86: rename intel only functions
      perf_counter, x86: modify initialization of struct x86_pmu
      perf_counter, x86: make x86_pmu data a static struct
      perf_counter, x86: move counter parameters to struct x86_pmu
      perf_counter, x86: make pmu version generic
      perf_counter, x86: make x86_pmu_read() static inline
      perf_counter, x86: rename cpuc->active_mask
      perf_counter, x86: generic use of cpuc->active
      perf_counter, x86: consistent use of type int for counter index
      perf_counter, x86: rework counter enable functions
      perf_counter, x86: rework counter disable functions
      perf_counter, x86: change and remove pmu initialization checks
      perf_counter, x86: implement the interrupt handler for AMD cpus
      perf_counter, x86: return raw count with x86_perf_counter_update()
      perf_counter, x86: introduce max_period variable
      perf_counter, x86: remove vendor check in fixed_mode_idx()
      perf_counter, x86: remove unused function argument in intel_pmu_get_status()
      perf_counter: update 'perf top' documentation
      perf_counter, x86: rename bitmasks to ->used_mask and ->active_mask

Steven Whitehouse (1):
      perfcounters: export perf_tpcounter_event

Thomas Gleixner (15):
      performance counters: core code
      perf counters: protect them against CSTATE transitions
      perf counters: clean up 'raw' type API
      perf counters: expand use of counter->event
      perf_counter tools: remove build generated files
      perfcounter tools: move common defines ... to local header file
      perfcounter tools: make rdclock an inline function
      perfcounter tools: fix pointer mismatch
      perfcounter tools: get the syscall number from arch/*/include/asm/unistd.h
      perf_counter tools: Add 'perf list' to list available events
      perf_counter tools: Add help for perf list
      perf_counter, x86: Implement generalized cache event types, add Core2 support
      perf_counter, x86: Implement generalized cache event types, add Atom support
      perf_counter, x86: Implement generalized cache event types, add AMD support
      perf_counter, x86: Clean up hw_cache_event ids copies

Tim Blechmann (1):
      perf_counter: include missing header

Wu Fengguang (9):
      perf_counter tools: Merge common code into perfcounters.h
      perf_counter tools: Move perfstat supporting code into perfcounters.h
      perf_counter tools: support symbolic event names in kerneltop
      perf_counter tools: Reuse event_name() in kerneltop
      perf_counter tools: move remaining code into kerneltop.c
      perf_counter tools: fix comment for sym_weight()
      perf_counter tools: fix event_id type
      perf_counter tools: cut down default count for cpu-cycles
      perf_counter tools: when no command is feed to perfstat, display help and exit

Yinghai Lu (2):
      perf_counter: more barrier in blank weak function
      x86: make irqinit_32.c more like irqinit_64.c, v2

Yong Wang (6):
      perf_counter/x86: Always use NMI for performance-monitoring interrupt
      perf_counter/x86: Remove the IRQ (non-NMI) handling bits
      perf_counter: Documentation update
      perf_counter tools: Fix incorrect printf formats
      perf_counter, x86: Correct some event and umask values for Intel processors
      perf_counter/x86: Fix the model number of Intel Core2 processors


 MAINTAINERS                                       |   10 +
 arch/powerpc/include/asm/hw_irq.h                 |   39 +
 arch/powerpc/include/asm/paca.h                   |    1 +
 arch/powerpc/include/asm/perf_counter.h           |   98 +
 arch/powerpc/include/asm/reg.h                    |    2 +
 arch/powerpc/include/asm/systbl.h                 |    2 +-
 arch/powerpc/include/asm/unistd.h                 |    1 +
 arch/powerpc/kernel/Makefile                      |    3 +
 arch/powerpc/kernel/asm-offsets.c                 |    1 +
 arch/powerpc/kernel/entry_64.S                    |    9 +
 arch/powerpc/kernel/irq.c                         |    5 +
 arch/powerpc/kernel/perf_counter.c                | 1263 ++++++
 arch/powerpc/kernel/power4-pmu.c                  |  598 +++
 arch/powerpc/kernel/power5+-pmu.c                 |  671 ++++
 arch/powerpc/kernel/power5-pmu.c                  |  611 +++
 arch/powerpc/kernel/power6-pmu.c                  |  532 +++
 arch/powerpc/kernel/power7-pmu.c                  |  357 ++
 arch/powerpc/kernel/ppc970-pmu.c                  |  482 +++
 arch/powerpc/mm/fault.c                           |   10 +-
 arch/powerpc/platforms/Kconfig.cputype            |    1 +
 arch/x86/Kconfig                                  |    1 +
 arch/x86/ia32/ia32entry.S                         |    3 +-
 arch/x86/include/asm/atomic_32.h                  |  236 ++
 arch/x86/include/asm/entry_arch.h                 |    2 +-
 arch/x86/include/asm/hardirq.h                    |    2 +
 arch/x86/include/asm/hw_irq.h                     |    2 +
 arch/x86/include/asm/intel_arch_perfmon.h         |   31 -
 arch/x86/include/asm/irq_vectors.h                |    8 +-
 arch/x86/include/asm/perf_counter.h               |  100 +
 arch/x86/include/asm/unistd_32.h                  |    1 +
 arch/x86/include/asm/unistd_64.h                  |    3 +-
 arch/x86/kernel/apic/apic.c                       |    3 +
 arch/x86/kernel/cpu/Makefile                      |   12 +-
 arch/x86/kernel/cpu/common.c                      |    2 +
 arch/x86/kernel/cpu/perf_counter.c                | 1704 ++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c            |    4 +-
 arch/x86/kernel/entry_64.S                        |    5 +
 arch/x86/kernel/irq.c                             |   10 +
 arch/x86/kernel/irqinit.c                         |   15 +-
 arch/x86/kernel/signal.c                          |    1 -
 arch/x86/kernel/syscall_table_32.S                |    1 +
 arch/x86/kernel/traps.c                           |   12 +-
 arch/x86/mm/fault.c                               |   12 +-
 arch/x86/oprofile/nmi_int.c                       |    7 +-
 arch/x86/oprofile/op_model_ppro.c                 |   10 +-
 arch/x86/vdso/vdso32-setup.c                      |    6 +-
 arch/x86/vdso/vma.c                               |    7 +-
 drivers/char/sysrq.c                              |    2 +
 fs/exec.c                                         |    9 +
 include/asm-generic/atomic.h                      |    2 +-
 include/linux/init_task.h                         |   10 +
 include/linux/kernel_stat.h                       |    5 +
 include/linux/perf_counter.h                      |  697 ++++
 include/linux/prctl.h                             |    3 +
 include/linux/sched.h                             |   21 +-
 include/linux/syscalls.h                          |    5 +
 init/Kconfig                                      |   34 +
 kernel/Makefile                                   |    1 +
 kernel/exit.c                                     |   16 +-
 kernel/fork.c                                     |   12 +
 kernel/mutex.c                                    |    2 +-
 kernel/perf_counter.c                             | 4260 +++++++++++++++++++++
 kernel/sched.c                                    |   57 +-
 kernel/sys.c                                      |    7 +
 kernel/sys_ni.c                                   |    3 +
 kernel/sysctl.c                                   |   27 +
 kernel/timer.c                                    |    3 +
 mm/mmap.c                                         |    5 +
 mm/mprotect.c                                     |    2 +
 tools/perf/.gitignore                             |   16 +
 tools/perf/Documentation/Makefile                 |  300 ++
 tools/perf/Documentation/asciidoc.conf            |   91 +
 tools/perf/Documentation/manpage-1.72.xsl         |   14 +
 tools/perf/Documentation/manpage-base.xsl         |   35 +
 tools/perf/Documentation/manpage-bold-literal.xsl |   17 +
 tools/perf/Documentation/manpage-normal.xsl       |   13 +
 tools/perf/Documentation/manpage-suppress-sp.xsl  |   21 +
 tools/perf/Documentation/perf-annotate.txt        |   29 +
 tools/perf/Documentation/perf-help.txt            |   38 +
 tools/perf/Documentation/perf-list.txt            |   25 +
 tools/perf/Documentation/perf-record.txt          |   42 +
 tools/perf/Documentation/perf-report.txt          |   26 +
 tools/perf/Documentation/perf-stat.txt            |   66 +
 tools/perf/Documentation/perf-top.txt             |   39 +
 tools/perf/Documentation/perf.txt                 |   24 +
 tools/perf/Makefile                               |  929 +++++
 tools/perf/builtin-annotate.c                     | 1356 +++++++
 tools/perf/builtin-help.c                         |  461 +++
 tools/perf/builtin-list.c                         |   20 +
 tools/perf/builtin-record.c                       |  582 +++
 tools/perf/builtin-report.c                       | 1316 +++++++
 tools/perf/builtin-stat.c                         |  367 ++
 tools/perf/builtin-top.c                          |  736 ++++
 tools/perf/builtin.h                              |   26 +
 tools/perf/command-list.txt                       |   10 +
 tools/perf/design.txt                             |  442 +++
 tools/perf/perf.c                                 |  428 +++
 tools/perf/perf.h                                 |   67 +
 tools/perf/util/PERF-VERSION-GEN                  |   42 +
 tools/perf/util/abspath.c                         |  117 +
 tools/perf/util/alias.c                           |   77 +
 tools/perf/util/cache.h                           |  119 +
 tools/perf/util/color.c                           |  241 ++
 tools/perf/util/color.h                           |   36 +
 tools/perf/util/config.c                          |  873 +++++
 tools/perf/util/ctype.c                           |   26 +
 tools/perf/util/environment.c                     |    9 +
 tools/perf/util/exec_cmd.c                        |  165 +
 tools/perf/util/exec_cmd.h                        |   13 +
 tools/perf/util/generate-cmdlist.sh               |   24 +
 tools/perf/util/help.c                            |  367 ++
 tools/perf/util/help.h                            |   29 +
 tools/perf/util/levenshtein.c                     |   84 +
 tools/perf/util/levenshtein.h                     |    8 +
 tools/perf/util/list.h                            |  603 +++
 tools/perf/util/pager.c                           |   99 +
 tools/perf/util/parse-events.c                    |  316 ++
 tools/perf/util/parse-events.h                    |   17 +
 tools/perf/util/parse-options.c                   |  508 +++
 tools/perf/util/parse-options.h                   |  174 +
 tools/perf/util/path.c                            |  353 ++
 tools/perf/util/quote.c                           |  481 +++
 tools/perf/util/quote.h                           |   68 +
 tools/perf/util/rbtree.c                          |  383 ++
 tools/perf/util/rbtree.h                          |  171 +
 tools/perf/util/run-command.c                     |  395 ++
 tools/perf/util/run-command.h                     |   93 +
 tools/perf/util/sigchain.c                        |   52 +
 tools/perf/util/sigchain.h                        |   11 +
 tools/perf/util/strbuf.c                          |  359 ++
 tools/perf/util/strbuf.h                          |  137 +
 tools/perf/util/string.c                          |   34 +
 tools/perf/util/string.h                          |    8 +
 tools/perf/util/symbol.c                          |  641 ++++
 tools/perf/util/symbol.h                          |   47 +
 tools/perf/util/usage.c                           |   80 +
 tools/perf/util/util.h                            |  410 ++
 tools/perf/util/wrapper.c                         |  206 +
 138 files changed, 27406 insertions(+), 85 deletions(-)
 create mode 100644 arch/powerpc/include/asm/perf_counter.h
 create mode 100644 arch/powerpc/kernel/perf_counter.c
 create mode 100644 arch/powerpc/kernel/power4-pmu.c
 create mode 100644 arch/powerpc/kernel/power5+-pmu.c
 create mode 100644 arch/powerpc/kernel/power5-pmu.c
 create mode 100644 arch/powerpc/kernel/power6-pmu.c
 create mode 100644 arch/powerpc/kernel/power7-pmu.c
 create mode 100644 arch/powerpc/kernel/ppc970-pmu.c
 delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
 create mode 100644 arch/x86/include/asm/perf_counter.h
 create mode 100644 arch/x86/kernel/cpu/perf_counter.c
 create mode 100644 include/linux/perf_counter.h
 create mode 100644 kernel/perf_counter.c
 create mode 100644 tools/perf/.gitignore
 create mode 100644 tools/perf/Documentation/Makefile
 create mode 100644 tools/perf/Documentation/asciidoc.conf
 create mode 100644 tools/perf/Documentation/manpage-1.72.xsl
 create mode 100644 tools/perf/Documentation/manpage-base.xsl
 create mode 100644 tools/perf/Documentation/manpage-bold-literal.xsl
 create mode 100644 tools/perf/Documentation/manpage-normal.xsl
 create mode 100644 tools/perf/Documentation/manpage-suppress-sp.xsl
 create mode 100644 tools/perf/Documentation/perf-annotate.txt
 create mode 100644 tools/perf/Documentation/perf-help.txt
 create mode 100644 tools/perf/Documentation/perf-list.txt
 create mode 100644 tools/perf/Documentation/perf-record.txt
 create mode 100644 tools/perf/Documentation/perf-report.txt
 create mode 100644 tools/perf/Documentation/perf-stat.txt
 create mode 100644 tools/perf/Documentation/perf-top.txt
 create mode 100644 tools/perf/Documentation/perf.txt
 create mode 100644 tools/perf/Makefile
 create mode 100644 tools/perf/builtin-annotate.c
 create mode 100644 tools/perf/builtin-help.c
 create mode 100644 tools/perf/builtin-list.c
 create mode 100644 tools/perf/builtin-record.c
 create mode 100644 tools/perf/builtin-report.c
 create mode 100644 tools/perf/builtin-stat.c
 create mode 100644 tools/perf/builtin-top.c
 create mode 100644 tools/perf/builtin.h
 create mode 100644 tools/perf/command-list.txt
 create mode 100644 tools/perf/design.txt
 create mode 100644 tools/perf/perf.c
 create mode 100644 tools/perf/perf.h
 create mode 100755 tools/perf/util/PERF-VERSION-GEN
 create mode 100644 tools/perf/util/abspath.c
 create mode 100644 tools/perf/util/alias.c
 create mode 100644 tools/perf/util/cache.h
 create mode 100644 tools/perf/util/color.c
 create mode 100644 tools/perf/util/color.h
 create mode 100644 tools/perf/util/config.c
 create mode 100644 tools/perf/util/ctype.c
 create mode 100644 tools/perf/util/environment.c
 create mode 100644 tools/perf/util/exec_cmd.c
 create mode 100644 tools/perf/util/exec_cmd.h
 create mode 100755 tools/perf/util/generate-cmdlist.sh
 create mode 100644 tools/perf/util/help.c
 create mode 100644 tools/perf/util/help.h
 create mode 100644 tools/perf/util/levenshtein.c
 create mode 100644 tools/perf/util/levenshtein.h
 create mode 100644 tools/perf/util/list.h
 create mode 100644 tools/perf/util/pager.c
 create mode 100644 tools/perf/util/parse-events.c
 create mode 100644 tools/perf/util/parse-events.h
 create mode 100644 tools/perf/util/parse-options.c
 create mode 100644 tools/perf/util/parse-options.h
 create mode 100644 tools/perf/util/path.c
 create mode 100644 tools/perf/util/quote.c
 create mode 100644 tools/perf/util/quote.h
 create mode 100644 tools/perf/util/rbtree.c
 create mode 100644 tools/perf/util/rbtree.h
 create mode 100644 tools/perf/util/run-command.c
 create mode 100644 tools/perf/util/run-command.h
 create mode 100644 tools/perf/util/sigchain.c
 create mode 100644 tools/perf/util/sigchain.h
 create mode 100644 tools/perf/util/strbuf.c
 create mode 100644 tools/perf/util/strbuf.h
 create mode 100644 tools/perf/util/string.c
 create mode 100644 tools/perf/util/string.h
 create mode 100644 tools/perf/util/symbol.c
 create mode 100644 tools/perf/util/symbol.h
 create mode 100644 tools/perf/util/usage.c
 create mode 100644 tools/perf/util/util.h
 create mode 100644 tools/perf/util/wrapper.c

[ combo patch left out due to lkml size limits ]
