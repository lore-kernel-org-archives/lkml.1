Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZIPWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZIPWd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZIPWdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:33:03 -0400
Received: from kroah.org ([198.145.64.141]:40943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZIPWcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:02 2009
Message-Id: <20090916222902.178026313@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>
Subject: [patch 10/24] udf: Use device size when drive reported bogus number of written blocks
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=udf-use-device-size-when-drive-reported-bogus-number-of-written-blocks.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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


