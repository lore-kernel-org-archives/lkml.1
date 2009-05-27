Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbZE0Hc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbZE0Hc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762405AbZE0H07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:59 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46937 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762361AbZE0H05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:57 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 06/29] microblaze_mmu_v2: mmu.h update
Date: Wed, 27 May 2009 08:47:31 +0200
Message-Id: <1243406874-3917-7-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-6-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/mmu.h |  104 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/include/asm/mmu.h b/arch/microblaze/include/asm/mmu.h
index 0e0431d..66cad6a 100644
--- a/arch/microblaze/include/asm/mmu.h
+++ b/arch/microblaze/include/asm/mmu.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,11 +11,109 @@
 #ifndef _ASM_MICROBLAZE_MMU_H
 #define _ASM_MICROBLAZE_MMU_H
 
-#ifndef __ASSEMBLY__
+# ifndef CONFIG_MMU
+#  ifndef __ASSEMBLY__
 typedef struct {
 	struct vm_list_struct	*vmlist;
 	unsigned long		end_brk;
 } mm_context_t;
-#endif /* __ASSEMBLY__ */
+#  endif /* __ASSEMBLY__ */
+# else /* CONFIG_MMU */
+#  ifdef __KERNEL__
+#   ifndef __ASSEMBLY__
 
+/* Default "unsigned long" context */
+typedef unsigned long mm_context_t;
+
+/* Hardware Page Table Entry */
+typedef struct _PTE {
+	unsigned long    v:1;	/* Entry is valid */
+	unsigned long vsid:24;	/* Virtual segment identifier */
+	unsigned long    h:1;	/* Hash algorithm indicator */
+	unsigned long  api:6;	/* Abbreviated page index */
+	unsigned long  rpn:20;	/* Real (physical) page number */
+	unsigned long     :3;	/* Unused */
+	unsigned long    r:1;	/* Referenced */
+	unsigned long    c:1;	/* Changed */
+	unsigned long    w:1;	/* Write-thru cache mode */
+	unsigned long    i:1;	/* Cache inhibited */
+	unsigned long    m:1;	/* Memory coherence */
+	unsigned long    g:1;	/* Guarded */
+	unsigned long     :1;	/* Unused */
+	unsigned long   pp:2;	/* Page protection */
+} PTE;
+
+/* Values for PP (assumes Ks=0, Kp=1) */
+#  define PP_RWXX	0 /* Supervisor read/write, User none */
+#  define PP_RWRX	1 /* Supervisor read/write, User read */
+#  define PP_RWRW	2 /* Supervisor read/write, User read/write */
+#  define PP_RXRX	3 /* Supervisor read,       User read */
+
+/* Segment Register */
+typedef struct _SEGREG {
+	unsigned long    t:1;	/* Normal or I/O  type */
+	unsigned long   ks:1;	/* Supervisor 'key' (normally 0) */
+	unsigned long   kp:1;	/* User 'key' (normally 1) */
+	unsigned long    n:1;	/* No-execute */
+	unsigned long     :4;	/* Unused */
+	unsigned long vsid:24;	/* Virtual Segment Identifier */
+} SEGREG;
+
+extern void _tlbie(unsigned long va);	/* invalidate a TLB entry */
+extern void _tlbia(void);		/* invalidate all TLB entries */
+#   endif /* __ASSEMBLY__ */
+
+/*
+ * The MicroBlaze processor has a TLB architecture identical to PPC-40x. The
+ * instruction and data sides share a unified, 64-entry, semi-associative
+ * TLB which is maintained totally under software control. In addition, the
+ * instruction side has a hardware-managed, 2,4, or 8-entry, fully-associative
+ * TLB which serves as a first level to the shared TLB. These two TLBs are
+ * known as the UTLB and ITLB, respectively.
+ */
+
+#  define MICROBLAZE_TLB_SIZE 64
+
+/*
+ * TLB entries are defined by a "high" tag portion and a "low" data
+ * portion. The data portion is 32-bits.
+ *
+ * TLB entries are managed entirely under software control by reading,
+ * writing, and searching using the MTS and MFS instructions.
+ */
+
+#  define TLB_LO		1
+#  define TLB_HI		0
+#  define TLB_DATA		TLB_LO
+#  define TLB_TAG		TLB_HI
+
+/* Tag portion */
+#  define TLB_EPN_MASK		0xFFFFFC00 /* Effective Page Number */
+#  define TLB_PAGESZ_MASK	0x00000380
+#  define TLB_PAGESZ(x)		(((x) & 0x7) << 7)
+#  define PAGESZ_1K		0
+#  define PAGESZ_4K		1
+#  define PAGESZ_16K		2
+#  define PAGESZ_64K		3
+#  define PAGESZ_256K		4
+#  define PAGESZ_1M		5
+#  define PAGESZ_4M		6
+#  define PAGESZ_16M		7
+#  define TLB_VALID		0x00000040 /* Entry is valid */
+
+/* Data portion */
+#  define TLB_RPN_MASK		0xFFFFFC00 /* Real Page Number */
+#  define TLB_PERM_MASK		0x00000300
+#  define TLB_EX		0x00000200 /* Instruction execution allowed */
+#  define TLB_WR		0x00000100 /* Writes permitted */
+#  define TLB_ZSEL_MASK		0x000000F0
+#  define TLB_ZSEL(x)		(((x) & 0xF) << 4)
+#  define TLB_ATTR_MASK		0x0000000F
+#  define TLB_W			0x00000008 /* Caching is write-through */
+#  define TLB_I			0x00000004 /* Caching is inhibited */
+#  define TLB_M			0x00000002 /* Memory is coherent */
+#  define TLB_G			0x00000001 /* Memory is guarded from prefetch */
+
+#  endif /* __KERNEL__ */
+# endif /* CONFIG_MMU */
 #endif /* _ASM_MICROBLAZE_MMU_H */
-- 
1.5.5.1

