Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbZLKEh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbZLKEh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbZLKEh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:26 -0500
Received: from kroah.org ([198.145.64.141]:37042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762222AbZLKEgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:40 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:15 2009
Message-Id: <20091211042814.628012070@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [75/90] ext4: move_extent_per_page() cleanup
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0075-ext4-move_extent_per_page-cleanup.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit ac48b0a1d068887141581bea8285de5fcab182b0)

Integrate duplicate lines (acquire/release semaphore and invalidate
extent cache in move_extent_per_page()) into mext_replace_branches(),
to reduce source and object code size.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -660,6 +660,9 @@ mext_replace_branches(handle_t *handle,
 	int replaced_count = 0;
 	int dext_alen;
 
+	/* Protect extent trees against block allocations via delalloc */
+	double_down_write_data_sem(orig_inode, donor_inode);
+
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
@@ -755,6 +758,11 @@ out:
 		kfree(donor_path);
 	}
 
+	ext4_ext_invalidate_cache(orig_inode);
+	ext4_ext_invalidate_cache(donor_inode);
+
+	double_up_write_data_sem(orig_inode, donor_inode);
+
 	return replaced_count;
 }
 
@@ -820,19 +828,9 @@ move_extent_per_page(struct file *o_filp
 	 * Just swap data blocks between orig and donor.
 	 */
 	if (uninit) {
-		/*
-		 * Protect extent trees against block allocations
-		 * via delalloc
-		 */
-		double_down_write_data_sem(orig_inode, donor_inode);
 		replaced_count = mext_replace_branches(handle, orig_inode,
 						donor_inode, orig_blk_offset,
 						block_len_in_page, err);
-
-		/* Clear the inode cache not to refer to the old data */
-		ext4_ext_invalidate_cache(orig_inode);
-		ext4_ext_invalidate_cache(donor_inode);
-		double_up_write_data_sem(orig_inode, donor_inode);
 		goto out2;
 	}
 
@@ -880,8 +878,6 @@ move_extent_per_page(struct file *o_filp
 	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);
 
-	/* Protect extent trees against block allocations via delalloc */
-	double_down_write_data_sem(orig_inode, donor_inode);
 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
 					&err2);
@@ -890,18 +886,10 @@ move_extent_per_page(struct file *o_filp
 			block_len_in_page = replaced_count;
 			replaced_size =
 				block_len_in_page << orig_inode->i_blkbits;
-		} else {
-			double_up_write_data_sem(orig_inode, donor_inode);
+		} else
 			goto out;
-		}
 	}
 
-	/* Clear the inode cache not to refer to the old data */
-	ext4_ext_invalidate_cache(orig_inode);
-	ext4_ext_invalidate_cache(donor_inode);
-
-	double_up_write_data_sem(orig_inode, donor_inode);
-
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);
 


