Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYACC2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYACC2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYACC2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:28:00 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:35865 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYACC17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:27:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iMtCJiYGca1D0uwnficRxITh8vkyNm6SpsS2h3z9FqQqsjXvheB/RJ3aa9o6YkUG4KST+yu0Huy9OgUd81tuF+MCGtyp2HqcCqkaWegFNQKdHUqu+IEllYJH6yDSt/qS3ipiMSUIc7yplqjrcUSf0uFV2cYgTJl6cAcHUECO/YU=
Subject: [PATCHv2] x86: fault_{32|64}.c unify do_page_fault
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 18:27:56 -0800
Message-Id: <1199327276.6323.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Begin to unify do_page_fault(), easy code movement first.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, Alexey Dobriyan noticed an obvious typo CONFIG_x86_64 in
the previous version, this is a fixed patch.

 arch/x86/mm/fault_32.c |   38 +++++++++++++++++++++++++++++---------
 arch/x86/mm/fault_64.c |   23 ++++++++++++++++++-----
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index b1893eb..051a4ec 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -375,19 +375,26 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned long address;
-	int write, si_code;
-	int fault;
+	int write, fault;
+#ifdef CONFIG_X86_64
+	unsigned long flags;
+#endif
+	int si_code;
 
 	/*
 	 * We can fault from pretty much anywhere, with unknown IRQ state.
 	 */
 	trace_hardirqs_fixup();
 
-	/* get the address */
-	address = read_cr2();
-
 	tsk = current;
+	mm = tsk->mm;
 
+#ifdef CONFIG_X86_64
+	prefetchw(&mm->mmap_sem);
+#endif
+
+	/* get the address */
+	address = read_cr2();
 	si_code = SEGV_MAPERR;
 
 	/*
@@ -403,9 +410,24 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * (error_code & 4) == 0, and that the fault was not a
 	 * protection error (error_code & 9) == 0.
 	 */
+#ifdef CONFIG_X86_32
 	if (unlikely(address >= TASK_SIZE)) {
-		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
+		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+		    vmalloc_fault(address) >= 0)
 			return;
+#else
+	if (unlikely(address >= TASK_SIZE64)) {
+		/*
+		 * Don't check for the module range here: its PML4
+		 * is always initialized because it's shared with the main
+		 * kernel text. Only vmalloc may need PML4 syncups.
+		 */
+		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+		      ((address >= VMALLOC_START && address < VMALLOC_END))) {
+			if (vmalloc_fault(address) >= 0)
+				return;
+		}
+#endif
 		if (notify_page_fault(regs))
 			return;
 		/*
@@ -423,8 +445,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
 		local_irq_enable();
 
-	mm = tsk->mm;
-
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
 	 * atomic region then we must not take the fault.
@@ -495,7 +515,7 @@ good_area:
 			goto bad_area;
 	}
 
- survive:
+survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 357a3e0..97b92b6 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -426,7 +426,9 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	struct vm_area_struct *vma;
 	unsigned long address;
 	int write, fault;
+#ifdef CONFIG_X86_64
 	unsigned long flags;
+#endif
 	int si_code;
 
 	/*
@@ -436,14 +438,15 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 
 	tsk = current;
 	mm = tsk->mm;
+
+#ifdef CONFIG_X86_64
 	prefetchw(&mm->mmap_sem);
+#endif
 
 	/* get the address */
 	address = read_cr2();
-
 	si_code = SEGV_MAPERR;
 
-
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
@@ -457,6 +460,12 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	 * (error_code & 4) == 0, and that the fault was not a
 	 * protection error (error_code & 9) == 0.
 	 */
+#ifdef CONFIG_X86_32
+	if (unlikely(address >= TASK_SIZE)) {
+		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+		    vmalloc_fault(address) >= 0)
+			return;
+#else
 	if (unlikely(address >= TASK_SIZE64)) {
 		/*
 		 * Don't check for the module range here: its PML4
@@ -468,6 +477,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
+#endif
 		if (notify_page_fault(regs))
 			return;
 		/*
@@ -500,7 +510,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	if (user_mode_vm(regs))
 		error_code |= PF_USER;
 
- again:
+again:
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -531,8 +541,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
 	if (error_code & PF_USER) {
-		/* Allow userspace just enough access below the stack pointer
-		 * to let the 'enter' instruction work.
+		/*
+		 * Accessing the stack below %sp is always a bug.
+		 * The large cushion allows instructions like enter
+		 * and pusha to work.  ("enter $65535,$31" pushes
+		 * 32 pointers and then decrements %sp by 65535.)
 		 */
 		if (address + 65536 + 32 * sizeof(unsigned long) < regs->sp)
 			goto bad_area;
-- 
1.5.4.rc2.1097.gb6e0d



