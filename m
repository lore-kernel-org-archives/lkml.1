Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXJILWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXJILWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJILV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:21:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:22791 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbXJILV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:21:58 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ramdisk: fix zeroed ramdisk pages on memory pressure
Date: Tue, 9 Oct 2007 13:21:46 +0200
User-Agent: KMail/1.9.7
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091321.46891.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

We have seen ramdisk based install systems, where some pages of mapped 
libraries and programs were suddendly zeroed under memory pressure. This 
should not happen, as the ramdisk avoids freeing its pages by keeping them 
dirty all the time.

It turns out that there is a case, where the VM makes a ramdisk page clean, 
without telling the ramdisk driver.
On memory pressure shrink_zone runs and it starts to run shrink_active_list. 
There is a check for buffer_heads_over_limit, and if true, pagevec_strip is 
called. pagevec_strip calls try_to_release_page. If the mapping has no 
releasepage callback, try_to_free_buffers is called. try_to_free_buffers has 
now a special logic for some file systems to make a dirty page clean, if all 
buffers are clean. Thats what happened in our test case.

The solution is to provide a noop-releasepage callback for the ramdisk driver.
This avoids try_to_free_buffers for ramdisk pages. 

To trigger the problem, you have to make buffer_heads_over_limit true, which
means:
- lower max_buffer_heads 
or
- have a system with lots of high memory

Andrew, if there are no objections - please apply. The patch applies against
2.6.23-rc9.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 drivers/block/rd.c |   13 +++++++++++++
 1 files changed, 13 insertions(+)

Index: linux-2.6/drivers/block/rd.c
===================================================================
--- linux-2.6.orig/drivers/block/rd.c
+++ linux-2.6/drivers/block/rd.c
@@ -189,6 +189,18 @@ static int ramdisk_set_page_dirty(struct
 	return 0;
 }
 
+/*
+ * releasepage is called by pagevec_strip/try_to_release_page if
+ * buffers_heads_over_limit is true. Without a releasepage function
+ * try_to_free_buffers is called instead. That can unset the dirty
+ * bit of our ram disk pages, which will be eventually freed, even
+ * if the page is still in use.
+ */
+static int ramdisk_releasepage(struct page *page, gfp_t dummy)
+{
+	return 0;
+}
+
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= ramdisk_prepare_write,
@@ -196,6 +208,7 @@ static const struct address_space_operat
 	.writepage	= ramdisk_writepage,
 	.set_page_dirty	= ramdisk_set_page_dirty,
 	.writepages	= ramdisk_writepages,
+	.releasepage	= ramdisk_releasepage,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
