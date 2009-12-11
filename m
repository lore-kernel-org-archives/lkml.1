Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbZLKEyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbZLKEyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbZLKEyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:54:01 -0500
Received: from kroah.org ([198.145.64.141]:36846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759073AbZLKEgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:03 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:52 2009
Message-Id: <20091211042751.864763427@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [35/90] ext4: Fix different block exchange issue in EXT4_IOC_MOVE_EXT
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0035-ext4-Fix-different-block-exchange-issue-in-EXT4_IOC_.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit c40ce3c9ea97425a12d7e44031a98fe50add6fc1)

If logical block offset of original file which is passed to
EXT4_IOC_MOVE_EXT is different from donor file's,
a calculation error occurs in ext4_calc_swap_extents(),
therefore wrong block is exchanged between original file and donor file.
As a result, we hit ext4_error() in check_block_validity().
To detect the logical offset difference in EXT4_IOC_MOVE_EXT,
add checks to mext_calc_swap_extents() and handle it as error,
since data exchange must be done between the same blocks in EXT4_IOC_MOVE_EXT.

Reported-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -597,8 +597,10 @@ out:
  * @orig_off:		block offset of original inode
  * @donor_off:		block offset of donor inode
  * @max_count:		the maximun length of extents
+ *
+ * Return 0 on success, or a negative error value on failure.
  */
-static void
+static int
 mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 			      struct ext4_extent *tmp_oext,
 			      ext4_lblk_t orig_off, ext4_lblk_t donor_off,
@@ -607,6 +609,19 @@ mext_calc_swap_extents(struct ext4_exten
 	ext4_lblk_t diff, orig_diff;
 	struct ext4_extent dext_old, oext_old;
 
+	BUG_ON(orig_off != donor_off);
+
+	/* original and donor extents have to cover the same block offset */
+	if (orig_off < le32_to_cpu(tmp_oext->ee_block) ||
+	    le32_to_cpu(tmp_oext->ee_block) +
+			ext4_ext_get_actual_len(tmp_oext) - 1 < orig_off)
+		return -ENODATA;
+
+	if (orig_off < le32_to_cpu(tmp_dext->ee_block) ||
+	    le32_to_cpu(tmp_dext->ee_block) +
+			ext4_ext_get_actual_len(tmp_dext) - 1 < orig_off)
+		return -ENODATA;
+
 	dext_old = *tmp_dext;
 	oext_old = *tmp_oext;
 
@@ -634,6 +649,8 @@ mext_calc_swap_extents(struct ext4_exten
 
 	copy_extent_status(&oext_old, tmp_dext);
 	copy_extent_status(&dext_old, tmp_oext);
+
+	return 0;
 }
 
 /**
@@ -690,8 +707,10 @@ mext_replace_branches(handle_t *handle,
 	dext = donor_path[depth].p_ext;
 	tmp_dext = *dext;
 
-	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
+	err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
 				      donor_off, count);
+	if (err)
+		goto out;
 
 	/* Loop for the donor extents */
 	while (1) {
@@ -760,9 +779,10 @@ mext_replace_branches(handle_t *handle,
 		}
 		tmp_dext = *dext;
 
-		mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
-					      donor_off,
-					      count - replaced_count);
+		err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
+					   donor_off, count - replaced_count);
+		if (err)
+			goto out;
 	}
 
 out:
@@ -1243,11 +1263,15 @@ ext4_move_extents(struct file *o_filp, s
 	ext_cur = holecheck_path[depth].p_ext;
 
 	/*
-	 * Get proper extent whose ee_block is beyond block_start
-	 * if block_start was within the hole.
+	 * Get proper starting location of block replacement if block_start was
+	 * within the hole.
 	 */
 	if (le32_to_cpu(ext_cur->ee_block) +
 		ext4_ext_get_actual_len(ext_cur) - 1 < block_start) {
+		/*
+		 * The hole exists between extents or the tail of
+		 * original file.
+		 */
 		last_extent = mext_next_extent(orig_inode,
 					holecheck_path, &ext_cur);
 		if (last_extent < 0) {
@@ -1260,8 +1284,12 @@ ext4_move_extents(struct file *o_filp, s
 			ret1 = last_extent;
 			goto out;
 		}
-	}
-	seq_start = block_start;
+		seq_start = le32_to_cpu(ext_cur->ee_block);
+	} else if (le32_to_cpu(ext_cur->ee_block) > block_start)
+		/* The hole exists at the beginning of original file. */
+		seq_start = le32_to_cpu(ext_cur->ee_block);
+	else
+		seq_start = block_start;
 
 	/* No blocks within the specified range. */
 	if (le32_to_cpu(ext_cur->ee_block) > block_end) {


