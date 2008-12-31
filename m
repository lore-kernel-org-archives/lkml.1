Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYLaQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYLaQu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYLaQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:50:15 -0500
Received: from kumera.dghda.com ([80.68.90.171]:34050 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYLaQuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:50:14 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 1/4] ufs: validate maximum fast symlink size from superblock
Date: Wed, 31 Dec 2008 16:50:05 +0000
Message-Id: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum fast symlink size is set in the superblock of certain types
of UFS filesystem. Before using it we need to check that it isn't longer
than the available space we have in the inode.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ufs/super.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e65212d..a959cdc 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -636,6 +636,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned block_size, super_block_size;
 	unsigned flags;
 	unsigned super_block_offset;
+	unsigned maxsymlen;
 	int ret = -EINVAL;
 
 	uspi = NULL;
@@ -1069,6 +1070,16 @@ magic_found:
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
+	if (uspi->fs_magic == UFS2_MAGIC)
+		maxsymlen = 2 * 4 * (UFS_NDADDR + UFS_NINDIR);
+	else
+		maxsymlen = 4 * (UFS_NDADDR + UFS_NINDIR);
+	if (uspi->s_maxsymlinklen > maxsymlen) {
+		printk(KERN_WARNING "ufs_read_super: excessive maximum fast "
+		       "symlink size (%u)\n", uspi->s_maxsymlinklen);
+		uspi->s_maxsymlinklen = maxsymlen;
+	}
+
 	inode = ufs_iget(sb, UFS_ROOTINO);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
-- 
1.6.0.6

