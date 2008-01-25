Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYAYBFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYAYBFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYAYBFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:05:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:15471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYAYBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:05:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KHbeOB3G1hTKixUZALlybbfJT1KzJsYX5hUiv8BK0zWcevOhPVXjTbTWHwNQsEAnsUS6r4YRbt4f/RUXy5h3br7Zjq6qw5QjTnSYduz4z/l//tYgZYiaKyqbzCYSr2xYc0Qgjfndq0N/+APv8+/jDyJYLyqQjoMNjbvpACOR9KY=
Subject: [PATCH 1/2] x86: Shrink some ifdefs in fault.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 17:05:31 -0800
Message-Id: <1201223131.16972.171.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change from current to tsk in do_page_fault is safe as
this is set at the very beginning of the function.

Removes a likely() annotation from the X86_64 version, this
could have instead been added to X86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault.c |   43 ++++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 14a0c6e..95fe8bf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -383,6 +383,7 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 #ifdef CONFIG_X86_32
 	if (!oops_may_print())
 		return;
+#endif
 
 #ifdef CONFIG_X86_PAE
 	if (error_code & PF_INSTR) {
@@ -395,28 +396,20 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 				"(uid: %d)\n", current->uid);
 	}
 #endif
-	printk(KERN_ALERT "BUG: unable to handle kernel ");
-	if (address < PAGE_SIZE)
-		printk(KERN_CONT "NULL pointer dereference");
-	else
-		printk(KERN_CONT "paging request");
-	printk(KERN_CONT " at %08lx\n", address);
 
-	printk(KERN_ALERT "IP:");
-	printk_address(regs->ip, 1);
-	dump_pagetable(address);
-#else /* CONFIG_X86_64 */
 	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
 		printk(KERN_CONT "NULL pointer dereference");
 	else
 		printk(KERN_CONT "paging request");
+#ifdef CONFIG_X86_32
+	printk(KERN_CONT " at %08lx\n", address);
+#else
 	printk(KERN_CONT " at %016lx\n", address);
-
+#endif
 	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
-#endif
 }
 
 #ifdef CONFIG_X86_64
@@ -655,11 +648,7 @@ again:
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
-#ifdef CONFIG_X86_32
 	if (vma->vm_start <= address)
-#else
-	if (likely(vma->vm_start <= address))
-#endif
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
@@ -808,23 +797,21 @@ no_context:
  */
 #ifdef CONFIG_X86_32
 	bust_spinlocks(1);
+#else
+	flags = oops_begin();
+#endif
 
 	show_fault_oops(regs, error_code, address);
 
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
+
+#ifdef CONFIG_X86_32
 	die("Oops", regs, error_code);
 	bust_spinlocks(0);
 	do_exit(SIGKILL);
-#else /* CONFIG_X86_64 */
-	flags = oops_begin();
-
-	show_fault_oops(regs, error_code, address);
-
-	tsk->thread.cr2 = address;
-	tsk->thread.trap_no = 14;
-	tsk->thread.error_code = error_code;
+#else
 	if (__die("Oops", regs, error_code))
 		regs = NULL;
 	/* Executive summary in case the body of the oops scrolled away */
@@ -838,18 +825,16 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-#ifdef CONFIG_X86_32
 	if (is_global_init(tsk)) {
 		yield();
+#ifdef CONFIG_X86_32
 		down_read(&mm->mmap_sem);
 		goto survive;
-	}
 #else
-	if (is_global_init(current)) {
-		yield();
 		goto again;
-	}
 #endif
+	}
+
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & PF_USER)
 		do_group_exit(SIGKILL);
-- 
1.5.4.rc4.1130.g9ad85


