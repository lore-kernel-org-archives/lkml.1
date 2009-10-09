Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbZJINGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbZJINGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZJINGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:06:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:33139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZJINGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:06:18 -0400
Subject: Re: [RFC][PATCH 0/4] stack based kmap_atomic -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20091008232226.768382977@chello.nl>
References: <20091008232226.768382977@chello.nl>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 15:05:30 +0200
Message-Id: <1255093530.8802.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 01:22 +0200, Peter Zijlstra wrote:
> 
> Maybe FRV can do a kind of kmap-stack switch on (soft)irq enter/exit
> in order to stay below 5 entries.

David, would something like the below work for you?

You'd need to disallow nested hardirqs, but I'm not sure FRV suffers
that particular issue?

---
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h
+++ linux-2.6/include/linux/highmem.h
@@ -83,6 +83,30 @@ static inline void *kmap_atomic(struct p
 
 #endif /* CONFIG_HIGHMEM */
 
+enum kmap_context {
+	KMAP_USER = 0,
+	KMAP_SOFTIRQ,
+	KMAP_IRQ,
+	KMAP_NMI,
+	KMAP_CONTEXT_NR,
+}
+
+#if !defined(CONFIG_HIGHMEM) || !defined(ARCH_HAS_KMAP_SWITCH)
+/*
+ * Routines the arch can use to save/restore kmap_atomic stacks.
+ *
+ * This can be useful when an arch has limited kmap_atomic slots
+ * and wants to deal with context nesting.
+ */
+static inline void kmap_atomic_save(enum kmap_context kctx)
+{
+}
+
+static inline void kmap_atomic_restore(enum kmap_context kctx)
+{
+}
+#endif
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -283,6 +283,8 @@ void irq_enter(void)
 		tick_check_idle(cpu);
 	} else
 		__irq_enter();
+
+	kmap_atomic_save(KMAP_IRQ);
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
@@ -296,11 +298,15 @@ void irq_enter(void)
  */
 void irq_exit(void)
 {
+	kmap_atomic_restore(KMAP_IRQ);
 	account_system_vtime(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
-	if (!in_interrupt() && local_softirq_pending())
+	if (!in_interrupt() && local_softirq_pending()) {
+		kmap_atomic_save(KMAP_SOFTIRQ);
 		invoke_softirq();
+		kmap_atomic_restore(KMAP_SOFTIRQ);
+	}
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
Index: linux-2.6/arch/frv/include/asm/highmem.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/highmem.h
+++ linux-2.6/arch/frv/include/asm/highmem.h
@@ -121,20 +121,13 @@ static inline void *kmap_atomic(struct p
 	type = kmap_atomic_idx_push();
 	paddr = page_to_phys(page);
 
-	switch (type) {
-        case 0:		return __kmap_atomic_primary(0, paddr, 2);
-        case 1:		return __kmap_atomic_primary(1, paddr, 3);
-        case 2:		return __kmap_atomic_primary(2, paddr, 4);
-        case 3:		return __kmap_atomic_primary(3, paddr, 5);
+	switch (type + 4) {
         case 4:		return __kmap_atomic_primary(4, paddr, 6);
         case 5:		return __kmap_atomic_primary(5, paddr, 7);
         case 6:		return __kmap_atomic_primary(6, paddr, 8);
         case 7:		return __kmap_atomic_primary(7, paddr, 9);
         case 8:		return __kmap_atomic_primary(8, paddr, 10);
 
-	case 9 ... 9 + NR_TLB_LINES - 1:
-		return __kmap_atomic_secondary(type - 9, paddr);
-
 	default:
 		BUG();
 		return NULL;
@@ -156,27 +149,53 @@ do {									\
 static inline void kunmap_atomic(void *kvaddr)
 {
 	int type = kmap_atomic_idx_pop();
-	switch (type) {
-        case 0:		__kunmap_atomic_primary(0, 2);	break;
-        case 1:		__kunmap_atomic_primary(1, 3);	break;
-        case 2:		__kunmap_atomic_primary(2, 4);	break;
-        case 3:		__kunmap_atomic_primary(3, 5);	break;
+	switch (type+4) {
         case 4:		__kunmap_atomic_primary(4, 6);	break;
         case 5:		__kunmap_atomic_primary(5, 7);	break;
         case 6:		__kunmap_atomic_primary(6, 8);	break;
         case 7:		__kunmap_atomic_primary(7, 9);	break;
         case 8:		__kunmap_atomic_primary(8, 10);	break;
 
-	case 9 ... 9 + NR_TLB_LINES - 1:
-		__kunmap_atomic_secondary(type - 9, kvaddr);
-		break;
-
 	default:
 		BUG();
 	}
 	pagefault_enable();
 }
 
+#define ARCH_HAS_KMAP_SWITCH
+
+struct kmap_atomic_context {
+	pte_t	maps[KM_TYPE_NR];
+	int	nr;
+};
+
+DECLARE_PER_CPU(struct kmap_atomic_context, kmap_ctxs[KMAP_CONTEXT_NR]);
+
+static inline void kmap_atomic_save(enum kmap_context kctx)
+{
+	struct kmap_atomic_context *kac = &__get_cpu_var(kmap_ctxs)[kctx];
+	int *idx = &__get_cpu_var(__kmap_atomic_idx);
+
+	kac->nr = *idx;
+
+	if (*idx) {
+		/* XXX save maps */ ;
+		*idx = 0;
+	}
+}
+
+static inline void kmap_atomic_restore(enum kmap_context kctx)
+{
+	struct kmap_atomic_context *kac = &__get_cpu_var(kmap_ctxs)[kctx];
+	int *idx = &__get_cpu_var(__kmap_atomic_idx);
+
+	*idx = kac->nr;
+	if (*idx) {
+		/* XXX restore maps */ ;
+	}
+}
+
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
Index: linux-2.6/arch/frv/include/asm/kmap_types.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/kmap_types.h
+++ linux-2.6/arch/frv/include/asm/kmap_types.h
@@ -3,27 +3,8 @@
 #define _ASM_KMAP_TYPES_H
 
 enum km_type {
-	/* arch specific kmaps - change the numbers attached to these at your peril */
-	__KM_CACHE,		/* cache flush page attachment point */
-	__KM_PGD,		/* current page directory */
-	__KM_ITLB_PTD,		/* current instruction TLB miss page table lookup */
-	__KM_DTLB_PTD,		/* current data TLB miss page table lookup */
-
 	/* general kmaps */
-        KM_BOUNCE_READ,
-        KM_SKB_SUNRPC_DATA,
-        KM_SKB_DATA_SOFTIRQ,
-        KM_USER0,
-        KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
+	KM_TYPE_NR = 5
 };
 
 #endif


