Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZA2W0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZA2W0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZA2WZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:25:16 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39890 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZA2WZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:25:10 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 1/6] integrity: IMA hooks
Date: Thu, 29 Jan 2009 17:23:22 -0500
Message-Id: <0f42289551bc0b5db9bce04e44bcd357ce127c6a.1233262163.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the generic integrity hooks, for which IMA registered
itself, with IMA integrity hooks in the appropriate places directly
in the fs directory.

- renamed integrity hooks to ima
- additional ima_path_check() in open_exec() and __link_path_walk()
  required for maintaining readcount
- removed Kconfig additions/changes

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d8362cf..40c51e9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	IMA     Integrity measurement architecture is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
 	ISAPNP	ISA PnP code is enabled.
diff --git a/fs/exec.c b/fs/exec.c
index 0dd60a0..febfd8e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/mount.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/syscalls.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
@@ -127,6 +128,9 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 				 MAY_READ | MAY_EXEC | MAY_OPEN);
 	if (error)
 		goto exit;
+	error = ima_path_check(&nd.path, MAY_READ | MAY_EXEC | MAY_OPEN);
+	if (error)
+		goto exit;
 
 	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	error = PTR_ERR(file);
@@ -674,6 +678,9 @@ struct file *open_exec(const char *name)
 	err = inode_permission(nd.path.dentry->d_inode, MAY_EXEC | MAY_OPEN);
 	if (err)
 		goto out_path_put;
+	err = ima_path_check(&nd.path, MAY_EXEC | MAY_OPEN);
+	if (err)
+		goto out_path_put;
 
 	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	if (IS_ERR(file))
@@ -1168,6 +1175,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
+	retval = ima_bprm_check(bprm);
+	if (retval)
+		return retval;
 
 	/* kernel module loader fixup */
 	/* so we don't try to load run modprobe in kernel space. */
diff --git a/fs/file_table.c b/fs/file_table.c
index bbeeac6..da806ac 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/eventpoll.h>
 #include <linux/rcupdate.h>
 #include <linux/mount.h>
@@ -279,6 +280,7 @@ void __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	ima_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..40e37c0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -147,13 +148,13 @@ struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_cdev = NULL;
 	inode->i_rdev = 0;
 	inode->dirtied_when = 0;
-	if (security_inode_alloc(inode)) {
-		if (inode->i_sb->s_op->destroy_inode)
-			inode->i_sb->s_op->destroy_inode(inode);
-		else
-			kmem_cache_free(inode_cachep, (inode));
-		return NULL;
-	}
+
+	if (security_inode_alloc(inode))
+		goto out_free_inode;
+
+	/* allocate and initialize an i_integrity */
+	if (ima_inode_alloc(inode))
+		goto out_free_security;
 
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
@@ -189,6 +190,15 @@ struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_mapping = mapping;
 
 	return inode;
+
+out_free_security:
+	security_inode_free(inode);
+out_free_inode:
+	if (inode->i_sb->s_op->destroy_inode)
+		inode->i_sb->s_op->destroy_inode(inode);
+	else
+		kmem_cache_free(inode_cachep, (inode));
+	return NULL;
 }
 EXPORT_SYMBOL(inode_init_always);
 
diff --git a/fs/namei.c b/fs/namei.c
index bbc15c2..f9bfc8d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -24,6 +24,7 @@
 #include <linux/fsnotify.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
 #include <linux/audit.h>
@@ -850,6 +851,8 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 		if (err == -EAGAIN)
 			err = inode_permission(nd->path.dentry->d_inode,
 					       MAY_EXEC);
+ 		if (!err)
+			err = ima_path_check(&nd->path, MAY_EXEC);
  		if (err)
 			break;
 
@@ -1509,6 +1512,11 @@ int may_open(struct path *path, int acc_mode, int flag)
 	error = inode_permission(inode, acc_mode);
 	if (error)
 		return error;
+
+	error = ima_path_check(path,
+			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC));
+	if (error)
+		return error;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
diff --git a/include/linux/ima.h b/include/linux/ima.h
new file mode 100644
index 0000000..4ed1e4d
--- /dev/null
+++ b/include/linux/ima.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/fs.h>
+
+#ifndef _LINUX_IMA_H
+#define _LINUX_IMA_H
+
+static inline int ima_bprm_check(struct linux_binprm *bprm)
+{
+	return 0;
+}
+
+static inline int ima_inode_alloc(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void ima_inode_free(struct inode *inode)
+{
+	return;
+}
+
+static inline int ima_path_check(struct path *path, int mask)
+{
+	return 0;
+}
+
+static inline void ima_file_free(struct file *file)
+{
+	return;
+}
+
+static inline int ima_file_mmap(struct file *file, unsigned long prot)
+{
+	return 0;
+}
+#endif /* _LINUX_IMA_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 8d95902..d36a587 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/hugetlb.h>
 #include <linux/profile.h>
 #include <linux/module.h>
@@ -1049,6 +1050,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
+	error = ima_file_mmap(file, prot);
+	if (error)
+		return error;
 
 	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
 			   accountable);
-- 
1.5.6.6

