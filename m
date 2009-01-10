Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbZAJAZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbZAJAZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbZAJAYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:20732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbZAJAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="377242486"
Message-Id: <20090110001404.585698000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:10 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/6] x86 PAT: consolidate old memtype new memtype check into a function
Content-Disposition: inline; filename=cleanup_allowed_memtype_change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the new memtype old memtype allowed check to header so that is can be
shared by other users. Subsequent patch uses this in pat.c in remap_pfn_range()
code path. No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h |   19 +++++++++++++++++++
 arch/x86/pci/i386.c            |   12 +-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2009-01-07 15:00:34.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2009-01-07 16:03:25.000000000 -0800
@@ -341,6 +341,25 @@ static inline pgprot_t pgprot_modify(pgp
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+static inline int is_new_memtype_allowed(unsigned long flags,
+						unsigned long new_flags)
+{
+	/*
+	 * Certain new memtypes are not allowed with certain
+	 * requested memtype:
+	 * - request is uncached, return cannot be write-back
+	 * - request is write-combine, return cannot be write-back
+	 */
+	if ((flags == _PAGE_CACHE_UC_MINUS &&
+	     new_flags == _PAGE_CACHE_WB) ||
+	    (flags == _PAGE_CACHE_WC &&
+	     new_flags == _PAGE_CACHE_WB)) {
+		return 0;
+	}
+
+	return 1;
+}
+
 #ifndef __ASSEMBLY__
 /* Indicate that x86 has its own track and untrack pfn vma functions */
 #define __HAVE_PFNMAP_TRACKING
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c	2009-01-07 15:00:34.000000000 -0800
+++ linux-2.6/arch/x86/pci/i386.c	2009-01-07 16:03:20.000000000 -0800
@@ -314,17 +314,7 @@ int pci_mmap_page_range(struct pci_dev *
 		return retval;
 
 	if (flags != new_flags) {
-		/*
-		 * Do not fallback to certain memory types with certain
-		 * requested type:
-		 * - request is uncached, return cannot be write-back
-		 * - request is uncached, return cannot be write-combine
-		 * - request is write-combine, return cannot be write-back
-		 */
-		if ((flags == _PAGE_CACHE_UC_MINUS &&
-		     (new_flags == _PAGE_CACHE_WB)) ||
-		    (flags == _PAGE_CACHE_WC &&
-		     new_flags == _PAGE_CACHE_WB)) {
+		if (!is_new_memtype_allowed(flags, new_flags)) {
 			free_memtype(addr, addr+len);
 			return -EINVAL;
 		}

-- 

