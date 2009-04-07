Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbZDGPW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbZDGPW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbZDGPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:10:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41298 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339AbZDGPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:10:12 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: [PATCH] [9/16] POISON: x86: Add VM_FAULT_POISON handling to x86 page fault handler
Message-Id: <20090407151006.537AC1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:10:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add VM_FAULT_POISON handling to the x86 page fault handler. This is 
very similar to VM_FAULT_OOM, the only difference is that a different
si_code is passed to user space and the new addr_lsb field is initialized.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/fault.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/fault.c
===================================================================
--- linux.orig/arch/x86/mm/fault.c	2009-04-07 16:39:23.000000000 +0200
+++ linux/arch/x86/mm/fault.c	2009-04-07 16:39:39.000000000 +0200
@@ -189,6 +189,7 @@
 	info.si_errno	= 0;
 	info.si_code	= si_code;
 	info.si_addr	= (void __user *)address;
+	info.si_addr_lsb = si_code == BUS_MCEERR_AR ? PAGE_SHIFT : 0;
 
 	force_sig_info(si_signo, &info, tsk);
 }
@@ -827,10 +828,12 @@
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
 
@@ -846,7 +849,14 @@
 	tsk->thread.error_code	= error_code;
 	tsk->thread.trap_no	= 14;
 
-	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
+#ifdef CONFIG_MEMORY_FAILURE
+	if (fault & VM_FAULT_POISON) {
+		printk(KERN_ERR "MCE: Killing %s:%d due to hardware memory corruption\n",
+			tsk->comm, tsk->pid);
+		code = BUS_MCEERR_AR;
+	}
+#endif
+	force_sig_info_fault(SIGBUS, code, address, tsk);
 }
 
 static noinline void
@@ -856,8 +866,8 @@
 	if (fault & VM_FAULT_OOM) {
 		out_of_memory(regs, error_code, address);
 	} else {
-		if (fault & VM_FAULT_SIGBUS)
-			do_sigbus(regs, error_code, address);
+		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_POISON))
+			do_sigbus(regs, error_code, address, fault);
 		else
 			BUG();
 	}
