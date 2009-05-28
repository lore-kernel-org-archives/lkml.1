Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbZE1VD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbZE1VD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbZE1VDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:03:18 -0400
Received: from tango.0pointer.de ([85.214.72.216]:37292 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbZE1VDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:03:17 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 17:03:16 EDT
Date: Thu, 28 May 2009 22:47:29 +0200
From: Lennart Poettering <lennart@poettering.net>
To: linux-lernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH/RFC] exit: PR_SET_ANCHOR for marking processes as reapers
	for child processes
Message-ID: <20090528204729.GA28564@omega>
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

Right now, if a process dies all its children are reparented to init.
This logic has good uses, i.e. for double forking when
daemonizing. However it also allows child processes to "escape" their
parents, which is a problem for software like session managers (such
as gnome-session) or other process supervisors [1].

This patch adds a simple flag for each process that marks it as an
"anchor" process for all its children and grandchildren. If a child of
such an anchor dies all its children will not be reparented to init, but
instead to this anchor, escaping this anchor process is not possible. A
task with this flag set hence acts as little "sub-init".

Anchors are fully recursive: if an anchor dies, all its children are
reparented to next higher anchor in the process tree.

This is orthogonal to PID namespaces. PID namespaces virtualize the
actual IDs in addition to introducing "sub-inits". This patch introduces
"sub-inits" inside the same PID namespace.

This patch is compile tested only. It's relatively trivial, and is
written in ignorance of the locking logic for accessing
task_struct->parent. This mail is primarily intended as a request for
comments. So please, I'd be happy about any comments!

Lennart

[1] To be fully useful for session managers/process supervisors we
    need one addition patch that makes the list of child processes of
    a processes easily accesible via /proc, so that a supervisor can
    keep track of its children.

---
 include/linux/prctl.h |    3 +++
 include/linux/sched.h |    4 ++++
 kernel/exit.c         |    7 ++++++-
 kernel/fork.c         |    2 ++
 kernel/sys.c          |    7 +++++++
 5 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 48d887e..1820edc 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -85,4 +85,7 @@
 #define PR_SET_TIMERSLACK 29
 #define PR_GET_TIMERSLACK 30
 
+#define PR_SET_ANCHOR 31
+#define PR_GET_ANCHOR 32
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c28c81b..c296328 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1189,6 +1189,10 @@ struct task_struct {
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
 
+	/* When a child of one of our children dies, reparent it to me, instead
+	 * of init. */
+	int child_anchor;
+
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
diff --git a/kernel/exit.c b/kernel/exit.c
index abf9cf3..20ce9da 100644
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
index b9e2edd..7c80680 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1218,6 +1218,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->parent_exec_id = current->self_exec_id;
 	}
 
+	p->child_anchor = 0;
+
 	spin_lock(&current->sighand->siglock);
 
 	/*
diff --git a/kernel/sys.c b/kernel/sys.c
index e7998cf..a8aa952 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1804,6 +1804,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				current->timer_slack_ns = arg2;
 			error = 0;
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
1.6.2.2



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
