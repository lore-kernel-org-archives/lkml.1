Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYCTPYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYCTPYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYCTPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:23:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36866 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbYCTPXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:23:50 -0400
Date: Thu, 20 Mar 2008 18:28:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pids: introduce change_pid() helper
Message-ID: <20080320152817.GA6335@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Eric W. Biederman's idea.

Without tasklist_lock held task_session()/task_pgrp() can return NULL if the
caller races with setprgp()/setsid() which does detach_pid() + attach_pid().
This can happen even if task == current.

Intoduce the new helper, change_pid(), which should be used instead. This way
the caller always sees the special pid != NULL, either old or new.

Also change the prototype of attach_pid(), it always returns 0 and nobody check
the returned value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/pid.h~2_PID_CHANGE	2008-03-20 18:02:22.000000000 +0300
+++ 25/include/linux/pid.h	2008-03-20 18:07:37.000000000 +0300
@@ -89,9 +89,11 @@ extern struct pid *get_task_pid(struct t
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
  */
-extern int attach_pid(struct task_struct *task, enum pid_type type,
-		      struct pid *pid);
+extern void attach_pid(struct task_struct *task, enum pid_type type,
+			struct pid *pid);
 extern void detach_pid(struct task_struct *task, enum pid_type);
+extern void change_pid(struct task_struct *task, enum pid_type,
+			struct pid *pid);
 extern void transfer_pid(struct task_struct *old, struct task_struct *new,
 			 enum pid_type);
 
--- 25/kernel/pid.c~2_PID_CHANGE	2008-03-20 17:22:19.000000000 +0300
+++ 25/kernel/pid.c	2008-03-20 18:04:28.000000000 +0300
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int attach_pid(struct task_struct *task, enum pid_type type,
+void attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	struct pid_link *link;
@@ -325,11 +325,10 @@ int attach_pid(struct task_struct *task,
 	link = &task->pids[type];
 	link->pid = pid;
 	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
-
-	return 0;
 }
 
-void detach_pid(struct task_struct *task, enum pid_type type)
+static void __change_pid(struct task_struct *task, enum pid_type type,
+			struct pid *new)
 {
 	struct pid_link *link;
 	struct pid *pid;
@@ -339,7 +338,7 @@ void detach_pid(struct task_struct *task
 	pid = link->pid;
 
 	hlist_del_rcu(&link->node);
-	link->pid = NULL;
+	link->pid = new;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
@@ -348,6 +347,18 @@ void detach_pid(struct task_struct *task
 	free_pid(pid);
 }
 
+void detach_pid(struct task_struct *task, enum pid_type type)
+{
+	__change_pid(task, type, NULL);
+}
+
+void change_pid(struct task_struct *task, enum pid_type type,
+		struct pid *pid)
+{
+	__change_pid(task, type, pid);
+	attach_pid(task, type, pid);
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)

