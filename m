Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753551AbYLRUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYLRUEU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYLRUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:16214 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYLRUBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="650947631"
Message-Id: <20081218194617.684582000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:31 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/7] x86 PAT: change pgprot_noncached to uc_minus instead of strong uc - v3
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

Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2008-12-17 17:09:16.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2008-12-17 17:23:07.000000000 -0800
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
Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h	2008-12-17 15:01:51.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable_32.h	2008-12-17 17:23:07.000000000 -0800
@@ -101,15 +101,6 @@ extern unsigned long pg0[];
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
Index: linux-2.6/arch/x86/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_64.h	2008-12-17 15:01:51.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable_64.h	2008-12-17 17:23:07.000000000 -0800
@@ -177,12 +177,6 @@ static inline int pmd_bad(pmd_t pmd)
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

