Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbXKNRh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbXKNRh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXKNRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:37:28 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:43598 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046AbXKNRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:37:27 -0500
Date: Wed, 14 Nov 2007 12:36:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: uml doesn't work on 2.6.24-rc2
Message-ID: <20071114173639.GA7899@c2.user-mode-linux.org>
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 04:26:11PM +0100, Miklos Szeredi wrote:
> This one fixed the EINVAL messages, and now UML boots, but consumes
> 100% CPU constantly.

Can you strace it and see if you are seeing zero-length nanosleeps,
and then send me your config file?  I've had one other report of this,
but haven't reproduced it here.

> > You'll also need f86f9e6d66027bdcdc9b40c06d431ee53ea0d509 for a
> > separate problem.
> 
> I can't find this in -linus.  Which tree is it?

My private tree, sorry - I looked at git-log output too quickly.  The
patch is below.  It's also in -mm.

> Never seen anything like this until 2.6.24.  Strange...

It breaks ptrace on 6-argument system calls made by 32-bit sysenter.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

commit f86f9e6d66027bdcdc9b40c06d431ee53ea0d509
Author: Jeff Dike <jdike@addtoit.com>
Date:   Wed Nov 7 10:40:07 2007 -0500

    From: Chuck Ebbert <76306.1226@compuserve.com>
    
    [ jdike - Pushing Chuck's patch - see http://lkml.org/lkml/2005/9/16/261 ]
    
    When the 32-bit vDSO is used to make a system call, the %ebp register for
    the 6th syscall arg has to be loaded from the user stack (where it's pushed
    by the vDSO user code).  The native i386 kernel always does this before
    stopping for syscall tracing, so %ebp can be seen and modified via ptrace
    to access the 6th syscall argument.  The x86-64 kernel fails to do this,
    presenting the stack address to ptrace instead.  This makes the %rbp value
    seen by 64-bit ptrace of a 32-bit process, and the %ebp value seen by a
    32-bit caller of ptrace, both differ from the native i386 behavior.
    
    This patch fixes the problem by putting the word loaded from the user stack
    into %rbp before calling syscall_trace_enter, and reloading the 6th syscall
    argument from there afterwards (so ptrace can change it).  This makes the
    behavior match that of i386 kernels.
    
    Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Original-Patch-By: Roland McGrath <roland@redhat.com>
    ---
     arch/x86_64/ia32/ia32entry.S |   19 ++++++-------------
     1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 18b2318..df588f0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -159,20 +159,16 @@ sysenter_do_call:
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
+	xchgl	%r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	movl	%ebp, %ebp
-	/* no need to do an access_ok check here because rbp has been
-	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
+	xchgl	%ebp,%r9d
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -262,20 +258,17 @@ cstar_do_call:
 	
 cstar_tracesys:	
 	CFI_RESTORE_STATE
+	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq %r9,R9(%rsp)
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
+	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
