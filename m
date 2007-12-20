Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXLTNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXLTNjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXLTNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762559AbXLTNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:09 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 11/16] make registers per-vcpu
Date: Thu, 20 Dec 2007 11:33:51 -0200
Message-Id: <1198157692575-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576884121-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the most obvious per-vcpu field: registers.

So this patch moves it from struct lguest to struct vcpu,
and patch the places in which they are used, accordingly

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/interrupts_and_traps.c |   29 ++++++++++++-----------
 drivers/lguest/lg.h                   |    9 ++++---
 drivers/lguest/lguest_user.c          |   36 +++++++++++++++---------------
 drivers/lguest/page_tables.c          |    4 ++-
 drivers/lguest/x86/core.c             |   39 +++++++++++++++++----------------
 5 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index db440cb..1ceff5f 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -71,7 +71,7 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 	/* There are two cases for interrupts: one where the Guest is already
 	 * in the kernel, and a more complex one where the Guest is in
 	 * userspace.  We check the privilege level to find out. */
-	if ((lg->regs->ss&0x3) != GUEST_PL) {
+	if ((vcpu->regs->ss&0x3) != GUEST_PL) {
 		/* The Guest told us their kernel stack with the SET_STACK
 		 * hypercall: both the virtual address and the segment */
 		virtstack = lg->esp1;
@@ -82,12 +82,12 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 		 * stack: when the Guest does an "iret" back from the interrupt
 		 * handler the CPU will notice they're dropping privilege
 		 * levels and expect these here. */
-		push_guest_stack(lg, &gstack, lg->regs->ss);
-		push_guest_stack(lg, &gstack, lg->regs->esp);
+		push_guest_stack(lg, &gstack, vcpu->regs->ss);
+		push_guest_stack(lg, &gstack, vcpu->regs->esp);
 	} else {
 		/* We're staying on the same Guest (kernel) stack. */
-		virtstack = lg->regs->esp;
-		ss = lg->regs->ss;
+		virtstack = vcpu->regs->esp;
+		ss = vcpu->regs->ss;
 
 		origstack = gstack = guest_pa(lg, virtstack);
 	}
@@ -96,7 +96,7 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 	 * the "Interrupt Flag" bit is always set.  We copy that bit from the
 	 * Guest's "irq_enabled" field into the eflags word: we saw the Guest
 	 * copy it back in "lguest_iret". */
-	eflags = lg->regs->eflags;
+	eflags = vcpu->regs->eflags;
 	if (get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
 	    && !(irq_enable & X86_EFLAGS_IF))
 		eflags &= ~X86_EFLAGS_IF;
@@ -105,19 +105,19 @@ static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
 	 * "eflags" word, the old code segment, and the old instruction
 	 * pointer. */
 	push_guest_stack(lg, &gstack, eflags);
-	push_guest_stack(lg, &gstack, lg->regs->cs);
-	push_guest_stack(lg, &gstack, lg->regs->eip);
+	push_guest_stack(lg, &gstack, vcpu->regs->cs);
+	push_guest_stack(lg, &gstack, vcpu->regs->eip);
 
 	/* For the six traps which supply an error code, we push that, too. */
 	if (has_err)
-		push_guest_stack(lg, &gstack, lg->regs->errcode);
+		push_guest_stack(lg, &gstack, vcpu->regs->errcode);
 
 	/* Now we've pushed all the old state, we change the stack, the code
 	 * segment and the address to execute. */
-	lg->regs->ss = ss;
-	lg->regs->esp = virtstack + (gstack - origstack);
-	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
-	lg->regs->eip = idt_address(lo, hi);
+	vcpu->regs->ss = ss;
+	vcpu->regs->esp = virtstack + (gstack - origstack);
+	vcpu->regs->cs = (__KERNEL_CS|GUEST_PL);
+	vcpu->regs->eip = idt_address(lo, hi);
 
 	/* There are two kinds of interrupt handlers: 0xE is an "interrupt
 	 * gate" which expects interrupts to be disabled on entry. */
@@ -158,7 +158,8 @@ void maybe_do_interrupt(struct lguest_vcpu *vcpu)
 
 	/* They may be in the middle of an iret, where they asked us never to
 	 * deliver interrupts. */
-	if (lg->regs->eip >= lg->noirq_start && lg->regs->eip < lg->noirq_end)
+	if ((vcpu->regs->eip >= lg->noirq_start) &&
+	    (vcpu->regs->eip < lg->noirq_end))
 		return;
 
 	/* If they're halted, interrupts restart them. */
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index f6e9020..d05fe38 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -44,6 +44,10 @@ struct lguest_vcpu {
 	int vcpu_id;
 	struct lguest *lg;
 
+	/* At end of a page shared mapped over lguest_pages in guest.  */
+	unsigned long regs_page;
+	struct lguest_regs *regs;
+
 	/* If a hypercall was asked for, this points to the arguments. */
 	struct hcall_args *hcall;
 	u32 next_hcall;
@@ -58,9 +62,6 @@ struct lguest_vcpu {
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
-	/* At end of a page shared mapped over lguest_pages in guest.  */
-	unsigned long regs_page;
-	struct lguest_regs *regs;
 	struct lguest_data __user *lguest_data;
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
@@ -187,7 +188,7 @@ void lguest_arch_run_guest(struct lguest_vcpu *vcpu);
 void lguest_arch_handle_trap(struct lguest_vcpu *vcpu);
 int lguest_arch_init_hypercalls(struct lguest_vcpu *vcpu);
 int lguest_arch_do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args);
-void lguest_arch_setup_regs(struct lguest *lg, unsigned long start);
+void lguest_arch_setup_regs(struct lguest_vcpu *vcpu, unsigned long start);
 
 /* <arch>/switcher.S: */
 extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 60cf6c6..4f51e25 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -101,6 +101,19 @@ static int vcpu_start(struct lguest_vcpu *vcpu, int vcpu_id,
 	/* The timer for lguest's clock needs initialization. */
 	init_clockdev(vcpu);
 
+	/* We need a complete page for the Guest registers: they are accessible
+	 * to the Guest and we can only grant it access to whole pages. */
+	vcpu->regs_page = get_zeroed_page(GFP_KERNEL);
+	if (!vcpu->regs_page)
+		return -ENOMEM;
+
+	/* We actually put the registers at the bottom of the page. */
+	vcpu->regs = (void *)vcpu->regs_page + PAGE_SIZE - sizeof(*vcpu->regs);
+
+	/* Now we initialize the Guest's registers, handing it the start
+	 * address. */
+	lguest_arch_setup_regs(vcpu, start_ip);
+
 	vcpu->lg = container_of((vcpu - vcpu_id), struct lguest, vcpus[0]);
 	vcpu->lg->nr_vcpus++;
 
@@ -159,16 +172,6 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	if (err)
 		goto release_guest;
 
-	/* We need a complete page for the Guest registers: they are accessible
-	 * to the Guest and we can only grant it access to whole pages. */
-	lg->regs_page = get_zeroed_page(GFP_KERNEL);
-	if (!lg->regs_page) {
-		err = -ENOMEM;
-		goto release_guest;
-	}
-	/* We actually put the registers at the bottom of the page. */
-	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
-
 	/* Initialize the Guest's shadow page tables, using the toplevel
 	 * address the Launcher gave us.  This allocates memory, so can
 	 * fail. */
@@ -176,10 +179,6 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	if (err)
 		goto free_regs;
 
-	/* Now we initialize the Guest's registers, handing it the start
-	 * address. */
-	lguest_arch_setup_regs(lg, args[3]);
-
 	/* We keep a pointer to the Launcher task (ie. current task) for when
 	 * other Guests want to wake this one (inter-Guest I/O). */
 	lg->tsk = current;
@@ -204,7 +203,7 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	return sizeof(args);
 
 free_regs:
-	free_page(lg->regs_page);
+	free_page(lg->vcpus[0].regs_page);
 release_guest:
 	kfree(lg);
 unlock:
@@ -279,9 +278,12 @@ static int close(struct inode *inode, struct file *file)
 	/* We need the big lock, to protect from inter-guest I/O and other
 	 * Launchers initializing guests. */
 	mutex_lock(&lguest_lock);
-	for (i = 0; i < lg->nr_vcpus; i++)
+	for (i = 0; i < lg->nr_vcpus; i++) {
 		/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
 		hrtimer_cancel(&lg->vcpus[i].hrt);
+		/* We can free up the register page we allocated. */
+		free_page(lg->vcpus[i].regs_page);
+	}
 	/* Free up the shadow page tables for the Guest. */
 	free_guest_pagetable(lg);
 	/* Now all the memory cleanups are done, it's safe to release the
@@ -291,8 +293,6 @@ static int close(struct inode *inode, struct file *file)
 	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
-	/* We can free up the register page we allocated. */
-	free_page(lg->regs_page);
 	/* We clear the entire structure, which also marks it as free for the
 	 * next user. */
 	memset(lg, 0, sizeof(*lg));
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 7fb8627..8c41030 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -641,6 +641,7 @@ void map_switcher_in_guest(struct lguest_vcpu *vcpu,
 	pte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
 	pgd_t switcher_pgd;
 	pte_t regs_pte;
+	unsigned long pfn;
 
 	/* Make the last PGD entry for this Guest point to the Switcher's PTE
 	 * page for this CPU (with appropriate flags). */
@@ -655,7 +656,8 @@ void map_switcher_in_guest(struct lguest_vcpu *vcpu,
 	 * CPU's "struct lguest_pages": if we make sure the Guest's register
 	 * page is already mapped there, we don't have to copy them out
 	 * again. */
-	regs_pte = pfn_pte (__pa(lg->regs_page) >> PAGE_SHIFT, __pgprot(_PAGE_KERNEL));
+	pfn = __pa(vcpu->regs_page) >> PAGE_SHIFT;
+	regs_pte = pfn_pte(pfn, __pgprot(_PAGE_KERNEL));
 	switcher_pte_page[(unsigned long)pages/PAGE_SIZE%PTRS_PER_PTE] = regs_pte;
 }
 /*:*/
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 2fb9cd3..a0d710e 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -129,7 +129,7 @@ static void run_guest_once(struct lguest_vcpu *vcpu,
 	/* Set the trap number to 256 (impossible value).  If we fault while
 	 * switching to the Guest (bad segment registers or bug), this will
 	 * cause us to abort the Guest. */
-	lg->regs->trapnum = 256;
+	vcpu->regs->trapnum = 256;
 
 	/* Now: we push the "eflags" register on the stack, then do an "lcall".
 	 * This is how we change from using the kernel code segment to using
@@ -197,11 +197,11 @@ void lguest_arch_run_guest(struct lguest_vcpu *vcpu)
 	 * bad virtual address.  We have to grab this now, because once we
 	 * re-enable interrupts an interrupt could fault and thus overwrite
 	 * cr2, or we could even move off to a different CPU. */
-	if (lg->regs->trapnum == 14)
+	if (vcpu->regs->trapnum == 14)
 		lg->arch.last_pagefault = read_cr2();
 	/* Similarly, if we took a trap because the Guest used the FPU,
 	 * we have to restore the FPU it expects to see. */
-	else if (lg->regs->trapnum == 7)
+	else if (vcpu->regs->trapnum == 7)
 		math_state_restore();
 
 	/* Restore SYSENTER if it's supposed to be on. */
@@ -227,12 +227,12 @@ static int emulate_insn(struct lguest_vcpu *vcpu)
 	unsigned int insnlen = 0, in = 0, shift = 0;
 	/* The eip contains the *virtual* address of the Guest's instruction:
 	 * guest_pa just subtracts the Guest's page_offset. */
-	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
+	unsigned long physaddr = guest_pa(lg, vcpu->regs->eip);
 
 	/* This must be the Guest kernel trying to do something, not userspace!
 	 * The bottom two bits of the CS segment register are the privilege
 	 * level. */
-	if ((lg->regs->cs & 3) != GUEST_PL)
+	if ((vcpu->regs->cs & 3) != GUEST_PL)
 		return 0;
 
 	/* Decoding x86 instructions is icky. */
@@ -275,12 +275,12 @@ static int emulate_insn(struct lguest_vcpu *vcpu)
 	if (in) {
 		/* Lower bit tells is whether it's a 16 or 32 bit access */
 		if (insn & 0x1)
-			lg->regs->eax = 0xFFFFFFFF;
+			vcpu->regs->eax = 0xFFFFFFFF;
 		else
-			lg->regs->eax |= (0xFFFF << shift);
+			vcpu->regs->eax |= (0xFFFF << shift);
 	}
 	/* Finally, we've "done" the instruction, so move past it. */
-	lg->regs->eip += insnlen;
+	vcpu->regs->eip += insnlen;
 	/* Success! */
 	return 1;
 }
@@ -289,12 +289,12 @@ static int emulate_insn(struct lguest_vcpu *vcpu)
 void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 {
 	struct lguest *lg = vcpu->lg;
-	switch (lg->regs->trapnum) {
+	switch (vcpu->regs->trapnum) {
 	case 13: /* We've intercepted a General Protection Fault. */
 		/* Check if this was one of those annoying IN or OUT
 		 * instructions which we need to emulate.  If so, we just go
 		 * back into the Guest after we've done it. */
-		if (lg->regs->errcode == 0) {
+		if (vcpu->regs->errcode == 0) {
 			if (emulate_insn(vcpu))
 				return;
 		}
@@ -309,7 +309,8 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		 *
 		 * The errcode tells whether this was a read or a write, and
 		 * whether kernel or userspace code. */
-		if (demand_page(lg, lg->arch.last_pagefault, lg->regs->errcode))
+		if (demand_page(lg, lg->arch.last_pagefault,
+				vcpu->regs->errcode))
 			return;
 
 		/* OK, it's really not there (or not OK): the Guest needs to
@@ -340,19 +341,19 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 	case LGUEST_TRAP_ENTRY:
 		/* Our 'struct hcall_args' maps directly over our regs: we set
 		 * up the pointer now to indicate a hypercall is pending. */
-		vcpu->hcall = (struct hcall_args *)lg->regs;
+		vcpu->hcall = (struct hcall_args *)vcpu->regs;
 		return;
 	}
 
 	/* We didn't handle the trap, so it needs to go to the Guest. */
-	if (!deliver_trap(vcpu, lg->regs->trapnum))
+	if (!deliver_trap(vcpu, vcpu->regs->trapnum))
 		/* If the Guest doesn't have a handler (either it hasn't
 		 * registered any yet, or it's one of the faults we don't let
 		 * it handle), it dies with a cryptic error message. */
 		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
-			   lg->regs->trapnum, lg->regs->eip,
-			   lg->regs->trapnum == 14 ? lg->arch.last_pagefault
-			   : lg->regs->errcode);
+			   vcpu->regs->trapnum, vcpu->regs->eip,
+			   vcpu->regs->trapnum == 14 ? lg->arch.last_pagefault
+			   : vcpu->regs->errcode);
 }
 
 /* Now we can look at each of the routines this calls, in increasing order of
@@ -559,9 +560,9 @@ int lguest_arch_init_hypercalls(struct lguest_vcpu *vcpu)
  *
  * Most of the Guest's registers are left alone: we used get_zeroed_page() to
  * allocate the structure, so they will be 0. */
-void lguest_arch_setup_regs(struct lguest *lg, unsigned long start)
+void lguest_arch_setup_regs(struct lguest_vcpu *vcpu, unsigned long start)
 {
-	struct lguest_regs *regs = lg->regs;
+	struct lguest_regs *regs = vcpu->regs;
 
 	/* There are four "segment" registers which the Guest needs to boot:
 	 * The "code segment" register (cs) refers to the kernel code segment
@@ -588,5 +589,5 @@ void lguest_arch_setup_regs(struct lguest *lg, unsigned long start)
 
 	/* There are a couple of GDT entries the Guest expects when first
 	 * booting. */
-	setup_guest_gdt(lg);
+	setup_guest_gdt(vcpu->lg);
 }
-- 
1.5.0.6

