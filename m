Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXFNJpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXFNJpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXFNJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:44:59 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:41638 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXFNJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:44:56 -0400
Message-ID: <4670EF9A.4080506@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:34:50 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 4/9] LSM adapter for TOMOYO.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:34:50.0634 (UTC) FILETIME=[7DEB46A0:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This file contains wrapper functions for TOMOYO's file access control functions.
The main job is to find "struct vfsmount" that corresponds to "struct dentry"
passed to LSM hooks.

Since "struct vfsmount" is not passed to LSM hooks,
TOMOYO can't determine which pathnames was requested by the process
if bind mounts are used.

If bind mounts are used, TOMOYO requires all permissions for
all possible pathnames (whereas AppArmor requires one of possible pathnames).
If "struct vfsmount" is passed to LSM hooks as AppArmor proposes,
this file will become more simpler and "namespace_sem" can remain "static".

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/tomoyo.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/tomoyo.c linux-2.6.21.5-tomoyo/security/tomoyo/tomoyo.c
--- linux-2.6.21.5/security/tomoyo/tomoyo.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/tomoyo.c	2007-06-14 15:11:57.000000000 +0900
@@ -0,0 +1,283 @@
+/*
+ * security/tomoyo/tomoyo.c
+ *
+ * LSM hooks for TOMOYO Linux.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/security.h>
+#include <linux/highmem.h>
+#include <linux/namei.h>
+#include <linux/mnt_namespace.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+
+#include "tomoyo.h"
+
+/* The initial domain. */
+struct domain_info KERNEL_DOMAIN = { NULL, NULL, NULL, 0, 0, 0 };
+extern struct rw_semaphore namespace_sem;
+
+static struct kmem_cache *tomoyo_cachep = NULL;
+
+static int tomoyo_task_alloc_security(struct task_struct *p)
+{
+	struct tomoyo_security *ptr = kmem_cache_alloc(tomoyo_cachep, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+	memcpy(ptr, current->security, sizeof(*ptr));
+	p->security = ptr;
+	return 0;
+}
+
+static void tomoyo_task_free_security(struct task_struct *p)
+{
+	kmem_cache_free(tomoyo_cachep, p->security);
+}
+
+static int tomoyo_bprm_alloc_security(struct linux_binprm *bprm)
+{
+	bprm->security = ((struct tomoyo_security *) current->security)->domain_info;
+	return 0;
+}
+
+static int tomoyo_bprm_check_security(struct linux_binprm * bprm)
+{
+	struct domain_info *next_domain = NULL;
+ 	int retval = 0;
+	extern void tomoyo_load_policy(const char *filename);
+	extern int tomoyo_find_next_domain(struct linux_binprm *, struct domain_info **);
+	tomoyo_load_policy(bprm->filename);
+	if (!(((struct tomoyo_security *) current->security)->flags
+	      & TOMOYO_CHECK_READ_FOR_OPEN_EXEC)) {
+		retval = tomoyo_find_next_domain(bprm, &next_domain);
+		if (retval == 0) {
+			((struct tomoyo_security *) current->security)->domain_info = next_domain;
+			((struct tomoyo_security *) current->security)->flags |=
+				TOMOYO_CHECK_READ_FOR_OPEN_EXEC;
+		}
+	}
+	
+	return retval;
+}
+
+static void tomoyo_bprm_post_apply_creds(struct linux_binprm * bprm)
+{
+	bprm->security = ((struct tomoyo_security *) current->security)->domain_info;
+}
+
+static void tomoyo_bprm_free_security(struct linux_binprm * bprm)
+{
+	((struct tomoyo_security *) current->security)->domain_info =
+		(struct domain_info *) bprm->security;
+	((struct tomoyo_security *) current->security)->flags &=
+		~TOMOYO_CHECK_READ_FOR_OPEN_EXEC;
+}
+
+static int tomoyo_inode_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	int flag = 0;
+	if (S_ISDIR(inode->i_mode)) /* ignore because inode is directory */
+		return 0;
+	if (!nd || !nd->dentry || !nd->mnt)
+		return 0;
+	if ((mask == MAY_EXEC) && (((struct tomoyo_security *) current->security)->flags &
+	                           TOMOYO_CHECK_READ_FOR_OPEN_EXEC))
+		mask = MAY_READ;
+	if ((mask == MAY_EXEC) || (mask == 0))
+		return 0;
+
+	if (mask == (MAY_READ | MAY_EXEC)) {
+		flag |= O_RDONLY + 1;
+	} else {
+		if (mask & MAY_READ)
+			flag |= O_RDONLY + 1;
+		if (mask & MAY_WRITE)
+			flag |= O_WRONLY + 1;
+		if ((mask & MAY_APPEND))
+			flag |= O_APPEND;
+	}
+	return tomoyo_check_open_permission(nd->dentry, nd->mnt, flag);
+}
+
+static int tomoyo_do_check_single_write_permission(int operation, struct dentry *dentry)
+{
+	struct mnt_namespace *namespace = current->nsproxy->mnt_ns;
+	struct list_head *p;
+	int ret = 0, error = 0;
+	int index = 0, index2 = 0;
+	if (!dentry || !namespace)
+		return 0;
+ start:
+	index2 = 0;
+	/* lock namespace */
+	down_read(&namespace_sem);
+	list_for_each(p, &namespace->list) {
+		struct vfsmount *mnt = list_entry(p, struct vfsmount, mnt_list);
+		if (mnt->mnt_root->d_sb != dentry->d_sb) continue;
+		if (index2++ < index) continue;
+		/* unlock namespace */
+		up_read(&namespace_sem);
+		if ((error = tomoyo_check_single_write_permission(operation, dentry, mnt)) != 0)
+			ret = error;
+		index++;
+		goto start;
+	}
+	/* unlock namespace */
+	up_read(&namespace_sem);
+	return ret;
+}
+
+static int tomoyo_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	if (iattr->ia_valid & ATTR_SIZE)
+		return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_TRUNCATE_ACL, dentry);
+	return 0;
+}
+
+static int tomoyo_inode_create(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_CREATE_ACL, dentry);
+}
+
+static int tomoyo_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_UNLINK_ACL, dentry);
+}
+
+static int tomoyo_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_MKDIR_ACL, dentry);
+}
+
+static int tomoyo_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_RMDIR_ACL, dentry);
+}
+
+static int tomoyo_inode_symlink(struct inode *dir, struct dentry *dentry, const char *old_name)
+{
+	return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_SYMLINK_ACL, dentry);
+}
+
+static int tomoyo_inode_mknod(struct inode *inode, struct dentry *dentry, int mode, dev_t dev)
+{
+	if (S_ISCHR(mode))
+		return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_MKCHAR_ACL, dentry);
+	if (S_ISBLK(mode))
+		return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_MKBLOCK_ACL, dentry);
+	if (S_ISFIFO(mode))
+		return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_MKFIFO_ACL, dentry);
+	if (S_ISSOCK(mode))
+		return tomoyo_do_check_single_write_permission(TOMOYO_TYPE_MKSOCK_ACL, dentry);
+	return 0;
+}
+
+static int tomoyo_do_check_double_write_permission(int operation,
+                                                   struct dentry *old_dentry,
+                                                   struct dentry *new_dentry)
+{
+	struct mnt_namespace *namespace = current->nsproxy->mnt_ns;
+	struct list_head *p;
+	int ret = 0, error = 0;
+	int index = 0, index2 = 0;
+	if (!old_dentry || !new_dentry)
+		return 0;
+ start:
+	index2 = 0;
+	/* lock namespace */
+	down_read(&namespace_sem);
+	list_for_each(p, &namespace->list) {
+		struct vfsmount *mnt = list_entry(p, struct vfsmount, mnt_list);
+		if (mnt->mnt_root->d_sb != old_dentry->d_sb) continue;
+		if (index2++ < index) continue;
+		/* unlock namespace */
+		up_read(&namespace_sem);
+		if ((error = tomoyo_check_double_write_permission(operation,
+		                                                  old_dentry,
+		                                                  mnt,
+		                                                  new_dentry,
+		                                                  mnt)) != 0)
+			ret = error;
+		index++;
+		goto start;
+	}
+	/* unlock namespace */
+	up_read(&namespace_sem);
+	return ret;
+}
+
+static int tomoyo_inode_link(struct dentry *old_dentry,
+                             struct inode *inode,
+                             struct dentry *new_dentry)
+{
+	return tomoyo_do_check_double_write_permission(TOMOYO_TYPE_LINK_ACL, old_dentry, new_dentry);
+}
+
+static int tomoyo_inode_rename(struct inode *old_inode,
+                               struct dentry *old_dentry,
+                               struct inode *new_inode,
+                               struct dentry *new_dentry)
+{
+	return tomoyo_do_check_double_write_permission(TOMOYO_TYPE_RENAME_ACL,
+	                                               old_dentry,
+	                                               new_dentry);
+}
+
+static int tomoyo_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	if (!(arg & O_APPEND))
+		return tomoyo_check_rewrite_permission(file);
+	return 0;
+}
+
+struct security_operations tomoyo_security_ops = {
+	.task_alloc_security   = tomoyo_task_alloc_security,
+	.task_free_security    = tomoyo_task_free_security,
+	.bprm_alloc_security   = tomoyo_bprm_alloc_security,
+	.bprm_check_security   = tomoyo_bprm_check_security,
+	.bprm_post_apply_creds = tomoyo_bprm_post_apply_creds,
+	.bprm_free_security    = tomoyo_bprm_free_security,
+	.inode_permission      = tomoyo_inode_permission,
+	.inode_setattr         = tomoyo_inode_setattr,
+	.inode_create          = tomoyo_inode_create,
+	.inode_unlink          = tomoyo_inode_unlink,
+	.inode_mkdir           = tomoyo_inode_mkdir,
+	.inode_rmdir           = tomoyo_inode_rmdir,
+	.inode_symlink         = tomoyo_inode_symlink,
+	.inode_mknod           = tomoyo_inode_mknod,
+	.inode_link            = tomoyo_inode_link,
+	.inode_rename          = tomoyo_inode_rename,
+	.file_fcntl            = tomoyo_file_fcntl,
+};
+
+static int __init tomoyo_init(void)
+{
+	/* register ourselves with the security framework */
+	if (register_security(&tomoyo_security_ops)) {
+		printk(KERN_INFO "Failure registering TOMOYO Linux with the kernel\n");
+		return -EINVAL;
+	}
+	
+	printk ("TOMOYO Linux initialized\n");
+	{
+		extern void tomoyo_proc_init(void);
+		tomoyo_proc_init();
+	}
+	tomoyo_cachep = kmem_cache_create("tomoyo_security",
+	                                  sizeof(struct tomoyo_security),
+	                                  0, SLAB_PANIC, NULL, NULL);
+	init_task.security = kmem_cache_alloc(tomoyo_cachep, GFP_KERNEL);
+	((struct tomoyo_security *) init_task.security)->domain_info = &KERNEL_DOMAIN;
+	((struct tomoyo_security *) init_task.security)->flags = 0;
+	return 0;
+}
+
+security_initcall(tomoyo_init);
---------------

