Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbYBMWsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbYBMWsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYBMWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:47:56 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:49031 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbYBMWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:47:55 -0500
Date: Wed, 13 Feb 2008 16:43:23 -0600 (CST)
From: Becky Bruce <bgill@freescale.com>
X-X-Sender: bgill@monty.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: sparclinux@vger.kernel.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] [POWERPC] Make lmb support large physical addressing
Message-ID: <Pine.LNX.4.64.0802131639200.24317@monty.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the lmb code to use phys_addr_t instead of unsigned long for
physical addresses and sizes.  This is needed to support large amounts
of RAM on 32-bit systems that support 36-bit physical addressing.

Built/booted on mpc8641; build tested on pasemi and 44x.

Signed-off-by: Becky Bruce <becky.bruce@freescale.com>
---
Folks,

This has been sitting in my tree for a few days, and now it looks like
David M. has submitted a patch that changes the lmb code to be shared
between sparc and powerpc.  Sparc has no notion of a phys_addr_t.
Should we just use u64 everywhere in this code instead?  Thoughts?

Cheers,
Becky

 arch/powerpc/mm/lmb.c     |   92 +++++++++++++++++++++++----------------------
 include/asm-powerpc/lmb.h |   38 +++++++++---------
 2 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/arch/powerpc/mm/lmb.c b/arch/powerpc/mm/lmb.c
index 4ce23bc..31d86ff 100644
--- a/arch/powerpc/mm/lmb.c
+++ b/arch/powerpc/mm/lmb.c
@@ -41,33 +41,34 @@ void lmb_dump_all(void)
 
 	DBG("lmb_dump_all:\n");
 	DBG("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
-	DBG("    memory.size		  = 0x%lx\n", lmb.memory.size);
+	DBG("    memory.size		  = 0x%llx\n",
+	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.memory.cnt ;i++) {
-		DBG("    memory.region[0x%x].base       = 0x%lx\n",
-			    i, lmb.memory.region[i].base);
-		DBG("		      .size     = 0x%lx\n",
-			    lmb.memory.region[i].size);
+		DBG("    memory.region[0x%x].base       = 0x%llx\n",
+		    i, (unsigned long long)lmb.memory.region[i].base);
+		DBG("		      .size     = 0x%llx\n",
+		    (unsigned long long)lmb.memory.region[i].size);
 	}
 
 	DBG("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
 	DBG("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
-		DBG("    reserved.region[0x%x].base       = 0x%lx\n",
-			    i, lmb.reserved.region[i].base);
-		DBG("		      .size     = 0x%lx\n",
-			    lmb.reserved.region[i].size);
+		DBG("    reserved.region[0x%x].base       = 0x%llx\n",
+		    i, (unsigned long long)lmb.reserved.region[i].base);
+		DBG("		      .size     = 0x%llx\n",
+		    (unsigned long long)lmb.reserved.region[i].size);
 	}
 #endif /* DEBUG */
 }
 
-static unsigned long __init lmb_addrs_overlap(unsigned long base1,
-		unsigned long size1, unsigned long base2, unsigned long size2)
+static unsigned long __init lmb_addrs_overlap(phys_addr_t base1,
+		phys_addr_t size1, phys_addr_t base2, phys_addr_t size2)
 {
 	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
 }
 
-static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
-		unsigned long base2, unsigned long size2)
+static long __init lmb_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
+		phys_addr_t base2, phys_addr_t size2)
 {
 	if (base2 == base1 + size1)
 		return 1;
@@ -80,10 +81,10 @@ static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
 static long __init lmb_regions_adjacent(struct lmb_region *rgn,
 		unsigned long r1, unsigned long r2)
 {
-	unsigned long base1 = rgn->region[r1].base;
-	unsigned long size1 = rgn->region[r1].size;
-	unsigned long base2 = rgn->region[r2].base;
-	unsigned long size2 = rgn->region[r2].size;
+	phys_addr_t base1 = rgn->region[r1].base;
+	phys_addr_t size1 = rgn->region[r1].size;
+	phys_addr_t base2 = rgn->region[r2].base;
+	phys_addr_t size2 = rgn->region[r2].size;
 
 	return lmb_addrs_adjacent(base1, size1, base2, size2);
 }
@@ -135,16 +136,16 @@ void __init lmb_analyze(void)
 }
 
 /* This routine called with relocation disabled. */
-static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
-				  unsigned long size)
+static long __init lmb_add_region(struct lmb_region *rgn, phys_addr_t base,
+				  phys_addr_t size)
 {
 	unsigned long coalesced = 0;
 	long adjacent, i;
 
 	/* First try and coalesce this LMB with another. */
 	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
+		phys_addr_t rgnbase = rgn->region[i].base;
+		phys_addr_t rgnsize = rgn->region[i].size;
 
 		if ((rgnbase == base) && (rgnsize == size))
 			/* Already have this region, so we're done */
@@ -191,7 +192,7 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
 }
 
 /* This routine may be called with relocation disabled. */
-long __init lmb_add(unsigned long base, unsigned long size)
+long __init lmb_add(phys_addr_t base, phys_addr_t size)
 {
 	struct lmb_region *_rgn = &(lmb.memory);
 
@@ -203,7 +204,7 @@ long __init lmb_add(unsigned long base, unsigned long size)
 
 }
 
-long __init lmb_reserve(unsigned long base, unsigned long size)
+long __init lmb_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct lmb_region *_rgn = &(lmb.reserved);
 
@@ -212,14 +213,14 @@ long __init lmb_reserve(unsigned long base, unsigned long size)
 	return lmb_add_region(_rgn, base, size);
 }
 
-long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
-				unsigned long size)
+long __init lmb_overlaps_region(struct lmb_region *rgn, phys_addr_t base,
+				phys_addr_t size)
 {
 	unsigned long i;
 
 	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
+		phys_addr_t rgnbase = rgn->region[i].base;
+		phys_addr_t rgnsize = rgn->region[i].size;
 		if ( lmb_addrs_overlap(base,size,rgnbase,rgnsize) ) {
 			break;
 		}
@@ -228,30 +229,30 @@ long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
 	return (i < rgn->cnt) ? i : -1;
 }
 
-unsigned long __init lmb_alloc(unsigned long size, unsigned long align)
+phys_addr_t __init lmb_alloc(phys_addr_t size, phys_addr_t align)
 {
 	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
 }
 
-unsigned long __init lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
+phys_addr_t __init lmb_alloc_base(phys_addr_t size, phys_addr_t align,
+				    phys_addr_t max_addr)
 {
-	unsigned long alloc;
+	phys_addr_t alloc;
 
 	alloc = __lmb_alloc_base(size, align, max_addr);
 
 	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%lx bytes below 0x%lx.\n",
-				size, max_addr);
+		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
+		      (unsigned long long)size, (unsigned long long)max_addr);
 
 	return alloc;
 }
 
-unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
+phys_addr_t __init __lmb_alloc_base(phys_addr_t size, phys_addr_t align,
+				    phys_addr_t max_addr)
 {
 	long i, j;
-	unsigned long base = 0;
+	phys_addr_t base = 0;
 
 	BUG_ON(0 == size);
 
@@ -261,8 +262,8 @@ unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 		max_addr = __max_low_memory;
 #endif
 	for (i = lmb.memory.cnt-1; i >= 0; i--) {
-		unsigned long lmbbase = lmb.memory.region[i].base;
-		unsigned long lmbsize = lmb.memory.region[i].size;
+		phys_addr_t lmbbase = lmb.memory.region[i].base;
+		phys_addr_t lmbsize = lmb.memory.region[i].size;
 
 		if (max_addr == LMB_ALLOC_ANYWHERE)
 			base = _ALIGN_DOWN(lmbbase + lmbsize - size, align);
@@ -290,12 +291,12 @@ unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 }
 
 /* You must call lmb_analyze() before this. */
-unsigned long __init lmb_phys_mem_size(void)
+phys_addr_t __init lmb_phys_mem_size(void)
 {
 	return lmb.memory.size;
 }
 
-unsigned long __init lmb_end_of_DRAM(void)
+phys_addr_t __init lmb_end_of_DRAM(void)
 {
 	int idx = lmb.memory.cnt - 1;
 
@@ -303,9 +304,10 @@ unsigned long __init lmb_end_of_DRAM(void)
 }
 
 /* You must call lmb_analyze() after this. */
-void __init lmb_enforce_memory_limit(unsigned long memory_limit)
+void __init lmb_enforce_memory_limit(phys_addr_t memory_limit)
 {
-	unsigned long i, limit;
+	unsigned long i;
+	phys_addr_t limit;
 	struct lmb_property *p;
 
 	if (! memory_limit)
@@ -343,13 +345,13 @@ void __init lmb_enforce_memory_limit(unsigned long memory_limit)
 	}
 }
 
-int __init lmb_is_reserved(unsigned long addr)
+int __init lmb_is_reserved(phys_addr_t addr)
 {
 	int i;
 
 	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long upper = lmb.reserved.region[i].base +
-				      lmb.reserved.region[i].size - 1;
+		phys_addr_t upper = lmb.reserved.region[i].base +
+			lmb.reserved.region[i].size - 1;
 		if ((addr >= lmb.reserved.region[i].base) && (addr <= upper))
 			return 1;
 	}
diff --git a/include/asm-powerpc/lmb.h b/include/asm-powerpc/lmb.h
index 5d1dc48..2233f51 100644
--- a/include/asm-powerpc/lmb.h
+++ b/include/asm-powerpc/lmb.h
@@ -20,19 +20,19 @@
 #define MAX_LMB_REGIONS 128
 
 struct lmb_property {
-	unsigned long base;
-	unsigned long size;
+	phys_addr_t base;
+	phys_addr_t size;
 };
 
 struct lmb_region {
 	unsigned long cnt;
-	unsigned long size;
+	phys_addr_t size;
 	struct lmb_property region[MAX_LMB_REGIONS+1];
 };
 
 struct lmb {
 	unsigned long debug;
-	unsigned long rmo_size;
+	phys_addr_t rmo_size;
 	struct lmb_region memory;
 	struct lmb_region reserved;
 };
@@ -41,36 +41,36 @@ extern struct lmb lmb;
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
-extern long __init lmb_add(unsigned long base, unsigned long size);
-extern long __init lmb_reserve(unsigned long base, unsigned long size);
-extern unsigned long __init lmb_alloc(unsigned long size, unsigned long align);
-extern unsigned long __init lmb_alloc_base(unsigned long size,
-		unsigned long align, unsigned long max_addr);
-extern unsigned long __init __lmb_alloc_base(unsigned long size,
-		unsigned long align, unsigned long max_addr);
-extern unsigned long __init lmb_phys_mem_size(void);
-extern unsigned long __init lmb_end_of_DRAM(void);
-extern void __init lmb_enforce_memory_limit(unsigned long memory_limit);
-extern int __init lmb_is_reserved(unsigned long addr);
+extern long __init lmb_add(phys_addr_t base, phys_addr_t size);
+extern long __init lmb_reserve(phys_addr_t base, phys_addr_t size);
+extern phys_addr_t __init lmb_alloc(phys_addr_t size, phys_addr_t align);
+extern phys_addr_t __init lmb_alloc_base(phys_addr_t size,
+		phys_addr_t, phys_addr_t max_addr);
+extern phys_addr_t __init __lmb_alloc_base(phys_addr_t size,
+		phys_addr_t align, phys_addr_t max_addr);
+extern phys_addr_t __init lmb_phys_mem_size(void);
+extern phys_addr_t __init lmb_end_of_DRAM(void);
+extern void __init lmb_enforce_memory_limit(phys_addr_t memory_limit);
+extern int __init lmb_is_reserved(phys_addr_t addr);
 
 extern void lmb_dump_all(void);
 
-static inline unsigned long
+static inline phys_addr_t
 lmb_size_bytes(struct lmb_region *type, unsigned long region_nr)
 {
 	return type->region[region_nr].size;
 }
-static inline unsigned long
+static inline phys_addr_t
 lmb_size_pages(struct lmb_region *type, unsigned long region_nr)
 {
 	return lmb_size_bytes(type, region_nr) >> PAGE_SHIFT;
 }
-static inline unsigned long
+static inline phys_addr_t
 lmb_start_pfn(struct lmb_region *type, unsigned long region_nr)
 {
 	return type->region[region_nr].base >> PAGE_SHIFT;
 }
-static inline unsigned long
+static inline phys_addr_t
 lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 {
 	return lmb_start_pfn(type, region_nr) +
-- 
1.5.3.8

