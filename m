Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYCSTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYCSTn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYCSTbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:25828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbYCSTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="220204542"
Message-Id: <20080319000100.552111000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:23 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 11/13] x86: PAT Add set_memory_wc() interface
Content-Disposition: inline; filename=set_memory_wc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set_memory_wc interface(), similar to set_memory_uc interface.
Callers has to call set_memory_uc, set_memory_wb and
set_memory_wc, set_memory_wb as pairs.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pageattr.c	2008-03-18 03:23:49.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pageattr.c	2008-03-18 03:53:45.000000000 -0700
@@ -788,6 +788,25 @@
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int _set_memory_wc(unsigned long addr, int numpages)
+{
+	return change_page_attr_set(addr, numpages,
+				    __pgprot(_PAGE_CACHE_WC));
+}
+
+int set_memory_wc(unsigned long addr, int numpages)
+{
+	if (!pat_wc_enabled)
+		return set_memory_uc(addr, numpages);
+
+	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+		_PAGE_CACHE_WC, NULL))
+		return -EINVAL;
+
+	return _set_memory_wc(addr, numpages);
+}
+EXPORT_SYMBOL(set_memory_wc);
+
 int _set_memory_wb(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(addr, numpages,
Index: linux-2.6-x86.git/include/asm-x86/cacheflush.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/cacheflush.h	2008-03-18 03:21:25.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/cacheflush.h	2008-03-18 03:53:45.000000000 -0700
@@ -35,8 +35,10 @@
 int set_pages_rw(struct page *page, int numpages);
 
 int _set_memory_uc(unsigned long addr, int numpages);
+int _set_memory_wc(unsigned long addr, int numpages);
 int _set_memory_wb(unsigned long addr, int numpages);
 int set_memory_uc(unsigned long addr, int numpages);
+int set_memory_wc(unsigned long addr, int numpages);
 int set_memory_wb(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);

-- 
