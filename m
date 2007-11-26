Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXKZQrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXKZQrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbXKZQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:41 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52787 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbXKZQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:32 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 12/16] Unionfs: reintroduce a bmap method
Date: Mon, 26 Nov 2007 11:44:09 -0500
Message-Id: <119609545888-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for swapon(2) files in the union.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 3f65e52..fa358ef 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -304,10 +304,33 @@ out:
 	return err;		/* assume all is ok */
 }
 
+/*
+ * Although unionfs isn't a block-based file system, it may stack on one.
+ * ->bmap is needed, for example, to swapon(2) files.
+ */
+sector_t unionfs_bmap(struct address_space *mapping, sector_t block)
+{
+	int err = -EINVAL;
+	struct inode *inode, *lower_inode;
+	sector_t (*bmap)(struct address_space *, sector_t);
+
+	inode = (struct inode *)mapping->host;
+	lower_inode = unionfs_lower_inode(inode);
+	if (!lower_inode)
+		goto out;
+	bmap = lower_inode->i_mapping->a_ops->bmap;
+	if (bmap)
+		err = bmap(lower_inode->i_mapping, block);
+out:
+	return err;
+}
+
+
 struct address_space_operations unionfs_aops = {
 	.writepage	= unionfs_writepage,
 	.writepages	= unionfs_writepages,
 	.readpage	= unionfs_readpage,
 	.prepare_write	= unionfs_prepare_write,
 	.commit_write	= unionfs_commit_write,
+	.bmap		= unionfs_bmap,
 };
-- 
1.5.2.2

