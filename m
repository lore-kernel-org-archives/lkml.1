Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbZFIG7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbZFIG7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZFIG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:59:31 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:54418 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZFIG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:59:30 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 13/27] score: create head files mman.h mmu_context.h mmu.h module.h
 msgbug.h mutex.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF5DFE8AEA.A76450A1-ON482575D0.0023B236-482575D0.002423A3@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:30:26 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:30:27,
	Serialize complete at 2009/06/09 ?? 02:30:27
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ac497b397052e5d65fe21c2748dc230362dc6eb0 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:11 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/mman.h        |    6 ++
 arch/score/include/asm/mmu.h         |    6 ++
 arch/score/include/asm/mmu_context.h |  113 
++++++++++++++++++++++++++++++++++
 arch/score/include/asm/module.h      |   39 ++++++++++++
 arch/score/include/asm/msgbuf.h      |    6 ++
 arch/score/include/asm/mutex.h       |    6 ++
 6 files changed, 176 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/mman.h
 create mode 100644 arch/score/include/asm/mmu.h
 create mode 100644 arch/score/include/asm/mmu_context.h
 create mode 100644 arch/score/include/asm/module.h
 create mode 100644 arch/score/include/asm/msgbuf.h
 create mode 100644 arch/score/include/asm/mutex.h

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
diff --git a/arch/score/include/asm/mmu_context.h 
b/arch/score/include/asm/mmu_context.h
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
+#define TLBMISS_HANDLER_SETUP_PGD(pgd) (pgd_current = (unsigned 
long)(pgd))
+
+#define TLBMISS_HANDLER_SETUP()                                \
+do {                                                   \
+       write_c0_context(0);                            \
+       TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)       \
+} while (0)
+
+/*
+ * All unused by hardware upper bits will be considered
+ * as a software asid extension.
+ */
+#define ASID_VERSION_MASK      0xfffff000
+#define ASID_FIRST_VERSION     0x1000
+
+/* PEVN    --------- VPN ---------- --ASID--- -NA- */
+/* binary: 0000 0000 0000 0000 0000 0000 0001 0000 */
+/* binary: 0000 0000 0000 0000 0000 1111 1111 0000 */
+#define ASID_INC       0x10
+#define ASID_MASK      0xff0
+
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+                               struct task_struct *tsk)
+{}
+
+static inline void
+get_new_mmu_context(struct mm_struct *mm)
+{
+       unsigned long asid = asid_cache + ASID_INC;
+
+       if (!(asid & ASID_MASK)) {
+               local_flush_tlb_all();          /* start new asid cycle */
+               if (!asid)                      /* fix version if needed 
*/
+                       asid = ASID_FIRST_VERSION;
+       }
+
+       mm->context = asid;
+       asid_cache = asid;
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+       mm->context = 0;
+       return 0;
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct 
*next,
+                       struct task_struct *tsk)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       if ((next->context ^ asid_cache) & ASID_VERSION_MASK)
+               get_new_mmu_context(next);
+
+       pevn_set(next->context);
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
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
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(next);
+       pevn_set(next->context);
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
+}
+
+#endif /* _ASM_SCORE_MMU_CONTEXT_H */
diff --git a/arch/score/include/asm/module.h 
b/arch/score/include/asm/module.h
new file mode 100644
index 0000000..f0b5dc0
--- /dev/null
+++ b/arch/score/include/asm/module.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_SCORE_MODULE_H
+#define _ASM_SCORE_MODULE_H
+
+#include <linux/list.h>
+#include <asm/uaccess.h>
+
+struct mod_arch_specific {
+       /* Data Bus Error exception tables */
+       struct list_head dbe_list;
+       const struct exception_table_entry *dbe_start;
+       const struct exception_table_entry *dbe_end;
+};
+
+typedef uint8_t Elf64_Byte;            /* Type for a 8-bit quantity. */
+
+#define Elf_Shdr       Elf32_Shdr
+#define Elf_Sym                Elf32_Sym
+#define Elf_Ehdr       Elf32_Ehdr
+#define Elf_Addr       Elf32_Addr
+
+/* Given an address, look for it in the exception tables. */
+#ifdef CONFIG_MODULES
+const struct exception_table_entry *search_module_dbetables(unsigned long 
addr);
+#else
+static inline const struct exception_table_entry
+*search_module_dbetables(unsigned long addr)
+{
+       return NULL;
+}
+#endif
+
+#define MODULE_PROC_FAMILY "SCORE7"
+#define MODULE_KERNEL_TYPE "32BIT "
+#define MODULE_KERNEL_SMTC ""
+
+#define MODULE_ARCH_VERMAGIC \
+       MODULE_PROC_FAMILY MODULE_KERNEL_TYPE MODULE_KERNEL_SMTC
+
+#endif /* _ASM_SCORE_MODULE_H */
diff --git a/arch/score/include/asm/msgbuf.h 
b/arch/score/include/asm/msgbuf.h
new file mode 100644
index 0000000..7506721
--- /dev/null
+++ b/arch/score/include/asm/msgbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MSGBUF_H
+#define _ASM_SCORE_MSGBUF_H
+
+#include <asm-generic/msgbuf.h>
+
+#endif /* _ASM_SCORE_MSGBUF_H */
diff --git a/arch/score/include/asm/mutex.h 
b/arch/score/include/asm/mutex.h
new file mode 100644
index 0000000..10d48fe
--- /dev/null
+++ b/arch/score/include/asm/mutex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MUTEX_H
+#define _ASM_SCORE_MUTEX_H
+
+#include <asm-generic/mutex-dec.h>
+
+#endif /* _ASM_SCORE_MUTEX_H */
-- 
1.6.2

