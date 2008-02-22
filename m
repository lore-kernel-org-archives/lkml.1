Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbYBVVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbYBVVro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbYBVVn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:60415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454AbYBVVnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:24 -0500
Date: Fri, 22 Feb 2008 13:40:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Mahoney <jeffm@suse.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 09/23] i386: fixup TRACE_IRQ breakage (CVE-2007-3731)
Message-ID: <20080222214027.GJ8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-fixup-trace_irq-breakage.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

mainline: a10d9a71bafd3a283da240d2868e71346d2aef6f

The TRACE_IRQS_ON function in iret_exc: calls a C function without
ensuring that the segments are set properly. Move the trace function and
the enabling of interrupt into the C stub.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/entry.S |    2 --
 arch/i386/kernel/traps.c |   10 ++++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -409,8 +409,6 @@ restore_nocheck_notrace:
 1:	INTERRUPT_RETURN
 .section .fixup,"ax"
 iret_exc:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $0			# no error code
 	pushl $do_iret_error
 	jmp error_code
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
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
+DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->eip, 0)
 DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0)
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
+DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)

-- 
