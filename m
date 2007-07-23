Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXGWSLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXGWSLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbXGWSLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:11:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47421 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbXGWSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:10:58 -0400
Subject: [PATCH respin, was PATCH for review] During VM oom condition, kill
	all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707191614180.7377@anakin>
References: <20070719348.540885000@suse.de>
	 <20070719134840.47B5114E6E@wotan.suse.de>
	 <20070719140411.GD16279@infradead.org>
	 <Pine.LNX.4.64.0707191614180.7377@anakin>
Content-Type: text/plain
Organization: IBM
Date: Mon, 23 Jul 2007 13:09:45 -0500
Message-Id: <1185214185.22237.30.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


During VM oom condition, kill all threads in process group.

We have had complaints where a threaded application is left in a bad
state after one of it's threads is killed when we hit a VM: out_of_memory
condition.
Killing just one of the process threads can leave the application in a
bad state, whereas killing the entire process group would allow for
the application to restart, or be otherwise handled, and makes it very
obvious that something has gone wrong.

This change allows the entire process group to be taken down, rather
than just the one thread.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>

---
 This patch hits all arches except for x86_64 and powerpc; those arches
have already been updated with this change.

diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index a0e18da..25154df 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -197,7 +197,7 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	       current->comm, current->pid);
 	if (!user_mode(regs))
 		goto no_context;
-	do_exit(SIGKILL);
+	do_group_exit(SIGKILL);
 
  do_sigbus:
 	/* Send a sigbus, regardless of whether we were in kernel
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 846cce4..59ed1d0 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -266,7 +266,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		 * the page fault gracefully.
 		 */
 		printk("VM: killing process %s\n", tsk->comm);
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 		return 0;
 	}
 	if (fault & VM_FAULT_SIGBUS) {
diff --git a/arch/arm26/mm/fault.c b/arch/arm26/mm/fault.c
index dec638a..df14681 100644
--- a/arch/arm26/mm/fault.c
+++ b/arch/arm26/mm/fault.c
@@ -246,7 +246,7 @@ int do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		 * us that made us unable to handle the page fault gracefully.
 		 */
 		printk("VM: killing process %s\n", tsk->comm);
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	}
 	else{
 		__do_user_fault(tsk, addr, fsr, fault == -1 ? SEGV_ACCERR : SEGV_MAPERR, regs);
diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index ae2d2c5..11472f8 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -216,7 +216,7 @@ out_of_memory:
 	}
 	printk("VM: Killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 8672ab7..8aab814 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -360,7 +360,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
  do_sigbus:
diff --git a/arch/frv/mm/fault.c b/arch/frv/mm/fault.c
index 6798fa0..05093d4 100644
--- a/arch/frv/mm/fault.c
+++ b/arch/frv/mm/fault.c
@@ -259,7 +259,7 @@ asmlinkage void do_page_fault(int datammu, unsigned long esr0, unsigned long ear
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(__frame))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
  do_sigbus:
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 01ffdd4..2bc2592 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -597,7 +597,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 73ccb60..320edf8 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -273,6 +273,6 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 	}
 	printk(KERN_CRIT "VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 }
diff --git a/arch/m32r/mm/fault.c b/arch/m32r/mm/fault.c
index 676a1c4..70a766a 100644
--- a/arch/m32r/mm/fault.c
+++ b/arch/m32r/mm/fault.c
@@ -278,7 +278,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & ACE_USERMODE)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index 578b48f..eaa6186 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -188,7 +188,7 @@ out_of_memory:
 
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 
 no_context:
 	current->thread.signo = SIGBUS;
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 521771b..5699c77 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -180,7 +180,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 7899ab8..1c091b4 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -263,6 +263,6 @@ no_context:
 	up_read(&mm->mmap_sem);
 	printk(KERN_CRIT "VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 }
diff --git a/arch/ppc/mm/fault.c b/arch/ppc/mm/fault.c
index b98244e..94913dd 100644
--- a/arch/ppc/mm/fault.c
+++ b/arch/ppc/mm/fault.c
@@ -297,7 +297,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	return SIGKILL;
 
 do_sigbus:
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 5405519..f5bd497 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -218,7 +218,7 @@ static int do_out_of_memory(struct pt_regs *regs, unsigned long error_code,
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (regs->psw.mask & PSW_MASK_PSTATE)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	do_no_context(regs, error_code, address);
 	return 0;
 }
diff --git a/arch/sh/mm/fault.c b/arch/sh/mm/fault.c
index 964c676..b0d5170 100644
--- a/arch/sh/mm/fault.c
+++ b/arch/sh/mm/fault.c
@@ -215,7 +215,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/sh64/mm/fault.c b/arch/sh64/mm/fault.c
index 0d069d8..dd81c66 100644
--- a/arch/sh64/mm/fault.c
+++ b/arch/sh64/mm/fault.c
@@ -334,7 +334,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/sparc/mm/fault.c b/arch/sparc/mm/fault.c
index 50747fe..e4d9c8e 100644
--- a/arch/sparc/mm/fault.c
+++ b/arch/sparc/mm/fault.c
@@ -369,7 +369,7 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", tsk->comm);
 	if (from_user)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
index 17123e9..13fdfa3 100644
--- a/arch/sparc64/mm/fault.c
+++ b/arch/sparc64/mm/fault.c
@@ -466,7 +466,7 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", current->comm);
 	if (!(regs->tstate & TSTATE_PRIV))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto handle_kernel_fault;
 
 intr_or_no_mm:
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index 1600406..399df5c 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -150,7 +150,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	bad_page_fault(regs, address, SIGKILL);
 	return;
 



