Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYKLXWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYKLXWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYKLXUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:43883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824AbYKLXUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="402946569"
Message-Id: <20081112212900.860540000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:54 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 7/8] x86 PAT: add pgprot_writecombine() interface for drivers
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

Index: tip/include/asm-generic/pgtable.h
===================================================================
--- tip.orig/include/asm-generic/pgtable.h	2008-11-12 12:03:41.000000000 -0800
+++ tip/include/asm-generic/pgtable.h	2008-11-12 12:09:34.000000000 -0800
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
Index: tip/arch/x86/include/asm/pgtable.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable.h	2008-11-12 12:09:31.000000000 -0800
+++ tip/arch/x86/include/asm/pgtable.h	2008-11-12 12:09:34.000000000 -0800
@@ -168,6 +168,9 @@
 
 #ifndef __ASSEMBLY__
 
+#define pgprot_writecombine	pgprot_writecombine
+extern pgprot_t pgprot_writecombine(pgprot_t prot);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
Index: tip/arch/x86/mm/pat.c
===================================================================
--- tip.orig/arch/x86/mm/pat.c	2008-11-12 12:06:50.000000000 -0800
+++ tip/arch/x86/mm/pat.c	2008-11-12 12:09:34.000000000 -0800
@@ -797,6 +797,14 @@ void untrack_pfn_vma(struct vm_area_stru
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

