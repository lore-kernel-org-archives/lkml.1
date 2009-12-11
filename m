Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbZLKEtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbZLKEtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934412AbZLKEtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:49:08 -0500
Received: from kroah.org ([198.145.64.141]:36976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761271AbZLKEgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:22 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:04 2009
Message-Id: <20091211042803.809439347@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [56/90] ext4: Fix return value of ext4_split_unwritten_extents() to fix direct I/O
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0056-ext4-Fix-return-value-of-ext4_split_unwritten_extent.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit ba230c3f6dc88ec008806adb27b12088486d508e)

To prepare for a direct I/O write, we need to split the unwritten
extents before submitting the I/O.  When no extents needed to be
split, ext4_split_unwritten_extents() was incorrectly returning 0
instead of the size of uninitialized extents. This bug caused the
wrong return value sent back to VFS code when it gets called from
async IO path, leading to an unnecessary fall back to buffered IO.

This bug also hid the fact that the check to see whether or not a
split would be necessary was incorrect; we can only skip splitting the
extent if the write completely covers the uninitialized extent.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2784,6 +2784,8 @@ fix_extent_len:
  * into three uninitialized extent(at most). After IO complete, the part
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
+ *
+ * Returns the size of uninitialized extent to be written on success.
  */
 static int ext4_split_unwritten_extents(handle_t *handle,
 					struct inode *inode,
@@ -2801,7 +2803,6 @@ static int ext4_split_unwritten_extents(
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
 	int err = 0;
-	int ret = 0;
 
 	ext_debug("ext4_split_unwritten_extents: inode %lu,"
 		  "iblock %llu, max_blocks %u\n", inode->i_ino,
@@ -2819,12 +2820,12 @@ static int ext4_split_unwritten_extents(
 	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
 
 	/*
- 	 * if the entire unintialized extent length less than
- 	 * the size of extent to write, there is no need to split
- 	 * uninitialized extent
+ 	 * If the uninitialized extent begins at the same logical
+ 	 * block where the write begins, and the write completely
+ 	 * covers the extent, then we don't need to split it.
  	 */
- 	if (allocated <= max_blocks)
-		return ret;
+	if ((iblock == ee_block) && (allocated <= max_blocks))
+		return allocated;
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)


