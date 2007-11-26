Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXKZO0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXKZO0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXKZOZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:25:38 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:36875 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbXKZOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:25:37 -0500
Date: Mon, 26 Nov 2007 17:25:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
Message-ID: <20071126142553.GA16525@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_setsid() still deals with pid_t's from the global namespace. This means
that the "session > 1" check can't help for sub-namespace init, setsid() can't
succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.

Remove the usage of task_struct->pid and convert the code to use "struct pid".
This also simplifies and speedups the code, saves one find_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/sys.c~1_setsid	2007-11-26 15:52:15.000000000 +0300
+++ PT/kernel/sys.c	2007-11-26 16:10:43.000000000 +0300
@@ -1045,35 +1045,33 @@ asmlinkage long sys_getsid(pid_t pid)
 asmlinkage long sys_setsid(void)
 {
 	struct task_struct *group_leader = current->group_leader;
-	pid_t session;
+	struct pid *sid = task_pid(group_leader);
+	pid_t session = pid_vnr(sid);
 	int err = -EPERM;
 
 	write_lock_irq(&tasklist_lock);
-
 	/* Fail if I am already a session leader */
 	if (group_leader->signal->leader)
 		goto out;
 
-	session = group_leader->pid;
-	/* Fail if a process group id already exists that equals the
-	 * proposed session id.
+	/* Fail if a process group id already exists that equals the proposed
+	 * session id.
 	 *
-	 * Don't check if session id == 1 because kernel threads use this
-	 * session id and so the check will always fail and make it so
-	 * init cannot successfully call setsid.
+	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
+	 * tasks use this session id and so the check will always fail and make
+	 * it so init cannot successfully call setsid.
 	 */
-	if (session > 1 && find_task_by_pid_type_ns(PIDTYPE_PGID,
-				session, &init_pid_ns))
+	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(session, session);
+	__set_special_pids(pid_nr(sid), pid_nr(sid));
 
 	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
 	spin_unlock(&group_leader->sighand->siglock);
 
-	err = task_pgrp_vnr(group_leader);
+	err = session;
 out:
 	write_unlock_irq(&tasklist_lock);
 	return err;

