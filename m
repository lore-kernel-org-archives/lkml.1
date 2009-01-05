Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZAEBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZAEBQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZAEBQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:16:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:42116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZAEBQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:16:34 -0500
Date: Mon, 5 Jan 2009 02:16:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090105011630.GI32239@wotan.suse.de>
References: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu> <20090103213856.GA24138@elte.hu> <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain> <20090103223723.GA17047@elte.hu> <20090105011416.GG32239@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105011416.GG32239@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really cc linux-arch this time

On Mon, Jan 05, 2009 at 02:14:16AM +0100, Nick Piggin wrote:
> On Sat, Jan 03, 2009 at 11:37:23PM +0100, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > What happened to Nick's cleanup patch to do_page_fault (a month or two 
> > > ago? I complained about some of the issues in his first version and 
> > > asked for some further cleanups, but I think that whole discussion ended 
> > > with him saying "I am going to add those changes that you suggested (in 
> > > fact, I already have)".
> > > 
> > > And then I didn't see anything further. Maybe I just missed the end 
> > > result. Or maybe we have it in some -mm branch or something?
> > 
> > they would have been in tip/x86/mm and would be upstream now had Nick 
> > re-sent a v2 series but that never happened. I think they might have 
> > fallen victim to a serious attention deficit caused by the SLQB patch ;-)
> 
> Well, I already added Linus's suggestions but didn't submit it because
> there was a bit of work going on in that file as far as I could see, both
> in the x86 tree and in -mm:
> 
> (http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/broken-out/mm-invoke-oom-killer-from-page-fault.patch)
> 
> It isn't a big deal to resolve either way, but I don't want to make Andrew's
> life harder.
> 
> [Yes OK now I'm the guilty one of pushing in an x86 patch not via the
> x86 tree ;) This one is easy to break in pieces, but I didn't want
> to create a dependency between the trees]
> 
> I didn't really consider it to be urgent, so I was waiting for that patch
> to go in, but I was still hoping to get this into 2.6.29... This is what
> it looks like now with your suggestions, and just merged it to your current
> tree (untested).
> 
> I'll cc the linux-arch list here too, because it might be nice to keep these
> things as structurally similar as possible (and they'll all want to look at
> the -mm patch above, although I'll probably end up having to write the
> patches!).

---
Optimise x86's do_page_fault (C entry point for the page fault path).

gcc isn't _all_ that smart about spilling registers to stack or reusing
stack slots, even with branch annotations. do_page_fault contained a lot
of functionality, so split unlikely paths into their own functions, and
mark them as noinline just to be sure. I consider this actually to be
somewhat of a cleanup too: the main function now contains about half
the number of lines.

Also, ensure the order of arguments to functions is always the same: regs,
addr, error_code. This can reduce code size a tiny bit, and just looks neater
too.

Add a couple of branch annotations.

One real behavioural difference this makes is that the OOM-init-task case
will no longer loop around the page fault handler, but will return to
userspace and presumably retry the fault. Effectively the same macro-behaviour,
but it is a notable difference. Such change in behaviour should disappear after
the "call oom killer from page fault" patch.

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
workload. Importantly, do_page_fault is less than 1/3rd it's original size.
Existing gotos and branch hints did move a lot of the infrequently used text
out of the fastpath, but that's even further improved after this patch.

---
 arch/x86/mm/fault.c |  458 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 265 insertions(+), 193 deletions(-)

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
@@ -429,6 +429,200 @@ static noinline void pgtable_bad(unsigne
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
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->mm;
+	/*
+	 * We ran out of memory, or some other thing happened to us that made
+	 * us unable to handle the page fault gracefully.
+	 */
+	up_read(&mm->mmap_sem);
+	if (is_global_init(tsk)) {
+		yield();
+		return;
+	}
+
+	printk("VM: killing process %s\n", tsk->comm);
+	if (error_code & PF_USER)
+		do_group_exit(SIGKILL);
+	no_context(regs, error_code, address);
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
@@ -448,8 +642,8 @@ static int spurious_fault_check(unsigned
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
@@ -494,7 +688,7 @@ static int spurious_fault(unsigned long
  *
  * This assumes no large pages in there.
  */
-static int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 #ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
@@ -573,6 +767,25 @@ static int vmalloc_fault(unsigned long a
 
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
@@ -583,16 +796,12 @@ asmlinkage
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
@@ -601,9 +810,7 @@ void __kprobes do_page_fault(struct pt_r
 	/* get the address */
 	address = read_cr2();
 
-	si_code = SEGV_MAPERR;
-
-	if (notify_page_fault(regs))
+	if (unlikely(notify_page_fault(regs)))
 		return;
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
@@ -638,10 +845,10 @@ void __kprobes do_page_fault(struct pt_r
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
@@ -657,17 +864,18 @@ void __kprobes do_page_fault(struct pt_r
 
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
 
-again:
 	/*
 	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -684,20 +892,26 @@ again:
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
@@ -705,31 +919,25 @@ again:
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
@@ -739,11 +947,8 @@ good_area:
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
@@ -761,139 +966,6 @@ good_area:
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
-/*
- * We ran out of memory, or some other thing happened to us that made
- * us unable to handle the page fault gracefully.
- */
-out_of_memory:
-	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		/*
-		 * Re-lookup the vma - in theory the vma tree might
-		 * have changed:
-		 */
-		goto again;
-	}
-
-	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & PF_USER)
-		do_group_exit(SIGKILL);
-	goto no_context;
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
