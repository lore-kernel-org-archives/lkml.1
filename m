Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYIGWZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYIGWZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYIGWYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:17 -0400
Received: from gw.goop.org ([64.81.55.164]:39659 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbYIGWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 7] x86: add early_memremap()
X-Mercurial-Node: 6bd56bc2461c501b722d2f2df6dc85d7055d3936
Message-Id: <6bd56bc2461c501b722d.1220826075@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_ioremap() is also used to map normal memory when constructing
the linear memory mapping.  However, since we sometimes need to be able
to distinguish between actual IO mappings and normal memory mappings,
add a early_memremap() call, which maps with PAGE_KERNEL (as opposed
to PAGE_KERNEL_IO for early_ioremap()), and use it when constructing
pagetables.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    2 +-
 arch/x86/mm/ioremap.c |   22 +++++++++++++++++-----
 include/asm-x86/io.h  |    1 +
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -312,7 +312,7 @@
 	if (pfn >= table_top)
 		panic("alloc_low_page: ran out of memory");
 
-	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
+	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
 	memset(adr, 0, PAGE_SIZE);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -549,12 +549,12 @@
 }
 
 static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					unsigned long phys)
+					   unsigned long phys, pgprot_t prot)
 {
 	if (after_paging_init)
-		set_fixmap(idx, phys);
+		__set_fixmap(idx, phys, prot);
 	else
-		__early_set_fixmap(idx, phys, PAGE_KERNEL);
+		__early_set_fixmap(idx, phys, prot);
 }
 
 static inline void __init early_clear_fixmap(enum fixed_addresses idx)
@@ -582,7 +582,7 @@
 }
 late_initcall(check_early_ioremap_leak);
 
-void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
 	unsigned int nrpages, nesting;
@@ -631,7 +631,7 @@
 	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
 	idx = idx0;
 	while (nrpages > 0) {
-		early_set_fixmap(idx, phys_addr);
+		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
 		--idx;
 		--nrpages;
@@ -640,6 +640,18 @@
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
 	return (void *) (offset + fix_to_virt(idx0));
+}
+
+/* Remap an IO device */
+void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
+}
+
+/* Remap memory */
+void __init *early_memremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void *addr, unsigned long size)
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -83,6 +83,7 @@
 extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void *early_ioremap(unsigned long offset, unsigned long size);
+extern void *early_memremap(unsigned long offset, unsigned long size);
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 


