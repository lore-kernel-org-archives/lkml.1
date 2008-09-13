Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYIMALM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYIMALM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbYIMAKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:10:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:40279 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbYIMAKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:10:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,392,1217833200"; 
   d="scan'208";a="379720429"
Message-Id: <20080913000051.970641000@linux-os.sc.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 12 Sep 2008 17:00:05 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] x86: Handle error returns in set_memory_*
Content-Disposition: inline; filename=set_memory_errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly handle the error returns from set_memory_*. We have to free memtype
on error return path.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pageattr.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-12 16:03:36.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-12 16:31:12.000000000 -0700
@@ -929,6 +929,8 @@ int _set_memory_uc(unsigned long addr, i
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
@@ -936,13 +938,19 @@ int set_memory_uc(unsigned long addr, in
 			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
-	return _set_memory_uc(addr, numpages);
+	ret = _set_memory_uc(addr, numpages);
+	if (ret)
+		free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
-	unsigned long start;
+	int ret;
+	int reserve_fail = 0;
+	unsigned long start = 0;
 	unsigned long end;
 	int i;
 	/*
@@ -955,17 +963,24 @@ int set_memory_array_uc(unsigned long *a
 				break;
 			i++;
 		}
-		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL)) {
+			ret = -EINVAL;
+			reserve_fail = 1;
 			goto out;
+		}
 	}
 
-	return change_page_attr_set(addr, addrinarray,
+	ret = change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
+
+	if (!ret)
+		return ret;
+
 out:
 	for (i = 0; i < addrinarray; i++) {
 		unsigned long tmp = __pa(addr[i]);
 
-		if (tmp == start)
+		if (reserve_fail && tmp == start)
 			break;
 		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
 			if (end != __pa(addr[i + 1]))
@@ -974,7 +989,7 @@ out:
 		}
 		free_memtype(tmp, end);
 	}
-	return -EINVAL;
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
 
@@ -986,6 +1001,8 @@ int _set_memory_wc(unsigned long addr, i
 
 int set_memory_wc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
@@ -993,7 +1010,11 @@ int set_memory_wc(unsigned long addr, in
 		_PAGE_CACHE_WC, NULL))
 		return -EINVAL;
 
-	return _set_memory_wc(addr, numpages);
+	ret = _set_memory_wc(addr, numpages);
+	if (ret)
+		free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wc);
 

-- 

