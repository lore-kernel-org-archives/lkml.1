Return-Path: <linux-kernel-owner+w=401wt.eu-S935578AbZDIPol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935578AbZDIPol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765010AbZDIPo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:44:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935570AbZDIPoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:44:25 -0400
Date: Thu, 9 Apr 2009 17:43:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] timer fixes
Message-ID: <20090409154359.GA20384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Oleg Nesterov (2):
      posix-timers: fix RLIMIT_CPU && fork()
      posix-timers: fix RLIMIT_CPU && setitimer(CPUCLOCK_PROF)

Randy Dunlap (1):
      timers: add missing kernel-doc


 kernel/fork.c             |   13 +++++++++----
 kernel/posix-cpu-timers.c |    2 +-
 kernel/timer.c            |    7 +++++--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 4854c2c..9b51a1b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -808,6 +808,12 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
+	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp =
+			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		sig->cputimer.running = 1;
+	}
+
 	/* The timer lists. */
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
@@ -823,11 +829,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 		atomic_inc(&current->signal->live);
 		return 0;
 	}
-	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
-
-	if (sig)
-		posix_cpu_timers_init_group(sig);
 
+	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -865,6 +868,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
+	posix_cpu_timers_init_group(sig);
+
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8e5d9a6..bb53185 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -18,7 +18,7 @@ void update_rlimit_cpu(unsigned long rlim_new)
 
 	cputime = secs_to_cputime(rlim_new);
 	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_lt(current->signal->it_prof_expires, cputime)) {
+	    cputime_gt(current->signal->it_prof_expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
diff --git a/kernel/timer.c b/kernel/timer.c
index 9b77fc9..3af9a0b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -524,10 +524,13 @@ static void __init_timer(struct timer_list *timer)
 }
 
 /**
- * init_timer - initialize a timer.
+ * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
+ * @name: name of the timer
+ * @key: lockdep class key of the fake lock used for tracking timer
+ *       sync lock dependencies
  *
- * init_timer() must be done to a timer prior calling *any* of the
+ * init_timer_key() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
 void init_timer(struct timer_list *timer)
