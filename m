Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYKLXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYKLXXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYKLXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:55947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbYKLXUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="75121292"
Message-Id: <20081112212900.719555000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:53 -0800
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
Subject: [patch 6/8] x86 PAT: change pgprot_noncached to uc_minus instead of strong uc
Content-Disposition: inline; filename=make_pgprot_noncached_ucminus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pgprot_noncached uc_minus instead of strong UC. This will make
pgprot_noncached to be in line with ioremap_nocache() and all the other
APIs that map page uc_minus on uc request.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h    |    8 ++++++++
 arch/x86/include/asm/pgtable_32.h |    9 ---------
 arch/x86/include/asm/pgtable_64.h |    6 ------
 3 files changed, 8 insertions(+), 15 deletions(-)

Index: tip/arch/x86/include/asm/pgtable.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable.h	2008-11-06 15:58:21.000000000 -0800
+++ tip/arch/x86/include/asm/pgtable.h	2008-11-10 09:44:38.000000000 -0800
@@ -158,6 +158,14 @@
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 
+/*
+ * Macro to mark a page protection value as UC-
+ */
+#define pgprot_noncached(prot)					\
+	((boot_cpu_data.x86 > 3)				\
+	 ? (__pgprot(pgprot_val(prot) | _PAGE_CACHE_UC_MINUS))	\
+	 : (prot))
+
 #ifndef __ASSEMBLY__
 
 /*
Index: tip/arch/x86/include/asm/pgtable_32.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable_32.h	2008-11-06 09:44:12.000000000 -0800
+++ tip/arch/x86/include/asm/pgtable_32.h	2008-11-06 16:17:11.000000000 -0800
@@ -107,15 +107,6 @@ extern unsigned long pg0[];
 #endif
 
 /*
- * Macro to mark a page protection value as "uncacheable".
- * On processors which do not support it, this is a no-op.
- */
-#define pgprot_noncached(prot)					\
-	((boot_cpu_data.x86 > 3)				\
-	 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))	\
-	 : (prot))
-
-/*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */
Index: tip/arch/x86/include/asm/pgtable_64.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable_64.h	2008-11-06 09:44:12.000000000 -0800
+++ tip/arch/x86/include/asm/pgtable_64.h	2008-11-06 16:17:11.000000000 -0800
@@ -183,12 +183,6 @@ static inline int pmd_bad(pmd_t pmd)
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 
 /*
- * Macro to mark a page protection value as "uncacheable".
- */
-#define pgprot_noncached(prot)					\
-	(__pgprot(pgprot_val((prot)) | _PAGE_PCD | _PAGE_PWT))
-
-/*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */

-- 

