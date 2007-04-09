Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXDIO7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXDIO7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933751AbXDIO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:59:11 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44008 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbXDIOyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:39 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 19/21] Unionfs: Properly handle stale inodes passed to unionfs_permission
Date: Mon,  9 Apr 2007 10:54:10 -0400
Message-Id: <1176130456571-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index edd226f..5c452b6 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -843,8 +843,21 @@ static int unionfs_permission(struct inode *inode, int mask,
 	const int is_file = !S_ISDIR(inode->i_mode);
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
+	unionfs_read_lock(inode->i_sb);
+
 	bstart = ibstart(inode);
 	bend = ibend(inode);
+	if (bstart < 0 || bend < 0) {
+		/*
+		 * With branch-management, we can get a stale inode here.
+		 * If so, we return ESTALE back to link_path_walk, which
+		 * would discard the dcache entry and re-lookup the
+		 * dentry+inode.  This should be equivalent to issuing
+		 * __unionfs_d_revalidate_chain on nd.dentry here.
+		 */
+		err = -ESTALE;	/* force revalidate */
+		goto out;
+	}
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		hidden_inode = unionfs_lower_inode_idx(inode, bindex);
@@ -881,6 +894,7 @@ static int unionfs_permission(struct inode *inode, int mask,
 	}
 
 out:
+	unionfs_read_unlock(inode->i_sb);
 	return err;
 }
 
-- 
1.5.0.3.268.g3dda

