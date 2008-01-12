Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYALWJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYALWJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYALWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:09:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:46492 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYALWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aqQwXmQKpj62RXPVqM5nocQSPQtjdn4/iix0Ituv4+tIZJZEaU1+VMCfX4PSVw3Dw0n3vt5TDkET3Vrn+qv3BFhKKR6LV7k4h9/ta9Fb57lslGtT0X4jw7rhNSy5zgxCWrrHhL7CR1ELgw+sbsO4s0PBcBu8eDnu+vEgrYYif0I=
Subject: [PATCH 1/2] x86: Last of trivial fault_32|64.c unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 14:09:26 -0800
Message-Id: <1200175766.19760.93.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments, indentation, printk format.

Uses task_pid_nr() on X86_64 now, but this is always defined
to task->pid.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   20 ++++++++++++--------
 arch/x86/mm/fault_64.c |   29 +++++++++++++++++++----------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index f8fc240..5a52489 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -36,10 +36,10 @@
  *	bit 3 == 1 means use of reserved bit detected
  *	bit 4 == 1 means fault was an instruction fetch
  */
-#define PF_PROT	(1<<0)
+#define PF_PROT		(1<<0)
 #define PF_WRITE	(1<<1)
-#define PF_USER	(1<<2)
-#define PF_RSVD	(1<<3)
+#define PF_USER		(1<<2)
+#define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
 static inline int notify_page_fault(struct pt_regs *regs)
@@ -477,11 +477,15 @@ bad_area_nosemaphore:
 
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
-			printk("%s%s[%d]: segfault at %08lx ip %08lx "
-			    "sp %08lx error %lx\n",
-			    task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
-			    tsk->comm, task_pid_nr(tsk), address, regs->ip,
-			    regs->sp, error_code);
+			printk(
+#ifdef CONFIG_X86_32
+			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
+#else
+			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
+#endif
+			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+			tsk->comm, task_pid_nr(tsk), address, regs->ip,
+			regs->sp, error_code);
 		}
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 11e9398..befe9da 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -454,8 +454,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
 	if (error_code & PF_USER) {
-		/* Allow userspace just enough access below the stack pointer
-		 * to let the 'enter' instruction work.
+		/*
+		 * Accessing the stack below %sp is always a bug.
+		 * The large cushion allows instructions like enter
+		 * and pusha to work.  ("enter $65535,$31" pushes
+		 * 32 pointers and then decrements %sp by 65535.)
 		 */
 		if (address + 65536 + 32 * sizeof(unsigned long) < regs->sp)
 			goto bad_area;
@@ -540,10 +543,14 @@ bad_area_nosemaphore:
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
 			printk(
-		       "%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
-					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
-					tsk->comm, tsk->pid, address, regs->ip,
-					regs->sp, error_code);
+#ifdef CONFIG_X86_32
+			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
+#else
+			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
+#endif
+			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+			tsk->comm, task_pid_nr(tsk), address, regs->ip,
+			regs->sp, error_code);
 		}
 
 		tsk->thread.cr2 = address;
@@ -627,10 +634,12 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
-	/* Note that races in the updates of insync and start aren't
-	   problematic:
-	   insync can only get set bits added, and updates to start are only
-	   improving performance (without affecting correctness if undone). */
+	/*
+	 * Note that races in the updates of insync and start aren't
+	 * problematic: insync can only get set bits added, and updates to
+	 * start are only improving performance (without affecting correctness
+	 * if undone).
+	 */
 	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
 	static unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
-- 
1.5.4.rc2.1164.g6451


