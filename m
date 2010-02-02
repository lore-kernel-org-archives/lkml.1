Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0BBMPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:15:24 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35664 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0BBMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:15:20 -0500
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 07:15:19 EST
Date: Tue, 2 Feb 2010 13:04:57 +0100
From: Lennart Poettering <lennart@poettering.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for
 child processes
Message-ID: <20100202120457.GA19605@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I already sent this patch half a year ago or so, as an RFC. I didn't
really get any comments back then, however I am still interested in
seeing this patch in the kernel tree. So here I go again: please
comment! I have updated the patch to apply to the current upstream git
master. ]

Right now, if a process dies all its children are reparented to init.
This logic has good uses, i.e. for double forking when daemonizing.
However it also allows child processes to "escape" their parents, which
is a problem for software like session managers (such as gnome-session)
or other process supervisors.

This patch adds a simple flag for each process that marks it as an
"anchor" process for all its children and grandchildren. If a child of
such an anchor dies all its children will not be reparented to init, but
instead to this anchor, escaping this anchor process is not possible. A
task with this flag set hence acts is little "sub-init".

Anchors are fully recursive: if an anchor dies, all its children are
reparented to next higher anchor in the process tree.

This is orthogonal to PID namespaces. PID namespaces virtualize the
actual IDs in addition to introducing "sub-inits". This patch introduces
"sub-inits" inside the same PID namespace.

This patch is compile tested only. It's relatively trivial, and is
written in ignorance of the expected locking logic for accessing
task_struct->parent. This mail is primarily intended as a request for
comments. So please, I'd be happy about any comments!

Lennart

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..e9b3dd1 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_SET_ANCHOR 35
+#define PR_GET_ANCHOR 36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index abdfacc..e9ab271 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1294,6 +1294,9 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
+	/* When a child of one of our children dies, reparent it to me, instead
+	 * of init. */
+	unsigned child_anchor:1;
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
@@ -1306,6 +1309,7 @@ struct task_struct {
 	unsigned long stack_canary;
 #endif
 
+
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..416883e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -704,7 +704,7 @@ static void exit_mm(struct task_struct * tsk)
 static struct task_struct *find_new_reaper(struct task_struct *father)
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
-	struct task_struct *thread;
+	struct task_struct *thread, *anchor;
 
 	thread = father;
 	while_each_thread(father, thread) {
@@ -715,6 +715,11 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		return thread;
 	}
 
+	/* find the first ancestor which is marked child_anchor */
+	for (anchor = father->parent; anchor != &init_task; anchor = anchor->parent)
+		if (anchor->child_anchor)
+			return anchor;
+
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
 		if (unlikely(pid_ns == &init_pid_ns))
diff --git a/kernel/fork.c b/kernel/fork.c
index 5b2959b..3d11673 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1265,6 +1265,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->parent_exec_id = current->self_exec_id;
 	}
 
+	p->child_anchor = 0;
+
 	spin_lock(&current->sighand->siglock);
 
 	/*
diff --git a/kernel/sys.c b/kernel/sys.c
index 26a6b73..8a1dfb1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1578,6 +1578,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_ANCHOR:
+			me->child_anchor = !!arg2;
+			error = 0;
+			break;
+		case PR_GET_ANCHOR:
+			error = put_user(me->child_anchor, (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.6



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
