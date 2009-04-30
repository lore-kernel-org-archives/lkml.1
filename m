Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZD3LvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZD3LvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZD3Lut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:50:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZD3Lus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:50:48 -0400
Message-ID: <49F99095.7060503@redhat.com>
Date: Thu, 30 Apr 2009 14:50:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1240929045-6970-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1240929045-6970-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> we currently unblock shadow interrupt state when we skip an instruction,
> but failing to do so when we actually emulate one. This blocks interrupts
> in key instruction blocks, in particular sti; hlt; sequences
>
> If the instruction emulated is an sti, we have to block shadow interrupts.
> The same goes for mov ss. pop ss also needs it, but we don't currently
> emulate it.
>
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cb306cf..9455a30 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -510,6 +510,8 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*interrupt_shadow_mask)(struct kvm_vcpu *vcpu, int mask);
>   

Can you verb this function?  set_interrupt_shadow would make it nicely 
complement get_interrupt_shadow.

> +	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>  	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
>  				unsigned char *hypercall_addr);
>  	int (*get_irq)(struct kvm_vcpu *vcpu);
>  
> +static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 ret = 0;
> +
> +	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
> +		ret |= (X86_SHADOW_INT_STI && X86_SHADOW_INT_MOV_SS);
> +	return ret;
> +}
>   

Hmm, if the guest runs an infinite emulated 'mov ss', it will keep 
toggling the MOV_SS bit, but STI will remain set, so we'll never allow 
an interrupt into the guest kernel.

> diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
> index d2664fc..797d41f 100644
> --- a/arch/x86/kvm/x86_emulate.c
> +++ b/arch/x86/kvm/x86_emulate.c
> @@ -1618,6 +1618,16 @@ special_insn:
>  		int err;
>  
>  		sel = c->src.val;
> +		if (c->modrm_reg == VCPU_SREG_SS) {
> +			u32 int_shadow =
> +				kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
> +			/* See sti emulation for an explanation of this */
> +			if ((int_shadow & X86_SHADOW_INT_MOV_SS))
> +				ctxt->interruptibility &= ~X86_SHADOW_INT_MOV_SS;
> +			else
> +				ctxt->interruptibility |= X86_SHADOW_INT_MOV_SS;
> +		}
>   

^=

> @@ -1846,10 +1856,23 @@ special_insn:
>  		ctxt->eflags &= ~X86_EFLAGS_IF;
>  		c->dst.type = OP_NONE;	/* Disable writeback. */
>  		break;
> -	case 0xfb: /* sti */
> +	case 0xfb: { /* sti */
> +		u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
> +		/*
> +		 * an sti; sti; sequence only disable interrupts for the first
> +		 * instruction. So, if the last instruction, be it emulated or
> +		 * not, left the system with the INT_STI flag enabled, it
> +		 * means that the last instruction is an sti. We should not
> +		 * leave the flag on in this case
> +		 */
> +		if ((int_shadow & X86_SHADOW_INT_STI))
> +			ctxt->interruptibility &= ~X86_SHADOW_INT_STI;
> +		else
> +			ctxt->interruptibility |= X86_SHADOW_INT_STI;
>   

^=

-- 
error compiling committee.c: too many arguments to function

