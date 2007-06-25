Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXFYWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXFYWD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXFYWDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:03:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58378 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXFYWDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:03:14 -0400
Subject: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and
	shared-subtree
From: Ram Pai <linuxram@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <20070625214640.GC29058@ram.us.ibm.com>
References: <467994BD.6000403@zytor.com>
	 <20070620210343.GQ21478@ftp.linux.org.uk> <46799A31.10301@zytor.com>
	 <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com>
	 <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com>
	 <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com>
	 <20070625214640.GC29058@ram.us.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 15:00:15 -0700
Message-Id: <1182808816.2816.7.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please check if the following modified patch meets the requirements.

It augments /proc/mount with additional information to
	(1) disambiguate bind mounts with subroot information.
	(2) display shared-subtree information using which one can
		determine the propagation trees.


The following additional fields are appended to each record
in /proc/mounts

mntid=id    ->  The unique id associated with that mount.
fsid=id:dir ->  The filesystem's id and directory in that filesystem
that
		makes the root directory of this mount.
parent=id   ->  The id of the mount's parent; on which it is mounted.

also flags are augmented with new information to indicate the mount's 
propagation type.

Here is a sample 'cat /proc/mounts' after executing the following
commands:
mount --bind /mnt /mnt
mount --make-shared /mnt
mount --bind /mnt/1 /var
mount --make-slave /var
mount --make-shared /mnt
mount --make-unbindable /proc

rootfs / rootfs rw PRIVATE mntid=c1708c30 fsid=1:/ parent=c1708c30 0 0
/dev/root / ext2 rw  PRIVATE mntid=c1208c08 fsid=6200:/ parent=c1708c30
0 0
/proc /proc proc rw UNBINDABLE mntid=c1108c90 fsid=3:/ parent=c1208c08 0
0
devpts /dev/pts devpts rw PRIVATE mntid=c1108c18 fsid=a:/
parent=c1208c08 0 0
/dev/root /mnt ext2 rw  SHARED:peer=c1e08cb0 mntid=c1e08cb0
fsid=6200:/mnt parent=c1208c08 0 0
/dev/root /var ext2 rw  SHARED:peer=c1f08c28 SLAVE:master=c1e08cb0
mntid=c1f08c28 fsid=6200:/mnt/1 parent=c1208c08 0 0


For example, the last line indicates that 
The mount is a shared mount.
Its peer mount is itself (note peer=c1f08c28 is the same mntid as
itself).
It is also a slave mount of the mount with the id c1e08cb0.  
The filesystem with fsid=6200 and subdirectory mnt/1 makes the root
directory 
	of this mount.
And finally the mount with id c1208c08 is its parent.


Signed-off-by: Ram Pai <linuxram@us.ibm.com>

---
 fs/dcache.c              |   53 +++++++++++++++++++++++++++++++
 fs/namespace.c           |   25 ++++++++++++++
 fs/pnode.c               |   22 +++++++++++++
 fs/pnode.h               |    2 +
 fs/seq_file.c            |   79
++++++++++++++++++++++++++++++++++-------------
 include/linux/dcache.h   |    2 +
 include/linux/seq_file.h |    1 
 7 files changed, 162 insertions(+), 22 deletions(-)

Index: linux-2.6.21.5/fs/dcache.c
===================================================================
--- linux-2.6.21.5.orig/fs/dcache.c
+++ linux-2.6.21.5/fs/dcache.c
@@ -1835,6 +1835,59 @@ char * d_path(struct dentry *dentry, str
 	return res;
 }

+static inline int prepend(char **buffer, int *buflen, const char *str,
+					int namelen)
+{
+	if ((*buflen -= namelen) < 0)
+		return 1;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
+/*
+ * write full pathname into buffer and return start of pathname.
+ * If @vfsmnt is not specified return the path relative to the
+ * its filesystem's root.
+ */
+char * dentry_path(struct dentry *dentry, char *buf, int buflen)
+{
+	char * end = buf+buflen;
+	char * retval;
+
+	spin_lock(&dcache_lock);
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
+		if (prepend(&end, &buflen, "//deleted", 10))
+			goto Elong;
+	}
+	/* Get '/' right */
+	retval = end-1;
+	*retval = '/';
+
+	for (;;) {
+		struct dentry * parent;
+		if (IS_ROOT(dentry))
+			break;
+
+		parent = dentry->d_parent;
+		prefetch(parent);
+
+		if (prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) ||
+	            prepend(&end, &buflen, "/", 1))
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
Index: linux-2.6.21.5/fs/namespace.c
===================================================================
--- linux-2.6.21.5.orig/fs/namespace.c
+++ linux-2.6.21.5/fs/namespace.c
@@ -386,8 +386,31 @@ static int show_vfsmnt(struct seq_file *
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
-	if (mnt->mnt_sb->s_op->show_options)
+	seq_putc(m, ' ');
+	if (mnt->mnt_sb->s_op->show_options) {
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
+		seq_putc(m, ' ');
+	}
+	if (IS_MNT_SHARED(mnt)) {
+		seq_printf(m, "%s:peer=%x ", "SHARED",
+				new_encode_dev((int)get_peer_same_ns(mnt)));
+		if (IS_MNT_SLAVE(mnt)) {
+			seq_printf(m, "%s:master=%x ", "SLAVE",
+				new_encode_dev((int)get_master_same_ns(mnt)));
+		}
+	} else if (IS_MNT_SLAVE(mnt)) {
+		seq_printf(m, "%s:master=%x ", "SLAVE",
+			new_encode_dev((int)get_master_same_ns(mnt)));
+	} else if (IS_MNT_UNBINDABLE(mnt)) {
+		seq_printf(m, "%s ", "UNBINDABLE");
+	} else {
+		seq_printf(m, "%s ", "PRIVATE");
+	}
+	seq_printf(m, "mntid=%x fsid=%x:", new_encode_dev((int)mnt),
+				new_encode_dev((int)mnt->mnt_sb->s_dev));
+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
+	seq_putc(m, ' ');
+	seq_printf(m, "parent=%x", new_encode_dev((int)mnt->mnt_parent));
 	seq_puts(m, " 0 0\n");
 	return err;
 }
Index: linux-2.6.21.5/fs/seq_file.c
===================================================================
--- linux-2.6.21.5.orig/fs/seq_file.c
+++ linux-2.6.21.5/fs/seq_file.c
@@ -338,38 +338,75 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);

-int seq_path(struct seq_file *m,
-	     struct vfsmount *mnt, struct dentry *dentry,
-	     char *esc)
+static inline char *mangle_path(char *s, char *p, char *esc)
 {
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
+int seq_path(struct seq_file *m, struct vfsmount *mnt, struct dentry
*dentry,
+ 	     char *esc)
+{
+	char *p = NULL;
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(dentry, mnt, s, m->size - m->count);
+		p = d_path(dentry, mnt, s, m->size - m->count);
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
 	m->count = m->size;
-	return -1;
+	return p == ERR_PTR(-ENAMETOOLONG) ? 0 : -1;
 }
+
 EXPORT_SYMBOL(seq_path);

+/*
+ * returns the path of the 'dentry' from the root of its filesystem.
+ */
+int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
+{
+	char *p = NULL;
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		p = dentry_path(dentry, s, m->size - m->count);
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
+	return p == ERR_PTR(-ENAMETOOLONG) ? 0 : -1;
+}
+
+EXPORT_SYMBOL(seq_dentry);
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
Index: linux-2.6.21.5/include/linux/dcache.h
===================================================================
--- linux-2.6.21.5.orig/include/linux/dcache.h
+++ linux-2.6.21.5/include/linux/dcache.h
@@ -294,6 +294,8 @@ extern struct dentry * d_hash_and_lookup
 extern int d_validate(struct dentry *, struct dentry *);

 extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
+extern char * dentry_path(struct dentry *, char *, int);
+
   
 /* Allocation counts.. */

Index: linux-2.6.21.5/include/linux/seq_file.h
===================================================================
--- linux-2.6.21.5.orig/include/linux/seq_file.h
+++ linux-2.6.21.5/include/linux/seq_file.h
@@ -43,6 +43,7 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));

 int seq_path(struct seq_file *, struct vfsmount *, struct dentry *,
char *);
+int seq_dentry(struct seq_file *, struct dentry *, char *);

 int single_open(struct file *, int (*)(struct seq_file *, void *), void
*);
 int single_release(struct inode *, struct file *);
Index: linux-2.6.21.5/fs/pnode.c
===================================================================
--- linux-2.6.21.5.orig/fs/pnode.c
+++ linux-2.6.21.5/fs/pnode.c
@@ -27,6 +27,28 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }

+/* return a peer in the same namespace */
+struct vfsmount *get_peer_same_ns(struct vfsmount *mnt)
+{
+	struct vfsmount *m = mnt;
+	do {
+		m = next_peer(m);
+	} while (mnt->mnt_ns != m->mnt_ns);
+	return m;
+}
+
+/* return a peer in the same namespace */
+struct vfsmount *get_master_same_ns(struct vfsmount *mnt)
+{
+	struct vfsmount *m = mnt->mnt_master;
+	struct vfsmount *tmp = m;
+	if (!m) return m;
+	do {
+		m = next_peer(m);
+	} while (tmp != m && mnt->mnt_ns != m->mnt_ns);
+	return m;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
Index: linux-2.6.21.5/fs/pnode.h
===================================================================
--- linux-2.6.21.5.orig/fs/pnode.h
+++ linux-2.6.21.5/fs/pnode.h
@@ -34,4 +34,6 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+struct vfsmount *get_master_same_ns(struct vfsmount *);
+struct vfsmount *get_peer_same_ns(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */


