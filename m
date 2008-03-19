Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYCSTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYCSTnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYCSTbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:2829 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYCSTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="220204538"
Message-Id: <20080319000059.430786000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:18 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 06/13] x86: PAT use reserve free memtype in set_memory_uc
Content-Disposition: inline; filename=use_reserve_free_memtype_setmemory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_memtype and free_memtype interfaces in set_memory_uc/set_memory_wb
interfaces to avoid aliasing.
Usage model of set_memory_uc and set_memory_wb is for RAM memory and users
will first call set_memory_uc and call set_memory_wb after use to reset the
attribute.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pageattr.c	2008-03-18 02:16:06.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pageattr.c	2008-03-18 09:20:30.000000000 -0700
@@ -19,6 +19,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
+#include <asm/pat.h>
 
 /*
  * The current flushing context - we pass it instead of 5 arguments:
@@ -771,18 +772,34 @@
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
 }
 
-int set_memory_uc(unsigned long addr, int numpages)
+int _set_memory_uc(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC));
 }
+
+int set_memory_uc(unsigned long addr, int numpages)
+{
+	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	                    _PAGE_CACHE_UC, NULL))
+		return -EINVAL;
+
+	return _set_memory_uc(addr, numpages);
+}
 EXPORT_SYMBOL(set_memory_uc);
 
-int set_memory_wb(unsigned long addr, int numpages)
+int _set_memory_wb(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(addr, numpages,
 				      __pgprot(_PAGE_CACHE_MASK));
 }
+
+int set_memory_wb(unsigned long addr, int numpages)
+{
+	free_memtype(addr, addr + numpages * PAGE_SIZE);
+
+	return _set_memory_wb(addr, numpages);
+}
 EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_x(unsigned long addr, int numpages)
Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 03:19:44.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 09:20:25.000000000 -0700
@@ -96,10 +96,10 @@
 	switch (prot_val) {
 	case _PAGE_CACHE_UC:
 	default:
-		err = set_memory_uc(vaddr, nrpages);
+		err = _set_memory_uc(vaddr, nrpages);
 		break;
 	case _PAGE_CACHE_WB:
-		err = set_memory_wb(vaddr, nrpages);
+		err = _set_memory_wb(vaddr, nrpages);
 		break;
 	}
 
Index: linux-2.6-x86.git/include/asm-x86/cacheflush.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/cacheflush.h	2008-03-18 02:16:06.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/cacheflush.h	2008-03-18 09:20:30.000000000 -0700
@@ -34,6 +34,8 @@
 int set_pages_ro(struct page *page, int numpages);
 int set_pages_rw(struct page *page, int numpages);
 
+int _set_memory_uc(unsigned long addr, int numpages);
+int _set_memory_wb(unsigned long addr, int numpages);
 int set_memory_uc(unsigned long addr, int numpages);
 int set_memory_wb(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);

-- 
