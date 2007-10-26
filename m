Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbXJZQIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbXJZQIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXJZQIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:08:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXJZQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:08:38 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.23: Filesystem capabilities 0.17
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 26 Oct 2007 18:08:32 +0200
Message-ID: <871wbhc0zj.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/JEDB3yoWd1mVPfraCIYrmD5K/O1ajPYpkCFD
 k7IbAXO7fSk46jHBtKYgIV9S5tzRa5aKuF8yxo1Fl6kBbvQWOE
 eTPWMfIaruZbcwwnMP0Pw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements filesystem capabilities. It allows to
run privileged executables without the need for suid root.

Changes:
- updated to 2.6.23
- fix const correctness
- fix secureexec

This patch is available at:
<http://www.olafdietsche.de/linux/capability/>

Regards, Olaf.

 fs/Kconfig                 |   64 +++++++++
 fs/Makefile                |    3 +-
 fs/attr.c                  |    7 +-
 fs/fscaps.c                |  318 ++++++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c             |    3 +
 fs/open.c                  |    4 +
 fs/super.c                 |    3 +
 include/linux/capability.h |    4 +
 include/linux/fs.h         |    1 +
 include/linux/fscaps.h     |   28 ++++
 security/commoncap.c       |   16 ++-
 11 files changed, 442 insertions(+), 9 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f9eed6d..8eaa590 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1425,6 +1425,70 @@ config QNX4FS_RW
 	  It's currently broken, so for now:
 	  answer N.
 
+config FS_CAPABILITIES
+	bool "Filesystem capabilities (Experimental)"
+	depends on EXPERIMENTAL
+	default n
+	help
+	  This implementation is likely _not_ POSIX compatible.
+
+	  If you say Y here, you will be able to grant selective privileges to
+	  executables on a needed basis. This means for some executables, there
+	  is no need anymore to run as root or as a suid root binary.
+
+	  For example, you may drop the SUID bit from ping and grant the
+	  CAP_NET_RAW capability:
+	  # chmod u-s /bin/ping
+	  # chcap cap_net_raw=ep /bin/ping
+
+	  Another use would be to run system daemons with their own uid:
+	  # chcap cap_net_bind_service=ei /usr/sbin/named
+	  This sets the effective and inheritable capabilities of named.
+
+	  In your startup script:
+	  inhcaps cap_net_bind_service=i bind:bind /usr/sbin/named
+
+	  This sets the inheritable set to CAP_NET_BIND_SERVICE, which is
+	  needed in order to bind to port 53, and runs named as user bind
+	  with group bind.
+
+	  This allows running named with needed restricted privileges, if the
+	  parent process (root) owns them already. When started by regular
+	  users, named runs without any privileges.
+
+	  WARNING:
+	  resize2fs(8) might relocate inodes and thus break fs capabilities.
+	  For this to work you must dump the capability db before you resize
+	  and restore the db afterwards.
+
+	  For user space tools see:
+	  <http://www.olafdietsche.de/linux/capability/>
+
+	  For libcap and an alternative implementation, based on extended
+	  attributes, see:
+	  <http://www.kernel.org/pub/linux/libs/security/linux-privs/>
+
+	  If you're unsure, say N.
+
+config LIBC_ENABLE_SECURE_HACK
+	bool "Disable LD_PRELOAD on privileged executables"
+	depends on FS_CAPABILITIES
+	default n
+	help
+	  LD_PRELOAD is a glibc feature, which allows to override system
+	  library functions. But this means also a security hole, through
+	  which an attacker might gain unauthorized privileges. This is
+	  already prevented for SUID and SGID binaries.
+
+	  Older GNU libc (pre 2.3.6) didn't know about filesystem
+	  capabilities and didn't disable LD_PRELOAD for privileged
+	  executables, which are not SUID or SGID. This hack sets the
+	  group id to an invalid value and tricks GNU libc into thinking,
+	  this is a SGID binary (unless it is already SUID and/or SGID).
+
+	  However, this may break some programs.
+
+	  If your libc is older than 2.3.6, say Y.
 
 
 config SYSV_FS
diff --git a/fs/Makefile b/fs/Makefile
index 720c29d..4188165 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -63,7 +63,8 @@ obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
- 
+obj-$(CONFIG_FS_CAPABILITIES)	+= fscaps.o
+
 # Do not add any filesystems before this line
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..c5ba4f3 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -14,6 +14,7 @@
 #include <linux/fcntl.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/fscaps.h>
 
 /* Taken over from the old code... */
 
@@ -162,8 +163,12 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (ia_valid & ATTR_SIZE)
 		up_write(&dentry->d_inode->i_alloc_sem);
 
-	if (!error)
+	if (!error) {
+		if (ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+			fscap_drop(inode);
+
 		fsnotify_change(dentry, ia_valid);
+	}
 
 	return error;
 }
diff --git a/fs/fscaps.c b/fs/fscaps.c
new file mode 100644
index 0000000..5bb5c00
--- /dev/null
+++ b/fs/fscaps.c
@@ -0,0 +1,318 @@
+/*
+ * Copyright (c) 2002 Olaf Dietsche
+ *
+ * Filesystem capabilities for linux.
+ */
+
+#include <linux/fscaps.h>
+#include <linux/module.h>
+#include <linux/binfmts.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/slab.h>
+#include <linux/mount.h>
+#include <asm/uaccess.h>
+
+struct fscap_info {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+	struct inode_operations rootdir_envelop;
+	const struct inode_operations *rootdir_iops;
+	struct inode_operations cap_envelop;
+	const struct inode_operations *cap_iops;
+};
+
+static char __capname[] = ".capabilities";
+
+static int __is_capname(const char *name)
+{
+	if (*name != __capname[0])
+		return 0;
+
+	return !strcmp(name, __capname);
+}
+
+static int __is_capentry(struct dentry *dentry)
+{
+	return dentry == dentry->d_sb->s_fscaps->dentry;
+}
+
+static int __cap_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	const struct inode_operations *iops;
+	if ((mask & MAY_WRITE) && !capable(CAP_SETFCAP))
+		return -EPERM;
+
+	iops = inode->i_sb->s_fscaps->cap_iops;
+	if (iops && iops->permission)
+		return iops->permission(inode, mask, nd);
+
+	return generic_permission(inode, mask, NULL);
+}
+
+static void __info_cap_release(struct fscap_info *info)
+{
+	if (info->dentry) {
+		struct inode *inode = info->dentry->d_inode;
+		if (inode)
+			inode->i_op = info->cap_iops;
+
+		dput(info->dentry);
+	}
+}
+
+static void __info_cap_init(struct fscap_info *info, struct dentry *dentry)
+{
+	struct inode *inode;
+	const struct inode_operations *iops;
+	__info_cap_release(info);
+
+	info->dentry = dget(dentry);
+	if (!dentry)
+		return;
+
+	inode = dentry->d_inode;
+	if (!inode) {
+		printk(KERN_WARNING "%s: negative dentry. Disabling capabilities on %s.\n", __FUNCTION__, info->mnt->mnt_mountpoint->d_name.name);
+		dput(info->dentry);
+		info->dentry = NULL;
+		return;
+	}
+
+	info->cap_iops = iops = inode->i_op;
+	memset(&info->cap_envelop, 0, sizeof(info->cap_envelop));
+	if (iops)
+		info->cap_envelop = *iops;
+
+	info->cap_envelop.permission = __cap_permission;
+	inode->i_op = &info->cap_envelop;
+}
+
+static int __rootdir_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+{
+	const struct inode_operations *iops;
+	int err, iscapdb = __is_capname(dentry->d_name.name);
+	if (iscapdb && !capable(CAP_SETFCAP))
+		return -EPERM;
+
+	iops = dir->i_sb->s_fscaps->rootdir_iops;
+	err = iops->create(dir, dentry, mode, nd);
+	if (!err && iscapdb)
+		__info_cap_init(dir->i_sb->s_fscaps, dentry);
+
+	return err;
+}
+
+static int __rootdir_link(struct dentry *old_dentry, struct inode *dir,
+			  struct dentry *new_dentry)
+{
+	const struct inode_operations *iops;
+	int err, iscapdb = __is_capname(new_dentry->d_name.name);
+	if (iscapdb && !capable(CAP_SETFCAP))
+		return -EPERM;
+
+	iops = dir->i_sb->s_fscaps->rootdir_iops;
+	err = iops->link(old_dentry, dir, new_dentry);
+	if (!err && iscapdb)
+		__info_cap_init(dir->i_sb->s_fscaps, new_dentry);
+
+	return err;
+}
+
+static int __rootdir_unlink(struct inode *dir, struct dentry *dentry)
+{
+	const struct inode_operations *iops;
+	int err, iscapdb = __is_capentry(dentry);
+	if (iscapdb && !capable(CAP_SETFCAP))
+		return -EPERM;
+
+	iops = dir->i_sb->s_fscaps->rootdir_iops;
+	err = iops->unlink(dir, dentry);
+	if (!err && iscapdb)
+		__info_cap_init(dir->i_sb->s_fscaps, NULL);
+
+	return err;
+}
+
+static int __rootdir_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
+{
+	const struct inode_operations *iops;
+	if (__is_capname(dentry->d_name.name))
+		return -EPERM;
+
+	iops = dir->i_sb->s_fscaps->rootdir_iops;
+	return iops->symlink(dir, dentry, oldname);
+}
+
+static int __rootdir_rename(struct inode *old_dir, struct dentry *old_dentry,
+			    struct inode *new_dir, struct dentry *new_dentry)
+{
+	const struct inode_operations *iops;
+	if (__is_capentry(old_dentry) || __is_capname(new_dentry->d_name.name))
+		return -EPERM;
+
+	iops = old_dir->i_sb->s_fscaps->rootdir_iops;
+	return iops->rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
+static void __info_rootdir_release(struct fscap_info *info)
+{
+	struct inode *inode = info->mnt->mnt_sb->s_root->d_inode;
+	if (inode) {
+		inode->i_op = info->rootdir_iops;
+	}
+}
+
+static void __info_rootdir_init(struct fscap_info *info, struct inode *dir)
+{
+	const struct inode_operations *iops = dir->i_op;
+	info->rootdir_iops = iops;
+	if (iops) {
+		info->rootdir_envelop = *iops;
+		info->rootdir_envelop.create = iops->create ? __rootdir_create : 0;
+		info->rootdir_envelop.link = iops->link ? __rootdir_link : 0;
+		info->rootdir_envelop.unlink = iops->unlink ? __rootdir_unlink : 0;
+		info->rootdir_envelop.symlink = iops->symlink ? __rootdir_symlink : 0;
+		info->rootdir_envelop.rename = iops->rename ? __rootdir_rename : 0;
+		dir->i_op = &info->rootdir_envelop;
+	}
+}
+
+static void __info_init(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct fscap_info *info = kmalloc(sizeof(struct fscap_info), GFP_KERNEL);
+	if (info) {
+		info->mnt = mnt;
+		info->dentry = NULL;
+		__info_rootdir_init(info, mnt->mnt_sb->s_root->d_inode);
+		__info_cap_init(info, dentry);
+	}
+
+	mnt->mnt_sb->s_fscaps = info;
+}
+
+static void __info_release(struct fscap_info *info)
+{
+	if (info) {
+		__info_cap_release(info);
+		__info_rootdir_release(info);
+		kfree(info);
+	}
+}
+
+static inline struct fscap_info *__info_lookup(struct super_block *sb) 
+{
+	return sb->s_fscaps;
+}
+
+static int __fscap_lookup(struct vfsmount *mnt, struct nameidata *nd)
+{
+	return vfs_path_lookup(mnt->mnt_sb->s_root, mnt, __capname, 0, nd);
+}
+
+static struct file *__fscap_open(struct dentry *dentry, struct vfsmount *mnt, int flags)
+{
+	if (mnt->mnt_flags & MNT_NOSUID)
+		return ERR_PTR(-EPERM);
+
+	dentry = dget(dentry);
+	mnt = mntget(mnt);
+	return dentry_open(dentry, mnt, flags);
+}
+
+static void __fscap_read(struct file *filp, struct linux_binprm *bprm)
+{
+	__u32 fscaps[3][4];
+	unsigned long ino = bprm->file->f_dentry->d_inode->i_ino;
+	int n = kernel_read(filp, ino * sizeof(fscaps), (char *) fscaps, sizeof(fscaps));
+	if (n == sizeof(fscaps)) {
+		/* small sanity check */
+		if (fscaps[0][1] || fscaps[0][2] || fscaps[0][3]
+		    || fscaps[1][1] || fscaps[1][2] || fscaps[1][3]
+		    || fscaps[2][1] || fscaps[2][2] || fscaps[2][3])
+			return;
+
+		bprm->cap_effective = fscaps[0][0];
+		bprm->cap_inheritable = fscaps[1][0];
+		bprm->cap_permitted = fscaps[2][0];
+	}
+}
+
+static int kernel_write(struct file *file, unsigned long offset,
+		 char *addr, unsigned long count)
+{
+	mm_segment_t old_fs;
+	loff_t pos = offset;
+	int result;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	result = vfs_write(file, addr, count, &pos);
+	set_fs(old_fs);
+	return result;
+}
+
+static void __fscap_drop(struct file *filp, struct inode *inode)
+{
+	__u32 fscaps[3][4];
+	unsigned long ino = inode->i_ino;
+	int n = kernel_read(filp, ino * sizeof(fscaps), (char *) fscaps, sizeof(fscaps));
+	if (n == sizeof(fscaps) && (fscaps[0][0] || fscaps[1][0] || fscaps[2][0])) {
+		memset(fscaps, 0, sizeof(fscaps));
+		kernel_write(filp, ino * sizeof(fscaps), (char *) fscaps, sizeof(fscaps));
+	}
+}
+
+void fscap_mount(struct vfsmount *mnt)
+{
+	struct nameidata nd;
+	if (__info_lookup(mnt->mnt_sb))
+		return;
+
+	if (__fscap_lookup(mnt, &nd)) {
+		__info_init(mnt, NULL);
+	} else {
+		__info_init(mnt, nd.dentry);
+		path_release(&nd);
+	}
+}
+
+void fscap_umount(struct super_block *sb)
+{
+	struct fscap_info *info = __info_lookup(sb);
+	__info_release(info);
+	sb->s_fscaps = NULL;
+}
+
+void fscap_read(struct linux_binprm *bprm)
+{
+	struct file *filp;
+	struct fscap_info *info = __info_lookup(bprm->file->f_vfsmnt->mnt_sb);
+	if (!info || !info->dentry)
+		return;
+
+	filp = __fscap_open(info->dentry, info->mnt, O_RDONLY);
+	if (filp && !IS_ERR(filp)) {
+		__fscap_read(filp, bprm);
+		filp_close(filp, 0);
+	}
+}
+
+void fscap_drop(struct inode *inode)
+{
+	struct file *filp;
+	struct fscap_info *info = __info_lookup(inode->i_sb);
+	if (!info || !info->dentry)
+		return;
+
+	filp = __fscap_open(info->dentry, info->mnt, O_RDWR);
+	if (filp && !IS_ERR(filp)) {
+		__fscap_drop(filp, inode);
+		filp_close(filp, 0);
+	}
+}
+
+EXPORT_SYMBOL(fscap_mount);
+EXPORT_SYMBOL(fscap_umount);
+EXPORT_SYMBOL(fscap_read);
+EXPORT_SYMBOL(fscap_drop);
diff --git a/fs/namespace.c b/fs/namespace.c
index ddbda13..30f130c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/fscaps.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -1110,6 +1111,8 @@ int do_add_mount(struct vfsmount *newmnt, struct nameidata *nd,
 	if ((err = graft_tree(newmnt, nd)))
 		goto unlock;
 
+	fscap_mount(newmnt);
+
 	if (fslist) {
 		/* add to the specified expiration list */
 		spin_lock(&vfsmount_lock);
diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..85c779e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -27,6 +27,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/fscaps.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -779,6 +780,9 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 		}
 	}
 
+	if (flags & O_CREAT)
+		fscap_drop(inode);
+
 	return f;
 
 cleanup_all:
diff --git a/fs/super.c b/fs/super.c
index fc8ebed..abcbe8c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -37,6 +37,7 @@
 #include <linux/idr.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
+#include <linux/fscaps.h>
 #include <asm/uaccess.h>
 
 
@@ -93,6 +94,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_qcop = sb_quotactl_ops;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+ 		s->s_fscaps = NULL;
 	}
 out:
 	return s;
@@ -180,6 +182,7 @@ void deactivate_super(struct super_block *s)
 		s->s_count -= S_BIAS-1;
 		spin_unlock(&sb_lock);
 		DQUOT_OFF(s);
+		fscap_umount(s);
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
 		put_filesystem(fs);
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 2dfa585..1d926e7 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -289,6 +289,10 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
+/* Allow setting capabilities on files */
+
+#define CAP_SETFCAP          31
+
 #ifdef __KERNEL__
 /* 
  * Bounding set
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16421f6..31511c1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -955,6 +955,7 @@ struct super_block {
 	struct mtd_info		*s_mtd;
 	struct list_head	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
+	struct fscap_info	*s_fscaps;	/* Filesystem capability stuff */
 
 	int			s_frozen;
 	wait_queue_head_t	s_wait_unfrozen;
diff --git a/include/linux/fscaps.h b/include/linux/fscaps.h
new file mode 100644
index 0000000..9046c15
--- /dev/null
+++ b/include/linux/fscaps.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2002 Olaf Dietsche
+ *
+ * Filesystem capabilities for linux.
+ */
+
+#ifndef _LINUX_FS_CAPS_H
+#define _LINUX_FS_CAPS_H
+
+struct vfsmount;
+struct super_block;
+struct linux_binprm;
+struct inode;
+
+#if defined(CONFIG_FS_CAPABILITIES)
+extern void fscap_mount(struct vfsmount *mnt);
+extern void fscap_umount(struct super_block *sb);
+extern void fscap_read(struct linux_binprm *bprm);
+extern void fscap_drop(struct inode *inode);
+#else	
+/* !CONFIG_FS_CAPABILITIES */
+static inline void fscap_mount(struct vfsmount *mnt) {}
+static inline void fscap_umount(struct super_block *sb) {}
+static inline void fscap_read(struct linux_binprm *bprm) {}
+static inline void fscap_drop(struct inode *inode) {}
+#endif
+
+#endif
diff --git a/security/commoncap.c b/security/commoncap.c
index 7520361..ea53ba8 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
+#include <linux/fscaps.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -112,11 +113,12 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 {
 	/* Copied from fs/exec.c:prepare_binprm. */
 
-	/* We don't have VFS support for capabilities yet */
 	cap_clear (bprm->cap_inheritable);
 	cap_clear (bprm->cap_permitted);
 	cap_clear (bprm->cap_effective);
 
+	fscap_read(bprm);
+
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
 	 *  capability sets for the file.
@@ -160,6 +162,10 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 							current->cap_permitted);
 			}
 		}
+#ifdef CONFIG_LIBC_ENABLE_SECURE_HACK
+		if (bprm->e_uid == current->uid && bprm->e_gid == current->gid)
+			current->gid = -1;
+#endif
 	}
 
 	current->suid = current->euid = current->fsuid = bprm->e_uid;
@@ -181,13 +187,9 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	/* If/when this module is enhanced to incorporate capability
-	   bits on files, the test below should be extended to also perform a 
-	   test between the old and new capability sets.  For now,
-	   it simply preserves the legacy decision algorithm used by
-	   the old userland. */
 	return (current->euid != current->uid ||
-		current->egid != current->gid);
+		current->egid != current->gid ||
+		!cap_isclear(current->cap_permitted));
 }
 
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
