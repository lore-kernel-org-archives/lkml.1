Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXKFL0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXKFL0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXKFL0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:26:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXKFL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:26:16 -0500
Date: Tue, 6 Nov 2007 12:26:15 +0100
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Future of Linux 2.6.22.y series
Message-ID: <20071106112615.GG32704@atrey.karlin.mff.cuni.cz>
References: <20071105181332.GB28628@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20071105181332.GB28628@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> For the last release, I stated that I thought the 2.6.22.12 release
> would be the last one in the 2.6.22.y series.  Since then, I've received
> a number of other patches that would be nice to have in the .22.y tree.
> 
> So, for a while, I'll keep the 2.6.22.y tree open, doing new releases
> every once in a while as they accumulate.  I do this, for no other than
> the selfish reason that I use it every day on my openSuSE 10.3 boxes as
> that is the kernel base that release is on :)
  In that case you might be interested in picking up the attached fix :)
I don't know if you already didn't get it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ramdisk-2.6.23-corruption_fix.diff"

Subject: [PATCH] rd: fix data corruption on memory pressure
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

The simplest solution is to provide a noop-releasepage callback for the
ramdisk driver. This avoids try_to_free_buffers for ramdisk pages. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/block/rd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

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

--ikeVEW9yuYc//A+q--
