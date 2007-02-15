Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbXBOBdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbXBOBdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXBOBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:33:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXBOBdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:33:07 -0500
Date: Thu, 15 Feb 2007 02:33:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] fs: fix nobh data leak
Message-ID: <20070215013306.GI29797@wotan.suse.de>
References: <20070215013229.GH29797@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215013229.GH29797@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


nobh_prepare_write leaks data similarly to how simple_prepare_write did. Fix
by not marking the page uptodate until nobh_commit_write time. Again, this
could break weird use-cases, but none appear to exist in the tree.

We can safely remove the set_page_dirty, because as the comment says,
nobh_commit_write does set_page_dirty. If a filesystem wants to allocate
backing store for a page dirtied via mmap, page_mkwrite is the suggested
approach.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -2245,7 +2245,6 @@ int nobh_prepare_write(struct page *page
 	int i;
 	int ret = 0;
 	int is_mapped_to_disk = 1;
-	int dirtied_it = 0;
 
 	if (PageMappedToDisk(page))
 		return 0;
@@ -2282,14 +2281,10 @@ int nobh_prepare_write(struct page *page
 			continue;
 		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
 			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_start < from) {
+			if (block_start < from)
 				memset(kaddr+block_start, 0, from-block_start);
-				dirtied_it = 1;
-			}
-			if (block_end > to) {
+			if (block_end > to)
 				memset(kaddr + to, 0, block_end - to);
-				dirtied_it = 1;
-			}
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 			continue;
@@ -2344,17 +2339,6 @@ int nobh_prepare_write(struct page *page
 
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
-	SetPageUptodate(page);
-
-	/*
-	 * Setting the page dirty here isn't necessary for the prepare_write
-	 * function - commit_write will do that.  But if/when this function is
-	 * used within the pagefault handler to ensure that all mmapped pages
-	 * have backing space in the filesystem, we will need to dirty the page
-	 * if its contents were altered.
-	 */
-	if (dirtied_it)
-		set_page_dirty(page);
 
 	return 0;
 
@@ -2384,6 +2368,7 @@ int nobh_commit_write(struct file *file,
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
