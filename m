Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbXH0QTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbXH0QTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbXH0QI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:08:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:60659 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760541AbXH0QIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:08:53 -0400
Message-ID: <46D2F680.9060100@qumranet.com>
Date: Mon, 27 Aug 2007 19:06:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Dor Laor <dor.laor@qumranet.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Refactor hypercall infrastructure
References: <11882278064002-git-send-email-aliguori@us.ibm.com> <1188227808405-git-send-email-aliguori@us.ibm.com> <11882278082826-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11882278082826-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This patch refactors the current hypercall infrastructure to better support live
> migration and SMP.  It eliminates the hypercall page by trapping the UD
> exception that would occur if you used the wrong hypercall instruction for the
> underlying architecture and replacing it with the right one lazily.
>
> It also introduces the infrastructure to probe for hypercall available via
> CPUID leaves 0x40000002 and 0x40000003.
>
> A fall-out of this patch is that the unhandled hypercalls no longer trap to
> userspace.  There is very little reason though to use a hypercall to communicate
> with userspace as PIO or MMIO can be used.  There is no code in tree that uses
> userspace hypercalls.
>
>   

Allowing userspace to handle hypercalls means that we can have block and 
net drivers in the kernel or userspace, reflecting user privileges and 
performance/flxibility tradeoffs.  I think that's an important feature 
to have.


>  void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	int i;
> @@ -1632,6 +1575,12 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->regs[VCPU_REGS_RBX] = 0;
>  	vcpu->regs[VCPU_REGS_RCX] = 0;
>  	vcpu->regs[VCPU_REGS_RDX] = 0;
> +
> +	if ((function & 0xFFFF0000) == 0x40000000) {
> +		emulate_paravirt_cpuid(vcpu, function);
> +		goto out;
> +	}
> +
>   

Hmm.  Suppose we expose kvm capabilities to host userspace instead, and 
let the host userspace decide which features to expose to the guest via 
the regular cpuid emulation?  That allows the qemu command line to 
control the feature set.

>  
> +static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
> +{
> +	int er;
> +	
> +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
> +
> +	/* we should only succeed here in the case of hypercalls which
> +	   cannot generate an MMIO event.  MMIO means that the emulator
> +	   is mistakenly allowing an instruction that should generate
> +	   a UD fault so it's a bug. */
> +	BUG_ON(er == EMULATE_DO_MMIO);
>   

It's a guest-triggerable bug; one vcpu can be issuing ud2-in-a-loop 
while the other replaces the instruction with something that does mmio.

> +
> +#define KVM_ENOSYS		ENOSYS
>   

A real number (well, an integer, not a real) here please.  I know that 
ENOSYS isn't going to change soon, but this file defines the kvm abi and 
I'd like it to be as independent as possible.

Let's start it at 1000 so that spurious "return 1"s or "return -1"s 
don't get translated into valid error numbers.

I really like the simplification to the guest/host interface that this 
patch brings.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

