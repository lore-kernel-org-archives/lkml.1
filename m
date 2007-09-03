Return-Path: <linux-kernel-owner+w=401wt.eu-S964920AbXICCbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920AbXICCbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932392AbXICCZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57663 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbXICCYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:46 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 25/32] Unionfs: readonly branch test fix
Date: Sun,  2 Sep 2007 22:20:48 -0400
Message-Id: <118878605894-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Bug fix to test if a lower branch is readonly, even when given negative
dentries.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/union.h |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 33c2137..26d886e 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -396,14 +396,23 @@ static inline int is_robranch_super(const struct super_block *sb, int index)
 /* Is this file on a read-only branch? */
 static inline int is_robranch_idx(const struct dentry *dentry, int index)
 {
-	int err = 0;
+	struct super_block *lower_sb;
 
 	BUG_ON(index < 0);
 
-	if ((!(branchperms(dentry->d_sb, index) & MAY_WRITE)) ||
-	    IS_RDONLY(unionfs_lower_dentry_idx(dentry, index)->d_inode))
-		err = -EROFS;
-	return err;
+	if (!(branchperms(dentry->d_sb, index) & MAY_WRITE))
+		return -EROFS;
+
+	lower_sb = unionfs_lower_super_idx(dentry->d_sb, index);
+	BUG_ON(lower_sb == NULL);
+	/*
+	 * test sb flags directly, not IS_RDONLY(lower_inode) because the
+	 * lower_dentry could be a negative.
+	 */
+	if (lower_sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	return 0;
 }
 
 static inline int is_robranch(const struct dentry *dentry)
-- 
1.5.2.2.238.g7cbf2f2

