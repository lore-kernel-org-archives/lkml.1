Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0ADUtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0ADUtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966Ab0ADUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:49:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:33617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0ADUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:49:33 -0500
Message-Id: <20100104182813.815259559@chello.nl>
References: <20100104182429.833180340@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 19:24:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC][PATCH 7/8] mm,x86: speculative pagefault support
Content-Disposition: inline; filename=mm-foo-9.patch
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the x86 architecture support for speculative pagefaults.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/fault.c |   31 +++++++++++--------------------
 arch/x86/mm/gup.c   |   10 ++++++++++
 2 files changed, 21 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -777,30 +777,13 @@ bad_area_access_error(struct pt_regs *re
 	__bad_area(regs, error_code, address, SEGV_ACCERR);
 }
 
-/* TODO: fixup for "mm-invoke-oom-killer-from-page-fault.patch" */
-static void
-out_of_memory(struct pt_regs *regs, unsigned long error_code,
-	      unsigned long address)
-{
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed):
-	 */
-	up_read(&current->mm->mmap_sem);
-
-	pagefault_out_of_memory();
-}
-
 static void
 do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	  unsigned int fault)
 {
 	struct task_struct *tsk = current;
-	struct mm_struct *mm = tsk->mm;
 	int code = BUS_ADRERR;
 
-	up_read(&mm->mmap_sem);
-
 	/* Kernel mode? Handle exceptions or die: */
 	if (!(error_code & PF_USER))
 		no_context(regs, error_code, address);
@@ -829,7 +812,7 @@ mm_fault_error(struct pt_regs *regs, uns
 	       unsigned long address, unsigned int fault)
 {
 	if (fault & VM_FAULT_OOM) {
-		out_of_memory(regs, error_code, address);
+		pagefault_out_of_memory();
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON))
 			do_sigbus(regs, error_code, address, fault);
@@ -1040,6 +1023,14 @@ do_page_fault(struct pt_regs *regs, unsi
 		return;
 	}
 
+	if (error_code & PF_USER) {
+		fault = handle_speculative_fault(mm, address,
+				error_code & PF_WRITE ? FAULT_FLAG_WRITE : 0);
+
+		if (!(fault & VM_FAULT_RETRY))
+			goto done;
+	}
+
 	/*
 	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in
@@ -1119,6 +1110,8 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
 
+	up_read(&mm->mmap_sem);
+done:
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		mm_fault_error(regs, error_code, address, fault);
 		return;
@@ -1135,6 +1128,4 @@ good_area:
 	}
 
 	check_v8086_mode(regs, address, tsk);
-
-	up_read(&mm->mmap_sem);
 }
Index: linux-2.6/arch/x86/mm/gup.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/gup.c
+++ linux-2.6/arch/x86/mm/gup.c
@@ -373,3 +373,13 @@ slow_irqon:
 		return ret;
 	}
 }
+
+void pin_page_tables(void)
+{
+	local_irq_disable();
+}
+
+void unpin_page_tables(void)
+{
+	local_irq_enable();
+}

-- 

