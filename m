Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYHUAMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYHUAMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYHUAMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:12:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:24075 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYHUAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,242,1217833200"; 
   d="scan'208";a="35913968"
Message-Id: <20080820234604.316127000@intel.com>
References: <20080820234550.923970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Aug 2008 16:45:51 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/4] x86: PAT proper tracking of set_memory_uc and friends
Content-Disposition: inline; filename=set_memory_pa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Big thinko in pat memtype tracking code. reserve_memtype should be called
with physical address and not virtual address. 

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pageattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-08-20 14:25:18.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-08-20 14:26:15.000000000 -0700
@@ -862,7 +862,7 @@ int set_memory_uc(unsigned long addr, in
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
@@ -905,7 +905,7 @@ int set_memory_wc(unsigned long addr, in
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL))
 		return -EINVAL;
 
@@ -921,7 +921,7 @@ int _set_memory_wb(unsigned long addr, i
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	free_memtype(addr, addr + numpages * PAGE_SIZE);
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
 
 	return _set_memory_wb(addr, numpages);
 }

-- 

