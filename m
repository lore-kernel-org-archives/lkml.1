Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbYA2N5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbYA2N5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbYA2N5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:57:38 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39381 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbYA2N5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:57:36 -0500
To: akpm@linux-foundation.org
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, a.p.zijlstra@chello.nl
Subject: [patch] vfs: create /proc/<pid>/mountinfo
Message-Id: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jan 2008 14:57:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

/proc/mounts in its current state fails to disambiguate bind mounts,
especially when the bind mount is subrooted.  Also it does not capture
propagation state of the mounts(shared-subtree).  The following patch
addresses the problem.

The patch adds '/proc/<pid>/mountinfo' which contains a superset of
information in '/proc/<pid>/mounts'. The following fields are added:

mntid -- is a unique identifier of the mount
parent -- the id of the parent mount
major:minor -- value of st_dev for files on that filesystem
dir -- the subdir in the filesystem which forms the root of this mount
propagation-type in the form of <propagation_flag>[:<mntid>][,...]
	note: 'shared' flag is followed by the mntid of its peer mount
	      'slave' flag is followed by the mntid of its master mount
	      'private' flag stands by itself
	      'unbindable' flag stands by itself

Also mount options are split into two fileds, the first containing the
per mount flags, the second the per super block options.

Here is a sample cat /proc/mounts after execution the following commands:

mount --bind /mnt /mnt
mount --make-shared /mnt
mount --bind /mnt/1 /var
mount --make-slave /var
mount --make-shared /var
mount --bind /var/abc /tmp
mount --make-unbindable /proc

2 2 0:1 rootfs rootfs / / rw rw private
16 2 98:0 ext2 /dev/root / / rw rw private
17 16 0:3 proc /proc / /proc rw rw unbindable
18 16 0:10 devpts devpts /dev/pts / rw rw private
19 16 98:0 ext2 /dev/root /mnt /mnt rw rw shared:19
20 16 98:0 ext2 /dev/root /mnt/1 /var rw rw shared:21,slave:19
21 16 98:0 ext2 /dev/root /mnt/1/abc /tmp rw rw shared:20,slave:19

For example, the last line indicates that :

1) The mount is a shared mount.
2) Its peer mount of mount with id 20
3) It is also a slave mount of the master-mount with the id  19
4) The filesystem on device with major/minor number 98:0 and subdirectory
	mnt/1/abc makes the root directory of this mount.
5) And finally the mount with id 16 is its parent.


[mszeredi@suse.cz]

- new file, rearrange fields
- for mount ID's use IDA (from the IDR library) instead of a 32bit
  counter, which could overflow
- print canonical ID's (smallest one within the peer group) for peers
  and master, this is more useful, than a random ID within the same namespace
- fix a couple of small bugs
- remove inlines
- style fixes

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/dcache.c	2008-01-28 14:54:50.000000000 +0100
@@ -1890,6 +1890,60 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return 1;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
+/*
+ * Write full pathname from the root of the filesystem into the buffer.
+ */
+char *dentry_path(struct dentry *dentry, char *buf, int buflen)
+{
+	char *end = buf + buflen;
+	char *retval;
+
+	spin_lock(&dcache_lock);
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
+		if (prepend(&end, &buflen, "//deleted", 9))
+			goto Elong;
+	}
+	if (buflen < 1)
+		goto Elong;
+	/* Get '/' right */
+	retval = end-1;
+	*retval = '/';
+
+	for (;;) {
+		struct dentry *parent;
+		if (IS_ROOT(dentry))
+			break;
+
+		parent = dentry->d_parent;
+		prefetch(parent);
+
+		if (prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) ||
+		    prepend(&end, &buflen, "/", 1))
+			goto Elong;
+
+		retval = end;
+		dentry = parent;
+	}
+	spin_unlock(&dcache_lock);
+	return retval;
+Elong:
+	spin_unlock(&dcache_lock);
+	return ERR_PTR(-ENAMETOOLONG);
+}
+
 /*
  * NOTE! The user-level library version returns a
  * character pointer. The kernel system call just
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/namespace.c	2008-01-28 14:54:50.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/ramfs.h>
 #include <linux/log2.h>
+#include <linux/idr.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -39,6 +40,7 @@
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 
 static int event;
+static DEFINE_IDA(mnt_id_ida);
 
 static struct list_head *mount_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
@@ -58,10 +60,41 @@ static inline unsigned long hash(struct 
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
+static int mnt_alloc_id(struct vfsmount *mnt)
+{
+	int res;
+
+ retry:
+	spin_lock(&vfsmount_lock);
+	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_id_ida, GFP_KERNEL))
+			goto retry;
+		res = -ENOMEM;
+	}
+	return res;
+}
+
+static void mnt_free_id(struct vfsmount *mnt)
+{
+	spin_lock(&vfsmount_lock);
+	ida_remove(&mnt_id_ida, mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
+		int err;
+
+		err = mnt_alloc_id(mnt);
+		if (err) {
+			kmem_cache_free(mnt_cache, mnt);
+			return NULL;
+		}
+
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -338,6 +371,7 @@ EXPORT_SYMBOL(simple_set_mnt);
 void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
+	mnt_free_id(mnt);
 	kmem_cache_free(mnt_cache, mnt);
 }
 
@@ -640,20 +674,30 @@ static void m_stop(struct seq_file *m, v
 	up_read(&namespace_sem);
 }
 
-static int show_vfsmnt(struct seq_file *m, void *v)
+struct proc_fs_info {
+	int flag;
+	const char *str;
+};
+
+static void show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
-	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
-	int err = 0;
-	static struct proc_fs_info {
-		int flag;
-		char *str;
-	} fs_info[] = {
+	static const struct proc_fs_info fs_info[] = {
 		{ MS_SYNCHRONOUS, ",sync" },
 		{ MS_DIRSYNC, ",dirsync" },
 		{ MS_MANDLOCK, ",mand" },
 		{ 0, NULL }
 	};
-	static struct proc_fs_info mnt_info[] = {
+	const struct proc_fs_info *fs_infop;
+
+	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+		if (sb->s_flags & fs_infop->flag)
+			seq_puts(m, fs_infop->str);
+	}
+}
+
+static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
+{
+	static const struct proc_fs_info mnt_info[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -662,40 +706,96 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
-	struct proc_fs_info *fs_infop;
+	const struct proc_fs_info *fs_infop;
+
+	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
+		if (mnt->mnt_flags & fs_infop->flag)
+			seq_puts(m, fs_infop->str);
+	}
+}
+
+static void show_type(struct seq_file *m, struct super_block *sb)
+{
+	mangle(m, sb->s_type->name);
+	if (sb->s_subtype && sb->s_subtype[0]) {
+		seq_putc(m, '.');
+		mangle(m, sb->s_subtype);
+	}
+}
+
+static int show_vfsmnt(struct seq_file *m, void *v)
+{
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	int err = 0;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
 	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
-	mangle(m, mnt->mnt_sb->s_type->name);
-	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
-		seq_putc(m, '.');
-		mangle(m, mnt->mnt_sb->s_subtype);
-	}
+	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
-		if (mnt->mnt_sb->s_flags & fs_infop->flag)
-			seq_puts(m, fs_infop->str);
-	}
-	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
-		if (mnt->mnt_flags & fs_infop->flag)
-			seq_puts(m, fs_infop->str);
-	}
+	show_sb_opts(m, mnt->mnt_sb);
+	show_mnt_opts(m, mnt);
 	if (mnt->mnt_sb->s_op->show_options)
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
 	seq_puts(m, " 0 0\n");
 	return err;
 }
 
-struct seq_operations mounts_op = {
+const struct seq_operations mounts_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
 	.show	= show_vfsmnt
 };
 
+static int show_mountinfo(struct seq_file *m, void *v)
+{
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	struct super_block *sb = mnt->mnt_sb;
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
+	int err = 0;
+
+	seq_printf(m, "%i %i %u:%u ", mnt->mnt_id, mnt->mnt_parent->mnt_id,
+		   MAJOR(sb->s_dev), MINOR(sb->s_dev));
+	show_type(m, sb);
+	seq_putc(m, ' ');
+	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
+	seq_putc(m, ' ');
+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
+	seq_putc(m, ' ');
+	seq_path(m, &mnt_path, " \t\n\\");
+	seq_putc(m, ' ');
+	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? "ro" : "rw");
+	show_mnt_opts(m, mnt);
+	seq_putc(m, ' ');
+	seq_puts(m, sb->s_flags & MS_RDONLY ? "ro" : "rw");
+	show_sb_opts(m, sb);
+	if (sb->s_op->show_options)
+		err = sb->s_op->show_options(m, mnt);
+	if (IS_MNT_SHARED(mnt)) {
+		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
+		if (IS_MNT_SLAVE(mnt))
+			seq_printf(m, ",slave:%i", get_master_id(mnt));
+	} else if (IS_MNT_SLAVE(mnt)) {
+		seq_printf(m, " slave:%i", get_master_id(mnt));
+	} else if (IS_MNT_UNBINDABLE(mnt)) {
+		seq_printf(m, " unbindable");
+	} else {
+		seq_printf(m, " private");
+	}
+	seq_putc(m, '\n');
+	return err;
+}
+
+const struct seq_operations mountinfo_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_mountinfo,
+};
+
 static int show_vfsstat(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
@@ -716,7 +816,7 @@ static int show_vfsstat(struct seq_file 
 
 	/* file system type */
 	seq_puts(m, "with fstype ");
-	mangle(m, mnt->mnt_sb->s_type->name);
+	show_type(m, mnt->mnt_sb);
 
 	/* optional statistics */
 	if (mnt->mnt_sb->s_op->show_stats) {
@@ -728,7 +828,7 @@ static int show_vfsstat(struct seq_file 
 	return err;
 }
 
-struct seq_operations mountstats_op = {
+const struct seq_operations mountstats_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
Index: linux/fs/seq_file.c
===================================================================
--- linux.orig/fs/seq_file.c	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/seq_file.c	2008-01-28 14:54:50.000000000 +0100
@@ -349,28 +349,40 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+static char *mangle_path(char *s, char *p, char *esc)
+{
+	while (s <= p) {
+		char c = *p++;
+		if (!c) {
+			return s;
+		} else if (!strchr(esc, c)) {
+			*s++ = c;
+		} else if (s + 4 > p) {
+			break;
+		} else {
+			*s++ = '\\';
+			*s++ = '0' + ((c & 0300) >> 6);
+			*s++ = '0' + ((c & 070) >> 3);
+			*s++ = '0' + (c & 07);
+		}
+	}
+	return NULL;
+}
+
+/*
+ * return the absolute path of 'dentry' residing in mount 'mnt'.
+ */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
 		char *p = d_path(path, s, m->size - m->count);
 		if (!IS_ERR(p)) {
-			while (s <= p) {
-				char c = *p++;
-				if (!c) {
-					p = m->buf + m->count;
-					m->count = s - m->buf;
-					return s - p;
-				} else if (!strchr(esc, c)) {
-					*s++ = c;
-				} else if (s + 4 > p) {
-					break;
-				} else {
-					*s++ = '\\';
-					*s++ = '0' + ((c & 0300) >> 6);
-					*s++ = '0' + ((c & 070) >> 3);
-					*s++ = '0' + (c & 07);
-				}
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
 			}
 		}
 	}
@@ -379,6 +391,28 @@ int seq_path(struct seq_file *m, struct 
 }
 EXPORT_SYMBOL(seq_path);
 
+/*
+ * returns the path of the 'dentry' from the root of its filesystem.
+ */
+int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
+{
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p = dentry_path(dentry, s, m->size - m->count);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
+			}
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_dentry);
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
Index: linux/include/linux/dcache.h
===================================================================
--- linux.orig/include/linux/dcache.h	2008-01-28 14:54:19.000000000 +0100
+++ linux/include/linux/dcache.h	2008-01-28 14:54:50.000000000 +0100
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
 
Index: linux/include/linux/seq_file.h
===================================================================
--- linux.orig/include/linux/seq_file.h	2008-01-28 14:54:19.000000000 +0100
+++ linux/include/linux/seq_file.h	2008-01-28 14:54:50.000000000 +0100
@@ -10,6 +10,7 @@ struct seq_operations;
 struct file;
 struct path;
 struct inode;
+struct dentry;
 
 struct seq_file {
 	char *buf;
@@ -43,6 +44,7 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+int seq_dentry(struct seq_file *, struct dentry *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/pnode.c	2008-01-28 14:54:50.000000000 +0100
@@ -27,6 +27,41 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
+static int __peer_group_id(struct vfsmount *mnt)
+{
+	struct vfsmount *m;
+	int id = mnt->mnt_id;
+
+	for (m = next_peer(mnt); m != mnt; m = next_peer(m))
+		id = min(id, m->mnt_id);
+
+	return id;
+}
+
+/* return the smallest ID within the peer group */
+int get_peer_group_id(struct vfsmount *mnt)
+{
+	int id;
+
+	spin_lock(&vfsmount_lock);
+	id = __peer_group_id(mnt);
+	spin_unlock(&vfsmount_lock);
+
+	return id;
+}
+
+/* return the smallest ID within the master's peer group */
+int get_master_id(struct vfsmount *mnt)
+{
+	int id;
+
+	spin_lock(&vfsmount_lock);
+	id = __peer_group_id(mnt->mnt_master);
+	spin_unlock(&vfsmount_lock);
+
+	return id;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/pnode.h	2008-01-28 14:54:50.000000000 +0100
@@ -35,4 +35,6 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+int get_peer_group_id(struct vfsmount *);
+int get_master_id(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h	2008-01-28 14:54:19.000000000 +0100
+++ linux/include/linux/mount.h	2008-01-28 14:54:50.000000000 +0100
@@ -56,6 +56,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	int mnt_id;			/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
Index: linux/fs/proc/base.c
===================================================================
--- linux.orig/fs/proc/base.c	2008-01-28 14:54:19.000000000 +0100
+++ linux/fs/proc/base.c	2008-01-28 14:54:50.000000000 +0100
@@ -435,13 +435,13 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-extern struct seq_operations mounts_op;
 struct proc_mounts {
 	struct seq_file m;
 	int event;
 };
 
-static int mounts_open(struct inode *inode, struct file *file)
+static int mounts_open_common(struct inode *inode, struct file *file,
+			      const struct seq_operations *op)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
@@ -467,7 +467,7 @@ static int mounts_open(struct inode *ino
 		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
 		if (p) {
 			file->private_data = &p->m;
-			ret = seq_open(file, &mounts_op);
+			ret = seq_open(file, op);
 			if (!ret) {
 				p->m.private = ns;
 				p->event = ns->event;
@@ -506,6 +506,11 @@ static unsigned mounts_poll(struct file 
 	return res;
 }
 
+static int mounts_open(struct inode *inode, struct file *file)
+{
+	return mounts_open_common(inode, file, &mounts_op);
+}
+
 static const struct file_operations proc_mounts_operations = {
 	.open		= mounts_open,
 	.read		= seq_read,
@@ -514,38 +519,22 @@ static const struct file_operations proc
 	.poll		= mounts_poll,
 };
 
-extern struct seq_operations mountstats_op;
-static int mountstats_open(struct inode *inode, struct file *file)
+static int mountinfo_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &mountstats_op);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct nsproxy *nsp;
-		struct mnt_namespace *mnt_ns = NULL;
-		struct task_struct *task = get_proc_task(inode);
-
-		if (task) {
-			rcu_read_lock();
-			nsp = task_nsproxy(task);
-			if (nsp) {
-				mnt_ns = nsp->mnt_ns;
-				if (mnt_ns)
-					get_mnt_ns(mnt_ns);
-			}
-			rcu_read_unlock();
+	return mounts_open_common(inode, file, &mountinfo_op);
+}
 
-			put_task_struct(task);
-		}
+static const struct file_operations proc_mountinfo_operations = {
+	.open		= mountinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= mounts_release,
+	.poll		= mounts_poll,
+};
 
-		if (mnt_ns)
-			m->private = mnt_ns;
-		else {
-			seq_release(inode, file);
-			ret = -EINVAL;
-		}
-	}
-	return ret;
+static int mountstats_open(struct inode *inode, struct file *file)
+{
+	return mounts_open_common(inode, file, &mountstats_op);
 }
 
 static const struct file_operations proc_mountstats_operations = {
@@ -2220,6 +2209,7 @@ static const struct pid_entry tgid_base_
 	LNK("root",       root),
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
+	REG("mountinfo",  S_IRUGO, mountinfo),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
@@ -2548,6 +2538,7 @@ static const struct pid_entry tid_base_s
 	LNK("root",      root),
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
+	REG("mountinfo",  S_IRUGO, mountinfo),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
Index: linux/include/linux/mnt_namespace.h
===================================================================
--- linux.orig/include/linux/mnt_namespace.h	2008-01-28 14:54:19.000000000 +0100
+++ linux/include/linux/mnt_namespace.h	2008-01-28 14:54:50.000000000 +0100
@@ -37,5 +37,9 @@ static inline void get_mnt_ns(struct mnt
 	atomic_inc(&ns->count);
 }
 
+extern const struct seq_operations mounts_op;
+extern const struct seq_operations mountinfo_op;
+extern const struct seq_operations mountstats_op;
+
 #endif
 #endif
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2008-01-28 14:54:19.000000000 +0100
+++ linux/Documentation/filesystems/proc.txt	2008-01-28 14:54:50.000000000 +0100
@@ -43,6 +43,7 @@ Table of Contents
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
   2.14	/proc/<pid>/io - Display the IO accounting fields
   2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
+  2.16	/proc/<pid>/mountinfo - Information about mounts
 
 ------------------------------------------------------------------------------
 Preface
@@ -2267,4 +2268,39 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
+2.16	/proc/<pid>/mountinfo - Information about mounts
+--------------------------------------------------------
+
+This file contains lines of the form:
+
+MNTID PARENT MAJOR:MINOR TYPE SOURCE ROOT MOUNTPOINT MNTOPTS SBOPTS PROPAGATION
+
+MNTID: unique identifier of the mount (may be reused after umount)
+PARENT: ID of parent (or of self for the top of the mount tree)
+MAJOR:MINOR: value of st_dev for files on filesystem
+TYPE: filesystem type
+SOURCE: source of mount (name of the device for block filesystems)
+ROOT: root of the mount within the filesystem
+MOUNTPOINT: mount point
+MNTOPTS: per mount options
+SBOPTS: per super block options
+PROPAGATION: propagation type
+
+propagation type: <propagation_flag>[:<mntid>][,...]
+	note: 'shared' flag is followed by the mntid of its peer mount
+	      'slave' flag is followed by the mntid of its master mount
+	      'private' flag stands by itself
+	      'unbindable' flag stands by itself
+
+The 'mntid' used in the propagation type is a canonical ID of the peer
+group (currently the smallest ID within the group is used for this
+purpose, but this should not be relied on).  Since mounts can be added
+or removed from the peer group, this ID only guaranteed to stay the
+same on a static propagation tree.
+
+For more information see:
+
+  Documentation/filesystems/sharedsubtree.txt
+
+
 ------------------------------------------------------------------------------
