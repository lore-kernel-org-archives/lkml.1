Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZIBMTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZIBMTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZIBMTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:19:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:39696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbZIBMTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:19:13 -0400
Date: Wed, 2 Sep 2009 12:18:47 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, zhaolei@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4A7F8B6E.2010109@cn.fujitsu.com>
References: <4A7F8B6E.2010109@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/tracing] itimers: Add tracepoints for itimer
Message-ID: <tip-3f0a525ebf4b8ef041a332bbe4a73aee94bb064b@git.kernel.org>
Git-Commit-ID: 3f0a525ebf4b8ef041a332bbe4a73aee94bb064b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 12:18:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f0a525ebf4b8ef041a332bbe4a73aee94bb064b
Gitweb:     http://git.kernel.org/tip/3f0a525ebf4b8ef041a332bbe4a73aee94bb064b
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 10 Aug 2009 10:52:30 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 29 Aug 2009 14:10:07 +0200

itimers: Add tracepoints for itimer

Add tracepoints for all itimer variants: ITIMER_REAL, ITIMER_VIRTUAL
and ITIMER_PROF.

[ tglx: Fixed comments and made the output more readable, parseable
  	and consistent. Replaced pid_vnr by pid_nr because the hrtimer
  	callback can happen in any namespace ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A7F8B6E.2010109@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/trace/events/timer.h |   66 ++++++++++++++++++++++++++++++++++++++++++
 kernel/itimer.c              |    5 +++
 kernel/posix-cpu-timers.c    |    7 ++++-
 3 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index df3c07f..1844c48 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -270,6 +270,72 @@ TRACE_EVENT(hrtimer_cancel,
 	TP_printk("hrtimer %p", __entry->timer)
 );
 
+/**
+ * itimer_state - called when itimer is started or canceled
+ * @which:	name of the interval timer
+ * @value:	the itimers value, itimer is canceled if value->it_value is
+ *		zero, otherwise it is started
+ * @expires:	the itimers expiry time
+ */
+TRACE_EVENT(itimer_state,
+
+	TP_PROTO(int which, const struct itimerval *const value,
+		 cputime_t expires),
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
+	TP_printk("which %d, expires %lu, it_value %lu.%lu, it_interval %lu.%lu",
+		  __entry->which, __entry->expires,
+		  __entry->value_sec, __entry->value_usec,
+		  __entry->interval_sec, __entry->interval_usec)
+);
+
+/**
+ * itimer_expire - called when itimer expires
+ * @which:	type of the interval timer
+ * @pid:	pid of the process which owns the timer
+ * @now:	current time, used to calculate the latency of itimer
+ */
+TRACE_EVENT(itimer_expire,
+
+	TP_PROTO(int which, struct pid *pid, cputime_t now),
+
+	TP_ARGS(which, pid, now),
+
+	TP_STRUCT__entry(
+		__field( int ,		which	)
+		__field( pid_t,		pid	)
+		__field( cputime_t,	now	)
+	),
+
+	TP_fast_assign(
+		__entry->which	= which;
+		__entry->now	= now;
+		__entry->pid	= pid_nr(pid);
+	),
+
+	    TP_printk("which %d, pid %d, now %lu", __entry->which,
+		      (int) __entry->pid, __entry->now)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 8078a32..b03451e 100644
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
+	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
+			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
 
 	spin_unlock_irq(&tsk->sighand->siglock);
 
@@ -217,6 +221,7 @@ again:
 		} else
 			tsk->signal->it_real_incr.tv64 = 0;
 
+		trace_itimer_state(ITIMER_REAL, value, 0);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 12161f7..5c9dc22 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -8,6 +8,7 @@
 #include <linux/math64.h>
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
+#include <trace/events/timer.h>
 
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
@@ -1090,9 +1091,13 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 							  cputime_one_jiffy);
 				it->error -= onecputick;
 			}
-		} else
+		} else {
 			it->expires = cputime_zero;
+		}
 
+		trace_itimer_expire(signo == SIGPROF ?
+				    ITIMER_PROF : ITIMER_VIRTUAL,
+				    tsk->signal->leader_pid, cur_time);
 		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
 	}
 
