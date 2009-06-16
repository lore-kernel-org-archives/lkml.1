Return-Path: <linux-kernel-owner+w=401wt.eu-S1763559AbZFPUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763559AbZFPUli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZFPUkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbZFPUkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/17] VFS: Implement the pioctl() system call
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:38:51 +0100
Message-ID: <20090616203850.4526.83585.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Thebault-Spieker <summatusmentis@gmail.com>

Implement the pioctl() system call.  This is used to support a number of AFS
functions, and could also be used for Coda and other filesystems.

Signed-off-by: Jacob Thebault-Spieker <summatusmentis@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/ia32/ia32entry.S          |    1 
 arch/x86/include/asm/unistd_32.h   |    1 
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 
 fs/Kconfig                         |    6 ++
 fs/Makefile                        |    3 +
 fs/afs/Kconfig                     |    1 
 fs/afs/Makefile                    |    3 +
 fs/afs/dir.c                       |    1 
 fs/afs/file.c                      |    1 
 fs/afs/inode.c                     |    9 +++
 fs/afs/internal.h                  |    5 ++
 fs/afs/mntpt.c                     |    1 
 fs/afs/pioctl.c                    |   24 ++++++++
 fs/compat_pioctl.c                 |  100 ++++++++++++++++++++++++++++++++++
 fs/pioctl.c                        |  107 ++++++++++++++++++++++++++++++++++++
 include/linux/compat.h             |   10 +++
 include/linux/fs.h                 |    2 +
 include/linux/pioctl.h             |   58 ++++++++++++++++++++
 include/linux/syscalls.h           |    5 ++
 20 files changed, 339 insertions(+), 2 deletions(-)
 create mode 100644 fs/afs/pioctl.c
 create mode 100644 fs/compat_pioctl.c
 create mode 100644 fs/pioctl.c
 create mode 100644 include/linux/pioctl.h


diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e590261..5caa7bd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -832,4 +832,5 @@ ia32_sys_call_table:
 	.quad compat_sys_pwritev
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_counter_open
+	.quad compat_sys_pioctl
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 732a307..f4f5c35 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,6 +342,7 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_counter_open	336
+#define __NR_pioctl		337
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 900e161..495d0fb 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,8 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_counter_open			298
 __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
+#define __NR_pioctl				299
+__SYSCALL(__NR_pioctl, sys_pioctl)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d51321d..723f33e 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,4 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_counter_open
+	.long sys_pioctl
diff --git a/fs/Kconfig b/fs/Kconfig
index 525da2e..69cff4a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -76,6 +76,12 @@ config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
 
+config PIOCTL
+	bool
+	help
+	  This option enabled the pioctl() system call, which is used by AFS
+	  and Coda
+
 menu "Caches"
 
 source "fs/fscache/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..d5bf38a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -51,6 +51,9 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
+pioctl-compat-$(CONFIG_COMPAT)	:= compat_pioctl.o
+obj-$(CONFIG_PIOCTL)		+= pioctl.o $(pioctl-compat-y)
+
 obj-y				+= quota/
 
 obj-$(CONFIG_PROC_FS)		+= proc/
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 5c4e61d..2bd2324 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -2,6 +2,7 @@ config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	select AF_RXRPC
+	select PIOCTL
 	help
 	  If you say Y here, you will get an experimental Andrew File System
 	  driver. It currently only supports unsecured read-only AFS access.
diff --git a/fs/afs/Makefile b/fs/afs/Makefile
index 4f64b95..0160227 100644
--- a/fs/afs/Makefile
+++ b/fs/afs/Makefile
@@ -27,6 +27,7 @@ kafs-objs := \
 	vlocation.o \
 	vnode.o \
 	volume.o \
-	write.o
+	write.o \
+	pioctl.o
 
 obj-$(CONFIG_AFS_FS)  := kafs.o
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9bd7577..e1a785c 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -60,6 +60,7 @@ const struct inode_operations afs_dir_inode_operations = {
 	.permission	= afs_permission,
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
+	.pioctl		= afs_pioctl,
 };
 
 static const struct dentry_operations afs_fs_dentry_operations = {
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 0149dab..73835b7 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -45,6 +45,7 @@ const struct inode_operations afs_file_inode_operations = {
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
 	.permission	= afs_permission,
+	.pioctl		= afs_pioctl,
 };
 
 const struct address_space_operations afs_fs_aops = {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index c048f06..f1de608 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -27,6 +27,13 @@ struct afs_iget_data {
 	struct afs_volume	*volume;	/* volume on which resides */
 };
 
+static const struct inode_operations afs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+	.pioctl		= afs_pioctl,
+};
+
 /*
  * map the AFS file status to the inode member variables
  */
@@ -54,7 +61,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 		break;
 	case AFS_FTYPE_SYMLINK:
 		inode->i_mode	= S_IFLNK | vnode->status.mode;
-		inode->i_op	= &page_symlink_inode_operations;
+		inode->i_op	= &afs_symlink_inode_operations;
 		break;
 	default:
 		printk("kAFS: AFS vnode with undefined type\n");
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 106be66..0aaa324 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -584,6 +584,11 @@ extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
 
 /*
+ * pioctl.c
+ */
+extern long afs_pioctl(struct dentry *, int, struct vice_ioctl *);
+
+/*
  * proc.c
  */
 extern int afs_proc_init(void);
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index c52be53..153bea5 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -37,6 +37,7 @@ const struct inode_operations afs_mntpt_inode_operations = {
 	.follow_link	= afs_mntpt_follow_link,
 	.readlink	= page_readlink,
 	.getattr	= afs_getattr,
+	.pioctl		= afs_pioctl,
 };
 
 static LIST_HEAD(afs_vfsmounts);
diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
new file mode 100644
index 0000000..e266f27
--- /dev/null
+++ b/fs/afs/pioctl.c
@@ -0,0 +1,24 @@
+/* Path-based I/O control
+ *
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/fs.h>
+#include <linux/pioctl.h>
+#include "internal.h"
+
+/*
+ * The AFS path-based I/O control operation
+ */
+long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
+{
+	switch (cmd) {
+	default:
+		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/fs/compat_pioctl.c b/fs/compat_pioctl.c
new file mode 100644
index 0000000..9f2de77
--- /dev/null
+++ b/fs/compat_pioctl.c
@@ -0,0 +1,100 @@
+/* Path-based I/O control, compatibility
+ *
+ * Copyright (C) 2009 David Howells <dhowells@redhat.com>
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * Modified by David Howells <dhowells@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/fs.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/compat.h>
+#include <linux/namei.h>
+#include <linux/pioctl.h>
+#include <linux/slab.h>
+
+/*
+ * Path-based I/O control system call, 32-bit compatibility version
+ */
+long compat_sys_pioctl(const char __user *filename, int cmd,
+		       struct compat_ViceIoctl __user *arg, int follow)
+{
+	struct compat_ViceIoctl user_args;
+	struct vice_ioctl kargs;
+	struct path path;
+	long error;
+
+	if (copy_from_user(&user_args, arg, sizeof(user_args)) != 0)
+		return -EFAULT;
+
+	if (user_args.in_size < 0 || user_args.out_size < 0)
+		return -EINVAL;
+
+	if (user_args.in) {
+		if (unlikely(!access_ok(VERIFY_READ,
+					compat_ptr(user_args.in),
+					user_args.in_size)))
+			return -EFAULT;
+
+		kargs.in = kmalloc(user_args.in_size, GFP_KERNEL);
+		if (!kargs.in)
+			return -ENOMEM;
+
+		if (copy_from_user(kargs.in,
+				   compat_ptr(user_args.in),
+				   user_args.in_size) != 0) {
+			kfree(kargs.in);
+			return -EFAULT;
+		}
+		kargs.in_size = user_args.in_size;
+	} else {
+		kargs.in_size = 0;
+		kargs.in = NULL;
+	}
+
+	if (user_args.out) {
+		if (unlikely(!access_ok(VERIFY_WRITE,
+					compat_ptr(user_args.out),
+					user_args.out_size))) {
+			kfree(kargs.in);
+			return -EFAULT;
+		}
+		kargs.out = kmalloc(user_args.out_size, GFP_KERNEL);
+		if (!kargs.out) {
+			kfree(kargs.in);
+			return -ENOMEM;
+		}
+	} else {
+		kargs.out_size = 0;
+		kargs.out = NULL;
+	}
+
+	error = user_path(filename, &path);
+	if (!error) {
+		if (path.dentry->d_inode)
+			error = vfs_pioctl(path.dentry, cmd, &kargs);
+		path_put(&path);
+	}
+	kfree(kargs.in);
+
+	if (user_args.out) {
+		if (error >= 0) {
+			if (copy_to_user(compat_ptr(user_args.out), kargs.out,
+					 kargs.out_size) != 0) {
+				kfree(kargs.out);
+				return -EFAULT;
+			}
+			if (put_user(kargs.out_size, &arg->out_size) != 0)
+				error = -EFAULT;
+		}
+		kfree(kargs.out);
+	}
+
+	return error;
+}
diff --git a/fs/pioctl.c b/fs/pioctl.c
new file mode 100644
index 0000000..c17f220
--- /dev/null
+++ b/fs/pioctl.c
@@ -0,0 +1,107 @@
+/* Path-based I/O control
+ *
+ * Copyright (C) 2009 David Howells <dhowells@redhat.com>
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * This program is free software; you can redistribute it a/or
+ * modify it uer the terms of the GNU General Public License
+ * as published by the Free Software Fouation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/fs.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/namei.h>
+#include <linux/pioctl.h>
+#include <linux/slab.h>
+
+/*
+ * VFS entry point for path-based I/O control
+ */
+long vfs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
+{
+	if (!dentry->d_inode->i_op || !dentry->d_inode->i_op->pioctl)
+		return -EPERM;
+
+	return dentry->d_inode->i_op->pioctl(dentry, cmd, arg);
+}
+
+/*
+ * Path-based I/O control system call
+ */
+SYSCALL_DEFINE4(pioctl,
+		const char __user *, filename, int, cmd,
+		struct ViceIoctl __user *, arg, int, follow)
+{
+	struct vice_ioctl kargs;
+	struct ViceIoctl user_args;
+	struct path path;
+	long error;
+
+	if (copy_from_user(&user_args, arg, sizeof(user_args)) != 0)
+		return -EFAULT;
+
+	if (user_args.in_size < 0 || user_args.out_size < 0)
+		return -EINVAL;
+
+	if (user_args.in) {
+		if (unlikely(!access_ok(VERIFY_READ, user_args.in,
+					user_args.in_size)))
+			return -EFAULT;
+
+		kargs.in = kmalloc(user_args.in_size, GFP_KERNEL);
+		if (!kargs.in)
+			return -ENOMEM;
+
+		if (copy_from_user(kargs.in, user_args.in,
+				   user_args.in_size) != 0) {
+			kfree(kargs.in);
+			return -EFAULT;
+		}
+		kargs.in_size = user_args.in_size;
+	} else {
+		kargs.in = NULL;
+		kargs.in_size = 0;
+	}
+
+	if (user_args.out) {
+		if (unlikely(!access_ok(VERIFY_WRITE, user_args.out,
+					user_args.out_size))) {
+			kfree(kargs.in);
+			return -EFAULT;
+		}
+		kargs.out = kmalloc(user_args.out_size, GFP_KERNEL);
+		if (!kargs.out) {
+			kfree(kargs.in);
+			return -ENOMEM;
+		}
+		kargs.out_size = user_args.out_size;
+	} else {
+		kargs.out_size = 0;
+		kargs.out = NULL;
+	}
+
+	error = user_path(filename, &path);
+	if (!error) {
+		if (path.dentry->d_inode)
+			error = vfs_pioctl(path.dentry, cmd, &kargs);
+		path_put(&path);
+	}
+	kfree(kargs.in);
+
+	if (user_args.out) {
+		if (error >= 0) {
+			if (copy_to_user(user_args.out, kargs.out,
+					 kargs.out_size) != 0) {
+				kfree(kargs.out);
+				return -EFAULT;
+			}
+			if (put_user(kargs.out_size, &arg->out_size) != 0)
+				error = -EFAULT;
+		}
+		kfree(kargs.out);
+	}
+
+	return error;
+}
diff --git a/include/linux/compat.h b/include/linux/compat.h
index af931ee..35afe29 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -132,6 +132,13 @@ struct compat_ustat {
 	char			f_fpack[6];
 };
 
+struct compat_ViceIoctl {
+	compat_uptr_t	in;
+	compat_uptr_t	out;
+	short 		in_size;
+	short 		out_size;
+};
+
 typedef union compat_sigval {
 	compat_int_t	sival_int;
 	compat_uptr_t	sival_ptr;
@@ -308,6 +315,9 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
 				      int flag);
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
+asmlinkage long compat_sys_pioctl(const char __user *filename, int cmd,
+				  struct compat_ViceIoctl __user *arg,
+				  int follow);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 32b0228..1737524 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -388,6 +388,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct vice_ioctl;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1531,6 +1532,7 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	long (*pioctl)(struct dentry *, int, struct vice_ioctl *);
 };
 
 struct seq_file;
diff --git a/include/linux/pioctl.h b/include/linux/pioctl.h
new file mode 100644
index 0000000..8e979f4
--- /dev/null
+++ b/include/linux/pioctl.h
@@ -0,0 +1,58 @@
+/* Path-based I/O control command listing
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Modifications Copyright (C) 2008
+ *	Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * pioctl definitions taken from http://grand.central.org/numbers/pioctls.html
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_PIOCTL_H
+#define _LINUX_PIOCTL_H
+
+#ifdef __KERNEL__
+
+/*
+ * pioctl syscall argument block
+ */
+struct ViceIoctl {
+	caddr_t __user	in;		/* input/argument buffer (or NULL) */
+	caddr_t __user	out;		/* output/reply buffer (or NULL) */
+	short 		in_size;	/* size of input buffer (or 0) */
+	short 		out_size;	/* size of output buffer (or 0) */
+};
+
+struct vice_ioctl {
+	char		*in;
+	char		*out;
+	short		in_size;
+	short		out_size;
+};
+
+/*
+ * Internal pioctl handler
+ */
+extern long vfs_pioctl(struct dentry *, int, struct vice_ioctl *);
+
+#else
+
+/*
+ * Userspace version of pioctl syscall argument block
+ */
+struct ViceIoctl {
+	caddr_t		in;
+	caddr_t		out;
+	short		in_size;
+	short		out_size;
+};
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_PIOCTL_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 418d90f..ab6f49f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -56,6 +56,7 @@ struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
 struct perf_counter_attr;
+struct ViceIoctl;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -760,4 +761,8 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 asmlinkage long sys_perf_counter_open(
 		struct perf_counter_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
+
+asmlinkage long sys_pioctl(const char __user *filename, int cmd,
+			   struct ViceIoctl __user *args, int nofollow);
+
 #endif

