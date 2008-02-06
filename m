Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbYBFXLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbYBFXLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763570AbYBFXGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:06:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:1486 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763555AbYBFXGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:06:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hCtAdNF1gNe2NzGpEAWoa9vpLiG/Aqgx6UjWianl8yV8pRuAP4bgJlNVWhzOYZlGy8XNFIdCLg5WF4YLJpxyXV/vZrDHKfVddur9uCbfCeAOaUPOBaC/fYS9Upkg+jNLE03Ppeg5UBC7SX+zMAGQYwc9XPdx6fY2L48rh9BwLTg=
Message-ID: <6101e8c40802061506x297eb52by6d4d30e1e406f97b@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:06:45 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {07/17} - i386-fixup-TRACE_IRQ-breakage - series for stable kernel #2
In-Reply-To: <6101e8c40802011733hb478764lc118368d0ef24547@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011733hb478764lc118368d0ef24547@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Jul 2007 18:59:22 +0000 (+0200)
Subject: i386: fixup TRACE_IRQ breakage
Patch-mainline: 2.6.23-rc1
References: 326270, CVE-2007-3731

i386: fixup TRACE_IRQ breakage

The TRACE_IRQS_ON function in iret_exc: calls a C function without
ensuring that the segments are set properly. Move the trace function and
the enabling of interrupt into the C stub.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
---

 arch/i386/kernel/entry.S |    2 --
 arch/i386/kernel/traps.c |   10 ++++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.22.orig/arch/i386/kernel/entry.S
+++ linux-2.6.22/arch/i386/kernel/entry.S
@@ -409,8 +409,6 @@ restore_nocheck_notrace:
 1:	INTERRUPT_RETURN
 .section .fixup,"ax"
 iret_exc:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $0			# no error code
 	pushl $do_iret_error
 	jmp error_code
--- linux-2.6.22.orig/arch/i386/kernel/traps.c
+++ linux-2.6.22/arch/i386/kernel/traps.c
@@ -517,10 +517,12 @@ fastcall void do_##name(struct pt_regs *
 	do_trap(trapnr, signr, str, 0, regs, error_code, NULL); \
 }

-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr) \
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq) \
 fastcall void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	siginfo_t info; \
+	if (irq) \
+		local_irq_enable(); \
 	info.si_signo = signr; \
 	info.si_errno = 0; \
 	info.si_code = sicode; \
@@ -560,13 +562,13 @@ DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
 DO_VM86_ERROR( 5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->eip)
+DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN,
regs->eip, 0)
 DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun",
coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0)
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
+DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)

 fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: a10d9a71bafd3a283da240d2868e71346d2aef6f
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
