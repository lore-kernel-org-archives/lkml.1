Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbZLKEqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbZLKEqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbZLKEpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:45:21 -0500
Received: from kroah.org ([198.145.64.141]:37073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761562AbZLKEgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:39 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:13 2009
Message-Id: <20091211042813.423360988@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [73/90] ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0073-ext4-Fix-double-free-of-blocks-with-EXT4_IOC_MOVE_EX.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 94d7c16cbbbd0e03841fcf272bcaf0620ad39618)

At the beginning of ext4_move_extent(), we call
ext4_discard_preallocations() to discard inode PAs of orig and donor
inodes.  But in the following case, blocks can be double freed, so
move ext4_discard_preallocations() to the end of ext4_move_extents().

1. Discard inode PAs of orig and donor inodes with
   ext4_discard_preallocations() in ext4_move_extents().

   orig : [ DATA1 ]
   donor: [ DATA2 ]

2. While data blocks are exchanging between orig and donor inodes, new
   inode PAs is created to orig by other process's block allocation.
   (Since there are semaphore gaps in ext4_move_extents().)  And new
   inode PAs is used partially (2-1).

   2-1 Create new inode PAs to orig inode
   orig : [ DATA1 | used PA1 | free PA1 ]
   donor: [ DATA2 ]

3. Donor inode which has old orig inode's blocks is deleted after
   EXT4_IOC_MOVE_EXT finished (3-1, 3-2).  So the block bitmap
   corresponds to old orig inode's blocks are freed.

   3-1 After EXT4_IOC_MOVE_EXT finished
   orig : [ DATA2 |  free PA1 ]
   donor: [ DATA1 |  used PA1 ]

   3-2 Delete donor inode
   orig : [ DATA2 |  free PA1 ]
   donor: [ FREE SPACE(DATA1) | FREE SPACE(used PA1) ]

4. The double-free of blocks is occurred, when close() is called to
   orig inode.  Because ext4_discard_preallocations() for orig inode
   frees used PA1 and free PA1, though used PA1 is already freed in 3.

   4-1 Double-free of blocks is occurred
   orig : [ DATA2 |  FREE SPACE(free PA1) ]
   donor: [ FREE SPACE(DATA1) | DOUBLE FREE(used PA1) ]

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1289,10 +1289,6 @@ ext4_move_extents(struct file *o_filp, s
 			 ext4_ext_get_actual_len(ext_cur), block_end + 1) -
 		     max(le32_to_cpu(ext_cur->ee_block), block_start);
 
-	/* Discard preallocations of two inodes */
-	ext4_discard_preallocations(orig_inode);
-	ext4_discard_preallocations(donor_inode);
-
 	while (!last_extent && le32_to_cpu(ext_cur->ee_block) <= block_end) {
 		seq_blocks += add_blocks;
 
@@ -1410,6 +1406,11 @@ ext4_move_extents(struct file *o_filp, s
 
 	}
 out:
+	if (*moved_len) {
+		ext4_discard_preallocations(orig_inode);
+		ext4_discard_preallocations(donor_inode);
+	}
+
 	if (orig_path) {
 		ext4_ext_drop_refs(orig_path);
 		kfree(orig_path);


