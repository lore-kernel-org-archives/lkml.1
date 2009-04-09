Return-Path: <linux-kernel-owner+w=401wt.eu-S936944AbZDIWMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936944AbZDIWMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762536AbZDIWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:11:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:53531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZDIWLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="129892092"
Message-Id: <20090409212708.512280000@intel.com>
References: <20090409212646.511925000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 14:26:48 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/6] x86, PAT: Change order of cpa and free in set_memory_wb
Content-Disposition: inline; filename=0002-x86-PAT-Change-order-of-cpa-and-free-in-set_memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be free of aliasing due to races, set_memory_* interfaces should
follow ordering of reserving, changing memtype to UC/WC, changing
memtype back to WB followed by free.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pageattr.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1224865..38dc61f 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1007,15 +1007,19 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
+	int ret = _set_memory_wb(addr, numpages);
 	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
-
-	return _set_memory_wb(addr, numpages);
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
+	int ret;
+
+	ret = change_page_attr_clear(addr, addrinarray,
+				      __pgprot(_PAGE_CACHE_MASK), 1);
 
 	for (i = 0; i < addrinarray; i++) {
 		unsigned long start = __pa(addr[i]);
@@ -1028,8 +1032,7 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 		}
 		free_memtype(start, end);
 	}
-	return change_page_attr_clear(addr, addrinarray,
-				      __pgprot(_PAGE_CACHE_MASK), 1);
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_wb);
 
-- 
1.6.0.6

-- 

