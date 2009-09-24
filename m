Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZIXQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZIXQK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZIXQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:10:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36703 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZIXQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:10:57 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@infradead.org, adilger@sun.com,
       yehuda@newdream.net, garlick@llnl.gov, raven@themaw.net,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex held
Date: Thu, 24 Sep 2009 09:10:59 -0700
Message-Id: <1253808660-20473-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
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

Yes, the goto is ugly.  A cleanup patch follows.

CC: Ian Kent <raven@themaw.net>
CC: Christoph Hellwig <hch@infradead.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Andreas Dilger <adilger@sun.com>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d11f404..f74ddb3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -497,6 +497,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 	if (!result) {
 		struct dentry *dentry;
 
+do_the_lookup:
 		/* Don't create child dentry for a dead directory. */
 		result = ERR_PTR(-ENOENT);
 		if (IS_DEADDIR(dir))
@@ -520,12 +521,12 @@ out_unlock:
 	 * Uhhuh! Nasty case: the cache was re-populated while
 	 * we waited on the semaphore. Need to revalidate.
 	 */
-	mutex_unlock(&dir->i_mutex);
 	if (result->d_op && result->d_op->d_revalidate) {
 		result = do_revalidate(result, nd);
 		if (!result)
-			result = ERR_PTR(-ENOENT);
+			goto do_the_lookup;
 	}
+	mutex_unlock(&dir->i_mutex);
 	return result;
 }
 
-- 
1.5.6.5

