Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbZAHWoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbZAHWoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZAHWn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:43:57 -0500
Received: from kumera.dghda.com ([80.68.90.171]:55941 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZAHWn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:43:56 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v2 1/4] ufs: validate maximum fast symlink size from superblock
Date: Thu,  8 Jan 2009 22:43:48 +0000
Message-Id: <1231454631-14329-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum fast symlink size is set in the superblock of certain types
of UFS filesystem. Before using it we need to check that it isn't longer
than the available space we have in the inode.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Version 1 -> 2:
  * Replaced printk with ufs_warning

 fs/ufs/super.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e65212d..9613b8c 100644
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
+		ufs_warning(sb, __func__, "ufs_read_super: excessive maximum "
+			    "fast symlink size (%u)\n", uspi->s_maxsymlinklen);
+		uspi->s_maxsymlinklen = maxsymlen;
+	}
+
 	inode = ufs_iget(sb, UFS_ROOTINO);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
-- 
1.6.0.6

