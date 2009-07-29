Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZG2KQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZG2KQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZG2KQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:16:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45812 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZG2KQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:16:31 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/4] itimers: fix periodic tics precision
Date: Wed, 29 Jul 2009 12:15:27 +0200
Message-Id: <1248862529-6063-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1248862529-6063-2-git-send-email-sgruszka@redhat.com>
References: <1248862529-6063-1-git-send-email-sgruszka@redhat.com>
 <1248862529-6063-2-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Measure ITIMER_PROF and ITIMER_VIRT timers interval error between real ticks
and requested by user. Take it into account when scheduling next tick.

This patch introduce possibility where time between two consecutive tics is
smaller then requested interval, it preserve however dependency that n tick
is generated not earlier than n*interval time - counting from the beginning
of periodic signal generation.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/sched.h     |    2 ++
 kernel/itimer.c           |   24 +++++++++++++++++++++---
 kernel/posix-cpu-timers.c |   20 +++++++++++++++++---
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3b3efad..a069e65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -473,6 +473,8 @@ struct pacct_struct {
 struct cpu_itimer {
 	cputime_t expires;
 	cputime_t incr;
+	u32 error;
+	u32 incr_error;
 };
 
 /**
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 852c88d..21adff7 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -42,7 +42,7 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
 }
 
 static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
-			   struct itimerval *value)
+			   struct itimerval *const value)
 {
 	cputime_t cval, cinterval;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
@@ -127,14 +127,32 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static inline u32 cputime_sub_ns(cputime_t ct, s64 real_ns)
+{
+	struct timespec ts;
+	s64 cpu_ns;
+
+	cputime_to_timespec(ct, &ts);
+	cpu_ns = timespec_to_ns(&ts);
+
+	return (cpu_ns <= real_ns) ? 0 : cpu_ns - real_ns;
+}
+
 static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
-			   struct itimerval *value, struct itimerval *ovalue)
+			   const struct itimerval *const value,
+			   struct itimerval *const ovalue)
 {
-	cputime_t cval, cinterval, nval, ninterval;
+	cputime_t cval, nval, cinterval, ninterval;
+	s64 ns_ninterval, ns_nval;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
 	nval = timeval_to_cputime(&value->it_value);
+	ns_nval = timeval_to_ns(&value->it_value);
 	ninterval = timeval_to_cputime(&value->it_interval);
+	ns_ninterval = timeval_to_ns(&value->it_interval);
+
+	it->incr_error = cputime_sub_ns(ninterval, ns_ninterval);
+	it->error = cputime_sub_ns(nval, ns_nval);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9b2d5e4..b60d644 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1070,6 +1070,8 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+static u32 onecputick;
+
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			     cputime_t *expires, cputime_t cur_time, int signo)
 {
@@ -1077,9 +1079,16 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 		return;
 
 	if (cputime_ge(cur_time, it->expires)) {
-		it->expires = it->incr;
-		if (!cputime_eq(it->expires, cputime_zero))
-			it->expires = cputime_add(it->expires, cur_time);
+		if (!cputime_eq(it->incr, cputime_zero)) {
+			it->expires = cputime_add(it->expires, it->incr);
+			it->error += it->incr_error;
+			if (it->error >= onecputick) {
+				it->expires = cputime_sub(it->expires,
+							jiffies_to_cputime(1));
+				it->error -= onecputick;
+			}
+		} else
+			it->expires = cputime_zero;
 
 		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
 	}
@@ -1696,10 +1705,15 @@ static __init int init_posix_cpu_timers(void)
 		.nsleep = thread_cpu_nsleep,
 		.nsleep_restart = thread_cpu_nsleep_restart,
 	};
+	struct timespec ts;
 
 	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
 	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
+	cputime_to_timespec(jiffies_to_cputime(1), &ts);
+	onecputick = ts.tv_nsec;
+	WARN_ON(ts.tv_sec != 0);
+
 	return 0;
 }
 __initcall(init_posix_cpu_timers);
-- 
1.6.2.5

