Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXDBNte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXDBNte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965461AbXDBNte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:49:34 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:10930
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965456AbXDBNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:49:33 -0400
Message-Id: <46112636.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 02 Apr 2007 14:50:14 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <davej@codemonkey.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] agp adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In generic code, remove an arch-dependent hunk in favor of #define-ing
the respective bits in asm-<arch>/agp.h (allowing easier overriding in
para-virtualized environments).

In intel-agp, fix a call to __free_page where __free_pages(, 2) was
meant, and do proper error path handling. Also remove a redundant
conditional.

In ali-agp, add missing calls to global_flush_tlb().

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.21-rc5/drivers/char/agp/ali-agp.c	2007-03-26 15:20:14.000000000 +0200
+++ 2.6.21-rc5-agp/drivers/char/agp/ali-agp.c	2007-03-30 13:33:03.000000000 +0200
@@ -145,6 +145,7 @@ static void *m1541_alloc_page(struct agp
 	void *addr = agp_generic_alloc_page(agp_bridge);
 	u32 temp;
 
+	global_flush_tlb();
 	if (!addr)
 		return NULL;
 
@@ -160,6 +161,7 @@ static void ali_destroy_page(void * addr
 	if (addr) {
 		global_cache_flush();	/* is this really needed?  --hch */
 		agp_generic_destroy_page(addr);
+		global_flush_tlb();
 	}
 }
 
--- linux-2.6.21-rc5/drivers/char/agp/generic.c	2007-03-26 15:20:14.000000000 +0200
+++ 2.6.21-rc5-agp/drivers/char/agp/generic.c	2007-03-30 13:43:29.000000000 +0200
@@ -51,28 +51,6 @@ int agp_memory_reserved;
  */
 EXPORT_SYMBOL_GPL(agp_memory_reserved);
 
-#if defined(CONFIG_X86)
-int map_page_into_agp(struct page *page)
-{
-	int i;
-	i = change_page_attr(page, 1, PAGE_KERNEL_NOCACHE);
-	/* Caller's responsibility to call global_flush_tlb() for
-	 * performance reasons */
-	return i;
-}
-EXPORT_SYMBOL_GPL(map_page_into_agp);
-
-int unmap_page_from_agp(struct page *page)
-{
-	int i;
-	i = change_page_attr(page, 1, PAGE_KERNEL);
-	/* Caller's responsibility to call global_flush_tlb() for
-	 * performance reasons */
-	return i;
-}
-EXPORT_SYMBOL_GPL(unmap_page_from_agp);
-#endif
-
 /*
  * Generic routines for handling agp_memory structures -
  * They use the basic page allocation routines to do the brunt of the work.
--- linux-2.6.21-rc5/drivers/char/agp/intel-agp.c	2007-03-26 15:20:14.000000000 +0200
+++ 2.6.21-rc5-agp/drivers/char/agp/intel-agp.c	2007-04-02 15:00:01.000000000 +0200
@@ -183,8 +183,9 @@ static void *i8xx_alloc_pages(void)
 		return NULL;
 
 	if (change_page_attr(page, 4, PAGE_KERNEL_NOCACHE) < 0) {
+		change_page_attr(page, 4, PAGE_KERNEL);
 		global_flush_tlb();
-		__free_page(page);
+		__free_pages(page, 2);
 		return NULL;
 	}
 	global_flush_tlb();
@@ -206,7 +207,7 @@ static void i8xx_destroy_pages(void *add
 	global_flush_tlb();
 	put_page(page);
 	unlock_page(page);
-	free_pages((unsigned long)addr, 2);
+	__free_pages(page, 2);
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
 
@@ -312,9 +313,6 @@ static struct agp_memory *alloc_agpphysm
 	struct agp_memory *new;
 	void *addr;
 
-	if (pg_count != 1 && pg_count != 4)
-		return NULL;
-
 	switch (pg_count) {
 	case 1: addr = agp_bridge->driver->agp_alloc_page(agp_bridge);
 		global_flush_tlb();
--- linux-2.6.21-rc5/include/asm-i386/agp.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-agp/include/asm-i386/agp.h	2007-03-30 13:43:21.000000000 +0200
@@ -12,8 +12,10 @@
  * data corruption on some CPUs.
  */
 
-int map_page_into_agp(struct page *page);
-int unmap_page_from_agp(struct page *page);
+/* Caller's responsibility to call global_flush_tlb() for
+ * performance reasons */
+#define map_page_into_agp(page) change_page_attr(page, 1, PAGE_KERNEL_NOCACHE)
+#define unmap_page_from_agp(page) change_page_attr(page, 1, PAGE_KERNEL)
 #define flush_agp_mappings() global_flush_tlb()
 
 /* Could use CLFLUSH here if the cpu supports it. But then it would
--- linux-2.6.21-rc5/include/asm-x86_64/agp.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-agp/include/asm-x86_64/agp.h	2007-03-30 13:43:46.000000000 +0200
@@ -10,8 +10,10 @@
  * with different cachability attributes for the same page.
  */
 
-int map_page_into_agp(struct page *page);
-int unmap_page_from_agp(struct page *page);
+/* Caller's responsibility to call global_flush_tlb() for
+ * performance reasons */
+#define map_page_into_agp(page) change_page_attr(page, 1, PAGE_KERNEL_NOCACHE)
+#define unmap_page_from_agp(page) change_page_attr(page, 1, PAGE_KERNEL)
 #define flush_agp_mappings() global_flush_tlb()
 
 /* Could use CLFLUSH here if the cpu supports it. But then it would


