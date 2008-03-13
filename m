Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYCMV3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYCMV3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYCMV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:27:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51626 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYCMV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:52 -0400
Message-Id: <20080313212738.474842471@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:46 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 5/6] vfs: optimization to /proc/<pid>/mountinfo patch
Content-Disposition: inline; filename=mountinfo_ifdefs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

1) reports deleted inode in dentry_path() consistent with that in __d_path()
2) modified __d_path() to use prepend(), reducing the size of __d_path()
3) moved all the functionality that reports mount information in /proc under
	CONFIG_PROC_FS.

Code compile tested only with and without CONFIG_PROC_FS.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c              |   63 ++++++++++++++++++++---------------------------
 fs/namespace.c           |    4 ++
 fs/pnode.c               |   10 ++++---
 fs/pnode.h               |    4 ++
 fs/seq_file.c            |    3 +-
 include/linux/dcache.h   |    3 ++
 include/linux/seq_file.h |    3 ++
 7 files changed, 47 insertions(+), 43 deletions(-)

Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2008-03-13 20:45:15.000000000 +0100
+++ linux/fs/dcache.c	2008-03-13 20:45:52.000000000 +0100
@@ -1747,6 +1747,17 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
 /**
  * d_path - return the path of a dentry
  * @dentry: dentry to report
@@ -1768,17 +1779,11 @@ static char *__d_path(struct dentry *den
 {
 	char * end = buffer+buflen;
 	char * retval;
-	int namelen;
 
-	*--end = '\0';
-	buflen--;
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
-	}
 
 	if (buflen < 1)
 		goto Elong;
@@ -1805,13 +1810,10 @@ static char *__d_path(struct dentry *den
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
 		retval = end;
 		dentry = parent;
 	}
@@ -1819,12 +1821,10 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
-	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
+	retval += 1;	/* hit the slash */
+	if (prepend(&retval, &buflen, dentry->d_name.name,
+		    dentry->d_name.len) != 0)
 		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1890,17 +1890,8 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
-static int prepend(char **buffer, int *buflen, const char *str,
-			  int namelen)
-{
-	*buflen -= namelen;
-	if (*buflen < 0)
-		return 1;
-	*buffer -= namelen;
-	memcpy(*buffer, str, namelen);
-	return 0;
-}
 
+#ifdef CONFIG_PROC_FS
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
@@ -1911,10 +1902,9 @@ char *dentry_path(struct dentry *dentry,
 
 	spin_lock(&dcache_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		if (prepend(&end, &buflen, "//deleted", 9))
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-	}
 	if (buflen < 1)
 		goto Elong;
 	/* Get '/' right */
@@ -1929,9 +1919,9 @@ char *dentry_path(struct dentry *dentry,
 		parent = dentry->d_parent;
 		prefetch(parent);
 
-		if (prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) ||
-		    prepend(&end, &buflen, "/", 1))
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 
 		retval = end;
@@ -1943,6 +1933,7 @@ Elong:
 	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
+#endif /* CONFIG_PROC_FS */
 
 /*
  * NOTE! The user-level library version returns a
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-13 20:45:51.000000000 +0100
+++ linux/fs/namespace.c	2008-03-13 20:45:52.000000000 +0100
@@ -679,6 +679,7 @@ void save_mount_options(struct super_blo
 }
 EXPORT_SYMBOL(save_mount_options);
 
+#ifdef CONFIG_PROC_FS
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
@@ -808,7 +809,7 @@ static int show_mountinfo(struct seq_fil
 			if (IS_MNT_SHARED(mnt))
 				seq_putc(m, ',');
 
-			seq_printf(m, "slave:%i", get_master_id(mnt));
+			seq_printf(m, "slave:%i", get_master_group_id(mnt));
 			if (dominator_id != -1)
 				seq_printf(m, ":%i", dominator_id);
 		}
@@ -866,6 +867,7 @@ const struct seq_operations mountstats_o
 	.stop	= m_stop,
 	.show	= show_vfsstat,
 };
+#endif  /* CONFIG_PROC_FS */
 
 /**
  * may_umount_tree - check if a mount tree is busy
Index: linux/fs/seq_file.c
===================================================================
--- linux.orig/fs/seq_file.c	2008-03-13 20:45:15.000000000 +0100
+++ linux/fs/seq_file.c	2008-03-13 20:45:52.000000000 +0100
@@ -391,6 +391,7 @@ int seq_path(struct seq_file *m, struct 
 }
 EXPORT_SYMBOL(seq_path);
 
+#ifdef CONFIG_PROC_FS
 /*
  * returns the path of the 'dentry' from the root of its filesystem.
  */
@@ -411,7 +412,7 @@ int seq_dentry(struct seq_file *m, struc
 	m->count = m->size;
 	return -1;
 }
-EXPORT_SYMBOL(seq_dentry);
+#endif /* CONFIG_PROC_FS */
 
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
Index: linux/include/linux/dcache.h
===================================================================
--- linux.orig/include/linux/dcache.h	2008-03-13 20:45:15.000000000 +0100
+++ linux/include/linux/dcache.h	2008-03-13 20:45:52.000000000 +0100
@@ -303,7 +303,10 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+
+#ifdef CONFIG_PROC_FS
 extern char *dentry_path(struct dentry *, char *, int);
+#endif /* CONFIG_PROC_FS */
 
 /* Allocation counts.. */
 
Index: linux/include/linux/seq_file.h
===================================================================
--- linux.orig/include/linux/seq_file.h	2008-03-13 20:45:15.000000000 +0100
+++ linux/include/linux/seq_file.h	2008-03-13 20:45:52.000000000 +0100
@@ -44,7 +44,10 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+
+#ifdef CONFIG_PROC_FS
 int seq_dentry(struct seq_file *, struct dentry *, char *);
+#endif /* CONFIG_PROC_FS */
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-03-13 20:45:51.000000000 +0100
+++ linux/fs/pnode.c	2008-03-13 20:45:52.000000000 +0100
@@ -72,12 +72,13 @@ void make_mnt_peer(struct vfsmount *old,
 	__set_mnt_shared(mnt);
 }
 
+#ifdef CONFIG_PROC_FS
 int get_peer_group_id(struct vfsmount *mnt)
 {
 	return mnt->mnt_pgid;
 }
 
-int get_master_id(struct vfsmount *mnt)
+int get_master_group_id(struct vfsmount *mnt)
 {
 	int id;
 
@@ -119,6 +120,7 @@ int get_dominator_id_same_ns(struct vfsm
 
 	return id;
 }
+#endif
 
 static int do_make_slave(struct vfsmount *mnt)
 {
@@ -138,13 +140,13 @@ static int do_make_slave(struct vfsmount
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	if (!list_empty(&mnt->mnt_share))
-		list_del_init(&mnt->mnt_share);
-	else if (IS_MNT_SHARED(mnt)) {
+
+	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share)) {
 		spin_lock(&mnt_pgid_lock);
 		ida_remove(&mnt_pgid_ida, mnt->mnt_pgid);
 		spin_unlock(&mnt_pgid_lock);
 	}
+	list_del_init(&mnt->mnt_share);
 
 	if (peer_mnt)
 		master = peer_mnt;
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-03-13 20:45:51.000000000 +0100
+++ linux/fs/pnode.h	2008-03-13 20:45:52.000000000 +0100
@@ -31,7 +31,9 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+
 int get_peer_group_id(struct vfsmount *);
-int get_master_id(struct vfsmount *);
+int get_master_group_id(struct vfsmount *);
 int get_dominator_id_same_ns(struct vfsmount *);
+
 #endif /* _LINUX_PNODE_H */

--
