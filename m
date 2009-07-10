Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZGJRBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZGJRBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZGJQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:7787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZGJQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777333"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 07/10] x86, PAT: Use page flags to track memtypes of RAM pages
Date: Fri, 10 Jul 2009 09:57:38 -0700
Message-Id: <9b94ff556a45738ea3bf5756662ed605c2a8f16f.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
 <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
 <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change reserve_ram_pages_type and free_ram_pages_type to use 2 page
flags to track UC_MINUS, WC, WB and default types. Previous RAM tracking
just tracked WB or NonWB, which was not complete and did not allow
tracking of RAM fully and there was no way to get the actual type
reserved by looking at the page flags.

We use the memtype_lock spinlock for atomicity in dealing with
memtype tracking in struct page.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/cacheflush.h |   54 +++++++++++++++++++++-
 arch/x86/mm/pat.c                 |   91 ++++++++++++++++++++-----------------
 2 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index e55dfc1..b54f6af 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -43,8 +43,58 @@ static inline void copy_from_user_page(struct vm_area_struct *vma,
 	memcpy(dst, src, len);
 }
 
-#define PG_non_WB				PG_arch_1
-PAGEFLAG(NonWB, non_WB)
+#define PG_WC				PG_arch_1
+PAGEFLAG(WC, WC)
+
+#ifdef CONFIG_X86_PAT
+/*
+ * X86 PAT uses page flags WC and Uncached together to keep track of
+ * memory type of pages that have backing page struct. X86 PAT supports 3
+ * different memory types, _PAGE_CACHE_WB, _PAGE_CACHE_WC and
+ * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
+ * been changed from its default (value of -1 used to denote this).
+ * Note we do not support _PAGE_CACHE_UC here.
+ *
+ * Caller must hold memtype_lock for atomicity.
+ */
+static inline unsigned long get_page_memtype(struct page *pg)
+{
+	if (!PageUncached(pg) && !PageWC(pg))
+		return -1;
+	else if (!PageUncached(pg) && PageWC(pg))
+		return _PAGE_CACHE_WC;
+	else if (PageUncached(pg) && !PageWC(pg))
+		return _PAGE_CACHE_UC_MINUS;
+	else
+		return _PAGE_CACHE_WB;
+}
+
+static inline void set_page_memtype(struct page *pg, unsigned long memtype)
+{
+	switch (memtype) {
+	case _PAGE_CACHE_WC:
+		ClearPageUncached(pg);
+		SetPageWC(pg);
+		break;
+	case _PAGE_CACHE_UC_MINUS:
+		SetPageUncached(pg);
+		ClearPageWC(pg);
+		break;
+	case _PAGE_CACHE_WB:
+		SetPageUncached(pg);
+		SetPageWC(pg);
+		break;
+	default:
+	case -1:
+		ClearPageUncached(pg);
+		ClearPageWC(pg);
+		break;
+	}
+}
+#else
+static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
+static inline void set_page_memtype(struct page *pg, unsigned long memtype) { }
+#endif
 
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c90f242..1a9d0f0 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -288,63 +288,61 @@ static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
 }
 
 /*
- * For RAM pages, mark the pages as non WB memory type using
- * PageNonWB (PG_arch_1). We allow only one set_memory_uc() or
- * set_memory_wc() on a RAM page at a time before marking it as WB again.
- * This is ok, because only one driver will be owning the page and
- * doing set_memory_*() calls.
+ * For RAM pages, we use page flags to mark the pages with appropriate type.
+ * Here we do two pass:
+ * - Find the memtype of all the pages in the range, look for any conflicts
+ * - In case of no conflicts, set the new memtype for pages in the range
  *
- * For now, we use PageNonWB to track that the RAM page is being mapped
- * as non WB. In future, we will have to use one more flag
- * (or some other mechanism in page_struct) to distinguish between
- * UC and WC mapping.
+ * Caller must hold memtype_lock for atomicity.
  */
 static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 				  unsigned long *new_type)
 {
 	struct page *page;
-	u64 pfn, end_pfn;
+	u64 pfn;
+
+	if (req_type == _PAGE_CACHE_UC) {
+		/* We do not support strong UC */
+		WARN_ON_ONCE(1);
+		req_type = _PAGE_CACHE_UC_MINUS;
+	}
 
 	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
-		page = pfn_to_page(pfn);
-		if (page_mapped(page) || PageNonWB(page))
-			goto out;
+		unsigned long type;
 
-		SetPageNonWB(page);
+		page = pfn_to_page(pfn);
+		type = get_page_memtype(page);
+		if (type != -1) {
+			printk(KERN_INFO "reserve_ram_pages_type failed "
+				"0x%Lx-0x%Lx, track 0x%lx, req 0x%lx\n",
+				start, end, type, req_type);
+			if (new_type)
+				*new_type = type;
+
+			return -EBUSY;
+		}
 	}
-	return 0;
 
-out:
-	end_pfn = pfn;
-	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+	if (new_type)
+		*new_type = req_type;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
 		page = pfn_to_page(pfn);
-		ClearPageNonWB(page);
+		set_page_memtype(page, req_type);
 	}
-
-	return -EINVAL;
+	return 0;
 }
 
 static int free_ram_pages_type(u64 start, u64 end)
 {
 	struct page *page;
-	u64 pfn, end_pfn;
+	u64 pfn;
 
 	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
 		page = pfn_to_page(pfn);
-		if (page_mapped(page) || !PageNonWB(page))
-			goto out;
-
-		ClearPageNonWB(page);
+		set_page_memtype(page, -1);
 	}
 	return 0;
-
-out:
-	end_pfn = pfn;
-	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
-		page = pfn_to_page(pfn);
-		SetPageNonWB(page);
-	}
-	return -EINVAL;
 }
 
 /*
@@ -405,11 +403,16 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		*new_type = actual_type;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type,
-					      new_type);
-	else if (is_range_ram < 0)
+	if (is_range_ram == 1) {
+
+		spin_lock(&memtype_lock);
+		err = reserve_ram_pages_type(start, end, req_type, new_type);
+		spin_unlock(&memtype_lock);
+
+		return err;
+	} else if (is_range_ram < 0) {
 		return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -505,10 +508,16 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return free_ram_pages_type(start, end);
-	else if (is_range_ram < 0)
+	if (is_range_ram == 1) {
+
+		spin_lock(&memtype_lock);
+		err = free_ram_pages_type(start, end);
+		spin_unlock(&memtype_lock);
+
+		return err;
+	} else if (is_range_ram < 0) {
 		return -EINVAL;
+	}
 
 	spin_lock(&memtype_lock);
 
-- 
1.6.0.6

