Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXEXAh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXEXAh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760807AbXEXAga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:30 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40225 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbXEXAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:23 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 21/21] Unionfs: Correctly decrement refcounts of mnt's upon branch management
Date: Wed, 23 May 2007 20:36:11 -0400
Message-Id: <11799669742009-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

The old logic was broken in one place, which another place tried to "fix"
incorrectly.  Also added detailed comments to explain the new/correct logic.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   17 ++++++++++++-----
 fs/unionfs/dentry.c     |   18 +++++++++++++-----
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 69d9c87..83001aa 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -135,14 +135,21 @@ static void cleanup_file(struct file *file)
 				       "file %p\n", file);
 			else {
 				unionfs_read_lock(sb);
+				/* decrement count of open files */
 				branchput(sb, i);
 				unionfs_read_unlock(sb);
-				/* XXX: is it OK to use sb->s_root here? */
-				unionfs_mntput(sb->s_root, i);
-				/* mntget b/c fput below will call mntput */
-				unionfs_mntget(sb->s_root, bindex);
+				/*
+				 * fput will perform an mntput for us on the
+				 * correct branch.  Although we're using the
+				 * file's old branch configuration, bindex,
+				 * which is the old index, correctly points
+				 * to the right branch in the file's branch
+				 * list.  In other words, we're going to
+				 * mntput the correct branch even if
+				 * branches have been added/removed.
+				 */
+				fput(unionfs_lower_file_idx(file, bindex));
 			}
-			fput(unionfs_lower_file_idx(file, bindex));
 		}
 	}
 
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 95cea3b..db0ef43 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -258,14 +258,22 @@ out_this:
 	/* finally, lock this dentry and revalidate it */
 	verify_locked(dentry);
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
-	saved_bstart = dbstart(dentry);
-	saved_bend = dbend(dentry);
 	valid = __unionfs_d_revalidate_one(dentry, nd);
 
-	if (valid && chain_len > 0 && sbgen != dgen) {
-		for (bindex = saved_bstart; bindex <= saved_bend; bindex++)
+	/*
+	 * If __unionfs_d_revalidate_one() succeeded above, then it will
+	 * have incremented the refcnt of the mnt's, but also the branch
+	 * indices of the dentry will have been updated (to take into
+	 * account any branch insertions/deletion.  So the current
+	 * dbstart/dbend match the current, and new, indices of the mnts
+	 * which __unionfs_d_revalidate_one has incremented.  Note: the "if"
+	 * test below does not depend on whether chain_len was 0 or greater.
+	 */
+	if (valid && sbgen != dgen)
+		for (bindex = dbstart(dentry);
+		     bindex <= dbend(dentry);
+		     bindex++)
 			unionfs_mntput(dentry, bindex);
-	}
 
 out_free:
 	/* unlock/dput all dentries in chain and return status */
-- 
1.5.2.rc1.165.gaf9b

