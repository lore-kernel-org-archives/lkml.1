Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXBJLuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXBJLuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXBJLuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:50:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbXBJLuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:16 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Amul Shah <amul.shah@unisys.com>, Andi Kleen <ak@suse.de>,
       Rohit Seth <rohitseth@google.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [2/25] x86_64: Make the NUMA hash function nodemap allocation
Message-Id: <20070210115014.484C513DBF@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Amul Shah <amul.shah@unisys.com>
Remove the statically allocated memory to NUMA node hash map in favor of a
dynamically allocated memory to node hash map (it is cache aligned).

This patch has the nice side effect in that it allows the hash map to grow
for systems with large amounts of memory (256GB - 1TB), but suffer from
having small PCI space tacked onto the boot node (which is somewhere
between 192MB to 512MB on the ES7000).

Signed-off-by: Amul Shah <amul.shah@unisys.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---
Updated patch to fix a bug that Andi Kleen found for platforms that
don't support NUMA (or "numa=off").

---
 arch/x86_64/kernel/e820.c   |    7 ++++
 arch/x86_64/kernel/setup.c  |    5 ++
 arch/x86_64/mm/numa.c       |   74 ++++++++++++++++++++++++++++++++++++++------
 include/asm-x86_64/e820.h   |    1 
 include/asm-x86_64/mmzone.h |   13 ++++---
 5 files changed, 85 insertions(+), 15 deletions(-)

Index: linux/arch/x86_64/kernel/e820.c
===================================================================
--- linux.orig/arch/x86_64/kernel/e820.c
+++ linux/arch/x86_64/kernel/e820.c
@@ -83,6 +83,13 @@ static inline int bad_addr(unsigned long
 		return 1;
 	}
 
+#ifdef CONFIG_NUMA
+	/* NUMA memory to node map */
+	if (last >= nodemap_addr && addr < nodemap_addr + nodemap_size) {
+		*addrp = nodemap_addr + nodemap_size;
+		return 1;
+	}
+#endif
 	/* XXX ramdisk image here? */ 
 	return 0;
 } 
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -444,6 +444,11 @@ void __init setup_arch(char **cmdline_p)
 	/* reserve ebda region */
 	if (ebda_addr)
 		reserve_bootmem_generic(ebda_addr, ebda_size);
+#ifdef CONFIG_NUMA
+	/* reserve nodemap region */
+	if (nodemap_addr)
+		reserve_bootmem_generic(nodemap_addr, nodemap_size);
+#endif
 
 #ifdef CONFIG_SMP
 	/*
Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -36,6 +36,8 @@ unsigned char apicid_to_node[MAX_LOCAL_A
 cpumask_t node_to_cpumask[MAX_NUMNODES] __read_mostly;
 
 int numa_off __initdata;
+unsigned long __initdata nodemap_addr;
+unsigned long __initdata nodemap_size;
 
 
 /*
@@ -52,34 +54,87 @@ populate_memnodemap(const struct bootnod
 	int res = -1;
 	unsigned long addr, end;
 
-	if (shift >= 64)
-		return -1;
-	memset(memnodemap, 0xff, sizeof(memnodemap));
+	memset(memnodemap, 0xff, memnodemapsize);
 	for (i = 0; i < numnodes; i++) {
 		addr = nodes[i].start;
 		end = nodes[i].end;
 		if (addr >= end)
 			continue;
-		if ((end >> shift) >= NODEMAPSIZE)
+		if ((end >> shift) >= memnodemapsize)
 			return 0;
 		do {
 			if (memnodemap[addr >> shift] != 0xff)
 				return -1;
 			memnodemap[addr >> shift] = i;
-                       addr += (1UL << shift);
+			addr += (1UL << shift);
 		} while (addr < end);
 		res = 1;
 	} 
 	return res;
 }
 
-int __init compute_hash_shift(struct bootnode *nodes, int numnodes)
+static int __init allocate_cachealigned_memnodemap(void)
+{
+	unsigned long pad, pad_addr;
+
+	memnodemap = memnode.embedded_map;
+	if (memnodemapsize <= 48) {
+		printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
+		       nodemap_addr, nodemap_addr + nodemap_size);
+		return 0;
+	}
+
+	pad = L1_CACHE_BYTES - 1;
+	pad_addr = 0x8000;
+	nodemap_size = pad + memnodemapsize;
+	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
+				      nodemap_size);
+	if (nodemap_addr == -1UL) {
+		printk(KERN_ERR
+		       "NUMA: Unable to allocate Memory to Node hash map\n");
+		nodemap_addr = nodemap_size = 0;
+		return -1;
+	}
+	pad_addr = (nodemap_addr + pad) & ~pad;
+	memnodemap = phys_to_virt(pad_addr);
+
+	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
+	       nodemap_addr, nodemap_addr + nodemap_size);
+	return 0;
+}
+
+/*
+ * The LSB of all start and end addresses in the node map is the value of the
+ * maximum possible shift.
+ */
+static int __init
+extract_lsb_from_nodes (const struct bootnode *nodes, int numnodes)
 {
-	int shift = 20;
+	int i;
+	unsigned long start, end;
+	unsigned long bitfield = 0, memtop = 0;
 
-	while (populate_memnodemap(nodes, numnodes, shift + 1) >= 0)
-		shift++;
+	for (i = 0; i < numnodes; i++) {
+		start = nodes[i].start;
+		end = nodes[i].end;
+		if (start >= end)
+			continue;
+		bitfield |= start | end;
+		if (end > memtop)
+			memtop = end;
+	}
+	i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
+	memnodemapsize = (memtop >> i)+1;
+	return i;
+}
+
+int __init compute_hash_shift(struct bootnode *nodes, int numnodes)
+{
+	int shift;
 
+	shift = extract_lsb_from_nodes(nodes, numnodes);
+	if (allocate_cachealigned_memnodemap())
+		return -1;
 	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
 		shift);
 
@@ -290,6 +345,7 @@ void __init numa_initmem_init(unsigned l
 	       end_pfn << PAGE_SHIFT); 
 		/* setup dummy node covering all memory */ 
 	memnode_shift = 63; 
+	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
 	nodes_clear(node_online_map);
 	node_set_online(0);
Index: linux/include/asm-x86_64/e820.h
===================================================================
--- linux.orig/include/asm-x86_64/e820.h
+++ linux/include/asm-x86_64/e820.h
@@ -56,6 +56,7 @@ extern void finish_e820_parsing(void);
 extern struct e820map e820;
 
 extern unsigned ebda_addr, ebda_size;
+extern unsigned long nodemap_addr, nodemap_size;
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
Index: linux/include/asm-x86_64/mmzone.h
===================================================================
--- linux.orig/include/asm-x86_64/mmzone.h
+++ linux/include/asm-x86_64/mmzone.h
@@ -11,24 +11,25 @@
 
 #include <asm/smp.h>
 
-/* Should really switch to dynamic allocation at some point */
-#define NODEMAPSIZE 0x4fff
-
 /* Simple perfect hash to map physical addresses to node numbers */
 struct memnode {
 	int shift;
-	u8 map[NODEMAPSIZE];
-} ____cacheline_aligned;
+	unsigned int mapsize;
+	u8 *map;
+	u8 embedded_map[64-16];
+} ____cacheline_aligned; /* total size = 64 bytes */
 extern struct memnode memnode;
 #define memnode_shift memnode.shift
 #define memnodemap memnode.map
+#define memnodemapsize memnode.mapsize
 
 extern struct pglist_data *node_data[];
 
 static inline __attribute__((pure)) int phys_to_nid(unsigned long addr) 
 { 
 	unsigned nid; 
-	VIRTUAL_BUG_ON((addr >> memnode_shift) >= NODEMAPSIZE);
+	VIRTUAL_BUG_ON(!memnodemap);
+	VIRTUAL_BUG_ON((addr >> memnode_shift) >= memnodemapsize);
 	nid = memnodemap[addr >> memnode_shift]; 
 	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]); 
 	return nid; 
