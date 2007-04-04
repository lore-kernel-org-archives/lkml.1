Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXDDG3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXDDG3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992703AbXDDG2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:24 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:25028 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992700AbXDDG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:13 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="26306155:sNHT23891259"
Subject: [PATCH] Blackfin arch: using asm-generic pgtable header file by
	adding PAGE access macros based on CPLB management
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:27:46 +0800
Message-Id: <1175668066.10608.36.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/pgtable.h |   44 +++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/include/asm-blackfin/pgtable.h b/include/asm-blackfin/pgtable.h
index 9328537..5a8f9e4 100644
--- a/include/asm-blackfin/pgtable.h
+++ b/include/asm-blackfin/pgtable.h
@@ -3,7 +3,8 @@
 
 #include <asm-generic/4level-fixup.h>
 
-#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/cplb.h>
 
 typedef pte_t *pte_addr_t;
 /*
@@ -14,7 +15,12 @@ typedef pte_t *pte_addr_t;
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *)0)
+
+#define pmd_offset(a, b)	((void *)0)
+#define pmd_none(x)		(!pmd_val(x))
+#define pmd_present(x)		(pmd_val(x))
+#define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
+#define pmd_bad(x)		(pmd_val(x) & ~PAGE_MASK)
 
 #define kern_addr_valid(addr) (1)
 
@@ -37,6 +43,32 @@ static inline int pte_file(pte_t pte)
 	return 0;
 }
 
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+/*
+ * Page assess control based on Blackfin CPLB management
+ */
+#define _PAGE_RD	(CPLB_USER_RD)
+#define _PAGE_WR	(CPLB_USER_WR)
+#define _PAGE_USER	(CPLB_USER_RD | CPLB_USER_WR)
+#define _PAGE_ACCESSED	CPLB_ALL_ACCESS
+#define _PAGE_DIRTY	(CPLB_DIRTY)
+
+#define PTE_BIT_FUNC(fn, op) \
+	static inline pte_t pte_##fn(pte_t _pte) { _pte.pte op; return _pte; }
+
+PTE_BIT_FUNC(rdprotect, &= ~_PAGE_RD);
+PTE_BIT_FUNC(mkread, |= _PAGE_RD);
+PTE_BIT_FUNC(wrprotect, &= ~_PAGE_WR);
+PTE_BIT_FUNC(mkwrite, |= _PAGE_WR);
+PTE_BIT_FUNC(exprotect, &= ~_PAGE_USER);
+PTE_BIT_FUNC(mkexec, |= _PAGE_USER);
+PTE_BIT_FUNC(mkclean, &= ~_PAGE_DIRTY);
+PTE_BIT_FUNC(mkdirty, |= _PAGE_DIRTY);
+PTE_BIT_FUNC(mkold, &= ~_PAGE_ACCESSED);
+PTE_BIT_FUNC(mkyoung, |= _PAGE_ACCESSED);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
@@ -59,12 +91,6 @@ extern unsigned int kobjsize(const void *objp);
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
-#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#include <asm-generic/pgtable.h>
 
 #endif				/* _BLACKFIN_PGTABLE_H */
-- 
1.5.0.5

