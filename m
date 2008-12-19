Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYLSUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYLSUt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYLSUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:39 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35286 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYLSUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:36 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v5] ext2: ensure fast symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:13 +0000
Message-Id: <1229719638-6982-6-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-5-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
 <1229719638-6982-5-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Changes from v4: fixed off-by-one bug in maximum length, as pointed out by
Andreas Dilger.

 fs/ext2/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..02b39a5 100644
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
+				sizeof(ei->i_data) - 1);
+		} else {
 			inode->i_op = &ext2_symlink_inode_operations;
 			if (test_opt(inode->i_sb, NOBH))
 				inode->i_mapping->a_ops = &ext2_nobh_aops;
-- 
1.6.0.4

