Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYAYWvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYAYWvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYAYWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:50:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44272 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbYAYWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:50:49 -0500
Date: Fri, 25 Jan 2008 14:50:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch 2/3] x86: convert CPA users to the new set_page_ API
Message-ID: <20080125145025.4d4d011b@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: convert CPA users to the new set_page_ API
From: Arjan van de Ven <arjan@linux.intel.com>

This patch converts various users of change_page_attr() to the new,
more intent driven set_page_*/set_memory_* API set. 

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/efi.c               |    8 ++++----
 arch/x86/kernel/pci-gart_64.c       |    3 +--
 arch/x86/mm/init_32.c               |   20 +++++++-------------
 arch/x86/mm/init_64.c               |    9 ++++-----
 drivers/char/agp/intel-agp.c        |    6 +++---
 drivers/video/vermilion/vermilion.c |    9 +++------
 include/asm-x86/agp.h               |    4 ++--
 sound/pci/intel8x0.c                |    7 +++++--
 8 files changed, 29 insertions(+), 37 deletions(-)

Index: linux.trees.git/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/pci-gart_64.c
+++ linux.trees.git/arch/x86/kernel/pci-gart_64.c
@@ -570,8 +570,7 @@ static __init int init_k8_gatt(struct ag
 	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
-	if (change_page_attr_addr((unsigned long)gatt, gatt_size >> PAGE_SHIFT,
-				  PAGE_KERNEL_NOCACHE))
+	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 	global_flush_tlb();
 
Index: linux.trees.git/drivers/char/agp/intel-agp.c
===================================================================
--- linux.trees.git.orig/drivers/char/agp/intel-agp.c
+++ linux.trees.git/drivers/char/agp/intel-agp.c
@@ -210,8 +210,8 @@ static void *i8xx_alloc_pages(void)
 	if (page == NULL)
 		return NULL;
 
-	if (change_page_attr(page, 4, PAGE_KERNEL_NOCACHE) < 0) {
-		change_page_attr(page, 4, PAGE_KERNEL);
+	if (set_pages_uc(page, 4) < 0) {
+		set_pages_cached(page, 4);
 		global_flush_tlb();
 		__free_pages(page, 2);
 		return NULL;
@@ -230,7 +230,7 @@ static void i8xx_destroy_pages(void *add
 		return;
 
 	page = virt_to_page(addr);
-	change_page_attr(page, 4, PAGE_KERNEL);
+	set_pages_cached(page, 4);
 	global_flush_tlb();
 	put_page(page);
 	__free_pages(page, 2);
Index: linux.trees.git/drivers/video/vermilion/vermilion.c
===================================================================
--- linux.trees.git.orig/drivers/video/vermilion/vermilion.c
+++ linux.trees.git/drivers/video/vermilion/vermilion.c
@@ -88,9 +88,7 @@ static int vmlfb_alloc_vram_area(struct 
 {
 	gfp_t flags;
 	unsigned long i;
-	pgprot_t wc_pageprot;
 
-	wc_pageprot = PAGE_KERNEL_NOCACHE;
 	max_order++;
 	do {
 		/*
@@ -131,8 +129,7 @@ static int vmlfb_alloc_vram_area(struct 
 	 */
 
 	global_flush_tlb();
-	change_page_attr(virt_to_page(va->logical), va->size >> PAGE_SHIFT,
-			 wc_pageprot);
+	set_pages_uc(virt_to_page(va->logical), va->size >> PAGE_SHIFT);
 	global_flush_tlb();
 
 	printk(KERN_DEBUG MODULE_NAME
@@ -157,8 +154,8 @@ static void vmlfb_free_vram_area(struct 
 		 * Reset the linear kernel map caching policy.
 		 */
 
-		change_page_attr(virt_to_page(va->logical),
-				 va->size >> PAGE_SHIFT, PAGE_KERNEL);
+		set_pages_cached(virt_to_page(va->logical),
+				 va->size >> PAGE_SHIFT);
 		global_flush_tlb();
 
 		/*
Index: linux.trees.git/arch/x86/kernel/efi.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/efi.c
+++ linux.trees.git/arch/x86/kernel/efi.c
@@ -394,10 +394,10 @@ static void __init runtime_code_page_mke
 		md = p;
 		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		if (md->type == EFI_RUNTIME_SERVICES_CODE &&
-		    (end >> PAGE_SHIFT) <= max_pfn_mapped)
-			change_page_attr_addr(md->virt_addr,
-					      md->num_pages,
-					      PAGE_KERNEL_EXEC_NOCACHE);
+		    (end >> PAGE_SHIFT) <= max_pfn_mapped) {
+			set_memory_x(md->virt_addr, md->num_pages);
+			set_memory_uc(md->virt_addr, md->num_pages);
+		}
 	}
 	__flush_tlb_all();
 }
Index: linux.trees.git/arch/x86/mm/init_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/init_32.c
+++ linux.trees.git/arch/x86/mm/init_32.c
@@ -763,8 +763,7 @@ void mark_rodata_ro(void)
 	if (num_possible_cpus() <= 1)
 #endif
 	{
-		change_page_attr(virt_to_page(start),
-				 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+		set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 		printk(KERN_INFO "Write protecting the kernel text: %luk\n",
 			size >> 10);
 
@@ -773,26 +772,23 @@ void mark_rodata_ro(void)
 
 		printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
 			start, start+size);
-		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
-				 PAGE_KERNEL_EXEC);
+		set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);
 		global_flush_tlb();
 
 		printk(KERN_INFO "Testing CPA: write protecting again\n");
-		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
-				 PAGE_KERNEL_RX);
+		set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 		global_flush_tlb();
 #endif
 	}
 #endif
 	start += size;
 	size = (unsigned long)__end_rodata - start;
-	change_page_attr(virt_to_page(start),
-			 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 		size >> 10);
 
 	/*
-	 * change_page_attr() requires a global_flush_tlb() call after it.
+	 * set_pages_*() requires a global_flush_tlb() call after it.
 	 * We do this after the printk so that if something went wrong in the
 	 * change, the printk gets out at least to give a better debug hint
 	 * of who is the culprit.
@@ -802,13 +798,11 @@ void mark_rodata_ro(void)
 
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, start + size);
-	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
-				PAGE_KERNEL);
+	set_pages_rw(virt_to_page(start), size >> PAGE_SHIFT);
 	global_flush_tlb();
 
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
-	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
-				PAGE_KERNEL_RO);
+	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	global_flush_tlb();
 #endif
 }
Index: linux.trees.git/arch/x86/mm/init_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/init_64.c
+++ linux.trees.git/arch/x86/mm/init_64.c
@@ -630,14 +630,13 @@ void mark_rodata_ro(void)
 	if (end <= start)
 		return;
 
-	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT,
-				PAGE_KERNEL_RO);
+	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
 
 	/*
-	 * change_page_attr_addr() requires a global_flush_tlb() call after it.
+	 * set_memory_*() requires a global_flush_tlb() call after it.
 	 * We do this after the printk so that if something went wrong in the
 	 * change, the printk gets out at least to give a better debug hint
 	 * of who is the culprit.
@@ -647,11 +646,11 @@ void mark_rodata_ro(void)
 
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, end);
-	change_page_attr_addr(start, (end-start) >> PAGE_SHIFT, PAGE_KERNEL);
+	set_memory_rw(start, (end-start) >> PAGE_SHIFT);
 	global_flush_tlb();
 
 	printk(KERN_INFO "Testing CPA: again\n");
-	change_page_attr_addr(start, (end-start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 	global_flush_tlb();
 #endif
 }
Index: linux.trees.git/include/asm-x86/agp.h
===================================================================
--- linux.trees.git.orig/include/asm-x86/agp.h
+++ linux.trees.git/include/asm-x86/agp.h
@@ -16,8 +16,8 @@
  * Caller's responsibility to call global_flush_tlb() for performance
  * reasons
  */
-#define map_page_into_agp(page) change_page_attr(page, 1, PAGE_KERNEL_NOCACHE)
-#define unmap_page_from_agp(page) change_page_attr(page, 1, PAGE_KERNEL)
+#define map_page_into_agp(page) set_pages_uc(page, 1)
+#define unmap_page_from_agp(page) set_pages_cached(page, 1)
 #define flush_agp_mappings() global_flush_tlb()
 
 /*
Index: linux.trees.git/sound/pci/intel8x0.c
===================================================================
--- linux.trees.git.orig/sound/pci/intel8x0.c
+++ linux.trees.git/sound/pci/intel8x0.c
@@ -711,11 +711,14 @@ static void snd_intel8x0_setup_periods(s
 static void fill_nocache(void *buf, int size, int nocache)
 {
 	size = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	change_page_attr(virt_to_page(buf), size, nocache ? PAGE_KERNEL_NOCACHE : PAGE_KERNEL);
+	if (nocache)
+		set_pages_uc(virt_to_page(buf), size);
+	else
+		set_pages_cached(virt_to_page(buf), size);
 	global_flush_tlb();
 }
 #else
-#define fill_nocache(buf,size,nocache)
+#define fill_nocache(buf, size, nocache) do { ; } while (0)
 #endif
 
 /*

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
