Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753393AbYLRUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYLRUDe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYLRUBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:42973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYLRUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="415657768"
Message-Id: <20081218194617.828992000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:32 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 6/7] x86 PAT: add pgprot_writecombine() interface for drivers - v3
Content-Disposition: inline; filename=add_pgprot_writecombine.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pgprot_writecombine. pgprot_writecombine will be aliased to
pgprot_noncached when not supported by the architecture.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h |    3 +++
 arch/x86/mm/pat.c              |    8 ++++++++
 include/asm-generic/pgtable.h  |    4 ++++
 3 files changed, 15 insertions(+)

Index: linux-2.6/include/asm-generic/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-generic/pgtable.h	2008-12-17 15:01:51.000000000 -0800
+++ linux-2.6/include/asm-generic/pgtable.h	2008-12-17 17:23:11.000000000 -0800
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef pgprot_writecombine
+#define pgprot_writecombine pgprot_noncached
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2008-12-17 17:23:07.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2008-12-17 17:23:11.000000000 -0800
@@ -168,6 +168,9 @@
 
 #ifndef __ASSEMBLY__
 
+#define pgprot_writecombine	pgprot_writecombine
+extern pgprot_t pgprot_writecombine(pgprot_t prot);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-12-17 17:22:59.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2008-12-17 17:23:11.000000000 -0800
@@ -832,6 +832,14 @@ void untrack_pfn_vma(struct vm_area_stru
 	}
 }
 
+pgprot_t pgprot_writecombine(pgprot_t prot)
+{
+	if (pat_enabled)
+		return __pgprot(pgprot_val(prot) | _PAGE_CACHE_WC);
+	else
+		return pgprot_noncached(prot);
+}
+
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */

-- 

