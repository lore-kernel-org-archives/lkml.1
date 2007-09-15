Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbXIOIMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbXIOIMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXIOIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:12:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbXIOIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:12:24 -0400
Date: Sat, 15 Sep 2007 01:11:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: convert to generic sys_ptrace
Message-Id: <20070915011150.0439a432.akpm@linux-foundation.org>
In-Reply-To: <20070908191257.GA5075@lst.de>
References: <20070908191257.GA5075@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007 21:12:57 +0200 Christoph Hellwig <hch@lst.de> wrote:

> This patch converts alpha to the generic sys_ptrace.  We use
> force_successful_syscall_return to avoid having to pass the pt_regs
> pointer down to the function.  I think the removal of the assemly
> stub is correct, but I could only compile-test this patch, so please
> give it a spin before commiting :)

Needed a bit of massaging due to consolidate-ptrace_detach.patch but
it still compiles:

 arch/alpha/kernel/entry.S  |    9 -------
 arch/alpha/kernel/ptrace.c |   42 +++++------------------------------
 include/asm-alpha/ptrace.h |    2 -
 3 files changed, 6 insertions(+), 47 deletions(-)

diff -puN arch/alpha/kernel/entry.S~alpha-convert-to-generic-sys_ptrace arch/alpha/kernel/entry.S
--- a/arch/alpha/kernel/entry.S~alpha-convert-to-generic-sys_ptrace
+++ a/arch/alpha/kernel/entry.S
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
diff -puN arch/alpha/kernel/ptrace.c~alpha-convert-to-generic-sys_ptrace arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~alpha-convert-to-generic-sys_ptrace
+++ a/arch/alpha/kernel/ptrace.c
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
@@ -366,16 +340,12 @@ do_sys_ptrace(long request, long pid, lo
 		wake_up_process(child);
 		/* give it a chance to run. */
 		ret = 0;
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
 	return ret;
 }
 
diff -puN include/asm-alpha/ptrace.h~alpha-convert-to-generic-sys_ptrace include/asm-alpha/ptrace.h
--- a/include/asm-alpha/ptrace.h~alpha-convert-to-generic-sys_ptrace
+++ a/include/asm-alpha/ptrace.h
@@ -68,8 +68,6 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
-#define __ARCH_SYS_PTRACE	1
-
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
_

