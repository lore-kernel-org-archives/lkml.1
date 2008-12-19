Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYLSUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYLSUtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYLSUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:41 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35294 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbYLSUrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:39 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>, Stephen Tweedie <sct@redhat.com>,
       linux-ext4@vger.kernel.org
Subject: [PATCH, v5] ext3: ensure fast symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:14 +0000
Message-Id: <1229719638-6982-7-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-6-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
 <1229719638-6982-5-git-send-email-duaneg@dghda.com>
 <1229719638-6982-6-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Changes from v4: fixed off-by-one bug in maximum length, as pointed out by
Andreas Dilger.

 fs/ext3/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f8424ad..c4bdccf 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/bio.h>
 #include <linux/fiemap.h>
+#include <linux/namei.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -2817,9 +2818,11 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			nd_terminate_link(ei->i_data, inode->i_size,
+				sizeof(ei->i_data) - 1);
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
-- 
1.6.0.4

