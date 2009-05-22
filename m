Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZEVUCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZEVUCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZEVUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:02:36 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:18757
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755165AbZEVUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:02:35 -0400
X-BigFish: VPS-11(zz1dbaM936eNzz1202hzzz2fh6bh)
X-FB-SS: 5,
Message-ID: <4A1704B9.3010200@am.sony.com>
Date: Fri, 22 May 2009 13:02:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ftrace: add documentation for function graph tracer
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2009 20:02:02.0885 (UTC) FILETIME=[2C7CE350:01C9DB18]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some documentation specifically for the function graph tracer.

I realized about half-way into this that this is redundant with
material already in Document/trace/ftrace.txt.  However, I
think there is value in having in a separate document.  Also,
I have a little bit of stuff here which is not in the other
document.

Let me know what you think.

(ftd source to follow next week)

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 Documentation/trace/func-graph.txt |  237 +++++++++++++++++++++++++++++++++++++
 1 files changed, 237 insertions(+)

--- /dev/null
+++ b/Documentation/trace/func-graph.txt
@@ -0,0 +1,237 @@
+		Function Graph Tracing
+
+	   Documentation written by Tim Bird
+
+
+Function graph tracing is a variant of function tracing, which traces
+both the entry and exit of each kernel function.
+
+Preparation
+-----------
+
+The function graph tracing feature is compiled in using the
+CONFIG_FUNCTION_GRAPH_TRACER option. Tracing is disabled by default, so
+it is safe to have this set to yes. On platforms without dynamic tracing
+capability (e.g. ARM in 2.6.30), function tracing (and function graph tracing)
+add significant overhead to function execution in the Linux kernel).  On
+these platforms it would be unwise to leave function tracing turned on
+for in production environments.
+
+Note that function graph tracing is supported on SMP systems.
+
+Usage Quick Reference
+---------------------
+
+ $ mount -t debugfs debugfs /debug
+ $ echo function_graph > /debug/tracing/current_tracer
+ $ echo funcgraph-abstime >/debug/tracing/trace_options
+ $ echo 1 >/debug/tracing/tracing_enabled
+ $ <do something> ; echo 0 >/debug/tracing/tracing_enabled
+ $ cat /debug/tracing/trace > /tmp/trace-something.txt
+ $ echo nop > /debug/tracing/current_tracer
+
+Usage
+-----
+
+Make sure debugfs is mounted to /debug. If not, (requires root privileges)
+ $ mount -t debugfs debugfs /debug
+
+Activate function graph tracing (requires root privileges):
+ $ echo function_graph > /debug/tracing/current_tracer
+
+Enable tracing (if not already enabled)
+ $ echo 1 >/debug/tracing/tracing_enabled
+
+Do something, and quickly disable tracing, to avoid overrunning the
+related events in the trace log.  Note that the trace log uses a ring
+buffer, which continually overwrites older events in the log, until
+tracing is disabled.
+
+ $ <do something> ; echo 0 >/debug/tracing/tracing_enabled
+
+Store the trace:
+$ cat /debug/tracing/trace > /tmp/trace-something.txt
+
+Extra Tip:
+During tracing you can place comments (markers) into the trace by
+
+ $ echo "foo happened" > /debug/tracing/trace_marker
+
+This makes it easier to see which part of the (huge) trace corresponds to
+which action. It is recommended to place descriptive markers about what you
+do.  (I'm not sure how effective this is for function graph tracing.  The
+trace buffer fills so quickly that any comment made in "human time" will
+likely get overrun in the trace buffer before a human has a chance to stop
+the trace. - this tip was copied from mmiotrace.txt)
+
+Shut down function graph tracing (requires root privileges):
+ $ echo nop > /debug/tracing/current_tracer
+
+If it doesn't look like sufficient data was captured, you can enlarge the
+buffers and try again. Buffers are enlarged by first seeing how large the
+current buffers are:
+
+ $ cat /debug/tracing/buffer_size_kb
+
+gives you a number. Approximately double this number and write it back.
+
+For instance:
+ $ echo 128000 > /debug/tracing/buffer_size_kb
+
+Then start again from the top.
+
+How function graph tracing works
+--------------------------------
+The function tracer (upon which the function graph tracer is dependent) works
+by having the compiler put a call to a special instrumentation routine (called
+'mcount') in the prologue of every kernel function.  (Well, almost every
+kernel function - some functions can not be traced for one reason or another.)
+The function graph tracer records the entry time for each function traced.
+Then, it arranges to capture the function exit, by setting up a return
+trampoline.  This is done by recording the real return address, and
+substituting the trampoline address for the return address in the process
+stack.  When the function returns to the tracer, the time is recorded again,
+and the real caller is returned to.
+
+Trace Log Format
+----------------
+
+The log format for the function graph tracer is text and is unfortunately NOT
+easily filtered with e.g. grep and awk.  The output is easily read by a human,
+and is useful for showing how functions nest within other functions.  But
+since the duration of each function is printed at the end of the routine (on a
+line with no name, just a closing brace), you have to scan through the log to
+match up the duration times with the matching functions.
+
+The function graph tracer consists of a header showing the tracer name, and
+the fields that are configured for display on each line.  Then lines are shown
+for function entry and exit events.  Also, when a process change occurs (that
+is, a schedule occurs in the kernel), a special sequence is shown.
+
+Here is a sample showing the log header and a few sample trace lines.
+
+# tracer: function_graph
+#
+#      TIME       CPU  DURATION                  FUNCTION CALLS
+#       |         |     |   |                     |   |   |   |
+ 2105.963678 |   0)               |      mutex_unlock() {
+ 2105.963682 |   0)   5.715 us    |        __mutex_unlock_slowpath();
+ 2105.963693 |   0) + 14.700 us   |      }
+ 2105.963698 |   0)               |      dnotify_parent() {
+
+A context switch line shows the process name and pid for the outgoing and
+incoming tasks.  The outgoing task is shown on the left, followed by '=>'
+then the incoming task.
+
+Here is a sample of a context switch:
+ ------------------------------------------
+ 0)     ls-595     =>    sed-596
+ ------------------------------------------
+
+You can configure the items displayed for each trace element, by setting
+/debug/tracing/trace_options.  (See Trace Display Options below)
+
+The following elements are available for display:
+
+TIME - this is the (absolute) time since the machine started in seconds, with
+a decimal portion showing resolution to microseconds.  The actual resolution
+of the time (and of the tracer timings in general) will depend on the specific
+clock used by ftrace. This option is off by default.
+
+CPU - indicates the CPU on which the function was executed
+
+TASK/PID - shows the task name and PID (process ID) for each trace entry.  The
+entry has the format <task>-<pid> (e.g. "sh-443").  This option is off by
+default.
+
+OVERHEAD (not labeled) - is a flag indicator, showing functions whose
+duration exceeded certain threshholds:
+   space (or nothing) - the function executed in less than 10 microseconds
+   + - the function lasted longer than 10 microseconds
+   ! - the function lasted longer than 100 microseconds
+
+DURATION - this is printed for function exit trace events, and shows
+ the time in microseconds that the function executed.  This is "wall time"
+for the function, and includes the time spent in any sub-routines or
+with the CPU scheduled away from this routine (this routine or a child
+waiting for a something.)
+
+FUNCTION CALLS - this shows the name of the function for function entry events,
+and a closing brace '}' for function exit events. For function entry (only,
+not a leaf) the line consists of a function name and an open brace.  For
+function exit, the line consists of a closing brace.  Note that the function
+name and closing brace are indented to indicate their depth on the call stack.
+This allows you to match up function exits with their matching functions, and
+to easily identify the call tree (graph) for a particular function.
+
+Trace Display Options
+---------------------
+
+The following display options are available for customizing the function
+graph trace output:
+
+   abstime - show TIME
+   cpu - show CPU
+   overhead - show OVERHEAD indicator
+   proc - show TASK and PID
+   duration - show DURATION
+   overrun - shows if the trace had an overrun (used for debugging the tracer)
+
+To set an option echo a string to /debug/tracing/trace_options, using the format:
+"funcgraph-<opt_name>".  To unset a particular option, use the format:
+"nofuncgraph-<opt_name>".
+
+ $ echo funcgraph-abstime >/debug/tracing/trace_options
+ $ echo nofuncgraph-cpu >/debug/tracing/trace_options
+ $ cat trace
+
+Tools for Developers
+--------------------
+
+The user space tool 'ftd' includes capabilities for:
+ * sorting the information by time spent in each routine
+ * filtering the information by cpu, process, call count, and execution time
+ * showing minimum and maximum time spent in a routine
+
+= Tutorial/Samples =
+For an interesting first trace, try the following:
+(make sure no other processes are active, if you can)
+
+ $ mount -t debugfs debugfs /debug
+ $ cd /debug/tracing
+ $ echo function_graph > current_tracer
+ $ echo funcgraph-abstime > trace_options
+ $ echo 10000 > buffer_size_kb
+ $ echo 1 > tracing_enabled ; ls /bin | sed s/[aeiou]/z/g ; \
+	echo "marker test!" ; echo 0 >tracing_enabled
+ $ cat trace > /tmp/trace1.txt
+
+You might need to change the buffer size to 20000 (20 M) if
+you don't capture the entire trace (if the top of the buffer
+starts in the middle of ls or sed execution).
+
+Now examine the data:
+ $ ls -l /tmp/trace1.txt
+ $ vi /tmp/trace1.txt
+
+Note that the trace data is quite large, but probably only covers a
+second or two of execution.
+
+Here are some things to look for in the trace:
+
+ * Watch as the shell forks and execs ls and sed.
+ * Watch for timer interrupts which cause context switches between the three
+ * processes (sh, ls and sed).
+ * Watch for page faults during ls and sed startup, as the processes are paged
+   into memory.
+ * Look for routines starting with "sys_" which are at the top level of the
+   call graphs. These are system calls.
+ * Look for the duration value for the system calls, on the lines with the
+   closing braces at the same indentation level.  You can see how long
+   different system calls took to execute, and what sub-routines were called
+   internally in the kernel.  Also, you can determine if a long-running
+   system call was interrupted (and the process scheduled out, before
+   returning)
+ * Look for the comment "marker test!" near the end of the trace.
+
+

