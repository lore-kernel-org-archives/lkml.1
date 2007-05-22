Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbXEVEDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbXEVEDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXEVEDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:03:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40035 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754962AbXEVEDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:03:41 -0400
Date: Mon, 21 May 2007 21:03:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
Message-ID: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The bounce buffer logic is included on systems that do not need it.
If a system does not have zones like ZONE_DMA and ZONE_HIGHMEM that
can lead to the use of bounce buffers then there is no need to reserve 
memory pools etc etc. This is true f.e. for SGI Altix.

Also nicifies the Makefile and gets rid of the tricky "and" there.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/blkdev.h |    2 +-
 mm/Kconfig             |    4 ++++
 mm/Makefile            |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2007-05-18 15:29:43.000000000 -0700
+++ linux-2.6/include/linux/blkdev.h	2007-05-18 15:32:48.000000000 -0700
@@ -607,7 +607,7 @@ extern unsigned long blk_max_low_pfn, bl
 #define BLK_BOUNCE_ANY		((u64)blk_max_pfn << PAGE_SHIFT)
 #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
 
-#ifdef CONFIG_MMU
+#ifdef CONFIG_BOUNCE
 extern int init_emergency_isa_pool(void);
 extern void blk_queue_bounce(request_queue_t *q, struct bio **bio);
 #else
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2007-05-18 15:31:18.000000000 -0700
+++ linux-2.6/mm/Kconfig	2007-05-18 15:38:25.000000000 -0700
@@ -163,6 +163,10 @@ config ZONE_DMA_FLAG
 	default "0" if !ZONE_DMA
 	default "1"
 
+config BOUNCE
+	def_bool y
+	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
+
 config NR_QUICK
 	int
 	depends on QUICKLIST
Index: linux-2.6/mm/Makefile
===================================================================
--- linux-2.6.orig/mm/Makefile	2007-05-18 15:27:57.000000000 -0700
+++ linux-2.6/mm/Makefile	2007-05-18 15:33:17.000000000 -0700
@@ -13,9 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   $(mmu-y)
 
-ifeq ($(CONFIG_MMU)$(CONFIG_BLOCK),yy)
-obj-y			+= bounce.o
-endif
+obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
