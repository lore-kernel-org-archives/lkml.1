Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbZLRSxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbZLRSxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZLRSxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:53:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZLRSxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:53:13 -0500
Date: Fri, 18 Dec 2009 19:52:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20091218185246.GA32199@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (3):
      signal: Fix racy access to __task_cred in kill_pid_info_as_uid()
      signals: Fix more rcu assumptions
      sys: Fix missing rcu protection for __task_cred() access


 kernel/signal.c |   25 ++++++++++++++-----------
 kernel/sys.c    |    2 ++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6b982f2..f67545f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -218,13 +218,13 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimi
 	struct user_struct *user;
 
 	/*
-	 * We won't get problems with the target's UID changing under us
-	 * because changing it requires RCU be used, and if t != current, the
-	 * caller must be holding the RCU readlock (by way of a spinlock) and
-	 * we use RCU protection here
+	 * Protect access to @t credentials. This can go away when all
+	 * callers hold rcu read lock.
 	 */
+	rcu_read_lock();
 	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
+	rcu_read_unlock();
 
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
@@ -1175,11 +1175,12 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	int ret = -EINVAL;
 	struct task_struct *p;
 	const struct cred *pcred;
+	unsigned long flags;
 
 	if (!valid_signal(sig))
 		return ret;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = pid_task(pid, PIDTYPE_PID);
 	if (!p) {
 		ret = -ESRCH;
@@ -1196,14 +1197,16 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	ret = security_task_kill(p, info, sig, secid);
 	if (ret)
 		goto out_unlock;
-	if (sig && p->sighand) {
-		unsigned long flags;
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		ret = __send_signal(sig, info, p, 1, 0);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+
+	if (sig) {
+		if (lock_task_sighand(p, &flags)) {
+			ret = __send_signal(sig, info, p, 1, 0);
+			unlock_task_sighand(p, &flags);
+		} else
+			ret = -ESRCH;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
diff --git a/kernel/sys.c b/kernel/sys.c
index 9968c5f..bc1dc61 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	if (niceval > 19)
 		niceval = 19;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -200,6 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 out:
 	return error;
 }
