Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZIPWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZIPWSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZIPWSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:18:35 -0400
Received: from kroah.org ([198.145.64.141]:49794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbZIPWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:18:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:15:06 2009
Message-Id: <20090916221506.226614681@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:13:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>
Subject: [patch 04/10] udf: Use device size when drive reported bogus number of written blocks
References: <20090916221320.283781925@mini.kroah.org>
Content-Disposition: inline; filename=udf-use-device-size-when-drive-reported-bogus-number-of-written-blocks.patch
In-Reply-To: <20090916221529.GA28162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Kara <jack@suse.cz>

commit 24a5d59f3477bcff4c069ff4d0ca9a3e037d0235 upstream.

Some drives report 0 as the number of written blocks when there are some blocks
recorded. Use device size in such case so that we can automagically mount such
media.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/udf/lowlevel.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -56,7 +56,12 @@ unsigned long udf_get_last_block(struct 
 	struct block_device *bdev = sb->s_bdev;
 	unsigned long lblock = 0;
 
-	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long) &lblock))
+	/*
+	 * ioctl failed or returned obviously bogus value?
+	 * Try using the device size...
+	 */
+	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long) &lblock) ||
+	    lblock == 0)
 		lblock = bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 
 	if (lblock)


