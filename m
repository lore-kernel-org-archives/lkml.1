Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYFXTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYFXTTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYFXTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:19:15 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:46541 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFXTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=hcgExD939Tt5oDBdFJCjT1M7GChK8a4ymfEwtG+IFC3+hOqlhTs24LtuC7pApAyooh
         3WjlzIqRyoTN32QFqxs5ScNX9aLdnfzBKRCJRi0JGe2yFFIf/DgDUXpT7v/rqoRoXm7x
         22xmw2eDHEP5D3ZhFY11IK2ZF/WK05V0f8U2s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce init_memory_mapping for 32bit #3
Date: Tue, 24 Jun 2008 12:19:41 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806241218.14436.yhlu.kernel@gmail.com> <200806241218.58613.yhlu.kernel@gmail.com>
In-Reply-To: <200806241218.58613.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806241219.41174.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move kva related early backto initmem_init for numa32

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/mm/discontig_32.c |    8 ++++++--
 arch/x86/mm/init_32.c      |   20 --------------------
 include/asm-x86/numa_32.h  |    5 -----
 3 files changed, 6 insertions(+), 27 deletions(-)

Index: xy/arch/x86/mm/discontig_32.c
===================================================================
--- xy.orig/arch/x86/mm/discontig_32.c
+++ xy/arch/x86/mm/discontig_32.c
@@ -200,7 +200,7 @@ void *alloc_remap(int nid, unsigned long
 	return allocation;
 }
 
-void __init remap_numa_kva(void)
+static void __init remap_numa_kva(void)
 {
 	void *vaddr;
 	unsigned long pfn;
@@ -373,12 +373,16 @@ void __init initmem_init(unsigned long s
 
 		allocate_pgdat(nid);
 	}
+	remap_numa_kva();
+
 	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
 	for_each_online_node(nid)
 		propagate_e820_map_node(nid);
 
-	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
+	for_each_online_node(nid)
+		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+
 	NODE_DATA(0)->bdata = &node0_bdata;
 	setup_bootmem_allocator();
 }
Index: xy/arch/x86/mm/init_32.c
===================================================================
--- xy.orig/arch/x86/mm/init_32.c
+++ xy/arch/x86/mm/init_32.c
@@ -449,7 +449,6 @@ static void __init pagetable_init(void)
 
 	paravirt_pagetable_setup_start(pgd_base);
 
-	remap_numa_kva();
 	/*
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
@@ -724,24 +723,6 @@ void __init setup_bootmem_allocator(void
 	after_init_bootmem = 1;
 }
 
-/*
- * The node 0 pgdat is initialized before all of these because
- * it's needed for bootmem.  node>0 pgdats have their virtual
- * space allocated before the pagetables are in place to access
- * them, so they can't be cleared then.
- *
- * This should all compile down to nothing when NUMA is off.
- */
-static void __init remapped_pgdat_init(void)
-{
-	int nid;
-
-	for_each_online_node(nid) {
-		if (nid != 0)
-			memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
-	}
-}
-
 static void __init find_early_table_space(unsigned long end)
 {
 	unsigned long puds, pmds, tables, start;
@@ -831,7 +812,6 @@ void __init paging_init(void)
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
-	remapped_pgdat_init();
 	sparse_init();
 	zone_sizes_init();
 
Index: xy/include/asm-x86/numa_32.h
===================================================================
--- xy.orig/include/asm-x86/numa_32.h
+++ xy/include/asm-x86/numa_32.h
@@ -5,12 +5,7 @@ extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
-extern void __init remap_numa_kva(void);
 extern void set_highmem_pages_init(void);
-#else
-static inline void remap_numa_kva(void)
-{
-}
 #endif
 
 #endif /* _ASM_X86_32_NUMA_H */
