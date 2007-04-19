Return-Path: <linux-kernel-owner+w=401wt.eu-S1766858AbXDSQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766858AbXDSQgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766860AbXDSQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766859AbXDSQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:25 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 4/8] Enhance fallback functions in libs to support higher order pages
Date: Thu, 19 Apr 2007 09:35:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Fixup fallback functions

Fixup the fallback function in fs/libfs.c to be able to handle
higher order page cache pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/libfs.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6.21-rc7/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/libfs.c	2007-04-18 21:52:49.000000000 -0700
+++ linux-2.6.21-rc7/fs/libfs.c	2007-04-18 21:54:51.000000000 -0700
@@ -320,8 +320,8 @@ int simple_rename(struct inode *old_dir,
 
 int simple_readpage(struct file *file, struct page *page)
 {
-	clear_highpage(page);
-	flush_dcache_page(page);
+	clear_mapping_page(file->f_mapping, page);
+	flush_mapping_page(file->f_mapping, page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -331,11 +331,15 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
+		if (to - from != page_cache_size(file->f_mapping)) {
+			/*
+			 * Mapping to higher order pages need to be supported
+			 * if higher order pages can be in highmem
+			 */
 			void *kaddr = kmap_atomic(page, KM_USER0);
 			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
+			memset(kaddr + to, 0, page_cache_size(file->f_mapping) - to);
+			flush_mapping_page(file->f_mapping, page);
 			kunmap_atomic(kaddr, KM_USER0);
 		}
 	}
@@ -346,7 +350,7 @@ int simple_commit_write(struct file *fil
 			unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	loff_t pos = ((loff_t)page->index << page_cache_shift(file->f_mapping)) + to;
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
