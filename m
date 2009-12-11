Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbZLKEhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbZLKEhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbZLKEhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:15 -0500
Received: from kroah.org ([198.145.64.141]:36968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761055AbZLKEgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:21 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:03 2009
Message-Id: <20091211042803.182022052@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [55/90] ext4: code clean up for dio fallocate handling
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0055-ext4-code-clean-up-for-dio-fallocate-handling.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 4b70df181611012a3556f017b57dfcef7e1d279f)

The ext4_debug() call in ext4_end_io_dio() should be moved after the
check to make sure that io_end is non-NULL.

The comment above ext4_get_block_dio_write() ("Maximum number of
blocks...") is a duplicate; the original and correct comment is above
the #define DIO_MAX_BLOCKS up above.

Based on review comments from Curt Wohlgemuth.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3440,8 +3440,6 @@ out:
 	return ret;
 }
 
-/* Maximum number of blocks we map for direct IO at once. */
-
 static int ext4_get_block_dio_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create)
 {
@@ -3649,13 +3647,14 @@ static void ext4_end_io_dio(struct kiocb
         ext4_io_end_t *io_end = iocb->private;
 	struct workqueue_struct *wq;
 
+	/* if not async direct IO or dio with 0 bytes write, just return */
+	if (!io_end || !size)
+		return;
+
 	ext_debug("ext4_end_io_dio(): io_end 0x%p"
 		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
  		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
-	/* if not async direct IO or dio with 0 bytes write, just return */
-	if (!io_end || !size)
-		return;
 
 	/* if not aio dio with unwritten extents, just free io and return */
 	if (io_end->flag != DIO_AIO_UNWRITTEN){


