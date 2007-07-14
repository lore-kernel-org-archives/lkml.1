Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbXGNUWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbXGNUWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760989AbXGNUWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:22:00 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:49964 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760137AbXGNUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:22:00 -0400
Date: Sat, 14 Jul 2007 16:16:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Text Edit Lock - x86_64 Use kernel_tex_is_ro
Message-ID: <20070714201654.GQ6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.960272115@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012412.960272115@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:15:13 up 7 days, 10:20,  2 users,  load average: 0.47, 0.31, 0.28
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - x86_64 Use kernel_tex_is_ro

It makes more sense to use the kernel_text_is_ro variable instead of
duplicating it.

And since we do not plan to call kernel_text_mark_rw()/kernel_text_unmark()
in the middle of mark_rodata_ro (we are still at boot time), there is no
need to wait until after global_flush_tlb() mark the rodata.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/x86_64/mm/init.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/init.c	2007-07-14 16:10:21.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/init.c	2007-07-14 16:11:47.000000000 -0400
@@ -56,10 +56,6 @@ static unsigned long dma_reserve __initd
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-#ifdef CONFIG_DEBUG_RODATA
-static int rodata_marked;
-#endif
-
 /*
  * NOTE: pagetable_init alloc all the fixmap pagetables contiguous on the
  * physical space so we can cache the place of the first one and move
@@ -605,13 +601,12 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_stext);
 	unsigned long end = PFN_ALIGN(__end_rodata);
 
-	kernel_text_is_ro = 1;
-
 	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT,
 				PAGE_KERNEL_RO);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
+	kernel_text_is_ro = 1;
 
 	/*
 	 * change_page_attr_addr() requires a global_flush_tlb() call after it.
@@ -620,7 +615,6 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
-	rodata_marked = 1;
 }
 
 /*
@@ -628,7 +622,7 @@ void mark_rodata_ro(void)
  */
 void kernel_text_mark_rw(unsigned long address, size_t len)
 {
-	if (rodata_marked && address >= PFN_ALIGN(_text)
+	if (kernel_text_is_ro && address >= PFN_ALIGN(_text)
 			&& (address + len) <= PFN_ALIGN(_etext)) {
 		unsigned long nr_pages;
 		nr_pages = ((address + len) >> PAGE_SHIFT)
@@ -644,7 +638,7 @@ EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
 
 void kernel_text_unmark(unsigned long address, size_t len)
 {
-	if (rodata_marked && address >= PFN_ALIGN(_text)
+	if (kernel_text_is_ro && address >= PFN_ALIGN(_text)
 			&& (address + len) <= PFN_ALIGN(_etext)) {
 		unsigned long nr_pages;
 		nr_pages = ((address + len) >> PAGE_SHIFT)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
