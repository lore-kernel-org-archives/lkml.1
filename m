Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZEVNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZEVNui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbZEVNuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:50:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZEVNuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:50:16 -0400
Date: Fri, 22 May 2009 15:43:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend4 2/3] itimers: fix periodic tics precision
Message-ID: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Compared to previous patch Thomas idea of calculating ticks is used. I'm not
using ktime anymore as all calculations can be done in 32 bits.

 include/linux/sched.h     |    2 ++
 kernel/itimer.c           |   21 ++++++++++++++++++---
 kernel/posix-cpu-timers.c |   20 +++++++++++++++++---
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a29aab8..237542a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -457,6 +457,8 @@ struct pacct_struct {
 struct cpu_itimer {
 	cputime_t expires;
 	cputime_t incr;
+	u32 error;
+	u32 incr_error;
 };
 
 /**
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 852c88d..c645793 100644
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
@@ -127,14 +127,29 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+#define CPUTIME_SUB_NS(ct, real_ns) ({ 		\
+	struct timespec ts;			\
+	s64 cpu_ns;				\
+	cputime_to_timespec(ct, &ts); 		\
+	cpu_ns = timespec_to_ns(&ts);		\
+	cpu_ns - real_ns;	 		\
+})
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
+	it->incr_error = CPUTIME_SUB_NS(ninterval, ns_ninterval);
+	it->error = CPUTIME_SUB_NS(nval, ns_nval);
 
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
1.5.5.6

