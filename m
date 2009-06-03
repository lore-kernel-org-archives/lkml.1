Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZFCSsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZFCSsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZFCSrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:47:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbZFCSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:47:00 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090603846.816684333@firstfloor.org>
In-Reply-To: <20090603846.816684333@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [7/16] HWPOISON: x86: Add VM_FAULT_HWPOISON handling to x86 page fault handler v2
Message-Id: <20090603184640.4FD751D0290@basil.firstfloor.org>
Date: Wed,  3 Jun 2009 20:46:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add VM_FAULT_HWPOISON handling to the x86 page fault handler. This is 
very similar to VM_FAULT_OOM, the only difference is that a different
si_code is passed to user space and the new addr_lsb field is initialized.

v2: Make the printk more verbose/unique

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/fault.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/fault.c
===================================================================
--- linux.orig/arch/x86/mm/fault.c	2009-06-03 19:36:21.000000000 +0200
+++ linux/arch/x86/mm/fault.c	2009-06-03 19:36:23.000000000 +0200
@@ -166,6 +166,7 @@
 	info.si_errno	= 0;
 	info.si_code	= si_code;
 	info.si_addr	= (void __user *)address;
+	info.si_addr_lsb = si_code == BUS_MCEERR_AR ? PAGE_SHIFT : 0;
 
 	force_sig_info(si_signo, &info, tsk);
 }
@@ -797,10 +798,12 @@
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
 
@@ -816,7 +819,15 @@
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
@@ -826,8 +837,8 @@
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
