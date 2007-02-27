Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXB0XQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXB0XQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXB0XQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:16:32 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54730 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXB0XQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:16:30 -0500
Message-Id: <20070227231546.769521584@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:44 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 02/22] fix quadratic behavior of shrink_dcache_parent()
Content-Disposition: inline; filename=fix_shrink_quadratic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Changes:
 o dput already checks dentry == NULL, so remove check
   from prune_one_dentry()


The time shrink_dcache_parent() takes, grows quadratically with the
depth of the tree under 'parent'.  This starts to get noticable at
about 10,000.

These kinds of depths don't occur normally, and filesystems which
invoke shrink_dcache_parent() via d_invalidate() seem to have other
depth dependent timings, so it's not even easy to expose this problem.

However with FUSE it's easy to create a deep tree and d_invalidate()
will also get called.  This can make a syscall hang for a very long
time.

This is the original discovery of the problem by Russ Cox:

  http://article.gmane.org/gmane.comp.file-systems.fuse.devel/3826

The following patch fixes the quadratic behavior, by optionally
allowing prune_dcache() to prune ancestors of a dentry in one go,
instead of doing it one at a time.

Common code in dput() and prune_one_dentry() is extracted into a new
helper function d_kill().

shrink_dcache_parent() as well as shrink_dcache_sb() are converted to
use the ancestry-pruner option.  Only for shrink_dcache_memory() is
this behavior not desirable, so it keeps using the old algorithm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2007-02-27 14:40:56.000000000 +0100
+++ linux/fs/dcache.c	2007-02-27 14:41:07.000000000 +0100
@@ -121,6 +121,28 @@ static void dentry_iput(struct dentry * 
 	}
 }
 
+/**
+ * d_kill - kill dentry and return parent
+ * @dentry: dentry to kill
+ *
+ * Called with dcache_lock and d_lock, releases both.  The dentry must
+ * already be unhashed and removed from the LRU.
+ *
+ * If this is the root of the dentry tree, return NULL.
+ */
+static struct dentry *d_kill(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	list_del(&dentry->d_u.d_child);
+	dentry_stat.nr_dentry--;	/* For d_free, below */
+	/*drops the locks, at that point nobody can reach this dentry */
+	dentry_iput(dentry);
+	parent = dentry->d_parent;
+	d_free(dentry);
+	return dentry == parent ? NULL : parent;
+}
+
 /* 
  * This is dput
  *
@@ -189,28 +211,17 @@ repeat:
 
 unhash_it:
 	__d_drop(dentry);
-
-kill_it: {
-		struct dentry *parent;
-
-		/* If dentry was on d_lru list
-		 * delete it from there
-		 */
-  		if (!list_empty(&dentry->d_lru)) {
-  			list_del(&dentry->d_lru);
-  			dentry_stat.nr_unused--;
-  		}
-  		list_del(&dentry->d_u.d_child);
-		dentry_stat.nr_dentry--;	/* For d_free, below */
-		/*drops the locks, at that point nobody can reach this dentry */
-		dentry_iput(dentry);
-		parent = dentry->d_parent;
-		d_free(dentry);
-		if (dentry == parent)
-			return;
-		dentry = parent;
-		goto repeat;
+kill_it:
+	/* If dentry was on d_lru list
+	 * delete it from there
+	 */
+	if (!list_empty(&dentry->d_lru)) {
+		list_del(&dentry->d_lru);
+		dentry_stat.nr_unused--;
 	}
+	dentry = d_kill(dentry);
+	if (dentry)
+		goto repeat;
 }
 
 /**
@@ -371,22 +382,40 @@ restart:
  * Throw away a dentry - free the inode, dput the parent.  This requires that
  * the LRU list has already been removed.
  *
+ * If prune_parents is true, try to prune ancestors as well.
+ *
  * Called with dcache_lock, drops it and then regains.
  * Called with dentry->d_lock held, drops it.
  */
-static void prune_one_dentry(struct dentry * dentry)
+static void prune_one_dentry(struct dentry * dentry, int prune_parents)
 {
-	struct dentry * parent;
-
 	__d_drop(dentry);
-	list_del(&dentry->d_u.d_child);
-	dentry_stat.nr_dentry--;	/* For d_free, below */
-	dentry_iput(dentry);
-	parent = dentry->d_parent;
-	d_free(dentry);
-	if (parent != dentry)
-		dput(parent);
+	dentry = d_kill(dentry);
+	if (!prune_parents) {
+		dput(dentry);
+		spin_lock(&dcache_lock);
+		return;
+	}
+
+	/*
+	 * Prune ancestors.  Locking is simpler than in dput(),
+	 * because dcache_lock needs to be taken anyway.
+	 */
 	spin_lock(&dcache_lock);
+	while (dentry) {
+		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
+			return;
+
+		if (dentry->d_op && dentry->d_op->d_delete)
+			dentry->d_op->d_delete(dentry);
+		if (!list_empty(&dentry->d_lru)) {
+			list_del(&dentry->d_lru);
+			dentry_stat.nr_unused--;
+		}
+		__d_drop(dentry);
+		dentry = d_kill(dentry);
+		spin_lock(&dcache_lock);
+	}
 }
 
 /**
@@ -394,6 +423,7 @@ static void prune_one_dentry(struct dent
  * @count: number of entries to try and free
  * @sb: if given, ignore dentries for other superblocks
  *         which are being unmounted.
+ * @prune_parents: if true, try to prune ancestors as well in one go
  *
  * Shrink the dcache. This is done when we need
  * more memory, or simply when we need to unmount
@@ -404,7 +434,7 @@ static void prune_one_dentry(struct dent
  * all the dentries are in use.
  */
  
-static void prune_dcache(int count, struct super_block *sb)
+static void prune_dcache(int count, struct super_block *sb, int prune_parents)
 {
 	spin_lock(&dcache_lock);
 	for (; count ; count--) {
@@ -464,7 +494,7 @@ static void prune_dcache(int count, stru
 		 * without taking the s_umount lock (I already hold it).
 		 */
 		if (sb && dentry->d_sb == sb) {
-			prune_one_dentry(dentry);
+			prune_one_dentry(dentry, prune_parents);
 			continue;
 		}
 		/*
@@ -479,7 +509,7 @@ static void prune_dcache(int count, stru
 		s_umount = &dentry->d_sb->s_umount;
 		if (down_read_trylock(s_umount)) {
 			if (dentry->d_sb->s_root != NULL) {
-				prune_one_dentry(dentry);
+				prune_one_dentry(dentry, prune_parents);
 				up_read(s_umount);
 				continue;
 			}
@@ -550,7 +580,7 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-		prune_one_dentry(dentry);
+		prune_one_dentry(dentry, 1);
 		cond_resched_lock(&dcache_lock);
 		goto repeat;
 	}
@@ -829,7 +859,7 @@ void shrink_dcache_parent(struct dentry 
 	int found;
 
 	while ((found = select_parent(parent)) != 0)
-		prune_dcache(found, parent->d_sb);
+		prune_dcache(found, parent->d_sb, 1);
 }
 
 /*
@@ -849,7 +879,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL);
+		prune_dcache(nr, NULL, 0);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }

--
