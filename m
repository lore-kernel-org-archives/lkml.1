Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXHHNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXHHNsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXHHNsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:48:25 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33779 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbXHHNsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:48:24 -0400
Date: Wed, 8 Aug 2007 09:47:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <20070808133001.GD14419@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
 <20070808133001.GD14419@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 8 Aug 2007, Andi Kleen wrote:

> > If you were talking about the general iretq => INTERRUPT_RETURN, then the
> > answer is "Yes, they are sufficient". The first version of lguest ran the
> > guest kernel in ring 3 (using dual page tables for guest kernel and guest
> > user).  The current version I'm pushing runs lguest in ring 1, and the
> > entry.S code  worked for both.
>
> How do you implement system calls then?

/me working very hard to get lguest64 ready for public display

Here's a snippet from my version of core.c.  I've been thinking of ways to
optimize it, but for now it works fine. This was done for both ring 3 and
ring 1 lguest versions (this is the host running):


	/*
	 * Update the LSTAR to point to the HV syscall handler.
	 * Also update the fsbase if the guest uses one.
	 */
	wrmsrl(MSR_LSTAR, (unsigned long)HV_OFFSET(&lguest_syscall_trampoline));

[...]
	asm volatile ("pushq %2; pushq %%rsp; pushfq; pushq %3; call *%6;"
		      /* The stack we pushed is off by 8, due to the
previous pushq */
		      "addq $8, %%rsp"
		      : "=D"(foo), "=a"(bar)
		      : "i" (__KERNEL_DS), "i" (__KERNEL_CS), "0"
(vcpu->vcpu),
			"1"(get_idt_table()),
			"r" (sw_guest)
		      : "memory", "cc");

[...]
	/* restore old LSTAR */
	wrmsrl(MSR_LSTAR, vcpu->host_syscall);



Also in the switcher.S (The Hypervisor):

.global lguest_syscall_trampoline
	.type lguest_syscall_trampoline, @function
lguest_syscall_trampoline:
	/*
	 * Tricky, we don't have much to choose from here.
	 * The only way to get to our stack is with swapgs.
	 * but we need to save the stack too, so we have to play
	 * very carefully.
	 */
	swapgs
	/* now gs points to our VCPU Guest Data */

	/* first save the stack! */
	movq	%rsp, %gs:LGUEST_GUEST_DATA_regs_rsp

	/*
	 * x86 arch doesn't have an easy way to find out where
	 * gs is located. So we need to read the MSR. But first
	 * we need to save off the rcx, rax and rdx.
	 */
	movq	%rax, %gs:LGUEST_GUEST_DATA_regs_rax
	movq	%rdx, %gs:LGUEST_GUEST_DATA_regs_rdx
	movq	%rcx, %gs:LGUEST_GUEST_DATA_regs_rcx

	/* Need to read manual, does rdmsr clear
	 * the top 32 bits of rax? */
	xor	%rax, %rax

	movl  	$MSR_GS_BASE,%ecx
	rdmsr
	shl	$32, %rdx
	orq	%rax, %rdx

	movq	%rdx, %rsp

	/* see if we need to disable interrupts */
	testq	$(1<<9),  %gs:LGUEST_GUEST_DATA_SFMASK
	jz	1f
	movq	$0, %gs:LGUEST_GUEST_DATA_irq_enabled
	jmp	2f
1:
	/* Still need to clear bit 10 (just in case) */
	/*  (see lguest_iretq)			     */
	movq	$(1<<10), %rax
	not	%rax
	andq	%rax, %gs:LGUEST_GUEST_DATA_irq_enabled
2:
	/* put back the generic regs */
	movq	%gs:LGUEST_GUEST_DATA_regs_rdx, %rdx
	movq	%gs:LGUEST_GUEST_DATA_regs_rcx, %rcx
	movq	%gs:LGUEST_GUEST_DATA_regs_rax, %rax

	/* Is this a hypercall? */
	testq	$1, %gs:LGUEST_GUEST_DATA_is_hc
	jnz	handle_hcall

	/* We have 64 bytes to play with */
	addq	$LGUEST_GUEST_DATA_regs, %rsp

	/* do the swapgs if possible */
	testq	$1, %gs:LGUEST_GUEST_DATA_do_swapgs
	je	1f

	/* We now have a stack to use */
	/* go back to the guest's gs */
	swapgs
	DO_SWAPGS_USE_STACK
	/* and then back to HV gs */
	swapgs
1:
	/*
	 * The stack has 64 bytes of playing room.
	 * Which is enough to do a jump to the guest kernel.
	 * We store the guest LSTAR register in the scatch pad
	 * because we don't care if the guest messes with it.
	 * If it is a bad address, we fault from the guest side
	 * and we kill the guest. No harm done to the host.
	 */
	pushq	$(__KERNEL_DS | 1)
	pushq	%gs:LGUEST_GUEST_DATA_regs_rsp
	pushfq
	/* Make sure we have actual interrupts on */
	orq	$(1<<9), 0(%rsp)
	pushq	$(__KERNEL_CS | 1)
	pushq	%gs:LGUEST_GUEST_DATA_LSTAR

	swapgs
	iretq



NOTE: This is still under development, since I'm going with a new design
change to try to stay more in sync with lguest32.

-- Steve

