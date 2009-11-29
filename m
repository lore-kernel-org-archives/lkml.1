Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZK2XS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZK2XS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZK2XS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:18:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:47345 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZK2XSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:18:55 -0500
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
 stepping)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <20091129210716.GA19205@redhat.com>
References: <20091125154052.GA6734@redhat.com>
	 <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com>
	 <20091126172524.GA14768@redhat.com>
	 <20091126182226.GF12355@darkmag.usersys.redhat.com>
	 <20091126202312.GA21945@redhat.com>
	 <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
	 <20091126223703.GA28556@redhat.com>
	 <20091127174627.GB26193@darkmag.usersys.redhat.com>
	 <20091128073049.GD23108@in.ibm.com>  <20091129210716.GA19205@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 10:15:01 +1100
Message-ID: <1259536501.2076.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-29 at 22:07 +0100, Oleg Nesterov wrote:
> On 11/28, Ananth N Mavinakayanahalli wrote:
> >
> > syscall-reset is the only failure I see on
> > powerpc:
> >
> > errno 14 (Bad address)
> > syscall-reset: syscall-reset.c:95: main: Assertion `(*__errno_location
> > ()) == 38' failed.
> > unexpected child status 67f
> > FAIL: syscall-reset
> 
> (to remind, it also fails without utrace)
> 
> Once again, I know nothing about powerc, perhaps I misread the code,
> but I believe this test-case is just wrong on powerpc and should be
> fixed.
> 
> On powerpc, syscall_get_nr() returns regs->gpr[0], this means this
> register is used to pass the syscall number.

Correct.

> This matches do_syscall_trace_enter(), it returns regs->gpr[0] as a
> (possibly changed by tracer) syscall nr.
> 
> arch/powerpc/kernel/entry_64.S does
> 
> 	syscall_dotrace:
> 
> 		 bl      .do_syscall_trace_enter
> 		 mr      r0,r3	// I guess, r3 = r0 ?

r3 is the return value from a function so this replaces the
syscall number
> 	 ...
> 		 b       syscall_dotrace_cont
> 
> 	syscall_dotrace_cont:
> 
> 		syscall_dotrace_cont:
> 
> 			cmpldi  0,r0,NR_syscalls
> 			bge-    syscall_enosys
> 
> 	syscall_enosys:
> 
> 		li      r3,-ENOSYS
> 		b       syscall_exit
> 
> 
> Now return to the test-case, syscall-reset.c. The tracee does
> l = syscall (-23, 1, 2, 3) and stops.
> 
> The tracer does
> 
> 	#define RETREG	offsetof(struct pt_regs, gpr[0])
> 	#define NEWVAL	((long) ENOTTY)
> 
> 	l = ptrace(PTRACE_PEEKUSER, child, RETREG, 0l);
> 
> l == -23, this is correct, note syscall(-23) above.
> 
> 	l = ptrace(PTRACE_POKEUSER, child, RETREG, NEWVAL);
> 
> And expects the tracee will see NEWVAL==ENOTTY after return from
> the systame call.
> 
> Of course this can't happen. We changed the syscall number, the
> new value is ENOTTY == 25 == __NR_stime, sys_stime() correctly
> returns -EFAULT.
> 
> -----------------------------------------------------------------
> 
> If I change the test-case to use NEWVAL == 1000 (or any other value
> greater than NR_syscalls), then the tracee sees ENOSYS and this is
> correct too.
> 
> But I do not see how it is possible to change the retcode on powerpc.
> Unlike x86, powepc doesn't set -ENOSYS "in advance", before doing
> do_syscall_trace_enter() logic. This means that if the tracer "cancels"
> syscall, r3 will be overwritten by syscall_enosys.
> 
> This probably means the kernel should be fixed too, but I am not
> brave enough to change the asm which I can't understand ;)

Yes, the asm should be changed. I suppose we could check if the result
of do_syscall_trace_enter is negative, and if it is, branch to the exit
path using r3 as the error code. Would that be ok ?

Something like this:

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 1175a85..7a88c88 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -419,6 +419,9 @@ syscall_dotrace:
 	stw	r0,_TRAP(r1)
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_syscall_trace_enter
+	cmpwi	cr0,r3,0
+	blt	ret_from_syscall
+
 	/*
 	 * Restore argument registers possibly just changed.
 	 * We use the return value of do_syscall_trace_enter
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 9763267..ec709a7 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -240,6 +240,9 @@ syscall_dotrace:
 	bl	.save_nvgprs
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	.do_syscall_trace_enter
+	cmpdi	cr0,r3,0
+	blt	syscall_exit
+
 	/*
 	 * Restore argument registers possibly just changed.
 	 * We use the return value of do_syscall_trace_enter


Cheers,
Ben.

