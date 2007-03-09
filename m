Return-Path: <linux-kernel-owner+w=401wt.eu-S2992917AbXCIDRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992917AbXCIDRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992921AbXCIDRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:17:51 -0500
Received: from ozlabs.org ([203.10.76.45]:45452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992917AbXCIDRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:17:50 -0500
Subject: [PATCH 4/9] lguest: cleanup: clean up regs save/restore
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173409939.32234.73.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
	 <1173409939.32234.73.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:16:50 +1100
Message-Id: <1173410210.32234.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We previously put "cr3" in the guest regs restored and saved: the
guest cannot change cr3, so saving it it silly.  Hand it across to the
host<->guest switcher in ebx.

While we're there, only save the host registers we need to; tell GCC
we clobber everything we can.

Finally, and trap 2 (NMI) doesn't supply a error code (we don't handle
NMI yet, but the test is wrong, so fix it before I get confused).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 6efda2f8ac22 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Thu Mar 08 16:25:07 2007 +1100
+++ b/arch/i386/lguest/core.c	Thu Mar 08 16:51:17 2007 +1100
@@ -260,11 +260,11 @@ static void run_guest_once(struct lguest
 {
 	unsigned int clobber;
 
-	/* Put eflags on stack, lcall does rest. */
+	/* Put eflags on stack, lcall does rest: suitable for iret return. */
 	asm volatile("pushf; lcall *lguest_entry"
-		     : "=a"(clobber), "=d"(clobber)
-		     : "0"(lg->state), "1"(get_idt_table())
-		     : "memory");
+		     : "=a"(clobber), "=d"(clobber), "=b"(clobber)
+		     : "0"(lg->state), "1"(get_idt_table()), "2"(lg->cr3)
+		     : "memory", "%ecx", "%edi", "%esi");
 }
 
 int run_guest(struct lguest *lg, char *__user user)
diff -r 6efda2f8ac22 arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S	Thu Mar 08 16:25:07 2007 +1100
+++ b/arch/i386/lguest/hypervisor.S	Thu Mar 08 16:52:56 2007 +1100
@@ -4,26 +4,17 @@
 #include <asm/asm-offsets.h>
 #include "lg.h"
 
-#define SAVE_REGS				\
-	/* Save old guest/host state */		\
-	pushl	%es;				\
-	pushl	%ds;				\
-	pushl	%fs;				\
-	pushl	%eax;				\
-	pushl	%gs;				\
-	pushl	%ebp;				\
-	pushl	%edi;				\
-	pushl	%esi;				\
-	pushl	%edx;				\
-	pushl	%ecx;				\
-	pushl	%ebx;				\
-
 .text
 ENTRY(_start) /* ld complains unless _start is defined. */
-/* %eax contains ptr to target guest state, %edx contains host idt. */
+/* %eax contains ptr to target guest state, %edx contains host idt.
+   %ebx contains cr3 value.  All normal registers can be clobbered! */
 switch_to_guest:
-	pushl	%ss
-	SAVE_REGS
+	pushl	%es
+	pushl	%ds
+	pushl	%fs
+	pushl	%gs
+	pushl	%edx
+	pushl	%ebp
 	/* Save old stack, switch to guest's stack. */
 	movl	%esp, LGUEST_STATE_host_stackptr(%eax)
 	movl	%eax, %esp
@@ -33,17 +24,16 @@ switch_to_guest:
 	lgdt	LGUEST_STATE_gdt(%eax)
 	lidt	LGUEST_STATE_idt(%eax)
 	/* Save page table top. */
-	movl	%cr3, %ebx
-	movl	%ebx, LGUEST_STATE_host_pgdir(%eax)
+	movl	%cr3, %ecx
+	movl	%ecx, LGUEST_STATE_host_pgdir(%eax)
 	/* Set host's TSS to available (clear byte 5 bit 2). */
-	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ebx
-	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ebx)
+	movl	(LGUEST_STATE_host_gdt+2)(%eax), %ecx
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%ecx)
 	/* Switch to guest page tables */
-	popl	%ebx
 	movl	%ebx, %cr3
 	/* Switch to guest's TSS. */
-	movl	$(GDT_ENTRY_TSS*8), %ebx
-	ltr	%bx
+	movl	$(GDT_ENTRY_TSS*8), %edx
+	ltr	%dx
 	/* Restore guest regs */
 	popl	%ebx
 	popl	%ecx
@@ -66,10 +56,18 @@ switch_to_guest:
 	iret
 
 #define SWITCH_TO_HOST							\
-	SAVE_REGS;							\
-	/* Save old pgdir */						\
-	movl	%cr3, %eax;						\
+	/* Save guest state */						\
+	pushl	%es;							\
+	pushl	%ds;							\
+	pushl	%fs;							\
 	pushl	%eax;							\
+	pushl	%gs;							\
+	pushl	%ebp;							\
+	pushl	%edi;							\
+	pushl	%esi;							\
+	pushl	%edx;							\
+	pushl	%ecx;							\
+	pushl	%ebx;							\
 	/* Load lguest ds segment for convenience. */			\
 	movl	$(LGUEST_DS), %eax;					\
 	movl	%eax, %ds;						\
@@ -88,21 +86,15 @@ switch_to_guest:
 	/* Switch to host's stack. */					\
 	movl	LGUEST_STATE_host_stackptr(%eax), %esp;			\
 	/* Switch to host's TSS */					\
-	movl	$(GDT_ENTRY_TSS*8), %eax;				\
-	ltr	%ax;							\
+	movl	$(GDT_ENTRY_TSS*8), %ebx;				\
+	ltr	%bx;							\
 	/* Restore host regs */						\
-	popl	%ebx;							\
-	popl	%ecx;							\
+	popl	%ebp;							\
 	popl	%edx;							\
-	popl	%esi;							\
-	popl	%edi;							\
-	popl	%ebp;							\
 	popl	%gs;							\
-	popl	%eax;							\
 	popl	%fs;							\
 	popl	%ds;							\
-	popl	%es;							\
-	popl	%ss
+	popl	%es
 
 /* Return to run_guest_once. */
 return_to_host:
@@ -135,7 +127,7 @@ deliver_to_host_with_errcode:
 .macro IRQ_STUB N TARGET
 	.data; .long 1f; .text; 1:
  /* Make an error number for most traps, which don't have one. */
- .if (\N <> 2) && (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
+ .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
 	pushl	$0
  .endif
 	pushl	$\N
diff -r 6efda2f8ac22 arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h	Thu Mar 08 16:25:07 2007 +1100
+++ b/arch/i386/lguest/lg.h	Thu Mar 08 16:51:17 2007 +1100
@@ -24,7 +24,6 @@ struct lguest_regs
 struct lguest_regs
 {
 	/* Manually saved part. */
-	u32 cr3;
 	u32 ebx, ecx, edx;
 	u32 esi, edi, ebp;
 	u32 gs;
@@ -81,6 +80,7 @@ struct lguest
 	u32 pfn_limit;
 	u32 page_offset;
 	u32 cr2;
+	u32 cr3;
 	int timer_on;
 	int halted;
 	int ts;
diff -r 6efda2f8ac22 arch/i386/lguest/lguest_user.c
--- a/arch/i386/lguest/lguest_user.c	Thu Mar 08 16:25:07 2007 +1100
+++ b/arch/i386/lguest/lguest_user.c	Thu Mar 08 16:51:17 2007 +1100
@@ -4,7 +4,7 @@
 #include <linux/fs.h>
 #include "lg.h"
 
-static struct lguest_state *setup_guest_state(unsigned int num, void *pgdir,
+static struct lguest_state *setup_guest_state(unsigned int num,
 					      unsigned long start)
 {
 	struct lguest_state *guest = &__lguest_states()[num];
@@ -38,7 +38,6 @@ static struct lguest_state *setup_guest_
 
 	/* Write out stack in format lguest expects, so we can switch to it. */
 	regs = &guest->regs;
-	regs->cr3 = __pa(pgdir);
 	regs->eax = regs->ebx = regs->ecx = regs->edx = regs->esp = 0;
 	regs->edi = LGUEST_MAGIC_EDI;
 	regs->ebp = LGUEST_MAGIC_EBP;
@@ -149,7 +148,7 @@ static int initialize(struct file *file,
 	if (err)
 		goto free_trap_page;
 
-	lg->state = setup_guest_state(i, lg->pgdirs[lg->pgdidx].pgdir,args[2]);
+	lg->state = setup_guest_state(i, args[2]);
 	if (!lg->state) {
 		err = -ENOEXEC;
 		goto release_pgtable;
diff -r 6efda2f8ac22 arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c	Thu Mar 08 16:25:07 2007 +1100
+++ b/arch/i386/lguest/page_tables.c	Thu Mar 08 16:51:17 2007 +1100
@@ -223,7 +223,7 @@ void guest_new_pagetable(struct lguest *
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
 		newpgdir = new_pgdir(lg, pgtable);
 	lg->pgdidx = newpgdir;
-	lg->state->regs.cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
 	pin_stack_pages(lg);
 }
 
@@ -296,6 +296,7 @@ int init_guest_pagetable(struct lguest *
 	lg->pgdirs[lg->pgdidx].pgdir = (u32*)get_zeroed_page(GFP_KERNEL);
 	if (!lg->pgdirs[lg->pgdidx].pgdir)
 		return -ENOMEM;
+	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
 	return 0;
 }
 


