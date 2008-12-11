Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYLKTum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYLKTum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbYLKTfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:35:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987AbYLKTfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:35:12 -0500
Date: Thu, 11 Dec 2008 20:34:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081211193439.GA25986@elte.hu>
References: <20081211155230.GA4230@elte.hu> <12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com>
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


* Tony Luck <tony.luck@intel.com> wrote:

> >        /*
> >         * Special "software" counters provided by the kernel, even if
> >         * the hardware does not support performance counters. These
> >         * counters measure various physical and sw events of the
> >         * kernel (and allow the profiling of them as well):
> >         */
> >        PERF_COUNT_CPU_CLOCK            = -1,
> >        PERF_COUNT_TASK_CLOCK           = -2,
> >        /*
> >         * Future software events:
> >         */
> >        /* PERF_COUNT_PAGE_FAULTS       = -3,
> >           PERF_COUNT_CONTEXT_SWITCHES  = -4, */
> 
>   ...
> > +[ Note: more hw_event_types are supported as well, but they are CPU
> > +  specific and are enumerated via /sys on a per CPU basis. Raw hw event
> > +  types can be passed in as negative numbers. For example, to count
> > +  "External bus cycles while bus lock signal asserted" events on Intel
> > +  Core CPUs, pass in a -0x4064 event type value. ]
> 
> It looks like you have an overlap here.  You are using some negative 
> numbers to denote your special software events, but also as "raw" 
> hardware events. What if these conflict?

that's an old comment, not a bug in the code - thx for pointing it out, i 
just fixed the comments - see the commit below.

Raw events are now done without using up negative numbers, they are done 
via:

 struct perf_counter_hw_event {
        s64                     type;

        u64                     irq_period;
        u32                     record_type;

        u32                     disabled     :  1, /* off by default */
                                nmi          :  1, /* NMI sampling   */
                                raw          :  1, /* raw event type */
                                __reserved_1 : 29;

        u64                     __reserved_2;
 };

if the hw_event.raw bit is set to 1, then the hw_event.type is fully 
'raw'. The default is for raw to be 0. So negative numbers can be used 
for sw events, positive numbers for hw events. Both can be extended 
gradually, without arbitrarily limits introduced.

	Ingo

------------------------->
>From 447557ac7ce120306b4a31d6003faef39cb1bf14 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 11 Dec 2008 20:40:18 +0100
Subject: [PATCH] perf counters: update docs

Impact: update docs

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/perf-counters.txt |  107 +++++++++++++++++++++++++++------------
 1 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/Documentation/perf-counters.txt b/Documentation/perf-counters.txt
index 19033a0..fddd321 100644
--- a/Documentation/perf-counters.txt
+++ b/Documentation/perf-counters.txt
@@ -10,8 +10,8 @@ trigger interrupts when a threshold number of events have passed - and can
 thus be used to profile the code that runs on that CPU.
 
 The Linux Performance Counter subsystem provides an abstraction of these
-hardware capabilities. It provides per task and per CPU counters, and
-it provides event capabilities on top of those.
+hardware capabilities. It provides per task and per CPU counters, counter
+groups, and it provides event capabilities on top of those.
 
 Performance counters are accessed via special file descriptors.
 There's one file descriptor per virtual counter used.
@@ -19,12 +19,8 @@ There's one file descriptor per virtual counter used.
 The special file descriptor is opened via the perf_counter_open()
 system call:
 
- int
- perf_counter_open(u32 hw_event_type,
-                   u32 hw_event_period,
-                   u32 record_type,
-                   pid_t pid,
-                   int cpu);
+   int sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
+			     pid_t pid, int cpu, int group_fd);
 
 The syscall returns the new fd. The fd can be used via the normal
 VFS system calls: read() can be used to read the counter, fcntl()
@@ -33,39 +29,78 @@ can be used to set the blocking mode, etc.
 Multiple counters can be kept open at a time, and the counters
 can be poll()ed.
 
-When creating a new counter fd, 'hw_event_type' is one of:
-
- enum hw_event_types {
-	PERF_COUNT_CYCLES,
-	PERF_COUNT_INSTRUCTIONS,
-	PERF_COUNT_CACHE_REFERENCES,
-	PERF_COUNT_CACHE_MISSES,
-	PERF_COUNT_BRANCH_INSTRUCTIONS,
-	PERF_COUNT_BRANCH_MISSES,
- };
+When creating a new counter fd, 'perf_counter_hw_event' is:
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default */
+				nmi	     :  1, /* NMI sampling   */
+				raw	     :  1, /* raw event type */
+				__reserved_1 : 29;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	/*
+	 * Future software events:
+	 */
+	/* PERF_COUNT_PAGE_FAULTS	= -3,
+	   PERF_COUNT_CONTEXT_SWITCHES	= -4, */
+};
 
 These are standardized types of events that work uniformly on all CPUs
 that implements Performance Counters support under Linux. If a CPU is
 not able to count branch-misses, then the system call will return
 -EINVAL.
 
-[ Note: more hw_event_types are supported as well, but they are CPU
-  specific and are enumerated via /sys on a per CPU basis. Raw hw event
-  types can be passed in as negative numbers. For example, to count
-  "External bus cycles while bus lock signal asserted" events on Intel
-  Core CPUs, pass in a -0x4064 event type value. ]
-
-The parameter 'hw_event_period' is the number of events before waking up
-a read() that is blocked on a counter fd. Zero value means a non-blocking
-counter.
+More hw_event_types are supported as well, but they are CPU
+specific and are enumerated via /sys on a per CPU basis. Raw hw event
+types can be passed in under hw_event.type if hw_event.raw is 1.
+For example, to count "External bus cycles while bus lock signal asserted"
+events on Intel Core CPUs, pass in a 0x4064 event type value and set
+hw_event.raw to 1.
 
 'record_type' is the type of data that a read() will provide for the
 counter, and it can be one of:
 
-  enum perf_record_type {
-	PERF_RECORD_SIMPLE,
-	PERF_RECORD_IRQ,
-  };
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
 
 a "simple" counter is one that counts hardware events and allows
 them to be read out into a u64 count value. (read() returns 8 on
@@ -76,6 +111,10 @@ the IP of the interrupted context. In this case read() will return
 the 8-byte counter value, plus the Instruction Pointer address of the
 interrupted context.
 
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
 The 'pid' parameter allows the counter to be specific to a task:
 
  pid == 0: if the pid parameter is zero, the counter is attached to the
@@ -92,7 +131,7 @@ CPU:
  cpu >= 0: the counter is restricted to a specific CPU
  cpu == -1: the counter counts on all CPUs
 
-Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.
+(Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.)
 
 A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
 events of that task and 'follows' that task to whatever CPU the task
@@ -102,3 +141,7 @@ their own tasks.
 A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
 all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
 
+Group counters are created by passing in a group_fd of another counter.
+Groups are scheduled at once and can be used with PERF_RECORD_GROUP
+to record multi-dimensional timestamps.
+
