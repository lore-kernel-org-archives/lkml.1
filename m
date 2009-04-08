Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbZDHSQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbZDHSQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbZDHSQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:16:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbZDHSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:16:29 -0400
Message-ID: <49DCE9E5.8020703@zytor.com>
Date: Wed, 08 Apr 2009 11:16:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
References: <1239213452-5966-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1239213452-5966-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> we currently unblock shadow interrupt state when we skip an instruction,
> but failing to do so when we actually emulate one. This blocks interrupts
> in key instruction blocks, in particular sti; hlt; sequences
> 
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c6997c0..cee38e4 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -736,26 +736,34 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	vmcs_writel(GUEST_RFLAGS, rflags);
>  }
>  
> +static void vmx_block_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * We emulated an instruction, so temporary interrupt blocking
> +	 * should be removed, if set.
> +	 */
> +	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> +	u32 interruptibility_mask = ((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
> +
> +	if (interruptibility & interruptibility_mask)
> +		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
> +			     interruptibility & ~interruptibility_mask);
> +	vcpu->arch.interrupt_window_open = 1;
> +}
> +

How does this logic work when the instruction emulated is an STI or MOV 
SS instruction?  In particular, when does GUEST_INTERRUPTIBILITY_INFO 
sets set to reflect the *blocking* operation?

The pseudo-code for this kind of stuff looks like:


forever {
	tmp_int_flags <- int_flags

	/* Begin instruction execution */
	int_flags |= GUEST_INTR_STATE_STI	/* STI instruction */
	/* End instruction execution */

	int_flags &= ~tmp_int_flags

	if (irq_pending && eflags.if == 1 && int_flags == 0)
		take_interrupt();
}

Note the behavior in the case of sequential STIs, that int_flags goes to 
0 after the second execution.

	-hpa
