Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYFWXkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYFWXkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYFWXkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:40:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:52131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFWXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:reply-to:content-type
         :content-transfer-encoding;
        b=fY0mvfUJpnrtOl7lMWCDTDfU5uYsKfdC1DUQbdBsfFXYOK4hVgim55yb/ZUN1q8HZT
         U9caaW+cGovahRwT5VSB2eflsi1zTDJcKddMFp5o9sYw13OjhUCuKN/tD3ZRaTmXXysG
         csv3u1aMBLy5rFxtJs1KHHhhckmBbg84/MSUM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: numa32 pfn print out using hex instead
Date: Mon, 23 Jun 2008 16:41:30 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231402.36752.yhlu.kernel@gmail.com>
In-Reply-To: <200806231402.36752.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806231641.30140.yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/srat_32.c  |   31 +++++++++++++++++++------------
 arch/x86/mm/discontig_32.c |   29 +++++++++++++++--------------
 2 files changed, 34 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/x86/kernel/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/srat_32.c
+++ linux-2.6/arch/x86/kernel/srat_32.c
@@ -93,7 +93,7 @@ acpi_numa_processor_affinity_init(struct
 
 	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain_lo;
 
-	printk("CPU 0x%02X in proximity domain 0x%02X\n",
+	printk(KERN_DEBUG "CPU %02x in proximity domain %02x\n",
 		cpu_affinity->apic_id, cpu_affinity->proximity_domain_lo);
 }
 
@@ -134,7 +134,8 @@ acpi_numa_memory_affinity_init(struct ac
 
 
 	if (num_memory_chunks >= MAXCHUNKS) {
-		printk("Too many mem chunks in SRAT. Ignoring %lld MBytes at %llx\n",
+		printk(KERN_WARNING "Too many mem chunks in SRAT."
+			" Ignoring %lld MBytes at %llx\n",
 			size/(1024*1024), paddr);
 		return;
 	}
@@ -155,7 +156,8 @@ acpi_numa_memory_affinity_init(struct ac
 
 	num_memory_chunks++;
 
-	printk("Memory range 0x%lX to 0x%lX (type 0x%X) in proximity domain 0x%02X %s\n",
+	printk(KERN_DEBUG "Memory range %08lx to %08lx (type %x)"
+			  " in proximity domain %02x %s\n",
 		start_pfn, end_pfn,
 		memory_affinity->memory_type,
 		pxm,
@@ -186,7 +188,7 @@ static __init void node_read_chunk(int n
 	 * *possible* memory hotplug areas the same as normal RAM.
 	 */
 	if (memory_chunk->start_pfn >= max_pfn) {
-		printk (KERN_INFO "Ignoring SRAT pfns: 0x%08lx -> %08lx\n",
+		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
 			memory_chunk->start_pfn, memory_chunk->end_pfn);
 		return;
 	}
@@ -212,7 +214,8 @@ int __init get_memcfg_from_srat(void)
 		goto out_fail;
 
 	if (num_memory_chunks == 0) {
-		printk("could not finy any ACPI SRAT memory areas.\n");
+		printk(KERN_WARNING
+			 "could not finy any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
 
@@ -239,20 +242,23 @@ int __init get_memcfg_from_srat(void)
 	for (i = 0; i < num_memory_chunks; i++)
 		node_memory_chunk[i].nid = pxm_to_node(node_memory_chunk[i].pxm);
 
-	printk("pxm bitmap: ");
+	printk(KERN_DEBUG "pxm bitmap: ");
 	for (i = 0; i < sizeof(pxm_bitmap); i++) {
-		printk("%02X ", pxm_bitmap[i]);
+		printk(KERN_CONT "%02x ", pxm_bitmap[i]);
 	}
-	printk("\n");
-	printk("Number of logical nodes in system = %d\n", num_online_nodes());
-	printk("Number of memory chunks in system = %d\n", num_memory_chunks);
+	printk(KERN_CONT "\n");
+	printk(KERN_DEBUG "Number of logical nodes in system = %d\n",
+			 num_online_nodes());
+	printk(KERN_DEBUG "Number of memory chunks in system = %d\n",
+			 num_memory_chunks);
 
 	for (i = 0; i < MAX_APICID; i++)
 		apicid_2_node[i] = pxm_to_node(apicid_to_pxm[i]);
 
 	for (j = 0; j < num_memory_chunks; j++){
 		struct node_memory_chunk_s * chunk = &node_memory_chunk[j];
-		printk("chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
+		printk(KERN_DEBUG
+			"chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
 		       j, chunk->nid, chunk->start_pfn, chunk->end_pfn);
 		node_read_chunk(chunk->nid, chunk);
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
@@ -268,6 +274,7 @@ int __init get_memcfg_from_srat(void)
 	}
 	return 1;
 out_fail:
-	printk("failed to get NUMA memory information from SRAT table\n");
+	printk(KERN_ERR "failed to get NUMA memory information from SRAT"
+			" table\n");
 	return 0;
 }
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -76,13 +76,13 @@ void memory_present(int nid, unsigned lo
 {
 	unsigned long pfn;
 
-	printk(KERN_INFO "Node: %d, start_pfn: %ld, end_pfn: %ld\n",
+	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
 	for (pfn = start; pfn < end; pfn += PAGES_PER_ELEMENT) {
 		physnode_map[pfn / PAGES_PER_ELEMENT] = nid;
-		printk(KERN_CONT "%ld ", pfn);
+		printk(KERN_CONT "%lx ", pfn);
 	}
 	printk(KERN_CONT "\n");
 }
@@ -117,7 +117,7 @@ static unsigned long kva_pages;
  */
 int __init get_memcfg_numa_flat(void)
 {
-	printk("NUMA - single node, flat memory mode\n");
+	printk(KERN_DEBUG "NUMA - single node, flat memory mode\n");
 
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
@@ -233,7 +233,7 @@ static unsigned long calculate_numa_rema
 		 * The acpi/srat node info can show hot-add memroy zones
 		 * where memory could be added but not currently present.
 		 */
-		printk("node %d pfn: [%lx - %lx]\n",
+		printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
 			nid, node_start_pfn[nid], node_end_pfn[nid]);
 		if (node_start_pfn[nid] > max_pfn)
 			continue;
@@ -268,7 +268,8 @@ static unsigned long calculate_numa_rema
 		node_remap_size[nid] = size;
 		node_remap_offset[nid] = reserve_pages;
 		reserve_pages += size;
-		printk("Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
+		printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of"
+				  " node %d at %llx\n",
 				size, nid, node_kva_final>>PAGE_SHIFT);
 
 		/*
@@ -290,7 +291,7 @@ static unsigned long calculate_numa_rema
 		remove_active_range(nid, node_remap_start_pfn[nid],
 					 node_remap_start_pfn[nid] + size);
 	}
-	printk("Reserving total of %ld pages for numa KVA remap\n",
+	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
 			reserve_pages);
 	return reserve_pages;
 }
@@ -304,7 +305,7 @@ static void init_remap_allocator(int nid
 	node_remap_alloc_vaddr[nid] = node_remap_start_vaddr[nid] +
 		ALIGN(sizeof(pg_data_t), PAGE_SIZE);
 
-	printk ("node %d will remap to vaddr %08lx - %08lx\n", nid,
+	printk(KERN_DEBUG "node %d will remap to vaddr %08lx - %08lx\n", nid,
 		(ulong) node_remap_start_vaddr[nid],
 		(ulong) node_remap_end_vaddr[nid]);
 }
@@ -340,9 +341,9 @@ void __init initmem_init(unsigned long s
 	if (kva_start_pfn == -1UL)
 		panic("Can not get kva space\n");
 
-	printk("kva_start_pfn ~ %ld find_max_low_pfn() ~ %ld\n",
+	printk(KERN_INFO "kva_start_pfn ~ %lx max_low_pfn ~ %lx\n",
 		kva_start_pfn, max_low_pfn);
-	printk("max_pfn = %ld\n", max_pfn);
+	printk(KERN_INFO "max_pfn = %lx\n", max_pfn);
 
 	/* avoid clash with initrd */
 	reserve_early(kva_start_pfn<<PAGE_SHIFT,
@@ -362,17 +363,17 @@ void __init initmem_init(unsigned long s
 #endif
 	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
 			pages_to_mb(max_low_pfn));
-	printk("min_low_pfn = %ld, max_low_pfn = %ld, highstart_pfn = %ld\n",
-			min_low_pfn, max_low_pfn, highstart_pfn);
+	printk(KERN_DEBUG "max_low_pfn = %lx, highstart_pfn = %lx\n",
+			max_low_pfn, highstart_pfn);
 
-	printk("Low memory ends at vaddr %08lx\n",
+	printk(KERN_DEBUG "Low memory ends at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(max_low_pfn));
 	for_each_online_node(nid) {
 		init_remap_allocator(nid);
 
 		allocate_pgdat(nid);
 	}
-	printk("High memory starts at vaddr %08lx\n",
+	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
 	for_each_online_node(nid)
 		propagate_e820_map_node(nid);
@@ -413,7 +414,7 @@ void __init set_highmem_pages_init(void)
 		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 
 		nid = zone_to_nid(zone);
-		printk("Initializing %s for node %d (%08lx:%08lx)\n",
+		printk(KERN_INFO "Initializing %s for node %d (%08lx:%08lx)\n",
 				zone->name, nid, zone_start_pfn, zone_end_pfn);
 
 		add_highpages_with_active_regions(nid, zone_start_pfn,
