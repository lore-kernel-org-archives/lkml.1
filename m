Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXLRLmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXLRLmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbXLRLmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:42:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20560 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXLRLmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=khKb0IoYV5jqRuT90XuxJN4NTXDQl4WYy3BnnBXLSy2jHwmIwttP2dC9EFyXL1TCxJrmmZfO9HubHiysn8fL+R1qziYt0EH8UID416BnSW6TkvPKDNc8APVO1+fbt/vLYu6HEGyOZoo8W14aGeWu0xLVFp8rjGSWpiEPCujdsbo=
Subject: Re: [PATCH 3/4] x86: add kprobe-booster to X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20071218112936.GE9002@elte.hu>
References: <1197930464.23402.112.camel@brick>
	 <20071218112936.GE9002@elte.hu>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 03:42:40 -0800
Message-Id: <1197978160.7734.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 12:29 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Sorry I missed an ifdef in this patch in the following hunk:
> 
> could you resend your kprobes cleanups against current x86.git? They
> have been conceptually acked by Masami. This cuts out the unification
> part of your queue which is bad luck but the effort has been duplicated
> already so there's not much we can do about it i guess.
> 
> Your other 17 cleanup and unification patches are still queued up in
> x86.git and passed a lot of testing, so they will likely go into
> v2.6.25. Nice work!
> 
> 	Ingo

Ingo,

I'd suggest just tossing my kprobes cleanups.  I just sent you a rollup
of anything I saw that was left in mine that was still worthwhile
after Masami's, included below for reference.  It didn't amount to much
left so I rolled it all together:

Subject: [PATCH] x86: kprobes leftover cleanups

Eliminate __always_inline, all of these static functions are
only called once.  Minor whitespace cleanup.  Eliminate one
supefluous return at end of void function.  Reverse sense of
#ifndef to be #ifdef to show the case only affects X86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 9aadd4d..1a0d96d 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -159,7 +159,7 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static __always_inline void set_jmp_op(void *from, void *to)
+static void set_jmp_op(void *from, void *to)
 {
 	struct __arch_jmp_op {
 		char op;
@@ -174,7 +174,7 @@ static __always_inline void set_jmp_op(void *from, void *to)
  * Returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
-static __always_inline int can_boost(kprobe_opcode_t *opcodes)
+static int can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -392,13 +392,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
-static __always_inline void clear_btf(void)
+static void clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
 		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
 }
 
-static __always_inline void restore_btf(void)
+static void restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
 		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
@@ -409,7 +409,7 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 	clear_btf();
 	regs->flags |= TF_MASK;
 	regs->flags &= ~IF_MASK;
-	/*single step inline if the instruction is an int3*/
+	/* single step inline if the instruction is an int3 */
 	if (p->opcode == BREAKPOINT_INSTRUCTION)
 		regs->ip = (unsigned long)p->addr;
 	else
@@ -767,7 +767,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 	case 0xe8:	/* call relative - Fix return addr */
 		*tos = orig_ip + (*tos - copy_ip);
 		break;
-#ifndef CONFIG_X86_64
+#ifdef CONFIG_X86_32
 	case 0x9a:	/* call absolute -- same as call absolute, indirect */
 		*tos = orig_ip + (*tos - copy_ip);
 		goto no_change;
@@ -813,8 +813,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 
 no_change:
 	restore_btf();
-
-	return;
 }
 
 /*
-- 
1.5.4.rc0.1143.g1a8a



