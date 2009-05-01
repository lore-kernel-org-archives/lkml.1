Return-Path: <linux-kernel-owner+w=401wt.eu-S1765195AbZEAOzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765195AbZEAOzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762721AbZEAOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:43:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36925 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761117AbZEAOm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:56 -0400
Subject: [RFC][PATCH 34/35] powerpc use generic ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:54 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144254.52127677@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


powerpc is a bid of an oddball here.  It seems to have CONFIG_HIGHPTE
behavior at all times when compiled as 32-bit.  There's even an
#ifdef CONFIG_HIGHPTE in arch/powerpc/mm/pgtable_32.c, but there's no
trace of HIGHPTE in Kconfig anywhere.

This gives ppc32 an explicit HIGHPTE in Kconfig so that we can use
the #ifdef in asm-generic/ptemap.h and let ppc use the generic code
with x86 and frv.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/powerpc/Kconfig              |    4 ++++
 linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h |   18 ++++++------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/include/asm/ptemap.h~powerpc-pte_offset_kernel arch/powerpc/include/asm/ptemap.h
--- linux-2.6.git/arch/powerpc/include/asm/ptemap.h~powerpc-pte_offset_kernel	2009-04-30 15:11:13.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h	2009-04-30 15:11:13.000000000 -0700
@@ -2,19 +2,13 @@
 #define _POWERPC_ASM_PTEMAP_H
 
 #ifndef __powerpc64__
-
-#define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
-#define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
-
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
-
-#else /* __powerpc64__ */
+/*
+ * This lets us use the x86 implementation
+ * in the generic ptemap.h
+ */
+#define kmap_atomic_pte(page, type) kmap_atomic(page, type)
+#endif
 
 #include <asm-generic/ptemap.h>
 
-#endif
-
 #endif /* _POWERPC_ASM_PTEMAP_H */
diff -puN arch/powerpc/Kconfig~powerpc-pte_offset_kernel arch/powerpc/Kconfig
--- linux-2.6.git/arch/powerpc/Kconfig~powerpc-pte_offset_kernel	2009-04-30 15:11:13.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/Kconfig	2009-04-30 15:11:13.000000000 -0700
@@ -244,6 +244,10 @@ config HIGHMEM
 	bool "High memory support"
 	depends on PPC32
 
+config HIGHPTE
+	def_bool y
+	depends on HIGHMEM
+
 source kernel/time/Kconfig
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
_
