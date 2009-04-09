Return-Path: <linux-kernel-owner+w=401wt.eu-S937049AbZDIWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937049AbZDIWNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZDIWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:11:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:53531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759770AbZDIWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="129892097"
Message-Id: <20090409212708.797481000@intel.com>
References: <20090409212646.511925000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 14:26:50 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/6] x86, PAT: Changing memtype to WC ensuring no WB alias
Content-Disposition: inline; filename=0004-x86-PAT-Changing-memtype-to-WC-ensuring-no-WB-alia.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per SDM, there should not be any aliasing of a WC with any cacheable
type across CPUs. That is if one CPU is changing the identity map
memtype to _WC, no other CPU at the time of this change should not have a
TLB for this page that carries a WB attribute. SDM suggests to make the
page not present. But for that we will have to handle any page faults
that can potentially happen due to these pages being not present.

Other way to deal with this without having any WB mapping is to change
the page first to UC and then to WC. This ensures that we meet the SDM
requirement of no cacheable alais to WC page. This also has same or
lower overhead than marking the page not present and making it present
later.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3226504..4fa8996 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -986,8 +986,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(&addr, numpages,
+	int ret;
+	ret = change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
+
+	if (!ret) {
+		ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_WC), 0);
+	}
+	return ret;
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
-- 
1.6.0.6

-- 

