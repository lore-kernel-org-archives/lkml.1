Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYFYElf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYFYElf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYFYEhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:22 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37449 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753956AbYFYEhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 36] x86: unify mmu_context.h
X-Mercurial-Node: 64c0ff3012c1e31a513b4509aa227e893269ac4a
Message-Id: <64c0ff3012c1e31a513b.1214367547@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some amount of asm-x86/mmu_context.h can be unified, including
activate_mm paravirt hook.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/mmu_context.h    |   32 ++++++++++++++++++++++++++++++++
 include/asm-x86/mmu_context_32.h |   28 ----------------------------
 include/asm-x86/mmu_context_64.h |   18 ------------------
 3 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/include/asm-x86/mmu_context.h b/include/asm-x86/mmu_context.h
--- a/include/asm-x86/mmu_context.h
+++ b/include/asm-x86/mmu_context.h
@@ -1,5 +1,37 @@
+#ifndef __ASM_X86_MMU_CONTEXT_H
+#define __ASM_X86_MMU_CONTEXT_H
+
+#include <asm/desc.h>
+#include <asm/atomic.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+#include <asm/paravirt.h>
+#ifndef CONFIG_PARAVIRT
+#include <asm-generic/mm_hooks.h>
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif	/* !CONFIG_PARAVIRT */
+
+/*
+ * Used for LDT copy/destruction.
+ */
+int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
+void destroy_context(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_32
 # include "mmu_context_32.h"
 #else
 # include "mmu_context_64.h"
 #endif
+
+#define activate_mm(prev, next)			\
+do {						\
+	paravirt_activate_mm((prev), (next));	\
+	switch_mm((prev), (next), NULL);	\
+} while (0);
+
+
+#endif /* __ASM_X86_MMU_CONTEXT_H */
diff --git a/include/asm-x86/mmu_context_32.h b/include/asm-x86/mmu_context_32.h
--- a/include/asm-x86/mmu_context_32.h
+++ b/include/asm-x86/mmu_context_32.h
@@ -1,27 +1,5 @@
 #ifndef __I386_SCHED_H
 #define __I386_SCHED_H
-
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/pgalloc.h>
-#include <asm/tlbflush.h>
-#include <asm/paravirt.h>
-#ifndef CONFIG_PARAVIRT
-#include <asm-generic/mm_hooks.h>
-
-static inline void paravirt_activate_mm(struct mm_struct *prev,
-					struct mm_struct *next)
-{
-}
-#endif	/* !CONFIG_PARAVIRT */
-
-
-/*
- * Used for LDT copy/destruction.
- */
-int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
-void destroy_context(struct mm_struct *mm);
-
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
@@ -75,10 +53,4 @@
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next)			\
-do {						\
-	paravirt_activate_mm((prev), (next));	\
-	switch_mm((prev), (next), NULL);	\
-} while (0);
-
 #endif
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -1,21 +1,7 @@
 #ifndef __X86_64_MMU_CONTEXT_H
 #define __X86_64_MMU_CONTEXT_H
 
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/pgalloc.h>
 #include <asm/pda.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
-#ifndef CONFIG_PARAVIRT
-#include <asm-generic/mm_hooks.h>
-#endif
-
-/*
- * possibly do the LDT unload here?
- */
-int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
-void destroy_context(struct mm_struct *mm);
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
@@ -65,8 +51,4 @@
 	asm volatile("movl %0,%%fs"::"r"(0));	\
 } while (0)
 
-#define activate_mm(prev, next)			\
-	switch_mm((prev), (next), NULL)
-
-
 #endif


