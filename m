Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYBQC7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYBQC7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYBQC5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:55 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36260 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYBQC5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:49 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 09/17] Unionfs: revalidation code cleanup and refactoring
Date: Sat, 16 Feb 2008 21:57:18 -0500
Message-Id: <12032170512158-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   55 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index cd15243..afa2120 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -18,6 +18,39 @@
 
 #include "union.h"
 
+
+static inline void __dput_lowers(struct dentry *dentry, int start, int end)
+{
+	struct dentry *lower_dentry;
+	int bindex;
+
+	if (start < 0)
+		return;
+	for (bindex = start; bindex <= end; bindex++) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
+			continue;
+		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+		dput(lower_dentry);
+	}
+}
+
+static inline void __iput_lowers(struct inode *inode, int start, int end)
+{
+	struct inode *lower_inode;
+	int bindex;
+
+	if (start < 0)
+		return;
+	for (bindex = start; bindex <= end; bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
+			continue;
+		unionfs_set_lower_inode_idx(inode, bindex, NULL);
+		iput(lower_inode);
+	}
+}
+
 /*
  * Revalidate a single dentry.
  * Assume that dentry's info node is locked.
@@ -72,15 +105,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 		/* Free the pointers for our inodes and this dentry. */
 		bstart = dbstart(dentry);
 		bend = dbend(dentry);
-		if (bstart >= 0) {
-			struct dentry *lower_dentry;
-			for (bindex = bstart; bindex <= bend; bindex++) {
-				lower_dentry =
-					unionfs_lower_dentry_idx(dentry,
-								 bindex);
-				dput(lower_dentry);
-			}
-		}
+		__dput_lowers(dentry, bstart, bend);
 		set_dbstart(dentry, -1);
 		set_dbend(dentry, -1);
 
@@ -90,17 +115,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 
 			bstart = ibstart(dentry->d_inode);
 			bend = ibend(dentry->d_inode);
-			if (bstart >= 0) {
-				struct inode *lower_inode;
-				for (bindex = bstart; bindex <= bend;
-				     bindex++) {
-					lower_inode =
-						unionfs_lower_inode_idx(
-							dentry->d_inode,
-							bindex);
-					iput(lower_inode);
-				}
-			}
+			__iput_lowers(dentry->d_inode, bstart, bend);
 			kfree(UNIONFS_I(dentry->d_inode)->lower_inodes);
 			UNIONFS_I(dentry->d_inode)->lower_inodes = NULL;
 			ibstart(dentry->d_inode) = -1;
-- 
1.5.2.2

