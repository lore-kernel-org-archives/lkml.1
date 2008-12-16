Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbYLPPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbYLPPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbYLPPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:52:24 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53457 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbYLPPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:52:22 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] sysv: ensure fast symlinks are NUL-terminated
Date: Tue, 16 Dec 2008 15:51:59 +0000
Message-Id: <1229442720-31056-8-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229442720-31056-7-git-send-email-duaneg@dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
 <1229442720-31056-3-git-send-email-duaneg@dghda.com>
 <1229442720-31056-4-git-send-email-duaneg@dghda.com>
 <1229442720-31056-5-git-send-email-duaneg@dghda.com>
 <1229442720-31056-6-git-send-email-duaneg@dghda.com>
 <1229442720-31056-7-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/sysv/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index df0d435..c93189d 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/namei.h>
 #include <asm/byteorder.h>
 #include "sysv.h"
 
@@ -163,8 +164,11 @@ void sysv_set_inode(struct inode *inode, dev_t rdev)
 		if (inode->i_blocks) {
 			inode->i_op = &sysv_symlink_inode_operations;
 			inode->i_mapping->a_ops = &sysv_aops;
-		} else
+		} else {
 			inode->i_op = &sysv_fast_symlink_inode_operations;
+			nd_terminate_link(SYSV_I(inode)->i_data, inode->i_size,
+				sizeof(SYSV_I(inode)->i_data));
+		}
 	} else
 		init_special_inode(inode, inode->i_mode, rdev);
 }
-- 
1.6.0.4

