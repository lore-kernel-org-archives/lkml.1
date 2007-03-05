Return-Path: <linux-kernel-owner+w=401wt.eu-S1750808AbXCEWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808AbXCEWmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXCEWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:42:36 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:26174 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXCEWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:42:00 -0500
Date: Mon, 5 Mar 2007 23:41:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: geraldsc@de.ibm.com
Subject: [S390] Fixed handling of access register mode faults.
Message-ID: <20070305224159.GH22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <geraldsc@de.ibm.com>
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] Fixed handling of access register mode faults.

Replaced check_user_space() + __check_access_register with the new
check_space(). The old functions made wrong assumptions about kernel
and user space when the kernel and user address spaces are switched
(kernel in home space, user in primary/secondary space).
Secondly the user process can switch to the accress register mode if
it is running in primary or secondary mode. In addition it can load
an arbitrary value to the access registers. If any other value than
0 for primary space or 1 for secondary space is loaded and memory
is accessed using the base register related to the access register,
the program should be terminated with a SIGSEGV. To achieve that the
DUALD pointer in the DUCT and the PSALD pointer in the PASTE need 
to point to an array of 8 invalid access-list entries to get a
ALEN-translation exception if an invalid alet is used.

Signed-off-by: Gerald Schaefer <geraldsc@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/head31.S |   11 +++-
 arch/s390/kernel/head64.S |   11 +++-
 arch/s390/mm/fault.c      |  105 ++++++++++++++++++++--------------------------
 3 files changed, 63 insertions(+), 64 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/head31.S linux-2.6-patched/arch/s390/kernel/head31.S
--- linux-2.6/arch/s390/kernel/head31.S	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head31.S	2007-03-05 22:51:54.000000000 +0100
@@ -121,7 +121,7 @@ startup_continue:
 	.long	.Lduct			# cr2: dispatchable unit control table
 	.long	0			# cr3: instruction authorization
 	.long	0			# cr4: instruction authorization
-	.long	0xffffffff		# cr5: primary-aste origin
+	.long	.Lduct			# cr5: primary-aste origin
 	.long	0			# cr6:	I/O interrupts
 	.long	0			# cr7:	secondary space segment table
 	.long	0			# cr8:	access registers translation
@@ -132,8 +132,6 @@ startup_continue:
 	.long	0			# cr13: home space segment table
 	.long	0xc0000000		# cr14: machine check handling off
 	.long	0			# cr15: linkage stack operations
-.Lduct:	.long	0,0,0,0,0,0,0,0
-	.long	0,0,0,0,0,0,0,0
 .Lpcfpu:.long	0x00080000,0x80000000 + .Lchkfpu
 .Lpccsp:.long	0x00080000,0x80000000 + .Lchkcsp
 .Lpcmvpg:.long	0x00080000,0x80000000 + .Lchkmvpg
@@ -147,6 +145,13 @@ startup_continue:
 .Linittu:   .long init_thread_union
 .Lstartup_init:
 	    .long startup_init
+	.align	64
+.Lduct:	.long	0,0,0,0,.Lduald,0,0,0
+	.long	0,0,0,0,0,0,0,0
+	.align	128
+.Lduald:.rept	8
+	.long	0x80000000,0,0,0	# invalid access-list entries
+	.endr
 
 	.org	0x12000
 	.globl	_ehead
diff -urpN linux-2.6/arch/s390/kernel/head64.S linux-2.6-patched/arch/s390/kernel/head64.S
--- linux-2.6/arch/s390/kernel/head64.S	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head64.S	2007-03-05 22:51:54.000000000 +0100
@@ -134,7 +134,7 @@ startup_continue:
 	.quad	.Lduct			# cr2: dispatchable unit control table
 	.quad	0			# cr3: instruction authorization
 	.quad	0			# cr4: instruction authorization
-	.quad	0xffffffffffffffff	# cr5: primary-aste origin
+	.quad	.Lduct			# cr5: primary-aste origin
 	.quad	0			# cr6:	I/O interrupts
 	.quad	0			# cr7:	secondary space segment table
 	.quad	0			# cr8:	access registers translation
@@ -145,14 +145,19 @@ startup_continue:
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
 	.quad	0			# cr15: linkage stack operations
-.Lduct: .long	0,0,0,0,0,0,0,0
-	.long	0,0,0,0,0,0,0,0
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
 .Lnop:	.long	0x07000700
 .Lparmaddr:
 	.quad	PARMAREA
+	.align	64
+.Lduct: .long	0,0,0,0,.Lduald,0,0,0
+	.long	0,0,0,0,0,0,0,0
+	.align	128
+.Lduald:.rept	8
+	.long	0x80000000,0,0,0	# invalid access-list entries
+	.endr
 
 	.org	0x12000
 	.globl	_ehead
diff -urpN linux-2.6/arch/s390/mm/fault.c linux-2.6-patched/arch/s390/mm/fault.c
--- linux-2.6/arch/s390/mm/fault.c	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/fault.c	2007-03-05 22:51:54.000000000 +0100
@@ -108,53 +108,40 @@ void bust_spinlocks(int yes)
 }
 
 /*
- * Check which address space is addressed by the access
- * register in S390_lowcore.exc_access_id.
- * Returns 1 for user space and 0 for kernel space.
+ * Returns the address space associated with the fault.
+ * Returns 0 for kernel space, 1 for user space and
+ * 2 for code execution in user space with noexec=on.
  */
-static int __check_access_register(struct pt_regs *regs, int error_code)
-{
-	int areg = S390_lowcore.exc_access_id;
-
-	if (areg == 0)
-		/* Access via access register 0 -> kernel address */
-		return 0;
-	save_access_regs(current->thread.acrs);
-	if (regs && areg < NUM_ACRS && current->thread.acrs[areg] <= 1)
-		/*
-		 * access register contains 0 -> kernel address,
-		 * access register contains 1 -> user space address
-		 */
-		return current->thread.acrs[areg];
-
-	/* Something unhealthy was done with the access registers... */
-	die("page fault via unknown access register", regs, error_code);
-	do_exit(SIGKILL);
-	return 0;
-}
-
-/*
- * Check which address space the address belongs to.
- * May return 1 or 2 for user space and 0 for kernel space.
- * Returns 2 for user space in primary addressing mode with
- * CONFIG_S390_EXEC_PROTECT on and kernel parameter noexec=on.
- */
-static inline int check_user_space(struct pt_regs *regs, int error_code)
+static inline int check_space(struct task_struct *tsk)
 {
 	/*
-	 * The lowest two bits of S390_lowcore.trans_exc_code indicate
-	 * which paging table was used:
-	 *   0: Primary Segment Table Descriptor
-	 *   1: STD determined via access register
-	 *   2: Secondary Segment Table Descriptor
-	 *   3: Home Segment Table Descriptor
+	 * The lowest two bits of S390_lowcore.trans_exc_code
+	 * indicate which paging table was used.
 	 */
-	int descriptor = S390_lowcore.trans_exc_code & 3;
-	if (unlikely(descriptor == 1))
-		return __check_access_register(regs, error_code);
-	if (descriptor == 2)
-		return current->thread.mm_segment.ar4;
-	return ((descriptor != 0) ^ (switch_amode)) << s390_noexec;
+	int desc = S390_lowcore.trans_exc_code & 3;
+
+	if (desc == 3)	/* Home Segment Table Descriptor */
+		return switch_amode == 0;
+	if (desc == 2)	/* Secondary Segment Table Descriptor */
+		return tsk->thread.mm_segment.ar4;
+#ifdef CONFIG_S390_SWITCH_AMODE
+	if (unlikely(desc == 1)) { /* STD determined via access register */
+		/* %a0 always indicates primary space. */
+		if (S390_lowcore.exc_access_id != 0) {
+			save_access_regs(tsk->thread.acrs);
+			/*
+			 * An alet of 0 indicates primary space.
+			 * An alet of 1 indicates secondary space.
+			 * Any other alet values generate an
+			 * alen-translation exception.
+			 */
+			if (tsk->thread.acrs[S390_lowcore.exc_access_id])
+				return tsk->thread.mm_segment.ar4;
+		}
+	}
+#endif
+	/* Primary Segment Table Descriptor */
+	return switch_amode << s390_noexec;
 }
 
 /*
@@ -265,16 +252,16 @@ out_fault:
  *   11       Page translation     ->  Not present       (nullification)
  *   3b       Region third trans.  ->  Not present       (nullification)
  */
-static inline void __kprobes
+static inline void
 do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
 {
         struct task_struct *tsk;
         struct mm_struct *mm;
         struct vm_area_struct * vma;
         unsigned long address;
-	int user_address;
 	const struct exception_table_entry *fixup;
-	int si_code = SEGV_MAPERR;
+	int si_code;
+	int space;
 
         tsk = current;
         mm = tsk->mm;
@@ -294,7 +281,7 @@ do_exception(struct pt_regs *regs, unsig
 		   NULL pointer write access in kernel mode.  */
  		if (!(regs->psw.mask & PSW_MASK_PSTATE)) {
 			address = 0;
-			user_address = 0;
+			space = 0;
 			goto no_context;
 		}
 
@@ -309,15 +296,15 @@ do_exception(struct pt_regs *regs, unsig
          * the address 
          */
         address = S390_lowcore.trans_exc_code & __FAIL_ADDR_MASK;
-	user_address = check_user_space(regs, error_code);
+	space = check_space(tsk);
 
 	/*
 	 * Verify that the fault happened in user space, that
 	 * we are not in an interrupt and that there is a 
 	 * user context.
 	 */
-        if (user_address == 0 || in_atomic() || !mm)
-                goto no_context;
+	if (unlikely(space == 0 || in_atomic() || !mm))
+		goto no_context;
 
 	/*
 	 * When we get here, the fault happened in the current
@@ -328,12 +315,13 @@ do_exception(struct pt_regs *regs, unsig
 
         down_read(&mm->mmap_sem);
 
-        vma = find_vma(mm, address);
-        if (!vma)
-                goto bad_area;
+	si_code = SEGV_MAPERR;
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
 
 #ifdef CONFIG_S390_EXEC_PROTECT
-	if (unlikely((user_address == 2) && !(vma->vm_flags & VM_EXEC)))
+	if (unlikely((space == 2) && !(vma->vm_flags & VM_EXEC)))
 		if (!signal_return(mm, regs, address, error_code))
 			/*
 			 * signal_return() has done an up_read(&mm->mmap_sem)
@@ -389,7 +377,7 @@ survive:
 	 * The instruction that caused the program check will
 	 * be repeated. Don't signal single step via SIGTRAP.
 	 */
-	clear_tsk_thread_flag(current, TIF_SINGLE_STEP);
+	clear_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
         return;
 
 /*
@@ -419,7 +407,7 @@ no_context:
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
  */
-        if (user_address == 0)
+	if (space == 0)
                 printk(KERN_ALERT "Unable to handle kernel pointer dereference"
         	       " at virtual kernel address %p\n", (void *)address);
         else
@@ -462,13 +450,14 @@ do_sigbus:
 		goto no_context;
 }
 
-void do_protection_exception(struct pt_regs *regs, unsigned long error_code)
+void __kprobes do_protection_exception(struct pt_regs *regs,
+				       unsigned long error_code)
 {
 	regs->psw.addr -= (error_code >> 16);
 	do_exception(regs, 4, 1);
 }
 
-void do_dat_exception(struct pt_regs *regs, unsigned long error_code)
+void __kprobes do_dat_exception(struct pt_regs *regs, unsigned long error_code)
 {
 	do_exception(regs, error_code & 0xff, 0);
 }
