Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbZIXIbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbZIXIbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZIXIbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:31:31 -0400
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.108]:8813
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403AbZIXIbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:31:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIPJukrLO0En/2dsb2JhbADWMIQbBYI9
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="39448930"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 01/11] Subject: [PATCH] vfs: make real_lookup do dentry
	revalidation with i_mutex held
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:21:25 +0800
Message-ID: <20090924082125.22151.94452.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sage Weil <sage@newdream.net>

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
index d11f404..d68ea6d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -477,6 +477,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 {
 	struct dentry * result;
 	struct inode *dir = parent->d_inode;
+	struct dentry *dentry;
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -494,38 +495,41 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
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
 

