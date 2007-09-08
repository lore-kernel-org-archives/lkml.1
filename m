Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbXIHTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbXIHTNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXIHTNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:13:13 -0400
Received: from verein.lst.de ([213.95.11.210]:60359 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbXIHTNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:13:12 -0400
Date: Sat, 8 Sep 2007 21:12:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: convert to generic sys_ptrace
Message-ID: <20070908191257.GA5075@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts alpha to the generic sys_ptrace.  We use
force_successful_syscall_return to avoid having to pass the pt_regs
pointer down to the function.  I think the removal of the assemly
stub is correct, but I could only compile-test this patch, so please
give it a spin before commiting :)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/alpha/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/ptrace.c	2007-09-08 20:23:22.000000000 +0200
+++ linux-2.6/arch/alpha/kernel/ptrace.c	2007-09-08 20:52:32.000000000 +0200
@@ -260,38 +260,12 @@ void ptrace_disable(struct task_struct *
 	ptrace_cancel_bpt(child);
 }
 
-asmlinkage long
-do_sys_ptrace(long request, long pid, long addr, long data,
-	      struct pt_regs *regs)
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	struct task_struct *child;
 	unsigned long tmp;
 	size_t copied;
 	long ret;
 
-	lock_kernel();
-	DBG(DBG_MEM, ("request=%ld pid=%ld addr=0x%lx data=0x%lx\n",
-		      request, pid, addr, data));
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		goto out_notsk;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out_notsk;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		goto out;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out;
-
 	switch (request) {
 	/* When I and D space are separate, these will need to be fixed.  */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
@@ -301,13 +275,13 @@ do_sys_ptrace(long request, long pid, lo
 		if (copied != sizeof(tmp))
 			break;
 		
-		regs->r0 = 0;	/* special return: no errors */
+		force_successful_syscall_return();
 		ret = tmp;
 		break;
 
 	/* Read register number ADDR. */
 	case PTRACE_PEEKUSR:
-		regs->r0 = 0;	/* special return: no errors */
+		force_successful_syscall_return();
 		ret = get_reg(child, addr);
 		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
 		break;
@@ -353,7 +327,7 @@ do_sys_ptrace(long request, long pid, lo
 		/* make sure single-step breakpoint is gone. */
 		ptrace_cancel_bpt(child);
 		wake_up_process(child);
-		goto out;
+		break;
 
 	case PTRACE_SINGLESTEP:  /* execute single instruction. */
 		ret = -EIO;
@@ -366,20 +340,17 @@ do_sys_ptrace(long request, long pid, lo
 		wake_up_process(child);
 		/* give it a chance to run. */
 		ret = 0;
-		goto out;
+		break;
 
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
-		goto out;
+		break;
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-		goto out;
+		break;
 	}
- out:
-	put_task_struct(child);
- out_notsk:
-	unlock_kernel();
+
 	return ret;
 }
 
Index: linux-2.6/arch/alpha/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/entry.S	2007-09-08 20:52:01.000000000 +0200
+++ linux-2.6/arch/alpha/kernel/entry.S	2007-09-08 20:52:16.000000000 +0200
@@ -917,15 +917,6 @@ sys_pipe:
 .end sys_pipe
 
 	.align	4
-	.globl	sys_ptrace
-	.ent	sys_ptrace
-sys_ptrace:
-	.prologue 0
-	mov	$sp, $20
-	jmp	$31, do_sys_ptrace
-.end sys_ptrace
-
-	.align	4
 	.globl	sys_execve
 	.ent	sys_execve
 sys_execve:
Index: linux-2.6/include/asm-alpha/ptrace.h
===================================================================
--- linux-2.6.orig/include/asm-alpha/ptrace.h	2007-09-08 20:52:45.000000000 +0200
+++ linux-2.6/include/asm-alpha/ptrace.h	2007-09-08 20:52:51.000000000 +0200
@@ -68,8 +68,6 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
-#define __ARCH_SYS_PTRACE	1
-
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
