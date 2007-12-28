Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbXL1Uw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbXL1Uw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXL1Uol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:41 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37210 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXL1UoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:44:23 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 14/30] Unionfs: remove unnecessary conditional inode lock
Date: Fri, 28 Dec 2007 15:42:48 -0500
Message-Id: <11988745922794-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was intended to protect the inode during branch management, but that is
now done through our superblock rwsem.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 68c07ba..dc1aa39 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -33,7 +33,6 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	int bindex, bstart, bend;
 	int sbgen, dgen;
 	int positive = 0;
-	int locked = 0;
 	int interpose_flag;
 	struct nameidata lowernd; /* TODO: be gentler to the stack */
 
@@ -87,16 +86,6 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 		interpose_flag = INTERPOSE_REVAL_NEG;
 		if (positive) {
 			interpose_flag = INTERPOSE_REVAL;
-			/*
-			 * During BRM, the VFS could already hold a lock on
-			 * a file being read, so don't lock it again
-			 * (deadlock), but if you lock it in this function,
-			 * then release it here too.
-			 */
-			if (!mutex_is_locked(&dentry->d_inode->i_mutex)) {
-				mutex_lock(&dentry->d_inode->i_mutex);
-				locked = 1;
-			}
 
 			bstart = ibstart(dentry->d_inode);
 			bend = ibend(dentry->d_inode);
@@ -115,8 +104,6 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 			UNIONFS_I(dentry->d_inode)->lower_inodes = NULL;
 			ibstart(dentry->d_inode) = -1;
 			ibend(dentry->d_inode) = -1;
-			if (locked)
-				mutex_unlock(&dentry->d_inode->i_mutex);
 		}
 
 		result = unionfs_lookup_backend(dentry, &lowernd,
-- 
1.5.2.2

