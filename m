Return-Path: <linux-kernel-owner+w=401wt.eu-S934396AbYAaUiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396AbYAaUiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763554AbYAaUhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:37:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35214 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762286AbYAaUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:37:13 -0500
Date: Thu, 31 Jan 2008 12:44:10 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: make bootmap_start page align v6
In-reply-to: <200801311237.26080.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200801311244.11206.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801311434.31011.ak@suse.de> <200801311237.26080.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: make bootmap_start page align v6

need to apply after x86_64: add debug name for early_res

boot oops when system get 64g or 128 installed

Calling initcall 0xffffffff80bc33b6: sctp_init+0x0/0x711()
BUG: unable to handle kernel NULL pointer dereference at 000000000000005f
IP: [<ffffffff802bfe55>] proc_register+0xe7/0x10f
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g5a514e21-dirty #6
RIP: 0010:[<ffffffff802bfe55>]  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
RSP: 0000:ffff810824c57e60  EFLAGS: 00010246
RAX: 000000000000d7d7 RBX: ffff811024c5fa80 RCX: ffff810824c57e08
RDX: 0000000000000000 RSI: 0000000000000195 RDI: ffffffff80cc2460
RBP: ffffffffffffffff R08: 0000000000000000 R09: ffff811024c5fa80
R10: 0000000000000000 R11: 0000000000000002 R12: ffff810824c57e6c
R13: 0000000000000000 R14: ffff810824c57ee0 R15: 00000006abd25bee
FS:  0000000000000000(0000) GS:ffffffff80b4d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000005f CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff810824c56000, task ffff812024c52000)
Stack:  ffffffff80a57348 0000019500000000 ffff811024c5fa80 0000000000000000
 00000000ffffff97 ffffffff802bfef0 0000000000000000 ffffffffffffffff
 0000000000000000 ffffffff80bc3b4b ffff810824c57ee0 ffffffff80bc34a5
Call Trace:
 [<ffffffff802bfef0>] ? create_proc_entry+0x73/0x8a
 [<ffffffff80bc3b4b>] ? sctp_snmp_proc_init+0x1c/0x34
 [<ffffffff80bc34a5>] ? sctp_init+0xef/0x711
 [<ffffffff80b976e3>] ? kernel_init+0x175/0x2e1
 [<ffffffff8020ccf8>] ? child_rip+0xa/0x12
 [<ffffffff80b9756e>] ? kernel_init+0x0/0x2e1
 [<ffffffff8020ccee>] ? child_rip+0x0/0x12


Code: 1e 48 83 7b 38 00 75 08 48 c7 43 38 f0 e8 82 80 48 83 7b 30 00 75 08 48 c7 43 30 d0 e9 82 80 48 c7 c7 60 24 cc 80 e8 bd 5a 54 00 <48> 8b 45 60 48 89 6b 58 48 89 5d 60 48 89 43 50 fe 05 f5 25 a0
RIP  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
 RSP <ffff810824c57e60>
CR2: 000000000000005f
---[ end trace 02c2d78def82877a ]---
Kernel panic - not syncing: Attempted to kill init!

it turns out some variables near end of bss is corrupted already.

in System.map we have
ffffffff80d40420 b rsi_table
ffffffff80d40620 B krb5_seq_lock
ffffffff80d40628 b i.20437
ffffffff80d40630 b xprt_rdma_inline_write_padding
ffffffff80d40638 b sunrpc_table_header
ffffffff80d40640 b zero
ffffffff80d40644 b min_memreg
ffffffff80d40648 b rpcrdma_tk_lock_g
ffffffff80d40650 B sctp_assocs_id_lock
ffffffff80d40658 B proc_net_sctp
ffffffff80d40660 B sctp_assocs_id
ffffffff80d40680 B sysctl_sctp_mem
ffffffff80d40690 B sysctl_sctp_rmem
ffffffff80d406a0 B sysctl_sctp_wmem
ffffffff80d406b0 b sctp_ctl_socket
ffffffff80d406b8 b sctp_pf_inet6_specific
ffffffff80d406c0 b sctp_pf_inet_specific
ffffffff80d406c8 b sctp_af_v4_specific
ffffffff80d406d0 b sctp_af_v6_specific
ffffffff80d406d8 b sctp_rand.33270
ffffffff80d406dc b sctp_memory_pressure
ffffffff80d406e0 b sctp_sockets_allocated
ffffffff80d406e4 b sctp_memory_allocated
ffffffff80d406e8 b sctp_sysctl_header
ffffffff80d406f0 b zero
ffffffff80d406f4 A __bss_stop
ffffffff80d406f4 A _end

and setup_node_bootmem() will use that page 0xd40000 for bootmap
Bootmem setup node 0 0000000000000000-0000000828000000
  NODE_DATA [000000000008a485 - 0000000000091484]
  bootmap [0000000000d406f4 -  0000000000e456f3] pages 105
Bootmem setup node 1 0000000828000000-0000001028000000
  NODE_DATA [0000000828000000 - 0000000828006fff]
  bootmap [0000000828007000 -  0000000828106fff] pages 100
Bootmem setup node 2 0000001028000000-0000001828000000
  NODE_DATA [0000001028000000 - 0000001028006fff]
  bootmap [0000001028007000 -  0000001028106fff] pages 100
Bootmem setup node 3 0000001828000000-0000002028000000
  NODE_DATA [0000001828000000 - 0000001828006fff]
  bootmap [0000001828007000 -  0000001828106fff] pages 100

actually, setup_node_bootmem hope to make NODE_DATA to be aligned,
and bootmap will after that in PAGE.

the patch update find_e820_area to make sure we can address with for alignment.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -171,12 +171,13 @@ int __init e820_all_mapped(unsigned long
 }
 
 /*
- * Find a free area in a specific range.
+ * Find a free area with specified alignment in a specific range.
  */
 unsigned long __init find_e820_area(unsigned long start, unsigned long end,
-				    unsigned size)
+				    unsigned size, unsigned long align)
 {
 	int i;
+	unsigned long mask = ~(align - 1);
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -190,7 +191,8 @@ unsigned long __init find_e820_area(unsi
 			continue;
 		while (bad_addr(&addr, size) && addr+size <= ei->addr+ei->size)
 			;
-		last = PAGE_ALIGN(addr) + size;
+		addr = (addr + align - 1) & mask;
+		last = addr + size;
 		if (last > ei->addr + ei->size)
 			continue;
 		if (last > end)
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -182,7 +182,8 @@ contig_initmem_init(unsigned long start_
 	unsigned long bootmap_size, bootmap;
 
 	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size);
+	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
+				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -354,17 +354,10 @@ static void __init find_early_table_spac
 	 * need roughly 0.5KB per GB.
 	 */
 	start = 0x8000;
-	table_start = find_e820_area(start, end, tables);
+	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
-	/*
-	 * When you have a lot of RAM like 256GB, early_table will not fit
-	 * into 0x8000 range, find_e820_area() will find area after kernel
-	 * bss but the table_start is not page aligned, so need to round it
-	 * up to avoid overlap with bss:
-	 */
-	table_start = round_up(table_start, PAGE_SIZE);
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
 
@@ -420,7 +413,9 @@ void __init_refok init_memory_mapping(un
 		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 
-	reserve_early(table_start << PAGE_SHIFT, table_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem)
+		reserve_early(table_start << PAGE_SHIFT,
+				 table_end << PAGE_SHIFT, "PGTABLE");
 }
 
 #ifndef CONFIG_NUMA
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -84,25 +84,23 @@ static int __init populate_memnodemap(co
 
 static int __init allocate_cachealigned_memnodemap(void)
 {
-	unsigned long pad, pad_addr;
+	unsigned long addr;
 
 	memnodemap = memnode.embedded_map;
 	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
-	pad = L1_CACHE_BYTES - 1;
-	pad_addr = 0x8000;
-	nodemap_size = pad + sizeof(s16) * memnodemapsize;
-	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
-				      nodemap_size);
+	addr = 0x8000;
+	nodemap_size = round_up(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
+	nodemap_addr = find_e820_area(addr, end_pfn<<PAGE_SHIFT,
+				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
 		       "NUMA: Unable to allocate Memory to Node hash map\n");
 		nodemap_addr = nodemap_size = 0;
 		return -1;
 	}
-	pad_addr = (nodemap_addr + pad) & ~pad;
-	memnodemap = phys_to_virt(pad_addr);
+	memnodemap = phys_to_virt(nodemap_addr);
 	reserve_early(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
 
 	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
@@ -164,15 +162,17 @@ int early_pfn_to_nid(unsigned long pfn)
 }
 
 static void * __init early_node_mem(int nodeid, unsigned long start,
-				    unsigned long end, unsigned long size)
+				    unsigned long end, unsigned long size,
+				    unsigned long align)
 {
-	unsigned long mem = find_e820_area(start, end, size);
+	unsigned long mem = find_e820_area(start, end, size, align);
 	void *ptr;
 
-	if (mem != -1L)
+	if (mem != -1L) {
+		mem = round_up(mem, align);
 		return __va(mem);
-	ptr = __alloc_bootmem_nopanic(size,
-				SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS));
+	}
+	ptr = __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
 	if (ptr == NULL) {
 		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
 		       size, nodeid);
@@ -198,7 +198,8 @@ void __init setup_node_bootmem(int nodei
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
 
-	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size);
+	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
+					   SMP_CACHE_BYTES);
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
@@ -213,8 +214,12 @@ void __init setup_node_bootmem(int nodei
 	/* Find a place for the bootmem map */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
 	bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	/*
+	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
+	 * to use that to align to PAGE_SIZE
+	 */
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
-					bootmap_pages<<PAGE_SHIFT);
+				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
 		if (nodedata_phys < start || nodedata_phys >= end)
 			free_bootmem((unsigned long)node_data[nodeid],
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -15,7 +15,7 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
-				    unsigned size);
+				    unsigned size, unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size, 
 			      int type);
 extern void setup_memory_region(void);
