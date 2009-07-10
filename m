Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZGJRBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZGJRBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZGJQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:7780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZGJQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777336"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 08/10] x86, PAT: Add lookup_memtype to get the current memtype of a paddr
Date: Fri, 10 Jul 2009 09:57:39 -0700
Message-Id: <f1bc76700599173408bf67167efc49027d70d98b.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <9b94ff556a45738ea3bf5756662ed605c2a8f16f.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
 <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
 <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
 <9b94ff556a45738ea3bf5756662ed605c2a8f16f.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new routine lookup_memtype() to get the current memtype based on
the PAT reserves and frees.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 1a9d0f0..71aa6f7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -574,6 +574,51 @@ unlock_ret:
 
 
 /**
+ * lookup_memtype - Looksup the memory type for a physical address
+ * @paddr: physical address of which memory type needs to be looked up
+ *
+ * Only to be called when PAT is enabled
+ *
+ * Returns _PAGE_CACHE_WB, _PAGE_CACHE_WC, _PAGE_CACHE_UC_MINUS or
+ * _PAGE_CACHE_UC
+ */
+static unsigned long lookup_memtype(u64 paddr)
+{
+	int rettype = _PAGE_CACHE_WB;
+	struct memtype *entry;
+
+	if (is_ISA_range(paddr, paddr + PAGE_SIZE - 1))
+		return rettype;
+
+	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
+		struct page *page;
+		spin_lock(&memtype_lock);
+		page = pfn_to_page(paddr >> PAGE_SHIFT);
+		rettype = get_page_memtype(page);
+		spin_unlock(&memtype_lock);
+		/*
+		 * -1 from get_page_memtype() implies RAM page is in its
+		 * default state and not reserved, and hence of type WB
+		 */
+		if (rettype == -1)
+			rettype = _PAGE_CACHE_WB;
+
+		return rettype;
+	}
+
+	spin_lock(&memtype_lock);
+
+	entry = memtype_rb_search(&memtype_rbroot, paddr);
+	if (entry != NULL)
+		rettype = entry->type;
+	else
+		rettype = _PAGE_CACHE_UC_MINUS;
+
+	spin_unlock(&memtype_lock);
+	return rettype;
+}
+
+/**
  * io_reserve_memtype - Request a memory type mapping for a region of memory
  * @start: start (physical address) of the region
  * @end: end (physical address) of the region
-- 
1.6.0.6

