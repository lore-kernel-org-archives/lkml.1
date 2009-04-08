Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbZDHTtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbZDHTtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbZDHTsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:48:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZDHTsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:48:54 -0400
Date: Wed, 8 Apr 2009 22:48:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
Message-ID: <20090408194850.GE18521@redhat.com>
References: <1239213452-5966-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239213452-5966-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:57:32PM -0400, Glauber Costa wrote:
> we currently unblock shadow interrupt state when we skip an instruction,
> but failing to do so when we actually emulate one. This blocks interrupts
> in key instruction blocks, in particular sti; hlt; sequences
> 
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/svm.c              |   12 ++++++++++--
>  arch/x86/kvm/vmx.c              |   29 +++++++++++++++++++----------
>  arch/x86/kvm/x86.c              |    2 ++
>  4 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3fc4623..0890a6e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -513,6 +513,7 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*block_interrupt_shadow)(struct kvm_vcpu *vcpu);
remove_interrupt_shadow or unblock_interrupt_shadow would be better
names IMHO.

>  	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
>  				unsigned char *hypercall_addr);
>  	int (*get_irq)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 3ffb695..d303e86 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -210,6 +210,14 @@ static int is_external_interrupt(u32 info)
>  	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>  }
>  
> +static void svm_block_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
> +	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
> +}
> +
>  static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -223,9 +231,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  		       __func__, kvm_rip_read(vcpu), svm->next_rip);
>  
>  	kvm_rip_write(vcpu, svm->next_rip);
> -	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
>  
> -	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
> +	svm_block_interrupt_shadow(vcpu);
>  }
>  
>  static int has_svm(void)
> @@ -2660,6 +2667,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.run = svm_vcpu_run,
>  	.handle_exit = handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
> +	.block_interrupt_shadow = svm_block_interrupt_shadow,
>  	.patch_hypercall = svm_patch_hypercall,
>  	.get_irq = svm_get_irq,
>  	.set_irq = svm_set_irq,
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
>  static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long rip;
> -	u32 interruptibility;
>  
>  	rip = kvm_rip_read(vcpu);
>  	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>  	kvm_rip_write(vcpu, rip);
>  
> -	/*
> -	 * We emulated an instruction, so temporary interrupt blocking
> -	 * should be removed, if set.
> -	 */
> -	interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> -	if (interruptibility & 3)
> -		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
> -			     interruptibility & ~3);
> -	vcpu->arch.interrupt_window_open = 1;
> +	/* skipping an emulated instruction also counts */
> +	vmx_block_interrupt_shadow(vcpu);
>  }
>  
> +
>  static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
>  				bool has_error_code, u32 error_code)
>  {
> @@ -3727,6 +3735,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>  	.run = vmx_vcpu_run,
>  	.handle_exit = vmx_handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
> +	.block_interrupt_shadow = vmx_block_interrupt_shadow,
>  	.patch_hypercall = vmx_patch_hypercall,
>  	.get_irq = vmx_get_irq,
>  	.set_irq = vmx_inject_irq,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0bb4131..8fa83b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2414,6 +2414,8 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  
>  	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
>  
> +	kvm_x86_ops->block_interrupt_shadow(vcpu);
> +
>  	if (vcpu->arch.pio.string)
>  		return EMULATE_DO_MMIO;
>  
> -- 
> 1.5.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
