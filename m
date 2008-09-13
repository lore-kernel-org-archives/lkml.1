Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYIMJOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYIMJOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYIMJO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:14:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:11757 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbYIMJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WXn8kVU2zWWHHtvR8QIQdgLKthiuB55lcS5ypL2hqu5BPH/Ebvn3XVOwsfcwsSOAm/
         du9sps9zYgeNuuo/Sl45LBbQGKbObqnfCcJeNBfRxNQWs8Ih3/BvamMFlU0MlDY3Hizh
         HBrhR70K+2XsfEczth2u+lcKRsPDhsqSj0V5U=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: change early_ioremap to use slots instead of nesting
Date: Sat, 13 Sep 2008 02:13:52 -0700
Message-Id: <1221297232-11949-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could remove requirement that need to call early_ioremap in exactly revese
order of early_iounmap

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/ioremap.c       |   77 ++++++++++++++++++++++++++++++++------------
 include/asm-x86/fixmap_32.h |    4 +-
 include/asm-x86/fixmap_64.h |    4 +-
 3 files changed, 61 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c
+++ linux-2.6/arch/x86/mm/ioremap.c
@@ -565,16 +565,22 @@ static inline void __init early_clear_fi
 		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-
-static int __initdata early_ioremap_nested;
-
+static void *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 static int __init check_early_ioremap_leak(void)
 {
-	if (!early_ioremap_nested)
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (!count)
 		return 0;
 	WARN(1, KERN_WARNING
 	       "Debug warning: early ioremap leak of %d areas detected.\n",
-		early_ioremap_nested);
+		count);
 	printk(KERN_WARNING
 		"please boot with early_ioremap_debug and report the dmesg.\n");
 
@@ -585,15 +591,30 @@ late_initcall(check_early_ioremap_leak);
 static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
-	unsigned int nrpages, nesting;
+	unsigned int nrpages;
 	enum fixed_addresses idx0, idx;
+	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
 
-	nesting = early_ioremap_nested;
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
+			 phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
-		       phys_addr, size, nesting);
+		       phys_addr, size, slot);
 		dump_stack();
 	}
 
@@ -604,11 +625,7 @@ static void __init *__early_ioremap(unsi
 		return NULL;
 	}
 
-	if (nesting >= FIX_BTMAPS_NESTING) {
-		WARN_ON(1);
-		return NULL;
-	}
-	early_ioremap_nested++;
+	prev_size[slot] = size;
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -628,7 +645,7 @@ static void __init *__early_ioremap(unsi
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	idx = idx0;
 	while (nrpages > 0) {
 		early_set_fixmap(idx, phys_addr, prot);
@@ -639,7 +656,8 @@ static void __init *__early_ioremap(unsi
 	if (early_ioremap_debug)
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
-	return (void *) (offset + fix_to_virt(idx0));
+	prev_map[slot] = (void *) (offset + fix_to_virt(idx0));
+	return prev_map[slot];
 }
 
 /* Remap an IO device */
@@ -660,15 +678,33 @@ void __init early_iounmap(void *addr, un
 	unsigned long offset;
 	unsigned int nrpages;
 	enum fixed_addresses idx;
-	int nesting;
+	int i, slot;
 
-	nesting = --early_ioremap_nested;
-	if (WARN_ON(nesting < 0))
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
+			 addr, size);
+		WARN_ON(1);
 		return;
+	}
+
+	if (prev_size[slot] != size) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+			 addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
+		return;
+	}
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
-		       size, nesting);
+		       size, slot);
 		dump_stack();
 	}
 
@@ -680,12 +716,13 @@ void __init early_iounmap(void *addr, un
 	offset = virt_addr & ~PAGE_MASK;
 	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
 
-	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_clear_fixmap(idx);
 		--idx;
 		--nrpages;
 	}
+	prev_map[slot] = 0;
 }
 
 void __this_fixmap_does_not_exist(void)
Index: linux-2.6/include/asm-x86/fixmap_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/fixmap_32.h
+++ linux-2.6/include/asm-x86/fixmap_32.h
@@ -94,10 +94,10 @@ enum fixed_addresses {
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
+#define FIX_BTMAPS_SLOTS	4
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	FIX_WP_TEST,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
Index: linux-2.6/include/asm-x86/fixmap_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/fixmap_64.h
+++ linux-2.6/include/asm-x86/fixmap_64.h
@@ -61,10 +61,10 @@ enum fixed_addresses {
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
+#define FIX_BTMAPS_SLOTS	4
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	__end_of_fixed_addresses
 };
 
