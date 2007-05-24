Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXEXAja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXEXAja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761329AbXEXAgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40224 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbXEXAgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:22 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 19/21] Unionfs: Actually catch bad use of unionfs_mnt{get,put}
Date: Wed, 23 May 2007 20:36:09 -0400
Message-Id: <11799669741312-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/union.h |   34 +++++++---------------------------
 1 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 5376b76..335d579 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -459,38 +459,18 @@ static inline void unlock_dir(struct dentry *dir)
 static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 					      int bindex)
 {
-	struct vfsmount *mnt;
+	BUG_ON(!dentry || bindex < 0);
 
-	if (!dentry) {
-		if (bindex < 0)
-			return NULL;
-		BUG_ON(bindex < 0);
-	}
-	mnt = unionfs_lower_mnt_idx(dentry, bindex);
-	if (!mnt) {
-		if (bindex < 0)
-			return NULL;
-		BUG_ON(mnt && bindex < 0);
-	}
-	mnt = mntget(mnt);
-	return mnt;
+	return mntget(unionfs_lower_mnt_idx(dentry, bindex));
 }
 
 static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 {
-	struct vfsmount *mnt;
+	if (!dentry)
+		return;
 
-	if (!dentry) {
-		if (bindex < 0)
-			return;
-		BUG_ON(dentry && bindex < 0);
-	}
-	mnt = unionfs_lower_mnt_idx(dentry, bindex);
-	if (!mnt) {
-		if (bindex < 0)
-			return;
-		BUG_ON(mnt && bindex < 0);
-	}
-	mntput(mnt);
+	BUG_ON(bindex < 0);
+
+	mntput(unionfs_lower_mnt_idx(dentry, bindex));
 }
 #endif	/* not _UNION_H_ */
-- 
1.5.2.rc1.165.gaf9b

