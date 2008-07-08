Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbYGHX33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbYGHX33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYGHXPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:15 -0400
Received: from gw.goop.org ([64.81.55.164]:51210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 51 of 55] xen64: allocate and manage user pagetables
X-Mercurial-Node: 280393bc32413b3f08d6d3ca9768a397943dd155
Message-Id: <280393bc32413b3f08d6.1215554833@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the x86_64 architecture does not enforce segment limits, Xen
cannot protect itself with them as it does in 32-bit mode.  Therefore,
to protect itself, it runs the guest kernel in ring 3.  Since it also
runs the guest userspace in ring3, the guest kernel must maintain a
second pagetable for its userspace, which does not map kernel space.
Naturally, the guest kernel pagetables map both kernel and userspace.

The userspace pagetable is attached to the corresponding kernel
pagetable via the pgd's page->private field.  It is allocated and
freed at the same time as the kernel pgd via the
paravirt_pgd_alloc/free hooks.

Fortunately, the user pagetable is almost entirely shared with the
kernel pagetable; the only difference is the pgd page itself.  set_pgd
will populate all entries in the kernel pagetable, and also set the
corresponding user pgd entry if the address is less than
STACK_TOP_MAX.

The user pagetable must be pinned and unpinned with the kernel one,
but because the pagetables are aliased, pgd_walk() only needs to be
called on the kernel pagetable.  The user pgd page is then
pinned/unpinned along with the kernel pgd page.

xen_write_cr3 must write both the kernel and user cr3s.

The init_mm.pgd pagetable never has a user pagetable allocated for it,
because it can never be used while running usermode.

One awkward area is that early in boot the page structures are not
available.  No user pagetable can exist at that point, but it
complicates the logic to avoid looking at the page structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   99 +++++++++++++++++++++++++++++++++++++++-------
 arch/x86/xen/mmu.c       |   91 ++++++++++++++++++++++++++++++++++++++----
 arch/x86/xen/mmu.h       |    2
 3 files changed, 168 insertions(+), 24 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -46,7 +46,6 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
-#include <asm/pgalloc.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -711,29 +710,57 @@
 	x86_write_percpu(xen_current_cr3, (unsigned long)v);
 }
 
-static void xen_write_cr3(unsigned long cr3)
+static void __xen_write_cr3(bool kernel, unsigned long cr3)
 {
 	struct mmuext_op *op;
 	struct multicall_space mcs;
-	unsigned long mfn = pfn_to_mfn(PFN_DOWN(cr3));
+	unsigned long mfn;
 
+	if (cr3)
+		mfn = pfn_to_mfn(PFN_DOWN(cr3));
+	else
+		mfn = 0;
+
+	WARN_ON(mfn == 0 && kernel);
+
+	mcs = __xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = kernel ? MMUEXT_NEW_BASEPTR : MMUEXT_NEW_USER_BASEPTR;
+	op->arg1.mfn = mfn;
+
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	if (kernel) {
+		x86_write_percpu(xen_cr3, cr3);
+
+		/* Update xen_current_cr3 once the batch has actually
+		   been submitted. */
+		xen_mc_callback(set_current_cr3, (void *)cr3);
+	}
+}
+
+static void xen_write_cr3(unsigned long cr3)
+{
 	BUG_ON(preemptible());
 
-	mcs = xen_mc_entry(sizeof(*op));  /* disables interrupts */
+	xen_mc_batch();  /* disables interrupts */
 
 	/* Update while interrupts are disabled, so its atomic with
 	   respect to ipis */
 	x86_write_percpu(xen_cr3, cr3);
 
-	op = mcs.args;
-	op->cmd = MMUEXT_NEW_BASEPTR;
-	op->arg1.mfn = mfn;
+	__xen_write_cr3(true, cr3);
 
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
-
-	/* Update xen_update_cr3 once the batch has actually
-	   been submitted. */
-	xen_mc_callback(set_current_cr3, (void *)cr3);
+#ifdef CONFIG_X86_64
+	{
+		pgd_t *user_pgd = xen_get_user_pgd(__va(cr3));
+		if (user_pgd)
+			__xen_write_cr3(false, __pa(user_pgd));
+		else
+			__xen_write_cr3(false, 0);
+	}
+#endif
 
 	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
 }
@@ -792,6 +819,40 @@
 static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PMD);
+}
+
+static int xen_pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = mm->pgd;
+	int ret = 0;
+
+	BUG_ON(PagePinned(virt_to_page(pgd)));
+
+#ifdef CONFIG_X86_64
+	{
+		struct page *page = virt_to_page(pgd);
+
+		BUG_ON(page->private != 0);
+
+		page->private = __get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (page->private == 0)
+			ret = -ENOMEM;
+
+		BUG_ON(PagePinned(virt_to_page(xen_get_user_pgd(pgd))));
+	}
+#endif
+
+	return ret;
+}
+
+static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+#ifdef CONFIG_X86_64
+	pgd_t *user_pgd = xen_get_user_pgd(pgd);
+
+	if (user_pgd)
+		free_page((unsigned long)user_pgd);
+#endif
 }
 
 /* This should never happen until we're OK to use struct page */
@@ -1168,8 +1229,8 @@
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-	.pgd_alloc = __paravirt_pgd_alloc,
-	.pgd_free = paravirt_nop,
+	.pgd_alloc = xen_pgd_alloc,
+	.pgd_free = xen_pgd_free,
 
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
@@ -1480,7 +1541,15 @@
 
 	/* Switch over */
 	pgd = init_level4_pgt;
-	xen_write_cr3(__pa(pgd));
+
+	/*
+	 * At this stage there can be no user pgd, and no page
+	 * structure to attach it to, so make sure we just set kernel
+	 * pgd.
+	 */
+	xen_mc_batch();
+	__xen_write_cr3(true, __pa(pgd));
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
 	reserve_early(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -57,6 +57,13 @@
 
 #include "multicalls.h"
 #include "mmu.h"
+
+/*
+ * Just beyond the highest usermode address.  STACK_TOP_MAX has a
+ * redzone above it, so round it up to a PGD boundary.
+ */
+#define USER_LIMIT	((STACK_TOP_MAX + PGDIR_SIZE - 1) & PGDIR_MASK)
+
 
 #define P2M_ENTRIES_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long))
 #define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
@@ -461,17 +468,45 @@
 	return native_make_pud(pud);
 }
 
-void xen_set_pgd_hyper(pgd_t *ptr, pgd_t val)
+pgd_t *xen_get_user_pgd(pgd_t *pgd)
+{
+	pgd_t *pgd_page = (pgd_t *)(((unsigned long)pgd) & PAGE_MASK);
+	unsigned offset = pgd - pgd_page;
+	pgd_t *user_ptr = NULL;
+
+	if (offset < pgd_index(USER_LIMIT)) {
+		struct page *page = virt_to_page(pgd_page);
+		user_ptr = (pgd_t *)page->private;
+		if (user_ptr)
+			user_ptr += offset;
+	}
+
+	return user_ptr;
+}
+
+static void __xen_set_pgd_hyper(pgd_t *ptr, pgd_t val)
 {
 	struct mmu_update u;
 
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pgd_val_ma(val);
+	extend_mmu_update(&u);
+}
+
+/*
+ * Raw hypercall-based set_pgd, intended for in early boot before
+ * there's a page structure.  This implies:
+ *  1. The only existing pagetable is the kernel's
+ *  2. It is always pinned
+ *  3. It has no user pagetable attached to it
+ */
+void __init xen_set_pgd_hyper(pgd_t *ptr, pgd_t val)
+{
 	preempt_disable();
 
 	xen_mc_batch();
 
-	u.ptr = virt_to_machine(ptr).maddr;
-	u.val = pgd_val_ma(val);
-	extend_mmu_update(&u);
+	__xen_set_pgd_hyper(ptr, val);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -480,14 +515,28 @@
 
 void xen_set_pgd(pgd_t *ptr, pgd_t val)
 {
+	pgd_t *user_ptr = xen_get_user_pgd(ptr);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!page_pinned(ptr)) {
 		*ptr = val;
+		if (user_ptr) {
+			WARN_ON(page_pinned(user_ptr));
+			*user_ptr = val;
+		}
 		return;
 	}
 
-	xen_set_pgd_hyper(ptr, val);
+	/* If it's pinned, then we can at least batch the kernel and
+	   user updates together. */
+	xen_mc_batch();
+
+	__xen_set_pgd_hyper(ptr, val);
+	if (user_ptr)
+		__xen_set_pgd_hyper(user_ptr, val);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 #endif	/* PAGETABLE_LEVELS == 4 */
 
@@ -526,7 +575,7 @@
 	 * space, which contains the Xen mappings.  On 32-bit these
 	 * will end up making a zero-sized hole and so is a no-op.
 	 */
-	hole_low = pgd_index(STACK_TOP_MAX + PGDIR_SIZE - 1);
+	hole_low = pgd_index(USER_LIMIT);
 	hole_high = pgd_index(PAGE_OFFSET);
 
 	pgdidx_limit = pgd_index(limit);
@@ -670,19 +719,31 @@
 {
 	xen_mc_batch();
 
-	if (pgd_walk(pgd, pin_page, TASK_SIZE)) {
+	if (pgd_walk(pgd, pin_page, USER_LIMIT)) {
 		/* re-enable interrupts for kmap_flush_unused */
 		xen_mc_issue(0);
 		kmap_flush_unused();
 		xen_mc_batch();
 	}
 
+#ifdef CONFIG_X86_64
+	{
+		pgd_t *user_pgd = xen_get_user_pgd(pgd);
+
+		xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(pgd)));
+
+		if (user_pgd) {
+			pin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(user_pgd)));
+		}
+	}
+#else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
 	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
-
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
+#endif /* CONFIG_X86_64 */
 	xen_mc_issue(0);
 }
 
@@ -763,11 +824,23 @@
 
 	xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
+#ifdef CONFIG_X86_64
+	{
+		pgd_t *user_pgd = xen_get_user_pgd(pgd);
+
+		if (user_pgd) {
+			xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(user_pgd)));
+			unpin_page(virt_to_page(user_pgd), PT_PGD);
+		}
+	}
+#endif
+
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
 	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
-	pgd_walk(pgd, unpin_page, TASK_SIZE);
+
+	pgd_walk(pgd, unpin_page, USER_LIMIT);
 
 	xen_mc_issue(0);
 }
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -51,6 +51,8 @@
 void xen_set_pgd_hyper(pgd_t *pgdp, pgd_t pgd);
 #endif
 
+pgd_t *xen_get_user_pgd(pgd_t *pgd);
+
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, pte_t pte);


