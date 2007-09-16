Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXIPJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXIPJIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 05:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXIPJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 05:08:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:45604 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbXIPJIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 05:08:37 -0400
Message-ID: <46ECF288.9080709@qumranet.com>
Date: Sun, 16 Sep 2007 11:08:24 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Dor Laor <dor.laor@qumranet.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] Refactor hypercall infrastructure (v2)
References: <11898788932902-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11898788932902-git-send-email-aliguori@us.ibm.com>
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
> CPUID leaves 0x40001000.  CPUID leaf 0x40001001 should be filled out by
> userspace.
>
> A fall-out of this patch is that the unhandled hypercalls no longer trap to
> userspace.  There is very little reason though to use a hypercall to communicate
> with userspace as PIO or MMIO can be used.  There is no code in tree that uses
> userspace hypercalls.
>
> Since the last patchset, I've changed the CPUID leaves to better avoid Xen's
> CPUID range and fixed a bug spotted by Muli in masking off hypercall arguments.
>
> Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
>
> @@ -1721,6 +1657,18 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->regs[VCPU_REGS_RBX] = 0;
>  	vcpu->regs[VCPU_REGS_RCX] = 0;
>  	vcpu->regs[VCPU_REGS_RDX] = 0;
> +
> +	if (function == KVM_CPUID_SIGNATURE) {
> +		u32 signature[3];
> +
> +		memcpy(signature, "LinuxPVLinux", 12);
> +		vcpu->regs[VCPU_REGS_RAX] = 0;
> +		vcpu->regs[VCPU_REGS_RBX] = signature[0];
> +		vcpu->regs[VCPU_REGS_RCX] = signature[1];
> +		vcpu->regs[VCPU_REGS_RDX] = signature[2];
> +		goto out;
> +	}
> +
>   

This needs to be done from userspace, so that kvm can pretend not to 
have this leaf.

(I have no objection to our userspace doing it unconditionally; but I 
don't want to force it on others)

Also, the signature string is too generic.

> diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
> index 18c2b2c..1362082 100644
> --- a/drivers/kvm/x86_emulate.c
> +++ b/drivers/kvm/x86_emulate.c
>   


Please split out the emulator changes.

> - *
> - * 64-bit parameters 1-6 are in the standard gcc x86_64 calling convention
> - * order: RDI, RSI, RDX, RCX, R8, R9.
> - *
> - * 32-bit index is EBX, parameters are: EAX, ECX, EDX, ESI, EDI, EBP.
> - * (the first 3 are according to the gcc regparm calling convention)
>   

Please document the new ABI.

-- 
error compiling committee.c: too many arguments to function

