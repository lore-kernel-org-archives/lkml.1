Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZD0Jzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZD0Jzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZD0Jsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:51 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754927AbZD0Jsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:50 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 10/30] microblaze_mmu_v1: Context handling - mmu_context.c/h
Date: Mon, 27 Apr 2009 10:31:59 +0200
Message-Id: <1240821139-7247-11-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-10-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/mmu_context.h |  134 +++++++++++++++++++++++++++++
 arch/microblaze/mm/mmu_context.c          |   70 +++++++++++++++
 2 files changed, 204 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/mmu_context.c

diff --git a/arch/microblaze/include/asm/mmu_context.h b/arch/microblaze/include/asm/mmu_context.h
index 150ca01..2f49649 100644
--- a/arch/microblaze/include/asm/mmu_context.h
+++ b/arch/microblaze/include/asm/mmu_context.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,6 +11,7 @@
 #ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
 #define _ASM_MICROBLAZE_MMU_CONTEXT_H
 
+# ifndef CONFIG_MMU
 # define init_new_context(tsk, mm)		({ 0; })
 
 # define enter_lazy_tlb(mm, tsk)		do {} while (0)
@@ -18,4 +21,135 @@
 # define switch_mm(prev, next, tsk)		do {} while (0)
 # define activate_mm(prev, next)		do {} while (0)
 
+# else /* CONFIG_MMU */
+
+# include <asm/atomic.h>
+# include <asm/bitops.h>
+# include <asm/mmu.h>
+# include <asm-generic/mm_hooks.h>
+
+#  ifdef __KERNEL__
+/*
+ * This function defines the mapping from contexts to VSIDs (virtual
+ * segment IDs).  We use a skew on both the context and the high 4 bits
+ * of the 32-bit virtual address (the "effective segment ID") in order
+ * to spread out the entries in the MMU hash table.  Note, if this
+ * function is changed then arch/ppc/mm/hashtable.S will have to be
+ * changed to correspond.
+ */
+#  define CTX_TO_VSID(ctx, va)	(((ctx) * (897 * 16) + ((va) >> 28) * 0x111) \
+				 & 0xffffff)
+
+/*
+   MicroBlaze has 256 contexts, so we can just rotate through these
+   as a way of "switching" contexts.  If the TID of the TLB is zero,
+   the PID/TID comparison is disabled, so we can use a TID of zero
+   to represent all kernel pages as shared among all contexts.
+ */
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+#  define NO_CONTEXT	256
+#  define LAST_CONTEXT	255
+#  define FIRST_CONTEXT	1
+
+/*
+ * Set the current MMU context.
+ * This is done byloading up the segment registers for the user part of the
+ * address space.
+ *
+ * Since the PGD is immediately available, it is much faster to simply
+ * pass this along as a second parameter, which is required for 8xx and
+ * can be used for debugging on all processors (if you happen to have
+ * an Abatron).
+ */
+extern void set_context(mm_context_t context, pgd_t *pgd);
+
+/*
+ * Bitmap of contexts in use.
+ * The size of this bitmap is LAST_CONTEXT + 1 bits.
+ */
+extern unsigned long context_map[];
+
+/*
+ * This caches the next context number that we expect to be free.
+ * Its use is an optimization only, we can't rely on this context
+ * number to be free, but it usually will be.
+ */
+extern mm_context_t next_mmu_context;
+
+/*
+ * Since we don't have sufficient contexts to give one to every task
+ * that could be in the system, we need to be able to steal contexts.
+ * These variables support that.
+ */
+extern atomic_t nr_free_contexts;
+extern struct mm_struct *context_mm[LAST_CONTEXT+1];
+extern void steal_context(void);
+
+/*
+ * Get a new mmu context for the address space described by `mm'.
+ */
+static inline void get_mmu_context(struct mm_struct *mm)
+{
+	mm_context_t ctx;
+
+	if (mm->context != NO_CONTEXT)
+		return;
+	while (atomic_dec_if_positive(&nr_free_contexts) < 0)
+		steal_context();
+	ctx = next_mmu_context;
+	while (test_and_set_bit(ctx, context_map)) {
+		ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1, ctx);
+		if (ctx > LAST_CONTEXT)
+			ctx = 0;
+	}
+	next_mmu_context = (ctx + 1) & LAST_CONTEXT;
+	mm->context = ctx;
+	context_mm[ctx] = mm;
+}
+
+/*
+ * Set up the context for a new address space.
+ */
+#  define init_new_context(tsk, mm)	(((mm)->context = NO_CONTEXT), 0)
+
+/*
+ * We're finished using the context for an address space.
+ */
+static inline void destroy_context(struct mm_struct *mm)
+{
+	if (mm->context != NO_CONTEXT) {
+		clear_bit(mm->context, context_map);
+		mm->context = NO_CONTEXT;
+		atomic_inc(&nr_free_contexts);
+	}
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	tsk->thread.pgdir = next->pgd;
+	get_mmu_context(next);
+	set_context(next->context, next->pgd);
+}
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+static inline void activate_mm(struct mm_struct *active_mm,
+			struct mm_struct *mm)
+{
+	current->thread.pgdir = mm->pgd;
+	get_mmu_context(mm);
+	set_context(mm->context, mm->pgd);
+}
+
+extern void mmu_context_init(void);
+
+#  endif /* __KERNEL__ */
+# endif /* CONFIG_MMU */
 #endif /* _ASM_MICROBLAZE_MMU_CONTEXT_H */
diff --git a/arch/microblaze/mm/mmu_context.c b/arch/microblaze/mm/mmu_context.c
new file mode 100644
index 0000000..26ff82f
--- /dev/null
+++ b/arch/microblaze/mm/mmu_context.c
@@ -0,0 +1,70 @@
+/*
+ * This file contains the routines for handling the MMU.
+ *
+ *    Copyright (C) 2007 Xilinx, Inc.  All rights reserved.
+ *
+ *  Derived from arch/ppc/mm/4xx_mmu.c:
+ *  -- paulus
+ *
+ *  Derived from arch/ppc/mm/init.c:
+ *    Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
+ *
+ *  Modifications by Paul Mackerras (PowerMac) (paulus@cs.anu.edu.au)
+ *  and Cort Dougan (PReP) (cort@cs.nmt.edu)
+ *    Copyright (C) 1996 Paul Mackerras
+ *  Amiga/APUS changes by Jesper Skov (jskov@cygnus.co.uk).
+ *
+ *  Derived from "arch/i386/mm/init.c"
+ *    Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/mm.h>
+#include <linux/init.h>
+
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+
+mm_context_t next_mmu_context;
+unsigned long context_map[LAST_CONTEXT / BITS_PER_LONG + 1];
+atomic_t nr_free_contexts;
+struct mm_struct *context_mm[LAST_CONTEXT+1];
+
+/*
+ * Initialize the context management stuff.
+ */
+void __init mmu_context_init(void)
+{
+	/*
+	 * The use of context zero is reserved for the kernel.
+	 * This code assumes FIRST_CONTEXT < 32.
+	 */
+	context_map[0] = (1 << FIRST_CONTEXT) - 1;
+	next_mmu_context = FIRST_CONTEXT;
+	atomic_set(&nr_free_contexts, LAST_CONTEXT - FIRST_CONTEXT + 1);
+}
+
+/*
+ * Steal a context from a task that has one at the moment.
+ *
+ * This isn't an LRU system, it just frees up each context in
+ * turn (sort-of pseudo-random replacement :).  This would be the
+ * place to implement an LRU scheme if anyone were motivated to do it.
+ */
+void steal_context(void)
+{
+	struct mm_struct *mm;
+
+	/* free up context `next_mmu_context' */
+	/* if we shouldn't free context 0, don't... */
+	if (next_mmu_context < FIRST_CONTEXT)
+		next_mmu_context = FIRST_CONTEXT;
+	mm = context_mm[next_mmu_context];
+	flush_tlb_mm(mm);
+	destroy_context(mm);
+}
-- 
1.5.5.1

