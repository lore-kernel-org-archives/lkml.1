Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbXCSNB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbXCSNB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXCSNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:01:57 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34103 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884AbXCSNBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:01:54 -0400
Date: Mon, 19 Mar 2007 14:02:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] minor fault path optimization.
Message-ID: <20070319130206.GC1292@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] minor fault path optimization.

The minor fault path has grown a lot in terms of cycles. In particular
the kprobes hook is very costly. Optimize the path to save a couple of
cycles. If kprobes is enabled more than 300 cycles can be avoided if 
kprobes_running() is false.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/mm/fault.c |  259 +++++++++++++++++++++++++++------------------------
 1 files changed, 141 insertions(+), 118 deletions(-)

diff -urpN linux-2.6/arch/s390/mm/fault.c linux-2.6-patched/arch/s390/mm/fault.c
--- linux-2.6/arch/s390/mm/fault.c	2007-03-19 13:08:56.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/fault.c	2007-03-19 13:09:34.000000000 +0100
@@ -63,21 +63,25 @@ int unregister_page_fault_notifier(struc
 	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
 }
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static int __kprobes __notify_page_fault(struct pt_regs *regs, long err)
 {
-	struct die_args args = {
-		.regs = regs,
-		.str = str,
-		.err = err,
-		.trapnr = trap,
-		.signr = sig
-	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	struct die_args args = { .str = "page fault",
+				 .trapnr = 14,
+				 .signr = SIGSEGV };
+	args.regs = regs;
+	args.err = err;
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+					  DIE_PAGE_FAULT, &args);
+}
+
+static inline int notify_page_fault(struct pt_regs *regs, long err)
+{
+	if (unlikely(kprobe_running()))
+		return __notify_page_fault(regs, err);
+	return NOTIFY_DONE;
 }
 #else
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
 	return NOTIFY_DONE;
 }
@@ -170,6 +174,89 @@ static void do_sigsegv(struct pt_regs *r
 	force_sig_info(SIGSEGV, &si, current);
 }
 
+static void do_no_context(struct pt_regs *regs, unsigned long error_code,
+			  unsigned long address)
+{
+	const struct exception_table_entry *fixup;
+
+	/* Are we prepared to handle this kernel fault?  */
+	fixup = search_exception_tables(regs->psw.addr & __FIXUP_MASK);
+	if (fixup) {
+		regs->psw.addr = fixup->fixup | PSW_ADDR_AMODE;
+		return;
+	}
+
+	/*
+	 * Oops. The kernel tried to access some bad page. We'll have to
+	 * terminate things with extreme prejudice.
+	 */
+	if (check_space(current) == 0)
+		printk(KERN_ALERT "Unable to handle kernel pointer dereference"
+		       " at virtual kernel address %p\n", (void *)address);
+	else
+		printk(KERN_ALERT "Unable to handle kernel paging request"
+		       " at virtual user address %p\n", (void *)address);
+
+	die("Oops", regs, error_code);
+	do_exit(SIGKILL);
+}
+
+static void do_low_address(struct pt_regs *regs, unsigned long error_code)
+{
+	/* Low-address protection hit in kernel mode means
+	   NULL pointer write access in kernel mode.  */
+	if (regs->psw.mask & PSW_MASK_PSTATE) {
+		/* Low-address protection hit in user mode 'cannot happen'. */
+		die ("Low-address protection", regs, error_code);
+		do_exit(SIGKILL);
+	}
+
+	do_no_context(regs, error_code, 0);
+}
+
+/*
+ * We ran out of memory, or some other thing happened to us that made
+ * us unable to handle the page fault gracefully.
+ */
+static int do_out_of_memory(struct pt_regs *regs, unsigned long error_code,
+			    unsigned long address)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->mm;
+
+	up_read(&mm->mmap_sem);
+	if (is_init(tsk)) {
+		yield();
+		down_read(&mm->mmap_sem);
+		return 1;
+	}
+	printk("VM: killing process %s\n", tsk->comm);
+	if (regs->psw.mask & PSW_MASK_PSTATE)
+		do_exit(SIGKILL);
+	do_no_context(regs, error_code, address);
+	return 0;
+}
+
+static void do_sigbus(struct pt_regs *regs, unsigned long error_code,
+		      unsigned long address)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->mm;
+
+	up_read(&mm->mmap_sem);
+	/*
+	 * Send a sigbus, regardless of whether we were in kernel
+	 * or user mode.
+	 */
+	tsk->thread.prot_addr = address;
+	tsk->thread.trap_no = error_code;
+	force_sig(SIGBUS, tsk);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (!(regs->psw.mask & PSW_MASK_PSTATE))
+		do_no_context(regs, error_code, address);
+}
+
 #ifdef CONFIG_S390_EXEC_PROTECT
 extern long sys_sigreturn(struct pt_regs *regs);
 extern long sys_rt_sigreturn(struct pt_regs *regs);
@@ -253,49 +340,23 @@ out_fault:
  *   3b       Region third trans.  ->  Not present       (nullification)
  */
 static inline void
-do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
+do_exception(struct pt_regs *regs, unsigned long error_code, int write)
 {
-        struct task_struct *tsk;
-        struct mm_struct *mm;
-        struct vm_area_struct * vma;
-        unsigned long address;
-	const struct exception_table_entry *fixup;
-	int si_code;
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	unsigned long address;
 	int space;
+	int si_code;
 
-        tsk = current;
-        mm = tsk->mm;
-	
-	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-					SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
-	/* 
-         * Check for low-address protection.  This needs to be treated
-	 * as a special case because the translation exception code 
-	 * field is not guaranteed to contain valid data in this case.
-	 */
-	if (is_protection && !(S390_lowcore.trans_exc_code & 4)) {
-
-		/* Low-address protection hit in kernel mode means 
-		   NULL pointer write access in kernel mode.  */
- 		if (!(regs->psw.mask & PSW_MASK_PSTATE)) {
-			address = 0;
-			space = 0;
-			goto no_context;
-		}
-
-		/* Low-address protection hit in user mode 'cannot happen'.  */
-		die ("Low-address protection", regs, error_code);
-        	do_exit(SIGKILL);
-	}
+	tsk = current;
+	mm = tsk->mm;
 
-        /* 
-         * get the failing address 
-         * more specific the segment and page table portion of 
-         * the address 
-         */
-        address = S390_lowcore.trans_exc_code & __FAIL_ADDR_MASK;
+	/* get the failing address and the affected space */
+	address = S390_lowcore.trans_exc_code & __FAIL_ADDR_MASK;
 	space = check_space(tsk);
 
 	/*
@@ -313,7 +374,7 @@ do_exception(struct pt_regs *regs, unsig
 	 */
 	local_irq_enable();
 
-        down_read(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 
 	si_code = SEGV_MAPERR;
 	vma = find_vma(mm, address);
@@ -330,19 +391,19 @@ do_exception(struct pt_regs *regs, unsig
 			return;
 #endif
 
-        if (vma->vm_start <= address) 
-                goto good_area;
-        if (!(vma->vm_flags & VM_GROWSDOWN))
-                goto bad_area;
-        if (expand_stack(vma, address))
-                goto bad_area;
+	if (vma->vm_start <= address)
+		goto good_area;
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+	if (expand_stack(vma, address))
+		goto bad_area;
 /*
  * Ok, we have a good vm_area for this memory access, so
  * we can handle it..
  */
 good_area:
 	si_code = SEGV_ACCERR;
-	if (!is_protection) {
+	if (!write) {
 		/* page not present, check vm flags */
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
@@ -357,7 +418,7 @@ survive:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	switch (handle_mm_fault(mm, vma, address, is_protection)) {
+	switch (handle_mm_fault(mm, vma, address, write)) {
 	case VM_FAULT_MINOR:
 		tsk->min_flt++;
 		break;
@@ -365,9 +426,12 @@ survive:
 		tsk->maj_flt++;
 		break;
 	case VM_FAULT_SIGBUS:
-		goto do_sigbus;
+		do_sigbus(regs, error_code, address);
+		return;
 	case VM_FAULT_OOM:
-		goto out_of_memory;
+		if (do_out_of_memory(regs, error_code, address))
+			goto survive;
+		return;
 	default:
 		BUG();
 	}
@@ -385,75 +449,34 @@ survive:
  * Fix it, but check if it's kernel or user first..
  */
 bad_area:
-        up_read(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 
-        /* User mode accesses just cause a SIGSEGV */
-        if (regs->psw.mask & PSW_MASK_PSTATE) {
-                tsk->thread.prot_addr = address;
-                tsk->thread.trap_no = error_code;
+	/* User mode accesses just cause a SIGSEGV */
+	if (regs->psw.mask & PSW_MASK_PSTATE) {
+		tsk->thread.prot_addr = address;
+		tsk->thread.trap_no = error_code;
 		do_sigsegv(regs, error_code, si_code, address);
-                return;
+		return;
 	}
 
 no_context:
-        /* Are we prepared to handle this kernel fault?  */
-	fixup = search_exception_tables(regs->psw.addr & __FIXUP_MASK);
-	if (fixup) {
-		regs->psw.addr = fixup->fixup | PSW_ADDR_AMODE;
-                return;
-        }
-
-/*
- * Oops. The kernel tried to access some bad page. We'll have to
- * terminate things with extreme prejudice.
- */
-	if (space == 0)
-                printk(KERN_ALERT "Unable to handle kernel pointer dereference"
-        	       " at virtual kernel address %p\n", (void *)address);
-        else
-                printk(KERN_ALERT "Unable to handle kernel paging request"
-		       " at virtual user address %p\n", (void *)address);
-
-        die("Oops", regs, error_code);
-        do_exit(SIGKILL);
-
-
-/*
- * We ran out of memory, or some other thing happened to us that made
- * us unable to handle the page fault gracefully.
-*/
-out_of_memory:
-	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
-	printk("VM: killing process %s\n", tsk->comm);
-	if (regs->psw.mask & PSW_MASK_PSTATE)
-		do_exit(SIGKILL);
-	goto no_context;
-
-do_sigbus:
-	up_read(&mm->mmap_sem);
-
-	/*
-	 * Send a sigbus, regardless of whether we were in kernel
-	 * or user mode.
-	 */
-        tsk->thread.prot_addr = address;
-        tsk->thread.trap_no = error_code;
-	force_sig(SIGBUS, tsk);
-
-	/* Kernel mode? Handle exceptions or die */
-	if (!(regs->psw.mask & PSW_MASK_PSTATE))
-		goto no_context;
+	do_no_context(regs, error_code, address);
 }
 
 void __kprobes do_protection_exception(struct pt_regs *regs,
 				       unsigned long error_code)
 {
+	/* Protection exception is supressing, decrement psw address. */
 	regs->psw.addr -= (error_code >> 16);
+	/*
+	 * Check for low-address protection.  This needs to be treated
+	 * as a special case because the translation exception code
+	 * field is not guaranteed to contain valid data in this case.
+	 */
+	if (unlikely(!(S390_lowcore.trans_exc_code & 4))) {
+		do_low_address(regs, error_code);
+		return;
+	}
 	do_exception(regs, 4, 1);
 }
 
