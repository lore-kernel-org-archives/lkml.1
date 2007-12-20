Return-Path: <linux-kernel-owner+w=401wt.eu-S1763766AbXLTNlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763766AbXLTNlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761860AbXLTNfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762659AbXLTNft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:49 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 16/16] per-vcpu lguest pgdir management
Date: Thu, 20 Dec 2007 11:33:56 -0200
Message-Id: <11981577182753-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981577132025-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com> <1198157692575-git-send-email-gcosta@redhat.com> <11981576972655-git-send-email-gcosta@redhat.com> <11981577021091-git-send-email-gcosta@redhat.com> <11981577083517-git-send-email-gcosta@redhat.com> <11981577132025-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch makes the pgdir management per-vcpu. The pgdirs pool
is still guest-wide (although it'll probably need to grow when we
are really executing more vcpus), but the pgdidx index is gone,
since it makes no sense anymore. Instead, we use a per-vcpu
index.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/hypercalls.c           |    2 +-
 drivers/lguest/interrupts_and_traps.c |    6 ++--
 drivers/lguest/lg.h                   |   12 +++---
 drivers/lguest/page_tables.c          |   60 +++++++++++++++++----------------
 drivers/lguest/x86/core.c             |    6 ++--
 5 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 95e1062..f379475 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -60,7 +60,7 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 		if (args->arg1)
 			guest_pagetable_clear_all(vcpu);
 		else
-			guest_pagetable_flush_user(lg);
+			guest_pagetable_flush_user(vcpu);
 		break;
 
 	/* All these calls simply pass the arguments through to the right
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 78f6210..a0ac77e 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -77,7 +77,7 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 		virtstack = vcpu->esp1;
 		ss = vcpu->ss1;
 
-		origstack = gstack = guest_pa(lg, virtstack);
+		origstack = gstack = guest_pa(vcpu, virtstack);
 		/* We push the old stack segment and pointer onto the new
 		 * stack: when the Guest does an "iret" back from the interrupt
 		 * handler the CPU will notice they're dropping privilege
@@ -89,7 +89,7 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 		virtstack = vcpu->regs->esp;
 		ss = vcpu->regs->ss;
 
-		origstack = gstack = guest_pa(lg, virtstack);
+		origstack = gstack = guest_pa(vcpu, virtstack);
 	}
 
 	/* Remember that we never let the Guest actually disable interrupts, so
@@ -325,7 +325,7 @@ void pin_stack_pages(struct lguest_vcpu *vcpu)
 		 * start of the page after the kernel stack.  Subtract one to
 		 * get back onto the first stack page, and keep subtracting to
 		 * get to the rest of the stack pages. */
-		pin_page(lg, vcpu->esp1 - 1 - i * PAGE_SIZE);
+		pin_page(vcpu, vcpu->esp1 - 1 - i * PAGE_SIZE);
 }
 
 /* Direct traps also mean that we need to know whenever the Guest wants to use
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 6faf90d..e700408 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -57,6 +57,8 @@ struct lguest_vcpu {
 	unsigned long regs_page;
 	struct lguest_regs *regs;
 
+	int vcpu_pgd; /* which pgd this vcpu is currently using */
+
 	/* If a hypercall was asked for, this points to the arguments. */
 	struct hcall_args *hcall;
 	u32 next_hcall;
@@ -92,8 +94,6 @@ struct lguest
 	int changed;
 	struct lguest_pages *last_pages;
 
-	/* We keep a small number of these. */
-	u32 pgdidx;
 	struct pgdir pgdirs[4];
 
 	unsigned long noirq_start, noirq_end;
@@ -175,14 +175,14 @@ void free_guest_pagetable(struct lguest *lg);
 void guest_new_pagetable(struct lguest_vcpu *vcpu, unsigned long pgtable);
 void guest_set_pmd(struct lguest *lg, unsigned long gpgdir, u32 i);
 void guest_pagetable_clear_all(struct lguest_vcpu *vcpu);
-void guest_pagetable_flush_user(struct lguest *lg);
+void guest_pagetable_flush_user(struct lguest_vcpu *vcpu);
 void guest_set_pte(struct lguest *lg, unsigned long gpgdir,
 		   unsigned long vaddr, pte_t val);
 void map_switcher_in_guest(struct lguest_vcpu *vcpu,
 			   struct lguest_pages *pages);
-int demand_page(struct lguest *info, unsigned long cr2, int errcode);
-void pin_page(struct lguest *lg, unsigned long vaddr);
-unsigned long guest_pa(struct lguest *lg, unsigned long vaddr);
+int demand_page(struct lguest_vcpu *vcpu, unsigned long cr2, int errcode);
+void pin_page(struct lguest_vcpu *vcpu, unsigned long vaddr);
+unsigned long guest_pa(struct lguest_vcpu *vcpu, unsigned long vaddr);
 void page_table_guest_data_init(struct lguest *lg);
 
 /* <arch>/core.c: */
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index f0f271d..84c22d7 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -94,10 +94,10 @@ static pte_t *spte_addr(struct lguest *lg, pgd_t spgd, unsigned long vaddr)
 
 /* These two functions just like the above two, except they access the Guest
  * page tables.  Hence they return a Guest address. */
-static unsigned long gpgd_addr(struct lguest *lg, unsigned long vaddr)
+static unsigned long gpgd_addr(struct lguest_vcpu *vcpu, unsigned long vaddr)
 {
 	unsigned int index = vaddr >> (PGDIR_SHIFT);
-	return lg->pgdirs[lg->pgdidx].gpgdir + index * sizeof(pgd_t);
+	return vcpu->lg->pgdirs[vcpu->vcpu_pgd].gpgdir + index * sizeof(pgd_t);
 }
 
 static unsigned long gpte_addr(struct lguest *lg,
@@ -200,22 +200,23 @@ static void check_gpgd(struct lguest *lg, pgd_t gpgd)
  *
  * If we fixed up the fault (ie. we mapped the address), this routine returns
  * true.  Otherwise, it was a real fault and we need to tell the Guest. */
-int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
+int demand_page(struct lguest_vcpu *vcpu, unsigned long vaddr, int errcode)
 {
 	pgd_t gpgd;
 	pgd_t *spgd;
 	unsigned long gpte_ptr;
 	pte_t gpte;
 	pte_t *spte;
+	struct lguest *lg = vcpu->lg;
 
 	/* First step: get the top-level Guest page table entry. */
-	gpgd = lgread(lg, gpgd_addr(lg, vaddr), pgd_t);
+	gpgd = lgread(lg, gpgd_addr(vcpu, vaddr), pgd_t);
 	/* Toplevel not present?  We can't map it in. */
 	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
 		return 0;
 
 	/* Now look at the matching shadow entry. */
-	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	spgd = spgd_addr(lg, vcpu->vcpu_pgd, vaddr);
 	if (!(pgd_flags(*spgd) & _PAGE_PRESENT)) {
 		/* No shadow entry: allocate a new shadow PTE page. */
 		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
@@ -297,19 +298,19 @@ int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
  *
  * This is a quick version which answers the question: is this virtual address
  * mapped by the shadow page tables, and is it writable? */
-static int page_writable(struct lguest *lg, unsigned long vaddr)
+static int page_writable(struct lguest_vcpu *vcpu, unsigned long vaddr)
 {
 	pgd_t *spgd;
 	unsigned long flags;
 
 	/* Look at the current top level entry: is it present? */
-	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	spgd = spgd_addr(vcpu->lg, vcpu->vcpu_pgd, vaddr);
 	if (!(pgd_flags(*spgd) & _PAGE_PRESENT))
 		return 0;
 
 	/* Check the flags on the pte entry itself: it must be present and
 	 * writable. */
-	flags = pte_flags(*(spte_addr(lg, *spgd, vaddr)));
+	flags = pte_flags(*(spte_addr(vcpu->lg, *spgd, vaddr)));
 
 	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
 }
@@ -317,10 +318,10 @@ static int page_writable(struct lguest *lg, unsigned long vaddr)
 /* So, when pin_stack_pages() asks us to pin a page, we check if it's already
  * in the page tables, and if not, we call demand_page() with error code 2
  * (meaning "write"). */
-void pin_page(struct lguest *lg, unsigned long vaddr)
+void pin_page(struct lguest_vcpu *vcpu, unsigned long vaddr)
 {
-	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
-		kill_guest(lg, "bad stack page %#lx", vaddr);
+	if (!page_writable(vcpu, vaddr) && !demand_page(vcpu, vaddr, 2))
+		kill_guest(vcpu->lg, "bad stack page %#lx", vaddr);
 }
 
 /*H:450 If we chase down the release_pgd() code, it looks like this: */
@@ -358,28 +359,28 @@ static void flush_user_mappings(struct lguest *lg, int idx)
  *
  * The Guest has a hypercall to throw away the page tables: it's used when a
  * large number of mappings have been changed. */
-void guest_pagetable_flush_user(struct lguest *lg)
+void guest_pagetable_flush_user(struct lguest_vcpu *vcpu)
 {
 	/* Drop the userspace part of the current page table. */
-	flush_user_mappings(lg, lg->pgdidx);
+	flush_user_mappings(vcpu->lg, vcpu->vcpu_pgd);
 }
 /*:*/
 
 /* We walk down the guest page tables to get a guest-physical address */
-unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
+unsigned long guest_pa(struct lguest_vcpu *vcpu, unsigned long vaddr)
 {
 	pgd_t gpgd;
 	pte_t gpte;
 
 	/* First step: get the top-level Guest page table entry. */
-	gpgd = lgread(lg, gpgd_addr(lg, vaddr), pgd_t);
+	gpgd = lgread(vcpu->lg, gpgd_addr(vcpu, vaddr), pgd_t);
 	/* Toplevel not present?  We can't map it in. */
 	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
-		kill_guest(lg, "Bad address %#lx", vaddr);
+		kill_guest(vcpu->lg, "Bad address %#lx", vaddr);
 
-	gpte = lgread(lg, gpte_addr(lg, gpgd, vaddr), pte_t);
+	gpte = lgread(vcpu->lg, gpte_addr(vcpu->lg, gpgd, vaddr), pte_t);
 	if (!(pte_flags(gpte) & _PAGE_PRESENT))
-		kill_guest(lg, "Bad address %#lx", vaddr);
+		kill_guest(vcpu->lg, "Bad address %#lx", vaddr);
 
 	return pte_pfn(gpte) * PAGE_SIZE | (vaddr & ~PAGE_MASK);
 }
@@ -399,11 +400,12 @@ static unsigned int find_pgdir(struct lguest *lg, unsigned long pgtable)
 /*H:435 And this is us, creating the new page directory.  If we really do
  * allocate a new one (and so the kernel parts are not there), we set
  * blank_pgdir. */
-static unsigned int new_pgdir(struct lguest *lg,
+static unsigned int new_pgdir(struct lguest_vcpu *vcpu,
 			      unsigned long gpgdir,
 			      int *blank_pgdir)
 {
 	unsigned int next;
+	struct lguest *lg = vcpu->lg;
 
 	/* We pick one entry at random to throw out.  Choosing the Least
 	 * Recently Used might be better, but this is easy. */
@@ -413,7 +415,7 @@ static unsigned int new_pgdir(struct lguest *lg,
 		lg->pgdirs[next].pgdir = (pgd_t *)get_zeroed_page(GFP_KERNEL);
 		/* If the allocation fails, just keep using the one we have */
 		if (!lg->pgdirs[next].pgdir)
-			next = lg->pgdidx;
+			next = vcpu->vcpu_pgd;
 		else
 			/* This is a blank page, so there are no kernel
 			 * mappings: caller must map the stack! */
@@ -442,9 +444,9 @@ void guest_new_pagetable(struct lguest_vcpu *vcpu, unsigned long pgtable)
 	/* If not, we allocate or mug an existing one: if it's a fresh one,
 	 * repin gets set to 1. */
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
-		newpgdir = new_pgdir(lg, pgtable, &repin);
+		newpgdir = new_pgdir(vcpu, pgtable, &repin);
 	/* Change the current pgd index to the new one. */
-	lg->pgdidx = newpgdir;
+	vcpu->vcpu_pgd = newpgdir;
 	/* If it was completely blank, we map in the Guest kernel stack */
 	if (repin)
 		pin_stack_pages(vcpu);
@@ -591,11 +593,11 @@ int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
 {
 	/* We start on the first shadow page table, and give it a blank PGD
 	 * page. */
-	lg->pgdidx = 0;
-	lg->pgdirs[lg->pgdidx].gpgdir = pgtable;
-	lg->pgdirs[lg->pgdidx].pgdir = (pgd_t*)get_zeroed_page(GFP_KERNEL);
-	if (!lg->pgdirs[lg->pgdidx].pgdir)
+	lg->pgdirs[0].gpgdir = pgtable;
+	lg->pgdirs[0].pgdir = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+	if (!lg->pgdirs[0].pgdir)
 		return -ENOMEM;
+	lg->vcpus[0].vcpu_pgd = 0;
 	return 0;
 }
 
@@ -607,7 +609,7 @@ void page_table_guest_data_init(struct lguest *lg)
 	    /* We tell the Guest that it can't use the top 4MB of virtual
 	     * addresses used by the Switcher. */
 	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
-	    || put_user(lg->pgdirs[lg->pgdidx].gpgdir,&lg->lguest_data->pgdir))
+	    || put_user(lg->pgdirs[0].gpgdir, &lg->lguest_data->pgdir))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
 	/* In flush_user_mappings() we loop from 0 to
@@ -638,7 +640,6 @@ void free_guest_pagetable(struct lguest *lg)
 void map_switcher_in_guest(struct lguest_vcpu *vcpu,
 			   struct lguest_pages *pages)
 {
-	struct lguest *lg = vcpu->lg;
 	pte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
 	pgd_t switcher_pgd;
 	pte_t regs_pte;
@@ -648,7 +649,8 @@ void map_switcher_in_guest(struct lguest_vcpu *vcpu,
 	 * page for this CPU (with appropriate flags). */
 	switcher_pgd = __pgd(__pa(switcher_pte_page) | _PAGE_KERNEL);
 
-	lg->pgdirs[lg->pgdidx].pgdir[SWITCHER_PGD_INDEX] = switcher_pgd;
+	vcpu->lg->pgdirs[vcpu->vcpu_pgd].pgdir[SWITCHER_PGD_INDEX] =
+								switcher_pgd;
 
 	/* We also change the Switcher PTE page.  When we're running the Guest,
 	 * we want the Guest's "regs" page to appear where the first Switcher
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index aec2527..582eaf0 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -147,7 +147,7 @@ static void run_guest_once(struct lguest_vcpu *vcpu,
 		      * 0-th argument above, ie "a").  %ebx contains the
 		      * physical address of the Guest's top-level page
 		      * directory. */
-		     : "0"(pages), "1"(__pa(lg->pgdirs[lg->pgdidx].pgdir))
+		     : "0"(pages), "1"(__pa(lg->pgdirs[vcpu->vcpu_pgd].pgdir))
 		     /* We tell gcc that all these registers could change,
 		      * which means we don't have to save and restore them in
 		      * the Switcher. */
@@ -225,7 +225,7 @@ static int emulate_insn(struct lguest_vcpu *vcpu)
 	unsigned int insnlen = 0, in = 0, shift = 0;
 	/* The eip contains the *virtual* address of the Guest's instruction:
 	 * guest_pa just subtracts the Guest's page_offset. */
-	unsigned long physaddr = guest_pa(lg, vcpu->regs->eip);
+	unsigned long physaddr = guest_pa(vcpu, vcpu->regs->eip);
 
 	/* This must be the Guest kernel trying to do something, not userspace!
 	 * The bottom two bits of the CS segment register are the privilege
@@ -307,7 +307,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		 *
 		 * The errcode tells whether this was a read or a write, and
 		 * whether kernel or userspace code. */
-		if (demand_page(lg, vcpu->arch.last_pagefault,
+		if (demand_page(vcpu, vcpu->arch.last_pagefault,
 				vcpu->regs->errcode))
 			return;
 
-- 
1.5.0.6

