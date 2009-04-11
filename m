Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZDKQiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZDKQiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZDKQiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:38:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbZDKQiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:38:11 -0400
Message-ID: <49E0C767.8060603@redhat.com>
Date: Sat, 11 Apr 2009 19:37:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239226966-8205-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1239226966-8205-1-git-send-email-glommer@redhat.com>
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
> emulate it. For sequences of two or more instructions of the same type
> among those instructions, only the first one has this effect.
>
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
>
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -513,6 +513,8 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*block_interrupt_shadow)(struct kvm_vcpu *vcpu);
> +	void (*unblock_interrupt_shadow)(struct kvm_vcpu *vcpu);
>   

set_interrupt_shadow(), clear_interrupt_shadow().  The interrupt shadow 
blocks interrupts, but what happens when you block the interrupt shadow?

Maybe better to fold into one callback with a parameter.

>  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt,
> -		     struct x86_emulate_ops *ops);
> +		     struct x86_emulate_ops *ops, int *interruptibility);
>   

Add to x86_emulate_ctxt, there's already some

>  
> +static void svm_block_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
> +	vcpu->arch.interrupt_window_open = 0;
> +}
> +
> +static void svm_unblock_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
> +	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
>   

If eflags.if = 0, the interrupt window is closed.

> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c6997c0..5158c2b 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -736,26 +736,45 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	vmcs_writel(GUEST_RFLAGS, rflags);
>  }
>  
> -static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
> +static void vmx_block_interrupt_shadow(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long rip;
> -	u32 interruptibility;
> +	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> +	u32 interruptibility_mask = ((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
>  
> -	rip = kvm_rip_read(vcpu);
> -	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
> -	kvm_rip_write(vcpu, rip);
> +	if (!(interruptibility & interruptibility_mask))
> +		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
> +			     interruptibility | interruptibility_mask);
> +	vcpu->arch.interrupt_window_open = 0;
>   

Setting both _MOV_SS and _STI is wierd; can't happen on real hardware.

>  {
>  	unsigned long memop = 0;
>  	u64 msr_data;
> @@ -1359,6 +1360,10 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
>  	unsigned int port;
>  	int io_dir_in;
>  	int rc = 0;
> +	static int movss_int_flag, movss_int_flag_old;
>   

static, for shame.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

