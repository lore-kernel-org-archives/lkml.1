Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYIWVXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYIWVXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYIWVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:21:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:37400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYIWVVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:21:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="50419300"
Message-Id: <20080923211444.670262000@linux-os.sc.intel.com>
References: <20080923210035.413932000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 14:00:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/7] x86, cpa: no need to check alias for __set_pages_p/__set_pages_np
Content-Disposition: inline; filename=no_alias_for_np_p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No alias checking needed for setting present/not-present mapping. Otherwise,
we may need to break large pages for 64-bit kernel text mappings (this adds to
complexity if we want to do this from atomic context especially, for ex:
with CONFIG_DEBUG_PAGEALLOC). Let's keep it simple!

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-23 13:45:59.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-23 13:47:45.000000000 -0700
@@ -1121,7 +1121,13 @@
 				.mask_clr = __pgprot(0),
 				.flags = 0};
 
-	return __change_page_attr_set_clr(&cpa, 1);
+	/*
+	 * No alias checking needed for setting present flag. otherwise,
+	 * we may need to break large pages for 64-bit kernel text
+	 * mappings (this adds to complexity if we want to do this from
+	 * atomic context especially). Let's keep it simple!
+	 */
+	return __change_page_attr_set_clr(&cpa, 0);
 }
 
 static int __set_pages_np(struct page *page, int numpages)
@@ -1133,7 +1139,13 @@
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.flags = 0};
 
-	return __change_page_attr_set_clr(&cpa, 1);
+	/*
+	 * No alias checking needed for setting not present flag. otherwise,
+	 * we may need to break large pages for 64-bit kernel text
+	 * mappings (this adds to complexity if we want to do this from
+	 * atomic context especially). Let's keep it simple!
+	 */
+	return __change_page_attr_set_clr(&cpa, 0);
 }
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
@@ -1153,11 +1165,8 @@
 
 	/*
 	 * The return value is ignored as the calls cannot fail.
-	 * Large pages are kept enabled at boot time, and are
-	 * split up quickly with DEBUG_PAGEALLOC. If a splitup
-	 * fails here (due to temporary memory shortage) no damage
-	 * is done because we just keep the largepage intact up
-	 * to the next attempt when it will likely be split up:
+	 * Large pages for identity mappings are not used at boot time
+	 * and hence no memory allocations during large page split.
 	 */
 	if (enable)
 		__set_pages_p(page, numpages);

-- 

