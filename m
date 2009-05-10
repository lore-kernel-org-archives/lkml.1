Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZEJNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZEJNIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZEJNIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:08:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbZEJNIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:08:32 -0400
Message-ID: <4A06D192.2010501@redhat.com>
Date: Sun, 10 May 2009 16:07:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/2] replace drop_interrupt_shadow by set_interrupt_shadow
References: <1241814187-5973-1-git-send-email-glommer@redhat.com> <1241814187-5973-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1241814187-5973-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> This patch replaces drop_interrupt_shadow with the more
> general set_interrupt_shadow, that can either drop or raise
> it, depending on its parameter.
>
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> +	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>   

Would be better to make these symmetric in their mask types.

> +++ b/arch/x86/kvm/svm.c
> @@ -202,6 +202,27 @@ static int is_external_interrupt(u32 info)
>  	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>  }
>  
> +static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 ret = 0;
> +
> +	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
> +		ret |= (X86_SHADOW_INT_STI && X86_SHADOW_INT_MOV_SS);
>   

&& -> |.  Parentheses unnecessary.

>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -2637,6 +2652,8 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.run = svm_vcpu_run,
>  	.handle_exit = handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
> +	.set_interrupt_shadow= svm_set_interrupt_shadow,
>   

Missing space.

> +static void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	u32 interruptibility_old = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> +	u32 interruptibility = interruptibility_old;
> +
> +	switch (mask) {
> +	case 0:
> +		interruptibility &= ~((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
> +		break;
>   

Need to clear this unconditionally, otherwise 'sti; mov ss' will set 
both flags.

> +	case X86_SHADOW_INT_MOV_SS:
> +		interruptibility |= GUEST_INTR_STATE_MOV_SS;
> +		break;
> +	case X86_SHADOW_INT_STI:
> +		interruptibility |= GUEST_INTR_STATE_STI;
> +		break;
> +	default:
> +		printk(KERN_ERR "Bogus mask for interrupt shadow!\n");
> +	}
>   

I suggest we deal with the case where both are set.  One day we'll live 
migrate this state, and if we come from an AMD host, we might get this 
state.

-- 
error compiling committee.c: too many arguments to function

