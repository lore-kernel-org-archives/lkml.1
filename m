Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZHCNZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZHCNZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZHCNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:25:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbZHCNZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:25:29 -0400
Date: Mon, 3 Aug 2009 13:24:49 GMT
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org,
       akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
       sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       benh@kernel.crashing.org, akpm@linux-foundation.org, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <1248862529-6063-3-git-send-email-sgruszka@redhat.com>
References: <1248862529-6063-3-git-send-email-sgruszka@redhat.com>
Subject: [tip:timers/posixtimers] itimers: Fix periodic tics precision
Message-ID: <tip-8356b5f9c424e5831715abbce747197c30d1fd71@git.kernel.org>
Git-Commit-ID: 8356b5f9c424e5831715abbce747197c30d1fd71
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 13:24:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8356b5f9c424e5831715abbce747197c30d1fd71
Gitweb:     http://git.kernel.org/tip/8356b5f9c424e5831715abbce747197c30d1fd71
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Wed, 29 Jul 2009 12:15:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 Aug 2009 14:48:35 +0200

itimers: Fix periodic tics precision

Measure ITIMER_PROF and ITIMER_VIRT timers interval error
between real ticks and requested by user. Take it into account
when scheduling next tick.

This patch introduce possibility where time between two
consecutive tics is smaller then requested interval, it
preserve however dependency that n tick is generated not
earlier than n*interval time - counting from the beginning of
periodic signal generation.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <1248862529-6063-3-git-send-email-sgruszka@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
