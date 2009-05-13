Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZEMIIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZEMIIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZEMIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:07:52 -0400
Received: from r9di115.net.upc.cz ([78.102.112.115]:36930 "EHLO
	dhcp-lab-195.englab.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753583AbZEMIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:07:50 -0400
X-Greylist: delayed 3395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 04:07:49 EDT
From: Stanislaw Gruszka <sgruszka@redhat.com>
Organization: RedHat
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH resend2 1/2] itimers: merge ITIMER_VIRT and ITIMER_PROF common code
Date: Wed, 13 May 2009 09:09:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5; KDE/4.2.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090512135850.35e082ae@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090512135850.35e082ae@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905130909.36946.sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both cpu itimers have same data flow in the few places, this patch make
unification of code related with VIRT and PROF itimers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I resend again as previous patch was truncated, thanks to Andrew for pointing
this.

 include/linux/sched.h     |   11 +++-
 kernel/fork.c             |    8 +-
 kernel/itimer.c           |  142 ++++++++++++++++++++-------------------------
 kernel/posix-cpu-timers.c |   74 +++++++++++-------------
 4 files changed, 111 insertions(+), 124 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..58430e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -454,6 +454,14 @@ struct pacct_struct {
 	unsigned long		ac_minflt, ac_majflt;
 };
 
+struct cpu_itimer {
+	cputime_t expires;
+	cputime_t incr;
+};
+
+#define IT_PROF 0
+#define IT_VIRT 1
+
 /**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
@@ -540,8 +548,7 @@ struct signal_struct {
 	ktime_t it_real_incr;
 
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
-	cputime_t it_prof_expires, it_virt_expires;
-	cputime_t it_prof_incr, it_virt_incr;
+	struct cpu_itimer it[2];
 
 	/*
 	 * Thread group totals for process CPU timers.
diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..a6225d3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -790,10 +790,10 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	thread_group_cputime_init(sig);
 
 	/* Expiration times and increments. */
-	sig->it_virt_expires = cputime_zero;
-	sig->it_virt_incr = cputime_zero;
-	sig->it_prof_expires = cputime_zero;
-	sig->it_prof_incr = cputime_zero;
+	sig->it[IT_PROF].expires = cputime_zero;
+	sig->it[IT_PROF].incr = cputime_zero;
+	sig->it[IT_VIRT].expires = cputime_zero;
+	sig->it[IT_VIRT].incr = cputime_zero;
 
 	/* Cached expiration times. */
 	sig->cputime_expires.prof_exp = cputime_zero;
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 58762f7..ba66eac 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -41,10 +41,37 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
 	return ktime_to_timeval(rem);
 }
 
+static void get_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
+			   struct itimerval *value)
+{
+	cputime_t cval, cinterval;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero)) {
+		struct task_cputime cputime;
+		cputime_t utime;
+
+		thread_group_cputimer(tsk, &cputime);
+		utime = cputime.utime;
+		if (cputime_le(cval, utime)) { /* about to fire */
+			cval = jiffies_to_cputime(1);
+		} else {
+			cval = cputime_sub(cval, utime);
+		}
+	}
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	cputime_to_timeval(cval, &value->it_value);
+	cputime_to_timeval(cinterval, &value->it_interval);
+}
+
 int do_getitimer(int which, struct itimerval *value)
 {
 	struct task_struct *tsk = current;
-	cputime_t cinterval, cval;
 
 	switch (which) {
 	case ITIMER_REAL:
@@ -55,44 +82,10 @@ int do_getitimer(int which, struct itimerval *value)
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime cputime;
-			cputime_t utime;
-
-			thread_group_cputimer(tsk, &cputime);
-			utime = cputime.utime;
-			if (cputime_le(cval, utime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, utime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, &tsk->signal->it[IT_VIRT], value);
 		break;
 	case ITIMER_PROF:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime times;
-			cputime_t ptime;
-
-			thread_group_cputimer(tsk, &times);
-			ptime = cputime_add(times.utime, times.stime);
-			if (cputime_le(cval, ptime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, ptime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, &tsk->signal->it[IT_PROF], value);
 		break;
 	default:
 		return(-EINVAL);
@@ -128,6 +121,36 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static void set_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
+			   unsigned int clock_id, struct itimerval *value,
+			   struct itimerval *ovalue)
+{
+	cputime_t cval, cinterval, nval, ninterval;
+
+	nval = timeval_to_cputime(&value->it_value);
+	ninterval = timeval_to_cputime(&value->it_interval);
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero) ||
+	    !cputime_eq(nval, cputime_zero)) {
+		if (cputime_gt(nval, cputime_zero))
+			nval = cputime_add(nval, jiffies_to_cputime(1));
+		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
+	}
+	it->expires = nval;
+	it->incr = ninterval;
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (ovalue) {
+		cputime_to_timeval(cval, &ovalue->it_value);
+		cputime_to_timeval(cinterval, &ovalue->it_interval);
+	}
+}
+
 /*
  * Returns true if the timeval is in canonical form
  */
@@ -139,7 +162,6 @@ int do_setitimer(int which, struct itimerval *value, struct itimerval *ovalue)
 	struct task_struct *tsk = current;
 	struct hrtimer *timer;
 	ktime_t expires;
-	cputime_t cval, cinterval, nval, ninterval;
 
 	/*
 	 * Validate the timevals in value.
@@ -174,48 +196,12 @@ again:
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
-					      &nval, &cval);
-		}
-		tsk->signal->it_virt_expires = nval;
-		tsk->signal->it_virt_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, &tsk->signal->it[IT_VIRT], CPUCLOCK_VIRT,
+			       value, ovalue);
 		break;
 	case ITIMER_PROF:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
-					      &nval, &cval);
-		}
-		tsk->signal->it_prof_expires = nval;
-		tsk->signal->it_prof_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, &tsk->signal->it[IT_PROF], CPUCLOCK_PROF,
+			       value, ovalue);
 		break;
 	default:
 		return -EINVAL;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..654e655 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -17,8 +17,8 @@ void update_rlimit_cpu(unsigned long rlim_new)
 	cputime_t cputime;
 
 	cputime = secs_to_cputime(rlim_new);
-	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_gt(current->signal->it_prof_expires, cputime)) {
+	if (cputime_eq(current->signal->it[IT_PROF].expires, cputime_zero) ||
+	    cputime_gt(current->signal->it[IT_PROF].expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
@@ -620,18 +620,18 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (!cputime_eq(p->signal->it_virt_expires,
+				if (!cputime_eq(p->signal->it[IT_VIRT].expires,
 						cputime_zero) &&
-				    cputime_lt(p->signal->it_virt_expires,
+				    cputime_lt(p->signal->it[IT_VIRT].expires,
 					       timer->it.cpu.expires.cpu))
 					break;
 				p->signal->cputime_expires.virt_exp =
 					timer->it.cpu.expires.cpu;
 				break;
 			case CPUCLOCK_PROF:
-				if (!cputime_eq(p->signal->it_prof_expires,
+				if (!cputime_eq(p->signal->it[IT_PROF].expires,
 						cputime_zero) &&
-				    cputime_lt(p->signal->it_prof_expires,
+				    cputime_lt(p->signal->it[IT_PROF].expires,
 					       timer->it.cpu.expires.cpu))
 					break;
 				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
@@ -1070,6 +1070,28 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
+			     cputime_t *expires, cputime_t cur_time, int signo)
+{
+	if (cputime_eq(it->expires, cputime_zero))
+		return;
+
+	if (cputime_ge(cur_time, it->expires)) {
+		it->expires = it->incr;
+		if (!cputime_eq(it->expires, cputime_zero)) {
+			it->expires = cputime_add(it->expires, cur_time);
+		}
+
+		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
+	}
+
+	if (!cputime_eq(it->expires, cputime_zero) &&
+	    (cputime_eq(*expires, cputime_zero) ||
+	     cputime_lt(it->expires, *expires))) {
+		*expires = it->expires;
+	}
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1089,10 +1111,10 @@ static void check_process_timers(struct task_struct *tsk,
 	 * Don't sample the current process CPU clocks if there are no timers.
 	 */
 	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it_prof_expires, cputime_zero) &&
+	    cputime_eq(sig->it[IT_PROF].expires, cputime_zero) &&
 	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
+	    cputime_eq(sig->it[IT_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
 		stop_process_timers(tsk);
 		return;
@@ -1152,38 +1174,10 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Check for the special case process timers.
 	 */
-	if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-		if (cputime_ge(ptime, sig->it_prof_expires)) {
-			/* ITIMER_PROF fires and reloads.  */
-			sig->it_prof_expires = sig->it_prof_incr;
-			if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-				sig->it_prof_expires = cputime_add(
-					sig->it_prof_expires, ptime);
-			}
-			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
-		    (cputime_eq(prof_expires, cputime_zero) ||
-		     cputime_lt(sig->it_prof_expires, prof_expires))) {
-			prof_expires = sig->it_prof_expires;
-		}
-	}
-	if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-		if (cputime_ge(utime, sig->it_virt_expires)) {
-			/* ITIMER_VIRTUAL fires and reloads.  */
-			sig->it_virt_expires = sig->it_virt_incr;
-			if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-				sig->it_virt_expires = cputime_add(
-					sig->it_virt_expires, utime);
-			}
-			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
-		    (cputime_eq(virt_expires, cputime_zero) ||
-		     cputime_lt(sig->it_virt_expires, virt_expires))) {
-			virt_expires = sig->it_virt_expires;
-		}
-	}
+	check_cpu_itimer(tsk, &sig->it[IT_PROF], &prof_expires, ptime, SIGPROF);
+	check_cpu_itimer(tsk, &sig->it[IT_VIRT], &virt_expires, utime,
+			 SIGVTALRM);
+
 	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
 		cputime_t x;
-- 
1.6.0.6

