Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZLKEo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZLKEo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZLKEow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:44:52 -0500
Received: from kroah.org ([198.145.64.141]:37037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762203AbZLKEgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:39 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:14 2009
Message-Id: <20091211042814.022299856@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kazuya Mio <k-mio@sx.jp.nec.com>, Akira Fujita <a-fujita@rs.jp.nec.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [74/90] ext4: initialize moved_len before calling ext4_move_extents()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0074-ext4-initialize-moved_len-before-calling-ext4_move_e.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 446aaa6e7e993b38a6f21c6acfa68f3f1af3dbe3)

The move_extent.moved_len is used to pass back the number of exchanged
blocks count to user space.  Currently the caller must clear this
field; but we spend more code space checking for this requirement than
simply zeroing the field ourselves, so let's just make life easier for
everyone all around.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ioctl.c       |    1 +
 fs/ext4/move_extent.c |   14 +++-----------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -239,6 +239,7 @@ setversion_out:
 			}
 		}
 
+		me.moved_len = 0;
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
 		fput(donor_filp);
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -947,7 +947,6 @@ out2:
  * @orig_start:		logical start offset in block for orig
  * @donor_start:	logical start offset in block for donor
  * @len:		the number of blocks to be moved
- * @moved_len:		moved block length
  *
  * Check the arguments of ext4_move_extents() whether the files can be
  * exchanged with each other.
@@ -955,8 +954,8 @@ out2:
  */
 static int
 mext_check_arguments(struct inode *orig_inode,
-			  struct inode *donor_inode, __u64 orig_start,
-			  __u64 donor_start, __u64 *len, __u64 moved_len)
+		     struct inode *donor_inode, __u64 orig_start,
+		     __u64 donor_start, __u64 *len)
 {
 	ext4_lblk_t orig_blocks, donor_blocks;
 	unsigned int blkbits = orig_inode->i_blkbits;
@@ -1010,13 +1009,6 @@ mext_check_arguments(struct inode *orig_
 		return -EINVAL;
 	}
 
-	if (moved_len) {
-		ext4_debug("ext4 move extent: moved_len should be 0 "
-			"[ino:orig %lu, donor %lu]\n", orig_inode->i_ino,
-			donor_inode->i_ino);
-		return -EINVAL;
-	}
-
 	if ((orig_start > MAX_DEFRAG_SIZE) ||
 	    (donor_start > MAX_DEFRAG_SIZE) ||
 	    (*len > MAX_DEFRAG_SIZE) ||
@@ -1226,7 +1218,7 @@ ext4_move_extents(struct file *o_filp, s
 	double_down_write_data_sem(orig_inode, donor_inode);
 	/* Check the filesystem environment whether move_extent can be done */
 	ret1 = mext_check_arguments(orig_inode, donor_inode, orig_start,
-					donor_start, &len, *moved_len);
+				    donor_start, &len);
 	if (ret1)
 		goto out;
 


