Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbXEXAqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbXEXAqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761798AbXEXAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:38:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40236 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761275AbXEXAge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:34 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 18/21] Unionfs: Remove defunct unionfs_put_inode super op
Date: Wed, 23 May 2007 20:36:08 -0400
Message-Id: <11799669741651-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Removed old workaround code that was needed to get mmap working, is no
longer needed with recent kernels.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 446faf8..bfd6c24 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -62,25 +62,6 @@ static void unionfs_read_inode(struct inode *inode)
 	inode->i_mapping->a_ops = &unionfs_empty_aops;
 }
 
-static void unionfs_put_inode(struct inode *inode)
-{
-	/*
-	 * This is really funky stuff:
-	 *
-	 * Basically, if i_count == 1, iput will then decrement it and this
-	 * inode will be destroyed.  It is currently holding a reference to
-	 * the hidden inode.  Therefore, it needs to release that reference
-	 * by calling iput on the hidden inode.  iput() _will_ do it for us
-	 * (by calling our clear_inode), but _only_ if i_nlink == 0.  The
-	 * problem is, NFS keeps i_nlink == 1 for silly_rename'd files.  So
-	 * we must force our i_nlink to 0 here to trick iput() into calling
-	 * our clear_inode.
-	 */
-
-	if (atomic_read(&inode->i_count) == 1)
-		inode->i_nlink = 0;
-}
-
 /*
  * we now define delete_inode, because there are two VFS paths that may
  * destroy an inode: one of them calls clear inode before doing everything
@@ -938,7 +919,6 @@ out:
 
 struct super_operations unionfs_sops = {
 	.read_inode	= unionfs_read_inode,
-	.put_inode	= unionfs_put_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
-- 
1.5.2.rc1.165.gaf9b

