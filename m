Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYLPPyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYLPPyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYLPPwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:52:25 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53451 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571AbYLPPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:52:20 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH] ufs: ensure fast symlinks are NUL-terminated
Date: Tue, 16 Dec 2008 15:51:58 +0000
Message-Id: <1229442720-31056-7-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229442720-31056-6-git-send-email-duaneg@dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
 <1229442720-31056-3-git-send-email-duaneg@dghda.com>
 <1229442720-31056-4-git-send-email-duaneg@dghda.com>
 <1229442720-31056-5-git-send-email-duaneg@dghda.com>
 <1229442720-31056-6-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ufs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 39f8778..aca4b58 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/namei.h>
 
 #include "ufs_fs.h"
 #include "ufs.h"
@@ -606,9 +607,12 @@ static void ufs_set_inode_ops(struct inode *inode)
 		inode->i_fop = &ufs_dir_operations;
 		inode->i_mapping->a_ops = &ufs_aops;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (!inode->i_blocks)
+		if (!inode->i_blocks) {
 			inode->i_op = &ufs_fast_symlink_inode_operations;
-		else {
+			nd_terminate_link(UFS_I(inode)->i_u1.i_symlink,
+					  inode->i_size,
+					  sizeof(UFS_I(inode)->i_u1.i_symlink));
+		} else {
 			inode->i_op = &page_symlink_inode_operations;
 			inode->i_mapping->a_ops = &ufs_aops;
 		}
-- 
1.6.0.4

