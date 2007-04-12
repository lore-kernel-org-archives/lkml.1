Return-Path: <linux-kernel-owner+w=401wt.eu-S1161515AbXDLCxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161515AbXDLCxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161529AbXDLCxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:53:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161515AbXDLCxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=jIm5osEv3rNIKnTvF7/TYZ2QeQMPsMZYZ4bEyjfYh4Ppes1xLHzzjM2m8wNNePfBomaWge+sraIp82KStpNb4IVgeTFzRzwFsG7tiahdB9bchjMd/AFZ3TDCJLOty08g4eyE+fZIpXWExLXX8H1lijm7IwOMU1DvRnRX0LPArZA=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.81259.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 10/17] mtd: convert page_read to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace page_read() with read_kmap_page()/__read_kmap_page().  This probably
fixes behaviour on highmem systems, since page_address() was being used
without kmap().  Also eliminate the need to re-take the page lock during
writes to the page.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/drivers/mtd/devices/block2mtd.c linux-2.6.21-rc5-mm4-test/drivers/mtd/devices/block2mtd.c
--- linux-2.6.21-rc5-mm4/drivers/mtd/devices/block2mtd.c	2007-04-05 17:14:24.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/drivers/mtd/devices/block2mtd.c	2007-04-06 01:59:19.000000000 -0700
@@ -39,12 +39,6 @@ struct block2mtd_dev {
 /* Static info about the MTD, used in cleanup_module */
 static LIST_HEAD(blkmtd_device_list);
 
-
-static struct page *page_read(struct address_space *mapping, int index)
-{
-	return read_mapping_page(mapping, index, NULL);
-}
-
 /* erase a specified part of the device */
 static int _block2mtd_erase(struct block2mtd_dev *dev, loff_t to, size_t len)
 {
@@ -56,23 +50,19 @@ static int _block2mtd_erase(struct block
 	u_long *max;
 
 	while (pages) {
-		page = page_read(mapping, index);
-		if (!page)
-			return -ENOMEM;
+		page = __read_kmap_page(mapping, index);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
 		max = page_address(page) + PAGE_SIZE;
 		for (p=page_address(page); p<max; p++)
 			if (*p != -1UL) {
-				lock_page(page);
 				memset(page_address(page), 0xff, PAGE_SIZE);
 				set_page_dirty(page);
-				unlock_page(page);
 				break;
 			}
 
-		page_cache_release(page);
+		put_locked_page(page);
 		pages--;
 		index++;
 	}
@@ -125,14 +115,12 @@ static int block2mtd_read(struct mtd_inf
 			cpylen = len;	// this page
 		len = len - cpylen;
 
-		page = page_read(dev->blkdev->bd_inode->i_mapping, index);
-		if (!page)
-			return -ENOMEM;
+		page = read_kmap_page(dev->blkdev->bd_inode->i_mapping, index);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
 		memcpy(buf, page_address(page) + offset, cpylen);
-		page_cache_release(page);
+		put_kmapped_page(page);
 
 		if (retlen)
 			*retlen += cpylen;
@@ -163,19 +151,15 @@ static int _block2mtd_write(struct block
 			cpylen = len;			// this page
 		len = len - cpylen;
 
-		page = page_read(mapping, index);
-		if (!page)
-			return -ENOMEM;
+		page = __read_kmap_page(mapping, index);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
 		if (memcmp(page_address(page)+offset, buf, cpylen)) {
-			lock_page(page);
 			memcpy(page_address(page) + offset, buf, cpylen);
 			set_page_dirty(page);
-			unlock_page(page);
 		}
-		page_cache_release(page);
+		put_locked_page(page);
 
 		if (retlen)
 			*retlen += cpylen;
