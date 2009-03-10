Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZCJTbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZCJTbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZCJTbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:31:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:47864 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbZCJTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:31:20 -0400
Date: Tue, 10 Mar 2009 12:31:18 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       yehuda@newdream.net
Subject: Re: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex
 held
In-Reply-To: <E1Lh7XK-0000QO-DT@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0903101228490.14713@cobra.newdream.net>
References: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
 <E1Lh7XK-0000QO-DT@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Miklos Szeredi wrote:

> The patch is wrong in case ->d_revalidate is NULL.
> 
> Something like this should fix it up:
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2009-03-10 20:03:58.000000000 +0100
> +++ linux-2.6/fs/namei.c	2009-03-10 20:19:29.000000000 +0100
> @@ -501,6 +501,8 @@ static struct dentry * real_lookup(struc
>  			 * The dentry was left behind invalid.  Just
>  			 * do the lookup.
>  			 */
> +		} else {
> +			goto out_unlock;
>  		}
>  	}
>  
> Otherwise looks OK.

Good catch.  Here is an updated patch (fixing the checkpatch error as 
well).

Thanks!
sage

---

>From d33ad281f3e6a3bb172a39a55824ce69187903be Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Tue, 10 Mar 2009 12:26:37 -0700
Subject: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex held

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

Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |   58 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c30e33d..64cf927 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -469,6 +469,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 {
 	struct dentry * result;
 	struct inode *dir = parent->d_inode;
+	struct dentry *dentry;
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -486,38 +487,41 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
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
+		} else {
+			goto out_unlock;
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
+		if (result)
+			dput(dentry);
+		else
+			result = dentry;
 	}
+out_unlock:
+	mutex_unlock(&dir->i_mutex);
 	return result;
 }
 
-- 
1.5.6.5

