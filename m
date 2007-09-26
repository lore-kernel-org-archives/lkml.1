Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbXIZDgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbXIZDgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbXIZDdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:33:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35491 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbXIZDdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:33:51 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/25] Unionfs: Simplify unionfs_get_nlinks
Date: Tue, 25 Sep 2007 23:09:40 -0400
Message-Id: <1190776205713-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

Since we set the right value for d_type in readdir, there's really no point
in having to calculate the number of directory links.  Some on-disk
filesystems don't even store the number of links for directories.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/subr.c |   41 +++++++----------------------------------
 1 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index b7e7904..6b93b64 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -188,16 +188,10 @@ out:
 }
 
 /*
- * returns the sum of the n_link values of all the underlying inodes of the
- * passed inode
+ * returns the right n_link value based on the inode type
  */
 int unionfs_get_nlinks(const struct inode *inode)
 {
-	int sum_nlinks = 0;
-	int dirs = 0;
-	int bindex;
-	struct inode *lower_inode;
-
 	/* don't bother to do all the work since we're unlinked */
 	if (inode->i_nlink == 0)
 		return 0;
@@ -205,33 +199,12 @@ int unionfs_get_nlinks(const struct inode *inode)
 	if (!S_ISDIR(inode->i_mode))
 		return unionfs_lower_inode(inode)->i_nlink;
 
-	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
-		lower_inode = unionfs_lower_inode_idx(inode, bindex);
-
-		/* ignore files */
-		if (!lower_inode || !S_ISDIR(lower_inode->i_mode))
-			continue;
-
-		BUG_ON(lower_inode->i_nlink < 0);
-
-		/* A deleted directory. */
-		if (lower_inode->i_nlink == 0)
-			continue;
-		dirs++;
-
-		/*
-		 * A broken directory...
-		 *
-		 * Some filesystems don't properly set the number of links
-		 * on empty directories
-		 */
-		if (lower_inode->i_nlink == 1)
-			sum_nlinks += 2;
-		else
-			sum_nlinks += (lower_inode->i_nlink - 2);
-	}
-
-	return (!dirs ? 0 : sum_nlinks + 2);
+	/*
+	 * For directories, we return 1. The only place that could cares
+	 * about links is readdir, and there's d_type there so even that
+	 * doesn't matter.
+	 */
+	return 1;
 }
 
 /* construct whiteout filename */
-- 
1.5.2.2

