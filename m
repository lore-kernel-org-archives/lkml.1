Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYANW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYANW1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYANWRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYANWRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:17:04 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [30/31] Remove set_kernel_exec
Message-Id: <20080114221703.A47A114F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:17:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The SMP trampoline always runs in real mode, so making it executable 
in the page tables doesn't make much sense because it executes
before page tables are set up. That was the only user of
set_kernel_exec(). Remove set_kernel_exec().

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/smpboot_32.c |   11 -----------
 arch/x86/mm/init_32.c        |   30 ------------------------------
 include/asm-x86/pgtable_32.h |   12 ------------
 3 files changed, 53 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -508,36 +508,6 @@ static void __init set_nx(void)
 		}
 	}
 }
-
-/*
- * Enables/disables executability of a given kernel page and
- * returns the previous setting.
- */
-int __init set_kernel_exec(unsigned long vaddr, int enable)
-{
-	pte_t *pte;
-	int ret = 1;
-	int level;
-
-	if (!nx_enabled)
-		goto out;
-
-	pte = lookup_address(vaddr, &level);
-	BUG_ON(!pte);
-
-	if (!pte_exec_kernel(*pte))
-		ret = 0;
-
-	if (enable)
-		pte->pte_high &= ~(1 << (_PAGE_BIT_NX - 32));
-	else
-		pte->pte_high |= 1 << (_PAGE_BIT_NX - 32);
-	pte_update_defer(&init_mm, vaddr, pte);
-	__flush_tlb_all();
-out:
-	return ret;
-}
-
 #endif
 
 /*
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -184,18 +184,6 @@ static inline void clone_pgd_range(pgd_t
  */
 extern pte_t *lookup_address(unsigned long address, int *level);
 
-/*
- * Make a given kernel text page executable/non-executable.
- * Returns the previous executability setting of that page (which
- * is used to restore the previous state). Used by the SMP bootup code.
- * NOTE: this is an __init function for security reasons.
- */
-#ifdef CONFIG_X86_PAE
- extern int set_kernel_exec(unsigned long vaddr, int enable);
-#else
- static inline int set_kernel_exec(unsigned long vaddr, int enable) { return 0;}
-#endif
-
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address) \
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
Index: linux/arch/x86/kernel/smpboot_32.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot_32.c
+++ linux/arch/x86/kernel/smpboot_32.c
@@ -112,7 +112,6 @@ u8 apicid_2_node[MAX_APICID];
 extern const unsigned char trampoline_data [];
 extern const unsigned char trampoline_end  [];
 static unsigned char *trampoline_base;
-static int trampoline_exec;
 
 static void map_cpu_to_logical_apicid(void);
 
@@ -144,10 +143,6 @@ void __init smp_alloc_memory(void)
 	 */
 	if (__pa(trampoline_base) >= 0x9F000)
 		BUG();
-	/*
-	 * Make the SMP trampoline executable:
-	 */
-	trampoline_exec = set_kernel_exec((unsigned long)trampoline_base, 1);
 }
 
 /*
@@ -1295,12 +1290,6 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	zap_low_mappings();
-#ifndef CONFIG_HOTPLUG_CPU
-	/*
-	 * Disable executability of the SMP trampoline:
-	 */
-	set_kernel_exec((unsigned long)trampoline_base, trampoline_exec);
-#endif
 }
 
 void __init smp_intr_init(void)
