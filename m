Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab0BZDri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:47:38 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65487 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124Ab0BZDrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:47:37 -0500
Message-Id: <201002260346.o1Q3kUmg005596@www262.sakura.ne.jp>
Subject: [PATCH] audit: Protect find_task_by_vpid() with RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, oleg@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, eparis@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Feb 2010 12:46:30 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25022010 #3421183, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] audit: Protect find_task_by_vpid() with RCU.

Holding tasklist_lock is no longer sufficient for find_task_by_vpid().
Explicit rcu_read_lock() is required.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> 
---
 kernel/audit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.33.orig/kernel/audit.c
+++ linux-2.6.33/kernel/audit.c
@@ -468,7 +468,9 @@ static int audit_prepare_user_tty(pid_t 
 	int err;
 
 	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	tsk = find_task_by_vpid(pid);
+	rcu_read_unlock();
 	err = -ESRCH;
 	if (!tsk)
 		goto out;
@@ -882,7 +884,9 @@ static int audit_receive_msg(struct sk_b
 		struct task_struct *tsk;
 
 		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
+		rcu_read_unlock();
 		if (!tsk)
 			err = -ESRCH;
 		else {
@@ -905,7 +909,9 @@ static int audit_receive_msg(struct sk_b
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
 		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
+		rcu_read_unlock();
 		if (!tsk)
 			err = -ESRCH;
 		else {
