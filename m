Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXKYOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXKYOoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXKYOoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:44:06 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54905 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXKYOoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:44:04 -0500
Date: Sun, 25 Nov 2007 17:44:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sys_setpgid: simplify pid/ns interaction
Message-ID: <20071125144428.GA6304@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_setpgid() does unneeded conversions from pid_t to "struct pid" and vice
versa. Use "struct pid" more consistently. Saves one find_vpid() and eliminates
the explicit usage of ->nsproxy->pid_ns. Imho, cleanups the code.

Also use the same_thread_group() helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/sys.c~	2007-11-20 17:16:10.000000000 +0300
+++ PT/kernel/sys.c	2007-11-25 17:16:59.000000000 +0300
@@ -916,8 +916,8 @@ asmlinkage long sys_setpgid(pid_t pid, p
 {
 	struct task_struct *p;
 	struct task_struct *group_leader = current->group_leader;
-	int err = -EINVAL;
-	struct pid_namespace *ns;
+	struct pid *pgrp;
+	int err;
 
 	if (!pid)
 		pid = task_pid_vnr(group_leader);
@@ -929,12 +929,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
 	 */
-	ns = current->nsproxy->pid_ns;
-
 	write_lock_irq(&tasklist_lock);
 
 	err = -ESRCH;
-	p = find_task_by_pid_ns(pid, ns);
+	p = find_task_by_vpid(pid);
 	if (!p)
 		goto out;
 
@@ -942,7 +940,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent->tgid == group_leader->tgid) {
+	if (same_thread_group(p->real_parent, group_leader)) {
 		err = -EPERM;
 		if (task_session(p) != task_session(group_leader))
 			goto out;
@@ -959,10 +957,12 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (p->signal->leader)
 		goto out;
 
+	pgrp = task_pid(p);
 	if (pgid != pid) {
 		struct task_struct *g;
 
-		g = find_task_by_pid_type_ns(PIDTYPE_PGID, pgid, ns);
+		pgrp = find_vpid(pgid);
+		g = pid_task(pgrp, PIDTYPE_PGID);
 		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
 	}
@@ -971,13 +971,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (err)
 		goto out;
 
-	if (task_pgrp_nr_ns(p, ns) != pgid) {
-		struct pid *pid;
-
+	if (task_pgrp(p) != pgrp) {
 		detach_pid(p, PIDTYPE_PGID);
-		pid = find_vpid(pgid);
-		attach_pid(p, PIDTYPE_PGID, pid);
-		set_task_pgrp(p, pid_nr(pid));
+		attach_pid(p, PIDTYPE_PGID, pgrp);
+		set_task_pgrp(p, pid_nr(pgrp));
 	}
 
 	err = 0;

