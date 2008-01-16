Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYAPWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYAPWMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYAPWMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:12:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57783 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYAPWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:12:40 -0500
To: akpm@linux-foundation.org
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: [patch] VFS: extend /proc/mounts
Message-Id: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Jan 2008 23:12:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason, why this patch was dug up, is that if the bdi-sysfs patch
is going to use device numbers to identify BDIs, then there should be
a way for the user to map the device number into mount(s).

But it's useful regardless of the bdi-sysfs patch.

Can this be added to -mm?

In theory it could break userspace, but I think it's very unlikely to
do so, because stuff is added only at the end of the lines, and
because most programs probably parse it through the libc interface
which is not broken by this change.  Despite this, it should be tested
on as many systems as possible.

The alternative (and completely safe) solution is to add another file
to proc.  Me no likey.

Miklos

----
From: Ram Pai <linuxram@us.ibm.com>

/proc/mounts in its current state fail to disambiguate bind mounts, especially
when the bind mount is subrooted. Also it does not capture propagation state of
the mounts(shared-subtree). The following patch addresses the problem.

The following additional fields to /proc/mounts are added.

propagation-type in the form of <propagation_flag>[:<mntid>][,...]
	note: 'shared' flag is followed by the mntid of its peer mount
	      'slave' flag is followed by the mntid of its master mount
	      'private' flag stands by itself
	      'unbindable' flag stands by itself

mntid -- is a unique identifier of the mount
major:minor -- is the major minor number of the device hosting the filesystem
dir -- the subdir in the filesystem which forms the root of this mount
parent -- the id of the parent mount


Here is a sample cat /proc/mounts after execution the following commands:

mount --bind /mnt /mnt
mount --make-shared /mnt
mount --bind /mnt/1 /var
mount --make-slave /var
mount --make-shared /var
mount --bind /var/abc /tmp
mount --make-unbindable /proc

rootfs / rootfs rw 0 0 private 2 0:1 / 2
/dev/root / ext2 rw  0 0 private 16 98:0 / 2
/proc /proc proc rw 0 0 unbindable 17 0:3 / 16
devpts /dev/pts devpts rw 0 0 private 18 0:10 / 16
/dev/root /mnt ext2 rw  0 0 shared:19 19 98:0 /mnt 16
/dev/root /var ext2 rw  0 0 shared:21,slave:19 20 98:0 /mnt/1 16
/dev/root /tmp ext2 rw  0 0 shared:20,slave:19 21 98:0 /mnt/1/abc 16

For example, the last line indicates that :

1) The mount is a shared mount.
2) Its peer mount of mount with id 20
3) It is also a slave mount of the master-mount with the id  19
4) The filesystem on device with major/minor number 98:0 and subdirectory
	mnt/1/abc makes the root directory of this mount.
5) And finally the mount with id 16 is its parent.


Testing: symlinked /etc/mtab to /proc/mounts and did some mount and df
commands. They worked normally.

[mszeredi@suse.cz]:

- for mount ID's use IRA instead of a 32bit counter, which could overflow
- print canonical ID's (smallest one within the peer group) for peers
  and master, this is more useful, than a random ID within the same namespace
- fix a couple of small bugs
- style fixes

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2008-01-09 21:16:28.000000000 +0100
+++ linux/fs/dcache.c	2008-01-16 20:26:56.000000000 +0100
@@ -1890,6 +1890,60 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
+static inline int prepend(char **buffer, int *buflen, const char *str,
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
--- linux.orig/fs/namespace.c	2008-01-16 18:42:01.000000000 +0100
+++ linux/fs/namespace.c	2008-01-16 22:29:19.000000000 +0100
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
+		return -ENOMEM;
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
 
@@ -646,7 +680,23 @@ static int show_vfsmnt(struct seq_file *
 	}
 	if (mnt->mnt_sb->s_op->show_options)
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
-	seq_puts(m, " 0 0\n");
+	seq_puts(m, " 0 0 ");
+	if (IS_MNT_SHARED(mnt)) {
+		seq_printf(m, "shared:%i", get_peer_group_id(mnt));
+		if (IS_MNT_SLAVE(mnt))
+			seq_printf(m, ",slave:%i", get_master_id(mnt));
+	} else if (IS_MNT_SLAVE(mnt)) {
+		seq_printf(m, "slave:%i", get_master_id(mnt));
+	} else if (IS_MNT_UNBINDABLE(mnt)) {
+		seq_printf(m, "unbindable");
+	} else {
+		seq_printf(m, "private");
+	}
+	seq_printf(m, " %i %u:%u ", mnt->mnt_id,
+		   MAJOR(mnt->mnt_sb->s_dev),
+		   MINOR(mnt->mnt_sb->s_dev));
+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
+	seq_printf(m, " %i\n", mnt->mnt_parent->mnt_id);
 	return err;
 }
 
Index: linux/fs/seq_file.c
===================================================================
--- linux.orig/fs/seq_file.c	2008-01-09 21:16:28.000000000 +0100
+++ linux/fs/seq_file.c	2008-01-16 21:59:15.000000000 +0100
@@ -349,28 +349,40 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+static inline char *mangle_path(char *s, char *p, char *esc)
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
--- linux.orig/include/linux/dcache.h	2008-01-09 21:16:29.000000000 +0100
+++ linux/include/linux/dcache.h	2008-01-16 19:00:38.000000000 +0100
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
 
Index: linux/include/linux/seq_file.h
===================================================================
--- linux.orig/include/linux/seq_file.h	2008-01-09 21:16:29.000000000 +0100
+++ linux/include/linux/seq_file.h	2008-01-16 19:03:36.000000000 +0100
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
--- linux.orig/fs/pnode.c	2008-01-16 13:25:17.000000000 +0100
+++ linux/fs/pnode.c	2008-01-16 22:27:33.000000000 +0100
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
--- linux.orig/fs/pnode.h	2008-01-16 18:42:01.000000000 +0100
+++ linux/fs/pnode.h	2008-01-16 22:28:35.000000000 +0100
@@ -35,4 +35,6 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+int get_peer_group_id(struct vfsmount *);
+int get_master_id(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h	2008-01-16 18:42:01.000000000 +0100
+++ linux/include/linux/mount.h	2008-01-16 21:20:04.000000000 +0100
@@ -56,6 +56,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	int mnt_id;			/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
