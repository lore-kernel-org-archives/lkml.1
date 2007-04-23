Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXDWXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXDWXHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXDWXHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:07:24 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38861 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754495AbXDWXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:07:19 -0400
Message-Id: <20070423215710.683563417@goop.org>
References: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/25] xen: xen: fix multicall batching
Content-Disposition: inline; filename=xen-fix-multicall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable interrupts between allocating a multicall entry and actually
issuing it, to prevent an interrupt from coming in, allocating and
initializing further multicall entries, and then issuing them all,
including the partially completed one.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/enlighten.c  |   44 +++++++++++++++++++++++++++-----------------
 arch/i386/xen/mmu.c        |   18 ++++++++++++------
 arch/i386/xen/multicalls.c |    9 ++++++++-
 arch/i386/xen/multicalls.h |   27 +++++++++++++++++++++++----
 arch/i386/xen/xen-ops.h    |    5 +----
 5 files changed, 71 insertions(+), 32 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -160,13 +160,25 @@ static void xen_halt(void)
 
 static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	enum paravirt_lazy_mode *lazy = &get_cpu_var(xen_lazy_mode);
+	switch(mode) {
+	case PARAVIRT_LAZY_NONE:
+		BUG_ON(x86_read_percpu(xen_lazy_mode) == PARAVIRT_LAZY_NONE);
+		break;
+
+	case PARAVIRT_LAZY_MMU:
+	case PARAVIRT_LAZY_CPU:
+		BUG_ON(x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE);
+		break;
+
+	case PARAVIRT_LAZY_FLUSH:
+		/* flush if necessary, but don't change state */
+		if (x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE)
+			xen_mc_flush();
+		return;
+	}
 
 	xen_mc_flush();
-
-	*lazy = mode;
-
-	put_cpu_var(xen_lazy_mode);
+	x86_write_percpu(xen_lazy_mode, mode);
 }
 
 static unsigned long xen_store_tr(void)
@@ -193,7 +208,7 @@ static void xen_set_ldt(const void *addr
 
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
-	xen_mc_issue();
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
 static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
@@ -217,7 +232,7 @@ static void xen_load_gdt(const struct Xg
 
 	MULTI_set_gdt(mcs.mc, frames, size/8);
 
-	xen_mc_issue();
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
 static void load_TLS_descriptor(struct thread_struct *t,
@@ -225,18 +240,20 @@ static void load_TLS_descriptor(struct t
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 	xmaddr_t maddr = virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
-	struct multicall_space mc = xen_mc_entry(0);
+	struct multicall_space mc = __xen_mc_entry(0);
 
 	MULTI_update_descriptor(mc.mc, maddr.maddr, t->tls_array[i]);
 }
 
 static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 {
+	xen_mc_batch();
+
 	load_TLS_descriptor(t, cpu, 0);
 	load_TLS_descriptor(t, cpu, 1);
 	load_TLS_descriptor(t, cpu, 2);
 
-	xen_mc_issue();
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum, u32 low, u32 high)
@@ -356,13 +373,9 @@ static void xen_load_esp0(struct tss_str
 static void xen_load_esp0(struct tss_struct *tss,
 				   struct thread_struct *thread)
 {
-	if (xen_get_lazy_mode() != PARAVIRT_LAZY_CPU) {
-		if (HYPERVISOR_stack_switch(__KERNEL_DS, thread->esp0))
-			BUG();
-	} else {
-		struct multicall_space mcs = xen_mc_entry(0);
-		MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->esp0);
-	}
+	struct multicall_space mcs = xen_mc_entry(0);
+	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->esp0);
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
 static void xen_set_iopl_mask(unsigned mask)
@@ -452,7 +465,7 @@ static void xen_write_cr3(unsigned long 
 
 		MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
-		xen_mc_issue();
+		xen_mc_issue(PARAVIRT_LAZY_CPU);
 	}
 }
 
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -344,7 +344,7 @@ static int pin_page(struct page *page, u
 	else {
 		void *pt = lowmem_page_address(page);
 		unsigned long pfn = page_to_pfn(page);
-		struct multicall_space mcs = xen_mc_entry(0);
+		struct multicall_space mcs = __xen_mc_entry(0);
 
 		flush = 0;
 
@@ -364,10 +364,12 @@ void xen_pgd_pin(pgd_t *pgd)
 	struct multicall_space mcs;
 	struct mmuext_op *op;
 
+	xen_mc_batch();
+
 	if (pgd_walk(pgd, pin_page, TASK_SIZE))
 		kmap_flush_unused();
 
-	mcs = xen_mc_entry(sizeof(*op));
+	mcs = __xen_mc_entry(sizeof(*op));
 	op = mcs.args;
 
 #ifdef CONFIG_X86_PAE
@@ -378,7 +380,7 @@ void xen_pgd_pin(pgd_t *pgd)
 	op->arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
-	xen_mc_flush();
+	xen_mc_issue(0);
 }
 
 /* The init_mm pagetable is really pinned as soon as its created, but
@@ -402,7 +404,7 @@ static int unpin_page(struct page *page,
 	if (pgfl && !PageHighMem(page)) {
 		void *pt = lowmem_page_address(page);
 		unsigned long pfn = page_to_pfn(page);
-		struct multicall_space mcs = xen_mc_entry(0);
+		struct multicall_space mcs = __xen_mc_entry(0);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL),
@@ -416,7 +418,11 @@ static void xen_pgd_unpin(pgd_t *pgd)
 static void xen_pgd_unpin(pgd_t *pgd)
 {
 	struct mmuext_op *op;
-	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+	struct multicall_space mcs;
+
+	xen_mc_batch();
+
+	mcs = __xen_mc_entry(sizeof(*op));
 
 	op = mcs.args;
 	op->cmd = MMUEXT_UNPIN_TABLE;
@@ -426,7 +432,7 @@ static void xen_pgd_unpin(pgd_t *pgd)
 
 	pgd_walk(pgd, unpin_page, TASK_SIZE);
 
-	xen_mc_flush();
+	xen_mc_issue(0);
 }
 
 
===================================================================
--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -14,11 +14,17 @@ struct mc_buffer {
 };
 
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
+DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
 void xen_mc_flush(void)
 {
 	struct mc_buffer *b = &get_cpu_var(mc_buffer);
 	int ret = 0;
+	unsigned long flags;
+
+	/* Disable interrupts in case someone comes in and queues
+	   something in the middle */
+	local_irq_save(flags);
 
 	if (b->mcidx) {
 		int i;
@@ -34,11 +40,12 @@ void xen_mc_flush(void)
 		BUG_ON(b->argidx != 0);
 
 	put_cpu_var(mc_buffer);
+	local_irq_restore(flags);
 
 	BUG_ON(ret);
 }
 
-struct multicall_space xen_mc_entry(size_t args)
+struct multicall_space __xen_mc_entry(size_t args)
 {
 	struct mc_buffer *b = &get_cpu_var(mc_buffer);
 	struct multicall_space ret;
===================================================================
--- a/arch/i386/xen/multicalls.h
+++ b/arch/i386/xen/multicalls.h
@@ -11,16 +11,35 @@ struct multicall_space
 };
 
 /* Allocate room for a multicall and its args */
-struct multicall_space xen_mc_entry(size_t args);
+struct multicall_space __xen_mc_entry(size_t args);
+
+DECLARE_PER_CPU(unsigned long, xen_mc_irq_flags);
+
+/* Call to start a batch of multiple __xen_mc_entry()s.  Must be
+   paired with xen_mc_issue() */
+static inline void xen_mc_batch(void)
+{
+	/* need to disable interrupts until this entry is complete */
+	local_irq_save(__get_cpu_var(xen_mc_irq_flags));
+}
+
+static inline struct multicall_space xen_mc_entry(size_t args)
+{
+	xen_mc_batch();
+	return __xen_mc_entry(args);
+}
 
 /* Flush all pending multicalls */
 void xen_mc_flush(void);
 
-/* Issue a multicall if we're not in lazy mode */
-static inline void xen_mc_issue(void)
+/* Issue a multicall if we're not in a lazy mode */
+static inline void xen_mc_issue(unsigned mode)
 {
-	if (xen_get_lazy_mode() == PARAVIRT_LAZY_NONE)
+	if ((xen_get_lazy_mode() & mode) == 0)
 		xen_mc_flush();
+
+	/* restore flags saved in xen_mc_batch */
+	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
 }
 
 #endif /* _XEN_MULTICALLS_H */
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -26,10 +26,7 @@ DECLARE_PER_CPU(enum paravirt_lazy_mode,
 
 static inline unsigned xen_get_lazy_mode(void)
 {
-	unsigned ret = get_cpu_var(xen_lazy_mode);
-	put_cpu_var(xen_lazy_mode);
-
-	return ret;
+	return x86_read_percpu(xen_lazy_mode);
 }
 
 

-- 

