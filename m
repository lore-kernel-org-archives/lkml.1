Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYGIPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYGIPCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbYGIPBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:01:53 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36206 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYGIPBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:01:51 -0400
Message-Id: <20080709150045.348339939@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "David S. Miller" <davem@davemloft.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 06/15] LTTng instrumentation - timer
Content-Disposition: inline; filename=lttng-instrumentation-timer.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrument timer activity (timer set, expired, current time updates) to keep
information about the "real time" flow within the kernel. It can be used by a
trace analysis tool to synchronize information coming from various sources, e.g.
to merge traces with system logs.

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: "David S. Miller" <davem@davemloft.net>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/itimer.c      |    5 +++++
 kernel/timer-trace.h |   24 ++++++++++++++++++++++++
 kernel/timer.c       |    8 +++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/itimer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/itimer.c	2008-07-09 10:46:33.000000000 -0400
+++ linux-2.6-lttng/kernel/itimer.c	2008-07-09 10:58:07.000000000 -0400
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/posix-timers.h>
 #include <linux/hrtimer.h>
+#include "timer-trace.h"
 
 #include <asm/uaccess.h>
 
@@ -132,6 +133,8 @@ enum hrtimer_restart it_real_fn(struct h
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
+	trace_timer_itimer_expired(sig);
+
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
@@ -157,6 +160,8 @@ int do_setitimer(int which, struct itime
 	    !timeval_valid(&value->it_interval))
 		return -EINVAL;
 
+	trace_timer_itimer_set(which, value);
+
 	switch (which) {
 	case ITIMER_REAL:
 again:
Index: linux-2.6-lttng/kernel/timer.c
===================================================================
--- linux-2.6-lttng.orig/kernel/timer.c	2008-07-09 10:55:46.000000000 -0400
+++ linux-2.6-lttng/kernel/timer.c	2008-07-09 10:58:07.000000000 -0400
@@ -37,12 +37,14 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include "timer-trace.h"
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/div64.h>
 #include <asm/timex.h>
 #include <asm/io.h>
+#include <asm/irq_regs.h>
 
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
@@ -288,6 +290,7 @@ static void internal_add_timer(struct tv
 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
 		vec = base->tv5.vec + i;
 	}
+	trace_timer_set(timer);
 	/*
 	 * Timers are FIFO:
 	 */
@@ -1066,6 +1069,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_times(ticks);
+	trace_timer_update_time(&xtime, &wall_to_monotonic);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
@@ -1147,7 +1151,9 @@ asmlinkage long sys_getegid(void)
 
 static void process_timeout(unsigned long __data)
 {
-	wake_up_process((struct task_struct *)__data);
+	struct task_struct *task = (struct task_struct *)__data;
+	trace_timer_timeout(task);
+	wake_up_process(task);
 }
 
 /**
Index: linux-2.6-lttng/kernel/timer-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/timer-trace.h	2008-07-09 10:58:07.000000000 -0400
@@ -0,0 +1,24 @@
+#ifndef _TIMER_TRACE_H
+#define _TIMER_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(timer_itimer_expired,
+	TPPROTO(struct signal_struct *sig),
+	TPARGS(sig));
+DEFINE_TRACE(timer_itimer_set,
+	TPPROTO(int which, struct itimerval *value),
+	TPARGS(which, value));
+DEFINE_TRACE(timer_set,
+	TPPROTO(struct timer_list *timer),
+	TPARGS(timer));
+/*
+ * xtime_lock is taken when kernel_timer_update_time tracepoint is reached.
+ */
+DEFINE_TRACE(timer_update_time,
+	TPPROTO(struct timespec *_xtime, struct timespec *_wall_to_monotonic),
+	TPARGS(_xtime, _wall_to_monotonic));
+DEFINE_TRACE(timer_timeout,
+	TPPROTO(struct task_struct *p),
+	TPARGS(p));
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
