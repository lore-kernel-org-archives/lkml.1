Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbYBFX5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbYBFX5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbYBFXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:59892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764066AbYBFXyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:19 -0500
Date: Wed, 6 Feb 2008 15:51:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/73] SPARC64: Fix two kernel linear mapping setup bugs.
Message-ID: <20080206235110.GI13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-two-kernel-linear-mapping-setup-bugs.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: David Miller <davem@davemloft.net>

[SPARC64]: Fix two kernel linear mapping setup bugs.

[ Upstream commit: 8f361453d8e9a67c85b2cf9b93c642c2d8fe0462 ]

This was caught and identified by Greg Onufer.

Since we setup the 256M/4M bitmap table after taking over the trap
table, it's possible for some 4M mapping to get loaded in the TLB
beforhand which later will be 256M mappings.

This can cause illegal TLB multiple-match conditions.  Fix this by
setting up the bitmap before we take over the trap table.

Next, __flush_tlb_all() was not doing anything on hypervisor
platforms.  Fix by adding sun4v_mmu_demap_all() and calling it.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/entry.S      |   12 ++++++++++++
 arch/sparc64/mm/init.c           |   29 ++++++++++++++++++++---------
 include/asm-sparc64/hypervisor.h |    4 ++++
 3 files changed, 36 insertions(+), 9 deletions(-)

--- a/arch/sparc64/kernel/entry.S
+++ b/arch/sparc64/kernel/entry.S
@@ -2593,3 +2593,15 @@ sun4v_mmustat_info:
 	retl
 	 nop
 	.size	sun4v_mmustat_info, .-sun4v_mmustat_info
+
+	.globl	sun4v_mmu_demap_all
+	.type	sun4v_mmu_demap_all,#function
+sun4v_mmu_demap_all:
+	clr	%o0
+	clr	%o1
+	mov	HV_MMU_ALL, %o2
+	mov	HV_FAST_MMU_DEMAP_ALL, %o5
+	ta	HV_FAST_TRAP
+	retl
+	 nop
+	.size	sun4v_mmu_demap_all, .-sun4v_mmu_demap_all
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1135,14 +1135,9 @@ static void __init mark_kpte_bitmap(unsi
 	}
 }
 
-static void __init kernel_physical_mapping_init(void)
+static void __init init_kpte_bitmap(void)
 {
 	unsigned long i;
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	unsigned long mem_alloced = 0UL;
-#endif
-
-	read_obp_memory("reg", &pall[0], &pall_ents);
 
 	for (i = 0; i < pall_ents; i++) {
 		unsigned long phys_start, phys_end;
@@ -1151,14 +1146,24 @@ static void __init kernel_physical_mappi
 		phys_end = phys_start + pall[i].reg_size;
 
 		mark_kpte_bitmap(phys_start, phys_end);
+	}
+}
 
+static void __init kernel_physical_mapping_init(void)
+{
 #ifdef CONFIG_DEBUG_PAGEALLOC
+	unsigned long i, mem_alloced = 0UL;
+
+	for (i = 0; i < pall_ents; i++) {
+		unsigned long phys_start, phys_end;
+
+		phys_start = pall[i].phys_addr;
+		phys_end = phys_start + pall[i].reg_size;
+
 		mem_alloced += kernel_map_range(phys_start, phys_end,
 						PAGE_KERNEL);
-#endif
 	}
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	printk("Allocated %ld bytes for kernel page tables.\n",
 	       mem_alloced);
 
@@ -1400,6 +1405,10 @@ void __init paging_init(void)
 	
 	inherit_prom_mappings();
 	
+	read_obp_memory("reg", &pall[0], &pall_ents);
+
+	init_kpte_bitmap();
+
 	/* Ok, we can use our TLB miss and window trap handlers safely.  */
 	setup_tba();
 
@@ -1854,7 +1863,9 @@ void __flush_tlb_all(void)
 			     "wrpr	%0, %1, %%pstate"
 			     : "=r" (pstate)
 			     : "i" (PSTATE_IE));
-	if (tlb_type == spitfire) {
+	if (tlb_type == hypervisor) {
+		sun4v_mmu_demap_all();
+	} else if (tlb_type == spitfire) {
 		for (i = 0; i < 64; i++) {
 			/* Spitfire Errata #32 workaround */
 			/* NOTE: Always runs on spitfire, so no
--- a/include/asm-sparc64/hypervisor.h
+++ b/include/asm-sparc64/hypervisor.h
@@ -709,6 +709,10 @@ extern unsigned long sun4v_mmu_tsb_ctx0(
  */
 #define HV_FAST_MMU_DEMAP_ALL		0x24
 
+#ifndef __ASSEMBLY__
+extern void sun4v_mmu_demap_all(void);
+#endif
+
 /* mmu_map_perm_addr()
  * TRAP:	HV_FAST_TRAP
  * FUNCTION:	HV_FAST_MMU_MAP_PERM_ADDR

-- 
