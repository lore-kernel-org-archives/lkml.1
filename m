Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbZE0Ha6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbZE0Ha6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbZE0H0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:32 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46919 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762301AbZE0H0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:31 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 13/29] microblaze_mmu_v2: Update tlb.h and tlbflush.h
Date: Wed, 27 May 2009 08:47:38 +0200
Message-Id: <1243406874-3917-14-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-13-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/tlb.h      |    8 +++++
 arch/microblaze/include/asm/tlbflush.h |   48 ++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/tlb.h b/arch/microblaze/include/asm/tlb.h
index d1dfe37..c472d28 100644
--- a/arch/microblaze/include/asm/tlb.h
+++ b/arch/microblaze/include/asm/tlb.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -13,4 +15,10 @@
 
 #include <asm-generic/tlb.h>
 
+#ifdef CONFIG_MMU
+#define tlb_start_vma(tlb, vma)		do { } while (0)
+#define tlb_end_vma(tlb, vma)		do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, pte, address) do { } while (0)
+#endif
+
 #endif /* _ASM_MICROBLAZE_TLB_H */
diff --git a/arch/microblaze/include/asm/tlbflush.h b/arch/microblaze/include/asm/tlbflush.h
index d7fe762..eb31a0e 100644
--- a/arch/microblaze/include/asm/tlbflush.h
+++ b/arch/microblaze/include/asm/tlbflush.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,6 +11,50 @@
 #ifndef _ASM_MICROBLAZE_TLBFLUSH_H
 #define _ASM_MICROBLAZE_TLBFLUSH_H
 
+#ifdef CONFIG_MMU
+
+#include <linux/sched.h>
+#include <linux/threads.h>
+#include <asm/processor.h>	/* For TASK_SIZE */
+#include <asm/mmu.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+
+extern void _tlbie(unsigned long address);
+extern void _tlbia(void);
+
+#define __tlbia()	_tlbia()
+
+static inline void local_flush_tlb_all(void)
+	{ __tlbia(); }
+static inline void local_flush_tlb_mm(struct mm_struct *mm)
+	{ __tlbia(); }
+static inline void local_flush_tlb_page(struct vm_area_struct *vma,
+				unsigned long vmaddr)
+	{ _tlbie(vmaddr); }
+static inline void local_flush_tlb_range(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+	{ __tlbia(); }
+
+#define flush_tlb_kernel_range(start, end)	do { } while (0)
+
+#define update_mmu_cache(vma, addr, pte)	do { } while (0)
+
+#define flush_tlb_all local_flush_tlb_all
+#define flush_tlb_mm local_flush_tlb_mm
+#define flush_tlb_page local_flush_tlb_page
+#define flush_tlb_range local_flush_tlb_range
+
+/*
+ * This is called in munmap when we have freed up some page-table
+ * pages.  We don't need to do anything here, there's nothing special
+ * about our page-table pages.  -- paulus
+ */
+static inline void flush_tlb_pgtables(struct mm_struct *mm,
+	unsigned long start, unsigned long end) { }
+
+#else /* CONFIG_MMU */
+
 #define flush_tlb()				BUG()
 #define flush_tlb_all()				BUG()
 #define flush_tlb_mm(mm)			BUG()
@@ -17,4 +63,6 @@
 #define flush_tlb_pgtables(mm, start, end)	BUG()
 #define flush_tlb_kernel_range(start, end)	BUG()
 
+#endif /* CONFIG_MMU */
+
 #endif /* _ASM_MICROBLAZE_TLBFLUSH_H */
-- 
1.5.5.1

