Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbYBNBMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbYBNBMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935077AbYBNBKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:10:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44810
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935008AbYBNBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:10:33 -0500
Date: Wed, 13 Feb 2008 17:11:05 -0800 (PST)
Message-Id: <20080213.171105.186339855.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4]: [LMB]: Make lmb support large physical addressing
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[LMB]: Make lmb support large physical addressing

Convert the lmb code to use u64 instead of unsigned long for physical
addresses and sizes.  This is needed to support large amounts of RAM
on 32-bit systems that support 36-bit physical addressing.

Signed-off-by: Becky Bruce <becky.bruce@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/lmb.h |   38 ++++++++++----------
 lib/lmb.c           |   93 +++++++++++++++++++++++++--------------------------
 2 files changed, 65 insertions(+), 66 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 8b93f63..632717c 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -19,19 +19,19 @@
 #define MAX_LMB_REGIONS 128
 
 struct lmb_property {
-	unsigned long base;
-	unsigned long size;
+	u64 base;
+	u64 size;
 };
 
 struct lmb_region {
 	unsigned long cnt;
-	unsigned long size;
+	u64 size;
 	struct lmb_property region[MAX_LMB_REGIONS+1];
 };
 
 struct lmb {
 	unsigned long debug;
-	unsigned long rmo_size;
+	u64 rmo_size;
 	struct lmb_region memory;
 	struct lmb_region reserved;
 };
@@ -40,36 +40,36 @@ extern struct lmb lmb;
 
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
+extern long __init lmb_add(u64 base, u64 size);
+extern long __init lmb_reserve(u64 base, u64 size);
+extern u64 __init lmb_alloc(u64 size, u64 align);
+extern u64 __init lmb_alloc_base(u64 size,
+		u64, u64 max_addr);
+extern u64 __init __lmb_alloc_base(u64 size,
+		u64 align, u64 max_addr);
+extern u64 __init lmb_phys_mem_size(void);
+extern u64 __init lmb_end_of_DRAM(void);
+extern void __init lmb_enforce_memory_limit(u64 memory_limit);
+extern int __init lmb_is_reserved(u64 addr);
 
 extern void lmb_dump_all(void);
 
-static inline unsigned long
+static inline u64
 lmb_size_bytes(struct lmb_region *type, unsigned long region_nr)
 {
 	return type->region[region_nr].size;
 }
-static inline unsigned long
+static inline u64
 lmb_size_pages(struct lmb_region *type, unsigned long region_nr)
 {
 	return lmb_size_bytes(type, region_nr) >> PAGE_SHIFT;
 }
-static inline unsigned long
+static inline u64
 lmb_start_pfn(struct lmb_region *type, unsigned long region_nr)
 {
 	return type->region[region_nr].base >> PAGE_SHIFT;
 }
-static inline unsigned long
+static inline u64
 lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 {
 	return lmb_start_pfn(type, region_nr) +
diff --git a/lib/lmb.c b/lib/lmb.c
index e34a9e5..e3c8dcb 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -34,33 +34,34 @@ void lmb_dump_all(void)
 
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
+static unsigned long __init lmb_addrs_overlap(u64 base1,
+		u64 size1, u64 base2, u64 size2)
 {
 	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
 }
 
-static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
-		unsigned long base2, unsigned long size2)
+static long __init lmb_addrs_adjacent(u64 base1, u64 size1,
+		u64 base2, u64 size2)
 {
 	if (base2 == base1 + size1)
 		return 1;
@@ -73,10 +74,10 @@ static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
 static long __init lmb_regions_adjacent(struct lmb_region *rgn,
 		unsigned long r1, unsigned long r2)
 {
-	unsigned long base1 = rgn->region[r1].base;
-	unsigned long size1 = rgn->region[r1].size;
-	unsigned long base2 = rgn->region[r2].base;
-	unsigned long size2 = rgn->region[r2].size;
+	u64 base1 = rgn->region[r1].base;
+	u64 size1 = rgn->region[r1].size;
+	u64 base2 = rgn->region[r2].base;
+	u64 size2 = rgn->region[r2].size;
 
 	return lmb_addrs_adjacent(base1, size1, base2, size2);
 }
@@ -128,8 +129,7 @@ void __init lmb_analyze(void)
 }
 
 /* This routine called with relocation disabled. */
-static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
-				  unsigned long size)
+static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 {
 	unsigned long coalesced = 0;
 	long adjacent, i;
@@ -142,8 +142,8 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
 
 	/* First try and coalesce this LMB with another. */
 	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
+		u64 rgnbase = rgn->region[i].base;
+		u64 rgnsize = rgn->region[i].size;
 
 		if ((rgnbase == base) && (rgnsize == size))
 			/* Already have this region, so we're done */
@@ -190,7 +190,7 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
 }
 
 /* This routine may be called with relocation disabled. */
-long __init lmb_add(unsigned long base, unsigned long size)
+long __init lmb_add(u64 base, u64 size)
 {
 	struct lmb_region *_rgn = &(lmb.memory);
 
@@ -202,7 +202,7 @@ long __init lmb_add(unsigned long base, unsigned long size)
 
 }
 
-long __init lmb_reserve(unsigned long base, unsigned long size)
+long __init lmb_reserve(u64 base, u64 size)
 {
 	struct lmb_region *_rgn = &(lmb.reserved);
 
@@ -211,14 +211,14 @@ long __init lmb_reserve(unsigned long base, unsigned long size)
 	return lmb_add_region(_rgn, base, size);
 }
 
-long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
-				unsigned long size)
+long __init lmb_overlaps_region(struct lmb_region *rgn, u64 base,
+				u64 size)
 {
 	unsigned long i;
 
 	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
+		u64 rgnbase = rgn->region[i].base;
+		u64 rgnsize = rgn->region[i].size;
 		if ( lmb_addrs_overlap(base,size,rgnbase,rgnsize) ) {
 			break;
 		}
@@ -227,40 +227,38 @@ long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
 	return (i < rgn->cnt) ? i : -1;
 }
 
-unsigned long __init lmb_alloc(unsigned long size, unsigned long align)
+u64 __init lmb_alloc(u64 size, u64 align)
 {
 	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
 }
 
-unsigned long __init lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
+u64 __init lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 {
-	unsigned long alloc;
+	u64 alloc;
 
 	alloc = __lmb_alloc_base(size, align, max_addr);
 
 	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%lx bytes below 0x%lx.\n",
-				size, max_addr);
+		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
+		      (unsigned long long) size, (unsigned long long) max_addr);
 
 	return alloc;
 }
 
-static unsigned long lmb_align_down(unsigned long addr, unsigned long size)
+static u64 lmb_align_down(u64 addr, u64 size)
 {
 	return addr & ~(size - 1);
 }
 
-static unsigned long lmb_align_up(unsigned long addr, unsigned long size)
+static u64 lmb_align_up(u64 addr, u64 size)
 {
 	return (addr + (size - 1)) & ~(size - 1);
 }
 
-unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
+u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
-	unsigned long base = 0;
+	u64 base = 0;
 
 	BUG_ON(0 == size);
 
@@ -269,8 +267,8 @@ unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 		max_addr = LMB_REAL_LIMIT;
 
 	for (i = lmb.memory.cnt-1; i >= 0; i--) {
-		unsigned long lmbbase = lmb.memory.region[i].base;
-		unsigned long lmbsize = lmb.memory.region[i].size;
+		u64 lmbbase = lmb.memory.region[i].base;
+		u64 lmbsize = lmb.memory.region[i].size;
 
 		if (max_addr == LMB_ALLOC_ANYWHERE)
 			base = lmb_align_down(lmbbase + lmbsize - size, align);
@@ -299,12 +297,12 @@ unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 }
 
 /* You must call lmb_analyze() before this. */
-unsigned long __init lmb_phys_mem_size(void)
+u64 __init lmb_phys_mem_size(void)
 {
 	return lmb.memory.size;
 }
 
-unsigned long __init lmb_end_of_DRAM(void)
+u64 __init lmb_end_of_DRAM(void)
 {
 	int idx = lmb.memory.cnt - 1;
 
@@ -312,9 +310,10 @@ unsigned long __init lmb_end_of_DRAM(void)
 }
 
 /* You must call lmb_analyze() after this. */
-void __init lmb_enforce_memory_limit(unsigned long memory_limit)
+void __init lmb_enforce_memory_limit(u64 memory_limit)
 {
-	unsigned long i, limit;
+	unsigned long i;
+	u64 limit;
 	struct lmb_property *p;
 
 	if (! memory_limit)
@@ -352,13 +351,13 @@ void __init lmb_enforce_memory_limit(unsigned long memory_limit)
 	}
 }
 
-int __init lmb_is_reserved(unsigned long addr)
+int __init lmb_is_reserved(u64 addr)
 {
 	int i;
 
 	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long upper = lmb.reserved.region[i].base +
-				      lmb.reserved.region[i].size - 1;
+		u64 upper = lmb.reserved.region[i].base +
+			lmb.reserved.region[i].size - 1;
 		if ((addr >= lmb.reserved.region[i].base) && (addr <= upper))
 			return 1;
 	}
-- 
1.5.4.29.gb828fe

