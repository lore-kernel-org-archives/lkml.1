Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968431Ab0B0O2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:28:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968380Ab0B0O2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:28:52 -0500
Date: Sat, 27 Feb 2010 15:28:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/core changes for v2.6.34
Message-ID: <20100227142834.GA15668@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

It was a very busy cycle for perf, with lots of improvements:

   131 files changed, 8461 insertions(+), 3335 deletions(-)

A few highlights:

 - New 'session' support, with cross-arch features: it's possible to record a
   session on 32-bit PA/RISC and then display a correct 'perf report' on
   64-bit x86. (this specific combination was tested in practice)

 - Rewritten auto-freq sampling code, there should be no sampling artifacts in 
   'perf report' output anymore:

      45.08%  multi-fault-all  [kernel]                  [k] smp_invalidate_interrupt
      19.45%  multi-fault-all  [kernel]                  [k] intel_pmu_enable_all
      14.17%  multi-fault-all  [kernel]                  [k] flush_tlb_others_ipi

   That 'intel_pmu_enable_all()' entry is now gone.

 - New x86 event constraint handling code, to correctly measure certain event 
   combinations.

 - Improved script engine for 'perf trace' and Python support.

 - New 'perf lock' tool to profile locking patterns, which 
   plugs into the lockstat callbacks.

 - Expanded x86 CPU support: Westmere support and support for intel core solo/duo.

 - Various 'perf probe' enhancements and refinements.

 - Improved symbol handling, buildid-cache in the .debug directory hierarchy 
   and improved debuginfo processing support.

 - Improved 'perf annotate'.

 - New 'perf archive' tool: create archive with object files with build-ids 
   found in the perf.data file, into perf.data.tar.bz2, to transport 
   self-contained profiling info and profiled images across machines.

( There's two more perf trees pending: perf/nmi and perf/probes, with two 
  other features that we kept separate. )

 Thanks,

	Ingo

------------------>
Alexander Beregalov (1):
      perf: Fix memory leak: counterwidth

Amerigo Wang (1):
      perf: Use format string of printf to align strings

Anton Blanchard (1):
      perf: Fix inconsistency between IP and callchain sampling

Arnaldo Carvalho de Melo (63):
      perf session: Move the event processing routines to session.c
      perf tools: Move the map class definition to a separate header
      perf session: Share the common trace sample_check routine as perf_session__has_traces
      perf session: Remove sample_type_check from event_ops
      perf session: Move total_unknown to perf_session->unknown events
      perf session: Move full_paths config to symbol_conf
      perf session: Remove redundant prefix & suffix from perf_event_ops
      perf record: Introduce a symtab cache
      perf header: Do_read shouldn't die
      perf header: perf_header__push_event() shouldn't die
      perf report: Add --hide-unresolved/-U command line option
      perf diff: Don't add the period for unresolved symbols
      perf diff: Fix support for all --sort combinations
      perf symbols: Generalise the kallsyms parsing routine
      perf symbols: Export symbol_type__is_a
      perf tools: Create write_padded routine out of __dsos__write_buildid_table
      perf session: Keep pointers to the vmlinux maps
      perf report: Fix --no-call-chain option handling
      perf tools: Handle relocatable kernels
      perf buildid-list: No need to process the header sections again
      perf symbols: Record the domain of DSOs in HEADER_BUILD_ID header table
      perf tools: Create typedef for common event synthesizing callback
      perf tools: Encode kernel module mappings in perf.data
      perf tools: Don't cast RIP to pointers
      perf tools: Cross platform perf.data analysis support
      perf tools: Convert getpagesize() uses to sysconf(_SC_GETPAGESIZE)
      perf symbols: Don't try to load kallsyms if doesn't match the record build-id
      perf symbols: Cache /proc/kallsyms files by build-id
      perf symbols: Use dso->long_name in dsos__find()
      perf record: Encode the domain while synthesizing MMAP events
      perf symbols: Create thread__find_addr_map from thread__find_addr_location
      perf buildid-list: Introduce --with-hits option
      perf symbols: The synthesized kernel modules MMAP must use the pathnames
      perf archive: Add helper script to package files needed to do analysis
      perf record: Intercept all events
      perf symbols: Accept an alias when looking for "_text"
      perf archive: Add documentation
      perf archive: Fix installation steps in the Makefile
      perf symbols: Set dso->kernel when handling the fake vmlinux MMAP event
      perf symbols: Use only --vmlinux if specified
      perf buildid-cache: Add new command to manage build-id cache
      perf top: Fix sample counting
      perf top: Handle PERF_RECORD_{FORK,EXIT} events
      perf symbols: Fix inverted logic for showing kallsyms as the source of symbols
      perf symbols: Use the right variable to check for kallsyms in the cache
      perf top: Exit if specified --vmlinux can't be used
      perf symbols: Factor out dso__load_vmlinux_path()
      perf symbols: Split helpers used when creating kernel dso object
      perf session: Create kernel maps in the constructor
      perf symbols: Remove perf_session usage in symbols layer
      perf symbols: Fixup vsyscall maps
      perf symbols: Ditch vdso global variable
      perf probe: Don't use a perf_session instance just to resolve symbols
      perf build-id: Move the routine to find DSOs with hits to the lib
      perf record: Stop intercepting events, use postprocessing to get build-ids
      perf tools: Adjust some verbosity levels
      perf top: Use address pattern in lookup_sym_source
      perf symbols: Fix up map end too on modular kernels with no modules installed
      perf tools: Don't use parent comm if not set at fork time
      perf top: Use a macro instead of a constant variable
      perf symbols: Improve debugging information about symtab origins
      perf annotate: Defer allocating sym_priv->hist array
      perf annotate: Handle samples not at objdump output addr boundaries

David S. Miller (1):
      perf tools: Flush maps on COMM events

Frederic Weisbecker (11):
      perf: Drop useless check for ignored frame
      perf/core: Split context's event group list into pinned and non-pinned lists
      list: Introduce list_rotate_left()
      perf: Round robin flexible groups of events using list_rotate_left()
      perf: Export software-only event group characteristic as a flag
      perf: Fix implicit declaration of getline in util.c
      perf: Make __perf_event_sched_out static
      perf: Allow pinned and flexible groups to be scheduled separately
      perf: Don't schedule out/in pinned events on task tick
      perf: Better order flexible and pinned scheduling
      perf/scripts: Tag syscall_name helper as not yet available

Hitoshi Mitake (7):
      perf probe: Fix build error of builtin-probe.c
      perf trace: Add -i option for choosing input file
      Revert "perf record: Intercept all events"
      perf tools: Add __data_loc support
      perf: Add util/include/linuxhash.h to include hash.h of kernel
      perf lock: Enhance information of lock trace events
      perf lock: Introduce new tool "perf lock", for analyzing lock statistics

Ingo Molnar (3):
      perf, x86: Clean up event constraints code a bit
      perf lock: Clean up various details
      perf tools: Fix session init on non-modular kernels

Jamie Iles (1):
      sched/perf: Make sure irqs are disabled for perf_event_task_sched_in()

John Kacur (1):
      perf: Ignore perf-archive temp file

K.Prasad (2):
      x86/debug: Clear reserved bits of DR6 in do_debug()
      x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler

Kirill Smelkov (5):
      perf: Fix few typos + cosmetics
      perf top: Fix code typo in prompt_symbol()
      perf annotate: Fix it for non-prelinked *.so
      perf top: Teach it to autolocate vmlinux
      perf top: Fix annotate for userspace

Li Zefan (1):
      perf events: Remove CONFIG_EVENT_PROFILE

Liming Wang (3):
      perf tools: Unify event type description
      perf probe: Change CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT
      perf tools: Fix --pid option for stat

Masami Hiramatsu (15):
      tracing/kprobe: Update example output in documentation
      tracing/kprobe: Drop function argument access syntax
      x86/ptrace: Remove unused regs_get_argument_nth API
      perf probe: Remove newline from die()
      perf probe: Show probe list in pager
      perf tools: Support tracepoint glob matching
      perf tools: Enhance glob string matching
      perf probe: Support --line option to show probable source-code lines
      tracing/kprobe: Update kprobe tracing self test for new syntax
      kprobes: Disable booster when CONFIG_PREEMPT=y
      ftrace/alternatives: Introducing *_text_reserved functions
      kprobes: Check probe address is reserved
      ftrace: Remove record freezing
      kprobes: Add mcount to the kprobes blacklist
      x86/alternatives: Fix build warning

Mike Galbraith (1):
      perf annotate: Fix perf top module symbol annotation

Motohiro KOSAKI (2):
      kprobetrace, doc: Shell needs single quote to use $ character
      kprobetrace, doc: Add the explanation to remove probe points

Naga Chumbalkar (1):
      x86, perfctr: Remove unused func avail_to_resrv_perfctr_nmi()

Peter Zijlstra (26):
      perf events: Remove arg from perf sched hooks
      perf: Reimplement frequency driven sampling
      perf_event: x86: Allocate the fake_cpuc
      perf_event: x86: Fixup constraints typing issue
      perf_event: x86: Clean up some of the u64/long bitmask casting
      perf_event: x86: Reduce some overly long lines with some MACROs
      bitops: Provide compile time HWEIGHT{8,16,32,64}
      perf_event: x86: Optimize the constraint searching bits
      perf_event: x86: Optimize constraint weight computation
      perf_event: x86: Optimize the fast path a little more
      perf_event: x86: Optimize x86_pmu_disable()
      perf_event: x86: Deduplicate the disable code
      perf_events, x86: Fix event constraint masks
      perf_events, x86: Clean up hw_perf_*_all() implementation
      perf_events, x86: Implement Intel Westmere support
      perf_events, x86: Remove spurious counter reset from x86_pmu_enable()
      perf_events: Fix sample_period transfer on inherit
      perf_events: Optimize perf_event_task_tick()
      perf_events, x86: Implement intel core solo/duo support
      bitops: Ensure the compile time HWEIGHT is only used for such
      perf_events: Report the MMAP pgoff value in bytes
      perf_events: Simplify code by removing cpu argument to hw_perf_group_sched_in()
      perf_events, x86: Remove superflous MSR writes
      perf_events, x86: Split PMU definitions into separate files
      perf_event: Fix preempt warning in perf_clock()
      perf_event, amd: Fix spinlock initialization

Stephane Eranian (5):
      perf_events, x86: Improve x86 event scheduling
      perf_events: Add fast-path to the rescheduling code
      perf_events, x86: Fix bug in hw_perf_enable()
      perf_events: Add new start/stop PMU callbacks
      perf_events, x86: AMD event scheduling

Thiago Farina (1):
      tools/perf/perf.c: Clean up trivial style issues

Tom Zanussi (9):
      perf/scripts: Fix supported language listing option
      perf/scripts: Fix bug in Util.pm
      perf/scripts: Move common code out of Perl-specific files
      perf/scripts: Move Perl scripting files to scripting-engines dir
      perf/scripts: Remove check-perf-trace from listed scripts
      perf/scripts: Add Python scripting engine
      perf/scripts: Add syscall tracing scripts
      perf/scripts: Remove unnecessary PyTuple resizes
      perf/scripts: Add perf-trace-python Documentation

Ulrich Drepper (1):
      perf tools: Do a few more directory handling optimizations

Wenji Huang (1):
      perf: Make cmd_to_page() function more compact

Xiao Guangrong (7):
      perf tools: Mount debugfs automatically
      perf trace: Clean up find_debugfs()
      perf trace: Fix forgotten close of file/dir
      perf: Factorize trace events raw sample buffer operations
      tracing/kprobe: Cleanup unused return value of tracing functions
      perf tools: Use O_LARGEFILE to open perf data file
      perf tools: Clean up O_LARGEFILE et al usage

Zhang, Yanmin (1):
      perf symbols: Check the right return variable

austin_zhang@linux.intel.com (1):
      perf record: Fix existing process callgraph symbol


 Documentation/trace/kprobetrace.txt                |   57 +-
 arch/ia64/kernel/kprobes.c                         |    2 +-
 arch/powerpc/kernel/perf_callchain.c               |    3 -
 arch/powerpc/kernel/perf_event.c                   |   10 +-
 arch/sh/kernel/perf_callchain.c                    |    3 -
 arch/sparc/kernel/perf_event.c                     |   10 +-
 arch/x86/include/asm/alternative.h                 |    5 +
 arch/x86/include/asm/debugreg.h                    |    3 +
 arch/x86/include/asm/nmi.h                         |    1 -
 arch/x86/include/asm/perf_event.h                  |   16 +-
 arch/x86/include/asm/ptrace.h                      |    4 -
 arch/x86/include/asm/stacktrace.h                  |    2 -
 arch/x86/kernel/alternative.c                      |   18 +
 arch/x86/kernel/cpu/perf_event.c                   | 1854 ++++++--------------
 arch/x86/kernel/cpu/perf_event_amd.c               |  416 +++++
 arch/x86/kernel/cpu/perf_event_intel.c             |  971 ++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c                |  157 ++
 arch/x86/kernel/cpu/perfctr-watchdog.c             |   11 -
 arch/x86/kernel/dumpstack_32.c                     |    5 -
 arch/x86/kernel/dumpstack_64.c                     |    5 -
 arch/x86/kernel/hw_breakpoint.c                    |   10 +-
 arch/x86/kernel/kprobes.c                          |    5 +-
 arch/x86/kernel/ptrace.c                           |   24 -
 arch/x86/kernel/traps.c                            |    3 +
 include/linux/bitops.h                             |   29 +-
 include/linux/ftrace.h                             |    7 +-
 include/linux/ftrace_event.h                       |   20 +-
 include/linux/list.h                               |   14 +
 include/linux/perf_event.h                         |   55 +-
 include/linux/syscalls.h                           |    4 +-
 include/trace/events/lock.h                        |   29 +-
 include/trace/ftrace.h                             |   60 +-
 include/trace/syscall.h                            |    4 +-
 init/Kconfig                                       |   13 -
 kernel/kprobes.c                                   |   34 +-
 kernel/perf_event.c                                |  627 +++++---
 kernel/sched.c                                     |   12 +-
 kernel/trace/Makefile                              |    4 +-
 kernel/trace/ftrace.c                              |   54 +-
 kernel/trace/trace_event_profile.c                 |   52 +-
 kernel/trace/trace_events_filter.c                 |    4 +-
 kernel/trace/trace_kprobe.c                        |  196 +--
 kernel/trace/trace_syscalls.c                      |   76 +-
 tools/perf/.gitignore                              |    1 +
 tools/perf/Documentation/perf-archive.txt          |   22 +
 tools/perf/Documentation/perf-buildid-cache.txt    |   33 +
 tools/perf/Documentation/perf-probe.txt            |   20 +
 tools/perf/Documentation/perf-top.txt              |    2 +-
 tools/perf/Documentation/perf-trace-perl.txt       |    2 +-
 tools/perf/Documentation/perf-trace-python.txt     |  625 +++++++
 tools/perf/Documentation/perf-trace.txt            |   15 +-
 tools/perf/Documentation/perf.txt                  |    2 +-
 tools/perf/Makefile                                |   51 +-
 tools/perf/builtin-annotate.c                      |  240 ++-
 tools/perf/builtin-buildid-cache.c                 |  133 ++
 tools/perf/builtin-buildid-list.c                  |   31 +-
 tools/perf/builtin-diff.c                          |   74 +-
 tools/perf/builtin-help.c                          |    5 +-
 tools/perf/builtin-kmem.c                          |   48 +-
 tools/perf/builtin-lock.c                          |  678 +++++++
 tools/perf/builtin-probe.c                         |   94 +-
 tools/perf/builtin-record.c                        |   50 +-
 tools/perf/builtin-report.c                        |   58 +-
 tools/perf/builtin-sched.c                         |   32 +-
 tools/perf/builtin-stat.c                          |  106 +-
 tools/perf/builtin-timechart.c                     |   25 +-
 tools/perf/builtin-top.c                           |  109 +-
 tools/perf/builtin-trace.c                         |   34 +-
 tools/perf/builtin.h                               |    2 +
 tools/perf/command-list.txt                        |    2 +
 tools/perf/design.txt                              |    8 +-
 tools/perf/perf-archive.sh                         |   32 +
 tools/perf/perf.c                                  |   25 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    5 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    3 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    2 +-
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +-
 .../perf/scripts/perl/bin/check-perf-trace-report  |    6 -
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    4 +
 tools/perf/scripts/perl/failed-syscalls.pl         |   38 +
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |   88 +
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   91 +
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   25 +
 .../python/bin/failed-syscalls-by-pid-record       |    2 +
 .../python/bin/failed-syscalls-by-pid-report       |    4 +
 .../python/bin/syscall-counts-by-pid-record        |    2 +
 .../python/bin/syscall-counts-by-pid-report        |    4 +
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +
 .../perf/scripts/python/bin/syscall-counts-report  |    4 +
 tools/perf/scripts/python/check-perf-trace.py      |   83 +
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   68 +
 tools/perf/scripts/python/syscall-counts-by-pid.py |   64 +
 tools/perf/scripts/python/syscall-counts.py        |   58 +
 tools/perf/util/build-id.c                         |   39 +
 tools/perf/util/build-id.h                         |    8 +
 tools/perf/util/data_map.c                         |  252 ---
 tools/perf/util/debug.c                            |    1 +
 tools/perf/util/debugfs.c                          |   17 +-
 tools/perf/util/debugfs.h                          |    2 +-
 tools/perf/util/event.c                            |  220 ++-
 tools/perf/util/event.h                            |   79 +-
 tools/perf/util/header.c                           |  284 +++-
 tools/perf/util/header.h                           |    9 +-
 tools/perf/util/include/linux/hash.h               |    5 +
 tools/perf/util/include/linux/kernel.h             |    1 +
 tools/perf/util/map.c                              |   52 +-
 tools/perf/util/map.h                              |   94 +
 tools/perf/util/parse-events.c                     |   48 +-
 tools/perf/util/probe-event.c                      |  105 ++-
 tools/perf/util/probe-event.h                      |    2 +
 tools/perf/util/probe-finder.c                     |  203 ++-
 tools/perf/util/probe-finder.h                     |   33 +
 .../{ => scripting-engines}/trace-event-perl.c     |  115 +--
 .../util/scripting-engines/trace-event-python.c    |  573 ++++++
 tools/perf/util/session.c                          |  431 +++++-
 tools/perf/util/session.h                          |   55 +-
 tools/perf/util/string.c                           |   65 +-
 tools/perf/util/symbol.c                           |  529 ++++--
 tools/perf/util/symbol.h                           |   52 +-
 tools/perf/util/thread.c                           |   52 +-
 tools/perf/util/thread.h                           |   24 +-
 tools/perf/util/trace-event-info.c                 |   64 +-
 tools/perf/util/trace-event-parse.c                |   24 +
 tools/perf/util/trace-event-perl.h                 |   55 -
 tools/perf/util/trace-event-read.c                 |   18 +-
 tools/perf/util/trace-event-scripting.c            |  167 ++
 tools/perf/util/trace-event.h                      |   10 +-
 tools/perf/util/util.c                             |   94 +
 tools/perf/util/util.h                             |    3 +
 tools/perf/util/values.c                           |    1 +
 131 files changed, 8461 insertions(+), 3335 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_p6.c
 create mode 100644 tools/perf/Documentation/perf-archive.txt
 create mode 100644 tools/perf/Documentation/perf-buildid-cache.txt
 create mode 100644 tools/perf/Documentation/perf-trace-python.txt
 create mode 100644 tools/perf/builtin-buildid-cache.c
 create mode 100644 tools/perf/builtin-lock.c
 create mode 100644 tools/perf/perf-archive.sh
 delete mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report
 create mode 100644 tools/perf/scripts/perl/bin/failed-syscalls-record
 create mode 100644 tools/perf/scripts/perl/bin/failed-syscalls-report
 create mode 100644 tools/perf/scripts/perl/failed-syscalls.pl
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Context.c
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
 create mode 100644 tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
 create mode 100644 tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-by-pid-record
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-by-pid-report
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-record
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-report
 create mode 100644 tools/perf/scripts/python/check-perf-trace.py
 create mode 100644 tools/perf/scripts/python/failed-syscalls-by-pid.py
 create mode 100644 tools/perf/scripts/python/syscall-counts-by-pid.py
 create mode 100644 tools/perf/scripts/python/syscall-counts.py
 create mode 100644 tools/perf/util/build-id.c
 create mode 100644 tools/perf/util/build-id.h
 delete mode 100644 tools/perf/util/data_map.c
 create mode 100644 tools/perf/util/include/linux/hash.h
 create mode 100644 tools/perf/util/map.h
 rename tools/perf/util/{ => scripting-engines}/trace-event-perl.c (85%)
 create mode 100644 tools/perf/util/scripting-engines/trace-event-python.c
 delete mode 100644 tools/perf/util/trace-event-perl.h
 create mode 100644 tools/perf/util/trace-event-scripting.c
 create mode 100644 tools/perf/util/util.c

[ 500K+ patch left out due to lkml size limits ]
