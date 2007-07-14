Return-Path: <linux-kernel-owner+w=401wt.eu-S1764452AbXGNUJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764452AbXGNUJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbXGNUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:08:59 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:34290 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760924AbXGNUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:08:59 -0400
Date: Sat, 14 Jul 2007 16:08:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Text Edit Lock - i386 Use kernel_text_is_ro
Message-ID: <20070714200857.GP6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca> <20070714161831.GA13831@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714161831.GA13831@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:59:34 up 7 days, 10:04,  2 users,  load average: 0.04, 0.14, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - i386 use kernel_text_is_ro

* Christoph Hellwig (hch@infradead.org) wrote:
> On Fri, Jul 13, 2007 at 09:21:36PM -0400, Mathieu Desnoyers wrote:
> > +#ifdef CONFIG_DEBUG_RODATA
> > +static int rodata_marked;
> > +#endif
> 
> Maybe I'm missing something, but the rodata section should always stay
> r/o, only text needs locking/unlocking, no?
> 
> Given that all code in this patch only operates on .text this seems fine,
> but the variables/config options are grossly misnamed then.  And actually
> making rodata r/o doesn't seem like a pure debugging thing to me either.

I think it will change to two different config options eventually (RO
data and RO text). But for now, it makes more sense to use the
kernel_text_is_ro variable.

And since we do not plan to call kernel_text_mark_rw()/kernel_text_unmark()
in the middle of mark_rodata_ro (we are still at boot time), there is no
need to wait until after global_flush_tlb() mark the rodata. And it makes to
rename mark_rodata_ro into kernel_rodata_is_ro.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 arch/i386/mm/init.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-07-14 16:04:20.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-07-14 16:05:45.000000000 -0400
@@ -47,6 +47,7 @@
 #include <asm/paravirt.h>
 
 int kernel_text_is_ro;
+int kernel_rodata_is_ro;
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -54,9 +55,6 @@ unsigned long highstart_pfn, highend_pfn
 
 static int noinline do_test_wp_bit(void);
 
-#ifdef CONFIG_DEBUG_RODATA
-static int rodata_marked;
-#endif
 
 /*
  * Creates a middle page table and puts a pointer to it in the
@@ -817,6 +815,7 @@ void mark_rodata_ro(void)
 	                 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
 	printk("Write protecting the kernel read-only data: %luk\n",
 	       size >> 10);
+	kernel_rodata_is_ro = 1;
 
 	/*
 	 * change_page_attr() requires a global_flush_tlb() call after it.
@@ -825,7 +824,6 @@ void mark_rodata_ro(void)
 	 * of who is the culprit.
 	 */
 	global_flush_tlb();
-	rodata_marked = 1;
 }
 
 /*
@@ -834,7 +832,7 @@ void mark_rodata_ro(void)
  */
 void __kprobes kernel_text_mark_rw(unsigned long address, size_t len)
 {
-	if (rodata_marked && address >= PFN_ALIGN(_text)
+	if (kernel_text_is_ro && address >= PFN_ALIGN(_text)
 			&& (address + len) <= PFN_ALIGN(_etext)) {
 		unsigned long nr_pages;
 		nr_pages = ((address + len) >> PAGE_SHIFT)
@@ -851,7 +849,7 @@ EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
 
 void __kprobes kernel_text_unmark(unsigned long address, size_t len)
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
