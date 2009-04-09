Return-Path: <linux-kernel-owner+w=401wt.eu-S936981AbZDIWMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936981AbZDIWMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764535AbZDIWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:11:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:36773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbZDIWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="680329606"
Message-Id: <20090409212708.653222000@intel.com>
References: <20090409212646.511925000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 14:26:49 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/6] x86, PAT: Handle faults cleanly in set_memory_ APIs
Content-Disposition: inline; filename=0003-x86-PAT-Handle-faults-cleanly-in-set_memory_-APIs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle faults and do proper cleanups in set_memory_*() functions. In
some cases, these functions were not doing proper free on failure paths.

With the changes to tracking memtype of RAM pages in struct page instead
of pat list, we do not need the changes in commits c5e147. This patch
reverts that change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pageattr.c |  113 +++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 38dc61f..3226504 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -931,52 +931,56 @@ int _set_memory_uc(unsigned long addr, int numpages)
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-			    _PAGE_CACHE_UC_MINUS, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+			    _PAGE_CACHE_UC_MINUS, NULL);
+	if (ret)
+		goto out_err;
+
+	ret = _set_memory_uc(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
 
-	return _set_memory_uc(addr, numpages);
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
-	unsigned long start;
-	unsigned long end;
-	int i;
+	int i, j;
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		start = __pa(addr[i]);
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
-			goto out;
+		ret = reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
+					_PAGE_CACHE_UC_MINUS, NULL);
+		if (ret)
+			goto out_free;
 	}
 
-	return change_page_attr_set(addr, addrinarray,
+	ret = change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
-out:
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long tmp = __pa(addr[i]);
-
-		if (tmp == start)
-			break;
-		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(tmp, end);
-	}
-	return -EINVAL;
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	for (j = 0; j < i; j++)
+		free_memtype(__pa(addr[j]), __pa(addr[j]) + PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
 
@@ -988,14 +992,26 @@ int _set_memory_wc(unsigned long addr, int numpages)
 
 int set_memory_wc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-		_PAGE_CACHE_WC, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+		_PAGE_CACHE_WC, NULL);
+	if (ret)
+		goto out_err;
 
-	return _set_memory_wc(addr, numpages);
+	ret = _set_memory_wc(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wc);
 
@@ -1007,9 +1023,14 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	int ret = _set_memory_wb(addr, numpages);
+	int ret;
+
+	ret = _set_memory_wb(addr, numpages);
+	if (ret)
+		return ret;
+
 	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_wb);
 
@@ -1020,19 +1041,13 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 
 	ret = change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
+	if (ret)
+		return ret;
 
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long start = __pa(addr[i]);
-		unsigned long end;
+	for (i = 0; i < addrinarray; i++)
+		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(start, end);
-	}
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_array_wb);
 
@@ -1125,6 +1140,8 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 
 	retval = cpa_clear_pages_array(pages, addrinarray,
 			__pgprot(_PAGE_CACHE_MASK));
+	if (retval)
+		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
 		start = (unsigned long)page_address(pages[i]);
@@ -1132,7 +1149,7 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		free_memtype(start, end);
 	}
 
-	return retval;
+	return 0;
 }
 EXPORT_SYMBOL(set_pages_array_wb);
 
-- 
1.6.0.6

-- 

