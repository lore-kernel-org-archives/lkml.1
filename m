Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZCITFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZCITFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCITFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:05:25 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50763 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZCITFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:05:23 -0400
X-Greylist: delayed 2021 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 15:05:23 EDT
Date: Mon, 9 Mar 2009 11:31:40 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
cc: adilger@sun.com
Subject: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex
 held
Message-ID: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real_lookup() is called by do_lookup() if dentry revalidation fails.  If
the cache is re-populated while waiting for i_mutex, it may find that
a d_lookup() subsequently succeeds (see the "Uhhuh! Nasty case" comment).

Previously, real_lookup() would drop i_mutex and do_revalidate() again. If
revalidate failed _again_, however, it would give up with -ENOENT.  The
problem here that network file systems may be invalidating dentries via
server callbacks, e.g. due to concurrent access from another client, and
-ENOENT is frequently the wrong answer.

This problem has been seen with both Lustre and Ceph.  It seems possible
to hit this case with NFS as well if the cache lifetime is very short.

Instead, we should do_revalidate() while i_mutex is still held.  If
revalidation fails, we can move on to a ->lookup() and ensure a correct
result without worrying about any subsequent races.

Note that do_revalidate() is called with i_mutex held elsewhere.  For
example, do_filp_open(), lookup_create(), do_unlinkat(), do_rmdir(),
and possibly others all take the directory i_mutex, and then

-> lookup_hash
        -> __lookup_hash
                -> cached_lookup
                        -> do_revalidate

so this does not introduce any new locking rules for d_revalidate
implementations.

CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Andreas Dilger <adilger@sun.com>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |   56 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c30e33d..49f58d1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -469,6 +469,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 {
 	struct dentry * result;
 	struct inode *dir = parent->d_inode;
+	struct dentry *dentry;
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -486,38 +487,39 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
 	result = d_lookup(parent, name);
-	if (!result) {
-		struct dentry *dentry;
-
-		/* Don't create child dentry for a dead directory. */
-		result = ERR_PTR(-ENOENT);
-		if (IS_DEADDIR(dir))
-			goto out_unlock;
-
-		dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
-		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+	if (result) {
+		/*
+		 * The cache was re-populated while we waited on the
+		 * mutex.  We need to revalidate, this time while
+		 * holding i_mutex (to avoid another race).
+		 */
+		if (result->d_op && result->d_op->d_revalidate) {
+			result = do_revalidate(result, nd);
 			if (result)
-				dput(dentry);
-			else
-				result = dentry;
+				goto out_unlock;
+			/*
+			 * The dentry was left behind invalid.  Just
+			 * do the lookup.
+			 */
 		}
-out_unlock:
-		mutex_unlock(&dir->i_mutex);
-		return result;
 	}
 
-	/*
-	 * Uhhuh! Nasty case: the cache was re-populated while
-	 * we waited on the semaphore. Need to revalidate.
-	 */
-	mutex_unlock(&dir->i_mutex);
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			result = ERR_PTR(-ENOENT);
+	/* Don't create child dentry for a dead directory. */
+	result = ERR_PTR(-ENOENT);
+	if (IS_DEADDIR(dir))
+		goto out_unlock;
+
+	dentry = d_alloc(parent, name);
+	result = ERR_PTR(-ENOMEM);
+	if (dentry) {
+		result = dir->i_op->lookup(dir, dentry, nd);
+		if (result) {
+			dput(dentry);
+		} else
+			result = dentry;
 	}
+out_unlock:
+	mutex_unlock(&dir->i_mutex);
 	return result;
 }
 
-- 
1.5.6.5

