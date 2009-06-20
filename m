Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbZFTDWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbZFTDWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 23:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZFTDUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 23:20:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:42168 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZFTDUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 23:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,257,1243839600"; 
   d="scan'208";a="156644156"
Message-Id: <20090620031625.449041353@intel.com>
References: <20090620031608.624240019@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 20 Jun 2009 11:16:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan.kim@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 06/15] HWPOISON: x86: Add VM_FAULT_HWPOISON handling to x86 page fault handler v2
Content-Disposition: inline; filename=x86-vmfault-poison
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add VM_FAULT_HWPOISON handling to the x86 page fault handler. This is 
very similar to VM_FAULT_OOM, the only difference is that a different
si_code is passed to user space and the new addr_lsb field is initialized.

v2: Make the printk more verbose/unique

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/fault.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- sound-2.6.orig/arch/x86/mm/fault.c
+++ sound-2.6/arch/x86/mm/fault.c
@@ -167,6 +167,7 @@ force_sig_info_fault(int si_signo, int s
 	info.si_errno	= 0;
 	info.si_code	= si_code;
 	info.si_addr	= (void __user *)address;
+	info.si_addr_lsb = si_code == BUS_MCEERR_AR ? PAGE_SHIFT : 0;
 
 	force_sig_info(si_signo, &info, tsk);
 }
@@ -798,10 +799,12 @@ out_of_memory(struct pt_regs *regs, unsi
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
 
@@ -817,7 +820,15 @@ do_sigbus(struct pt_regs *regs, unsigned
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
@@ -827,8 +838,8 @@ mm_fault_error(struct pt_regs *regs, uns
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

-- 

