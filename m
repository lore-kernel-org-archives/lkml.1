Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbZLKEsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbZLKEsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbZLKEgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:24 -0500
Received: from kroah.org ([198.145.64.141]:36723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759500AbZLKEfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:47 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:36 2009
Message-Id: <20091211042736.230715168@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [17/90] ext4: Fix wrong comparisons in mext_check_arguments()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0017-ext4-Fix-wrong-comparisons-in-mext_check_arguments.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 70d5d3dcea47c16058d2b093c29e07fdf61b56ad)

The mext_check_arguments() function in move_extents.c has wrong
comparisons.  orig_start which is passed from user-space is block
unit, but i_size of inode is byte unit, therefore the checks do not
work fine.  This mis-check leads to the overflow of 'len' and then
hits BUG_ON() in ext4_move_extents().  The patch fixes this issue.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Reviewed-by: Greg Freemyer <greg.freemyer@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -898,6 +898,10 @@ mext_check_arguments(struct inode *orig_
 			  struct inode *donor_inode, __u64 orig_start,
 			  __u64 donor_start, __u64 *len, __u64 moved_len)
 {
+	ext4_lblk_t orig_blocks, donor_blocks;
+	unsigned int blkbits = orig_inode->i_blkbits;
+	unsigned int blocksize = 1 << blkbits;
+
 	/* Regular file check */
 	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
 		ext4_debug("ext4 move extent: The argument files should be "
@@ -972,43 +976,47 @@ mext_check_arguments(struct inode *orig_
 	}
 
 	if (orig_inode->i_size > donor_inode->i_size) {
-		if (orig_start >= donor_inode->i_size) {
+		donor_blocks = (donor_inode->i_size + blocksize - 1) >> blkbits;
+		/* TODO: eliminate this artificial restriction */
+		if (orig_start >= donor_blocks) {
 			ext4_debug("ext4 move extent: orig start offset "
-			"[%llu] should be less than donor file size "
-			"[%lld] [ino:orig %lu, donor_inode %lu]\n",
-			orig_start, donor_inode->i_size,
+			"[%llu] should be less than donor file blocks "
+			"[%u] [ino:orig %lu, donor %lu]\n",
+			orig_start, donor_blocks,
 			orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}
 
-		if (orig_start + *len > donor_inode->i_size) {
+		/* TODO: eliminate this artificial restriction */
+		if (orig_start + *len > donor_blocks) {
 			ext4_debug("ext4 move extent: End offset [%llu] should "
-				"be less than donor file size [%lld]."
-				"So adjust length from %llu to %lld "
+				"be less than donor file blocks [%u]."
+				"So adjust length from %llu to %llu "
 				"[ino:orig %lu, donor %lu]\n",
-				orig_start + *len, donor_inode->i_size,
-				*len, donor_inode->i_size - orig_start,
+				orig_start + *len, donor_blocks,
+				*len, donor_blocks - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			*len = donor_inode->i_size - orig_start;
+			*len = donor_blocks - orig_start;
 		}
 	} else {
-		if (orig_start >= orig_inode->i_size) {
+		orig_blocks = (orig_inode->i_size + blocksize - 1) >> blkbits;
+		if (orig_start >= orig_blocks) {
 			ext4_debug("ext4 move extent: start offset [%llu] "
-				"should be less than original file size "
-				"[%lld] [inode:orig %lu, donor %lu]\n",
-				 orig_start, orig_inode->i_size,
+				"should be less than original file blocks "
+				"[%u] [ino:orig %lu, donor %lu]\n",
+				 orig_start, orig_blocks,
 				orig_inode->i_ino, donor_inode->i_ino);
 			return -EINVAL;
 		}
 
-		if (orig_start + *len > orig_inode->i_size) {
+		if (orig_start + *len > orig_blocks) {
 			ext4_debug("ext4 move extent: Adjust length "
-				"from %llu to %lld. Because it should be "
-				"less than original file size "
+				"from %llu to %llu. Because it should be "
+				"less than original file blocks "
 				"[ino:orig %lu, donor %lu]\n",
-				*len, orig_inode->i_size - orig_start,
+				*len, orig_blocks - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			*len = orig_inode->i_size - orig_start;
+			*len = orig_blocks - orig_start;
 		}
 	}
 


