Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbYFYEqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbYFYEqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYFYEho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:44 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37480 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755328AbYFYEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 36] x86_64: unify early_ioremap
X-Mercurial-Node: a0d7848f5c02fdb2843eef00e3978dd0a07d6246
Message-Id: <a0d7848f5c02fdb2843e.1214367543@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:03 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit early_ioremap will work equally well for 64-bit, so just use it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup_64.c  |    2 +
 arch/x86/mm/init_64.c       |   52 -------------------------------------------
 arch/x86/mm/ioremap.c       |    5 +++-
 include/asm-x86/fixmap_64.h |   13 ++++++++++
 include/asm-x86/io.h        |   13 ++++++++++
 include/asm-x86/io_32.h     |   12 ---------
 6 files changed, 32 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -191,6 +191,8 @@
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
+	early_ioremap_init();
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -255,58 +255,6 @@
 		return;
 
 	early_iounmap(adr, PAGE_SIZE);
-}
-
-/* Must run before zap_low_mappings */
-__meminit void *early_ioremap(unsigned long addr, unsigned long size)
-{
-	pmd_t *pmd, *last_pmd;
-	unsigned long vaddr;
-	int i, pmds;
-
-	pmds = ((addr & ~PMD_MASK) + size + ~PMD_MASK) / PMD_SIZE;
-	vaddr = __START_KERNEL_map;
-	pmd = level2_kernel_pgt;
-	last_pmd = level2_kernel_pgt + PTRS_PER_PMD - 1;
-
-	for (; pmd <= last_pmd; pmd++, vaddr += PMD_SIZE) {
-		for (i = 0; i < pmds; i++) {
-			if (pmd_present(pmd[i]))
-				goto continue_outer_loop;
-		}
-		vaddr += addr & ~PMD_MASK;
-		addr &= PMD_MASK;
-
-		for (i = 0; i < pmds; i++, addr += PMD_SIZE)
-			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-		__flush_tlb_all();
-
-		return (void *)vaddr;
-continue_outer_loop:
-		;
-	}
-	printk(KERN_ERR "early_ioremap(0x%lx, %lu) failed\n", addr, size);
-
-	return NULL;
-}
-
-/*
- * To avoid virtual aliases later:
- */
-__meminit void early_iounmap(void *addr, unsigned long size)
-{
-	unsigned long vaddr;
-	pmd_t *pmd;
-	int i, pmds;
-
-	vaddr = (unsigned long)addr;
-	pmds = ((vaddr & ~PMD_MASK) + size + ~PMD_MASK) / PMD_SIZE;
-	pmd = level2_kernel_pgt + pmd_index(vaddr);
-
-	for (i = 0; i < pmds; i++)
-		pmd_clear(pmd + i);
-
-	__flush_tlb_all();
 }
 
 static unsigned long __meminit
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -409,8 +409,6 @@
 	return;
 }
 
-#ifdef CONFIG_X86_32
-
 int __initdata early_ioremap_debug;
 
 static int __init early_ioremap_debug_setup(char *str)
@@ -511,6 +509,7 @@
 		return;
 	}
 	pte = early_ioremap_pte(addr);
+
 	if (pgprot_val(flags))
 		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
 	else
@@ -652,5 +651,3 @@
 {
 	WARN_ON(1);
 }
-
-#endif /* CONFIG_X86_32 */
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -49,6 +49,19 @@
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
+	__end_of_permanent_fixed_addresses,
+	/*
+	 * 256 temporary boot-time mappings, used by early_ioremap(),
+	 * before ioremap() is functional.
+	 *
+	 * We round it up to the next 512 pages boundary so that we
+	 * can have a single pgd entry and a single pte table:
+	 */
+#define NR_FIX_BTMAPS		64
+#define FIX_BTMAPS_NESTING	4
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
+			(__end_of_permanent_fixed_addresses & 511),
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	__end_of_fixed_addresses
 };
 
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -72,4 +72,17 @@
 				unsigned long prot_val);
 extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
 
+/*
+ * early_ioremap() and early_iounmap() are for temporary early boot-time
+ * mappings, before the real ioremap() is functional.
+ * A boot-time mapping is currently limited to at most 16 pages.
+ */
+extern void early_ioremap_init(void);
+extern void early_ioremap_clear(void);
+extern void early_ioremap_reset(void);
+extern void *early_ioremap(unsigned long offset, unsigned long size);
+extern void early_iounmap(void *addr, unsigned long size);
+extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
+
+
 #endif /* _ASM_X86_IO_H */
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -122,18 +122,6 @@
 extern void iounmap(volatile void __iomem *addr);
 
 /*
- * early_ioremap() and early_iounmap() are for temporary early boot-time
- * mappings, before the real ioremap() is functional.
- * A boot-time mapping is currently limited to at most 16 pages.
- */
-extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
-extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
-
-/*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
  */
 #define isa_virt_to_bus virt_to_phys


