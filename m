Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXLTNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXLTNjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762217AbXLTNfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760397AbXLTNff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 14/16] makes special fields be per-vcpu
Date: Thu, 20 Dec 2007 11:33:54 -0200
Message-Id: <11981577083517-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981577021091-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com> <1198157692575-git-send-email-gcosta@redhat.com> <11981576972655-git-send-email-gcosta@redhat.com> <11981577021091-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lguest struct have room for some fields, namely, cr2, ts, esp1
and ss1, that are not really guest-wide, but rather, vcpu-wide.

This patch puts it in the vcpu struct

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/hypercalls.c           |   10 +++++-----
 drivers/lguest/interrupts_and_traps.c |   24 +++++++++++++-----------
 drivers/lguest/lg.h                   |   18 ++++++++++--------
 drivers/lguest/page_tables.c          |   11 ++++++-----
 drivers/lguest/x86/core.c             |   10 ++++------
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 41ea2e2..c6b87ef 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -58,7 +58,7 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 		/* FLUSH_TLB comes in two flavors, depending on the
 		 * argument: */
 		if (args->arg1)
-			guest_pagetable_clear_all(lg);
+			guest_pagetable_clear_all(vcpu);
 		else
 			guest_pagetable_flush_user(lg);
 		break;
@@ -66,10 +66,10 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 	/* All these calls simply pass the arguments through to the right
 	 * routines. */
 	case LHCALL_NEW_PGTABLE:
-		guest_new_pagetable(lg, args->arg1);
+		guest_new_pagetable(vcpu, args->arg1);
 		break;
 	case LHCALL_SET_STACK:
-		guest_set_stack(lg, args->arg1, args->arg2, args->arg3);
+		guest_set_stack(vcpu, args->arg1, args->arg2, args->arg3);
 		break;
 	case LHCALL_SET_PTE:
 		guest_set_pte(lg, args->arg1, args->arg2, __pte(args->arg3));
@@ -82,7 +82,7 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 		break;
 	case LHCALL_TS:
 		/* This sets the TS flag, as we saw used in run_guest(). */
-		lg->ts = args->arg1;
+		vcpu->ts = args->arg1;
 		break;
 	case LHCALL_HALT:
 		/* Similarly, this sets the halted flag for run_guest(). */
@@ -189,7 +189,7 @@ static void initialize(struct lguest_vcpu *vcpu)
 	 * first write to a Guest page.  This may have caused a copy-on-write
 	 * fault, but the old page might be (read-only) in the Guest
 	 * pagetable. */
-	guest_pagetable_clear_all(lg);
+	guest_pagetable_clear_all(vcpu);
 }
 
 /*H:100
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 10c9aea..78f6210 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -74,8 +74,8 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 	if ((vcpu->regs->ss&0x3) != GUEST_PL) {
 		/* The Guest told us their kernel stack with the SET_STACK
 		 * hypercall: both the virtual address and the segment */
-		virtstack = lg->esp1;
-		ss = lg->ss1;
+		virtstack = vcpu->esp1;
+		ss = vcpu->ss1;
 
 		origstack = gstack = guest_pa(lg, virtstack);
 		/* We push the old stack segment and pointer onto the new
@@ -313,10 +313,11 @@ static int direct_trap(unsigned int num)
  * the Guest.
  *
  * Which is deeply unfair, because (literally!) it wasn't the Guests' fault. */
-void pin_stack_pages(struct lguest *lg)
+void pin_stack_pages(struct lguest_vcpu *vcpu)
 {
 	unsigned int i;
 
+	struct lguest *lg = vcpu->lg;
 	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
 	 * two pages of stack space. */
 	for (i = 0; i < lg->stack_pages; i++)
@@ -324,7 +325,7 @@ void pin_stack_pages(struct lguest *lg)
 		 * start of the page after the kernel stack.  Subtract one to
 		 * get back onto the first stack page, and keep subtracting to
 		 * get to the rest of the stack pages. */
-		pin_page(lg, lg->esp1 - 1 - i * PAGE_SIZE);
+		pin_page(lg, vcpu->esp1 - 1 - i * PAGE_SIZE);
 }
 
 /* Direct traps also mean that we need to know whenever the Guest wants to use
@@ -335,21 +336,22 @@ void pin_stack_pages(struct lguest *lg)
  *
  * In Linux each process has its own kernel stack, so this happens a lot: we
  * change stacks on each context switch. */
-void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
+void guest_set_stack(struct lguest_vcpu *vcpu, u32 seg, u32 esp,
+		     unsigned int pages)
 {
 	/* You are not allowed have a stack segment with privilege level 0: bad
 	 * Guest! */
 	if ((seg & 0x3) != GUEST_PL)
-		kill_guest(lg, "bad stack segment %i", seg);
+		kill_guest(vcpu->lg, "bad stack segment %i", seg);
 	/* We only expect one or two stack pages. */
 	if (pages > 2)
-		kill_guest(lg, "bad stack pages %u", pages);
+		kill_guest(vcpu->lg, "bad stack pages %u", pages);
 	/* Save where the stack is, and how many pages */
-	lg->ss1 = seg;
-	lg->esp1 = esp;
-	lg->stack_pages = pages;
+	vcpu->ss1 = seg;
+	vcpu->esp1 = esp;
+	vcpu->lg->stack_pages = pages;
 	/* Make sure the new stack pages are mapped */
-	pin_stack_pages(lg);
+	pin_stack_pages(vcpu);
 }
 
 /* All this reference to mapping stacks leads us neatly into the other complex
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index b23694e..dbf70c6 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -46,6 +46,11 @@ struct lguest_vcpu {
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
 
+	u32 cr2;
+	int ts;
+	u32 esp1;
+	u8 ss1;
+
 	/* At end of a page shared mapped over lguest_pages in guest.  */
 	unsigned long regs_page;
 	struct lguest_regs *regs;
@@ -80,10 +85,6 @@ struct lguest
 	 * memory in the Launcher. */
 	void __user *mem_base;
 	unsigned long kernel_address;
-	u32 cr2;
-	int ts;
-	u32 esp1;
-	u8 ss1;
 
 	/* Bitmap of what has changed: see CHANGED_* above. */
 	int changed;
@@ -146,8 +147,9 @@ void maybe_do_interrupt(struct lguest_vcpu *vcpu);
 int deliver_trap(struct lguest_vcpu *vcpu, unsigned int num);
 void load_guest_idt_entry(struct lguest_vcpu *vcpu, unsigned int i,
 			  u32 low, u32 hi);
-void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
-void pin_stack_pages(struct lguest *lg);
+void guest_set_stack(struct lguest_vcpu *vcpu, u32 seg, u32 esp,
+		     unsigned int pages);
+void pin_stack_pages(struct lguest_vcpu *vcpu);
 void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def);
 void copy_traps(const struct lguest_vcpu *vcpu, struct desc_struct *idt,
@@ -169,9 +171,9 @@ void copy_gdt_tls(const struct lguest_vcpu *vcpu, struct desc_struct *gdt);
 /* page_tables.c: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
 void free_guest_pagetable(struct lguest *lg);
-void guest_new_pagetable(struct lguest *lg, unsigned long pgtable);
+void guest_new_pagetable(struct lguest_vcpu *vcpu, unsigned long pgtable);
 void guest_set_pmd(struct lguest *lg, unsigned long gpgdir, u32 i);
-void guest_pagetable_clear_all(struct lguest *lg);
+void guest_pagetable_clear_all(struct lguest_vcpu *vcpu);
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long gpgdir,
 		   unsigned long vaddr, pte_t val);
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 8c41030..f0f271d 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -432,9 +432,10 @@ static unsigned int new_pgdir(struct lguest *lg,
  * Now we've seen all the page table setting and manipulation, let's see what
  * what happens when the Guest changes page tables (ie. changes the top-level
  * pgdir).  This occurs on almost every context switch. */
-void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
+void guest_new_pagetable(struct lguest_vcpu *vcpu, unsigned long pgtable)
 {
 	int newpgdir, repin = 0;
+	struct lguest *lg = vcpu->lg;
 
 	/* Look to see if we have this one already. */
 	newpgdir = find_pgdir(lg, pgtable);
@@ -446,7 +447,7 @@ void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
 	lg->pgdidx = newpgdir;
 	/* If it was completely blank, we map in the Guest kernel stack */
 	if (repin)
-		pin_stack_pages(lg);
+		pin_stack_pages(vcpu);
 }
 
 /*H:470 Finally, a routine which throws away everything: all PGD entries in all
@@ -468,11 +469,11 @@ static void release_all_pagetables(struct lguest *lg)
  * mapping.  Since kernel mappings are in every page table, it's easiest to
  * throw them all away.  This traps the Guest in amber for a while as
  * everything faults back in, but it's rare. */
-void guest_pagetable_clear_all(struct lguest *lg)
+void guest_pagetable_clear_all(struct lguest_vcpu *vcpu)
 {
-	release_all_pagetables(lg);
+	release_all_pagetables(vcpu->lg);
 	/* We need the Guest kernel stack mapped again. */
-	pin_stack_pages(lg);
+	pin_stack_pages(vcpu);
 }
 /*:*/
 /*M:009 Since we throw away all mappings when a kernel mapping changes, our
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 177b9e5..aec2527 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -96,8 +96,8 @@ static void copy_in_guest_info(struct lguest_vcpu *vcpu,
 	/* Set up the two "TSS" members which tell the CPU what stack to use
 	 * for traps which do directly into the Guest (ie. traps at privilege
 	 * level 1). */
-	pages->state.guest_tss.esp1 = lg->esp1;
-	pages->state.guest_tss.ss1 = lg->ss1;
+	pages->state.guest_tss.esp1 = vcpu->esp1;
+	pages->state.guest_tss.ss1 = vcpu->ss1;
 
 	/* Copy direct-to-Guest trap entries. */
 	if (lg->changed & CHANGED_IDT)
@@ -167,12 +167,10 @@ static void run_guest_once(struct lguest_vcpu *vcpu,
  * are disabled: we own the CPU. */
 void lguest_arch_run_guest(struct lguest_vcpu *vcpu)
 {
-	struct lguest *lg = vcpu->lg;
-
 	/* Remember the awfully-named TS bit?  If the Guest has asked to set it
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU. */
-	if (lg->ts)
+	if (vcpu->ts)
 		lguest_set_ts();
 
 	/* SYSENTER is an optimized way of doing system calls.  We can't allow
@@ -328,7 +326,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		/* If the Guest doesn't want to know, we already restored the
 		 * Floating Point Unit, so we just continue without telling
 		 * it. */
-		if (!lg->ts)
+		if (!vcpu->ts)
 			return;
 		break;
 	case 32 ... 255:
-- 
1.5.0.6

