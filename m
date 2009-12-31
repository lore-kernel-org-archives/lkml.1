Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZLaL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZLaL5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZLaL5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:57:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZLaL5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:57:19 -0500
Date: Thu, 31 Dec 2009 12:55:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091231115515.GA17279@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Lai Jiangshan (3):
      tracing/kprobe: Show sign of fields in trace_kprobe format files
      tracing/syscalls: Fix typo in SYSCALL_DEFINE0
      tracing: Fix sign fields in ftrace_define_fields_##call()

Li Zefan (4):
      ksym_tracer: Fix to make the tracer work
      ksym_tracer: Fix to allow writing newline to ksym_trace_filter
      ksym_tracer: Fix race when incrementing count
      ksym_tracer: Remove trace_stat

Randy Dunlap (4):
      Documentation: Update mmiotrace.txt
      Documentation: Update tracepoint-analysis.txt
      Documentation: Update ftrace-design.txt
      tracing: Kconfig spelling fixes and cleanups

Steven Rostedt (1):
      tracing: Fix setting tracer specific options


 Documentation/trace/ftrace-design.txt       |   14 ++--
 Documentation/trace/mmiotrace.txt           |   15 ++--
 Documentation/trace/tracepoint-analysis.txt |   60 ++++++------
 include/linux/syscalls.h                    |    2 +-
 include/trace/ftrace.h                      |    7 +-
 kernel/hw_breakpoint.c                      |   10 ++-
 kernel/trace/Kconfig                        |  112 +++++++++++-----------
 kernel/trace/trace.c                        |    2 +-
 kernel/trace/trace_export.c                 |    7 +-
 kernel/trace/trace_kprobe.c                 |    7 +-
 kernel/trace/trace_ksym.c                   |  140 +++++++++++----------------
 11 files changed, 179 insertions(+), 197 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 641a1ef..239f14b 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -53,14 +53,14 @@ size of the mcount call that is embedded in the function).
 For example, if the function foo() calls bar(), when the bar() function calls
 mcount(), the arguments mcount() will pass to the tracer are:
 	"frompc" - the address bar() will use to return to foo()
-	"selfpc" - the address bar() (with _mcount() size adjustment)
+	"selfpc" - the address bar() (with mcount() size adjustment)
 
 Also keep in mind that this mcount function will be called *a lot*, so
 optimizing for the default case of no tracer will help the smooth running of
 your system when tracing is disabled.  So the start of the mcount function is
-typically the bare min with checking things before returning.  That also means
-the code flow should usually kept linear (i.e. no branching in the nop case).
-This is of course an optimization and not a hard requirement.
+typically the bare minimum with checking things before returning.  That also
+means the code flow should usually be kept linear (i.e. no branching in the nop
+case).  This is of course an optimization and not a hard requirement.
 
 Here is some pseudo code that should help (these functions should actually be
 implemented in assembly):
@@ -131,10 +131,10 @@ some functions to save (hijack) and restore the return address.
 
 The mcount function should check the function pointers ftrace_graph_return
 (compare to ftrace_stub) and ftrace_graph_entry (compare to
-ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
+ftrace_graph_entry_stub).  If either of those is not set to the relevant stub
 function, call the arch-specific function ftrace_graph_caller which in turn
 calls the arch-specific function prepare_ftrace_return.  Neither of these
-function names are strictly required, but you should use them anyways to stay
+function names is strictly required, but you should use them anyway to stay
 consistent across the architecture ports -- easier to compare & contrast
 things.
 
@@ -144,7 +144,7 @@ but the first argument should be a pointer to the "frompc".  Typically this is
 located on the stack.  This allows the function to hijack the return address
 temporarily to have it point to the arch-specific function return_to_handler.
 That function will simply call the common ftrace_return_to_handler function and
-that will return the original return address with which, you can return to the
+that will return the original return address with which you can return to the
 original call site.
 
 Here is the updated mcount pseudo code:
diff --git a/Documentation/trace/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
index 162effb..664e738 100644
--- a/Documentation/trace/mmiotrace.txt
+++ b/Documentation/trace/mmiotrace.txt
@@ -44,7 +44,8 @@ Check for lost events.
 Usage
 -----
 
-Make sure debugfs is mounted to /sys/kernel/debug. If not, (requires root privileges)
+Make sure debugfs is mounted to /sys/kernel/debug.
+If not (requires root privileges):
 $ mount -t debugfs debugfs /sys/kernel/debug
 
 Check that the driver you are about to trace is not loaded.
@@ -91,7 +92,7 @@ $ dmesg > dmesg.txt
 $ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
 and then send the .tar.gz file. The trace compresses considerably. Replace
 "pciid" and "nick" with the PCI ID or model name of your piece of hardware
-under investigation and your nick name.
+under investigation and your nickname.
 
 
 How Mmiotrace Works
@@ -100,7 +101,7 @@ How Mmiotrace Works
 Access to hardware IO-memory is gained by mapping addresses from PCI bus by
 calling one of the ioremap_*() functions. Mmiotrace is hooked into the
 __ioremap() function and gets called whenever a mapping is created. Mapping is
-an event that is recorded into the trace log. Note, that ISA range mappings
+an event that is recorded into the trace log. Note that ISA range mappings
 are not caught, since the mapping always exists and is returned directly.
 
 MMIO accesses are recorded via page faults. Just before __ioremap() returns,
@@ -122,11 +123,11 @@ Trace Log Format
 ----------------
 
 The raw log is text and easily filtered with e.g. grep and awk. One record is
-one line in the log. A record starts with a keyword, followed by keyword
-dependant arguments. Arguments are separated by a space, or continue until the
+one line in the log. A record starts with a keyword, followed by keyword-
+dependent arguments. Arguments are separated by a space, or continue until the
 end of line. The format for version 20070824 is as follows:
 
-Explanation	Keyword	Space separated arguments
+Explanation	Keyword	Space-separated arguments
 ---------------------------------------------------------------------------
 
 read event	R	width, timestamp, map id, physical, value, PC, PID
@@ -136,7 +137,7 @@ iounmap event	UNMAP	timestamp, map id, PC, PID
 marker		MARK	timestamp, text
 version		VERSION	the string "20070824"
 info for reader	LSPCI	one line from lspci -v
-PCI address map	PCIDEV	space separated /proc/bus/pci/devices data
+PCI address map	PCIDEV	space-separated /proc/bus/pci/devices data
 unk. opcode	UNKNOWN	timestamp, map id, physical, data, PC, PID
 
 Timestamp is in seconds with decimals. Physical is a PCI bus address, virtual
diff --git a/Documentation/trace/tracepoint-analysis.txt b/Documentation/trace/tracepoint-analysis.txt
index 5eb4e48..87bee3c 100644
--- a/Documentation/trace/tracepoint-analysis.txt
+++ b/Documentation/trace/tracepoint-analysis.txt
@@ -10,8 +10,8 @@ Tracepoints (see Documentation/trace/tracepoints.txt) can be used without
 creating custom kernel modules to register probe functions using the event
 tracing infrastructure.
 
-Simplistically, tracepoints will represent an important event that when can
-be taken in conjunction with other tracepoints to build a "Big Picture" of
+Simplistically, tracepoints represent important events that can be
+taken in conjunction with other tracepoints to build a "Big Picture" of
 what is going on within the system. There are a large number of methods for
 gathering and interpreting these events. Lacking any current Best Practises,
 this document describes some of the methods that can be used.
@@ -33,12 +33,12 @@ calling
 
 will give a fair indication of the number of events available.
 
-2.2 PCL
+2.2 PCL (Performance Counters for Linux)
 -------
 
-Discovery and enumeration of all counters and events, including tracepoints
+Discovery and enumeration of all counters and events, including tracepoints,
 are available with the perf tool. Getting a list of available events is a
-simple case of
+simple case of:
 
   $ perf list 2>&1 | grep Tracepoint
   ext4:ext4_free_inode                     [Tracepoint event]
@@ -49,19 +49,19 @@ simple case of
   [ .... remaining output snipped .... ]
 
 
-2. Enabling Events
+3. Enabling Events
 ==================
 
-2.1 System-Wide Event Enabling
+3.1 System-Wide Event Enabling
 ------------------------------
 
 See Documentation/trace/events.txt for a proper description on how events
 can be enabled system-wide. A short example of enabling all events related
-to page allocation would look something like
+to page allocation would look something like:
 
   $ for i in `find /sys/kernel/debug/tracing/events -name "enable" | grep mm_`; do echo 1 > $i; done
 
-2.2 System-Wide Event Enabling with SystemTap
+3.2 System-Wide Event Enabling with SystemTap
 ---------------------------------------------
 
 In SystemTap, tracepoints are accessible using the kernel.trace() function
@@ -86,7 +86,7 @@ were allocating the pages.
           print_count()
   }
 
-2.3 System-Wide Event Enabling with PCL
+3.3 System-Wide Event Enabling with PCL
 ---------------------------------------
 
 By specifying the -a switch and analysing sleep, the system-wide events
@@ -107,16 +107,16 @@ for a duration of time can be examined.
 Similarly, one could execute a shell and exit it as desired to get a report
 at that point.
 
-2.4 Local Event Enabling
+3.4 Local Event Enabling
 ------------------------
 
 Documentation/trace/ftrace.txt describes how to enable events on a per-thread
 basis using set_ftrace_pid.
 
-2.5 Local Event Enablement with PCL
+3.5 Local Event Enablement with PCL
 -----------------------------------
 
-Events can be activate and tracked for the duration of a process on a local
+Events can be activated and tracked for the duration of a process on a local
 basis using PCL such as follows.
 
   $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -131,18 +131,18 @@ basis using PCL such as follows.
 
     0.973913387  seconds time elapsed
 
-3. Event Filtering
+4. Event Filtering
 ==================
 
 Documentation/trace/ftrace.txt covers in-depth how to filter events in
 ftrace.  Obviously using grep and awk of trace_pipe is an option as well
 as any script reading trace_pipe.
 
-4. Analysing Event Variances with PCL
+5. Analysing Event Variances with PCL
 =====================================
 
 Any workload can exhibit variances between runs and it can be important
-to know what the standard deviation in. By and large, this is left to the
+to know what the standard deviation is. By and large, this is left to the
 performance analyst to do it by hand. In the event that the discrete event
 occurrences are useful to the performance analyst, then perf can be used.
 
@@ -166,7 +166,7 @@ In the event that some higher-level event is required that depends on some
 aggregation of discrete events, then a script would need to be developed.
 
 Using --repeat, it is also possible to view how events are fluctuating over
-time on a system wide basis using -a and sleep.
+time on a system-wide basis using -a and sleep.
 
   $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
 		-e kmem:mm_pagevec_free \
@@ -180,7 +180,7 @@ time on a system wide basis using -a and sleep.
 
     1.002251757  seconds time elapsed   ( +-   0.005% )
 
-5. Higher-Level Analysis with Helper Scripts
+6. Higher-Level Analysis with Helper Scripts
 ============================================
 
 When events are enabled the events that are triggering can be read from
@@ -190,11 +190,11 @@ be gathered on-line as appropriate. Examples of post-processing might include
 
   o Reading information from /proc for the PID that triggered the event
   o Deriving a higher-level event from a series of lower-level events.
-  o Calculate latencies between two events
+  o Calculating latencies between two events
 
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl is an example
 script that can read trace_pipe from STDIN or a copy of a trace. When used
-on-line, it can be interrupted once to generate a report without existing
+on-line, it can be interrupted once to generate a report without exiting
 and twice to exit.
 
 Simplistically, the script just reads STDIN and counts up events but it
@@ -212,12 +212,12 @@ also can do more such as
     processes, the parent process responsible for creating all the helpers
     can be identified
 
-6. Lower-Level Analysis with PCL
+7. Lower-Level Analysis with PCL
 ================================
 
-There may also be a requirement to identify what functions with a program
+There may also be a requirement to identify what functions within a program
 were generating events within the kernel. To begin this sort of analysis, the
-data must be recorded. At the time of writing, this required root
+data must be recorded. At the time of writing, this required root:
 
   $ perf record -c 1 \
 	-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -253,11 +253,11 @@ perf report.
   # (For more details, try: perf report --sort comm,dso,symbol)
   #
 
-According to this, the vast majority of events occured triggered on events
-within the VDSO. With simple binaries, this will often be the case so lets
+According to this, the vast majority of events triggered on events
+within the VDSO. With simple binaries, this will often be the case so let's
 take a slightly different example. In the course of writing this, it was
-noticed that X was generating an insane amount of page allocations so lets look
-at it
+noticed that X was generating an insane amount of page allocations so let's look
+at it:
 
   $ perf record -c 1 -f \
 		-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -280,8 +280,8 @@ This was interrupted after a few seconds and
   # (For more details, try: perf report --sort comm,dso,symbol)
   #
 
-So, almost half of the events are occuring in a library. To get an idea which
-symbol.
+So, almost half of the events are occurring in a library. To get an idea which
+symbol:
 
   $ perf report --sort comm,dso,symbol
   # Samples: 27666
@@ -297,7 +297,7 @@ symbol.
        0.01%     Xorg  /opt/gfx-test/lib/libpixman-1.so.0.13.1  [.] get_fast_path
        0.00%     Xorg  [kernel]                                 [k] ftrace_trace_userstack
 
-To see where within the function pixmanFillsse2 things are going wrong
+To see where within the function pixmanFillsse2 things are going wrong:
 
   $ perf annotate pixmanFillsse2
   [ ... ]
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 65793e9..207466a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -195,7 +195,7 @@ struct perf_event_attr;
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta_##sname = {				\
+	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7352315..c6fe03e 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -414,7 +414,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0, FILTER_OTHER);	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -422,8 +423,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #define __dynamic_array(type, item, len)				       \
 	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
 				 offsetof(typeof(field), __data_loc_##item),   \
-				 sizeof(field.__data_loc_##item), 0,	       \
-				 FILTER_OTHER);
+				 sizeof(field.__data_loc_##item),	       \
+				 is_signed_type(type), FILTER_OTHER);
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 366eedf..48fb0bb 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -40,6 +40,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
@@ -388,7 +389,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 	if (!cpu_events)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_possible_cpu(cpu) {
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
 		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
 
@@ -399,18 +401,20 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			goto fail;
 		}
 	}
+	put_online_cpus();
 
 	return cpu_events;
 
 fail:
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
 		if (IS_ERR(*pevent))
 			break;
 		unregister_hw_breakpoint(*pevent);
 	}
+	put_online_cpus();
+
 	free_percpu(cpu_events);
-	/* return the error if any */
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d006554..6c22d8a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -12,17 +12,17 @@ config NOP_TRACER
 config HAVE_FTRACE_NMI_ENTER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_TRACER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
@@ -34,17 +34,17 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_DYNAMIC_FTRACE
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_HW_BRANCH_TRACER
 	bool
@@ -52,7 +52,7 @@ config HAVE_HW_BRANCH_TRACER
 config HAVE_SYSCALL_TRACEPOINTS
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config TRACER_MAX_TRACE
 	bool
@@ -83,7 +83,7 @@ config RING_BUFFER_ALLOW_SWAP
 # This allows those options to appear when no other tracer is selected. But the
 # options do not appear when something else selects it. We need the two options
 # GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
-# hidding of the automatic options.
+# hiding of the automatic options.
 
 config TRACING
 	bool
@@ -119,7 +119,7 @@ menuconfig FTRACE
 	bool "Tracers"
 	default y if DEBUG_KERNEL
 	help
-	 Enable the kernel tracing infrastructure.
+	  Enable the kernel tracing infrastructure.
 
 if FTRACE
 
@@ -133,7 +133,7 @@ config FUNCTION_TRACER
 	help
 	  Enable the kernel to trace every kernel function. This is done
 	  by using a compiler feature to insert a small, 5-byte No-Operation
-	  instruction to the beginning of every kernel function, which NOP
+	  instruction at the beginning of every kernel function, which NOP
 	  sequence is then dynamically patched into a tracer call when
 	  tracing is enabled by the administrator. If it's runtime disabled
 	  (the bootup default), then the overhead of the instructions is very
@@ -150,7 +150,7 @@ config FUNCTION_GRAPH_TRACER
 	  and its entry.
 	  Its first purpose is to trace the duration of functions and
 	  draw a call graph for each thread with some information like
-	  the return value. This is done by setting the current return 
+	  the return value. This is done by setting the current return
 	  address on the current task structure into a stack of calls.
 
 
@@ -173,7 +173,7 @@ config IRQSOFF_TRACER
 
 	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
-	  (Note that kernel size and overhead increases with this option
+	  (Note that kernel size and overhead increase with this option
 	  enabled. This option and the preempt-off timing option can be
 	  used together or separately.)
 
@@ -186,7 +186,7 @@ config PREEMPT_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
 	help
-	  This option measures the time spent in preemption off critical
+	  This option measures the time spent in preemption-off critical
 	  sections, with microsecond accuracy.
 
 	  The default measurement method is a maximum search, which is
@@ -195,7 +195,7 @@ config PREEMPT_TRACER
 
 	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
-	  (Note that kernel size and overhead increases with this option
+	  (Note that kernel size and overhead increase with this option
 	  enabled. This option and the irqs-off timing option can be
 	  used together or separately.)
 
@@ -222,7 +222,7 @@ config ENABLE_DEFAULT_TRACERS
 	depends on !GENERIC_TRACER
 	select TRACING
 	help
-	  This tracer hooks to various trace points in the kernel
+	  This tracer hooks to various trace points in the kernel,
 	  allowing the user to pick and choose which trace point they
 	  want to trace. It also includes the sched_switch tracer plugin.
 
@@ -265,19 +265,19 @@ choice
 	 The likely/unlikely profiler only looks at the conditions that
 	 are annotated with a likely or unlikely macro.
 
-	 The "all branch" profiler will profile every if statement in the
+	 The "all branch" profiler will profile every if-statement in the
 	 kernel. This profiler will also enable the likely/unlikely
-	 profiler as well.
+	 profiler.
 
-	 Either of the above profilers add a bit of overhead to the system.
-	 If unsure choose "No branch profiling".
+	 Either of the above profilers adds a bit of overhead to the system.
+	 If unsure, choose "No branch profiling".
 
 config BRANCH_PROFILE_NONE
 	bool "No branch profiling"
 	help
-	 No branch profiling. Branch profiling adds a bit of overhead.
-	 Only enable it if you want to analyse the branching behavior.
-	 Otherwise keep it disabled.
+	  No branch profiling. Branch profiling adds a bit of overhead.
+	  Only enable it if you want to analyse the branching behavior.
+	  Otherwise keep it disabled.
 
 config PROFILE_ANNOTATED_BRANCHES
 	bool "Trace likely/unlikely profiler"
@@ -288,7 +288,7 @@ config PROFILE_ANNOTATED_BRANCHES
 
 	  /sys/kernel/debug/tracing/profile_annotated_branch
 
-	  Note: this will add a significant overhead, only turn this
+	  Note: this will add a significant overhead; only turn this
 	  on if you need to profile the system's use of these macros.
 
 config PROFILE_ALL_BRANCHES
@@ -305,7 +305,7 @@ config PROFILE_ALL_BRANCHES
 
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
-	  is to be analyzed
+	  is to be analyzed in much detail.
 endchoice
 
 config TRACING_BRANCHES
@@ -335,7 +335,7 @@ config POWER_TRACER
 	depends on X86
 	select GENERIC_TRACER
 	help
-	  This tracer helps developers to analyze and optimize the kernels
+	  This tracer helps developers to analyze and optimize the kernel's
 	  power management decisions, specifically the C-state and P-state
 	  behavior.
 
@@ -391,14 +391,14 @@ config HW_BRANCH_TRACER
 	select GENERIC_TRACER
 	help
 	  This tracer records all branches on the system in a circular
-	  buffer giving access to the last N branches for each cpu.
+	  buffer, giving access to the last N branches for each cpu.
 
 config KMEMTRACE
 	bool "Trace SLAB allocations"
 	select GENERIC_TRACER
 	help
 	  kmemtrace provides tracing for slab allocator functions, such as
-	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
+	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free, etc. Collected
 	  data is then fed to the userspace application in order to analyse
 	  allocation hotspots, internal fragmentation and so on, making it
 	  possible to see how well an allocator performs, as well as debug
@@ -417,15 +417,15 @@ config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
 	help
-	  The workqueue tracer provides some statistical informations
+	  The workqueue tracer provides some statistical information
           about each cpu workqueue thread such as the number of the
           works inserted and executed since their creation. It can help
-          to evaluate the amount of work each of them have to perform.
+          to evaluate the amount of work each of them has to perform.
           For example it can help a developer to decide whether he should
-          choose a per cpu workqueue instead of a singlethreaded one.
+          choose a per-cpu workqueue instead of a singlethreaded one.
 
 config BLK_DEV_IO_TRACE
-	bool "Support for tracing block io actions"
+	bool "Support for tracing block IO actions"
 	depends on SYSFS
 	depends on BLOCK
 	select RELAY
@@ -456,15 +456,15 @@ config KPROBE_EVENT
 	select TRACING
 	default y
 	help
-	  This allows the user to add tracing events (similar to tracepoints) on the fly
-	  via the ftrace interface. See Documentation/trace/kprobetrace.txt
-	  for more details.
+	  This allows the user to add tracing events (similar to tracepoints)
+	  on the fly via the ftrace interface. See
+	  Documentation/trace/kprobetrace.txt for more details.
 
 	  Those events can be inserted wherever kprobes can probe, and record
 	  various register and memory values.
 
-	  This option is also required by perf-probe subcommand of perf tools. If
-	  you want to use perf tools, this option is strongly recommended.
+	  This option is also required by perf-probe subcommand of perf tools.
+	  If you want to use perf tools, this option is strongly recommended.
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
@@ -472,32 +472,32 @@ config DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-         This option will modify all the calls to ftrace dynamically
-	 (will patch them out of the binary image and replaces them
-	 with a No-Op instruction) as they are called. A table is
-	 created to dynamically enable them again.
+          This option will modify all the calls to ftrace dynamically
+	  (will patch them out of the binary image and replace them
+	  with a No-Op instruction) as they are called. A table is
+	  created to dynamically enable them again.
 
-	 This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but otherwise
-	 has native performance as long as no tracing is active.
+	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
+	  otherwise has native performance as long as no tracing is active.
 
-	 The changes to the code are done by a kernel thread that
-	 wakes up once a second and checks to see if any ftrace calls
-	 were made. If so, it runs stop_machine (stops all CPUS)
-	 and modifies the code to jump over the call to ftrace.
+	  The changes to the code are done by a kernel thread that
+	  wakes up once a second and checks to see if any ftrace calls
+	  were made. If so, it runs stop_machine (stops all CPUS)
+	  and modifies the code to jump over the call to ftrace.
 
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
 	default n
 	help
-	 This option enables the kernel function profiler. A file is created
-	 in debugfs called function_profile_enabled which defaults to zero.
-	 When a 1 is echoed into this file profiling begins, and when a
-	 zero is entered, profiling stops. A file in the trace_stats
-	 directory called functions, that show the list of functions that
-	 have been hit and their counters.
+	  This option enables the kernel function profiler. A file is created
+	  in debugfs called function_profile_enabled which defaults to zero.
+	  When a 1 is echoed into this file profiling begins, and when a
+	  zero is entered, profiling stops. A "functions" file is created in
+	  the trace_stats directory; this file shows the list of functions that
+	  have been hit and their counters.
 
-	 If in doubt, say N
+	  If in doubt, say N.
 
 config FTRACE_MCOUNT_RECORD
 	def_bool y
@@ -556,8 +556,8 @@ config RING_BUFFER_BENCHMARK
 	tristate "Ring buffer benchmark stress tester"
 	depends on RING_BUFFER
 	help
-	  This option creates a test to stress the ring buffer and bench mark it.
-	  It creates its own ring buffer such that it will not interfer with
+	  This option creates a test to stress the ring buffer and benchmark it.
+	  It creates its own ring buffer such that it will not interfere with
 	  any other users of the ring buffer (such as ftrace). It then creates
 	  a producer and consumer that will run for 10 seconds and sleep for
 	  10 seconds. Each interval it will print out the number of events
@@ -566,7 +566,7 @@ config RING_BUFFER_BENCHMARK
 	  It does not disable interrupts or raise its priority, so it may be
 	  affected by processes that are running.
 
-	  If unsure, say N
+	  If unsure, say N.
 
 endif # FTRACE
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee61915..d0a4c12 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3949,7 +3949,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
 		ret = __set_tracer_option(current_trace, topt->flags,
-					  topt->opt, val);
+					  topt->opt, !val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
 			return ret;
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 458e5bf..d4fa5dc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -158,7 +158,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0, FILTER_OTHER);	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -168,8 +169,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
-				 sizeof(field.container.item), 0,	\
-				 FILTER_OTHER);				\
+				 sizeof(field.container.item),		\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..83f1e6e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1182,10 +1182,11 @@ static int __probe_event_show_format(struct trace_seq *s,
 #undef SHOW_FIELD
 #define SHOW_FIELD(type, item, name)					\
 	do {								\
-		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
-				"offset:%u;\tsize:%u;\n", name,		\
+		ret = trace_seq_printf(s, "\tfield:" #type " %s;\t"	\
+				"offset:%u;\tsize:%u;\tsigned:%d;\n", name,\
 				(unsigned int)offsetof(typeof(field), item),\
-				(unsigned int)sizeof(type));		\
+				(unsigned int)sizeof(type),		\
+				is_signed_type(type));			\
 		if (!ret)						\
 			return 0;					\
 	} while (0)
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index faf37fa..94103cd 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -26,12 +26,13 @@
 #include <linux/fs.h>
 
 #include "trace_output.h"
-#include "trace_stat.h"
 #include "trace.h"
 
 #include <linux/hw_breakpoint.h>
 #include <asm/hw_breakpoint.h>
 
+#include <asm/atomic.h>
+
 /*
  * For now, let us restrict the no. of symbols traced simultaneously to number
  * of available hardware breakpoint registers.
@@ -44,7 +45,7 @@ struct trace_ksym {
 	struct perf_event	**ksym_hbp;
 	struct perf_event_attr	attr;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-	unsigned long		counter;
+	atomic64_t		counter;
 #endif
 	struct hlist_node	ksym_hlist;
 };
@@ -69,9 +70,8 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
-		if ((entry->attr.bp_addr == hbp_hit_addr) &&
-		    (entry->counter <= MAX_UL_INT)) {
-			entry->counter++;
+		if (entry->attr.bp_addr == hbp_hit_addr) {
+			atomic64_inc(&entry->counter);
 			break;
 		}
 	}
@@ -197,7 +197,6 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	entry->attr.bp_addr = addr;
 	entry->attr.bp_len = HW_BREAKPOINT_LEN_4;
 
-	ret = -EAGAIN;
 	entry->ksym_hbp = register_wide_hw_breakpoint(&entry->attr,
 					ksym_hbp_handler);
 
@@ -300,8 +299,8 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!buf[0] || !strcmp(buf, "0") ||
-	    !strcmp(buf, "*:---")) {
+	if (!input_string[0] || !strcmp(input_string, "0") ||
+	    !strcmp(input_string, "*:---")) {
 		__ksym_trace_reset();
 		ret = 0;
 		goto out;
@@ -444,102 +443,77 @@ struct tracer ksym_tracer __read_mostly =
 	.print_line	= ksym_trace_output
 };
 
-__init static int init_ksym_trace(void)
-{
-	struct dentry *d_tracer;
-	struct dentry *entry;
-
-	d_tracer = tracing_init_dentry();
-	ksym_filter_entry_count = 0;
-
-	entry = debugfs_create_file("ksym_trace_filter", 0644, d_tracer,
-				    NULL, &ksym_tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'ksym_trace_filter' file\n");
-
-	return register_tracer(&ksym_tracer);
-}
-device_initcall(init_ksym_trace);
-
-
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-static int ksym_tracer_stat_headers(struct seq_file *m)
+static int ksym_profile_show(struct seq_file *m, void *v)
 {
+	struct hlist_node *node;
+	struct trace_ksym *entry;
+	int access_type = 0;
+	char fn_name[KSYM_NAME_LEN];
+
 	seq_puts(m, "  Access Type ");
 	seq_puts(m, "  Symbol                                       Counter\n");
 	seq_puts(m, "  ----------- ");
 	seq_puts(m, "  ------                                       -------\n");
-	return 0;
-}
 
-static int ksym_tracer_stat_show(struct seq_file *m, void *v)
-{
-	struct hlist_node *stat = v;
-	struct trace_ksym *entry;
-	int access_type = 0;
-	char fn_name[KSYM_NAME_LEN];
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
 
-	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
+		access_type = entry->attr.bp_type;
 
-	access_type = entry->attr.bp_type;
+		switch (access_type) {
+		case HW_BREAKPOINT_R:
+			seq_puts(m, "  R           ");
+			break;
+		case HW_BREAKPOINT_W:
+			seq_puts(m, "  W           ");
+			break;
+		case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
+			seq_puts(m, "  RW          ");
+			break;
+		default:
+			seq_puts(m, "  NA          ");
+		}
 
-	switch (access_type) {
-	case HW_BREAKPOINT_R:
-		seq_puts(m, "  R           ");
-		break;
-	case HW_BREAKPOINT_W:
-		seq_puts(m, "  W           ");
-		break;
-	case HW_BREAKPOINT_R | HW_BREAKPOINT_W:
-		seq_puts(m, "  RW          ");
-		break;
-	default:
-		seq_puts(m, "  NA          ");
+		if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
+			seq_printf(m, "  %-36s", fn_name);
+		else
+			seq_printf(m, "  %-36s", "<NA>");
+		seq_printf(m, " %15llu\n",
+			   (unsigned long long)atomic64_read(&entry->counter));
 	}
-
-	if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
-		seq_printf(m, "  %-36s", fn_name);
-	else
-		seq_printf(m, "  %-36s", "<NA>");
-	seq_printf(m, " %15lu\n", entry->counter);
+	rcu_read_unlock();
 
 	return 0;
 }
 
-static void *ksym_tracer_stat_start(struct tracer_stat *trace)
+static int ksym_profile_open(struct inode *node, struct file *file)
 {
-	return ksym_filter_head.first;
-}
-
-static void *
-ksym_tracer_stat_next(void *v, int idx)
-{
-	struct hlist_node *stat = v;
-
-	return stat->next;
+	return single_open(file, ksym_profile_show, NULL);
 }
 
-static struct tracer_stat ksym_tracer_stats = {
-	.name = "ksym_tracer",
-	.stat_start = ksym_tracer_stat_start,
-	.stat_next = ksym_tracer_stat_next,
-	.stat_headers = ksym_tracer_stat_headers,
-	.stat_show = ksym_tracer_stat_show
+static const struct file_operations ksym_profile_fops = {
+	.open		= ksym_profile_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
+#endif /* CONFIG_PROFILE_KSYM_TRACER */
 
-__init static int ksym_tracer_stat_init(void)
+__init static int init_ksym_trace(void)
 {
-	int ret;
+	struct dentry *d_tracer;
 
-	ret = register_stat_tracer(&ksym_tracer_stats);
-	if (ret) {
-		printk(KERN_WARNING "Warning: could not register "
-				    "ksym tracer stats\n");
-		return 1;
-	}
+	d_tracer = tracing_init_dentry();
 
-	return 0;
+	trace_create_file("ksym_trace_filter", 0644, d_tracer,
+			  NULL, &ksym_tracing_fops);
+
+#ifdef CONFIG_PROFILE_KSYM_TRACER
+	trace_create_file("ksym_profile", 0444, d_tracer,
+			  NULL, &ksym_profile_fops);
+#endif
+
+	return register_tracer(&ksym_tracer);
 }
-fs_initcall(ksym_tracer_stat_init);
-#endif /* CONFIG_PROFILE_KSYM_TRACER */
+device_initcall(init_ksym_trace);
