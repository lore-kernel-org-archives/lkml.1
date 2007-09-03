Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXICC1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXICC1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbXICCZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:10 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57592 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbXICCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:23 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 26/32] Unionfs: minor remount fixes
Date: Sun,  2 Sep 2007 22:20:49 -0400
Message-Id: <11887860593576-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 1de41ea..339afab 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -736,7 +736,7 @@ out_no_change:
 	for (i=dbstart(sb->s_root); i<=dbend(sb->s_root); i++) {
 		struct dentry *lower_dentry =
 			unionfs_lower_dentry_idx(sb->s_root, i);
-		atomic_inc(&lower_dentry->d_inode->i_count);
+		igrab(lower_dentry->d_inode);
 		new_lower_inodes[i] = lower_dentry->d_inode;
 	}
 	/* 2. release reference on all older lower inodes */
@@ -758,11 +758,11 @@ out_no_change:
 	i = atomic_inc_return(&UNIONFS_SB(sb)->generation);
 	atomic_set(&UNIONFS_D(sb->s_root)->generation, i);
 	atomic_set(&UNIONFS_I(sb->s_root->d_inode)->generation, i);
-
-	err = 0;		/* reset to success */
-
 	if (!(*flags & MS_SILENT))
 		printk("unionfs: new generation number %d\n", i);
+	/* finally, update the root dentry's times */
+	unionfs_copy_attr_times(sb->s_root->d_inode);
+	err = 0;		/* reset to success */
 
 	/*
 	 * The code above falls through to the next label, and releases the
-- 
1.5.2.2.238.g7cbf2f2

