Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXF2H2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXF2H2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbXF2H0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46310 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXF2H0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:32 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 5/5] Unionfs: Remove unnecessary BUG_ON in unionfs_follow_link
Date: Fri, 29 Jun 2007 03:26:21 -0400
Message-Id: <11831019822222-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
References: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index a86da5b..b5f9022 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -832,35 +832,21 @@ out:
 }
 
 /*
- * Check if dentry is valid or not, as per our generation numbers.
- * @dentry: dentry to check.
- * Returns 1 (valid) or 0 (invalid/stale).
+ * unionfs_follow_link takes a dentry, but it is simple.  It only needs to
+ * allocate some memory and then call our ->readlink method.  Our
+ * unionfs_readlink *does* lock our dentry and revalidate the dentry.
+ * Therefore, we do not have to lock our dentry here, to prevent a deadlock;
+ * nor do we need to revalidate it either.  It is safe to not lock our
+ * dentry here, nor revalidate it, because unionfs_follow_link does not do
+ * anything (prior to calling ->readlink) which could become inconsistent
+ * due to branch management.
  */
-static inline int is_valid_dentry(struct dentry *dentry)
-{
-	BUG_ON(!UNIONFS_D(dentry));
-	BUG_ON(!UNIONFS_SB(dentry->d_sb));
-	return (atomic_read(&UNIONFS_D(dentry)->generation) ==
-			atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-}
-
-/* We don't lock the dentry here, because readlink does the heavy lifting. */
 static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	char *buf;
 	int len = PAGE_SIZE, err;
 	mm_segment_t old_fs;
 
-	/*
-	 * FIXME: Really nasty...we can get called from two distinct places:
-	 * 1) read_link - locks the dentry
-	 * 2) VFS lookup code - does NOT lock the dentry
-	 *
-	 * The proper thing would be to call dentry revalidate. It however
-	 * expects a locked dentry, and we can't cleanly guarantee that.
-	 */
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_read_lock(dentry->d_sb);
 
 	/* This is freed by the put_link method assuming a successful call. */
-- 
1.5.2.2.238.g7cbf2f2

