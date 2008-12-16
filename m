Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYLPPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYLPPxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYLPPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:52:15 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53431 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbYLPPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:52:12 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ext2: ensure fast symlinks are NUL-terminated
Date: Tue, 16 Dec 2008 15:51:55 +0000
Message-Id: <1229442720-31056-4-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229442720-31056-3-git-send-email-duaneg@dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
 <1229442720-31056-3-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ext2/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..c902504 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -32,6 +32,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
+#include <linux/namei.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -1286,9 +1287,11 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		else
 			inode->i_mapping->a_ops = &ext2_aops;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext2_inode_is_fast_symlink(inode))
+		if (ext2_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext2_fast_symlink_inode_operations;
-		else {
+			nd_terminate_link(ei->i_data, inode->i_size,
+				sizeof(ei->i_data));
+		} else {
 			inode->i_op = &ext2_symlink_inode_operations;
 			if (test_opt(inode->i_sb, NOBH))
 				inode->i_mapping->a_ops = &ext2_nobh_aops;
-- 
1.6.0.4

