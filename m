Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXLFMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXLFMq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXLFMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:49 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53716 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXLFMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:30 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <1cafe3040d64fbc0094c804d0840a282f71644e0.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 13:59:57 +0100
Subject: [PATCH 15/47] Minor fixes to mm/fault.c for CRIS.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Only disallow oops if we're in_interrupt context (was in_atomic before)
- Use the generic oops_in_progress instead of the raw_printk hack.
- Fix whitespace/formatting.
- Remove CVS log entries.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/mm/fault.c |  169 ++++++++-----------------------------------------
 1 files changed, 28 insertions(+), 141 deletions(-)

diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 3034f3f..c4c76db 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -1,130 +1,9 @@
 /*
  *  linux/arch/cris/mm/fault.c
  *
- *  Copyright (C) 2000, 2001  Axis Communications AB
- *
- *  Authors:  Bjorn Wesen 
- * 
- *  $Log: fault.c,v $
- *  Revision 1.20  2005/03/04 08:16:18  starvik
- *  Merge of Linux 2.6.11.
- *
- *  Revision 1.19  2005/01/14 10:07:59  starvik
- *  Fixed warning.
- *
- *  Revision 1.18  2005/01/12 08:10:14  starvik
- *  Re-added the change of frametype when handling kernel page fault fixup
- *  for v10. This is necessary to avoid that the CPU remakes the faulting
- *  access.
- *
- *  Revision 1.17  2005/01/11 13:53:05  starvik
- *  Use raw_printk.
- *
- *  Revision 1.16  2004/12/17 11:39:41  starvik
- *  SMP support.
- *
- *  Revision 1.15  2004/11/23 18:36:18  starvik
- *  Stack is now non-executable.
- *  Signal handler trampolines are placed in a reserved page mapped into all
- *  processes.
- *
- *  Revision 1.14  2004/11/23 07:10:21  starvik
- *  Moved find_fixup_code to generic code.
- *
- *  Revision 1.13  2004/11/23 07:00:54  starvik
- *  Actually use the execute permission bit in the MMU. This makes it possible
- *  to prevent e.g. attacks where executable code is put on the stack.
- *
- *  Revision 1.12  2004/09/29 06:16:04  starvik
- *  Use instruction_pointer
- *
- *  Revision 1.11  2004/05/14 07:58:05  starvik
- *  Merge of changes from 2.4
- *
- *  Revision 1.10  2003/10/27 14:51:24  starvik
- *  Removed debugcode
- *
- *  Revision 1.9  2003/10/27 14:50:42  starvik
- *  Changed do_page_fault signature
- *
- *  Revision 1.8  2003/07/04 13:02:48  tobiasa
- *  Moved code snippet from arch/cris/mm/fault.c that searches for fixup code
- *  to separate function in arch-specific files.
- *
- *  Revision 1.7  2003/01/22 06:48:38  starvik
- *  Fixed warnings issued by GCC 3.2.1
- *
- *  Revision 1.6  2003/01/09 14:42:52  starvik
- *  Merge of Linux 2.5.55
- *
- *  Revision 1.5  2002/12/11 14:44:48  starvik
- *  Extracted v10 (ETRAX 100LX) specific stuff to arch/cris/arch-v10/mm
- *
- *  Revision 1.4  2002/11/13 15:10:28  starvik
- *  pte_offset has been renamed to pte_offset_kernel
- *
- *  Revision 1.3  2002/11/05 06:45:13  starvik
- *  Merge of Linux 2.5.45
- *
- *  Revision 1.2  2001/12/18 13:35:22  bjornw
- *  Applied the 2.4.13->2.4.16 CRIS patch to 2.5.1 (is a copy of 2.4.15).
- *
- *  Revision 1.20  2001/11/22 13:34:06  bjornw
- *  * Bug workaround (LX TR89): force a rerun of the whole of an interrupted
- *    unaligned write, because the second half of the write will be corrupted
- *    otherwise. Affected unaligned writes spanning not-yet mapped pages.
- *  * Optimization: use the wr_rd bit in R_MMU_CAUSE to know whether a miss
- *    was due to a read or a write (before we didn't know this until the next
- *    restart of the interrupted instruction, thus wasting one fault-irq)
- *
- *  Revision 1.19  2001/11/12 19:02:10  pkj
- *  Fixed compiler warnings.
- *
- *  Revision 1.18  2001/07/18 22:14:32  bjornw
- *  Enable interrupts in the bulk of do_page_fault
- *
- *  Revision 1.17  2001/07/18 13:07:23  bjornw
- *  * Detect non-existant PTE's in vmalloc pmd synchronization
- *  * Remove comment about fast-paths for VMALLOC_START etc, because all that
- *    was totally bogus anyway it turned out :)
- *  * Fix detection of vmalloc-area synchronization
- *  * Add some comments
- *
- *  Revision 1.16  2001/06/13 00:06:08  bjornw
- *  current_pgd should be volatile
- *
- *  Revision 1.15  2001/06/13 00:02:23  bjornw
- *  Use a separate variable to store the current pgd to avoid races in schedule
- *
- *  Revision 1.14  2001/05/16 17:41:07  hp
- *  Last comment tweak further tweaked.
- *
- *  Revision 1.13  2001/05/15 00:58:44  hp
- *  Expand a bit on the comment why we compare address >= TASK_SIZE rather
- *  than >= VMALLOC_START.
- *
- *  Revision 1.12  2001/04/04 10:51:14  bjornw
- *  mmap_sem is grabbed for reading
- *
- *  Revision 1.11  2001/03/23 07:36:07  starvik
- *  Corrected according to review remarks
- *
- *  Revision 1.10  2001/03/21 16:10:11  bjornw
- *  CRIS_FRAME_FIXUP not needed anymore, use FRAME_NORMAL
- *
- *  Revision 1.9  2001/03/05 13:22:20  bjornw
- *  Spell-fix and fix in vmalloc_fault handling
- *
- *  Revision 1.8  2000/11/22 14:45:31  bjornw
- *  * 2.4.0-test10 removed the set_pgdir instantaneous kernel global mapping
- *    into all processes. Instead we fill in the missing PTE entries on demand.
- *
- *  Revision 1.7  2000/11/21 16:39:09  bjornw
- *  fixup switches frametype
- *
- *  Revision 1.6  2000/11/17 16:54:08  bjornw
- *  More detailed siginfo reporting
+ *  Copyright (C) 2000-2006  Axis Communications AB
  *
+ *  Authors:  Bjorn Wesen
  *
  */
 
@@ -135,7 +14,6 @@
 
 extern int find_fixup_code(struct pt_regs *);
 extern void die_if_kernel(const char *, struct pt_regs *, long);
-extern int raw_printk(const char *fmt, ...);
 
 /* debug of low-level TLB reload */
 #undef DEBUG
@@ -164,8 +42,8 @@ unsigned long cris_signal_return_page;
  * address.
  *
  * error_code:
- *	bit 0 == 0 means no page found, 1 means protection fault
- *	bit 1 == 0 means read, 1 means write
+ *      bit 0 == 0 means no page found, 1 means protection fault
+ *      bit 1 == 0 means read, 1 means write
  *
  * If this routine detects a bad access, it returns 1, otherwise it
  * returns 0.
@@ -181,9 +59,10 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	siginfo_t info;
 	int fault;
 
-        D(printk("Page fault for %lX on %X at %lX, prot %d write %d\n",
-                 address, smp_processor_id(), instruction_pointer(regs),
-                 protection, writeaccess));
+	D(printk(KERN_DEBUG
+		 "Page fault for %lX on %X at %lX, prot %d write %d\n",
+		 address, smp_processor_id(), instruction_pointer(regs),
+		 protection, writeaccess));
 
 	tsk = current;
 
@@ -233,7 +112,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	 * context, we must not take the fault..
 	 */
 
-	if (in_atomic() || !mm)
+	if (in_interrupt() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
@@ -319,6 +198,9 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 		/* info.si_code has been set above */
 		info.si_addr = (void *)address;
 		force_sig_info(SIGSEGV, &info, tsk);
+		printk(KERN_NOTICE "%s (pid %d) segfaults for page "
+		       "address %08lx at pc %08lx\n",
+		       tsk->comm, tsk->pid, address, instruction_pointer(regs));
 		return;
 	}
 
@@ -326,7 +208,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 
 	/* Are we prepared to handle this kernel fault?
 	 *
-	 * (The kernel has valid exception-points in the source 
+	 * (The kernel has valid exception-points in the source
 	 *  when it acesses user-memory. When it fails in one
 	 *  of those points, we find it in a table and do a jump
 	 *  to some fixup code that loads an appropriate error
@@ -341,13 +223,18 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	 * terminate things with extreme prejudice.
 	 */
 
-	if ((unsigned long) (address) < PAGE_SIZE)
-		raw_printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
-	else
-		raw_printk(KERN_ALERT "Unable to handle kernel access");
-	raw_printk(" at virtual address %08lx\n",address);
-
-	die_if_kernel("Oops", regs, (writeaccess << 1) | protection);
+	if (!oops_in_progress) {
+		oops_in_progress = 1;
+		if ((unsigned long) (address) < PAGE_SIZE)
+			printk(KERN_ALERT "Unable to handle kernel NULL "
+				"pointer dereference");
+		else
+			printk(KERN_ALERT "Unable to handle kernel access"
+				" at virtual address %08lx\n", address);
+
+		die_if_kernel("Oops", regs, (writeaccess << 1) | protection);
+		oops_in_progress = 0;
+	}
 
 	do_exit(SIGKILL);
 
@@ -360,7 +247,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_group_exit(SIGKILL);
+		do_exit(SIGKILL);
 	goto no_context;
 
  do_sigbus:
@@ -406,8 +293,8 @@ vmalloc_fault:
 		/* Since we're two-level, we don't need to do both
 		 * set_pgd and set_pmd (they do the same thing). If
 		 * we go three-level at some point, do the right thing
-		 * with pgd_present and set_pgd here. 
-		 * 
+		 * with pgd_present and set_pgd here.
+		 *
 		 * Also, since the vmalloc area is global, we don't
 		 * need to copy individual PTE's, it is enough to
 		 * copy the pgd pointer into the pte page of the
-- 
1.5.3.6.970.gd25430

