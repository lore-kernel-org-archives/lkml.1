Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZLJAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZLJAym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbZLJAy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:26 -0500
Received: from www.tglx.de ([62.245.132.106]:54091 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142AbZLJAyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:23 -0500
Message-Id: <20091210004703.232302055@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [patch 6/9] signal: Fix racy access to __task_cred in
	kill_pid_info_as_uid()
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline; filename=signal-fix-racy-access-to-task-cred.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill_pid_info_as_uid() accesses __task_cred() without being in a RCU
read side critical section. tasklist_lock is not protecting that when
CONFIG_TREE_PREEMPT_RCU=y.

Convert the whole tasklist_lock section to rcu and use
lock_task_sighand to prevent the exit race.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/kernel/signal.c
+++ linux-2.6-tip/kernel/signal.c
@@ -1175,11 +1175,12 @@ int kill_pid_info_as_uid(int sig, struct
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
@@ -1196,14 +1197,16 @@ int kill_pid_info_as_uid(int sig, struct
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


