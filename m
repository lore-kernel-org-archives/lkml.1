Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZHJCxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZHJCxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 22:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZHJCxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 22:53:04 -0400
Received: from [222.73.24.84] ([222.73.24.84]:63437 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZHJCxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 22:53:02 -0400
Message-ID: <4A7F8B6E.2010109@cn.fujitsu.com>
Date: Mon, 10 Aug 2009 10:52:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/3] ftrace: add tracepoint for itimer
References: <4A7F8A9B.3040201@cn.fujitsu.com>
In-Reply-To: <4A7F8A9B.3040201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those tracepoints are wanted and useful:
1: We can detect a itimer's delay
2: We can monitor the lifecycle and behaviors of a itimer

Thus they help in analysing and debuging.

Great thanks to Thomas for giving me so many valuable advices.

There have two case: 
case 1, if we use ITIMER_REAL itimer:
Example ftrace output:
  main-1517  [000]   288.826521: hrtimer_start: timer=ce807544 func=it_real_fn expires=289327664443 ns softexpires=289327664443 ns
  main-1517  [000]   288.826524: itimer_state: which=0 expires=0 it_value=0.500 it_interval=0.0
  main-1517  [000]   288.827313: hrtimer_expire: timer=ce807544 now=289327958161 ns
  main-1517  [000]   288.827314: hrtimer_cancel: timer=ce807544
  main-1517  [000]   288.827315: itimer_expire: pid=1517 which=0 now=0
  main-1517  [000]   288.827319: hrtimer_callback_done: timer=ce807544
  main-1517  [000]   288.827463: itimer_state: which=0 expires=0 it_value=0.0 it_interval=0.0

ITIMER_REAL itime use hrtimer to calculate time, so we can cooperate with
hrtimer's tracepoint to get it's delay.

from this output information, the process set up a ITIMER_REAL
iteimr(which=0), use a hrtime which address is ce807544, we can get the
delay is 289327958161-289327664443=293718 ns

case 2, if we use ITIMER_VIRTUAL/ITIMER_PROF itimer:
Example ftrace output:
  main-5409  [001] 12763.874835: itimer_state: which=1 expires=2 it_value=0.500 it_interval=0.500
  main-5409  [001] 12763.883495: itimer_expire: pid=5409 which=1 now=2
  main-5409  [001] 12763.883712: itimer_state: which=1 expires=0 it_value=0.0 it_interval=0.0
  
from this, we can know the itimer delay is 2-2=0 jiffies.

Changelog:
v1->v2:
Remove ktime_to_ns() in TP_fast_assign()
v2->v3:
Below changes are all base on Thomas's suggestion:
1: Remove ITIMER_REAL's timer address and 'state' from trace_itimer_state()
2: Don't save task's name in trace_itimer_state()
3: Save task's pid instead of task's name in trace_itimer_expire()
v3->v4:
Modify other two patches in this patchset
v4->v5:
Rebase the patch against latest tip tree

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   65 ++++++++++++++++++++++++++++++++++++++++++
 kernel/itimer.c              |    5 +++
 kernel/posix-cpu-timers.c    |    3 ++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 6140f29..fbbead9 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -261,6 +261,71 @@ TRACE_EVENT(hrtimer_cancel,
 	TP_printk("timer=%p", __entry->timer)
 );
 
+/**
+ * itimer_state - called when itimer is started or canceled
+ * @which: name of the interval timer
+ * @value: the itimer's value, itimer is canceled if value->it_value is zero,
+ * 	   otherwise is started
+ * @expires: the itimer's expire time
+ **/
+TRACE_EVENT(itimer_state,
+
+	TP_PROTO(int which, const struct itimerval *const value, cputime_t expires),
+
+	TP_ARGS(which, value, expires),
+
+	TP_STRUCT__entry(
+		__field(	int,		which		)
+		__field(	cputime_t,	expires		)
+		__field(	long,		value_sec	)
+		__field(	long,		value_usec	)
+		__field(	long,		interval_sec	)
+		__field(	long,		interval_usec	)
+	),
+
+	TP_fast_assign(
+		__entry->which		= which;
+		__entry->expires	= expires;
+		__entry->value_sec	= value->it_value.tv_sec;
+		__entry->value_usec	= value->it_value.tv_usec;
+		__entry->interval_sec	= value->it_interval.tv_sec;
+		__entry->interval_usec	= value->it_interval.tv_usec;
+	),
+
+	TP_printk("which=%d expires=%lu it_value=%lu.%lu it_interval=%lu.%lu",
+		  __entry->which, __entry->expires,
+		  __entry->value_sec, __entry->value_usec,
+		  __entry->interval_sec, __entry->interval_usec)
+);
+
+/**
+ * itimer_expire: called when itimer expires
+ * @which: name of the interval timer
+ * @pid: pid of process which owns the itimer
+ * @now: current time, used to calculate the latency of itimer
+ **/
+TRACE_EVENT(itimer_expire,
+
+	TP_PROTO(int which, struct pid *pid, cputime_t now),
+
+	TP_ARGS(which, pid, now),
+
+	TP_STRUCT__entry(
+		__field( int ,		which	)
+		__field( int,		pid	)
+		__field( cputime_t,	now	)
+	),
+
+	TP_fast_assign(
+		__entry->which	= which;
+		__entry->now	= now;
+		__entry->pid	= pid_vnr(pid);
+	),
+
+	TP_printk("pid=%d which=%d now=%lu", __entry->pid, __entry->which,
+		  __entry->now)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 8078a32..a3ceb34 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/posix-timers.h>
 #include <linux/hrtimer.h>
+#include <trace/events/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -122,6 +123,7 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
+	trace_itimer_expire(ITIMER_REAL, sig->leader_pid, 0);
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
@@ -166,6 +168,8 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	}
 	it->expires = nval;
 	it->incr = ninterval;
+	trace_itimer_state(clock_id == CPUCLOCK_VIRT ? ITIMER_VIRTUAL : ITIMER_PROF,
+			   value, nval);
 
 	spin_unlock_irq(&tsk->sighand->siglock);
 
@@ -217,6 +221,7 @@ again:
 		} else
 			tsk->signal->it_real_incr.tv64 = 0;
 
+		trace_itimer_state(ITIMER_REAL, value, 0);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 12161f7..14798a7 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -8,6 +8,7 @@
 #include <linux/math64.h>
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
+#include <trace/events/timer.h>
 
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
@@ -1093,6 +1094,8 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 		} else
 			it->expires = cputime_zero;
 
+		trace_itimer_expire(signo == SIGPROF ? ITIMER_PROF : ITIMER_VIRTUAL,
+				    tsk->signal->leader_pid, cur_time);
 		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
 	}
 
-- 
1.6.1.2


