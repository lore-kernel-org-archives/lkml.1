Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZATDYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZATDYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZATDYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:24:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:47013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZATDYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:24:30 -0500
Date: Tue, 20 Jan 2009 04:24:26 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] x86: optimise page fault entry
Message-ID: <20090120032426.GE16304@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay with this. The kernel ended up unbootable for me when
I last dusted off the patch, so I couldn't test it and then promptly
got sidetracked with other things.

Anyway, this one is tested with a boot, some basic segfault sigbus etc
tests, and passes various of the mmap and mprotect etc. ltp tests.

Ingo, would you merge this into the x86 tree, please? (unless Linus has
any objections to this version)

Thanks,
Nick
---

Optimise x86's do_page_fault (C entry point for the page fault path).

gcc isn't _all_ that smart about spilling registers to stack or reusing
stack slots, even with branch annotations. do_page_fault contained a lot
of functionality, so split unlikely paths into their own functions, and
mark them as noinline just to be sure. I consider this actually to be
somewhat of a cleanup too: the main function now contains about half
the number of lines so the normal path is easier to read, while the error
cases are also nicely split away.

Also, ensure the order of arguments to functions is always the same: regs,
addr, error_code. This can reduce code size a tiny bit, and just looks neater
too.

And add a couple of branch annotations.

Before:
  do_page_fault:
          subq    $360, %rsp      #,

After:
  do_page_fault:
          subq    $56, %rsp       #,

bloat-o-meter:
  add/remove: 8/0 grow/shrink: 0/1 up/down: 2222/-1680 (542)
  function                                     old     new   delta
  __bad_area_nosemaphore                         -     506    +506
  no_context                                     -     474    +474
  vmalloc_fault                                  -     424    +424
  spurious_fault                                 -     358    +358
  mm_fault_error                                 -     272    +272
  bad_area_access_error                          -      89     +89
  bad_area                                       -      89     +89
  bad_area_nosemaphore                           -      10     +10
  do_page_fault                               2464     784   -1680

Yes, the total size increases by 542 bytes, due to the extra function calls.
But these will very rarely be called (except for vmalloc_fault) in a normal
workload. Importantly, do_page_fault is less than 1/3rd it's original size,
and touches far less stack.

Existing gotos and branch hints did move a lot of the infrequently used text
out of the fastpath, but that's even further improved after this patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/x86/mm/fault.c |  436 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 255 insertions(+), 181 deletions(-)

Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -91,8 +91,8 @@ static inline int notify_page_fault(stru
  *
  * Opcode checker based on code by Richard Brunner
  */
-static int is_prefetch(struct pt_regs *regs, unsigned long addr,
-		       unsigned long error_code)
+static int is_prefetch(struct pt_regs *regs, unsigned long error_code,
+			unsigned long addr)
 {
 	unsigned char *instr;
 	int scan_more = 1;
@@ -409,15 +409,15 @@ static void show_fault_oops(struct pt_re
 }
 
 #ifdef CONFIG_X86_64
-static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
-				 unsigned long error_code)
+static noinline void pgtable_bad(struct pt_regs *regs,
+			 unsigned long error_code, unsigned long address)
 {
 	unsigned long flags = oops_begin();
 	int sig = SIGKILL;
-	struct task_struct *tsk;
+	struct task_struct *tsk = current;
 
 	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
-	       current->comm, address);
+	       tsk->comm, address);
 	dump_pagetable(address);
 	tsk = current;
 	tsk->thread.cr2 = address;
@@ -429,6 +429,190 @@ static noinline void pgtable_bad(unsigne
 }
 #endif
 
+static noinline void no_context(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	struct task_struct *tsk = current;
+#ifdef CONFIG_X86_64
+	unsigned long flags;
+	int sig;
+#endif
+
+	/* Are we prepared to handle this kernel fault?  */
+	if (fixup_exception(regs))
+		return;
+
+	/*
+	 * X86_32
+	 * Valid to do another page fault here, because if this fault
+	 * had been triggered by is_prefetch fixup_exception would have
+	 * handled it.
+	 *
+	 * X86_64
+	 * Hall of shame of CPU/BIOS bugs.
+	 */
+	if (is_prefetch(regs, error_code, address))
+		return;
+
+	if (is_errata93(regs, address))
+		return;
+
+	/*
+	 * Oops. The kernel tried to access some bad page. We'll have to
+	 * terminate things with extreme prejudice.
+	 */
+#ifdef CONFIG_X86_32
+	bust_spinlocks(1);
+#else
+	flags = oops_begin();
+#endif
+
+	show_fault_oops(regs, error_code, address);
+
+	tsk->thread.cr2 = address;
+	tsk->thread.trap_no = 14;
+	tsk->thread.error_code = error_code;
+
+#ifdef CONFIG_X86_32
+	die("Oops", regs, error_code);
+	bust_spinlocks(0);
+	do_exit(SIGKILL);
+#else
+	sig = SIGKILL;
+	if (__die("Oops", regs, error_code))
+		sig = 0;
+	/* Executive summary in case the body of the oops scrolled away */
+	printk(KERN_EMERG "CR2: %016lx\n", address);
+	oops_end(flags, regs, sig);
+#endif
+}
+
+static void __bad_area_nosemaphore(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address,
+			int si_code)
+{
+	struct task_struct *tsk = current;
+
+	/* User mode accesses just cause a SIGSEGV */
+	if (error_code & PF_USER) {
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
+		/*
+		 * Valid to do another page fault here because this one came
+		 * from user space.
+		 */
+		if (is_prefetch(regs, error_code, address))
+			return;
+
+		if (is_errata100(regs, address))
+			return;
+
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			printk(
+			"%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
+			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+			tsk->comm, task_pid_nr(tsk), address,
+			(void *) regs->ip, (void *) regs->sp, error_code);
+			print_vma_addr(" in ", regs->ip);
+			printk("\n");
+		}
+
+		tsk->thread.cr2 = address;
+		/* Kernel addresses are always protection faults */
+		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
+		tsk->thread.trap_no = 14;
+		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
+		return;
+	}
+
+	if (is_f00f_bug(regs, address))
+		return;
+
+	no_context(regs, error_code, address);
+}
+
+static noinline void bad_area_nosemaphore(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	__bad_area_nosemaphore(regs, error_code, address, SEGV_MAPERR);
+}
+
+static void __bad_area(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address,
+			int si_code)
+{
+	struct mm_struct *mm = current->mm;
+
+	/*
+	 * Something tried to access memory that isn't in our memory map..
+	 * Fix it, but check if it's kernel or user first..
+	 */
+	up_read(&mm->mmap_sem);
+
+	__bad_area_nosemaphore(regs, error_code, address, si_code);
+}
+
+static noinline void bad_area(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	__bad_area(regs, error_code, address, SEGV_MAPERR);
+}
+
+static noinline void bad_area_access_error(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	__bad_area(regs, error_code, address, SEGV_ACCERR);
+}
+
+/* TODO: fixup for "mm-invoke-oom-killer-from-page-fault.patch" */
+static void out_of_memory(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	/*
+	 * We ran out of memory, call the OOM killer, and return the userspace
+	 * (which will retry the fault, or kill us if we got oom-killed).
+	 */
+	up_read(&current->mm->mmap_sem);
+	pagefault_out_of_memory();
+}
+
+static void do_sigbus(struct pt_regs *regs,
+			unsigned long error_code, unsigned long address)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->mm;
+
+	up_read(&mm->mmap_sem);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (!(error_code & PF_USER))
+		no_context(regs, error_code, address);
+#ifdef CONFIG_X86_32
+	/* User space => ok to do another page fault */
+	if (is_prefetch(regs, error_code, address))
+		return;
+#endif
+	tsk->thread.cr2 = address;
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 14;
+	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
+}
+
+static noinline void mm_fault_error(struct pt_regs *regs,
+		unsigned long error_code, unsigned long address, unsigned int fault)
+{
+	if (fault & VM_FAULT_OOM)
+		out_of_memory(regs, error_code, address);
+	else if (fault & VM_FAULT_SIGBUS)
+		do_sigbus(regs, error_code, address);
+	else
+		BUG();
+}
+
 static int spurious_fault_check(unsigned long error_code, pte_t *pte)
 {
 	if ((error_code & PF_WRITE) && !pte_write(*pte))
@@ -448,8 +632,8 @@ static int spurious_fault_check(unsigned
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  */
-static int spurious_fault(unsigned long address,
-			  unsigned long error_code)
+static noinline int spurious_fault(unsigned long error_code,
+				unsigned long address)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -494,7 +678,7 @@ static int spurious_fault(unsigned long
  *
  * This assumes no large pages in there.
  */
-static int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 #ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
@@ -573,6 +757,25 @@ static int vmalloc_fault(unsigned long a
 
 int show_unhandled_signals = 1;
 
+static inline int access_error(unsigned long error_code, int write,
+				struct vm_area_struct *vma)
+{
+	if (write) {
+		/* write, present and write, not present */
+		if (unlikely(!(vma->vm_flags & VM_WRITE)))
+			return 1;
+	} else if (unlikely(error_code & PF_PROT)) {
+		/* read, present */
+		return 1;
+	} else {
+		/* read, not present */
+		if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -583,16 +786,12 @@ asmlinkage
 #endif
 void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	unsigned long address;
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	unsigned long address;
-	int write, si_code;
+	int write;
 	int fault;
-#ifdef CONFIG_X86_64
-	unsigned long flags;
-	int sig;
-#endif
 
 	tsk = current;
 	mm = tsk->mm;
@@ -601,9 +800,7 @@ void __kprobes do_page_fault(struct pt_r
 	/* get the address */
 	address = read_cr2();
 
-	si_code = SEGV_MAPERR;
-
-	if (notify_page_fault(regs))
+	if (unlikely(notify_page_fault(regs)))
 		return;
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
@@ -638,10 +835,10 @@ void __kprobes do_page_fault(struct pt_r
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
 		 */
-		goto bad_area_nosemaphore;
+		bad_area_nosemaphore(regs, error_code, address);
+		return;
 	}
 
-
 	/*
 	 * It's safe to allow irq's after cr2 has been saved and the
 	 * vmalloc fault has been handled.
@@ -657,15 +854,17 @@ void __kprobes do_page_fault(struct pt_r
 
 #ifdef CONFIG_X86_64
 	if (unlikely(error_code & PF_RSVD))
-		pgtable_bad(address, regs, error_code);
+		pgtable_bad(regs, error_code, address);
 #endif
 
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
 	 * atomic region then we must not take the fault.
 	 */
-	if (unlikely(in_atomic() || !mm))
-		goto bad_area_nosemaphore;
+	if (unlikely(in_atomic() || !mm)) {
+		bad_area_nosemaphore(regs, error_code, address);
+		return;
+	}
 
 	/*
 	 * When running in the kernel we expect faults to occur only to
@@ -683,20 +882,26 @@ void __kprobes do_page_fault(struct pt_r
 	 * source.  If this is invalid we can skip the address space check,
 	 * thus avoiding the deadlock.
 	 */
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
 		if ((error_code & PF_USER) == 0 &&
-		    !search_exception_tables(regs->ip))
-			goto bad_area_nosemaphore;
+		    !search_exception_tables(regs->ip)) {
+			bad_area_nosemaphore(regs, error_code, address);
+			return;
+		}
 		down_read(&mm->mmap_sem);
 	}
 
 	vma = find_vma(mm, address);
-	if (!vma)
-		goto bad_area;
-	if (vma->vm_start <= address)
+	if (unlikely(!vma)) {
+		bad_area(regs, error_code, address);
+		return;
+	}
+	if (likely(vma->vm_start <= address))
 		goto good_area;
-	if (!(vma->vm_flags & VM_GROWSDOWN))
-		goto bad_area;
+	if (unlikely(!(vma->vm_flags & VM_GROWSDOWN))) {
+		bad_area(regs, error_code, address);
+		return;
+	}
 	if (error_code & PF_USER) {
 		/*
 		 * Accessing the stack below %sp is always a bug.
@@ -704,31 +909,25 @@ void __kprobes do_page_fault(struct pt_r
 		 * and pusha to work.  ("enter $65535,$31" pushes
 		 * 32 pointers and then decrements %sp by 65535.)
 		 */
-		if (address + 65536 + 32 * sizeof(unsigned long) < regs->sp)
-			goto bad_area;
+		if (unlikely(address + 65536 + 32 * sizeof(unsigned long) < regs->sp)) {
+			bad_area(regs, error_code, address);
+			return;
+		}
 	}
-	if (expand_stack(vma, address))
-		goto bad_area;
-/*
- * Ok, we have a good vm_area for this memory access, so
- * we can handle it..
- */
+	if (unlikely(expand_stack(vma, address))) {
+		bad_area(regs, error_code, address);
+		return;
+	}
+
+	/*
+	 * Ok, we have a good vm_area for this memory access, so
+	 * we can handle it..
+	 */
 good_area:
-	si_code = SEGV_ACCERR;
-	write = 0;
-	switch (error_code & (PF_PROT|PF_WRITE)) {
-	default:	/* 3: write, present */
-		/* fall through */
-	case PF_WRITE:		/* write, not present */
-		if (!(vma->vm_flags & VM_WRITE))
-			goto bad_area;
-		write++;
-		break;
-	case PF_PROT:		/* read, present */
-		goto bad_area;
-	case 0:			/* read, not present */
-		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
-			goto bad_area;
+	write = error_code & PF_WRITE;
+	if (unlikely(access_error(error_code, write, vma))) {
+		bad_area_access_error(regs, error_code, address);
+		return;
 	}
 
 	/*
@@ -738,11 +937,8 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, write);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
-		if (fault & VM_FAULT_OOM)
-			goto out_of_memory;
-		else if (fault & VM_FAULT_SIGBUS)
-			goto do_sigbus;
-		BUG();
+		mm_fault_error(regs, error_code, address, fault);
+		return;
 	}
 	if (fault & VM_FAULT_MAJOR)
 		tsk->maj_flt++;
@@ -760,128 +956,6 @@ good_area:
 	}
 #endif
 	up_read(&mm->mmap_sem);
-	return;
-
-/*
- * Something tried to access memory that isn't in our memory map..
- * Fix it, but check if it's kernel or user first..
- */
-bad_area:
-	up_read(&mm->mmap_sem);
-
-bad_area_nosemaphore:
-	/* User mode accesses just cause a SIGSEGV */
-	if (error_code & PF_USER) {
-		/*
-		 * It's possible to have interrupts off here.
-		 */
-		local_irq_enable();
-
-		/*
-		 * Valid to do another page fault here because this one came
-		 * from user space.
-		 */
-		if (is_prefetch(regs, address, error_code))
-			return;
-
-		if (is_errata100(regs, address))
-			return;
-
-		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-		    printk_ratelimit()) {
-			printk(
-			"%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
-			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
-			tsk->comm, task_pid_nr(tsk), address,
-			(void *) regs->ip, (void *) regs->sp, error_code);
-			print_vma_addr(" in ", regs->ip);
-			printk("\n");
-		}
-
-		tsk->thread.cr2 = address;
-		/* Kernel addresses are always protection faults */
-		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
-		tsk->thread.trap_no = 14;
-		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
-		return;
-	}
-
-	if (is_f00f_bug(regs, address))
-		return;
-
-no_context:
-	/* Are we prepared to handle this kernel fault?  */
-	if (fixup_exception(regs))
-		return;
-
-	/*
-	 * X86_32
-	 * Valid to do another page fault here, because if this fault
-	 * had been triggered by is_prefetch fixup_exception would have
-	 * handled it.
-	 *
-	 * X86_64
-	 * Hall of shame of CPU/BIOS bugs.
-	 */
-	if (is_prefetch(regs, address, error_code))
-		return;
-
-	if (is_errata93(regs, address))
-		return;
-
-/*
- * Oops. The kernel tried to access some bad page. We'll have to
- * terminate things with extreme prejudice.
- */
-#ifdef CONFIG_X86_32
-	bust_spinlocks(1);
-#else
-	flags = oops_begin();
-#endif
-
-	show_fault_oops(regs, error_code, address);
-
-	tsk->thread.cr2 = address;
-	tsk->thread.trap_no = 14;
-	tsk->thread.error_code = error_code;
-
-#ifdef CONFIG_X86_32
-	die("Oops", regs, error_code);
-	bust_spinlocks(0);
-	do_exit(SIGKILL);
-#else
-	sig = SIGKILL;
-	if (__die("Oops", regs, error_code))
-		sig = 0;
-	/* Executive summary in case the body of the oops scrolled away */
-	printk(KERN_EMERG "CR2: %016lx\n", address);
-	oops_end(flags, regs, sig);
-#endif
-
-out_of_memory:
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed).
-	 */
-	up_read(&mm->mmap_sem);
-	pagefault_out_of_memory();
-	return;
-
-do_sigbus:
-	up_read(&mm->mmap_sem);
-
-	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & PF_USER))
-		goto no_context;
-#ifdef CONFIG_X86_32
-	/* User space => ok to do another page fault */
-	if (is_prefetch(regs, address, error_code))
-		return;
-#endif
-	tsk->thread.cr2 = address;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 14;
-	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 }
 
 DEFINE_SPINLOCK(pgd_lock);
