Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYLKW1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYLKW1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYLKW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:27:14 -0500
Received: from kumera.dghda.com ([80.68.90.171]:39552 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbYLKW1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:27:13 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Thu, 11 Dec 2008 22:27:08 +0000
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, tytso@mit.edu, adilger@sun.com,
       linux-ext4@vger.kernel.org
Subject: [PATCH, v2] ext4: ensure link targets are NUL-terminated
Message-ID: <20081211222622.GC18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com> <1229022995-9898-7-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-7-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ca88060..e70122e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4200,9 +4200,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext4_dir_inode_operations;
 		inode->i_fop = &ext4_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext4_inode_is_fast_symlink(inode))
+		if (ext4_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext4_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext4_symlink_inode_operations;
 			ext4_set_aops(inode);
 		}
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
