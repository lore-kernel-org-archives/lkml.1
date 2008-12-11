Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYLKWY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYLKWY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbYLKWYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:24:07 -0500
Received: from kumera.dghda.com ([80.68.90.171]:39525 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYLKWYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:24:05 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Thu, 11 Dec 2008 22:23:59 +0000
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org
Subject: [PATCH, v2] ext2: ensure link targets are NUL-terminated
Message-ID: <20081211222359.GA18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-5-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..9bacf35 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1286,9 +1286,10 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		else
 			inode->i_mapping->a_ops = &ext2_aops;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext2_inode_is_fast_symlink(inode))
+		if (ext2_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext2_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext2_symlink_inode_operations;
 			if (test_opt(inode->i_sb, NOBH))
 				inode->i_mapping->a_ops = &ext2_nobh_aops;
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
