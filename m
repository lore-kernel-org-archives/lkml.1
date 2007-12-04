Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXLDHJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXLDHJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXLDHI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:08:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:48666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXLDHI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:08:57 -0500
Date: Tue, 4 Dec 2007 08:08:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-ID: <20071204070856.GF31482@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <20071203222903.c820707b.akpm@linux-foundation.org> <20071204070131.GE31482@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204070131.GE31482@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 08:01:31AM +0100, Nick Piggin wrote:
> Thanks for the review, I'll post an incremental patch in a sec.
 

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -56,7 +56,7 @@ struct brd_device {
  */
 static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 {
-	unsigned long idx;
+	pgoff_t idx;
 	struct page *page;
 
 	/*
@@ -87,13 +87,17 @@ static struct page *brd_lookup_page(stru
  */
 static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 {
-	unsigned long idx;
+	pgoff_t idx;
 	struct page *page;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
 		return page;
 
+	/*
+	 * Must use NOIO because we don't want to recurse back into the
+	 * block or filesystem layers from page reclaim.
+	 */
 	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
 	if (!page)
 		return NULL;
@@ -148,6 +152,11 @@ static void brd_free_pages(struct brd_de
 
 		pos++;
 
+		/*
+		 * This assumes radix_tree_gang_lookup always returns as
+		 * many pages as possible. If the radix-tree code changes,
+		 * so will this have to.
+		 */
 	} while (nr_pages == FREE_BATCH);
 }
 
@@ -159,7 +168,7 @@ static int copy_to_brd_setup(struct brd_
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	if (!brd_insert_page(brd, sector))
 		return -ENOMEM;
 	if (copy < n) {
@@ -181,7 +190,7 @@ static void copy_to_brd(struct brd_devic
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
 
@@ -213,7 +222,7 @@ static void copy_from_brd(void *dst, str
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
 		src = kmap_atomic(page, KM_USER1);
@@ -318,6 +327,9 @@ static int brd_ioctl(struct inode *inode
 		/*
 		 * Invalidate the cache first, so it isn't written
 		 * back to the device.
+		 *
+		 * Another thread might instantiate more buffercache here,
+		 * but there is not much we can do to close that race.
 		 */
 		invalidate_bh_lrus();
 		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
