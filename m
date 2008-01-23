Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYAWAHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYAWAHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYAWAG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:06:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:46261 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbYAWAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HUbJnowPHXluY/KigT5Offo3e7cfOtVLYdVZ9ohuRlQheX7B/OgcKhJzi6jq9cYTOPE2C5kCZuXGsDKCpCIvf15XCYcO/6lnw1VLxKrV/4z2a0G7+Z2moOUCO8agxmELsO+BBxpbcqBd0t+j4IQKJPh5elOWTGRnMzgquvg1kVI=
Subject: [PATCH 2/3] x86: Unify fault_32|64.c with ifdefs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 16:07:05 -0800
Message-Id: <1201046825.16972.93.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elimination of these ifdefs can be done in a unified file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |  100 +++++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/fault_64.c |   93 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 177 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 2d8a577..be0921c 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -48,7 +48,11 @@ static inline int notify_page_fault(struct pt_regs *regs)
 	int ret = 0;
 
 	/* kprobe_running() needs smp_processor_id() */
+#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
+#else
+	if (!user_mode(regs)) {
+#endif
 		preempt_disable();
 		if (kprobe_running() && kprobe_fault_handler(regs, 14))
 			ret = 1;
@@ -429,11 +433,15 @@ static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 #endif
 
 /*
+ * X86_32
  * Handle a fault on the vmalloc or module mapping area
  *
+ * X86_64
+ * Handle a fault on the vmalloc area
+ *
  * This assumes no large pages in there.
  */
-static inline int vmalloc_fault(unsigned long address)
+static int vmalloc_fault(unsigned long address)
 {
 #ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
@@ -508,6 +516,9 @@ int show_unhandled_signals = 1;
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
 void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct task_struct *tsk;
@@ -516,6 +527,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long address;
 	int write, si_code;
 	int fault;
+#ifdef CONFIG_X86_64
+	unsigned long flags;
+#endif
 
 	/*
 	 * We can fault from pretty much anywhere, with unknown IRQ state.
@@ -547,6 +561,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * (error_code & 4) == 0, and that the fault was not a
 	 * protection error (error_code & 9) == 0.
 	 */
+#ifdef CONFIG_X86_32
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
 		    vmalloc_fault(address) >= 0)
@@ -569,7 +584,45 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 	if (in_atomic() || !mm)
 		goto bad_area_nosemaphore;
+#else /* CONFIG_X86_64 */
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
+		/*
+		 * Don't take the mm semaphore here. If we fixup a prefetch
+		 * fault we could otherwise deadlock.
+		 */
+		goto bad_area_nosemaphore;
+	}
+	if (likely(regs->flags & X86_EFLAGS_IF))
+		local_irq_enable();
+
+	if (unlikely(error_code & PF_RSVD))
+		pgtable_bad(address, regs, error_code);
+
+	/*
+	 * If we're in an interrupt, have no user context or are running in an
+	 * atomic region then we must not take the fault.
+	 */
+	if (unlikely(in_atomic() || !mm))
+		goto bad_area_nosemaphore;
 
+	/*
+	 * User-mode registers count as a user access even for any
+	 * potential system fault or CPU buglet.
+	 */
+	if (user_mode_vm(regs))
+		error_code |= PF_USER;
+again:
+#endif
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -595,7 +648,11 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
+#ifdef CONFIG_X86_32
 	if (vma->vm_start <= address)
+#else
+	if (likely(vma->vm_start <= address))
+#endif
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
@@ -633,7 +690,9 @@ good_area:
 			goto bad_area;
 	}
 
- survive:
+#ifdef CONFIG_X86_32
+survive:
+#endif
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -704,6 +763,7 @@ bad_area_nosemaphore:
 			print_vma_addr(" in ", regs->ip);
 			printk("\n");
 		}
+
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
@@ -721,9 +781,13 @@ no_context:
 		return;
 
 	/*
+	 * X86_32
 	 * Valid to do another page fault here, because if this fault
 	 * had been triggered by is_prefetch fixup_exception would have
 	 * handled it.
+	 *
+	 * X86_64
+	 * Hall of shame of CPU/BIOS bugs.
 	 */
 	if (is_prefetch(regs, address, error_code))
 		return;
@@ -735,7 +799,7 @@ no_context:
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
  */
-
+#ifdef CONFIG_X86_32
 	bust_spinlocks(1);
 
 	show_fault_oops(regs, error_code, address);
@@ -746,6 +810,20 @@ no_context:
 	die("Oops", regs, error_code);
 	bust_spinlocks(0);
 	do_exit(SIGKILL);
+#else /* CONFIG_X86_64 */
+	flags = oops_begin();
+
+	show_fault_oops(regs, error_code, address);
+
+	tsk->thread.cr2 = address;
+	tsk->thread.trap_no = 14;
+	tsk->thread.error_code = error_code;
+	if (__die("Oops", regs, error_code))
+		regs = NULL;
+	/* Executive summary in case the body of the oops scrolled away */
+	printk(KERN_EMERG "CR2: %016lx\n", address);
+	oops_end(flags, regs, SIGKILL);
+#endif
 
 /*
  * We ran out of memory, or some other thing happened to us that made
@@ -753,11 +831,18 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
+#ifdef CONFIG_X86_32
 	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
+#else
+	if (is_global_init(current)) {
+		yield();
+		goto again;
+	}
+#endif
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & PF_USER)
 		do_group_exit(SIGKILL);
@@ -769,17 +854,22 @@ do_sigbus:
 	/* Kernel mode? Handle exceptions or die */
 	if (!(error_code & PF_USER))
 		goto no_context;
-
+#ifdef CONFIG_X86_32
 	/* User space => ok to do another page fault */
 	if (is_prefetch(regs, address, error_code))
 		return;
-
+#endif
 	tsk->thread.cr2 = address;
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = 14;
 	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 }
 
+#ifdef CONFIG_X86_64
+DEFINE_SPINLOCK(pgd_lock);
+LIST_HEAD(pgd_list);
+#endif
+
 void vmalloc_sync_all(void)
 {
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index bea77b2..e0231c6 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -51,7 +51,11 @@ static inline int notify_page_fault(struct pt_regs *regs)
 	int ret = 0;
 
 	/* kprobe_running() needs smp_processor_id() */
+#ifdef CONFIG_X86_32
+	if (!user_mode_vm(regs)) {
+#else
 	if (!user_mode(regs)) {
+#endif
 		preempt_disable();
 		if (kprobe_running() && kprobe_fault_handler(regs, 14))
 			ret = 1;
@@ -432,6 +436,10 @@ static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 #endif
 
 /*
+ * X86_32
+ * Handle a fault on the vmalloc or module mapping area
+ *
+ * X86_64
  * Handle a fault on the vmalloc area
  *
  * This assumes no large pages in there.
@@ -511,16 +519,20 @@ int show_unhandled_signals = 1;
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
-					unsigned long error_code)
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
+void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned long address;
-	int write, fault;
+	int write, si_code;
+	int fault;
+#ifdef CONFIG_X86_64
 	unsigned long flags;
-	int si_code;
+#endif
 
 	/*
 	 * We can fault from pretty much anywhere, with unknown IRQ state.
@@ -552,6 +564,30 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	 * (error_code & 4) == 0, and that the fault was not a
 	 * protection error (error_code & 9) == 0.
 	 */
+#ifdef CONFIG_X86_32
+	if (unlikely(address >= TASK_SIZE)) {
+		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+		    vmalloc_fault(address) >= 0)
+			return;
+		/*
+		 * Don't take the mm semaphore here. If we fixup a prefetch
+		 * fault we could otherwise deadlock.
+		 */
+		goto bad_area_nosemaphore;
+	}
+
+	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
+	   fault has been handled. */
+	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
+		local_irq_enable();
+
+	/*
+	 * If we're in an interrupt, have no user context or are running in an
+	 * atomic region then we must not take the fault.
+	 */
+	if (in_atomic() || !mm)
+		goto bad_area_nosemaphore;
+#else /* CONFIG_X86_64 */
 	if (unlikely(address >= TASK_SIZE64)) {
 		/*
 		 * Don't check for the module range here: its PML4
@@ -569,7 +605,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		 */
 		goto bad_area_nosemaphore;
 	}
-
 	if (likely(regs->flags & X86_EFLAGS_IF))
 		local_irq_enable();
 
@@ -589,8 +624,8 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	 */
 	if (user_mode_vm(regs))
 		error_code |= PF_USER;
-
- again:
+again:
+#endif
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -616,7 +651,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
+#ifdef CONFIG_X86_32
+	if (vma->vm_start <= address)
+#else
 	if (likely(vma->vm_start <= address))
+#endif
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
@@ -654,6 +693,9 @@ good_area:
 			goto bad_area;
 	}
 
+#ifdef CONFIG_X86_32
+survive:
+#endif
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -729,7 +771,6 @@ bad_area_nosemaphore:
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
 		tsk->thread.trap_no = 14;
-
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
 		return;
 	}
@@ -743,9 +784,14 @@ no_context:
 		return;
 
 	/*
+	 * X86_32
+	 * Valid to do another page fault here, because if this fault
+	 * had been triggered by is_prefetch fixup_exception would have
+	 * handled it.
+	 *
+	 * X86_64
 	 * Hall of shame of CPU/BIOS bugs.
 	 */
-
 	if (is_prefetch(regs, address, error_code))
 		return;
 
@@ -756,7 +802,18 @@ no_context:
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
  */
+#ifdef CONFIG_X86_32
+	bust_spinlocks(1);
+
+	show_fault_oops(regs, error_code, address);
 
+	tsk->thread.cr2 = address;
+	tsk->thread.trap_no = 14;
+	tsk->thread.error_code = error_code;
+	die("Oops", regs, error_code);
+	bust_spinlocks(0);
+	do_exit(SIGKILL);
+#else /* CONFIG_X86_64 */
 	flags = oops_begin();
 
 	show_fault_oops(regs, error_code, address);
@@ -769,6 +826,7 @@ no_context:
 	/* Executive summary in case the body of the oops scrolled away */
 	printk(KERN_EMERG "CR2: %016lx\n", address);
 	oops_end(flags, regs, SIGKILL);
+#endif
 
 /*
  * We ran out of memory, or some other thing happened to us that made
@@ -776,10 +834,18 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
+#ifdef CONFIG_X86_32
+	if (is_global_init(tsk)) {
+		yield();
+		down_read(&mm->mmap_sem);
+		goto survive;
+	}
+#else
 	if (is_global_init(current)) {
 		yield();
 		goto again;
 	}
+#endif
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & PF_USER)
 		do_group_exit(SIGKILL);
@@ -791,16 +857,21 @@ do_sigbus:
 	/* Kernel mode? Handle exceptions or die */
 	if (!(error_code & PF_USER))
 		goto no_context;
-
+#ifdef CONFIG_X86_32
+	/* User space => ok to do another page fault */
+	if (is_prefetch(regs, address, error_code))
+		return;
+#endif
 	tsk->thread.cr2 = address;
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = 14;
 	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
-	return;
 }
 
+#ifdef CONFIG_X86_64
 DEFINE_SPINLOCK(pgd_lock);
 LIST_HEAD(pgd_list);
+#endif
 
 void vmalloc_sync_all(void)
 {
-- 
1.5.4.rc3.1118.gf6754c


