Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZCSVzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZCSVzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZCSVz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:55:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:61334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbZCSVz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,391,1233561600"; 
   d="scan'208";a="440390108"
Message-Id: <20090319215358.611346000@intel.com>
References: <20090319215112.636641000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 14:51:13 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com
Cc: arjan@infradead.org, eric@anholt.net, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/3] x86, CPA: Add a flag parameter to cpa set_clr
Content-Disposition: inline; filename=cpa_array_param_to_flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change change_page_attr_set_clr() array parameter to a flag. This helps
following patches which adds an interface to change attr to uc/wb over a
set of pages referred by struct page.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pageattr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2009-03-13 11:51:31.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2009-03-17 11:03:31.000000000 -0700
@@ -786,7 +786,7 @@ static inline int cache_attr(pgprot_t at
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split, int array)
+				    int force_split, int in_flag)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -801,7 +801,7 @@ static int change_page_attr_set_clr(unsi
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (!array) {
+	if (!(in_flag & CPA_ARRAY)) {
 		if (*addr & ~PAGE_MASK) {
 			*addr &= PAGE_MASK;
 			/*
@@ -839,7 +839,7 @@ static int change_page_attr_set_clr(unsi
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	if (array)
+	if (in_flag & CPA_ARRAY)
 		cpa.flags |= CPA_ARRAY;
 
 	/* No alias checking for _NX bit modifications */
@@ -888,14 +888,14 @@ static inline int change_page_attr_set(u
 				       pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
-		array);
+		(array ? CPA_ARRAY : 0));
 }
 
 static inline int change_page_attr_clear(unsigned long *addr, int numpages,
 					 pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
-		array);
+		(array ? CPA_ARRAY : 0));
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)

-- 

