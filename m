Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZIXQLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZIXQLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZIXQK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:10:59 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36710 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZIXQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:10:57 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@infradead.org, adilger@sun.com,
       yehuda@newdream.net, garlick@llnl.gov, raven@themaw.net,
       Sage Weil <sage@newdream.net>
Subject: [PATCH] vfs: clean up real_lookup
Date: Thu, 24 Sep 2009 09:11:00 -0700
Message-Id: <1253808660-20473-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1253808660-20473-1-git-send-email-sage@newdream.net>
References: <1253808660-20473-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the goto by flipping the if (!result) over.  Make the
comments a bit more descriptive.  Fix a few kernel style problems.
No functional changes.

CC: Ian Kent <raven@themaw.net>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |   65 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f74ddb3..6770dde 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -469,19 +469,20 @@ ok:
  * This is called when everything else fails, and we actually have
  * to go to the low-level filesystem to find out what we should do..
  *
- * We get the directory semaphore, and after getting that we also
+ * We get the directory mutex, and after getting that we also
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static struct dentry *real_lookup(struct dentry *parent, struct qstr *name,
+				  struct nameidata *nd)
 {
-	struct dentry * result;
+	struct dentry *result, *dentry;
 	struct inode *dir = parent->d_inode;
 
 	mutex_lock(&dir->i_mutex);
 	/*
 	 * First re-do the cached lookup just in case it was created
-	 * while we waited for the directory semaphore..
+	 * while we waited for the directory mutex.
 	 *
 	 * FIXME! This could use version numbering or similar to
 	 * avoid unnecessary cache lookups.
@@ -494,38 +495,40 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
 	result = d_lookup(parent, name);
-	if (!result) {
-		struct dentry *dentry;
-
-do_the_lookup:
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
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			goto do_the_lookup;
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
 	mutex_unlock(&dir->i_mutex);
 	return result;
 }
-- 
1.5.6.5

