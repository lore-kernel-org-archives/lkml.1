Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYKKSZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYKKSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYKKSY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:24:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYKKSYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:24:55 -0500
Date: Tue, 11 Nov 2008 19:24:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20081111182428.GA16813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

the large linecount comes from the ftrace.txt update, which was 
getting pretty stale so we took it a bit ahead.

 Thanks,

	Ingo

------------------>
Eric Anholt (1):
      ftrace: fix breakage in bin_fmt results

Steven Rostedt (4):
      ftrace: update txt document
      ftrace: ftrace.txt version update
      ftrace: disable tracing on resize
      ring-buffer: prevent infinite looping on time stamping


 Documentation/ftrace.txt   |  171 +++++++++++++++++++-------------------------
 kernel/trace/ring_buffer.c |    2 +-
 kernel/trace/trace.c       |   19 +++++-
 3 files changed, 91 insertions(+), 101 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index ea5a827..9cc4d68 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -8,7 +8,7 @@ Copyright 2008 Red Hat Inc.
 Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
 	     John Kacur, and David Teigland.
 
-Written for: 2.6.27-rc1
+Written for: 2.6.28-rc2
 
 Introduction
 ------------
@@ -50,26 +50,26 @@ of ftrace. Here is a list of some of the key files:
 
  Note: all time values are in microseconds.
 
-  current_tracer : This is used to set or display the current tracer
+  current_tracer: This is used to set or display the current tracer
 		that is configured.
 
-  available_tracers : This holds the different types of tracers that
+  available_tracers: This holds the different types of tracers that
 		have been compiled into the kernel. The tracers
 		listed here can be configured by echoing their name
 		into current_tracer.
 
-  tracing_enabled : This sets or displays whether the current_tracer
+  tracing_enabled: This sets or displays whether the current_tracer
 		is activated and tracing or not. Echo 0 into this
 		file to disable the tracer or 1 to enable it.
 
-  trace : This file holds the output of the trace in a human readable
+  trace: This file holds the output of the trace in a human readable
 		format (described below).
 
-  latency_trace : This file shows the same trace but the information
+  latency_trace: This file shows the same trace but the information
 		is organized more to display possible latencies
 		in the system (described below).
 
-  trace_pipe : The output is the same as the "trace" file but this
+  trace_pipe: The output is the same as the "trace" file but this
 		file is meant to be streamed with live tracing.
 		Reads from this file will block until new data
 		is retrieved. Unlike the "trace" and "latency_trace"
@@ -82,11 +82,11 @@ of ftrace. Here is a list of some of the key files:
 		tracer is not adding more data, they will display
 		the same information every time they are read.
 
-  iter_ctrl : This file lets the user control the amount of data
+  iter_ctrl: This file lets the user control the amount of data
 		that is displayed in one of the above output
 		files.
 
-  trace_max_latency : Some of the tracers record the max latency.
+  trace_max_latency: Some of the tracers record the max latency.
 		For example, the time interrupts are disabled.
 		This time is saved in this file. The max trace
 		will also be stored, and displayed by either
@@ -94,29 +94,26 @@ of ftrace. Here is a list of some of the key files:
 		only be recorded if the latency is greater than
 		the value in this file. (in microseconds)
 
-  trace_entries : This sets or displays the number of trace
-		entries each CPU buffer can hold. The tracer buffers
-		are the same size for each CPU. The displayed number
-		is the size of the CPU buffer and not total size. The
+  trace_entries: This sets or displays the number of bytes each CPU
+		buffer can hold. The tracer buffers are the same size
+		for each CPU. The displayed number is the size of the
+		 CPU buffer and not total size of all buffers. The
 		trace buffers are allocated in pages (blocks of memory
 		that the kernel uses for allocation, usually 4 KB in size).
-		Since each entry is smaller than a page, if the last
-		allocated page has room for more entries than were
-		requested, the rest of the page is used to allocate
-		entries.
+		If the last page allocated has room for more bytes
+		than requested, the rest of the page will be used,
+		making the actual allocation bigger than requested.
+		(Note, the size may not be a multiple of the page size due
+		to buffer managment overhead.)
 
 		This can only be updated when the current_tracer
-		is set to "none".
+		is set to "nop".
 
-		NOTE: It is planned on changing the allocated buffers
-		      from being the number of possible CPUS to
-		      the number of online CPUS.
-
-  tracing_cpumask : This is a mask that lets the user only trace
+  tracing_cpumask: This is a mask that lets the user only trace
 		on specified CPUS. The format is a hex string
 		representing the CPUS.
 
-  set_ftrace_filter : When dynamic ftrace is configured in (see the
+  set_ftrace_filter: When dynamic ftrace is configured in (see the
 		section below "dynamic ftrace"), the code is dynamically
 		modified (code text rewrite) to disable calling of the
 		function profiler (mcount). This lets tracing be configured
@@ -130,14 +127,11 @@ of ftrace. Here is a list of some of the key files:
 		be traced. If a function exists in both set_ftrace_filter
 		and set_ftrace_notrace,	the function will _not_ be traced.
 
-  available_filter_functions : When a function is encountered the first
-		time by the dynamic tracer, it is recorded and
-		later the call is converted into a nop. This file
-		lists the functions that have been recorded
-		by the dynamic tracer and these functions can
-		be used to set the ftrace filter by the above
-		"set_ftrace_filter" file. (See the section "dynamic ftrace"
-		below for more details).
+  available_filter_functions: This lists the functions that ftrace
+		has processed and can trace. These are the function
+		names that you can pass to "set_ftrace_filter" or
+		"set_ftrace_notrace". (See the section "dynamic ftrace"
+		below for more details.)
 
 
 The Tracers
@@ -145,7 +139,7 @@ The Tracers
 
 Here is the list of current tracers that may be configured.
 
-  ftrace - function tracer that uses mcount to trace all functions.
+  function - function tracer that uses mcount to trace all functions.
 
   sched_switch - traces the context switches between tasks.
 
@@ -166,8 +160,8 @@ Here is the list of current tracers that may be configured.
 		the highest priority task to get scheduled after
 		it has been woken up.
 
-  none - This is not a tracer. To remove all tracers from tracing
-		simply echo "none" into current_tracer.
+  nop - This is not a tracer. To remove all tracers from tracing
+		simply echo "nop" into current_tracer.
 
 
 Examples of using the tracer
@@ -182,7 +176,7 @@ Output format:
 Here is an example of the output format of the file "trace"
 
                              --------
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -192,7 +186,7 @@ Here is an example of the output format of the file "trace"
                              --------
 
 A header is printed with the tracer name that is represented by the trace.
-In this case the tracer is "ftrace". Then a header showing the format. Task
+In this case the tracer is "function". Then a header showing the format. Task
 name "bash", the task PID "4251", the CPU that it was running on
 "01", the timestamp in <secs>.<usecs> format, the function name that was
 traced "path_put" and the parent function that called this function
@@ -1003,22 +997,20 @@ is the stack for the hard interrupt. This hides the fact that NEED_RESCHED
 has been set. We do not see the 'N' until we switch back to the task's
 assigned stack.
 
-ftrace
-------
+function
+--------
 
-ftrace is not only the name of the tracing infrastructure, but it
-is also a name of one of the tracers. The tracer is the function
-tracer. Enabling the function tracer can be done from the
-debug file system. Make sure the ftrace_enabled is set otherwise
-this tracer is a nop.
+This tracer is the function tracer. Enabling the function tracer
+can be done from the debug file system. Make sure the ftrace_enabled is
+set; otherwise this tracer is a nop.
 
  # sysctl kernel.ftrace_enabled=1
- # echo ftrace > /debug/tracing/current_tracer
+ # echo function > /debug/tracing/current_tracer
  # echo 1 > /debug/tracing/tracing_enabled
  # usleep 1
  # echo 0 > /debug/tracing/tracing_enabled
  # cat /debug/tracing/trace
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -1040,10 +1032,10 @@ this tracer is a nop.
 [...]
 
 
-Note: ftrace uses ring buffers to store the above entries. The newest data
-may overwrite the oldest data. Sometimes using echo to stop the trace
-is not sufficient because the tracing could have overwritten the data
-that you wanted to record. For this reason, it is sometimes better to
+Note: function tracer uses ring buffers to store the above entries.
+The newest data may overwrite the oldest data. Sometimes using echo to
+stop the trace is not sufficient because the tracing could have overwritten
+the data that you wanted to record. For this reason, it is sometimes better to
 disable tracing directly from a program. This allows you to stop the
 tracing at the point that you hit the part that you are interested in.
 To disable the tracing directly from a C program, something like following
@@ -1077,18 +1069,31 @@ every kernel function, produced by the -pg switch in gcc), starts
 of pointing to a simple return. (Enabling FTRACE will include the
 -pg switch in the compiling of the kernel.)
 
-When dynamic ftrace is initialized, it calls kstop_machine to make
-the machine act like a uniprocessor so that it can freely modify code
-without worrying about other processors executing that same code.  At
-initialization, the mcount calls are changed to call a "record_ip"
-function.  After this, the first time a kernel function is called,
-it has the calling address saved in a hash table.
-
-Later on the ftraced kernel thread is awoken and will again call
-kstop_machine if new functions have been recorded. The ftraced thread
-will change all calls to mcount to "nop".  Just calling mcount
-and having mcount return has shown a 10% overhead. By converting
-it to a nop, there is no measurable overhead to the system.
+At compile time every C file object is run through the
+recordmcount.pl script (located in the scripts directory). This
+script will process the C object using objdump to find all the
+locations in the .text section that call mcount. (Note, only
+the .text section is processed, since processing other sections
+like .init.text may cause races due to those sections being freed).
+
+A new section called "__mcount_loc" is created that holds references
+to all the mcount call sites in the .text section. This section is
+compiled back into the original object. The final linker will add
+all these references into a single table.
+
+On boot up, before SMP is initialized, the dynamic ftrace code
+scans this table and updates all the locations into nops. It also
+records the locations, which are added to the available_filter_functions
+list.  Modules are processed as they are loaded and before they are
+executed.  When a module is unloaded, it also removes its functions from
+the ftrace function list. This is automatic in the module unload
+code, and the module author does not need to worry about it.
+
+When tracing is enabled, kstop_machine is called to prevent races
+with the CPUS executing code being modified (which can cause the
+CPU to do undesireable things), and the nops are patched back
+to calls. But this time, they do not call mcount (which is just
+a function stub). They now call into the ftrace infrastructure.
 
 One special side-effect to the recording of the functions being
 traced is that we can now selectively choose which functions we
@@ -1251,36 +1256,6 @@ Produces:
 
 We can see that there's no more lock or preempt tracing.
 
-ftraced
--------
-
-As mentioned above, when dynamic ftrace is configured in, a kernel
-thread wakes up once a second and checks to see if there are mcount
-calls that need to be converted into nops. If there are not any, then
-it simply goes back to sleep. But if there are some, it will call
-kstop_machine to convert the calls to nops.
-
-There may be a case in which you do not want this added latency.
-Perhaps you are doing some audio recording and this activity might
-cause skips in the playback. There is an interface to disable
-and enable the "ftraced" kernel thread.
-
- # echo 0 > /debug/tracing/ftraced_enabled
-
-This will disable the calling of kstop_machine to update the
-mcount calls to nops. Remember that there is a large overhead
-to calling mcount. Without this kernel thread, that overhead will
-exist.
-
-If there are recorded calls to mcount, any write to the ftraced_enabled
-file will cause the kstop_machine to run. This means that a
-user can manually perform the updates when they want to by simply
-echoing a '0' into the ftraced_enabled file.
-
-The updates are also done at the beginning of enabling a tracer
-that uses ftrace function recording.
-
-
 trace_pipe
 ----------
 
@@ -1289,14 +1264,14 @@ on the tracing is different. Every read from trace_pipe is consumed.
 This means that subsequent reads will be different. The trace
 is live.
 
- # echo ftrace > /debug/tracing/current_tracer
+ # echo function > /debug/tracing/current_tracer
  # cat /debug/tracing/trace_pipe > /tmp/trace.out &
 [1] 4153
  # echo 1 > /debug/tracing/tracing_enabled
  # usleep 1
  # echo 0 > /debug/tracing/tracing_enabled
  # cat /debug/tracing/trace
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -1317,7 +1292,7 @@ is live.
 
 Note, reading the trace_pipe file will block until more input is added.
 By changing the tracer, trace_pipe will issue an EOF. We needed
-to set the ftrace tracer _before_ cating the trace_pipe file.
+to set the function tracer _before_ we "cat" the trace_pipe file.
 
 
 trace entries
@@ -1334,10 +1309,10 @@ number of entries.
 65620
 
 Note, to modify this, you must have tracing completely disabled. To do that,
-echo "none" into the current_tracer. If the current_tracer is not set
-to "none", an EINVAL error will be returned.
+echo "nop" into the current_tracer. If the current_tracer is not set
+to "nop", an EINVAL error will be returned.
 
- # echo none > /debug/tracing/current_tracer
+ # echo nop > /debug/tracing/current_tracer
  # echo 100000 > /debug/tracing/trace_entries
  # cat /debug/tracing/trace_entries
 100045
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3f33806..2f76193 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1060,7 +1060,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 		/* Did the write stamp get updated already? */
 		if (unlikely(ts < cpu_buffer->write_stamp))
-			goto again;
+			delta = 0;
 
 		if (test_time_stamp(delta)) {
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9f3b478..697eda3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1755,7 +1755,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 		return TRACE_TYPE_HANDLED;
 
 	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, iter->cpu);
+	SEQ_PUT_FIELD_RET(s, entry->cpu);
 	SEQ_PUT_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
@@ -2676,7 +2676,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 {
 	unsigned long val;
 	char buf[64];
-	int ret;
+	int ret, cpu;
 	struct trace_array *tr = filp->private_data;
 
 	if (cnt >= sizeof(buf))
@@ -2704,6 +2704,14 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		goto out;
 	}
 
+	/* disable all cpu buffers */
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_inc(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_inc(&max_tr.data[cpu]->disabled);
+	}
+
 	if (val != global_trace.entries) {
 		ret = ring_buffer_resize(global_trace.buffer, val);
 		if (ret < 0) {
@@ -2735,6 +2743,13 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	if (tracing_disabled)
 		cnt = -ENOMEM;
  out:
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_dec(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_dec(&max_tr.data[cpu]->disabled);
+	}
+
 	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
