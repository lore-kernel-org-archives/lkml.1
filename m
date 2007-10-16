Return-Path: <linux-kernel-owner+w=401wt.eu-S935433AbXJPTq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935433AbXJPTq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXJPTqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:46:15 -0400
Received: from duempel.org ([81.209.165.42]:44413 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933419AbXJPTqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:46:14 -0400
Date: Tue, 16 Oct 2007 21:38:50 +0200
From: Max Kellermann <mk@cm4all.com>
To: chrisw@sous-sol.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] /proc Security Hooks
Message-ID: <20071016193850.GA5418@roonstrasse.net>
Mail-Followup-To: chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add two LSM hooks for limiting access to the proc file system.

security_proc_task() defines the visibility of tasks in /proc.

security_proc_generic() lets the LSM define who will see "generic"
proc entries (see fs/proc/generic.c).

This patch attempts to unify duplicated code found in modules like
Linux VServer.

Signed-off-by: Max Kellermann <mk@cm4all.com>

---
 fs/proc/base.c           |    9 +++++++++
 fs/proc/generic.c        |   15 +++++++++++++++
 include/linux/security.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 security/Kconfig         |    8 ++++++++
 security/dummy.c         |   16 ++++++++++++++++
 5 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 19489b0..a6ebe2d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2317,6 +2317,10 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	     put_task_struct(task), task = next_tgid(tgid + 1)) {
 		tgid = task->pid;
 		filp->f_pos = tgid + TGID_OFFSET;
+#ifdef CONFIG_SECURITY_PROC
+		if (security_proc_task(task) != 0)
+			continue;
+#endif
 		if (proc_pid_fill_cache(filp, dirent, filldir, task, tgid) < 0) {
 			put_task_struct(task);
 			goto out;
@@ -2453,6 +2457,11 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 		goto out;
 	if (leader->tgid != task->tgid)
 		goto out_drop_task;
+#ifdef CONFIG_SECURITY_PROC
+	result = ERR_PTR(security_proc_task(task));
+	if (IS_ERR(result))
+		goto out_drop_task;
+#endif
 
 	result = proc_task_instantiate(dir, dentry, task, NULL);
 out_drop_task:
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b5e7155..7b17ec3 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -21,6 +21,9 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#ifdef CONFIG_SECURITY_PROC
+#include <linux/security.h>
+#endif
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -400,6 +403,11 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 				unsigned int ino = de->low_ino;
 
 				de_get(de);
+#ifdef CONFIG_SECURITY_PROC
+				error = security_proc_generic(de);
+				if (error != 0)
+					break;
+#endif
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
 				inode = proc_get_inode(dir->i_sb, ino, de);
@@ -483,6 +491,10 @@ int proc_readdir(struct file * filp,
 
 				/* filldir passes info to user space */
 				de_get(de);
+#ifdef CONFIG_SECURITY_PROC
+				if (security_proc_generic(de) != 0)
+					goto skip;
+#endif
 				spin_unlock(&proc_subdir_lock);
 				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
 					    de->low_ino, de->mode >> 12) < 0) {
@@ -490,6 +502,9 @@ int proc_readdir(struct file * filp,
 					goto out;
 				}
 				spin_lock(&proc_subdir_lock);
+#ifdef CONFIG_SECURITY_PROC
+			skip:
+#endif
 				filp->f_pos++;
 				next = de->next;
 				de_put(de);
diff --git a/include/linux/security.h b/include/linux/security.h
index 1a15526..3fbeacf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -68,6 +68,10 @@ struct xfrm_policy;
 struct xfrm_state;
 struct xfrm_user_sec_ctx;
 
+#ifdef CONFIG_SECURITY_PROC
+struct proc_dir_entry;
+#endif
+
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
@@ -915,6 +919,17 @@ struct request_sock;
  *	Return 1 if permission granted, 0 if permission denied and -ve it the
  *      normal permissions model should be effected.
  *
+ * Security hooks affecting proc visibility
+ *
+ * @proc_task:
+ *      Determines whether a task is visible.
+ *      @task the requested task
+ *	Return 0 if task is visible, -ENOENT if not, or -errno on other errors
+ * @proc_generic:
+ *      Determines whether a generic proc entry is visible
+ *      @de the requested proc_dir_entry structure
+ *	Return 0 if entry is visible, -ENOENT if not, or -errno on other errors
+ *
  * Security hooks affecting all System V IPC operations.
  *
  * @ipc_permission:
@@ -1399,6 +1414,11 @@ struct security_operations {
 
 #endif	/* CONFIG_KEYS */
 
+ #ifdef CONFIG_SECURITY_PROC
+	int (*proc_task)(struct task_struct *task);
+	int (*proc_generic)(struct proc_dir_entry *de);
+ #endif
+
 };
 
 /* global variables */
@@ -3314,5 +3334,31 @@ static inline int security_key_permission(key_ref_t key_ref,
 #endif
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_SECURITY_PROC
+#ifdef CONFIG_SECURITY
+static inline int security_proc_task(struct task_struct *task)
+{
+	return security_ops->proc_task(task);
+}
+
+static inline int security_proc_generic(struct proc_dir_entry *de)
+{
+	return security_ops->proc_generic(de);
+}
+
+#else
+
+static inline int security_proc_task(struct task_struct *task)
+{
+	return 0;
+}
+
+static inline int security_proc_generic(struct proc_dir_entry *de)
+{
+	return 0;
+}
+#endif
+#endif
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index 460e5c9..bd6ad4b 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -73,6 +73,14 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_PROC
+	bool "/proc Security Hooks"
+	depends on PROC_FS && SECURITY
+	help
+	  This enables the /proc security hooks.
+	  These allow an LSM to hide nodes in the proc filesystem.
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_CAPABILITIES
 	tristate "Default Linux Capabilities"
 	depends on SECURITY
diff --git a/security/dummy.c b/security/dummy.c
index 853ec22..3ec57be 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -949,6 +949,18 @@ static inline int dummy_key_permission(key_ref_t key_ref,
 }
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_SECURITY_PROC
+static int dummy_proc_task(struct task_struct *task)
+{
+	return 0;
+}
+
+static int dummy_proc_generic(struct proc_dir_entry *de)
+{
+	return 0;
+}
+#endif
+
 struct security_operations dummy_security_ops;
 
 #define set_to_dummy_if_null(ops, function)				\
@@ -1131,6 +1143,10 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, key_free);
 	set_to_dummy_if_null(ops, key_permission);
 #endif	/* CONFIG_KEYS */
+#ifdef CONFIG_SECURITY_PROC
+	set_to_dummy_if_null(ops, proc_task);
+	set_to_dummy_if_null(ops, proc_generic);
+#endif
 
 }
 
