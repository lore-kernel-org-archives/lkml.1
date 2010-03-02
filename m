Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab0CBItU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:49:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0CBItS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:49:18 -0500
Date: Tue, 2 Mar 2010 10:49:07 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100302084907.GV16909@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BE7C1.40000@redhat.com>
 <20100301174724.GA12867@redhat.com>
 <4B8C09F5.9070506@redhat.com>
 <20100301190341.GD12867@redhat.com>
 <4B8C1320.6060602@redhat.com>
 <4B8C4032.7080703@zytor.com>
 <4B8C463B.7070900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8C463B.7070900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 02:56:59PM -0800, H. Peter Anvin wrote:
> On 03/01/2010 02:31 PM, H. Peter Anvin wrote:
> > On 03/01/2010 11:18 AM, Zachary Amsden wrote:
> >>
> >> It's going to be ugly to emulate segmentation, NX and write protect 
> >> support without hardware to do this checking for you, but it's just what 
> >> you have to do in this slow path - tedious, fully specified emulation.
> >>
> >> Just because it's tedious doesn't mean we need to use setjmp / longjmp.  
> >> Throw / catch might be effective, but it's still pretty bizarre to do 
> >> tricks like that in C.
> >>
> > 
> > Well, setjmp/longjmp really is not much more than exception handling in C.
> > 
> 
> For what it's worth, I think that setjmp/longjmp is not anywhere near as
> dangerous as people want to make it out to be.  gcc will warn for
> dangerous uses (and a lot of non-dangerous uses), but generally the
> difficult problems can be dealt with by moving the setjmp-protected code
> into a separate function.
> 
Can I consider this as ACK for something like the patch blow? :) (with
proper x86 version of setjmp/longjmp of course).

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index cfcb6f0..089a405 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -35,6 +35,45 @@
 #include "x86.h"
 #include "tss.h"
 
+typedef unsigned long jmp_buf[8];
+int setjmp(jmp_buf);
+void longjmp(jmp_buf, int);
+
+asm (
+"	.align 4\n"
+"	.type setjmp, @function\n"
+"setjmp:\n"
+"	pop  %rsi		# Return address, and adjust the stack\n"
+"	xorl %eax,%eax		# Return value\n"
+"	movq %rbx,(%rdi)\n"
+"	movq %rsp,8(%rdi)	# Post-return %rsp!\n"
+"	push %rsi		# Make the call/return stack happy\n"
+"	movq %rbp,16(%rdi)\n"
+"	movq %r12,24(%rdi)\n"
+"	movq %r13,32(%rdi)\n"
+"	movq %r14,40(%rdi)\n"
+"	movq %r15,48(%rdi)\n"
+"	movq %rsi,56(%rdi)	# Return address\n"
+"	ret\n"
+"	.size setjmp,.-setjmp\n"
+
+"	.align 4\n"
+"	.type longjmp, @function\n"
+"longjmp:\n"
+"	movl %esi,%eax		# Return value (int)\n"
+"	movq (%rdi),%rbx\n"
+"	movq 8(%rdi),%rsp\n"
+"	movq 16(%rdi),%rbp\n"
+"	movq 24(%rdi),%r12\n"
+"	movq 32(%rdi),%r13\n"
+"	movq 40(%rdi),%r14\n"
+"	movq 48(%rdi),%r15\n"
+"	jmp *56(%rdi)\n"
+"	.size longjmp,.-longjmp\n"
+	);
+
+static jmp_buf jb;
+
 /*
  * Opcode effective-address decode tables.
  * Note that we only emulate instructions that have at least one memory
@@ -1729,7 +1768,7 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 					c->dst.bytes,
 					ctxt->vcpu);
 		if (rc != X86EMUL_CONTINUE)
-			return rc;
+			longjmp(jb, 1);
 		break;
 	case OP_NONE:
 		/* no writeback */
@@ -2391,6 +2430,11 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 	saved_eip = c->eip;
 
+	if (setjmp(jb)) {
+		printk(KERN_ERR"setjump() == 1\n");
+		return 0;
+	}
+
 	if (ctxt->mode == X86EMUL_MODE_PROT64 && (c->d & No64)) {
 		kvm_queue_exception(ctxt->vcpu, UD_VECTOR);
 		goto done;
--
			Gleb.
