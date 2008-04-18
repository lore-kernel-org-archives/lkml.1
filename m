Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYDRSS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYDRSS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbYDRSRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538AbYDRSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:39 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] dlm: move plock code from gfs2
Date: Fri, 18 Apr 2008 13:12:47 -0500
Message-Id: <1208542368-13417-6-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that handles cluster posix locks from gfs2 into the dlm
so that it can be used by both gfs2 and ocfs2.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/Makefile                |    1 +
 fs/dlm/dlm_internal.h          |    2 +
 fs/dlm/main.c                  |    7 +
 fs/dlm/plock.c                 |  439 ++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/locking/dlm/Makefile   |    2 +-
 fs/gfs2/locking/dlm/lock_dlm.h |   11 +-
 fs/gfs2/locking/dlm/main.c     |    8 -
 fs/gfs2/locking/dlm/mount.c    |   21 ++
 fs/gfs2/locking/dlm/plock.c    |  406 -------------------------------------
 include/linux/Kbuild           |    2 +-
 include/linux/dlm_plock.h      |   50 +++++
 include/linux/lock_dlm_plock.h |   41 ----
 12 files changed, 523 insertions(+), 467 deletions(-)
 create mode 100644 fs/dlm/plock.c
 delete mode 100644 fs/gfs2/locking/dlm/plock.c
 create mode 100644 include/linux/dlm_plock.h
 delete mode 100644 include/linux/lock_dlm_plock.h

diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index d248e60..ca1c912 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -10,6 +10,7 @@ dlm-y :=			ast.o \
 				midcomms.o \
 				netlink.o \
 				lowcomms.o \
+				plock.o \
 				rcom.o \
 				recover.o \
 				recoverd.o \
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index c70c8e5..caa1581 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -582,6 +582,8 @@ static inline int dlm_no_directory(struct dlm_ls *ls)
 int dlm_netlink_init(void);
 void dlm_netlink_exit(void);
 void dlm_timeout_warn(struct dlm_lkb *lkb);
+int dlm_plock_init(void);
+void dlm_plock_exit(void);
 
 #ifdef CONFIG_DLM_DEBUG
 int dlm_register_debugfs(void);
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index 58487fb..b80e0aa 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -46,10 +46,16 @@ static int __init init_dlm(void)
 	if (error)
 		goto out_user;
 
+	error = dlm_plock_init();
+	if (error)
+		goto out_netlink;
+
 	printk("DLM (built %s %s) installed\n", __DATE__, __TIME__);
 
 	return 0;
 
+ out_netlink:
+	dlm_netlink_exit();
  out_user:
 	dlm_user_exit();
  out_debug:
@@ -66,6 +72,7 @@ static int __init init_dlm(void)
 
 static void __exit exit_dlm(void)
 {
+	dlm_plock_exit();
 	dlm_netlink_exit();
 	dlm_user_exit();
 	dlm_config_exit();
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
new file mode 100644
index 0000000..d6d6e37
--- /dev/null
+++ b/fs/dlm/plock.c
@@ -0,0 +1,439 @@
+/*
+ * Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
+#include <linux/dlm.h>
+#include <linux/dlm_plock.h>
+
+#include "dlm_internal.h"
+#include "lockspace.h"
+
+static spinlock_t ops_lock;
+static struct list_head send_list;
+static struct list_head recv_list;
+static wait_queue_head_t send_wq;
+static wait_queue_head_t recv_wq;
+
+struct plock_op {
+	struct list_head list;
+	int done;
+	struct dlm_plock_info info;
+};
+
+struct plock_xop {
+	struct plock_op xop;
+	void *callback;
+	void *fl;
+	void *file;
+	struct file_lock flc;
+};
+
+
+static inline void set_version(struct dlm_plock_info *info)
+{
+	info->version[0] = DLM_PLOCK_VERSION_MAJOR;
+	info->version[1] = DLM_PLOCK_VERSION_MINOR;
+	info->version[2] = DLM_PLOCK_VERSION_PATCH;
+}
+
+static int check_version(struct dlm_plock_info *info)
+{
+	if ((DLM_PLOCK_VERSION_MAJOR != info->version[0]) ||
+	    (DLM_PLOCK_VERSION_MINOR < info->version[1])) {
+		log_print("plock device version mismatch: "
+			  "kernel (%u.%u.%u), user (%u.%u.%u)",
+			  DLM_PLOCK_VERSION_MAJOR,
+			  DLM_PLOCK_VERSION_MINOR,
+			  DLM_PLOCK_VERSION_PATCH,
+			  info->version[0],
+			  info->version[1],
+			  info->version[2]);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void send_op(struct plock_op *op)
+{
+	set_version(&op->info);
+	INIT_LIST_HEAD(&op->list);
+	spin_lock(&ops_lock);
+	list_add_tail(&op->list, &send_list);
+	spin_unlock(&ops_lock);
+	wake_up(&send_wq);
+}
+
+int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		   int cmd, struct file_lock *fl)
+{
+	struct dlm_ls *ls;
+	struct plock_op *op;
+	struct plock_xop *xop;
+	int rv;
+
+	ls = dlm_find_lockspace_local(lockspace);
+	if (!ls)
+		return -EINVAL;
+
+	xop = kzalloc(sizeof(*xop), GFP_KERNEL);
+	if (!xop) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	op = &xop->xop;
+	op->info.optype		= DLM_PLOCK_OP_LOCK;
+	op->info.pid		= fl->fl_pid;
+	op->info.ex		= (fl->fl_type == F_WRLCK);
+	op->info.wait		= IS_SETLKW(cmd);
+	op->info.fsid		= ls->ls_global_id;
+	op->info.number		= number;
+	op->info.start		= fl->fl_start;
+	op->info.end		= fl->fl_end;
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant) {
+		/* fl_owner is lockd which doesn't distinguish
+		   processes on the nfs client */
+		op->info.owner	= (__u64) fl->fl_pid;
+		xop->callback	= fl->fl_lmops->fl_grant;
+		locks_init_lock(&xop->flc);
+		locks_copy_lock(&xop->flc, fl);
+		xop->fl		= fl;
+		xop->file	= file;
+	} else {
+		op->info.owner	= (__u64)(long) fl->fl_owner;
+		xop->callback	= NULL;
+	}
+
+	send_op(op);
+
+	if (xop->callback == NULL)
+		wait_event(recv_wq, (op->done != 0));
+	else {
+		rv = -EINPROGRESS;
+		goto out;
+	}
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&op->list)) {
+		log_error(ls, "dlm_posix_lock: op on list %llx",
+			  (unsigned long long)number);
+		list_del(&op->list);
+	}
+	spin_unlock(&ops_lock);
+
+	rv = op->info.rv;
+
+	if (!rv) {
+		if (posix_lock_file_wait(file, fl) < 0)
+			log_error(ls, "dlm_posix_lock: vfs lock error %llx",
+				  (unsigned long long)number);
+	}
+
+	kfree(xop);
+out:
+	dlm_put_lockspace(ls);
+	return rv;
+}
+EXPORT_SYMBOL_GPL(dlm_posix_lock);
+
+/* Returns failure iff a succesful lock operation should be canceled */
+static int dlm_plock_callback(struct plock_op *op)
+{
+	struct file *file;
+	struct file_lock *fl;
+	struct file_lock *flc;
+	int (*notify)(void *, void *, int) = NULL;
+	struct plock_xop *xop = (struct plock_xop *)op;
+	int rv = 0;
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&op->list)) {
+		log_print("dlm_plock_callback: op on list %llx",
+			  (unsigned long long)op->info.number);
+		list_del(&op->list);
+	}
+	spin_unlock(&ops_lock);
+
+	/* check if the following 2 are still valid or make a copy */
+	file = xop->file;
+	flc = &xop->flc;
+	fl = xop->fl;
+	notify = xop->callback;
+
+	if (op->info.rv) {
+		notify(flc, NULL, op->info.rv);
+		goto out;
+	}
+
+	/* got fs lock; bookkeep locally as well: */
+	flc->fl_flags &= ~FL_SLEEP;
+	if (posix_lock_file(file, flc, NULL)) {
+		/*
+		 * This can only happen in the case of kmalloc() failure.
+		 * The filesystem's own lock is the authoritative lock,
+		 * so a failure to get the lock locally is not a disaster.
+		 * As long as the fs cannot reliably cancel locks (especially
+		 * in a low-memory situation), we're better off ignoring
+		 * this failure than trying to recover.
+		 */
+		log_print("dlm_plock_callback: vfs lock error %llx file %p fl %p",
+			  (unsigned long long)op->info.number, file, fl);
+	}
+
+	rv = notify(flc, NULL, 0);
+	if (rv) {
+		/* XXX: We need to cancel the fs lock here: */
+		log_print("dlm_plock_callback: lock granted after lock request "
+			  "failed; dangling lock!\n");
+		goto out;
+	}
+
+out:
+	kfree(xop);
+	return rv;
+}
+
+int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		     struct file_lock *fl)
+{
+	struct dlm_ls *ls;
+	struct plock_op *op;
+	int rv;
+
+	ls = dlm_find_lockspace_local(lockspace);
+	if (!ls)
+		return -EINVAL;
+
+	op = kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	if (posix_lock_file_wait(file, fl) < 0)
+		log_error(ls, "dlm_posix_unlock: vfs unlock error %llx",
+			  (unsigned long long)number);
+
+	op->info.optype		= DLM_PLOCK_OP_UNLOCK;
+	op->info.pid		= fl->fl_pid;
+	op->info.fsid		= ls->ls_global_id;
+	op->info.number		= number;
+	op->info.start		= fl->fl_start;
+	op->info.end		= fl->fl_end;
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
+		op->info.owner	= (__u64) fl->fl_pid;
+	else
+		op->info.owner	= (__u64)(long) fl->fl_owner;
+
+	send_op(op);
+	wait_event(recv_wq, (op->done != 0));
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&op->list)) {
+		log_error(ls, "dlm_posix_unlock: op on list %llx",
+			  (unsigned long long)number);
+		list_del(&op->list);
+	}
+	spin_unlock(&ops_lock);
+
+	rv = op->info.rv;
+
+	if (rv == -ENOENT)
+		rv = 0;
+
+	kfree(op);
+out:
+	dlm_put_lockspace(ls);
+	return rv;
+}
+EXPORT_SYMBOL_GPL(dlm_posix_unlock);
+
+int dlm_posix_get(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		  struct file_lock *fl)
+{
+	struct dlm_ls *ls;
+	struct plock_op *op;
+	int rv;
+
+	ls = dlm_find_lockspace_local(lockspace);
+	if (!ls)
+		return -EINVAL;
+
+	op = kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	op->info.optype		= DLM_PLOCK_OP_GET;
+	op->info.pid		= fl->fl_pid;
+	op->info.ex		= (fl->fl_type == F_WRLCK);
+	op->info.fsid		= ls->ls_global_id;
+	op->info.number		= number;
+	op->info.start		= fl->fl_start;
+	op->info.end		= fl->fl_end;
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
+		op->info.owner	= (__u64) fl->fl_pid;
+	else
+		op->info.owner	= (__u64)(long) fl->fl_owner;
+
+	send_op(op);
+	wait_event(recv_wq, (op->done != 0));
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&op->list)) {
+		log_error(ls, "dlm_posix_get: op on list %llx",
+			  (unsigned long long)number);
+		list_del(&op->list);
+	}
+	spin_unlock(&ops_lock);
+
+	/* info.rv from userspace is 1 for conflict, 0 for no-conflict,
+	   -ENOENT if there are no locks on the file */
+
+	rv = op->info.rv;
+
+	fl->fl_type = F_UNLCK;
+	if (rv == -ENOENT)
+		rv = 0;
+	else if (rv > 0) {
+		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
+		fl->fl_pid = op->info.pid;
+		fl->fl_start = op->info.start;
+		fl->fl_end = op->info.end;
+		rv = 0;
+	}
+
+	kfree(op);
+out:
+	dlm_put_lockspace(ls);
+	return rv;
+}
+EXPORT_SYMBOL_GPL(dlm_posix_get);
+
+/* a read copies out one plock request from the send list */
+static ssize_t dev_read(struct file *file, char __user *u, size_t count,
+			loff_t *ppos)
+{
+	struct dlm_plock_info info;
+	struct plock_op *op = NULL;
+
+	if (count < sizeof(info))
+		return -EINVAL;
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&send_list)) {
+		op = list_entry(send_list.next, struct plock_op, list);
+		list_move(&op->list, &recv_list);
+		memcpy(&info, &op->info, sizeof(info));
+	}
+	spin_unlock(&ops_lock);
+
+	if (!op)
+		return -EAGAIN;
+
+	if (copy_to_user(u, &info, sizeof(info)))
+		return -EFAULT;
+	return sizeof(info);
+}
+
+/* a write copies in one plock result that should match a plock_op
+   on the recv list */
+static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
+			 loff_t *ppos)
+{
+	struct dlm_plock_info info;
+	struct plock_op *op;
+	int found = 0;
+
+	if (count != sizeof(info))
+		return -EINVAL;
+
+	if (copy_from_user(&info, u, sizeof(info)))
+		return -EFAULT;
+
+	if (check_version(&info))
+		return -EINVAL;
+
+	spin_lock(&ops_lock);
+	list_for_each_entry(op, &recv_list, list) {
+		if (op->info.fsid == info.fsid && op->info.number == info.number &&
+		    op->info.owner == info.owner) {
+			list_del_init(&op->list);
+			found = 1;
+			op->done = 1;
+			memcpy(&op->info, &info, sizeof(info));
+			break;
+		}
+	}
+	spin_unlock(&ops_lock);
+
+	if (found) {
+		struct plock_xop *xop;
+		xop = (struct plock_xop *)op;
+		if (xop->callback)
+			count = dlm_plock_callback(op);
+		else
+			wake_up(&recv_wq);
+	} else
+		log_print("dev_write no op %x %llx", info.fsid,
+			  (unsigned long long)info.number);
+	return count;
+}
+
+static unsigned int dev_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask = 0;
+
+	poll_wait(file, &send_wq, wait);
+
+	spin_lock(&ops_lock);
+	if (!list_empty(&send_list))
+		mask = POLLIN | POLLRDNORM;
+	spin_unlock(&ops_lock);
+
+	return mask;
+}
+
+static const struct file_operations dev_fops = {
+	.read    = dev_read,
+	.write   = dev_write,
+	.poll    = dev_poll,
+	.owner   = THIS_MODULE
+};
+
+static struct miscdevice plock_dev_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = DLM_PLOCK_MISC_NAME,
+	.fops = &dev_fops
+};
+
+int dlm_plock_init(void)
+{
+	int rv;
+
+	spin_lock_init(&ops_lock);
+	INIT_LIST_HEAD(&send_list);
+	INIT_LIST_HEAD(&recv_list);
+	init_waitqueue_head(&send_wq);
+	init_waitqueue_head(&recv_wq);
+
+	rv = misc_register(&plock_dev_misc);
+	if (rv)
+		log_print("dlm_plock_init: misc_register failed %d", rv);
+	return rv;
+}
+
+void dlm_plock_exit(void)
+{
+	if (misc_deregister(&plock_dev_misc) < 0)
+		log_print("dlm_plock_exit: misc_deregister failed");
+}
+
diff --git a/fs/gfs2/locking/dlm/Makefile b/fs/gfs2/locking/dlm/Makefile
index 89b93b6..2609bb6 100644
--- a/fs/gfs2/locking/dlm/Makefile
+++ b/fs/gfs2/locking/dlm/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
-lock_dlm-y := lock.o main.o mount.o sysfs.o thread.o plock.o
+lock_dlm-y := lock.o main.o mount.o sysfs.o thread.o
 
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 9e8265d..55e92af 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -25,6 +25,7 @@
 #include <net/sock.h>
 
 #include <linux/dlm.h>
+#include <linux/dlm_plock.h>
 #include <linux/lm_interface.h>
 
 /*
@@ -173,15 +174,5 @@ void gdlm_cancel(void *);
 int gdlm_hold_lvb(void *, char **);
 void gdlm_unhold_lvb(void *, char *);
 
-/* plock.c */
-
-int gdlm_plock_init(void);
-void gdlm_plock_exit(void);
-int gdlm_plock(void *, struct lm_lockname *, struct file *, int,
-		struct file_lock *);
-int gdlm_plock_get(void *, struct lm_lockname *, struct file *,
-		struct file_lock *);
-int gdlm_punlock(void *, struct lm_lockname *, struct file *,
-		struct file_lock *);
 #endif
 
diff --git a/fs/gfs2/locking/dlm/main.c b/fs/gfs2/locking/dlm/main.c
index a0e7eda..867763c 100644
--- a/fs/gfs2/locking/dlm/main.c
+++ b/fs/gfs2/locking/dlm/main.c
@@ -30,13 +30,6 @@ static int __init init_lock_dlm(void)
 		return error;
 	}
 
-	error = gdlm_plock_init();
-	if (error) {
-		gdlm_sysfs_exit();
-		gfs2_unregister_lockproto(&gdlm_ops);
-		return error;
-	}
-
 	printk(KERN_INFO
 	       "Lock_DLM (built %s %s) installed\n", __DATE__, __TIME__);
 	return 0;
@@ -44,7 +37,6 @@ static int __init init_lock_dlm(void)
 
 static void __exit exit_lock_dlm(void)
 {
-	gdlm_plock_exit();
 	gdlm_sysfs_exit();
 	gfs2_unregister_lockproto(&gdlm_ops);
 }
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index f2efff4..470bdf6 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -236,6 +236,27 @@ static void gdlm_withdraw(void *lockspace)
 	gdlm_kobject_release(ls);
 }
 
+static int gdlm_plock(void *lockspace, struct lm_lockname *name,
+	       struct file *file, int cmd, struct file_lock *fl)
+{
+	struct gdlm_ls *ls = lockspace;
+	return dlm_posix_lock(ls->dlm_lockspace, name->ln_number, file, cmd, fl);
+}
+
+static int gdlm_punlock(void *lockspace, struct lm_lockname *name,
+		 struct file *file, struct file_lock *fl)
+{
+	struct gdlm_ls *ls = lockspace;
+	return dlm_posix_unlock(ls->dlm_lockspace, name->ln_number, file, fl);
+}
+
+static int gdlm_plock_get(void *lockspace, struct lm_lockname *name,
+		   struct file *file, struct file_lock *fl)
+{
+	struct gdlm_ls *ls = lockspace;
+	return dlm_posix_get(ls->dlm_lockspace, name->ln_number, file, fl);
+}
+
 const struct lm_lockops gdlm_ops = {
 	.lm_proto_name = "lock_dlm",
 	.lm_mount = gdlm_mount,
diff --git a/fs/gfs2/locking/dlm/plock.c b/fs/gfs2/locking/dlm/plock.c
deleted file mode 100644
index 2ebd374..0000000
--- a/fs/gfs2/locking/dlm/plock.c
+++ /dev/null
@@ -1,406 +0,0 @@
-/*
- * Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/miscdevice.h>
-#include <linux/lock_dlm_plock.h>
-#include <linux/poll.h>
-
-#include "lock_dlm.h"
-
-
-static spinlock_t ops_lock;
-static struct list_head send_list;
-static struct list_head recv_list;
-static wait_queue_head_t send_wq;
-static wait_queue_head_t recv_wq;
-
-struct plock_op {
-	struct list_head list;
-	int done;
-	struct gdlm_plock_info info;
-};
-
-struct plock_xop {
-	struct plock_op xop;
-	void *callback;
-	void *fl;
-	void *file;
-	struct file_lock flc;
-};
-
-
-static inline void set_version(struct gdlm_plock_info *info)
-{
-	info->version[0] = GDLM_PLOCK_VERSION_MAJOR;
-	info->version[1] = GDLM_PLOCK_VERSION_MINOR;
-	info->version[2] = GDLM_PLOCK_VERSION_PATCH;
-}
-
-static int check_version(struct gdlm_plock_info *info)
-{
-	if ((GDLM_PLOCK_VERSION_MAJOR != info->version[0]) ||
-	    (GDLM_PLOCK_VERSION_MINOR < info->version[1])) {
-		log_error("plock device version mismatch: "
-			  "kernel (%u.%u.%u), user (%u.%u.%u)",
-			  GDLM_PLOCK_VERSION_MAJOR,
-			  GDLM_PLOCK_VERSION_MINOR,
-			  GDLM_PLOCK_VERSION_PATCH,
-			  info->version[0],
-			  info->version[1],
-			  info->version[2]);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void send_op(struct plock_op *op)
-{
-	set_version(&op->info);
-	INIT_LIST_HEAD(&op->list);
-	spin_lock(&ops_lock);
-	list_add_tail(&op->list, &send_list);
-	spin_unlock(&ops_lock);
-	wake_up(&send_wq);
-}
-
-int gdlm_plock(void *lockspace, struct lm_lockname *name,
-	       struct file *file, int cmd, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	struct plock_op *op;
-	struct plock_xop *xop;
-	int rv;
-
-	xop = kzalloc(sizeof(*xop), GFP_KERNEL);
-	if (!xop)
-		return -ENOMEM;
-
-	op = &xop->xop;
-	op->info.optype		= GDLM_PLOCK_OP_LOCK;
-	op->info.pid		= fl->fl_pid;
-	op->info.ex		= (fl->fl_type == F_WRLCK);
-	op->info.wait		= IS_SETLKW(cmd);
-	op->info.fsid		= ls->id;
-	op->info.number		= name->ln_number;
-	op->info.start		= fl->fl_start;
-	op->info.end		= fl->fl_end;
-	if (fl->fl_lmops && fl->fl_lmops->fl_grant) {
-		/* fl_owner is lockd which doesn't distinguish
-		   processes on the nfs client */
-		op->info.owner	= (__u64) fl->fl_pid;
-		xop->callback	= fl->fl_lmops->fl_grant;
-		locks_init_lock(&xop->flc);
-		locks_copy_lock(&xop->flc, fl);
-		xop->fl		= fl;
-		xop->file	= file;
-	} else {
-		op->info.owner	= (__u64)(long) fl->fl_owner;
-		xop->callback	= NULL;
-	}
-
-	send_op(op);
-
-	if (xop->callback == NULL)
-		wait_event(recv_wq, (op->done != 0));
-	else
-		return -EINPROGRESS;
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&op->list)) {
-		printk(KERN_INFO "plock op on list\n");
-		list_del(&op->list);
-	}
-	spin_unlock(&ops_lock);
-
-	rv = op->info.rv;
-
-	if (!rv) {
-		if (posix_lock_file_wait(file, fl) < 0)
-			log_error("gdlm_plock: vfs lock error %x,%llx",
-				  name->ln_type,
-				  (unsigned long long)name->ln_number);
-	}
-
-	kfree(xop);
-	return rv;
-}
-
-/* Returns failure iff a succesful lock operation should be canceled */
-static int gdlm_plock_callback(struct plock_op *op)
-{
-	struct file *file;
-	struct file_lock *fl;
-	struct file_lock *flc;
-	int (*notify)(void *, void *, int) = NULL;
-	struct plock_xop *xop = (struct plock_xop *)op;
-	int rv = 0;
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&op->list)) {
-		printk(KERN_INFO "plock op on list\n");
-		list_del(&op->list);
-	}
-	spin_unlock(&ops_lock);
-
-	/* check if the following 2 are still valid or make a copy */
-	file = xop->file;
-	flc = &xop->flc;
-	fl = xop->fl;
-	notify = xop->callback;
-
-	if (op->info.rv) {
-		notify(flc, NULL, op->info.rv);
-		goto out;
-	}
-
-	/* got fs lock; bookkeep locally as well: */
-	flc->fl_flags &= ~FL_SLEEP;
-	if (posix_lock_file(file, flc, NULL)) {
-		/*
-		 * This can only happen in the case of kmalloc() failure.
-		 * The filesystem's own lock is the authoritative lock,
-		 * so a failure to get the lock locally is not a disaster.
-		 * As long as GFS cannot reliably cancel locks (especially
-		 * in a low-memory situation), we're better off ignoring
-		 * this failure than trying to recover.
-		 */
-		log_error("gdlm_plock: vfs lock error file %p fl %p",
-				file, fl);
-	}
-
-	rv = notify(flc, NULL, 0);
-	if (rv) {
-		/* XXX: We need to cancel the fs lock here: */
-		printk("gfs2 lock granted after lock request failed;"
-						" dangling lock!\n");
-		goto out;
-	}
-
-out:
-	kfree(xop);
-	return rv;
-}
-
-int gdlm_punlock(void *lockspace, struct lm_lockname *name,
-		 struct file *file, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	struct plock_op *op;
-	int rv;
-
-	op = kzalloc(sizeof(*op), GFP_KERNEL);
-	if (!op)
-		return -ENOMEM;
-
-	if (posix_lock_file_wait(file, fl) < 0)
-		log_error("gdlm_punlock: vfs unlock error %x,%llx",
-			  name->ln_type, (unsigned long long)name->ln_number);
-
-	op->info.optype		= GDLM_PLOCK_OP_UNLOCK;
-	op->info.pid		= fl->fl_pid;
-	op->info.fsid		= ls->id;
-	op->info.number		= name->ln_number;
-	op->info.start		= fl->fl_start;
-	op->info.end		= fl->fl_end;
-	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
-		op->info.owner	= (__u64) fl->fl_pid;
-	else
-		op->info.owner	= (__u64)(long) fl->fl_owner;
-
-	send_op(op);
-	wait_event(recv_wq, (op->done != 0));
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&op->list)) {
-		printk(KERN_INFO "punlock op on list\n");
-		list_del(&op->list);
-	}
-	spin_unlock(&ops_lock);
-
-	rv = op->info.rv;
-
-	if (rv == -ENOENT)
-		rv = 0;
-
-	kfree(op);
-	return rv;
-}
-
-int gdlm_plock_get(void *lockspace, struct lm_lockname *name,
-		   struct file *file, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	struct plock_op *op;
-	int rv;
-
-	op = kzalloc(sizeof(*op), GFP_KERNEL);
-	if (!op)
-		return -ENOMEM;
-
-	op->info.optype		= GDLM_PLOCK_OP_GET;
-	op->info.pid		= fl->fl_pid;
-	op->info.ex		= (fl->fl_type == F_WRLCK);
-	op->info.fsid		= ls->id;
-	op->info.number		= name->ln_number;
-	op->info.start		= fl->fl_start;
-	op->info.end		= fl->fl_end;
-	if (fl->fl_lmops && fl->fl_lmops->fl_grant)
-		op->info.owner	= (__u64) fl->fl_pid;
-	else
-		op->info.owner	= (__u64)(long) fl->fl_owner;
-
-	send_op(op);
-	wait_event(recv_wq, (op->done != 0));
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&op->list)) {
-		printk(KERN_INFO "plock_get op on list\n");
-		list_del(&op->list);
-	}
-	spin_unlock(&ops_lock);
-
-	/* info.rv from userspace is 1 for conflict, 0 for no-conflict,
-	   -ENOENT if there are no locks on the file */
-
-	rv = op->info.rv;
-
-	fl->fl_type = F_UNLCK;
-	if (rv == -ENOENT)
-		rv = 0;
-	else if (rv > 0) {
-		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
-		fl->fl_pid = op->info.pid;
-		fl->fl_start = op->info.start;
-		fl->fl_end = op->info.end;
-		rv = 0;
-	}
-
-	kfree(op);
-	return rv;
-}
-
-/* a read copies out one plock request from the send list */
-static ssize_t dev_read(struct file *file, char __user *u, size_t count,
-			loff_t *ppos)
-{
-	struct gdlm_plock_info info;
-	struct plock_op *op = NULL;
-
-	if (count < sizeof(info))
-		return -EINVAL;
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&send_list)) {
-		op = list_entry(send_list.next, struct plock_op, list);
-		list_move(&op->list, &recv_list);
-		memcpy(&info, &op->info, sizeof(info));
-	}
-	spin_unlock(&ops_lock);
-
-	if (!op)
-		return -EAGAIN;
-
-	if (copy_to_user(u, &info, sizeof(info)))
-		return -EFAULT;
-	return sizeof(info);
-}
-
-/* a write copies in one plock result that should match a plock_op
-   on the recv list */
-static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
-			 loff_t *ppos)
-{
-	struct gdlm_plock_info info;
-	struct plock_op *op;
-	int found = 0;
-
-	if (count != sizeof(info))
-		return -EINVAL;
-
-	if (copy_from_user(&info, u, sizeof(info)))
-		return -EFAULT;
-
-	if (check_version(&info))
-		return -EINVAL;
-
-	spin_lock(&ops_lock);
-	list_for_each_entry(op, &recv_list, list) {
-		if (op->info.fsid == info.fsid && op->info.number == info.number &&
-		    op->info.owner == info.owner) {
-			list_del_init(&op->list);
-			found = 1;
-			op->done = 1;
-			memcpy(&op->info, &info, sizeof(info));
-			break;
-		}
-	}
-	spin_unlock(&ops_lock);
-
-	if (found) {
-		struct plock_xop *xop;
-		xop = (struct plock_xop *)op;
-		if (xop->callback)
-			count = gdlm_plock_callback(op);
-		else
-			wake_up(&recv_wq);
-	} else
-		printk(KERN_INFO "gdlm dev_write no op %x %llx\n", info.fsid,
-			(unsigned long long)info.number);
-	return count;
-}
-
-static unsigned int dev_poll(struct file *file, poll_table *wait)
-{
-	unsigned int mask = 0;
-
-	poll_wait(file, &send_wq, wait);
-
-	spin_lock(&ops_lock);
-	if (!list_empty(&send_list))
-		mask = POLLIN | POLLRDNORM;
-	spin_unlock(&ops_lock);
-
-	return mask;
-}
-
-static const struct file_operations dev_fops = {
-	.read    = dev_read,
-	.write   = dev_write,
-	.poll    = dev_poll,
-	.owner   = THIS_MODULE
-};
-
-static struct miscdevice plock_dev_misc = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = GDLM_PLOCK_MISC_NAME,
-	.fops = &dev_fops
-};
-
-int gdlm_plock_init(void)
-{
-	int rv;
-
-	spin_lock_init(&ops_lock);
-	INIT_LIST_HEAD(&send_list);
-	INIT_LIST_HEAD(&recv_list);
-	init_waitqueue_head(&send_wq);
-	init_waitqueue_head(&recv_wq);
-
-	rv = misc_register(&plock_dev_misc);
-	if (rv)
-		printk(KERN_INFO "gdlm_plock_init: misc_register failed %d",
-		       rv);
-	return rv;
-}
-
-void gdlm_plock_exit(void)
-{
-	if (misc_deregister(&plock_dev_misc) < 0)
-		printk(KERN_INFO "gdlm_plock_exit: misc_deregister failed");
-}
-
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 9cdd12a..7fd04ba 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -99,7 +99,7 @@ header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
 header-y += limits.h
-header-y += lock_dlm_plock.h
+header-y += dlm_plock.h
 header-y += magic.h
 header-y += major.h
 header-y += matroxfb.h
diff --git a/include/linux/dlm_plock.h b/include/linux/dlm_plock.h
new file mode 100644
index 0000000..18d5fdb
--- /dev/null
+++ b/include/linux/dlm_plock.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ */
+
+#ifndef __DLM_PLOCK_DOT_H__
+#define __DLM_PLOCK_DOT_H__
+
+#define DLM_PLOCK_MISC_NAME		"dlm_plock"
+
+#define DLM_PLOCK_VERSION_MAJOR	1
+#define DLM_PLOCK_VERSION_MINOR	1
+#define DLM_PLOCK_VERSION_PATCH	0
+
+enum {
+	DLM_PLOCK_OP_LOCK = 1,
+	DLM_PLOCK_OP_UNLOCK,
+	DLM_PLOCK_OP_GET,
+};
+
+struct dlm_plock_info {
+	__u32 version[3];
+	__u8 optype;
+	__u8 ex;
+	__u8 wait;
+	__u8 pad;
+	__u32 pid;
+	__s32 nodeid;
+	__s32 rv;
+	__u32 fsid;
+	__u64 number;
+	__u64 start;
+	__u64 end;
+	__u64 owner;
+};
+
+#ifdef __KERNEL__
+int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		int cmd, struct file_lock *fl);
+int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		struct file_lock *fl);
+int dlm_posix_get(dlm_lockspace_t *lockspace, u64 number, struct file *file,
+		struct file_lock *fl);
+#endif /* __KERNEL__ */
+
+#endif
+
diff --git a/include/linux/lock_dlm_plock.h b/include/linux/lock_dlm_plock.h
deleted file mode 100644
index fc34151..0000000
--- a/include/linux/lock_dlm_plock.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Copyright (C) 2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
- */
-
-#ifndef __LOCK_DLM_PLOCK_DOT_H__
-#define __LOCK_DLM_PLOCK_DOT_H__
-
-#define GDLM_PLOCK_MISC_NAME		"lock_dlm_plock"
-
-#define GDLM_PLOCK_VERSION_MAJOR	1
-#define GDLM_PLOCK_VERSION_MINOR	1
-#define GDLM_PLOCK_VERSION_PATCH	0
-
-enum {
-	GDLM_PLOCK_OP_LOCK = 1,
-	GDLM_PLOCK_OP_UNLOCK,
-	GDLM_PLOCK_OP_GET,
-};
-
-struct gdlm_plock_info {
-	__u32 version[3];
-	__u8 optype;
-	__u8 ex;
-	__u8 wait;
-	__u8 pad;
-	__u32 pid;
-	__s32 nodeid;
-	__s32 rv;
-	__u32 fsid;
-	__u64 number;
-	__u64 start;
-	__u64 end;
-	__u64 owner;
-};
-
-#endif
-
-- 
1.5.3.3

