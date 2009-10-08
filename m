Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZJHX1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZJHX1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZJHX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:27:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096AbZJHX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:56 -0400
Message-Id: <20091008232528.272013520@chello.nl>
References: <20091008232226.768382977@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 09 Oct 2009 01:22:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/4] mm: strictly nested kmap_atomic
Content-Disposition: inline; filename=kmap-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure kmap_atomic usage is strictly nested

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 crypto/async_tx/async_memcpy.c |    2 +-
 crypto/blkcipher.c             |    2 +-
 drivers/block/loop.c           |    4 ++--
 include/linux/highmem.h        |    4 ++--
 kernel/power/snapshot.c        |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/crypto/async_tx/async_memcpy.c
===================================================================
--- linux-2.6.orig/crypto/async_tx/async_memcpy.c
+++ linux-2.6/crypto/async_tx/async_memcpy.c
@@ -83,8 +83,8 @@ async_memcpy(struct page *dest, struct p
 
 		memcpy(dest_buf, src_buf, len);
 
-		kunmap_atomic(dest_buf, KM_USER0);
 		kunmap_atomic(src_buf, KM_USER1);
+		kunmap_atomic(dest_buf, KM_USER0);
 
 		async_tx_sync_epilog(submit);
 	}
Index: linux-2.6/crypto/blkcipher.c
===================================================================
--- linux-2.6.orig/crypto/blkcipher.c
+++ linux-2.6/crypto/blkcipher.c
@@ -89,9 +89,9 @@ static inline unsigned int blkcipher_don
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		blkcipher_unmap_dst(walk);
 	} else if (!(walk->flags & BLKCIPHER_WALK_PHYS)) {
-		blkcipher_unmap_src(walk);
 		if (walk->flags & BLKCIPHER_WALK_DIFF)
 			blkcipher_unmap_dst(walk);
+		blkcipher_unmap_src(walk);
 	}
 
 	scatterwalk_advance(&walk->in, n);
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -99,8 +99,8 @@ static int transfer_none(struct loop_dev
 	else
 		memcpy(raw_buf, loop_buf, size);
 
-	kunmap_atomic(raw_buf, KM_USER0);
 	kunmap_atomic(loop_buf, KM_USER1);
+	kunmap_atomic(raw_buf, KM_USER0);
 	cond_resched();
 	return 0;
 }
@@ -128,8 +128,8 @@ static int transfer_xor(struct loop_devi
 	for (i = 0; i < size; i++)
 		*out++ = *in++ ^ key[(i & 511) % keysize];
 
-	kunmap_atomic(raw_buf, KM_USER0);
 	kunmap_atomic(loop_buf, KM_USER1);
+	kunmap_atomic(raw_buf, KM_USER0);
 	cond_resched();
 	return 0;
 }
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h
+++ linux-2.6/include/linux/highmem.h
@@ -191,8 +191,8 @@ static inline void copy_user_highpage(st
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
 	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vfrom, KM_USER0);
 }
 
 #endif
@@ -204,8 +204,8 @@ static inline void copy_highpage(struct 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vfrom, KM_USER0);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -978,8 +978,8 @@ static void copy_data_page(unsigned long
 		src = kmap_atomic(s_page, KM_USER0);
 		dst = kmap_atomic(d_page, KM_USER1);
 		do_copy_page(dst, src);
-		kunmap_atomic(src, KM_USER0);
 		kunmap_atomic(dst, KM_USER1);
+		kunmap_atomic(src, KM_USER0);
 	} else {
 		if (PageHighMem(d_page)) {
 			/* Page pointed to by src may contain some kernel
@@ -2253,8 +2253,8 @@ swap_two_pages_data(struct page *p1, str
 	memcpy(buf, kaddr1, PAGE_SIZE);
 	memcpy(kaddr1, kaddr2, PAGE_SIZE);
 	memcpy(kaddr2, buf, PAGE_SIZE);
-	kunmap_atomic(kaddr1, KM_USER0);
 	kunmap_atomic(kaddr2, KM_USER1);
+	kunmap_atomic(kaddr1, KM_USER0);
 }
 
 /**

-- 

