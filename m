Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbYFWQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbYFWQMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbYFWQMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:12:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57084 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYFWQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:12:13 -0400
Message-Id: <20080623161210.904477291@szeredi.hu>
References: <20080623161151.597847108@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 23 Jun 2008 18:11:52 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: [patch 1/3] vfs: dcache sparse fixes
Content-Disposition: inline; filename=vfs-dcache-sparse-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following sparse warnings:

fs/dcache.c:2183:19: warning: symbol 'filp_cachep' was not declared. Should it be static?
fs/dcache.c:115:3: warning: context imbalance in 'dentry_iput' - unexpected unlock
fs/dcache.c:188:2: warning: context imbalance in 'dput' - different lock contexts for basic block
fs/dcache.c:400:2: warning: context imbalance in 'prune_one_dentry' - different lock contexts for basic block
fs/dcache.c:431:22: warning: context imbalance in 'prune_dcache' - different lock contexts for basic block
fs/dcache.c:563:2: warning: context imbalance in 'shrink_dcache_sb' - different lock contexts for basic block
fs/dcache.c:1385:6: warning: context imbalance in 'd_delete' - wrong count at exit
fs/dcache.c:1636:2: warning: context imbalance in '__d_unalias' - unexpected unlock
fs/dcache.c:1735:2: warning: context imbalance in 'd_materialise_unique' - different lock contexts for basic block

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 fs/dcache.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-23 17:25:19.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-23 17:27:11.000000000 +0200
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
@@ -106,9 +107,10 @@ static void dentry_lru_remove(struct den
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
- * Called with dcache_lock and per dentry lock held, drops both.
  */
 static void dentry_iput(struct dentry * dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -132,12 +134,13 @@ static void dentry_iput(struct dentry * 
  * d_kill - kill dentry and return parent
  * @dentry: dentry to kill
  *
- * Called with dcache_lock and d_lock, releases both.  The dentry must
- * already be unhashed and removed from the LRU.
+ * The dentry must already be unhashed and removed from the LRU.
  *
  * If this is the root of the dentry tree, return NULL.
  */
 static struct dentry *d_kill(struct dentry *dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
 {
 	struct dentry *parent;
 
@@ -383,11 +386,11 @@ restart:
  * Try to prune ancestors as well.  This is necessary to prevent
  * quadratic behavior of shrink_dcache_parent(), but is also expected
  * to be beneficial in reducing dentry cache fragmentation.
- *
- * Called with dcache_lock, drops it and then regains.
- * Called with dentry->d_lock held, drops it.
  */
 static void prune_one_dentry(struct dentry * dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
+	__acquires(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
@@ -1604,10 +1607,9 @@ static int d_isparent(struct dentry *p1,
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
- *
- * On return, dcache_lock will have been unlocked.
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
+	__releases(dcache_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -1743,7 +1745,6 @@ out_nolock:
 shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
-	goto shouldnt_be_hashed;
 }
 
 static int prepend(char **buffer, int *buflen, const char *str,
@@ -1758,7 +1759,7 @@ static int prepend(char **buffer, int *b
 }
 
 /**
- * d_path - return the path of a dentry
+ * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
@@ -1845,7 +1846,7 @@ Elong:
  *
  * Returns the buffer or an error code if the path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * "buflen" should be positive.
  */
 char *d_path(struct path *path, char *buf, int buflen)
 {

--
