Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbZLKEgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbZLKEgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbZLKEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:47 -0500
Received: from kroah.org ([198.145.64.141]:36839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760629AbZLKEgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:02 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:51 2009
Message-Id: <20091211042751.274203312@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [34/90] ext4: Add null extent check to ext_get_path
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0034-ext4-Add-null-extent-check-to-ext_get_path.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 347fa6f1c7cb5df2b38d3c9167cfe242ce0cd1da)

There is the possibility that path structure which is taken
by ext4_ext_find_extent() indicates null extents.
Because during data block exchanging in ext4_move_extents(),
constitution of an extent tree may be changed.
As a solution, the patch adds null extent check
to ext_get_path().

Reported-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -39,7 +39,9 @@ get_ext_path(struct inode *inode, ext4_l
 	if (IS_ERR(*path)) {
 		ret = PTR_ERR(*path);
 		*path = NULL;
-	}
+	} else if ((*path)[ext_depth(inode)].p_ext == NULL)
+		ret = -ENODATA;
+
 	return ret;
 }
 
@@ -316,7 +318,7 @@ mext_insert_across_blocks(handle_t *hand
 
 	if (new_flag) {
 		err = get_ext_path(orig_inode, eblock, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;
 
 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -327,7 +329,7 @@ mext_insert_across_blocks(handle_t *hand
 	if (end_flag) {
 		err = get_ext_path(orig_inode,
 				le32_to_cpu(end_ext->ee_block) - 1, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;
 
 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -673,12 +675,12 @@ mext_replace_branches(handle_t *handle,
 
 	/* Get the original extent for the block "orig_off" */
 	err = get_ext_path(orig_inode, orig_off, &orig_path);
-	if (orig_path == NULL)
+	if (err)
 		goto out;
 
 	/* Get the donor extent for the head */
 	err = get_ext_path(donor_inode, donor_off, &donor_path);
-	if (donor_path == NULL)
+	if (err)
 		goto out;
 	depth = ext_depth(orig_inode);
 	oext = orig_path[depth].p_ext;
@@ -733,7 +735,7 @@ mext_replace_branches(handle_t *handle,
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		err = get_ext_path(orig_inode, orig_off, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(orig_inode);
 		oext = orig_path[depth].p_ext;
@@ -747,7 +749,7 @@ mext_replace_branches(handle_t *handle,
 		if (donor_path)
 			ext4_ext_drop_refs(donor_path);
 		err = get_ext_path(donor_inode, donor_off, &donor_path);
-		if (donor_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(donor_inode);
 		dext = donor_path[depth].p_ext;
@@ -1221,7 +1223,7 @@ ext4_move_extents(struct file *o_filp, s
 					donor_start, &len, *moved_len);
 	mext_double_up_read(orig_inode, donor_inode);
 	if (ret1)
-		goto out2;
+		goto out;
 
 	file_end = (i_size_read(orig_inode) - 1) >> orig_inode->i_blkbits;
 	block_end = block_start + len - 1;
@@ -1229,20 +1231,16 @@ ext4_move_extents(struct file *o_filp, s
 		len -= block_end - file_end;
 
 	ret1 = get_ext_path(orig_inode, block_start, &orig_path);
-	if (orig_path == NULL)
-		goto out2;
+	if (ret1)
+		goto out;
 
 	/* Get path structure to check the hole */
 	ret1 = get_ext_path(orig_inode, block_start, &holecheck_path);
-	if (holecheck_path == NULL)
+	if (ret1)
 		goto out;
 
 	depth = ext_depth(orig_inode);
 	ext_cur = holecheck_path[depth].p_ext;
-	if (ext_cur == NULL) {
-		ret1 = -EINVAL;
-		goto out;
-	}
 
 	/*
 	 * Get proper extent whose ee_block is beyond block_start
@@ -1371,7 +1369,7 @@ ext4_move_extents(struct file *o_filp, s
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
 		ret1 = get_ext_path(orig_inode, seq_start, &holecheck_path);
-		if (holecheck_path == NULL)
+		if (ret1)
 			break;
 		depth = holecheck_path->p_depth;
 
@@ -1379,7 +1377,7 @@ ext4_move_extents(struct file *o_filp, s
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		ret1 = get_ext_path(orig_inode, seq_start, &orig_path);
-		if (orig_path == NULL)
+		if (ret1)
 			break;
 
 		ext_cur = holecheck_path[depth].p_ext;
@@ -1396,7 +1394,7 @@ out:
 		ext4_ext_drop_refs(holecheck_path);
 		kfree(holecheck_path);
 	}
-out2:
+
 	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
 
 	if (ret1)


