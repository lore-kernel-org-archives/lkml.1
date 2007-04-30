Return-Path: <linux-kernel-owner+w=401wt.eu-S1423064AbXD3GOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064AbXD3GOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423065AbXD3GOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:14:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423064AbXD3GOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:14:41 -0400
Date: Sun, 29 Apr 2007 23:14:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: Nate Diller <nate.diller@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Message-ID: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of places where kmap_atomic is surrounding two
memory operations. Usually only one of them is performed. So it is
possible to also use zero_user_page there.

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   29 ++++++++++-------------------
 fs/libfs.c  |   12 ++++++------
 2 files changed, 16 insertions(+), 25 deletions(-)

Index: linux-2.6.21-rc7-mm1/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7-mm1.orig/fs/buffer.c	2007-04-25 00:20:35.000000000 -0700
+++ linux-2.6.21-rc7-mm1/fs/buffer.c	2007-04-25 00:24:05.000000000 -0700
@@ -1796,19 +1796,12 @@ static int __block_prepare_write(struct 
 					set_buffer_uptodate(bh);
 					continue;
 				}
-				if (block_end > to || block_start < from) {
-					void *kaddr;
-
-					kaddr = kmap_atomic(page, KM_USER0);
-					if (block_end > to)
-						memset(kaddr+to, 0,
-							block_end-to);
-					if (block_start < from)
-						memset(kaddr+block_start,
-							0, from-block_start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
-				}
+				if (block_end > to)
+					zero_user_page(page, to,
+						block_end - to, KM_USER0);
+				if (block_start < from)
+					zero_user_page(page, block_start,
+						from - block_start, KM_USER0);
 				continue;
 			}
 		}
@@ -2224,7 +2217,6 @@ int nobh_prepare_write(struct page *page
 	unsigned block_in_page;
 	unsigned block_start;
 	sector_t block_in_file;
-	char *kaddr;
 	int nr_reads = 0;
 	int i;
 	int ret = 0;
@@ -2264,13 +2256,12 @@ int nobh_prepare_write(struct page *page
 		if (PageUptodate(page))
 			continue;
 		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
-			kaddr = kmap_atomic(page, KM_USER0);
 			if (block_start < from)
-				memset(kaddr+block_start, 0, from-block_start);
+				zero_user_page(page, block_start,
+					from - block_start, KM_USER0);
 			if (block_end > to)
-				memset(kaddr + to, 0, block_end - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+				zero_user_page(page, to,
+					block_end - to, KM_USER0);
 			continue;
 		}
 		if (buffer_uptodate(&map_bh))
Index: linux-2.6.21-rc7-mm1/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7-mm1.orig/fs/libfs.c	2007-04-25 00:24:10.000000000 -0700
+++ linux-2.6.21-rc7-mm1/fs/libfs.c	2007-04-25 00:25:56.000000000 -0700
@@ -337,12 +337,12 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+		if (to - from != PAGE_CACHE_SIZE)
+			if (from)
+				zero_user_page(page, 0, from, KM_USER0);
+			if (to < PAGE_CACHE_SIZE)
+				zero_user_page(page, to,
+					PAGE_CACHE_SIZE - to, KM_USER0);
 		}
 	}
 	return 0;
