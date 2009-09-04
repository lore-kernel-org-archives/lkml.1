Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZIDQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZIDQHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZIDQHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:07:38 -0400
Received: from claw.goop.org ([74.207.240.146]:35533 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbZIDQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:07:38 -0400
Message-ID: <4AA13B4B.7020101@goop.org>
Date: Fri, 04 Sep 2009 09:07:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, 544145@bugs.debian.org,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org> <20090903223603.GA19945@wavehammer.waldi.eu.org>
In-Reply-To: <20090903223603.GA19945@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/09 15:36, Bastian Blank wrote:
> This function looks weird. It tries to restores the user code segment.
> But the documentation from AMD explicitely stat that the CS and SS are
> restored from the STAR register.

And STAR is always set with:

    wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);

so when using sysret to return to 32-bit, it:

    The CS selector value is set to MSR IA32_STAR[63:48]. The SS is set
    to IA32_STAR[63:48] + 8.

so CS is __USER32_CS and SS is __USER32_DS.

The code for xen_sysret32 is:

ENTRY(xen_sysret32)
	/*
	 * We're already on the usermode stack at this point, but
	 * still with the kernel gs, so we can easily switch back
	 */
	movq %rsp, PER_CPU_VAR(old_rsp)
	movq PER_CPU_VAR(kernel_stack), %rsp

	pushq $__USER32_DS
	pushq PER_CPU_VAR(old_rsp)
	pushq %r11
	pushq $__USER32_CS
	pushq %rcx

	pushq $VGCF_in_syscall
1:	jmp hypercall_iret

The iret frame is:

 	ss
 	rsp
 	rflags
 	cs
 	rip		<-- rsp

so this constructs a frame of:

	__USER32_DS
	user_esp
	user_eflags
	__USER32_CS
	user_eip	<-- kernel rsp

and then it does the iret hypercall.

But for some reason that's triggering a failsafe callback, which invokes
a GP.

    J
