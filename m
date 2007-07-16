Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXGPSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXGPSu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXGPSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:50:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33257 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXGPSuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:50:11 -0400
Subject: [RFC2 PATCH 1/1] VFS: Augment /proc/mount with subroot and
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
Date: Mon, 16 Jul 2007 11:46:48 -0700
Message-Id: <1184611609.2815.12.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


Testing: symlinked /etc/mtab to /proc/mounts and did some mount and df commands. They worked normally.



Signed-off-by: Ram Pai <linuxram@us.ibm.com>

---
 fs/dcache.c              |   53 +++++++++++++++++++++++++++++++
 fs/namespace.c           |   35 +++++++++++++++++++-
 fs/pnode.c               |   22 +++++++++++++
 fs/pnode.h               |    2 +
 fs/seq_file.c            |   79 ++++++++++++++++++++++++++++++++++-------------
 include/linux/dcache.h   |    2 +
 include/linux/mount.h    |    1 
 include/linux/seq_file.h |    1 
 8 files changed, 172 insertions(+), 23 deletions(-)

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
@@ -33,6 +33,8 @@
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 
 static int event;
+static atomic_t mnt_counter;
+
 
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
@@ -51,6 +53,7 @@ static inline unsigned long hash(struct 
 	return tmp & hash_mask;
 }
 
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -64,6 +67,7 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+		mnt->mnt_id = atomic_inc_return(&mnt_counter);
 		if (name) {
 			int size = strlen(name) + 1;
 			char *newname = kmalloc(size, GFP_KERNEL);
@@ -386,9 +390,35 @@ static int show_vfsmnt(struct seq_file *
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
-	if (mnt->mnt_sb->s_op->show_options)
+	seq_putc(m, ' ');
+	if (mnt->mnt_sb->s_op->show_options) {
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
-	seq_puts(m, " 0 0\n");
+		seq_putc(m, ' ');
+	}
+	seq_puts(m, "0 0 ");
+	if (IS_MNT_SHARED(mnt)) {
+		seq_printf(m, "shared:%lu",
+				get_peer_same_ns(mnt)->mnt_id);
+		if (IS_MNT_SLAVE(mnt)) {
+			seq_printf(m, ",slave:%lu ",
+				get_master_same_ns(mnt)->mnt_id);
+		} else {
+			seq_putc(m, ' ');
+		}
+	} else if (IS_MNT_SLAVE(mnt)) {
+		seq_printf(m, "slave:%lu ",
+			get_master_same_ns(mnt)->mnt_id);
+	} else if (IS_MNT_UNBINDABLE(mnt)) {
+		seq_printf(m, "unbindable ");
+	} else {
+		seq_printf(m, "private ");
+	}
+	seq_printf(m, "%lu %u:%u ", mnt->mnt_id,
+				MAJOR(mnt->mnt_sb->s_dev),
+				MINOR(mnt->mnt_sb->s_dev));
+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
+	seq_putc(m, ' ');
+	seq_printf(m, "%lu \n", mnt->mnt_parent->mnt_id);
 	return err;
 }
 
@@ -1822,6 +1852,7 @@ void __init mnt_init(unsigned long mempa
 	if (!mount_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
+	atomic_set(&mnt_counter, 0);
 	/*
 	 * Find the power-of-two list-heads that can fit into the allocation..
 	 * We don't guarantee that "sizeof(struct list_head)" is necessarily
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
+int seq_path(struct seq_file *m, struct vfsmount *mnt, struct dentry *dentry,
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
 
 int seq_path(struct seq_file *, struct vfsmount *, struct dentry *, char *);
+int seq_dentry(struct seq_file *, struct dentry *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
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
Index: linux-2.6.21.5/include/linux/mount.h
===================================================================
--- linux-2.6.21.5.orig/include/linux/mount.h
+++ linux-2.6.21.5/include/linux/mount.h
@@ -53,6 +53,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	unsigned long   mnt_id;		/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line


