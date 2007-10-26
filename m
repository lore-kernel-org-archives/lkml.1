Return-Path: <linux-kernel-owner+w=401wt.eu-S1763640AbXJZQHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640AbXJZQHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJZQH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:07:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbXJZQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:07:25 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.23: access permission filesystem 0.20
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 26 Oct 2007 18:07:19 +0200
Message-ID: <878x5pc11k.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+ISVS709cJV6RcD1rpG6x7fmbM64ohNptJyGi
 WyrRA1kt/sDY4f6mcj6zV9ZJezj03kgPrOw595g2TkHsFuO9Tm
 wYBE8t7FT+OAcAO7DH+KA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new permission managing file system.
Furthermore, it adds two modules, which make use of this file system.

One module allows granting capabilities based on user-/groupid. The
second module allows to grant access to lower numbered ports based on
user-/groupid, too.

Changes:
- updated to 2.6.23

This patch is available at:
<http://www.olafdietsche.de/linux/accessfs/>

Regards, Olaf.

 Documentation/filesystems/accessfs.txt |   41 +++
 fs/Kconfig                             |    1 +
 fs/Makefile                            |    1 +
 fs/accessfs/Kconfig                    |   50 ++++
 fs/accessfs/Makefile                   |   11 +
 fs/accessfs/capabilities.c             |  107 ++++++++
 fs/accessfs/inode.c                    |  426 ++++++++++++++++++++++++++++++++
 fs/accessfs/ip.c                       |   95 +++++++
 include/linux/accessfs_fs.h            |   42 +++
 include/net/sock.h                     |   43 ++++
 net/Kconfig                            |   12 +
 net/Makefile                           |    1 +
 net/hooks.c                            |   55 ++++
 net/ipv4/af_inet.c                     |    2 +-
 net/ipv6/af_inet6.c                    |    2 +-
 15 files changed, 887 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/accessfs.txt b/Documentation/filesystems/accessfs.txt
new file mode 100644
index 0000000..bf135b5
--- /dev/null
+++ b/Documentation/filesystems/accessfs.txt
@@ -0,0 +1,41 @@
+Accessfs is a permission managing filesystem. It allows to control access to
+system resources, based on file permissions. The recommended mount point for
+this file-system is /proc/access, which will appear automatically in the
+/proc filesystem.
+
+Currently there are two modules using accessfs, userports and usercaps.
+
+With userports, you will be able to control access to IP ports based
+on user-/groupid.
+
+There's no need anymore to run internet daemons as root. You can
+individually configure which user/program can bind to protected ports
+(by default, below 1024).
+
+For example, you can say, user www is allowed to bind to port 80 or
+user mail is allowed to bind to port 25. Then, you can run apache as
+user www and sendmail as user mail. Now, you don't have to rely on
+apache or sendmail giving up superuser rights to enhance security.
+
+To use this option, you need to mount the access file system
+and do a chown on the appropriate ports:
+
+# mount -t accessfs none /proc/access
+# chown www /proc/access/net/ip/bind/80
+# chown mail /proc/access/net/ip/bind/25
+
+You can grant access to a group for individual ports as well. Just say:
+
+# chgrp lp /proc/access/net/ip/bind/515
+# chown g+x /proc/access/net/ip/bind/515
+
+With usercaps, you will be able to grant capabilities based on
+user-/groupid (root by default).
+
+For example you can create a group raw and change the capability
+net_raw to this group:
+
+# chgrp raw /proc/access/capabilities/net_raw
+# chmod ug+x /proc/access/capabilities/net_raw
+# chgrp raw /sbin/ping
+# chmod u-s /sbin/ping; chmod g+s /sbin/ping
diff --git a/fs/Kconfig b/fs/Kconfig
index f9eed6d..008a764 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1425,6 +1425,7 @@ config QNX4FS_RW
 	  It's currently broken, so for now:
 	  answer N.
 
+source "fs/accessfs/Kconfig"
 
 
 config SYSV_FS
diff --git a/fs/Makefile b/fs/Makefile
index 720c29d..50f6d49 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_ACCESS_FS)		+= accessfs/
diff --git a/fs/accessfs/Kconfig b/fs/accessfs/Kconfig
new file mode 100644
index 0000000..465fe1a
--- /dev/null
+++ b/fs/accessfs/Kconfig
@@ -0,0 +1,50 @@
+config ACCESS_FS
+	tristate "Accessfs support (Experimental)"
+	depends on EXPERIMENTAL
+	default n
+	help
+	  This is a new file system to manage permissions. It is not very
+	  useful on its own. You need to enable other options below.
+
+	  If you're unsure, say N.
+
+config ACCESSFS_USER_PORTS
+	tristate "User permission based IP ports"
+	depends on ACCESS_FS
+	select NET_HOOKS
+	default n
+	help
+	  If you say Y here, you will be able to control access to IP ports
+	  based on user-/groupid. For this to work, you must say Y
+	  to CONFIG_NET_HOOKS.
+
+	  If you're unsure, say N.
+
+config ACCESSFS_PROT_SOCK
+	int "Range of protected ports (1024-65536)"
+	depends on ACCESSFS_USER_PORTS
+	default 1024
+	help
+	  Here you can extend the range of protected ports. This is
+	  from 1-1023 inclusive on normal unix systems. One use for this
+	  could be to reserve ports for X11 (port 6000) or database
+	  servers (port 3306 for mysql), so nobody else could grab this port.
+	  The default permission for extended ports is --x--x--x.
+
+	  If you build this as a module, you can specify the range of
+	  protected ports at module load time (max_prot_sock).
+
+	  If you're unsure, say 1024.
+
+config ACCESSFS_USER_CAPABILITIES
+	tristate "User permission based capabilities"
+	depends on ACCESS_FS
+	select SECURITY
+	default n
+	help
+	  If you say Y here, you will be able to grant capabilities based on
+	  user-/groupid (root by default). For this to work, you must say M or
+	  N to CONFIG_SECURITY_CAPABILITIES.
+
+	  If you're unsure, say N.
+
diff --git a/fs/accessfs/Makefile b/fs/accessfs/Makefile
new file mode 100644
index 0000000..63a5647
--- /dev/null
+++ b/fs/accessfs/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the linux accessfs routines.
+#
+
+obj-$(CONFIG_ACCESS_FS) += accessfs.o
+obj-$(CONFIG_ACCESSFS_USER_CAPABILITIES) += usercaps.o
+obj-$(CONFIG_ACCESSFS_USER_PORTS) += userports.o
+
+accessfs-objs := inode.o
+usercaps-objs := capabilities.o
+userports-objs := ip.o
diff --git a/fs/accessfs/capabilities.c b/fs/accessfs/capabilities.c
new file mode 100644
index 0000000..deaec8f
--- /dev/null
+++ b/fs/accessfs/capabilities.c
@@ -0,0 +1,107 @@
+/* Copyright (c) 2002-2006 Olaf Dietsche
+ *
+ * User based capabilities for Linux.
+ */
+
+#include <linux/accessfs_fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/security.h>
+
+static const char *names[] = {
+	"chown",
+	"dac_override",
+	"dac_read_search",
+	"fowner",
+	"fsetid",
+	"kill",
+	"setgid",
+	"setuid",
+	"setpcap",
+	"linux_immutable",
+	"net_bind_service",
+	"net_broadcast",
+	"net_admin",
+	"net_raw",
+	"ipc_lock",
+	"ipc_owner",
+	"sys_module",
+	"sys_rawio",
+	"sys_chroot",
+	"sys_ptrace",
+	"sys_pacct",
+	"sys_admin",
+	"sys_boot",
+	"sys_nice",
+	"sys_resource",
+	"sys_time",
+	"sys_tty_config",
+	"mknod",
+	"lease"
+};
+
+static struct access_attr caps[ARRAY_SIZE(names)];
+
+static int accessfs_capable(struct task_struct *tsk, int cap)
+{
+	if (accessfs_permitted(&caps[cap], MAY_EXEC)) {
+		/* capability granted */
+		tsk->flags |= PF_SUPERPRIV;
+		return 0;
+	}
+
+	/* capability denied */
+	return -EPERM;
+}
+
+static struct security_operations accessfs_security_ops = {
+	.capable =	accessfs_capable,
+};
+
+static void unregister_capabilities(struct accessfs_direntry *dir, int n)
+{
+	int	i;
+	for (i = 0; i < n; ++i)
+		accessfs_unregister(dir, names[i]);
+}
+
+static int __init init_capabilities(void)
+{
+	struct accessfs_direntry *dir;
+	int i, err;
+	dir = accessfs_make_dirpath("capabilities");
+	if (dir == 0)
+		return -ENOTDIR;
+
+	for (i = 0; i < ARRAY_SIZE(caps); ++i) {
+		caps[i].uid = 0;
+		caps[i].gid = 0;
+		caps[i].mode = S_IXUSR;
+		err = accessfs_register(dir, names[i], &caps[i]);
+		if (err) {
+			unregister_capabilities(dir, i);
+			return err;
+		}
+	}
+
+	err = register_security(&accessfs_security_ops);
+	if (err != 0)
+		unregister_capabilities(dir, ARRAY_SIZE(names));
+
+	return err;
+}
+
+static void __exit exit_capabilities(void)
+{
+	struct accessfs_direntry *dir;
+	dir = accessfs_make_dirpath("capabilities");
+	unregister_security(&accessfs_security_ops);
+	unregister_capabilities(dir, ARRAY_SIZE(names));
+}
+
+module_init(init_capabilities)
+module_exit(exit_capabilities)
+
+MODULE_AUTHOR("Olaf Dietsche");
+MODULE_DESCRIPTION("User based capabilities");
+MODULE_LICENSE("GPL");
diff --git a/fs/accessfs/inode.c b/fs/accessfs/inode.c
new file mode 100644
index 0000000..6100429
--- /dev/null
+++ b/fs/accessfs/inode.c
@@ -0,0 +1,426 @@
+/* Copyright (c) 2001-2006 Olaf Dietsche
+ *
+ * Access permission filesystem for Linux.
+ *
+ * 2002 Ben Clifford, create mount point at /proc/access
+ * 2002 Ben Clifford, trying to make it work under 2.5.5-dj2
+ *          (see comments: BENC255 for reminders and todos)
+ *
+ *
+ * BENC255: the kernel doesn't lock BKL for us when entering methods 
+ *          (see Documentation/fs/porting.txt)
+ *          Need to look at code here and see if we need either the BKL
+ *          or our own lock - I think probably not.
+ *
+ */
+
+#include <linux/accessfs_fs.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/proc_fs.h>
+#include <asm/statfs.h>
+#include <asm/semaphore.h>
+#include <asm/uaccess.h>
+
+#define ACCESSFS_MAGIC	0x3c1d36e7
+
+static struct proc_dir_entry *mountdir = NULL;
+
+static DEFINE_MUTEX(accessfs_sem);
+
+static struct inode_operations accessfs_inode_operations;
+static struct file_operations accessfs_dir_file_operations;
+static struct inode_operations accessfs_dir_inode_operations;
+
+static inline void accessfs_readdir_aux(struct file *filp,
+					struct accessfs_direntry *dir,
+					int start, void *dirent,
+					filldir_t filldir)
+{
+	struct list_head *list;
+	int i = 2;
+	list_for_each(list, &dir->children) {
+		struct accessfs_entry *de;
+		if (i++ < start)
+			continue;
+
+		de = list_entry(list, struct accessfs_entry, siblings);
+		if (filldir(dirent, de->name, strlen(de->name), filp->f_pos,
+			    de->ino, DT_UNKNOWN) < 0)
+			break;
+
+		++filp->f_pos;
+	}
+}
+
+static int accessfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	int i;
+	struct dentry *dentry = filp->f_dentry;
+	struct accessfs_direntry *dir;
+
+	i = filp->f_pos;
+	switch (i) {
+	case 0:
+		if (filldir(dirent, ".", 1, i, dentry->d_inode->i_ino,
+			    DT_DIR) < 0)
+			break;
+
+		++i;
+		++filp->f_pos;
+		/* NO break; */
+	case 1:
+		if (filldir(dirent, "..", 2, i,
+			    dentry->d_parent->d_inode->i_ino, DT_DIR) < 0)
+			break;
+
+		++i;
+		++filp->f_pos;
+		/* NO break; */
+	default:
+		mutex_lock(&accessfs_sem);
+		dir = dentry->d_inode->i_private;
+		accessfs_readdir_aux(filp, dir, i, dirent, filldir);
+		mutex_unlock(&accessfs_sem);
+		break;
+	}
+
+	return 0;
+}
+
+static struct accessfs_entry *accessfs_lookup_entry(struct accessfs_entry *pe,
+						    const char *name, int len)
+{
+	struct list_head *list;
+	struct accessfs_direntry *dir;
+	struct accessfs_entry *de;
+	if (!S_ISDIR(pe->attr->mode))
+		return NULL;
+
+	dir = (struct accessfs_direntry *) pe;
+	de = NULL;
+	list_for_each(list, &dir->children) {
+		de = list_entry(list, struct accessfs_entry, siblings);
+		if (strncmp(de->name, name, len) == 0 && de->name[len] == 0)
+			break;
+	}
+
+	return de;
+}
+
+static struct dentry *accessfs_lookup(struct inode *dir, struct dentry *dentry,
+				      struct nameidata *nd)
+{
+	struct inode *inode = NULL;
+	struct accessfs_entry *pe;
+	mutex_lock(&accessfs_sem);
+	pe = accessfs_lookup_entry(dir->i_private, dentry->d_name.name,
+				   dentry->d_name.len);
+	mutex_unlock(&accessfs_sem);
+	if (pe)
+		inode = iget(dir->i_sb, pe->ino);
+
+	d_add(dentry, inode);
+	return NULL;
+}
+
+static struct accessfs_direntry	accessfs_rootdir = {
+	{ "/", 
+	  LIST_HEAD_INIT(accessfs_rootdir.node.hash), 
+	  LIST_HEAD_INIT(accessfs_rootdir.node.siblings), 
+	  1, &accessfs_rootdir.attr },
+	NULL, LIST_HEAD_INIT(accessfs_rootdir.children), 
+	{ 0, 0, S_IFDIR | 0755 }
+};
+
+static void accessfs_init_inode(struct inode *inode, struct accessfs_entry *pe)
+{
+	static const struct timespec epoch = {0, 0};
+	inode->i_private = pe;
+	inode->i_uid = pe->attr->uid;
+	inode->i_gid = pe->attr->gid;
+	inode->i_mode = pe->attr->mode;
+/*
+	inode->i_blksize = PAGE_CACHE_SIZE;
+	inode->i_blocks = 0;
+	inode->i_rdev = NODEV;
+*/
+	inode->i_atime = inode->i_mtime = inode->i_ctime = epoch;
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_op = &accessfs_inode_operations;
+		break;
+	case S_IFDIR:
+		inode->i_op = &accessfs_dir_inode_operations;
+		inode->i_fop = &accessfs_dir_file_operations;
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+static struct inode *accessfs_get_root_inode(struct super_block *sb)
+{
+	struct inode *inode = new_inode(sb);
+	if (inode) {
+		mutex_lock(&accessfs_sem);
+/* 		inode->i_ino = accessfs_rootdir.node.ino; */
+		accessfs_init_inode(inode, &accessfs_rootdir.node);
+		accessfs_rootdir.node.ino = inode->i_ino;
+		mutex_unlock(&accessfs_sem);
+	}
+
+	return inode;
+}
+
+static LIST_HEAD(hash);
+
+static int accessfs_node_init(struct accessfs_direntry *parent,
+			      struct accessfs_entry *de, const char *name,
+			      size_t len, struct access_attr *attr, mode_t mode)
+{
+	static unsigned long ino = 1;
+	de->name = kmalloc(len + 1, GFP_KERNEL);
+	if (de->name == NULL)
+		return -ENOMEM;
+
+	strncpy(de->name, name, len);
+	de->name[len] = 0;
+	de->ino = ++ino;
+	de->attr = attr;
+	de->attr->uid = 0;
+	de->attr->gid = 0;
+	de->attr->mode = mode;
+
+	list_add_tail(&de->hash, &hash);
+	list_add_tail(&de->siblings, &parent->children);
+	return 0;
+}
+
+static int accessfs_mknod(struct accessfs_direntry *dir, const char *name,
+			  struct access_attr *attr)
+{
+	struct accessfs_entry *pe;
+	pe = kmalloc(sizeof(struct accessfs_entry), GFP_KERNEL);
+	if (pe == NULL)
+		return -ENOMEM;
+
+	accessfs_node_init(dir, pe, name, strlen(name), attr,
+			   S_IFREG | attr->mode);
+	return 0;
+}
+
+static struct accessfs_direntry	*accessfs_mkdir(struct accessfs_direntry *parent,
+						const char *name, size_t len)
+{
+	int err;
+	struct accessfs_direntry *dir;
+	dir = kmalloc(sizeof(struct accessfs_direntry), GFP_KERNEL);
+	if (dir == NULL)
+		return NULL;
+
+	dir->parent = parent;
+	INIT_LIST_HEAD(&dir->children);
+	err = accessfs_node_init(parent, &dir->node, name, len, &dir->attr,
+				 S_IFDIR | 0755);
+	if (err) {
+		kfree(dir);
+		dir = 0;
+	}
+
+	return dir;
+}
+
+struct accessfs_direntry *accessfs_make_dirpath(const char *name)
+{
+	struct accessfs_direntry *dir = &accessfs_rootdir;
+	const char *slash;
+	mutex_lock(&accessfs_sem);
+	do {
+		struct accessfs_entry *de;
+		size_t len;
+		while (*name == '/')
+			++name;
+
+		slash = strchr(name, '/');
+		len = slash ? slash - name : strlen(name);
+		de = accessfs_lookup_entry(&dir->node, name, len);
+		if (de == NULL) {
+			dir = accessfs_mkdir(dir, name, len);
+		} else if (S_ISDIR(de->attr->mode)) {
+			dir = (struct accessfs_direntry *) de;
+		} else {
+			dir = NULL;
+		}
+
+		if (dir == NULL)
+			break;
+
+		name = slash  + 1;
+	} while (slash != NULL);
+
+	mutex_unlock(&accessfs_sem);
+	return dir;
+}
+
+static void accessfs_unlink(struct accessfs_entry *pe)
+{
+	list_del_init(&pe->hash);
+	list_del_init(&pe->siblings);
+	kfree(pe->name);
+	kfree(pe);
+}
+
+static int accessfs_notify_change(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *i = dentry->d_inode;
+	int err = inode_setattr(i, iattr);
+	if (!err) {
+		struct accessfs_entry *pe;
+		pe = (struct accessfs_entry *) i->i_private;
+		pe->attr->uid = i->i_uid;
+		pe->attr->gid = i->i_gid;
+		pe->attr->mode = i->i_mode;
+	}
+
+	return err;
+}
+
+static void accessfs_read_inode(struct inode *inode)
+{
+	ino_t	ino = inode->i_ino;
+	struct list_head	*list;
+	mutex_lock(&accessfs_sem);
+	list_for_each(list, &hash) {
+		struct accessfs_entry *pe;
+		pe = list_entry(list, struct accessfs_entry, hash);
+		if (pe->ino == ino) {
+			accessfs_init_inode(inode, pe);
+			break;
+		}
+	}
+
+	mutex_unlock(&accessfs_sem);
+}
+
+static struct inode_operations accessfs_inode_operations = {
+	.setattr =	accessfs_notify_change,
+};
+
+static struct inode_operations accessfs_dir_inode_operations = {
+	.lookup =	accessfs_lookup,
+	.setattr =	accessfs_notify_change,
+};
+
+static struct file_operations accessfs_dir_file_operations = {
+	.readdir =	accessfs_readdir,
+};
+
+static struct super_operations accessfs_ops = {
+	.read_inode =	accessfs_read_inode,
+	.statfs =	simple_statfs,
+};
+
+static int accessfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *inode;
+	struct dentry *root;
+
+	sb->s_blocksize = PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	sb->s_magic = ACCESSFS_MAGIC;
+	sb->s_op = &accessfs_ops;
+	inode = accessfs_get_root_inode(sb);
+	if (!inode)
+		return -ENOMEM;
+
+	root = d_alloc_root(inode);
+	if (!root) {
+		iput(inode);
+		return -ENOMEM;
+	}
+
+	sb->s_root = root;
+	return 0;
+}
+
+static int accessfs_get_sb(struct file_system_type *fs_type,
+			   int flags, const char *dev_name,
+			   void *data, struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, accessfs_fill_super, mnt);
+}
+
+int accessfs_permitted(struct access_attr *p, int mask)
+{
+	mode_t mode = p->mode;
+	if (current->fsuid == p->uid)
+		mode >>= 6;
+	else if (in_group_p(p->gid))
+		mode >>= 3;
+
+	return (mode & mask) == mask;
+}
+
+int accessfs_register(struct accessfs_direntry *dir, const char *name,
+		      struct access_attr *attr)
+{
+	int err;
+	if (dir == 0)
+		return -EINVAL;
+
+	mutex_lock(&accessfs_sem);
+	err = accessfs_mknod(dir, name, attr);
+	mutex_unlock(&accessfs_sem);
+	return err;
+}
+
+void accessfs_unregister(struct accessfs_direntry *dir, const char *name)
+{
+	struct accessfs_entry *pe;
+	mutex_lock(&accessfs_sem);
+	pe = accessfs_lookup_entry(&dir->node, name, strlen(name));
+	if (pe) {
+		accessfs_unlink(pe);
+	}
+
+	mutex_unlock(&accessfs_sem);
+}
+
+static struct file_system_type accessfs_fs_type = {
+	.owner =	THIS_MODULE,
+	.name =		"accessfs",
+	.get_sb =	accessfs_get_sb,
+	.kill_sb =	kill_anon_super,
+};
+
+static int __init init_accessfs_fs(void)
+{
+
+	/* create mount point for accessfs */
+	mountdir = proc_mkdir("access",&proc_root);
+	return register_filesystem(&accessfs_fs_type);
+}
+
+static void __exit exit_accessfs_fs(void)
+{
+	unregister_filesystem(&accessfs_fs_type);
+	remove_proc_entry("access",&proc_root);
+}
+
+module_init(init_accessfs_fs)
+module_exit(exit_accessfs_fs)
+
+MODULE_AUTHOR("Olaf Dietsche");
+MODULE_DESCRIPTION("Access Filesystem");
+MODULE_LICENSE("GPL");
+
+EXPORT_SYMBOL(accessfs_permitted);
+EXPORT_SYMBOL(accessfs_make_dirpath);
+EXPORT_SYMBOL(accessfs_register);
+EXPORT_SYMBOL(accessfs_unregister);
diff --git a/fs/accessfs/ip.c b/fs/accessfs/ip.c
new file mode 100644
index 0000000..ef2cf1c
--- /dev/null
+++ b/fs/accessfs/ip.c
@@ -0,0 +1,95 @@
+/* Copyright (c) 2002-2006 Olaf Dietsche
+ *
+ * User permission based port access for Linux.
+ */
+
+#include <linux/accessfs_fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <net/sock.h>
+
+static int max_prot_sock = CONFIG_ACCESSFS_PROT_SOCK;
+static struct access_attr *bind_to_port;
+
+static int accessfs_ip_prot_sock(struct socket *sock,
+				 struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+	unsigned short snum = ntohs(addr->sin_port);
+	if (snum && snum < max_prot_sock
+	    && !accessfs_permitted(&bind_to_port[snum], MAY_EXEC)
+	    && !capable(CAP_NET_BIND_SERVICE))
+		return -EACCES;
+
+	return 0;
+}
+
+static int accessfs_ip6_prot_sock(struct socket *sock,
+				  struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in6 *addr = (struct sockaddr_in6 *) uaddr;
+	unsigned short snum = ntohs(addr->sin6_port);
+	if (snum && snum < max_prot_sock
+	    && !accessfs_permitted(&bind_to_port[snum], MAY_EXEC)
+	    && !capable(CAP_NET_BIND_SERVICE))
+		return -EACCES;
+
+	return 0;
+}
+
+static struct net_hook_operations ip_net_ops = {
+	.ip_prot_sock =	accessfs_ip_prot_sock,
+	.ip6_prot_sock =	accessfs_ip6_prot_sock,
+};
+
+static int __init init_ip(void)
+{
+	struct accessfs_direntry *dir = accessfs_make_dirpath("net/ip/bind");
+	int i;
+
+	if (max_prot_sock < PROT_SOCK)
+		max_prot_sock = PROT_SOCK;
+	else if (max_prot_sock > 65536)
+		max_prot_sock = 65536;
+
+	bind_to_port = kmalloc(max_prot_sock * sizeof(*bind_to_port),
+			       GFP_KERNEL);
+	if (bind_to_port == 0)
+		return -ENOMEM;
+
+	for (i = 1; i < max_prot_sock; ++i) {
+		char	buf[sizeof("65536")];
+		bind_to_port[i].uid = 0;
+		bind_to_port[i].gid = 0;
+		bind_to_port[i].mode = i < PROT_SOCK ? S_IXUSR : S_IXUGO;
+		sprintf(buf, "%d", i);
+		accessfs_register(dir, buf, &bind_to_port[i]);
+	}
+
+	net_hooks_register(&ip_net_ops);
+	return 0;
+}
+
+static void __exit exit_ip(void)
+{
+	struct accessfs_direntry *dir = accessfs_make_dirpath("net/ip/bind");
+	int i;
+	net_hooks_unregister(&ip_net_ops);
+	for (i = 1; i < max_prot_sock; ++i) {
+		char	buf[sizeof("65536")];
+		sprintf(buf, "%d", i);
+		accessfs_unregister(dir, buf);
+	}
+
+	if (bind_to_port != NULL)
+		kfree(bind_to_port);
+}
+
+module_init(init_ip)
+module_exit(exit_ip)
+
+MODULE_AUTHOR("Olaf Dietsche");
+MODULE_DESCRIPTION("User based IP ports permission");
+MODULE_LICENSE("GPL");
+module_param(max_prot_sock, int, 0);
+MODULE_PARM_DESC(max_prot_sock, "Number of protected ports");
diff --git a/include/linux/accessfs_fs.h b/include/linux/accessfs_fs.h
new file mode 100644
index 0000000..ecd914e
--- /dev/null
+++ b/include/linux/accessfs_fs.h
@@ -0,0 +1,42 @@
+/* -*- mode: c -*- */
+#ifndef __accessfs_fs_h_included__
+#define __accessfs_fs_h_included__	1
+
+/* Copyright (c) 2001 Olaf Dietsche
+ *
+ * Access permission filesystem for Linux.
+ */
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <net/sock.h>
+
+struct access_attr {
+	uid_t	uid;
+	gid_t	gid;
+	mode_t	mode;
+};
+
+struct accessfs_entry {
+	char	*name;
+	struct list_head	hash;
+	struct list_head	siblings;
+	ino_t	ino;
+	struct access_attr	*attr;
+};
+
+struct accessfs_direntry {
+	struct accessfs_entry	node;
+	struct accessfs_direntry	*parent;
+	struct list_head	children;
+	struct access_attr	attr;
+};
+
+extern int accessfs_permitted(struct access_attr *p, int mask);
+extern struct accessfs_direntry *accessfs_make_dirpath(const char *name);
+extern int accessfs_register(struct accessfs_direntry *dir, const char *name, struct access_attr *attr);
+extern void accessfs_unregister(struct accessfs_direntry *dir, const char *name);
+
+#endif
diff --git a/include/net/sock.h b/include/net/sock.h
index dfeb8b1..40246ee 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1372,4 +1372,47 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+/* Networking hooks */
+extern int default_ip_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+				int addr_len);
+extern int default_ip6_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+				 int addr_len);
+#ifdef	CONFIG_NET_HOOKS
+struct net_hook_operations {
+	int	(*ip_prot_sock)(struct socket *sock,
+				struct sockaddr *uaddr, int addr_len);
+	int	(*ip6_prot_sock)(struct socket *sock,
+				 struct sockaddr *uaddr, int addr_len);
+};
+
+extern struct net_hook_operations	*net_ops;
+
+extern void net_hooks_register(struct net_hook_operations *ops);
+extern void net_hooks_unregister(struct net_hook_operations *ops);
+
+static inline int ip_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+			       int addr_len)
+{
+	return net_ops->ip_prot_sock(sock, uaddr, addr_len);
+}
+
+static inline int ip6_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+				int addr_len)
+{
+	return net_ops->ip6_prot_sock(sock, uaddr, addr_len);
+}
+#else
+static inline int ip_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+			       int addr_len)
+{
+	return default_ip_prot_sock(sock, uaddr, addr_len);
+}
+
+static inline int ip6_prot_sock(struct socket *sock, struct sockaddr *uaddr,
+				int addr_len)
+{
+	return default_ip6_prot_sock(sock, uaddr, addr_len);
+}
+#endif
+
 #endif	/* _SOCK_H */
diff --git a/net/Kconfig b/net/Kconfig
index cdba08c..50e21e2 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -57,6 +57,18 @@ config INET
 if INET
 source "net/ipv4/Kconfig"
 source "net/ipv6/Kconfig"
+
+config NET_HOOKS
+	bool "IP: Networking hooks (Experimental)"
+	depends on INET && EXPERIMENTAL
+	default n
+	help
+	  This option enables other kernel parts or modules to hook into the
+	  networking area and provide fine grained control over the access to
+	  IP ports.
+
+	  If you're unsure, say N.
+
 source "net/netlabel/Kconfig"
 
 endif # if INET
diff --git a/net/Makefile b/net/Makefile
index bbe7d2a..7ab64cf 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
+obj-$(CONFIG_NET_HOOKS)		+= hooks.o
 
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
diff --git a/net/hooks.c b/net/hooks.c
new file mode 100644
index 0000000..33100e6
--- /dev/null
+++ b/net/hooks.c
@@ -0,0 +1,55 @@
+/* Copyright (c) 2002 Olaf Dietsche
+ *
+ * Networking hooks. Currently for IPv4 and IPv6 only.
+ */
+
+#include <linux/module.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <net/sock.h>
+
+int default_ip_prot_sock(struct socket *sock, struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+	unsigned short snum = ntohs(addr->sin_port);
+	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+		return -EACCES;
+
+	return 0;
+}
+
+int default_ip6_prot_sock(struct socket *sock, struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in6 *addr = (struct sockaddr_in6 *) uaddr;
+	unsigned short snum = ntohs(addr->sin6_port);
+	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+		return -EACCES;
+
+	return 0;
+}
+
+EXPORT_SYMBOL(default_ip_prot_sock);
+EXPORT_SYMBOL(default_ip6_prot_sock);
+
+#ifdef CONFIG_NET_HOOKS
+static struct net_hook_operations default_net_ops = {
+	.ip_prot_sock =	default_ip_prot_sock,
+	.ip6_prot_sock =	default_ip6_prot_sock,
+};
+
+struct net_hook_operations *net_ops = &default_net_ops;
+
+void net_hooks_register(struct net_hook_operations *ops)
+{
+	net_ops = ops;
+}
+
+void net_hooks_unregister(struct net_hook_operations *ops)
+{
+	net_ops = &default_net_ops;
+}
+
+EXPORT_SYMBOL(net_ops);
+EXPORT_SYMBOL(net_hooks_register);
+EXPORT_SYMBOL(net_hooks_unregister);
+#endif
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e681034..f1d1b83 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -457,7 +457,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	snum = ntohs(addr->sin_port);
 	err = -EACCES;
-	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+	if (ip_prot_sock(sock, uaddr, addr_len))
 		goto out;
 
 	/*      We keep a pair of addresses. rcv_saddr is the one
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b5f9637..0c28cc4 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -263,7 +263,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		return -EINVAL;
 
 	snum = ntohs(addr->sin6_port);
-	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+	if (ip6_prot_sock(sock, uaddr, addr_len))
 		return -EACCES;
 
 	lock_sock(sk);
