Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYJOQdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYJOQdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJOQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:32:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYJOQcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:32:54 -0400
Date: Wed, 15 Oct 2008 18:32:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20081015163244.GA25660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86/mm: unify init task OOM handling

Linus Torvalds (1):
      x86/mm: do not trigger a kernel warning if user-space disables interrupts and generates a page fault

Suresh Siddha (1):
      x86: fix compat-vdso


 arch/x86/mm/fault.c       |   45 +++++++++++++++++----------------------------
 include/asm-x86/pgtable.h |    7 ++++++-
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a742d75..8bc5956 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -645,24 +645,23 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	}
 
 
-#ifdef CONFIG_X86_32
-	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
-	   fault has been handled. */
-	if (regs->flags & (X86_EFLAGS_IF | X86_VM_MASK))
-		local_irq_enable();
-
 	/*
-	 * If we're in an interrupt, have no user context or are running in an
-	 * atomic region then we must not take the fault.
+	 * It's safe to allow irq's after cr2 has been saved and the
+	 * vmalloc fault has been handled.
+	 *
+	 * User-mode registers count as a user access even for any
+	 * potential system fault or CPU buglet.
 	 */
-	if (in_atomic() || !mm)
-		goto bad_area_nosemaphore;
-#else /* CONFIG_X86_64 */
-	if (likely(regs->flags & X86_EFLAGS_IF))
+	if (user_mode_vm(regs)) {
+		local_irq_enable();
+		error_code |= PF_USER;
+	} else if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 
+#ifdef CONFIG_X86_64
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(address, regs, error_code);
+#endif
 
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
@@ -671,15 +670,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(in_atomic() || !mm))
 		goto bad_area_nosemaphore;
 
-	/*
-	 * User-mode registers count as a user access even for any
-	 * potential system fault or CPU buglet.
-	 */
-	if (user_mode_vm(regs))
-		error_code |= PF_USER;
 again:
-#endif
-	/* When running in the kernel we expect faults to occur only to
+	/*
+	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
 	 * erroneous fault occurring in a code path which already holds mmap_sem
@@ -742,9 +735,6 @@ good_area:
 			goto bad_area;
 	}
 
-#ifdef CONFIG_X86_32
-survive:
-#endif
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -879,12 +869,11 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	if (is_global_init(tsk)) {
 		yield();
-#ifdef CONFIG_X86_32
-		down_read(&mm->mmap_sem);
-		goto survive;
-#else
+		/*
+		 * Re-lookup the vma - in theory the vma tree might
+		 * have changed:
+		 */
 		goto again;
-#endif
 	}
 
 	printk("VM: killing process %s\n", tsk->comm);
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index ed93245..e9f10af 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -138,8 +138,13 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
+/*
+ * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
+ * bits are combined, this will alow user to access the high address mapped
+ * VDSO in the presence of CONFIG_COMPAT_VDSO
+ */
 #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
-#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
+#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 
