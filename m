Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYCTUer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYCTUer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759882AbYCTU1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:27:54 -0400
Received: from gw.goop.org ([64.81.55.164]:51289 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759874AbYCTU1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:27:52 -0400
Message-ID: <47E2C7E3.40109@goop.org>
Date: Thu, 20 Mar 2008 13:24:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu>
In-Reply-To: <20080319235212.GA22786@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> turns out that i have another bug which causes a screaming IRQ#0 that 
> floods the box at 70K irqs/sec. That is what triggered that crash in 
> your patch most likely.
>
> so either figure out the bug by review or try turning your IRQ#0 into a 
> screaming one for debug purposes. (hint: turning irq#0's trigger mode 
> from 'edge' to 'level' in mpparse.c or ioapic.c does wonders to that end 
> ;-)
>   

Hm.  I think the problem was that the patch changed the ordering so that 
the %ebp fault test was happening with interrupts disabled, meaning that 
any fault-in would happen with interrupts disabled.

Could you tell me if this revised patch still provokes a problem?

Thanks,
    J

Subject: x86: only enable interrupts when kernel state has been set up

The sysenter path tries to enable interrupts immediately.  Unfortunately
this doesn't work in a paravirt environment, because not enough kernel
state has been set up at that point (namely, pointing %fs to the kernel
percpu data segment).  To fix this, defer ENABLE_INTERRUPTS until after
the kernel state has been set up.

Unfortunately this means that we're running with interrupts disabled
for a while without calling the IRQ tracing code, but that can't be
called without setting up %fs either.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -290,10 +290,10 @@ ENTRY(ia32_sysenter_target)
 	movl TSS_sysenter_sp0(%esp),%esp
 ENTRY(sysenter_past_esp)
 	/*
-	 * No need to follow this irqs on/off section: the syscall
-	 * disabled irqs and here we enable it straight after entry:
+	 * Interrupts are disabled here, but we can't trace it until
+	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
+	 * we immediately enable interrupts at that point anyway.
 	 */
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $(__USER_DS)
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET ss, 0*/
@@ -314,6 +314,11 @@ ENTRY(sysenter_past_esp)
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
 
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	ENABLE_INTERRUPTS(CLBR_NONE)
+
 /*
  * Load the potential sixth argument from user stack.
  * Careful about security.
@@ -321,14 +326,12 @@ ENTRY(sysenter_past_esp)
 	cmpl $__PAGE_OFFSET-3,%ebp
 	jae syscall_fault
 1:	movl (%ebp),%ebp
+	movl %ebp,PT_EBP(%esp)
 .section __ex_table,"a"
 	.align 4
 	.long 1b,syscall_fault
 .previous
 
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
@@ -542,9 +545,6 @@ END(syscall_exit_work)
 
 	RING0_INT_FRAME			# can't unwind into user space anyway
 syscall_fault:
-	pushl %eax			# save orig_eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace

