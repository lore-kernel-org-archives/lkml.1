Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYAOFu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYAOFu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 00:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYAOFuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 00:50:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:36685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYAOFuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:50:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="501974876"
Subject: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 13:45:06 +0800
Message-Id: <1200375906.3505.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 05:44:52.0605 (UTC) FILETIME=[C00032D0:01C85739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes bt_ioremap can be used before paging_init via
providing an early implementation of set_fixmap that can be used
before paging_init. This makes boot_ioremap can be replaced by
bt_ioremap.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/setup_32.c |    1 
 arch/x86/mm/init_32.c      |    2 +
 arch/x86/mm/ioremap_32.c   |   87 +++++++++++++++++++++++++++++++++++++++++++--
 include/asm-x86/io_32.h    |    3 +
 4 files changed, 91 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -208,6 +208,89 @@ void iounmap(volatile void __iomem *addr
 }
 EXPORT_SYMBOL(iounmap);
 
+static __initdata int after_paging_init;
+static __initdata unsigned long bm_pte[1024]
+				__attribute__((aligned(PAGE_SIZE)));
+
+static inline unsigned long * __init bt_ioremap_pgd(unsigned long addr)
+{
+	return (unsigned long *)swapper_pg_dir + ((addr >> 22) & 1023);
+}
+
+static inline unsigned long * __init bt_ioremap_pte(unsigned long addr)
+{
+	return bm_pte + ((addr >> PAGE_SHIFT) & 1023);
+}
+
+void __init bt_ioremap_init(void)
+{
+	unsigned long *pgd;
+
+	pgd = bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
+	*pgd = __pa(bm_pte) | _PAGE_TABLE;
+	memset(bm_pte, 0, sizeof(bm_pte));
+	BUG_ON(pgd != bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_END)));
+}
+
+void __init bt_ioremap_clear(void)
+{
+	unsigned long *pgd;
+
+	pgd = bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
+	*pgd = 0;
+	__flush_tlb_all();
+}
+
+void __init bt_ioremap_reset(void)
+{
+	enum fixed_addresses idx;
+	unsigned long *pte, phys, addr;
+
+	after_paging_init = 1;
+	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
+		addr = fix_to_virt(idx);
+		pte = bt_ioremap_pte(addr);
+		if (!*pte & _PAGE_PRESENT) {
+			phys = *pte & PAGE_MASK;
+			set_fixmap(idx, phys);
+		}
+	}
+}
+
+static void __init __bt_set_fixmap(enum fixed_addresses idx,
+				   unsigned long phys, pgprot_t flags)
+{
+	unsigned long *pte, addr = __fix_to_virt(idx);
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+	pte = bt_ioremap_pte(addr);
+	if (pgprot_val(flags))
+		*pte = (phys & PAGE_MASK) | pgprot_val(flags);
+	else
+		*pte = 0;
+	__flush_tlb_one(addr);
+}
+
+static inline void __init bt_set_fixmap(enum fixed_addresses idx,
+					unsigned long phys)
+{
+	if (after_paging_init)
+		set_fixmap(idx, phys);
+	else
+		__bt_set_fixmap(idx, phys, PAGE_KERNEL);
+}
+
+static inline void __init bt_clear_fixmap(enum fixed_addresses idx)
+{
+	if (after_paging_init)
+		clear_fixmap(idx);
+	else
+		__bt_set_fixmap(idx, 0, __pgprot(0));
+}
+
 void __init *bt_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	unsigned long offset, last_addr;
@@ -244,7 +327,7 @@ void __init *bt_ioremap(unsigned long ph
 	 */
 	idx = FIX_BTMAP_BEGIN;
 	while (nrpages > 0) {
-		set_fixmap(idx, phys_addr);
+		bt_set_fixmap(idx, phys_addr);
 		phys_addr += PAGE_SIZE;
 		--idx;
 		--nrpages;
@@ -267,7 +350,7 @@ void __init bt_iounmap(void *addr, unsig
 
 	idx = FIX_BTMAP_BEGIN;
 	while (nrpages > 0) {
-		clear_fixmap(idx);
+		bt_clear_fixmap(idx);
 		--idx;
 		--nrpages;
 	}
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -423,9 +423,11 @@ static void __init pagetable_init (void)
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
+	bt_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
+	bt_ioremap_reset();
 
 	permanent_kmaps_init(pgd_base);
 
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -130,6 +130,9 @@ extern void iounmap(volatile void __iome
  * mappings, before the real ioremap() is functional.
  * A boot-time mapping is currently limited to at most 16 pages.
  */
+extern void bt_ioremap_init(void);
+extern void bt_ioremap_clear(void);
+extern void bt_ioremap_reset(void);
 extern void *bt_ioremap(unsigned long offset, unsigned long size);
 extern void bt_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -624,6 +624,7 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
+	bt_ioremap_init();
 
 	efi_check_bios_type();
 #ifdef CONFIG_EFI

