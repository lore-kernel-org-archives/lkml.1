Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbXLTNNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbXLTNNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbXLTNMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:12:55 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43876
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759778AbXLTNMy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:12:54 -0500
Message-Id: <476A7877.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 20 Dec 2007 13:13:11 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] add task handling notifier: connector based proc
	events
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the additional benefit of allowing the code to now be built
as a module (which made it necessary to add MODULE_xxx declarations).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
---
 drivers/connector/Kconfig   |    5 +--
 drivers/connector/cn_proc.c |   57 ++++++++++++++++++++++++++++++++++++++++----
 fs/exec.c                   |    5 ++-
 include/linux/cn_proc.h     |   21 ----------------
 include/linux/sched.h       |    4 +++
 kernel/exit.c               |    5 ++-
 kernel/fork.c               |    2 -
 kernel/sys.c                |   27 +++++++++++++-------
 8 files changed, 83 insertions(+), 43 deletions(-)

--- 2.6.24-rc5-notify-task.orig/drivers/connector/Kconfig
+++ 2.6.24-rc5-notify-task/drivers/connector/Kconfig
@@ -12,9 +12,8 @@ menuconfig CONNECTOR
 if CONNECTOR
 
 config PROC_EVENTS
-	boolean "Report process events to userspace"
-	depends on CONNECTOR=y
-	default y
+	tristate "Report process events to userspace"
+	default CONNECTOR
 	---help---
 	  Provide a connector that reports process events to userspace. Send
 	  events such as fork, exec, id change (uid, gid, suid, etc), and exit.
--- 2.6.24-rc5-notify-task.orig/drivers/connector/cn_proc.c
+++ 2.6.24-rc5-notify-task/drivers/connector/cn_proc.c
@@ -26,12 +26,17 @@
 #include <linux/kernel.h>
 #include <linux/ktime.h>
 #include <linux/init.h>
+#include <linux/notifier.h>
 #include <linux/connector.h>
 #include <asm/atomic.h>
 #include <asm/unaligned.h>
 
 #include <linux/cn_proc.h>
 
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Matt Helsley <matthltc@us.ibm.com>");
+MODULE_DESCRIPTION("Process events -> userspace connector");
+
 #define CN_PROC_MSG_SIZE (sizeof(struct cn_msg) + sizeof(struct proc_event))
 
 static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
@@ -47,7 +52,7 @@ static inline void get_seq(__u32 *ts, in
 	put_cpu_var(proc_event_counts);
 }
 
-void proc_fork_connector(struct task_struct *task)
+static void proc_fork_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
@@ -75,7 +80,7 @@ void proc_fork_connector(struct task_str
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
-void proc_exec_connector(struct task_struct *task)
+static void proc_exec_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
@@ -100,7 +105,7 @@ void proc_exec_connector(struct task_str
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
-void proc_id_connector(struct task_struct *task, int which_id)
+static void proc_id_connector(struct task_struct *task, int which_id)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
@@ -133,7 +138,7 @@ void proc_id_connector(struct task_struc
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
-void proc_exit_connector(struct task_struct *task)
+static void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
@@ -220,6 +225,35 @@ static void cn_proc_mcast_ctl(void *data
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
+static int connector_task_notifier(struct notifier_block *nb,
+				   unsigned long action,
+				   void *task)
+{
+	switch (action) {
+	case TASK_NEW:
+		proc_fork_connector(task);
+		break;
+	case TASK_EXEC:
+		proc_exec_connector(task);
+		break;
+	case TASK_EXIT:
+		proc_exit_connector(task);
+		break;
+	case TASK_UID_CHANGE:
+		proc_id_connector(task, PROC_EVENT_UID);
+		break;
+	case TASK_GID_CHANGE:
+		proc_id_connector(task, PROC_EVENT_GID);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block connector_task_notifier_block = {
+	.notifier_call = connector_task_notifier
+};
+
 /*
  * cn_proc_init - initialization entry point
  *
@@ -234,7 +268,22 @@ static int __init cn_proc_init(void)
 		printk(KERN_WARNING "cn_proc failed to register\n");
 		return err;
 	}
+	blocking_notifier_chain_register(&task_notifier_list,
+					 &connector_task_notifier_block);
 	return 0;
 }
 
+/*
+ * cn_proc_exit - unload entry point
+ *
+ * Removes the connector callback from the connector driver.
+ */
+static void __exit cn_proc_exit(void)
+{
+	blocking_notifier_chain_unregister(&task_notifier_list,
+					   &connector_task_notifier_block);
+	cn_del_callback(&cn_proc_event_id);
+}
+
 module_init(cn_proc_init);
+module_exit(cn_proc_exit);
--- 2.6.24-rc5-notify-task.orig/fs/exec.c
+++ 2.6.24-rc5-notify-task/fs/exec.c
@@ -49,7 +49,7 @@
 #include <linux/syscalls.h>
 #include <linux/rmap.h>
 #include <linux/tsacct_kern.h>
-#include <linux/cn_proc.h>
+#include <linux/notifier.h>
 #include <linux/audit.h>
 
 #include <asm/uaccess.h>
@@ -1253,7 +1253,8 @@ int search_binary_handler(struct linux_b
 					fput(bprm->file);
 				bprm->file = NULL;
 				current->did_exec = 1;
-				proc_exec_connector(current);
+				blocking_notifier_call_chain(&task_notifier_list,
+							     TASK_EXEC, current);
 				return retval;
 			}
 			read_lock(&binfmt_lock);
--- 2.6.24-rc5-notify-task.orig/include/linux/cn_proc.h
+++ 2.6.24-rc5-notify-task/include/linux/cn_proc.h
@@ -97,25 +97,4 @@ struct proc_event {
 	} event_data;
 };
 
-#ifdef __KERNEL__
-#ifdef CONFIG_PROC_EVENTS
-void proc_fork_connector(struct task_struct *task);
-void proc_exec_connector(struct task_struct *task);
-void proc_id_connector(struct task_struct *task, int which_id);
-void proc_exit_connector(struct task_struct *task);
-#else
-static inline void proc_fork_connector(struct task_struct *task)
-{}
-
-static inline void proc_exec_connector(struct task_struct *task)
-{}
-
-static inline void proc_id_connector(struct task_struct *task,
-				     int which_id)
-{}
-
-static inline void proc_exit_connector(struct task_struct *task)
-{}
-#endif	/* CONFIG_PROC_EVENTS */
-#endif	/* __KERNEL__ */
 #endif	/* CN_PROC_H */
--- 2.6.24-rc5-notify-task.orig/include/linux/sched.h
+++ 2.6.24-rc5-notify-task/include/linux/sched.h
@@ -1702,6 +1702,10 @@ struct task_struct *fork_idle(int);
 
 #define TASK_NEW 1
 #define TASK_DELETE 2
+#define TASK_EXEC 3
+#define TASK_EXIT 4
+#define TASK_UID_CHANGE 5
+#define TASK_GID_CHANGE 6
 
 extern struct blocking_notifier_head task_notifier_list;
 extern struct atomic_notifier_head atomic_task_notifier_list;
--- 2.6.24-rc5-notify-task.orig/kernel/exit.c
+++ 2.6.24-rc5-notify-task/kernel/exit.c
@@ -35,7 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/signal.h>
 #include <linux/posix-timers.h>
-#include <linux/cn_proc.h>
+#include <linux/notifier.h>
 #include <linux/mutex.h>
 #include <linux/futex.h>
 #include <linux/compat.h>
@@ -747,6 +747,8 @@ static void exit_notify(struct task_stru
 	struct task_struct *t;
 	struct pid *pgrp;
 
+	blocking_notifier_call_chain(&task_notifier_list, TASK_EXIT, tsk);
+
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
 	    && !thread_group_empty(tsk)) {
 		/*
@@ -1009,7 +1011,6 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->binfmt)
 		module_put(tsk->binfmt->module);
 
-	proc_exit_connector(tsk);
 	exit_notify(tsk);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
--- 2.6.24-rc5-notify-task.orig/kernel/fork.c
+++ 2.6.24-rc5-notify-task/kernel/fork.c
@@ -44,7 +44,6 @@
 #include <linux/rmap.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
-#include <linux/cn_proc.h>
 #include <linux/freezer.h>
 #include <linux/notifier.h>
 #include <linux/taskstats_kern.h>
@@ -1316,7 +1315,6 @@ static struct task_struct *copy_process(
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
-	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	return p;
 
--- 2.6.24-rc5-notify-task.orig/kernel/sys.c
+++ 2.6.24-rc5-notify-task/kernel/sys.c
@@ -28,7 +28,6 @@
 #include <linux/suspend.h>
 #include <linux/tty.h>
 #include <linux/signal.h>
-#include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
@@ -519,7 +518,9 @@ asmlinkage long sys_setregid(gid_t rgid,
 	current->egid = new_egid;
 	current->gid = new_rgid;
 	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_GID_CHANGE, current);
+
 	return 0;
 }
 
@@ -554,7 +555,9 @@ asmlinkage long sys_setgid(gid_t gid)
 		return -EPERM;
 
 	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_GID_CHANGE, current);
+
 	return 0;
 }
   
@@ -642,7 +645,8 @@ asmlinkage long sys_setreuid(uid_t ruid,
 	current->fsuid = current->euid;
 
 	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_UID_CHANGE, current);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RE);
 }
@@ -689,7 +693,8 @@ asmlinkage long sys_setuid(uid_t uid)
 	current->suid = new_suid;
 
 	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_UID_CHANGE, current);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_ID);
 }
@@ -737,7 +742,8 @@ asmlinkage long sys_setresuid(uid_t ruid
 		current->suid = suid;
 
 	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_UID_CHANGE, current);
 
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RES);
 }
@@ -789,7 +795,8 @@ asmlinkage long sys_setresgid(gid_t rgid
 		current->sgid = sgid;
 
 	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_GID_CHANGE, current);
 	return 0;
 }
 
@@ -830,7 +837,8 @@ asmlinkage long sys_setfsuid(uid_t uid)
 	}
 
 	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_UID_CHANGE, current);
 
 	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
 
@@ -857,7 +865,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
 		}
 		current->fsgid = gid;
 		key_fsgid_changed(current);
-		proc_id_connector(current, PROC_EVENT_GID);
+		blocking_notifier_call_chain(&task_notifier_list,
+					     TASK_GID_CHANGE, current);
 	}
 	return old_fsgid;
 }


