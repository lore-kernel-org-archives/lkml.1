Return-Path: <linux-kernel-owner+w=401wt.eu-S934473AbZLKEr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbZLKEr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbZLKErx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:47:53 -0500
Received: from kroah.org ([198.145.64.141]:37018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761767AbZLKEga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:30 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:07 2009
Message-Id: <20091211042807.176333510@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [62/90] ext4: plug a buffer_head leak in an error path of ext4_iget()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0062-ext4-plug-a-buffer_head-leak-in-an-error-path-of-ext.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 567f3e9a70d71e5c9be03701b8578be77857293b)

One of the invalid error paths in ext4_iget() forgot to brelse() the
inode buffer head.  Fix it by adding a brelse() in the common error
return path, which also simplifies function.

Thanks to Andi Kleen <ak@linux.intel.com> reporting the problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4771,7 +4771,6 @@ struct inode *ext4_iget(struct super_blo
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei;
-	struct buffer_head *bh;
 	struct inode *inode;
 	long ret;
 	int block;
@@ -4783,11 +4782,11 @@ struct inode *ext4_iget(struct super_blo
 		return inode;
 
 	ei = EXT4_I(inode);
+	iloc.bh = 0;
 
 	ret = __ext4_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
 		goto bad_inode;
-	bh = iloc.bh;
 	raw_inode = ext4_raw_inode(&iloc);
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
@@ -4810,7 +4809,6 @@ struct inode *ext4_iget(struct super_blo
 		if (inode->i_mode == 0 ||
 		    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
 			/* this inode is deleted */
-			brelse(bh);
 			ret = -ESTALE;
 			goto bad_inode;
 		}
@@ -4842,7 +4840,6 @@ struct inode *ext4_iget(struct super_blo
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT4_INODE_SIZE(inode->i_sb)) {
-			brelse(bh);
 			ret = -EIO;
 			goto bad_inode;
 		}
@@ -4895,10 +4892,8 @@ struct inode *ext4_iget(struct super_blo
 		/* Validate block references which are part of inode */
 		ret = ext4_check_inode_blockref(inode);
 	}
-	if (ret) {
-		brelse(bh);
+	if (ret)
 		goto bad_inode;
-	}
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -4926,7 +4921,6 @@ struct inode *ext4_iget(struct super_blo
 			init_special_inode(inode, inode->i_mode,
 			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
 	} else {
-		brelse(bh);
 		ret = -EIO;
 		ext4_error(inode->i_sb, __func__,
 			   "bogus i_mode (%o) for inode=%lu",
@@ -4939,6 +4933,7 @@ struct inode *ext4_iget(struct super_blo
 	return inode;
 
 bad_inode:
+	brelse(iloc.bh);
 	iget_failed(inode);
 	return ERR_PTR(ret);
 }


