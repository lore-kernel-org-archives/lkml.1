Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZLCUGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZLCUGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZLCUGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:06:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZLCUGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:06:48 -0500
Date: Thu, 3 Dec 2009 21:06:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/core for v2.6.33
Message-ID: <20091203200621.GA18096@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Perf events, tools/perf/ and tracepoints development activity has gone 
through the roof in this cycle, with 469 commits done by 47 developers:

  251 files changed, 21092 insertions(+), 6102 deletions(-)

Here are some of the highlights:

 - New 'perf kmem' tool for SLAB analysis. 'perf kmem record' records 
   the trace, 'perf kmem' reports the result.

 - New 'perf probe' tool to utilize kprobes to dynamically probe kernel 
   functions and insert new events. A 'perf probe my_function' command 
   will create a new probe at that function and the function name can be 
   used as a symbolic event ID in all perf tools from that point on. For 
   example, to probe 'sys_open', do:

     $ perf probe sys_open

   and it can be used for stats, profiling and tracing from that point 
   on, in the rest of the perf tools:

     $ perf stat -e probe:sys_open_0 -a sleep 1
     $ perf record -e probe:sys_open_0 -c 1 -a -f sleep 1
     $ perf record -g -e probe:sys_open_0 -c 1 -a -f sleep 1
     $ perf top -e probe:sys_open_0

   Part of this is a feature to kprobes that uses an instruction decoder 
   on x86 to make sure that probes inserted by user-space are safe 
   (occur at the right instruction boundary). The last thing we want is 
   for instrumentation to crash the kernel.

   There's also a new matching ftrace plugin for kprobes.

 - New 'perf bench' tool to run micro-benchmarks in a uniform way - next 
   to the tools that can measure them. It includes three benchmark 
   modules as a starting point:

    perf bench sched
	messaging: Benchmark for scheduler and IPC mechanisms
	pipe: Flood of communication over pipe() between two processes

    perf bench mem
	memcpy: Simple memory copy in various ways

   Our hope is that people find this useful and start adding more 
   modules.

 - New hardware breakpoints abstraction and support. This allows mixed
   use of hw-breakpoints by gdb and perf (and other debugging 
   facilities). It also allows and implements new features like the 
   profiling of kernel data variables on stock kernels. For example, to 
   profile tasklist_lock accesses:

  $ perf record -e mem:0x$(grep tasklist_lock /proc/kallsyms | cut -d' ' -f1) -c 1 -a -f sleep 10
  [ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 2.157 MB perf.data (~94233 samples) ]

  $ perf report

  # Samples: 80665
  #
  # Overhead          Command      Shared Object  Symbol
  # ........  ...............  .................  ......
  #
    34.84%        hackbench  [kernel]           [k] __write_lock_failed
    21.85%        hackbench  [kernel]           [k] _write_lock_irq
     4.97%        hackbench  [kernel]           [k] forget_original_parent
     4.97%        hackbench  [kernel]           [k] exit_ptrace
     4.96%        hackbench  [kernel]           [k] exit_notify
     3.70%        hackbench  [kernel]           [k] _read_lock
     3.47%        hackbench  [kernel]           [k] copy_process
     3.47%        hackbench  [kernel]           [k] release_task
     3.47%        hackbench  [kernel]           [k] wait_task_zombie
     3.04%             bash  [kernel]           [k] _write_lock_irq
     2.36%        hackbench  [kernel]           [k] __read_lock_failed
     1.65%             bash  [kernel]           [k] _read_lock
     1.50%             bash  [kernel]           [k] copy_process
     1.50%             bash  [kernel]           [k] release_task

 - build-id support for reliable matching of symbols to instrumentation 
   data.

 - Much rewamped and improved ELF symbol resolution code.

 - 'perf top' now displays user symbols too mixed with kernel symbols, 
   and other improvements.

 - "--filter expression" support to tracepoints - which utilizes the 
   filter engine within the kernel. For example, to trace only timer 
   interrupts in the system:

   $ perf record -e irq:irq_handler_entry --filter='irq==0' -R -f -a sleep 10

   $ perf trace

            perf-27426 [000] 22435.320805: irq_handler_entry: irq=0 name=timer
            perf-27426 [000] 22435.321803: irq_handler_entry: irq=0 name=timer
         swapper-0     [000] 22435.324797: irq_handler_entry: irq=0 name=timer
         swapper-0     [000] 22435.325752: irq_handler_entry: irq=0 name=timer
         swapper-0     [000] 22435.328669: irq_handler_entry: irq=0 name=timer
         swapper-0     [000] 22435.328850: irq_handler_entry: irq=0 name=timer

   Or to only record IRQ 19 when the 'achi' handler is triggered:

   $ perf record -e irq:irq_handler_entry --filter='irq==19 && name==ahci' -R -f -a sleep 10

   The filtering happens when the event occurs - i.e. events that are 
   filtered out do not enter the ring-buffer and dont get sent to the 
   trace file. This allows significant reduction of data traffic.

 - Perl scripting engine for programmable 'perf trace' scripting.
   See perf trace -g/--gen-script and perf trace -s/--script.

 - dwarf info support

 - new tracepoints: for PowerPC, signals and elsewhere

 - much improved 'perf trace' support

 - better structured and extensible perf.data format

 - ... and much more.

(See the shortlog and the tree for more details.)

 Thanks,

	Ingo

------------------>

Ananth N Mavinakayanahalli (1):
      kprobes: Prevent re-registration of the same kprobe

Andrew Morton (1):
      kernel/hw_breakpoint.c: Fix local/global shadowing

Anton Blanchard (15):
      perf stat: Add branch performance metric
      powerpc: perf_event: Log invalid data addresses as all 1s
      powerpc: perf_event: Enable SDAR in continous sample mode
      perf_event: Add alignment-faults and emulation-faults software events
      powerpc: Create PPC_WARN_ALIGNMENT to match PPC_WARN_EMULATED
      powerpc: perf_event: Add alignment-faults and emulation-faults software events
      powerpc: tracing: Add powerpc tracepoints for interrupt entry and exit
      powerpc: tracing: Add powerpc tracepoints for timer entry and exit
      powerpc: tracing: Add hypervisor call tracepoints
      powerpc: tracing: Give hypervisor call tracepoints access to arguments
      powerpc: Disable HCALL_STATS by default
      powerpc: Export powerpc_debugfs_root
      powerpc: perf_event: Cleanup copy_page output by hiding setup symbol
      powerpc: perf_event: Hide iseries_check_pending_irqs
      powerpc: perf_event: Cleanup output by adding symbols

Arjan van de Ven (3):
      perf timechart: Add a process filter
      perf/core: Provide a kernel-internal interface to get to performance counters
      perf_event: Fix invalid type in ioctl definition

Arnaldo Carvalho de Melo (91):
      perf tools: Use rb_tree for maps
      perf sched: Remove dead code
      perf trace: Remove dead code
      perf top: Remove dead {min,max}_ip unused variables
      perf tools: Rewrite and improve support for kernel modules
      perf tools: Move hist_entry__add common code to hist.c
      perf tools: Remove show_mask bitmask
      perf top: Keep the default of asking for kernel module symbols
      perf tools: Create maps for modules when processing kallsyms
      perf tools: /proc/modules names don't always match its name
      perf report: Use kernel_maps__find_symbol as fallback to find vdsos, etc
      perf tools: Up the verbose level for some really verbose stuff
      perf tools: Improve kernel/modules symbol lookup
      perf tools: Move threads & last_match to threads.c
      perf tools: Add missing tools/perf/util/include/string.h
      perf tools: Add bunch of missing headers to LIB_H
      perf tools: Add ->unmap_ip operation to struct map
      perf annotate: Use the sym_priv_size area for the histogram
      perf annotate: Remove requirement of passing a symbol name
      perf top: Fix symbol annotation
      perf tools: Unify debug messages mechanisms
      perf probe: Print debug messages using pr_*()
      perf record: Fix race where process can disappear while reading its /proc/pid/tasks
      perf tools: Generalize event synthesizing routines
      perf top: Support userspace symbols too
      perf tools: Delay loading symtabs till we hit a map with it
      perf tools: Factor out the map initialization
      perf tools: Simplify the symbol priv area mechanism
      perf tools: Improve message about missing symtabs for deleted DSOs
      perf probe: Annotate variable initialization
      perf symbols: Initialize dso->loaded
      perf symbols: Factor out buildid reading routine
      perf symbols: Use the buildids if present
      perf symbols: Call the symbol filter in dso__synthesize_plt_symbols()
      perf symbols: Pass the offset to perf_header__read_build_ids()
      perf tools: Debug.h needs to include event.h for event_t
      perf tools: Generalize perf_header__adds_read()
      perf tools: Introduce dsos__fprintf_buildid
      perf buildid-list: New plumbing command
      perf tools: Don't die in perf_header_attr__new()
      perf top: Use all the lines in the screen
      perf top: Introduce --hide_{user,kernel}_symbols
      perf buildid-list: Always show the DSO name
      perf tools: Don't die() in perf_header__add_attr()
      perf tools: Don't die() in perf_header_attr__add_id()
      perf tools: Don't die() in perf_header__new()
      perf tools: Don't die() in do_write()
      perf symbols: Add a long_name_len member to struct dso
      perf top: Auto adjust symbol and dso widths
      perf top: Suppress DSO column if only one is present
      perf top: Introduce helper function to access symbol from sym_entry
      perf top: Allocate space only for the number of counters used
      perf top: Don't allocate the source parsing members upfront
      perf symbols: Fix comparision of build_ids
      perf symbols: Kill struct build_id_list and die() another day
      perf symbols: Record the build_ids of kernel modules too
      perf symbols: Capture the running kernel buildid too
      perf tools: perf_header__read() shouldn't die()
      perf tools: Eliminate some more die() uses in library functions
      perf tools: Don't die() in mmap_dispatch_perf_file
      perf symbols: Remove unrelated actions from dso__load_kernel_sym
      perf symbols: Filename__read_build_id should look at .notes section too
      perf symbols: Introduce dso__build_id_equal
      perf symbols: Do lazy symtab loading for the kernel & modules too
      perf symbols: Check vmlinux buildid
      perf symbols: Change the kernel DSO name if it comes from kallsyms
      perf symbols: Fixup kernel_maps__fixup_end end map
      perf symbols: Old versions of elf.h don't have NT_GNU_BUILD_ID
      perf trace: Read_tracing_data should die() another day
      perf symbols: Show messages about module loading only if verbose >= 1
      perf report: Do map lookups in resolve_callchain()
      perf symbols: Look for vmlinux in more places
      perf tools: Move graph_line and graph_dotted_line from top
      perf kmem: Resolve symbols
      perf top: Always show the DSO column, even if its all the same
      perf symbols: Simplify symbol machinery setup
      perf tools: Introduce zalloc() for the common calloc(1, N) case
      perf tools: Remove unused wrapper routines
      perf symbols: Rename find_symbol routines to find_function
      perf symbols: Avoid annoying message about loading symbols
      perf symbols: Rename kernel_mapto kernel_map[s]__functions
      perf symbols: Split the dsos list into kernel and user parts
      perf symbols: Unexport kernel_map__functions
      perf symbols: Add a 'type' field to struct map
      perf symbols: Better support for multiple symbol tables per dso
      perf symbols: Make the kallsyms loading routines part of the dso class
      perf symbols: Kernel_maps should be an array of MAP__NR_TYPES entries
      perf symbols: Support multiple symtabs in struct thread
      perf symbols: When not using modules, discard its symbols
      perf tools: Reorganize event processing routines, lotsa dups killed
      perf tools: Consolidate symbol resolving across all tools

Borislav Petkov (3):
      mce, edac: Use an atomic notifier for MCEs decoding
      x86, mce: Fix up MCE naming nomenclature
      x86, mce: Add a global MCE init helper

Clark Williams (2):
      perf tools: Add debugfs utility routines for perf
      perf tools: Modify perf routines to use new debugfs routines

Frederic Weisbecker (52):
      hw-breakpoints: fix undeclared ksym_tracer_mutex
      tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
      tracing: Restore the const qualifier for field names and types definition
      tracing: Remove unneeded pointer casts
      tracing: Fix ring-buffer and ksym tracer merge interaction
      perf tools: Start the perf.data mapping at data offset in perf trace
      perf tools: Merge trace.info content into perf.data
      perf tools: Unify perf.data mapping and events handling
      perf tools: Improve thread comm resolution in perf sched
      perf tools: Fix thread comm resolution in perf sched
      perf tools: Provide backward compatibility with previous perf.data version
      perf tools: Use kernel bitmap library
      perf tools: Introduce bitmask'ed additional headers
      perf tools: Use DECLARE_BITMAP instead of an open-coded array
      perf tools: Fix missing top level callchain
      perf tools: Bind callchains to the first sort dimension column
      perf tools: Drop asm/types.h wrapper
      perf/core: Add a callback to perf events
      hw-breakpoint: Move asm-generic/hw_breakpoint.h to linux/hw_breakpoint.h
      tracing, perf_events: Protect the buffer from recursion in perf
      hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf events
      hw-breakpoints: Arbitrate access to pmu following registers constraints
      hw-breakpoints: Fix broken a.out format dump
      hw-breakpoints: Fix broken hw-breakpoint sample module
      hw-breakpoints: Wrap in the KVM breakpoint active state check
      perf tools: Synthetize the targeted process
      perf tools: Move the build-id storage operations to headers
      perf tools: Split up build id saving into fetch and write
      perf tools: Read the build-ids from the header layer
      perf tools: Use perf_header__set/has_feat whenever possible
      perf tools: Bring linear set of section headers for features
      tracing: Rename 'lockdep' event subsystem into 'lock'
      hw-breakpoints: Provide an off-case for counter_arch_bp()
      tracing: Use the perf recursion protection from trace event
      tracing: Forget about the NMI buffer for syscall events
      hw-breakpoints: Remove x86 specific headers from core file
      hw-breakpoints: Separate the kernel part from breakpoint headers
      hw-breakpoints: Include only linux/perf_event.h from kernel part of bp headers
      hw-breakpoints: Check the breakpoint params from perf tools
      perf: Add kernel side syscall events support for breakpoints
      perf tools: Add support for breakpoint events in perf tools
      hw-breakpoints: Fix misordered ifdef
      perf_events: Fix bad software/trace event recursion counting
      ksym_tracer: Fix breakpoint removal after modification
      hw-breakpoints: Improve in-kernel event creation error granularity
      hw-breakpoints: Simplify error handling in breakpoint creation requests
      x86/hw-breakpoints: Don't lose GE flag while disabling a breakpoint
      hw-breakpoints: Fix unused function in off-case
      hw-breakpoints: Use struct perf_event_attr to define user breakpoints
      hw-breakpoints: Use struct perf_event_attr to define kernel breakpoints
      tracing/syscalls: Make syscall events print callbacks static
      hw-breakpoints: Keep track of user disabled breakpoints

Hidetoshi Seto (3):
      perf_event, x86, mce: Use TRACE_EVENT() for MCE logging
      x86, mce: Fix __init annotations
      x86, mce: Add __cpuinit to hotplug callback functions

Hiroshi Shimamoto (2):
      x86: Gitignore: arch/x86/lib/inat-tables.c
      perf_event, x86: Annotate init functions and data

Hitoshi Mitake (20):
      perf bench: Add new directory and header for new subcommand 'bench'
      perf bench: Add sched-messaging.c: Benchmark for scheduler and IPC mechanisms based on hackbench
      perf bench: Add sched-pipe.c: Benchmark for pipe() system call
      perf bench: Add builtin-bench.c: General framework for benchmark suites
      perf bench: Modify builtin.h for new prototype
      perf bench: Add new subcommand 'bench' to perf.c
      perf bench: Add subcommand 'bench' to the Makefile
      perf bench: Fix bench/sched-pipe.c to wait for child process
      perf bench: Add format constants to bench.h for unified output formatting
      perf bench: Modify builtin-bench.c for processing common options
      perf bench: Modify bench/bench-messaging.c to adopt unified output formatting
      perf bench: Modify builtin-pipe.c for processing common options
      perf bench: Add new document about perf-bench
      perf bench: Modify command-list.txt for the entry of perf-bench
      perf bench: Improve builtin-bench.c for more friendly output
      perf bench: Improve sched-pipe.c with more comfortable output
      perf bench: Improve sched-message.c with more comfortable output
      perf tools: Add new perf_atoll() function to parse string representing size in bytes
      perf bench: Add memcpy() benchmark
      perf bench: Make the mem/memcpy tests more user-friendly

Ingo Molnar (17):
      perf tools: Default to 1 KHz auto-sampling freq events
      perf_events, x86: Fix event constraints code
      tracing/events: Fix locking imbalance in the filter code
      events: Harmonize event field names and print output names
      perf stat: Re-align the default_attrs[] array
      perf stat: Count branches first
      x86, instruction decoder: Fix test_get_len build rules
      perf tools: Fix missing symtabs printouts
      perf bench: Clean up bench/bench.h
      hw-breakpoints: Fix build on !perf architectures
      hw-breakpoints, x86: Fix modular KVM build
      perf_events: Fix modular build
      perf events: Do not generate function trace entries in perf code
      perf_events: Optimize the swcounter hotpath
      events: Rename TRACE_EVENT_TEMPLATE() to DECLARE_EVENT_CLASS()
      tracing: Fix kmem event exports
      perf scripting: Fix build

Jan Beulich (1):
      x86: Tighten conditionals on MCE related statistics

Jason Baron (1):
      tracing: Add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook

Jaswinder Singh Rajput (2):
      x86: hw_breakpoint.c arch_check_va_in_kernelspace and hw_breakpoint_handler should be static
      x86: Mark ptrace_get_debugreg() as static

John Kacur (6):
      perf annotate: Add the cmp_null function and make use of it
      perf tools: Protect header files with a consistent style
      perf tools: Create util/sort.and use it
      perf tools: Put common histogram functions in their own file
      perf tools: Add perf.data to .gitignore
      perf tools: Use common process_event functions for annotate and report

Julia Lawall (1):
      perf tools: Move dereference after NULL test

K.Prasad (13):
      hw-breakpoints: prepare the code for Hardware Breakpoint interfaces
      hw-breakpoints: introducing generic hardware breakpoint handler interfaces
      hw-breakpoints: x86 architecture implementation of Hardware Breakpoint interfaces
      hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
      hw-breakpoints: use wrapper routines around debug registers in processor related functions
      hw-breakpoints: use the new wrapper routines to access debug registers in process/thread code
      hw-breakpoints: modify signal handling code to refrain from re-enabling HW Breakpoints
      hw-breakpoints: modify Ptrace routines to access breakpoint registers
      hw-breakpoints: cleanup HW Breakpoint registers before kexec
      hw-breakpoints: sample HW breakpoint over kernel data address
      hw-breakpoints: ftrace plugin for kernel symbol tracing using HW Breakpoint interfaces
      hw-breakpoints: reset bits in dr6 after the corresponding exception is handled
      hw-breakpoint: Attribute authorship of hw-breakpoint related files

Kristian Høgsberg (1):
      perf: Don't free perf_mmap_data until work has been done

Lai Jiangshan (11):
      trace_syscalls: Add syscall nr field
      trace_kprobes: Fix memory leak
      trace_kprobes: Always show group name
      trace_kprobes: Don't output zero offset
      trace_syscalls: Remove unused event_syscall_enter and event_syscall_exit
      trace_syscalls: Set event_enter_##sname->data to its metadata
      trace_syscalls: Remove enter_id exit_id
      trace_syscalls: Add syscall_nr field to struct syscall_metadata
      trace_syscalls: Remove duplicate init_enter_##sname()
      trace_syscalls: Simplify syscall profile
      trace_syscalls: Remove unused syscall_name_to_nr()

Li Zefan (31):
      ksym_tracer: Extract trace entry from struct trace_ksym
      ksym_tracer: Rewrite ksym_trace_filter_read()
      ksym_tracer: Fix validation of access type
      ksym_tracer: Fix validation of length of access type
      ksym_tracer: NIL-terminate user input filter
      ksym_tracer: Report error when failed to re-register hbp
      ksym_tracer: Fix memory leak
      ksym_tracer: Fix the output of stat tracing
      tracing/filters: Refactor subsystem filter code
      tracing/filters: Use a different op for glob match
      tracing/profile: Add filter support
      perf trace: Add filter Suppport
      tracing/filters: Fix to make system filter work
      ksym_tracer: Remove KSYM_SELFTEST_ENTRY
      perf: Add 'perf kmem' tool
      perf kmem: Add new option to show raw ip
      perf kmem: Default to sort by fragmentation
      perf kmem: Collect cross node allocation statistics
      perf kmem: Measure kmalloc/kfree CPU ping-pong call-sites
      perf kmem: Add help file
      tracing: Convert module refcnt events to DEFINE_EVENT
      tracing: Convert some kmem events to DEFINE_EVENT
      tracing: Convert softirq events to DEFINE_EVENT
      tracing: Convert some workqueue events to DEFINE_EVENT
      tracing: Convert some power events to DEFINE_EVENT
      tracing: Convert some block events to DEFINE_EVENT
      tracing: Convert some jbd2 events to DEFINE_EVENT
      tracing: Convert some ext4 events to DEFINE_TRACE
      tracing: Restore original format of sched events
      perf annotate: Fix perf data parsing
      perf timechart: Remove open-coded event parsing code

Liming Wang (2):
      perf tools: Fix _GNU_SOURCE macro related strndup() build error
      perf tools: Replace %m with %a in sscanf

Lucas De Marchi (1):
      perf stat: Do not print ratio when task-clock event is not counted

Marti Raudsepp (2):
      perf tools: Notify user when unrecognized event is specified
      perf tools: Output 'perf list' to stdout not stderr

Masami Hiramatsu (94):
      x86: Instruction decoder API
      x86: X86 instruction decoder build-time selftest
      kprobes: Checks probe address is instruction boudary on x86
      kprobes: Cleanup fix_riprel() using insn decoder on x86
      x86: Add pt_regs register and stack access APIs
      tracing: Ftrace dynamic ftrace_event_call support
      tracing: Introduce TRACE_FIELD_ZERO() macro
      tracing: Add kprobe-based event tracer
      tracing: Add kprobe-based event tracer documentation
      tracing: Kprobe-tracer supports more than 6 arguments
      tracing: Generate names for each kprobe event automatically
      tracing: Kprobe tracer assigns new event ids for each event
      tracing: Add kprobes event profiling interface
      x86: Fix x86 instruction decoder selftest to check only .text
      x86: Check awk features before generating inat-tables.c
      tracing/kprobes: Fix format typo in trace_kprobes
      tracing/kprobes: Change trace_arg to probe_arg
      kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS
      kprobes/x86-64: Allow to reenter probe on post_handler
      kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions
      kprobes: Fix to add __kprobes to notify_die
      kprobes/x86-64: Fix to move common_interrupt to .kprobes.text
      kprobes: Prohibit to probe native_get_debugreg
      x86: Allow x86-32 instruction decoder selftest on x86-64
      x86: Remove unused config macros from instruction decoder selftest
      x86: Add MMX support for instruction decoder
      kprobes/x86-32: Move irq-exit functions to kprobes section
      x86/ptrace: Fix regs_get_argument_nth() to add correct offset
      tracing/kprobes: Fix probe offset to be unsigned
      tracing/kprobes: Cleanup kprobe tracer code.
      tracing/kprobes: Add event profiling support
      tracing/kprobes: Add argument name support
      tracing/kprobes: Show event name in trace output
      tracing/kprobes: Support custom subsystem for each kprobe event
      tracing/kprobes: Fix trace_probe registration order
      ftrace: Fix trace_add_event_call() to initialize list
      ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
      tracing/kprobes: Add probe handler dispatcher to support perf and ftrace concurrent use
      tracing/kprobes: Fix profiling alignment for perf_counter buffer
      tracing/kprobes: Disable kprobe events by default after creation
      tracing/kprobes: Use global event perf buffers in kprobe tracer
      x86: Add VIA processor instructions in opcodes decoder
      tracing/ftrace: Fix to check create_event_dir() when adding new events
      tracing/kprobes: Add $ prefix to special variables
      tracing/kprobes: Remove '$ra' special variable
      tracing/kprobes: Make special variable names more self-explainable
      tracing/kprobes: Avoid field name confliction
      tracing/kprobes: Robustify fixed field names against variable field names conflicts
      perf: Add perf probe subcommand, a kprobe-event setup helper
      perf probe: Add perf probe command support without libdwarf
      tracing/kprobes: Update kprobe-tracer selftest against new syntax
      tracing/kprobes: Add failure messages for debugging
      x86: Add MMX/SSE opcode groups to opcode map
      x86: Add AMD prefetch and 3DNow! opcodes to opcode map
      perf: Check libdwarf APIs for perf probe
      perf: Use die() for error cases in perf-probe
      perf: Use eprintf() for debug messages in perf-probe
      perf: Add DIE_IF() macro for error checking
      perf: Add perf-probe document
      x86: Fix group attribute decoding bug
      x86: Add AES opcodes to opcode map
      x86: Fix SSE opcode map bug
      x86: Merge INAT_REXPFX into INAT_PFX_*
      x86: Add pclmulq to x86 opcode map
      x86: AVX instruction set decoder support
      x86: Add Intel FMA instructions to x86 opcode map
      kprobe-tracer: Compare both of event-name and event-group to find probe
      perf/probes: Exit searching after finding target function
      perf/probes: Improve command-line option of perf-probe
      perf/probes: Improve probe point syntax of perf-probe
      perf/probes: Support function entry relative line number
      perf/probes: Update Documentation/perf-probe.txt
      perf/probes: Improve error messages
      perf/probes: Fall back to non-dwarf if possible
      perf/probes: Rename perf probe events group name
      tracing/kprobes: Rename Kprobe-tracer to kprobe-event
      x86: Add verbose option to insn decoder test
      x86: Show symbol name if insn decoder test failed
      x86: Instruction decoder test should generate build warning
      x86: Fix insn decoder test typos
      x86: insn decoder test checks objdump version
      tracepoint: Move signal sending tracepoint to events/signal.h
      tracepoint: Add signal deliver event
      tracepoint: Add signal loss events
      trace_kprobes: Fix a memory leak bug and check kstrdup() return value
      perf probe: Change a debugging message from pr_info to pr_debug
      perf probe: Add probe-finder.h without libdwarf
      perf probe: Fix argv array size in probe parser
      perf probe: Fix probe array index for multiple probe points
      perf probe: Move probe event utility functions to probe-event.c
      perf probe: Add argv_split() from lib/argv_split.c
      perf probe: Add --list option for listing current probe events
      perf probe: Simplify event naming
      x86: Fix comments of register/stack access functions

Michael Cree (2):
      perf tools, Alpha: Add Alpha support to perf.h
      perf tools: Test -fstack-protector-all compiler option for inclusion in CFLAGS

Michael S. Tsirkin (4):
      perf tools: Support static build
      perf tools: Add V=2 option to help debug config issues
      perf tools: Suggest static libraries as well
      perf: Use default compiler mode by default

Mike Galbraith (3):
      perf tools: Fix counter sample frequency breakage
      perf sched: Add -C option to measure on a specific CPU
      perf tools: Remove expensive old debug code from perf top

Márton Németh (1):
      perf_event: Remove redundant zero fill

Nick Piggin (1):
      perf annotate: Allocate history size correctly

Paul Mackerras (1):
      perf tools: Fix compilation on powerpc

Paul Mundt (2):
      x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().
      ksym_tracer: Support read accesses independent of read/write.

Pekka Enberg (2):
      perf kmem: Add --sort hit and --sort frag
      perf symbols: Fix ELF header errors during "perf kmem record"

Peter Zijlstra (23):
      perf, x86: Add simple group validation
      perf_event: Optimize perf_output_lock()
      perf: Allow for custom overflow handlers
      perf: Optimize some swcounter attr.sample_period==1 paths
      perf: Optimize perf_swevent_ctx_event()
      perf: Optimize perf_event_task_ctx()
      perf: Optimize perf_event_comm_ctx()
      perf: Optimize perf_event_mmap_ctx()
      perf: Fix PERF_FORMAT_GROUP scale info
      perf: Optimize perf_event_task_sched_out
      perf: Optimize __perf_event_read()
      perf: Simplify __perf_event_sync_stat
      perf: Simplify __perf_event_read
      perf: Fix time locking
      perf: Fix event scaling for inherited counters
      perf: Fix locking for PERF_FORMAT_GROUP
      perf_events: Undo copy/paste damage
      perf_events: Fix style nits
      perf_events: Disable events when we detach them
      perf_events: Update the context time on exit
      perf_events: Fix __perf_event_exit_task() vs. update_event_times() locking
      perf_events: Undo some recursion damage
      perf_events: Restore sanity to scaling land

Randy Dunlap (1):
      perf tools: Display better error messages on missing packages

Simon Kaempflein (1):
      perf record, x86: Print more intelligent error message when sampling fails

Stephane Eranian (6):
      perf_events: Check for filters on fixed counter events
      perf_events: Add event constraints support for Intel processors
      perf_events: Fix default watermark calculation
      perf_events: Fix bogus copy_to_user() in perf_event_read_group()
      perf_events, x86: Fix validate_event bug
      perf_events: Fix read() bogus counts when in error state

Steven Rostedt (18):
      perf tools: Handle print concatenations in event format file
      perf tools: Fix backslash processing on trace print formats
      perf tools: Handle trace parsing of < and >
      perf tools: Handle arrays in print fields for trace parsing
      perf tools: Handle * as typecast in trace parsing
      perf tools: Handle newlines in trace parsing better
      perf tools: Handle the case with and without the "signed" trace field
      perf tools: Still continue on failed parsing of an event
      perf tools: Fix bprintk reading in trace output
      perf tools: Handle both versions of ftrace output
      perf tools: Add latency format to trace output
      perf tools: Handle - and + in parsing trace print format
      perf tools: Remove all char * typecasts and use const in prototype
      perf tools: Add 'make DEBUG=1' to remove the -O6 cflag
      perf tools: Use strsep() over strtok_r() for parsing single line
      tracing: Create new TRACE_EVENT_TEMPLATE
      tracing: Create new DEFINE_EVENT_PRINT
      tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT

Tejun Heo (1):
      x86: Rename global percpu symbol dr7 to cpu_dr7

Thiago Farina (1):
      perf: Clean up trivial style issues in builtin-help.c

Tim Blechmann (1):
      perf stat: Add branch performance events to default output

Tom Zanussi (16):
      tracing/events: Add 'signed' field to format files
      perf trace: Add subsystem string to struct event
      perf trace: Add string/dynamic cases to format_flags
      perf tools: Add 'signed' flag setting back into trace-event-parse.c
      trace/syscalls: Change ret param in struct syscall_trace_exit to long
      perf trace: Add scripting ops
      perf trace: Add flag/symbolic format_flags
      perf trace: Add Perl scripting support
      perf trace: Add perf trace scripting support modules for Perl
      perf trace: Add interface to access perf data from Perl handlers
      perf trace: Add Documentation for perf trace Perl support
      perf trace: Add a scripts/perl/bin for perf trace shell scripts
      perf trace/scripting: Silence PERL_EMBED_* backtick errors
      perf trace/scripting: Ignore shadowed variable warning for perf-trace-perl.c
      perf trace/scripting: Fix Perl common_* access functions
      perf trace/scripting: Add Fedora libperl install note to doc

Tony Luck (1):
      perf tools: Add ia64 support for tools/perf/

Vincent Legoll (1):
      perf tools: Do not manually count string lengths

Xiao Guangrong (5):
      tracing/ksym_tracer: fix the output of ksym tracer
      tracing/ksym_tracer: fix write operation of ksym_trace_filter
      tracing/ksym_tracer: support quick clear for ksym_trace_filter -- v2
      perf_event: Initialize data.period in perf_swevent_hrtimer()
      perf_event: Fix compile error

Yong Wang (2):
      x86: Under BIOS control, restore AP's APIC_LVTTHMR to the BSP value
      x86: Mark the thermal init functions __init

Zeev Tarantov (1):
      perf tools: Fix syntax in documentation

 Documentation/DocBook/tracepoint.tmpl              |    5 +
 Documentation/trace/kprobetrace.txt                |  149 ++
 arch/Kconfig                                       |    7 +
 arch/powerpc/Kconfig.debug                         |    2 +-
 arch/powerpc/configs/pseries_defconfig             |    2 +-
 arch/powerpc/include/asm/emulated_ops.h            |   19 +-
 arch/powerpc/include/asm/hvcall.h                  |    2 +
 arch/powerpc/include/asm/reg.h                     |    2 +
 arch/powerpc/include/asm/trace.h                   |  133 ++
 arch/powerpc/kernel/align.c                        |   12 +-
 arch/powerpc/kernel/entry_64.S                     |    4 +-
 arch/powerpc/kernel/exceptions-64s.S               |    3 +
 arch/powerpc/kernel/irq.c                          |    6 +
 arch/powerpc/kernel/perf_event.c                   |    2 +-
 arch/powerpc/kernel/power5+-pmu.c                  |    4 -
 arch/powerpc/kernel/power5-pmu.c                   |    6 +-
 arch/powerpc/kernel/power6-pmu.c                   |    2 +-
 arch/powerpc/kernel/power7-pmu.c                   |    6 +-
 arch/powerpc/kernel/ppc970-pmu.c                   |    4 -
 arch/powerpc/kernel/setup-common.c                 |    1 +
 arch/powerpc/kernel/time.c                         |    6 +
 arch/powerpc/kernel/traps.c                        |   18 +-
 arch/powerpc/lib/copypage_64.S                     |    4 +-
 arch/powerpc/platforms/pseries/hvCall.S            |  132 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c       |   38 +
 arch/powerpc/platforms/pseries/lpar.c              |   33 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/Kconfig.debug                             |    9 +
 arch/x86/Makefile                                  |    3 +
 arch/x86/include/asm/Kbuild                        |    1 +
 arch/x86/include/asm/a.out-core.h                  |   10 +-
 arch/x86/include/asm/debugreg.h                    |   33 +
 arch/x86/include/asm/hardirq.h                     |    6 +-
 arch/x86/include/asm/hw_breakpoint.h               |   73 +
 arch/x86/include/asm/inat.h                        |  220 +++
 arch/x86/include/asm/inat_types.h                  |   29 +
 arch/x86/include/asm/insn.h                        |  184 +++
 arch/x86/include/asm/mce.h                         |   14 +-
 arch/x86/include/asm/perf_event.h                  |   13 +-
 arch/x86/include/asm/processor.h                   |   14 +-
 arch/x86/include/asm/ptrace.h                      |   62 +
 arch/x86/kernel/Makefile                           |    2 +-
 arch/x86/kernel/cpu/Makefile                       |    1 +
 arch/x86/kernel/cpu/common.c                       |    4 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  103 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |   29 +-
 arch/x86/kernel/cpu/perf_event.c                   |  205 +++-
 arch/x86/kernel/entry_32.S                         |   24 +
 arch/x86/kernel/entry_64.S                         |    8 +
 arch/x86/kernel/hw_breakpoint.c                    |  555 +++++++
 arch/x86/kernel/irq.c                              |   12 +-
 arch/x86/kernel/kgdb.c                             |    6 +
 arch/x86/kernel/kprobes.c                          |  243 ++--
 arch/x86/kernel/machine_kexec_32.c                 |    2 +
 arch/x86/kernel/machine_kexec_64.c                 |    2 +
 arch/x86/kernel/process.c                          |   21 +-
 arch/x86/kernel/process_32.c                       |    6 +
 arch/x86/kernel/process_64.c                       |    7 +
 arch/x86/kernel/ptrace.c                           |  415 +++++--
 arch/x86/kernel/setup.c                            |    3 +
 arch/x86/kernel/signal.c                           |    9 -
 arch/x86/kernel/traps.c                            |   73 +-
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/lib/.gitignore                            |    1 +
 arch/x86/lib/Makefile                              |   13 +
 arch/x86/lib/inat.c                                |   90 ++
 arch/x86/lib/insn.c                                |  516 +++++++
 arch/x86/lib/x86-opcode-map.txt                    |  893 ++++++++++++
 arch/x86/mm/fault.c                                |   11 +-
 arch/x86/mm/kmmio.c                                |    8 +-
 arch/x86/power/cpu.c                               |   26 +-
 arch/x86/tools/Makefile                            |   31 +
 arch/x86/tools/chkobjdump.awk                      |   23 +
 arch/x86/tools/distill.awk                         |   47 +
 arch/x86/tools/gen-insn-attr-x86.awk               |  380 +++++
 arch/x86/tools/test_get_len.c                      |  173 +++
 drivers/edac/edac_mce_amd.c                        |   21 +-
 include/linux/ftrace_event.h                       |   38 +-
 include/linux/hw_breakpoint.h                      |  131 ++
 include/linux/kprobes.h                            |    2 +
 include/linux/perf_counter.h                       |    3 +
 include/linux/perf_event.h                         |   59 +-
 include/linux/syscalls.h                           |   77 +-
 include/linux/tracepoint.h                         |    6 +
 include/trace/define_trace.h                       |   11 +
 include/trace/events/bkl.h                         |   18 +-
 include/trace/events/block.h                       |  202 +--
 include/trace/events/ext4.h                        |  129 +--
 include/trace/events/irq.h                         |   52 +-
 include/trace/events/jbd2.h                        |   63 +-
 include/trace/events/kmem.h                        |  130 +--
 include/trace/events/{lockdep.h => lock.h}         |    8 +-
 include/trace/events/mce.h                         |   69 +
 include/trace/events/module.h                      |   22 +-
 include/trace/events/power.h                       |   38 +-
 include/trace/events/sched.h                       |  217 +--
 include/trace/events/signal.h                      |  173 +++
 include/trace/events/timer.h                       |   79 +-
 include/trace/events/workqueue.h                   |   22 +-
 include/trace/ftrace.h                             |  338 ++++-
 include/trace/syscall.h                            |   31 +-
 kernel/Makefile                                    |    2 +
 kernel/exit.c                                      |    5 +
 kernel/hw_breakpoint.c                             |  423 ++++++
 kernel/kallsyms.c                                  |    1 +
 kernel/kprobes.c                                   |   68 +-
 kernel/lockdep.c                                   |    2 +-
 kernel/notifier.c                                  |    2 +-
 kernel/perf_event.c                                |  627 ++++++---
 kernel/signal.c                                    |   27 +-
 kernel/trace/Kconfig                               |   38 +
 kernel/trace/Makefile                              |    2 +
 kernel/trace/ring_buffer.c                         |   15 +-
 kernel/trace/trace.h                               |   38 +-
 kernel/trace/trace_entries.h                       |   16 +
 kernel/trace/trace_event_profile.c                 |   43 +-
 kernel/trace/trace_events.c                        |  168 ++-
 kernel/trace/trace_events_filter.c                 |  310 +++--
 kernel/trace/trace_export.c                        |   39 +-
 kernel/trace/trace_kprobe.c                        | 1523 ++++++++++++++++++++
 kernel/trace/trace_ksym.c                          |  550 +++++++
 kernel/trace/trace_selftest.c                      |   55 +
 kernel/trace/trace_syscalls.c                      |  195 ++--
 samples/Kconfig                                    |    6 +
 samples/Makefile                                   |    3 +-
 samples/hw_breakpoint/Makefile                     |    1 +
 samples/hw_breakpoint/data_breakpoint.c            |   87 ++
 scripts/kernel-doc                                 |   15 +-
 tools/perf/.gitignore                              |    1 +
 tools/perf/Documentation/perf-bench.txt            |  120 ++
 tools/perf/Documentation/perf-buildid-list.txt     |   34 +
 tools/perf/Documentation/perf-kmem.txt             |   44 +
 tools/perf/Documentation/perf-probe.txt            |   49 +
 tools/perf/Documentation/perf-record.txt           |   16 +-
 tools/perf/Documentation/perf-report.txt           |    8 +-
 tools/perf/Documentation/perf-timechart.txt        |    5 +-
 tools/perf/Documentation/perf-trace-perl.txt       |  219 +++
 tools/perf/Documentation/perf-trace.txt            |   11 +-
 tools/perf/Makefile                                |  151 ++-
 tools/perf/bench/bench.h                           |   17 +
 tools/perf/bench/mem-memcpy.c                      |  193 +++
 tools/perf/bench/sched-messaging.c                 |  336 +++++
 tools/perf/bench/sched-pipe.c                      |  124 ++
 tools/perf/builtin-annotate.c                      |  885 ++----------
 tools/perf/builtin-bench.c                         |  196 +++
 tools/perf/builtin-buildid-list.c                  |  116 ++
 tools/perf/builtin-help.c                          |   16 +-
 tools/perf/builtin-kmem.c                          |  807 +++++++++++
 tools/perf/builtin-probe.c                         |  242 ++++
 tools/perf/builtin-record.c                        |  345 ++---
 tools/perf/builtin-report.c                        | 1147 +++------------
 tools/perf/builtin-sched.c                         |  351 ++---
 tools/perf/builtin-stat.c                          |   34 +-
 tools/perf/builtin-timechart.c                     |  267 ++--
 tools/perf/builtin-top.c                           |  503 ++++---
 tools/perf/builtin-trace.c                         |  418 ++++--
 tools/perf/builtin.h                               |    4 +
 tools/perf/command-list.txt                        |    4 +
 tools/perf/design.txt                              |    2 +
 tools/perf/perf.c                                  |   86 +-
 tools/perf/perf.h                                  |   12 +
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |  134 ++
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   41 +
 .../perf/scripts/perl/Perf-Trace-Util/Makefile.PL  |   17 +
 tools/perf/scripts/perl/Perf-Trace-Util/README     |   59 +
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |   55 +
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |  192 +++
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   88 ++
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
 tools/perf/scripts/perl/check-perf-trace.pl        |  106 ++
 tools/perf/scripts/perl/rw-by-file.pl              |  105 ++
 tools/perf/scripts/perl/rw-by-pid.pl               |  170 +++
 tools/perf/scripts/perl/wakeup-latency.pl          |  103 ++
 tools/perf/scripts/perl/workqueue-stats.pl         |  129 ++
 tools/perf/util/cache.h                            |   11 +-
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/callchain.h                        |    2 +-
 tools/perf/util/color.h                            |    6 +-
 tools/perf/util/ctype.c                            |    8 +
 tools/perf/util/data_map.c                         |  291 ++++
 tools/perf/util/data_map.h                         |   32 +
 tools/perf/util/debug.c                            |    4 +-
 tools/perf/util/debug.h                            |    9 +-
 tools/perf/util/debugfs.c                          |  241 +++
 tools/perf/util/debugfs.h                          |   25 +
 tools/perf/util/event.c                            |  312 ++++
 tools/perf/util/event.h                            |   75 +-
 tools/perf/util/exec_cmd.h                         |    6 +-
 tools/perf/util/header.c                           |  403 ++++--
 tools/perf/util/header.h                           |   76 +-
 tools/perf/util/help.h                             |    6 +-
 tools/perf/util/hist.c                             |  202 +++
 tools/perf/util/hist.h                             |   50 +
 tools/perf/util/include/asm/asm-offsets.h          |    1 +
 tools/perf/util/include/asm/bitops.h               |   18 +
 tools/perf/util/include/asm/bug.h                  |   22 +
 tools/perf/util/include/asm/byteorder.h            |    2 +
 tools/perf/util/include/asm/swab.h                 |    1 +
 tools/perf/util/include/asm/uaccess.h              |   14 +
 tools/perf/util/include/linux/bitmap.h             |    3 +
 tools/perf/util/include/linux/bitops.h             |   29 +
 tools/perf/util/include/linux/compiler.h           |   10 +
 tools/perf/util/include/linux/ctype.h              |    1 +
 tools/perf/util/include/linux/kernel.h             |   76 +
 tools/perf/util/include/linux/string.h             |    1 +
 tools/perf/util/include/linux/types.h              |    9 +
 tools/perf/util/levenshtein.h                      |    6 +-
 tools/perf/util/map.c                              |   99 ++-
 tools/perf/util/module.c                           |  545 -------
 tools/perf/util/module.h                           |   53 -
 tools/perf/util/parse-events.c                     |  155 ++-
 tools/perf/util/parse-events.h                     |    8 +-
 tools/perf/util/parse-options.h                    |    6 +-
 tools/perf/util/probe-event.c                      |  484 +++++++
 tools/perf/util/probe-event.h                      |   18 +
 tools/perf/util/probe-finder.c                     |  732 ++++++++++
 tools/perf/util/probe-finder.h                     |   57 +
 tools/perf/util/quote.h                            |    6 +-
 tools/perf/util/run-command.h                      |    6 +-
 tools/perf/util/sigchain.h                         |    6 +-
 tools/perf/util/sort.c                             |  290 ++++
 tools/perf/util/sort.h                             |   99 ++
 tools/perf/util/strbuf.h                           |    6 +-
 tools/perf/util/string.c                           |  194 +++
 tools/perf/util/string.h                           |   10 +-
 tools/perf/util/strlist.h                          |    6 +-
 tools/perf/util/svghelper.h                        |    6 +-
 tools/perf/util/symbol.c                           | 1193 ++++++++++++----
 tools/perf/util/symbol.h                           |   92 +-
 tools/perf/util/thread.c                           |  250 +++-
 tools/perf/util/thread.h                           |   50 +-
 tools/perf/util/trace-event-info.c                 |   26 +-
 tools/perf/util/trace-event-parse.c                |  573 ++++++--
 tools/perf/util/trace-event-perl.c                 |  598 ++++++++
 tools/perf/util/trace-event-perl.h                 |   51 +
 tools/perf/util/trace-event-read.c                 |   11 +-
 tools/perf/util/trace-event.h                      |   64 +-
 tools/perf/util/types.h                            |    6 +-
 tools/perf/util/util.h                             |   31 +-
 tools/perf/util/values.h                           |    6 +-
 tools/perf/util/wrapper.c                          |   61 +-
 251 files changed, 21092 insertions(+), 6102 deletions(-)
 create mode 100644 Documentation/trace/kprobetrace.txt
 create mode 100644 arch/powerpc/include/asm/trace.h
 create mode 100644 arch/x86/include/asm/hw_breakpoint.h
 create mode 100644 arch/x86/include/asm/inat.h
 create mode 100644 arch/x86/include/asm/inat_types.h
 create mode 100644 arch/x86/include/asm/insn.h
 create mode 100644 arch/x86/kernel/hw_breakpoint.c
 create mode 100644 arch/x86/lib/.gitignore
 create mode 100644 arch/x86/lib/inat.c
 create mode 100644 arch/x86/lib/insn.c
 create mode 100644 arch/x86/lib/x86-opcode-map.txt
 create mode 100644 arch/x86/tools/Makefile
 create mode 100644 arch/x86/tools/chkobjdump.awk
 create mode 100644 arch/x86/tools/distill.awk
 create mode 100644 arch/x86/tools/gen-insn-attr-x86.awk
 create mode 100644 arch/x86/tools/test_get_len.c
 create mode 100644 include/linux/hw_breakpoint.h
 rename include/trace/events/{lockdep.h => lock.h} (92%)
 create mode 100644 include/trace/events/mce.h
 create mode 100644 include/trace/events/signal.h
 create mode 100644 kernel/hw_breakpoint.c
 create mode 100644 kernel/trace/trace_kprobe.c
 create mode 100644 kernel/trace/trace_ksym.c
 create mode 100644 samples/hw_breakpoint/Makefile
 create mode 100644 samples/hw_breakpoint/data_breakpoint.c
 create mode 100644 tools/perf/Documentation/perf-bench.txt
 create mode 100644 tools/perf/Documentation/perf-buildid-list.txt
 create mode 100644 tools/perf/Documentation/perf-kmem.txt
 create mode 100644 tools/perf/Documentation/perf-probe.txt
 create mode 100644 tools/perf/Documentation/perf-trace-perl.txt
 create mode 100644 tools/perf/bench/bench.h
 create mode 100644 tools/perf/bench/mem-memcpy.c
 create mode 100644 tools/perf/bench/sched-messaging.c
 create mode 100644 tools/perf/bench/sched-pipe.c
 create mode 100644 tools/perf/builtin-bench.c
 create mode 100644 tools/perf/builtin-buildid-list.c
 create mode 100644 tools/perf/builtin-kmem.c
 create mode 100644 tools/perf/builtin-probe.c
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
 create mode 100644 tools/perf/util/data_map.c
 create mode 100644 tools/perf/util/data_map.h
 create mode 100644 tools/perf/util/debugfs.c
 create mode 100644 tools/perf/util/debugfs.h
 create mode 100644 tools/perf/util/event.c
 create mode 100644 tools/perf/util/hist.c
 create mode 100644 tools/perf/util/hist.h
 create mode 100644 tools/perf/util/include/asm/asm-offsets.h
 create mode 100644 tools/perf/util/include/asm/bitops.h
 create mode 100644 tools/perf/util/include/asm/bug.h
 create mode 100644 tools/perf/util/include/asm/byteorder.h
 create mode 100644 tools/perf/util/include/asm/swab.h
 create mode 100644 tools/perf/util/include/asm/uaccess.h
 create mode 100644 tools/perf/util/include/linux/bitmap.h
 create mode 100644 tools/perf/util/include/linux/bitops.h
 create mode 100644 tools/perf/util/include/linux/compiler.h
 create mode 100644 tools/perf/util/include/linux/ctype.h
 create mode 100644 tools/perf/util/include/linux/string.h
 create mode 100644 tools/perf/util/include/linux/types.h
 delete mode 100644 tools/perf/util/module.c
 delete mode 100644 tools/perf/util/module.h
 create mode 100644 tools/perf/util/probe-event.c
 create mode 100644 tools/perf/util/probe-event.h
 create mode 100644 tools/perf/util/probe-finder.c
 create mode 100644 tools/perf/util/probe-finder.h
 create mode 100644 tools/perf/util/sort.c
 create mode 100644 tools/perf/util/sort.h
 create mode 100644 tools/perf/util/trace-event-perl.c
 create mode 100644 tools/perf/util/trace-event-perl.h

[ diff is 900K, well above lkml limits. ]
