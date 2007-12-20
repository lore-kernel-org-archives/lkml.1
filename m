Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbXLTNLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbXLTNLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbXLTNLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:11:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43779
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbXLTNLo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:11:44 -0500
Message-Id: <476A7832.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 20 Dec 2007 13:12:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] add task handling notifier: base definitions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the base patch, adding notification for task creation and
deletion.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
---
 include/linux/sched.h |    8 +++++++-
 kernel/fork.c         |   11 +++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

--- 2.6.24-rc5-notify-task.orig/include/linux/sched.h
+++ 2.6.24-rc5-notify-task/include/linux/sched.h
@@ -80,7 +80,7 @@ struct sched_param {
 #include <linux/rcupdate.h>
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
-
+#include <linux/notifier.h>
 #include <linux/time.h>
 #include <linux/param.h>
 #include <linux/resource.h>
@@ -1700,6 +1700,12 @@ extern int do_execve(char *, char __user
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
+#define TASK_NEW 1
+#define TASK_DELETE 2
+
+extern struct blocking_notifier_head task_notifier_list;
+extern struct atomic_notifier_head atomic_task_notifier_list;
+
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern void get_task_comm(char *to, struct task_struct *tsk);
 
--- 2.6.24-rc5-notify-task.orig/kernel/fork.c
+++ 2.6.24-rc5-notify-task/kernel/fork.c
@@ -46,6 +46,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/freezer.h>
+#include <linux/notifier.h>
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
@@ -71,6 +72,11 @@ DEFINE_PER_CPU(unsigned long, process_co
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
+BLOCKING_NOTIFIER_HEAD(task_notifier_list);
+EXPORT_SYMBOL_GPL(task_notifier_list);
+ATOMIC_NOTIFIER_HEAD(atomic_task_notifier_list);
+EXPORT_SYMBOL_GPL(atomic_task_notifier_list);
+
 int nr_processes(void)
 {
 	int cpu;
@@ -121,6 +127,9 @@ void __put_task_struct(struct task_struc
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	atomic_notifier_call_chain(&atomic_task_notifier_list,
+				   TASK_DELETE, tsk);
+
 	security_task_free(tsk);
 	free_uid(tsk->user);
 	put_group_info(tsk->group_info);
@@ -1450,6 +1459,8 @@ long do_fork(unsigned long clone_flags,
 			set_tsk_thread_flag(p, TIF_SIGPENDING);
 		}
 
+		blocking_notifier_call_chain(&task_notifier_list, TASK_NEW, p);
+
 		if (!(clone_flags & CLONE_STOPPED))
 			wake_up_new_task(p, clone_flags);
 		else



