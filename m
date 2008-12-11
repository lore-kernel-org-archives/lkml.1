Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYLKW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYLKW00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYLKW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:26:13 -0500
Received: from kumera.dghda.com ([80.68.90.171]:39535 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbYLKW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:26:11 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Thu, 11 Dec 2008 22:26:05 +0000
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Stephen@kumera.dghda.com,
       Tweedie@kumera.dghda.com, sct@redhat.com, Andrew@kumera.dghda.com,
       Morton@kumera.dghda.com, akpm@linux-foundation.org, adilger@sun.com,
       linux-ext4@vger.kernel.org
Subject: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Message-ID: <20081211222605.GB18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-6-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f8424ad..c168781 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2817,9 +2817,10 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
