Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYLYMlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYLYMlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYLYMln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:41:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYLYMlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:41:42 -0500
Date: Thu, 25 Dec 2008 13:41:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [git pull] tracing updates for v2.6.29
Message-ID: <20081225124121.GA32165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

There was a lot of tracing development in this cycle, spread out between 
17 topic trees:

   tracing/blktrace         tracing/branch-tracer    tracing/core             
   tracing/fastboot         tracing/ftrace
   tracing/function-graph-tracer                     tracing/hw-branch-tracing
   tracing/markers          tracing/mmiotrace        tracing/nmisafe
   tracing/options          tracing/power-tracer     tracing/powerpc
   tracing/profiling        tracing/ring-buffer      tracing/stack-tracer
   tracing/tracepoints      
   
New tracing plugins: the function-graph-tracer, the (hardware-driven) 
branch tracer on x86 and the power-tracer. Lots of updates to various 
aspects of the infrastructure itself.

One of the most interesting ones is the new function graph tracer, which 
can trace all kernel functions and display/render their call graph in the 
following text format:

  $ cd /debug/tracing/
  $ echo function_graph > current_tracer
  $ tail -1000 trace

# tracer: function_graph
#
# CPU  OVERHEAD      FUNCTION CALLS
# |    |             |   |   |   |

  [...]
  5)               |  sys_write() {
  5)   0.378 us    |    fget_light();
  5)               |    vfs_write() {
  5)               |      rw_verify_area() {
  5)               |        security_file_permission() {
  5)               |          selinux_file_permission() {
  5)   0.344 us    |            avc_policy_seqno();
  5)   0.265 us    |            selinux_netlbl_inode_permission();
  5)   1.598 us    |          }
  5)   2.297 us    |        }
  5)   2.997 us    |      }
  5)               |      tty_write() {
  5)   0.405 us    |        tty_paranoia_check();
  5)               |        tty_ldisc_ref_wait() {
  5)               |          tty_ldisc_try() {
  5)   0.413 us    |            _spin_lock_irqsave();
  5)   0.276 us    |            _spin_unlock_irqrestore();
  5)   2.552 us    |          }

There's also various variants of this: it's dyn-ftrace capable (i.e. can 
be built into the kernel with near zero overhead in the disabled case and 
can be runtime enabled), it can filter to narrow down on interesting 
function names (and patterns), and has the ability to trace the a given 
set of functions (and all their child functions) - but no other function.

Note: three (smaller) x86 topics were merged into the tracing tree to 
resolve conflicts:

   x86/tsc      # incidental context conflict
   x86/ptrace   # BTS / hw-tracer semantic interaction
   x86/irq      # IRQ entry code changes and interaction with irq tracing

The x86 and the tracing tree can be pulled independently of each other and 
any combination of them will work fine. The diffstat below was done 
assuming that you already pulled the x86 tree.

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      profiling: clean up profile_nop()

Aneesh Kumar K.V (1):
      tracing: branch tracer, fix writing to trace/trace_options

Arjan van de Ven (1):
      tracing: add "power-tracer": C/P state tracer to help power optimization

Arnaldo Carvalho de Melo (2):
      markers: add missing stdargs.h include, needed due to va_list usage
      blktrace: port to tracepoints

Cyrill Gorcunov (1):
      x86: entry_64 - introduce FTRACE_ frame macro v2

Frederic Weisbecker (47):
      ftrace: add a script to produce a hierarchical view of a function trace
      tracing/fastboot: Enable boot tracing only during initcalls
      tracing/ftrace: fix a race condition in sched_switch tracer
      tracing/ftrace: remove unused code in sched_switch tracer
      tracing/fastboot: use sched switch tracer from boot tracer
      tracing/ftrace: types and naming corrections for sched tracer
      tracing/ftrace: fix a bug when switch current tracer to sched tracer
      tracing, x86: add low level support for ftrace return tracing
      tracing: add a tracer to catch execution time of kernel functions
      tracing/fastboot: move boot tracer structs and funcs into their own header.
      tracing/fastboot: Use the ring-buffer timestamp for initcall entries
      tracing/function-return-tracer: make the function return tracer lockless
      tracing/function-return-tracer: call prepare_ftrace_return by registers
      tracing/ftrace: fix unexpected -EINVAL when longest tracer name is set
      tracing/ftrace: change the type of the init() callback
      tracing/branch-tracer: fix a trace recursion on branch tracer
      tracing/function-return-tracer: add a barrier to ensure return stack index is incremented in memory
      tracing/function-return-tracer: support for dynamic ftrace on function return tracer
      tracing/ftrace: implement a set_flag callback for tracers
      tracing/ftrace: make nop tracer using tracer flags
      tracing/function-return-tracer: add the overrun field
      tracing/function-return-tracer: store return stack into task_struct and allocate it dynamically
      tracing/function-return-tracer: don't trace kfree while it frees the return stack
      tracing/function-return-tracer: free the return stack on free_task()
      tracing/function-return-tracer: change the name into function-graph-tracer
      tracing/function-return-tracer: set a more human readable output
      tracing/function-graph-tracer: enhancements for the trace output
      tracing/function-graph-tracer: adjustments of the trace informations
      tracing/branch-tracer: include missing irqflags.h
      tracing/function-graph-tracer: support for x86-64
      tracing/function-graph-tracer: display unified style cmdline and pid
      tracing/function-graph-tracer: improve duration output
      tracing/function-graph-tracer: handle ftrace_printk entries
      tracing/ftrace: don't insert TRACE_PRINT during selftests
      tracing/ftrace: fix the check of ftrace_trace_task
      tracing/ftrace: provide the macro task_curr_ret_stack()
      tracing/function-graph-tracer: implement a print_headers function
      tracing/function-graph-tracer: introduce __notrace_funcgraph to filter special functions
      tracing/function-graph-tracer: turn tracing_selftest_running into an int
      tracing/function-graph-tracer: append the tracing_graph_flag
      tracing/fastboot: include missing headers
      tracing/function-graph-tracer: add a new .irqentry.text section
      tracing/function-graph-tracer: annotate do_IRQ and smp_apic_timer_interrupt
      tracing/function-graph-tracer: Output arrows signal on hardirq call/return
      tracing/ftrace: use preempt_enable_no_resched_notrace in ring_buffer_time_stamp()
      tracing/ftrace: add the printk-msg-only option
      tracing/ftrace: don't trace on early stage of a secondary cpu boot, v3

Heiko Carstens (1):
      ftrace: preemptoff selftest not working

Ingo Molnar (25):
      Merge branches 'tracing/ftrace' and 'tracing/urgent' into tracing/core
      tracing, x86: clean up FUNCTION_RET_TRACER Kconfig
      tracing, x86: function return tracer, fix assembly constraints
      tracing: function return tracer, build fix
      tracing: branch tracer, tweak output
      tracing: branch tracer, fix vdso crash
      tracing: finetune branch-tracer output
      tracepoints: format documentation
      markers/tracpoints: fix non-modular build
      ftrace: fix selftest locking
      tracing/function-return-tracer: clean up task start/exit callbacks
      tracing: allow tracing of suspend/resume & hibernation code again
      tracing, tty: fix warnings caused by branch tracing and tty_kref_get()
      tracing: function graph tracer, fix
      blktrace: port to tracepoints, update
      tracing/function-graph-tracer: more output tweaks
      vfs, seqfile: export mangle_path() generally
      tracing/function-graph-tracer: enabled by default
      tracing: fix typo and missing inline function
      tracing/function-graph-tracer: fix 'flags' variable mismatch
      x86, bts: fix build error
      tracing/function-graph-tracer: add a new .irqentry.text section, fix
      tracing: fix warning in kernel/trace/trace.c
      tracing: fix warnings in kernel/trace/trace_sched_switch.c
      Revert "x86: disable X86_PTRACE_BTS"

Jim Radford (1):
      ftrace: scripts/recordmcount.pl support for ARM

Lai Jiangshan (8):
      markers: simplify marker_set_format()
      markers: remove exported symbol marker_probe_cb_noarg()
      markers: let marker_table be close to its comments
      tracepoint: simplification for tracepoints using RCU
      tracepoint: introduce *_noupdate APIs.
      ring_buffer: fix comments
      tracing/ring-buffer: remove unused ring_buffer size
      ftrace: enable format arguments checking

Liming Wang (4):
      ftrace: adding other non-leaving .text sections
      ftrace: improve seq_operation of ftrace
      function trace: fix a bug of single thread function trace
      ftrace: avoid duplicated function when writing set_graph_function

Markus Metzger (11):
      x86, bts: base in-kernel ds interface on handles
      x86, bts, ptrace: move BTS buffer allocation from ds.c into ptrace.c
      x86, ftrace: call trace->open() before stopping tracing; add trace->print_header()
      x86, bts, ftrace: a BTS ftrace plug-in prototype
      x86, bts: turn BUG_ON into WARN_ON_ONCE
      x86, bts: provide in-kernel branch-trace interface
      x86, bts, ftrace: adapt the hw-branch-tracer to the ds.c interface
      x86, bts: remove recursion from get_context
      x86, bts: correctly report invalid bts records
      x86, bts: add fork and exit handling
      x86, bts: memory accounting

Mathieu Desnoyers (15):
      rcu: add rcu_read_*_sched_notrace()
      markers: fix unregister
      markers: use rcu_*_sched_notrace and notrace
      markers: use module notifier
      markers: auto enable tracepoints (new API : trace_mark_tp())
      markers: create DEFINE_MARKER and GET_MARKER (new API)
      tracepoints: samples, fix teardown
      tracepoints: fix disable
      tracepoints: use rcu_*_sched_notrace
      tracepoints: use unregister return value
      tracepoints: do not put arguments in name
      tracepoints: use modules notifiers
      tracepoints: add DECLARE_TRACE() and DEFINE_TRACE()
      tracepoints: documentation fix for teardown
      tracepoints, docs: marker_synchronize_unregister->tracepoint_synchronize_unregister

Matt Fleming (3):
      ftrace: align __mcount_loc sections
      sh: dynamic ftrace support.
      ftrace: specify $alignment for sh architecture

Nikanth Karthikesan (1):
      tracepoints: Documentation TPPROTO misspelt in Documentation/tracepoints.txt

Pekka J Enberg (1):
      ftrace: introduce tracing_reset_online_cpus() helper

Pekka Paalanen (1):
      trace: add the MMIO-tracer to the tracer menu, cleanup

Peter Zijlstra (5):
      ftrace: ftrace_dump_on_oops=[tracer]
      ftrace: sysrq-z to dump the buffers
      ftrace: sysctl typo
      sched: fix tracepoints in scheduler
      sched, trace: update trace_sched_wakeup()

Stephen Hemminger (2):
      tracing/fastboot: fix perlcritic warning
      tracing/fastboot: put error message on stderr

Stephen Rothwell (1):
      tracing/fastboot: fix len of func buffer

Steven Rostedt (94):
      ftrace: ftrace dump on oops control
      ftrace: nmi safe code modification
      ftrace: nmi update statistics
      ftrace, kbuild: condense recordmcount.pl parameter code
      ftrace: nmi safe code clean ups
      ftrace: fix hardirq header for non ftrace archs
      ftrace: introduce ftrace_preempt_disable()/enable()
      ftrace: insert in the ftrace_preempt_disable()/enable() functions
      ftrace: function tracer with irqs disabled
      ftrace: add quick function trace stop
      ftrace: soft tracing stop and start
      ftrace: restructure tracing start/stop infrastructure
      ring-buffer: convert to raw spinlocks
      ftrace: split out hardirq ftrace code into own header
      ftrace: fix set_ftrace_filter
      ftrace: fix boot trace sched startup
      ftrace: fix sched_switch API
      ftrace: irqsoff tracer incorrect reset
      ftrace: enable trace_printk by default
      ftrace: remove ctrl_update method
      ftrace: remove trace array ctrl
      ftrace: force pass of preemptoff selftest
      ftrace: display start of CPU buffer in trace output
      ftrace: prevent ftrace_special from recursion
      ring-buffer: replace most bug ons with warn on and disable buffer
      ring-buffer: add reader lock
      ring-buffer: clean up warn ons
      ring-buffer: fix deadlock from reader_lock in read_start
      tracing: profile likely and unlikely annotations
      tracing: likely/unlikely branch annotation tracer
      trace: rename unlikely profiler to branch profiler
      ftrace: rename unlikely iter_ctrl to branch
      ftrace: add tracer called branch
      ftrace: rename trace_unlikely.c file
      ftrace: rename trace_entries to buffer_size_kb
      ftrace: show buffer size in kilobytes
      ftrace: rename iter_ctrl to trace_options
      ftrace: CPU buffer start annotation clean ups
      ftrace: remove condition from ftrace_record_ip
      ftrace: disable ftrace on anomalies in trace start and stop
      ftrace: do not process freed records
      ftrace: replace raw_local_irq_save with local_irq_save
      ftrace: pass module struct to arch dynamic ftrace functions
      ftrace: allow NULL pointers in mcount_loc
      ftrace: fix dyn ftrace filter
      ftrace: make filtered functions effective on setting
      powerpc: ftrace, do not latency trace idle
      powerpc: ftrace, convert to new dynamic ftrace arch API
      powerpc: ftrace, use probe_kernel API to modify code
      powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
      powerpc/ppc32: ftrace, dynamic ftrace to handle modules
      ftrace: add support for powerpc to recordmcount.pl script
      ftrace: create default variables for archs in recordmcount.pl
      trace: remove extra assign in branch check
      trace: consolidate unlikely and likely profiler
      trace: branch profiling should not print percent without data
      trace: profile all if conditionals
      ring-buffer: add tracing_off_permanent
      ftrace: add ftrace_off_permanent
      trace: fix compiler warning in branch profiler
      ftrace: add function tracing to single thread
      ftrace: use code patching for ftrace graph tracer
      ftrace: let function tracing and function return run together
      ftrace: add thread comm to function graph tracer
      ftrace: add cpu annotation for function graph tracer
      powerpc: ftrace, do nothing in mcount call for dyn ftrace
      powerpc: ftrace, fix cast aliasing and add code verification
      powerpc: ftrace, added missing icache flush
      powerpc: ftrace, use create_branch
      powerpc/ppc32: static ftrace fixes for PPC32
      ftrace: replace raw_local_irq_save with local_irq_save
      ring-buffer: move some metadata into buffer page
      ring-buffer: read page interface
      ftrace: clean up function graph asm
      ftrace: have function graph use mcount caller address
      ftrace: add ftrace_graph_stop()
      ring-buffer: change "page" variable names to "bpage"
      ftrace: print real return in dumpstack for function graph
      ftrace: function graph return for function entry
      ftrace: add checks on ret stack in function graph
      trace: fix output of stack trace
      ftrace: fix race in function graph during fork
      ftrace: graph of a single function
      ftrace: use task struct trace flag to filter on pid
      ftrace: trace single pid for function graph tracer
      pid: fix the do_each_pid_task() macro
      ftrace: use struct pid
      ftrace: add ability to only trace swapper tasks
      ftrace: use init_struct_pid as swapper pid
      trace: add a way to enable or disable the stack tracer
      trace: better use of stack_trace_enabled for boot up code
      ftrace: add not to regex on filtering functions
      ring-buffer: fix dangling commit race
      ring-buffer: prevent false positive warning

Thomas Gleixner (1):
      trace: fix task state printout

Török Edwin (9):
      tracing: add support for userspace stacktraces in tracing/iter_ctrl
      vfs, seqfile: make mangle_path() global
      tracing: identify which executable object the userspace address belongs to
      tracing/stack-tracer: fix style issues
      tracing/stack-tracer: fix locking and refcounts
      tracing/stack-tracer: introduce CONFIG_USER_STACKTRACE_SUPPORT
      tracing/stack-tracer: avoid races accessing file
      vfs, seqfile: fix comment style on mangle_path
      tracing, alpha: fix build: add missing #ifdef CONFIG_STACKTRACE

Will Newton (1):
      init/main.c: use ktime accessor function in initcall_debug code

Wu Fengguang (1):
      markers: comment marker_synchronize_unregister() on data dependency

Zhaolei (1):
      markers: break the redundant loop in kernel/marker.c

walimis (2):
      ftrace: remove unnecessary if condition of __unregister_ftrace_function
      ftrace: improve documentation


 Documentation/ftrace.txt                       |  149 +++-
 Documentation/kernel-parameters.txt            |   12 +
 Documentation/markers.txt                      |   29 +-
 Documentation/tracepoints.txt                  |   94 ++-
 arch/powerpc/include/asm/ftrace.h              |   14 +-
 arch/powerpc/include/asm/module.h              |   16 +-
 arch/powerpc/kernel/Makefile                   |    1 +
 arch/powerpc/kernel/entry_32.S                 |   40 +-
 arch/powerpc/kernel/entry_64.S                 |   12 -
 arch/powerpc/kernel/ftrace.c                   |  461 +++++++++-
 arch/powerpc/kernel/idle.c                     |    5 +
 arch/powerpc/kernel/module_32.c                |   10 +
 arch/powerpc/kernel/module_64.c                |   13 +
 arch/powerpc/lib/Makefile                      |    3 +
 arch/x86/Kconfig                               |    3 +
 arch/x86/Kconfig.cpu                           |    2 +-
 arch/x86/Kconfig.debug                         |    4 -
 arch/x86/include/asm/ds.h                      |  312 ++++---
 arch/x86/include/asm/ftrace.h                  |   61 ++-
 arch/x86/include/asm/msr.h                     |    3 +-
 arch/x86/include/asm/processor.h               |   13 +
 arch/x86/include/asm/ptrace.h                  |   43 +-
 arch/x86/include/asm/thread_info.h             |    7 +-
 arch/x86/kernel/Makefile                       |    1 +
 arch/x86/kernel/apic.c                         |    3 +-
 arch/x86/kernel/cpu/Makefile                   |    5 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c     |    4 +
 arch/x86/kernel/cpu/intel.c                    |    4 -
 arch/x86/kernel/ds.c                           | 1138 +++++++++++++-----------
 arch/x86/kernel/dumpstack.c                    |   34 +-
 arch/x86/kernel/dumpstack.h                    |    2 +-
 arch/x86/kernel/dumpstack_32.c                 |    5 +-
 arch/x86/kernel/dumpstack_64.c                 |    7 +-
 arch/x86/kernel/entry_32.S                     |   51 +-
 arch/x86/kernel/entry_64.S                     |   98 ++-
 arch/x86/kernel/ftrace.c                       |  390 ++++++++-
 arch/x86/kernel/irq_64.c                       |    3 +-
 arch/x86/kernel/process.c                      |   16 +
 arch/x86/kernel/process_32.c                   |   67 +--
 arch/x86/kernel/process_64.c                   |   58 +-
 arch/x86/kernel/ptrace.c                       |  431 ++++------
 arch/x86/kernel/smpboot.c                      |    2 +-
 arch/x86/kernel/stacktrace.c                   |   64 ++
 arch/x86/kernel/vmlinux_32.lds.S               |    1 +
 arch/x86/kernel/vmlinux_64.lds.S               |    1 +
 arch/x86/kernel/vsyscall_64.c                  |    3 +
 arch/x86/mm/Makefile                           |    3 +-
 arch/x86/mm/fault.c                            |    2 +-
 arch/x86/vdso/vclock_gettime.c                 |    3 +
 block/Kconfig                                  |    1 +
 block/blk-core.c                               |   46 +-
 block/blktrace.c                               |  332 +++++++-
 block/elevator.c                               |   12 +-
 drivers/char/sysrq.c                           |   18 +-
 drivers/md/dm.c                                |    8 +-
 fs/bio.c                                       |    5 +-
 fs/seq_file.c                                  |   14 +-
 include/asm-generic/vmlinux.lds.h              |   31 +-
 include/linux/blktrace_api.h                   |  172 +----
 include/linux/compiler.h                       |   84 ++-
 include/linux/ftrace.h                         |  293 ++++++-
 include/linux/ftrace_irq.h                     |   13 +
 include/linux/hardirq.h                        |   15 +-
 include/linux/marker.h                         |   75 ++-
 include/linux/mm.h                             |    2 +
 include/linux/pid.h                            |    4 +-
 include/linux/ptrace.h                         |   22 +
 include/linux/rcupdate.h                       |    2 +
 include/linux/ring_buffer.h                    |   16 +-
 include/linux/sched.h                          |   31 +
 include/linux/seq_file.h                       |    1 +
 include/linux/stacktrace.h                     |    8 +
 include/linux/tracepoint.h                     |   57 +-
 include/linux/tty.h                            |    2 +-
 include/trace/block.h                          |   76 ++
 include/trace/boot.h                           |   60 ++
 include/trace/sched.h                          |   36 +-
 init/Kconfig                                   |    1 +
 init/main.c                                    |   35 +-
 kernel/exit.c                                  |    5 +-
 kernel/extable.c                               |    5 +-
 kernel/fork.c                                  |   14 +-
 kernel/kthread.c                               |    3 +
 kernel/lockdep.c                               |    1 +
 kernel/marker.c                                |  192 +++--
 kernel/module.c                                |   13 +-
 kernel/power/disk.c                            |   13 +-
 kernel/power/main.c                            |    5 +-
 kernel/profile.c                               |    2 +-
 kernel/ptrace.c                                |   12 +
 kernel/sched.c                                 |   14 +-
 kernel/signal.c                                |    2 +
 kernel/sysctl.c                                |   20 +
 kernel/trace/Kconfig                           |  115 +++-
 kernel/trace/Makefile                          |    9 +
 kernel/trace/ftrace.c                          |  929 +++++++++++++++++---
 kernel/trace/ring_buffer.c                     |  709 +++++++++++-----
 kernel/trace/trace.c                           |  976 +++++++++++++++++----
 kernel/trace/trace.h                           |  265 ++++++-
 kernel/trace/trace_boot.c                      |  158 +++-
 kernel/trace/trace_branch.c                    |  342 +++++++
 kernel/trace/trace_functions.c                 |   30 +-
 kernel/trace/trace_functions_graph.c           |  669 ++++++++++++++
 kernel/trace/trace_hw_branches.c               |  195 ++++
 kernel/trace/trace_irqsoff.c                   |   61 +-
 kernel/trace/trace_mmiotrace.c                 |   33 +-
 kernel/trace/trace_nop.c                       |   65 ++-
 kernel/trace/trace_power.c                     |  179 ++++
 kernel/trace/trace_sched_switch.c              |  121 ++-
 kernel/trace/trace_sched_wakeup.c              |   72 +-
 kernel/trace/trace_selftest.c                  |  173 +++-
 kernel/trace/trace_stack.c                     |   70 ++-
 kernel/trace/trace_sysprof.c                   |   31 +-
 kernel/tracepoint.c                            |  295 ++++---
 mm/bounce.c                                    |    5 +-
 mm/mlock.c                                     |   45 +
 samples/tracepoints/tp-samples-trace.h         |    4 +-
 samples/tracepoints/tracepoint-probe-sample.c  |    1 +
 samples/tracepoints/tracepoint-probe-sample2.c |    1 +
 samples/tracepoints/tracepoint-sample.c        |    3 +
 scripts/Makefile.build                         |   12 +-
 scripts/bootgraph.pl                           |   16 +-
 scripts/recordmcount.pl                        |   51 +-
 scripts/trace/power.pl                         |  108 +++
 scripts/tracing/draw_functrace.py              |  130 +++
 125 files changed, 8742 insertions(+), 2607 deletions(-)
 create mode 100644 include/linux/ftrace_irq.h
 create mode 100644 include/trace/block.h
 create mode 100644 include/trace/boot.h
 create mode 100644 kernel/trace/trace_branch.c
 create mode 100644 kernel/trace/trace_functions_graph.c
 create mode 100644 kernel/trace/trace_hw_branches.c
 create mode 100644 kernel/trace/trace_power.c
 create mode 100644 scripts/trace/power.pl
 create mode 100644 scripts/tracing/draw_functrace.py
