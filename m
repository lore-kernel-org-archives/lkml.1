Return-Path: <linux-kernel-owner+w=401wt.eu-S939087AbXHIJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939087AbXHIJ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938814AbXHIJ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:23 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:48293 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938755AbXHIJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:22 -0400
Message-Id: <20070809092516.669107268@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:53 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 7/9] clean out unused code in dentry pruning
Content-Disposition: inline; filename=dcache_cleanup_prune.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

It looks like in the end all pruners want parents removed.

So remove unused code and function arguments.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2007-08-09 11:01:54.000000000 +0200
+++ linux/fs/dcache.c	2007-08-09 11:04:32.000000000 +0200
@@ -381,20 +381,17 @@ restart:
  * Throw away a dentry - free the inode, dput the parent.  This requires that
  * the LRU list has already been removed.
  *
- * If prune_parents is true, try to prune ancestors as well.
+ * Try to prune ancestors as well.  This is necessary to prevent
+ * quadratic behavior of shrink_dcache_parent(), but is also expected
+ * to be beneficial in reducing dentry cache fragmentation.
  *
  * Called with dcache_lock, drops it and then regains.
  * Called with dentry->d_lock held, drops it.
  */
-static void prune_one_dentry(struct dentry * dentry, int prune_parents)
+static void prune_one_dentry(struct dentry * dentry)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
-	if (!prune_parents) {
-		dput(dentry);
-		spin_lock(&dcache_lock);
-		return;
-	}
 
 	/*
 	 * Prune ancestors.  Locking is simpler than in dput(),
@@ -422,7 +419,6 @@ static void prune_one_dentry(struct dent
  * @count: number of entries to try and free
  * @sb: if given, ignore dentries for other superblocks
  *         which are being unmounted.
- * @prune_parents: if true, try to prune ancestors as well in one go
  *
  * Shrink the dcache. This is done when we need
  * more memory, or simply when we need to unmount
@@ -433,7 +429,7 @@ static void prune_one_dentry(struct dent
  * all the dentries are in use.
  */
  
-static void prune_dcache(int count, struct super_block *sb, int prune_parents)
+static void prune_dcache(int count, struct super_block *sb)
 {
 	spin_lock(&dcache_lock);
 	for (; count ; count--) {
@@ -493,7 +489,7 @@ static void prune_dcache(int count, stru
 		 * without taking the s_umount lock (I already hold it).
 		 */
 		if (sb && dentry->d_sb == sb) {
-			prune_one_dentry(dentry, prune_parents);
+			prune_one_dentry(dentry);
 			continue;
 		}
 		/*
@@ -508,7 +504,7 @@ static void prune_dcache(int count, stru
 		s_umount = &dentry->d_sb->s_umount;
 		if (down_read_trylock(s_umount)) {
 			if (dentry->d_sb->s_root != NULL) {
-				prune_one_dentry(dentry, prune_parents);
+				prune_one_dentry(dentry);
 				up_read(s_umount);
 				continue;
 			}
@@ -579,7 +575,7 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-		prune_one_dentry(dentry, 1);
+		prune_one_dentry(dentry);
 		cond_resched_lock(&dcache_lock);
 		goto repeat;
 	}
@@ -858,7 +854,7 @@ void shrink_dcache_parent(struct dentry 
 	int found;
 
 	while ((found = select_parent(parent)) != 0)
-		prune_dcache(found, parent->d_sb, 1);
+		prune_dcache(found, parent->d_sb);
 }
 
 /*
@@ -878,7 +874,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL, 1);
+		prune_dcache(nr, NULL);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }

--
