Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbZLJWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbZLJWJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbZLJWJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:09:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:41290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761858AbZLJWJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:09:49 -0500
Date: Thu, 10 Dec 2009 22:09:31 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20091210004703.232302055@linutronix.de>
References: <20091210004703.232302055@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] signal: Fix racy access to __task_cred in kill_pid_info_as_uid()
Message-ID: <tip-14d8c9f3c09e7fd7b9af80904289fe204f5b93c6@git.kernel.org>
Git-Commit-ID: 14d8c9f3c09e7fd7b9af80904289fe204f5b93c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14d8c9f3c09e7fd7b9af80904289fe204f5b93c6
Gitweb:     http://git.kernel.org/tip/14d8c9f3c09e7fd7b9af80904289fe204f5b93c6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 10 Dec 2009 00:53:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Dec 2009 23:04:11 +0100

signal: Fix racy access to __task_cred in kill_pid_info_as_uid()

kill_pid_info_as_uid() accesses __task_cred() without being in a RCU
read side critical section. tasklist_lock is not protecting that when
CONFIG_TREE_PREEMPT_RCU=y.

Convert the whole tasklist_lock section to rcu and use
lock_task_sighand to prevent the exit race.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091210004703.232302055@linutronix.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6b982f2..7331656 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
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
