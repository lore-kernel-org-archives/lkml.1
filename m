Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYLDXq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYLDXq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLDXqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:46:03 -0500
Received: from www.tglx.de ([62.245.132.106]:38346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLDXqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:46:01 -0500
Message-Id: <20081204230228.557959174@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 04 Dec 2008 23:44:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: [patch 2/3] performance counters: documentation
References: <20081204225345.654705757@linutronix.de>
Content-Disposition: inline; filename=perf-counters-docs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Add more documentation about performance counters.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/perf-counters.txt |  104 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

Index: linux/Documentation/perf-counters.txt
===================================================================
--- /dev/null
+++ linux/Documentation/perf-counters.txt
@@ -0,0 +1,104 @@
+
+Performance Counters for Linux
+------------------------------
+
+Performance counters are special hardware registers available on most modern
+CPUs. These registers count the number of certain types of hw events: such
+as instructions executed, cachemisses suffered, or branches mis-predicted -
+without slowing down the kernel or applications. These registers can also
+trigger interrupts when a threshold number of events have passed - and can
+thus be used to profile the code that runs on that CPU.
+
+The Linux Performance Counter subsystem provides an abstraction of these
+hardware capabilities. It provides per task and per CPU counters, and
+it provides event capabilities on top of those.
+
+Performance counters are accessed via special file descriptors.
+There's one file descriptor per virtual counter used.
+
+The special file descriptor is opened via the perf_counter_open()
+system call:
+
+ int
+ perf_counter_open(u32 hw_event_type,
+                   u32 hw_event_period,
+                   u32 record_type,
+                   pid_t pid,
+                   int cpu);
+
+The syscall returns the new fd. The fd can be used via the normal
+VFS system calls: read() can be used to read the counter, fcntl()
+can be used to set the blocking mode, etc.
+
+Multiple counters can be kept open at a time, and the counters
+can be poll()ed.
+
+When creating a new counter fd, 'hw_event_type' is one of:
+
+ enum hw_event_types {
+	PERF_COUNT_CYCLES,
+	PERF_COUNT_INSTRUCTIONS,
+	PERF_COUNT_CACHE_REFERENCES,
+	PERF_COUNT_CACHE_MISSES,
+	PERF_COUNT_BRANCH_INSTRUCTIONS,
+	PERF_COUNT_BRANCH_MISSES,
+ };
+
+These are standardized types of events that work uniformly on all CPUs
+that implements Performance Counters support under Linux. If a CPU is
+not able to count branch-misses, then the system call will return
+-EINVAL.
+
+[ Note: more hw_event_types are supported as well, but they are CPU
+  specific and are enumerated via /sys on a per CPU basis. Raw hw event
+  types can be passed in as negative numbers. For example, to count
+  "External bus cycles while bus lock signal asserted" events on Intel
+  Core CPUs, pass in a -0x4064 event type value. ]
+
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
+'record_type' is the type of data that a read() will provide for the
+counter, and it can be one of:
+
+  enum perf_record_type {
+	PERF_RECORD_SIMPLE,
+	PERF_RECORD_IRQ,
+  };
+
+a "simple" counter is one that counts hardware events and allows
+them to be read out into a u64 count value. (read() returns 8 on
+a successful read of a simple counter.)
+
+An "irq" counter is one that will also provide an IRQ context information:
+the IP of the interrupted context. In this case read() will return
+the 8-byte counter value, plus the Instruction Pointer address of the
+interrupted context.
+
+The 'pid' parameter allows the counter to be specific to a task:
+
+ pid == 0: if the pid parameter is zero, the counter is attached to the
+ current task.
+
+ pid > 0: the counter is attached to a specific task (if the current task
+ has sufficient privilege to do so)
+
+ pid < 0: all tasks are counted (per cpu counters)
+
+The 'cpu' parameter allows a counter to be made specific to a full
+CPU:
+
+ cpu >= 0: the counter is restricted to a specific CPU
+ cpu == -1: the counter counts on all CPUs
+
+Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.
+
+A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
+events of that task and 'follows' that task to whatever CPU the task
+gets schedule to. Per task counters can be created by any user, for
+their own tasks.
+
+A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
+all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
+


