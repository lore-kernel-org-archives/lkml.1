Return-Path: <linux-kernel-owner+w=401wt.eu-S1765594AbYA2Qh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765594AbYA2Qh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYA2Qhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:37:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48172 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYA2Qhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:37:47 -0500
Date: Tue, 29 Jan 2008 19:40:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-ID: <20080129164019.GA2060@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
but find_pid_ns()->hlist_for_each_entry_rcu() should be safe under tasklist.

Usually it is, detach_pid() is always called under write_lock(tasklist_lock),
but copy_process() calls free_pid() lockless.

"#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
too ugly and should be removed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/fork.c~PR_RCU	2008-01-27 17:09:47.000000000 +0300
+++ MM/kernel/fork.c	2008-01-29 19:23:44.000000000 +0300
@@ -1335,8 +1335,19 @@ static struct task_struct *copy_process(
 	return p;
 
 bad_fork_free_pid:
-	if (pid != &init_struct_pid)
+	if (pid != &init_struct_pid) {
+#ifdef CONFIG_PREEMPT_RCU
+		/*
+		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
+		 * make sure find_pid() is safe under read_lock(tasklist).
+		 */
+		write_lock_irq(&tasklist_lock);
+#endif
 		free_pid(pid);
+#ifdef CONFIG_PREEMPT_RCU
+		write_unlock_irq(&tasklist_lock);
+#endif
+	}
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_keys:

