Return-Path: <linux-kernel-owner+w=401wt.eu-S1423089AbXD3HEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089AbXD3HEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423094AbXD3HEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:04:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50618 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423089AbXD3HEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:04:31 -0400
Date: Mon, 30 Apr 2007 00:04:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: akpm@linux-foundation.org, Nate Diller <nate.diller@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
In-Reply-To: <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
 <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Satyam Sharma wrote:

> A simple "Replace open-coded kmap_atomic() and kunmap_atomic()
> surrounding two memory clear operations with zero_user_page(), as both
> memory operations act on the same page" would have been better.

Ok.

> Perhaps you were more worried with the additional overhead of two
> successive kmap_atomic() and kunmap_atomic() calls for the same page
> in the two resulting zero_user_page()'s (if both conditions evaluate
> to true for the same page), but that would still be a price to pay to
> replace the current open-coding.

Right.

> Either you've fixed an issue (in which case this should've been a
> different patch with the accompanying explanation) or else I don't see
> what we gain with the additional if's. Again, we still do incur the
> overhead of two successive kmap_atomic() / kunmap_atomic() calls for
> the same page in order to replace the open-coding.

We also flush the page twice. I think its worth the savings.
 
Revised patch (fixes missing { due to missing quilt refresh):


zero_user_page: Use it in more places

Replace open-coded kmap_atomic() and kunmap_atomic()
surrounding two memory clear operations with zero_user_page(), as both
memory operations act on the same page.

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   29 ++++++++++-------------------
 fs/libfs.c  |   10 +++++-----
 2 files changed, 15 insertions(+), 24 deletions(-)

Index: linux-2.6.21-rc7-mm2/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/fs/buffer.c	2007-04-27 22:51:27.000000000 -0700
+++ linux-2.6.21-rc7-mm2/fs/buffer.c	2007-04-29 23:58:48.000000000 -0700
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
Index: linux-2.6.21-rc7-mm2/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/fs/libfs.c	2007-04-27 22:51:27.000000000 -0700
+++ linux-2.6.21-rc7-mm2/fs/libfs.c	2007-04-27 22:55:12.000000000 -0700
@@ -338,11 +338,11 @@ int simple_prepare_write(struct file *fi
 {
 	if (!PageUptodate(page)) {
 		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			if (from)
+				zero_user_page(page, 0, from, KM_USER0);
+			if (to < PAGE_CACHE_SIZE)
+				zero_user_page(page, to,
+					PAGE_CACHE_SIZE - to, KM_USER0);
 		}
 	}
 	return 0;
