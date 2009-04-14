Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZDNJdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZDNJdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZDNJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:33:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZDNJdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:33:41 -0400
Message-ID: <49E45894.7090700@redhat.com>
Date: Tue, 14 Apr 2009 12:34:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1239653210-10422-1-git-send-email-glommer@redhat.com>
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
> If the instruction emulated is an sti, we have to block shadow interrupts.
> The same goes for mov ss. pop ss also needs it, but we don't currently
> emulate it. For sequences of two or more instructions of the same type
> among those instructions, only the first one has this effect.
>
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
>
>   

We'll defer this until after Gleb's patchset, since that's much bigger.

> +#define X86_SHADOW_INT_MOV_SS	1
> +#define X86_SHADOW_INT_STI	2
> +
>  struct x86_emulate_ctxt {
>  	/* Register state before/after emulation. */
>  	struct kvm_vcpu *vcpu;
> @@ -152,6 +155,10 @@ struct x86_emulate_ctxt {
>  	int mode;
>  	u32 cs_base;
>  
> +	/* interruptibility state, as a result of execution of STI or MOV SS */
> +	int interruptibility;
> +	int movss_int_flag, movss_int_flag_old;
> +
>   

bit masks are traditionally unsigned.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0bb4131..b1fc8b6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2364,7 +2364,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  			u16 error_code,
>  			int emulation_type)
>  {
> -	int r;
> +	int r, shadow_mask;
>  	struct decode_cache *c;
>  
>  	kvm_clear_exception_queue(vcpu);
> @@ -2412,8 +2412,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> +	vcpu->arch.emulate_ctxt.interruptibility = 0;
>  	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
>  
> +	shadow_mask = vcpu->arch.emulate_ctxt.interruptibility;
> +	kvm_x86_ops->interrupt_shadow_mask(vcpu, shadow_mask);
> +
>   

Emulation may have failed, in which case you don't want to update the 
interrupt shadow mask.

>  	if (vcpu->arch.pio.string)
>  		return EMULATE_DO_MMIO;
>  
> diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
> index d7c9f6f..1369a2e 100644
> --- a/arch/x86/kvm/x86_emulate.c
> +++ b/arch/x86/kvm/x86_emulate.c
> @@ -1360,6 +1360,10 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
>  	int io_dir_in;
>  	int rc = 0;
>  
> +	ctxt->movss_int_flag_old = ctxt->movss_int_flag;
> +
> +	ctxt->movss_int_flag = 0;
>   

This seem to be internal to the emulator.  However, instructions may be 
executed outside the emulator, invalidating movss_int_flag.  But see below.

> @@ -1610,6 +1614,14 @@ special_insn:
>  
>  		sel = c->src.val;
>  		if (c->modrm_reg <= 5) {
> +			if (c->modrm_reg == VCPU_SREG_SS) {
> +				if (ctxt->movss_int_flag_old)
> +					ctxt->interruptibility |=
> +						X86_SHADOW_INT_MOV_SS;
> +				else
> +					ctxt->movss_int_flag = 1;
> +			}
>   

The comment about repeating 'mov ss' in the manual has that wonderful 
word in it, May.  That means we're perfectly allowed to ignore it and 
just set the flag unconditionally.

I doubt we'll ever see a repeated 'mov ss', once is more than enough.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

