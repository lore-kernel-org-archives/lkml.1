Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZIKSsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZIKSsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZIKSsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZIKSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/21] HWPOISON: x86: Add VM_FAULT_HWPOISON handling to x86 page fault handler v2
Message-Id: <20090911184836.1E5F9B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add VM_FAULT_HWPOISON handling to the x86 page fault handler. This is 
very similar to VM_FAULT_OOM, the only difference is that a different
si_code is passed to user space and the new addr_lsb field is initialized.

v2: Make the printk more verbose/unique

Cc: x86@kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/fault.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/fault.c
===================================================================
--- linux.orig/arch/x86/mm/fault.c
+++ linux/arch/x86/mm/fault.c
@@ -167,6 +167,7 @@ force_sig_info_fault(int si_signo, int s
 	info.si_errno	= 0;
 	info.si_code	= si_code;
 	info.si_addr	= (void __user *)address;
+	info.si_addr_lsb = si_code == BUS_MCEERR_AR ? PAGE_SHIFT : 0;
 
 	force_sig_info(si_signo, &info, tsk);
 }
@@ -799,10 +800,12 @@ out_of_memory(struct pt_regs *regs, unsi
 }
 
 static void
-do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address)
+do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
+	  unsigned int fault)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
+	int code = BUS_ADRERR;
 
 	up_read(&mm->mmap_sem);
 
@@ -818,7 +821,15 @@ do_sigbus(struct pt_regs *regs, unsigned
 	tsk->thread.error_code	= error_code;
 	tsk->thread.trap_no	= 14;
 
-	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
+#ifdef CONFIG_MEMORY_FAILURE
+	if (fault & VM_FAULT_HWPOISON) {
+		printk(KERN_ERR
+	"MCE: Killing %s:%d due to hardware memory corruption fault at %lx\n",
+			tsk->comm, tsk->pid, address);
+		code = BUS_MCEERR_AR;
+	}
+#endif
+	force_sig_info_fault(SIGBUS, code, address, tsk);
 }
 
 static noinline void
@@ -828,8 +839,8 @@ mm_fault_error(struct pt_regs *regs, uns
 	if (fault & VM_FAULT_OOM) {
 		out_of_memory(regs, error_code, address);
 	} else {
-		if (fault & VM_FAULT_SIGBUS)
-			do_sigbus(regs, error_code, address);
+		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON))
+			do_sigbus(regs, error_code, address, fault);
 		else
 			BUG();
 	}
