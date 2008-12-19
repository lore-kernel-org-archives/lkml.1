Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYLSUvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYLSUvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYLSUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:52 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35322 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYLSUrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:49 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>
Subject: [PATCH, v5] befs: ensure fast symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:18 +0000
Message-Id: <1229719638-6982-11-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-10-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
 <1229719638-6982-5-git-send-email-duaneg@dghda.com>
 <1229719638-6982-6-git-send-email-duaneg@dghda.com>
 <1229719638-6982-7-git-send-email-duaneg@dghda.com>
 <1229719638-6982-8-git-send-email-duaneg@dghda.com>
 <1229719638-6982-9-git-send-email-duaneg@dghda.com>
 <1229719638-6982-10-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Sergey S. Kostyliov <rathamahata@php4.ru>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Unchanged from original version.

 fs/befs/linuxvfs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index b6dfee3..d06cb02 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -378,7 +378,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_size = 0;
 		inode->i_blocks = befs_sb->block_size / VFS_BLOCK_SIZE;
 		strncpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
-			BEFS_SYMLINK_LEN);
+			BEFS_SYMLINK_LEN - 1);
+		befs_ino->i_data.symlink[BEFS_SYMLINK_LEN - 1] = '\0';
 	} else {
 		int num_blks;
 
@@ -477,6 +478,8 @@ befs_follow_link(struct dentry *dentry, struct nameidata *nd)
 			kfree(link);
 			befs_error(sb, "Failed to read entire long symlink");
 			link = ERR_PTR(-EIO);
+		} else {
+			link[len - 1] = '\0';
 		}
 	} else {
 		link = befs_ino->i_data.symlink;
-- 
1.6.0.4

