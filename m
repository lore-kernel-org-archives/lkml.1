Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYLaQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYLaQum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYLaQuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:50:19 -0500
Received: from kumera.dghda.com ([80.68.90.171]:34053 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbYLaQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:50:15 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 2/4] ufs: don't truncate longer ufs2 fast symlinks
Date: Wed, 31 Dec 2008 16:50:06 +0000
Message-Id: <1230742208-23972-2-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ufs2 fast symlinks can be twice as long as ufs ones, however the code
was using the ufs size in various places. Fix that so ufs2 symlinks over
60 characters aren't truncated.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ufs/inode.c |    4 ++--
 fs/ufs/ufs.h   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 39f8778..c1ea916 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -708,7 +708,7 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 			ufsi->i_u1.u2_i_data[i] =
 				ufs2_inode->ui_u2.ui_addr.ui_db[i];
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
 			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
 	}
 	return 0;
@@ -853,7 +853,7 @@ static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
 			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.u2_i_data[i];
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
 			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
  	}
 
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 11c0351..69b3427 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -23,7 +23,7 @@ struct ufs_sb_info {
 struct ufs_inode_info {
 	union {
 		__fs32	i_data[15];
-		__u8	i_symlink[4*15];
+		__u8	i_symlink[2 * 4 * 15];
 		__fs64	u2_i_data[15];
 	} i_u1;
 	__u32	i_flags;
-- 
1.6.0.6

