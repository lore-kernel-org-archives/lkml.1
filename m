Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZHZG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZHZG3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZHZG3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:29:17 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:52651
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbZHZG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:29:16 -0400
Subject: Subject: [PATCH 12/33] score: create head files mman.h mmu.h
	mmu_context.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:18:53 +0800
Message-Id: <1251267533.3073.17.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea8c2b7695927955321995364b681f69f0ce9a0a Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:01 +0800
Subject: [PATCH 12/33] score: create head files mman.h mmu.h mmu_context.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/mman.h        |    6 ++
 arch/score/include/asm/mmu.h         |    6 ++
 arch/score/include/asm/mmu_context.h |  113 ++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/mman.h
 create mode 100644 arch/score/include/asm/mmu.h
 create mode 100644 arch/score/include/asm/mmu_context.h

diff --git a/arch/score/include/asm/mman.h b/arch/score/include/asm/mman.h
new file mode 100644
index 0000000..84d85dd
--- /dev/null
+++ b/arch/score/include/asm/mman.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MMAN_H
+#define _ASM_SCORE_MMAN_H
+
+#include <asm-generic/mman.h>
+
+#endif /* _ASM_SCORE_MMAN_H */
diff --git a/arch/score/include/asm/mmu.h b/arch/score/include/asm/mmu.h
new file mode 100644
index 0000000..676828e
--- /dev/null
+++ b/arch/score/include/asm/mmu.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MMU_H
+#define _ASM_SCORE_MMU_H
+
+typedef unsigned long mm_context_t;
+
+#endif /* _ASM_SCORE_MMU_H */
diff --git a/arch/score/include/asm/mmu_context.h b/arch/score/include/asm/mmu_context.h
new file mode 100644
index 0000000..2644577
--- /dev/null
+++ b/arch/score/include/asm/mmu_context.h
@@ -0,0 +1,113 @@
+#ifndef _ASM_SCORE_MMU_CONTEXT_H
+#define _ASM_SCORE_MMU_CONTEXT_H
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <asm-generic/mm_hooks.h>
+
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/scoreregs.h>
+
+/*
+ * For the fast tlb miss handlers, we keep a per cpu array of pointers
+ * to the current pgd for each processor. Also, the proc. id is stuffed
+ * into the context register.
+ */
+extern unsigned long asid_cache;
+extern unsigned long pgd_current;
+
+#define TLBMISS_HANDLER_SETUP_PGD(pgd) (pgd_current = (unsigned long)(pgd))
+
+#define TLBMISS_HANDLER_SETUP()				\
+do {							\
+	write_c0_context(0);				\
+	TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)	\
+} while (0)
+
+/*
+ * All unused by hardware upper bits will be considered
+ * as a software asid extension.
+ */
+#define ASID_VERSION_MASK	0xfffff000
+#define ASID_FIRST_VERSION	0x1000
+
+/* PEVN    --------- VPN ---------- --ASID--- -NA- */
+/* binary: 0000 0000 0000 0000 0000 0000 0001 0000 */
+/* binary: 0000 0000 0000 0000 0000 1111 1111 0000 */
+#define ASID_INC	0x10
+#define ASID_MASK	0xff0
+
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+				struct task_struct *tsk)
+{}
+
+static inline void
+get_new_mmu_context(struct mm_struct *mm)
+{
+	unsigned long asid = asid_cache + ASID_INC;
+
+	if (!(asid & ASID_MASK)) {
+		local_flush_tlb_all();		/* start new asid cycle */
+		if (!asid)			/* fix version if needed */
+			asid = ASID_FIRST_VERSION;
+	}
+
+	mm->context = asid;
+	asid_cache = asid;
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	mm->context = 0;
+	return 0;
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if ((next->context ^ asid_cache) & ASID_VERSION_MASK)
+		get_new_mmu_context(next);
+
+	pevn_set(next->context);
+	TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+	local_irq_restore(flags);
+}
+
+/*
+ * Destroy context related info for an mm_struct that is about
+ * to be put to rest.
+ */
+static inline void destroy_context(struct mm_struct *mm)
+{}
+
+static inline void
+deactivate_mm(struct task_struct *task, struct mm_struct *mm)
+{}
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+static inline void
+activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	get_new_mmu_context(next);
+	pevn_set(next->context);
+	TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+	local_irq_restore(flags);
+}
+
+#endif /* _ASM_SCORE_MMU_CONTEXT_H */
-- 
1.6.2



