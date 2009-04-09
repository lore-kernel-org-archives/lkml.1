Return-Path: <linux-kernel-owner+w=401wt.eu-S935536AbZDIPvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536AbZDIPvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZDIPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:51:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbZDIPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:51:06 -0400
Message-ID: <49DE195D.1020303@redhat.com>
Date: Thu, 09 Apr 2009 18:50:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Add MCE support to KVM. The related MSRs are emulated. A new vcpu
> ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation such as
> the mcg_cap. MCE is injected via vcpu ioctl command
> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
> not implemented.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  arch/x86/include/asm/kvm_host.h |    5 
>  arch/x86/include/asm/mce.h      |    1 
>  arch/x86/kvm/x86.c              |  202 +++++++++++++++++++++++++++++++++++-----
>  include/linux/kvm.h             |   15 ++
>  4 files changed, 199 insertions(+), 24 deletions(-)
>
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -42,6 +42,7 @@
>  #include <asm/msr.h>
>  #include <asm/desc.h>
>  #include <asm/mtrr.h>
> +#include <asm/mce.h>
>  
>  #define MAX_IO_MSRS 256
>  #define CR0_RESERVED_BITS						\
> @@ -734,23 +735,43 @@ static int set_msr_mtrr(struct kvm_vcpu 
>  	return 0;
>  }
>  
> -int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> +static int set_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
> +	u64 mcg_cap = vcpu->arch.mcg_cap;
> +	unsigned bank_num = mcg_cap & 0xff;
> +
>  	switch (msr) {
> -	case MSR_EFER:
> -		set_efer(vcpu, data);
> -		break;
> -	case MSR_IA32_MC0_STATUS:
> -		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
> -		       __func__, data);
> -		break;
>  	case MSR_IA32_MCG_STATUS:
> -		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
> -			__func__, data);
> +		vcpu->arch.mcg_status = data;
>  		break;
>  	case MSR_IA32_MCG_CTL:
> -		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_CTL 0x%llx, nop\n",
> -			__func__, data);
> +		if (!(mcg_cap & MCG_CTL_P))
> +			return 1;
> +		if (data != 0 && data != ~(u64)0)
> +			return -1;
> +		vcpu->arch.mcg_ctl = data;
> +		break;
> +	default:
> +		if (msr >= MSR_IA32_MC0_CTL &&
> +		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
> +			u32 offset = msr - MSR_IA32_MC0_CTL;
> +			/* only 0 or all 1s can be written to IA32_MCi_CTL */
> +			if ((offset & 0x3) == 0 &&
> +			    data != 0 && data != ~(u64)0)
> +				return -1;
> +			vcpu->arch.mce_banks[offset] = data;
> +			break;
> +		}
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> +{
> +	switch (msr) {
> +	case MSR_EFER:
> +		set_efer(vcpu, data);
>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!data) {
> @@ -807,6 +828,8 @@ int kvm_set_msr_common(struct kvm_vcpu *
>  		break;
>  	}
>  	default:
> +		if (!set_msr_mce(vcpu, msr, data))
> +		    break;
>  		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
>  		return 1;
>  	}
>   

Is there any reason you split kvm_set_msr_common() into two functions?

>  
> -int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> +static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  {
>  	u64 data;
> +	u64 mcg_cap = vcpu->arch.mcg_cap;
> +	unsigned bank_num = mcg_cap & 0xff;
>  
>  	switch (msr) {
> -	case 0xc0010010: /* SYSCFG */
> -	case 0xc0010015: /* HWCR */
> -	case MSR_IA32_PLATFORM_ID:
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
> -	case MSR_IA32_MC0_CTL:
> -	case MSR_IA32_MCG_STATUS:
> +		data = 0;
> +		break;
>  	case MSR_IA32_MCG_CAP:
> +		data = vcpu->arch.mcg_cap;
> +		break;
>  	case MSR_IA32_MCG_CTL:
> -	case MSR_IA32_MC0_MISC:
> -	case MSR_IA32_MC0_MISC+4:
> -	case MSR_IA32_MC0_MISC+8:
> -	case MSR_IA32_MC0_MISC+12:
> -	case MSR_IA32_MC0_MISC+16:
> -	case MSR_IA32_MC0_MISC+20:
> +		if (!(mcg_cap & MCG_CTL_P))
> +			return 1;
> +		data = vcpu->arch.mcg_ctl;
> +		break;
> +	case MSR_IA32_MCG_STATUS:
> +		data = vcpu->arch.mcg_status;
> +		break;
> +	default:
> +		if (msr >= MSR_IA32_MC0_CTL &&
> +		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
> +			u32 offset = msr - MSR_IA32_MC0_CTL;
> +			data = vcpu->arch.mce_banks[offset];
> +			break;
> +		}
> +		return 1;
> +	}
> +	*pdata = data;
> +	return 0;
> +}
> +
> +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> +{
> +	u64 data;
> +
> +	switch (msr) {
> +	case 0xc0010010: /* SYSCFG */
> +	case 0xc0010015: /* HWCR */
>   

Please use MSR_ constants (add them if they don't exist yet).

> +	case MSR_IA32_PLATFORM_ID:
>  	case MSR_IA32_UCODE_REV:
>  	case MSR_IA32_EBL_CR_POWERON:
>  	case MSR_IA32_DEBUGCTLMSR:
> @@ -921,6 +967,8 @@ int kvm_get_msr_common(struct kvm_vcpu *
>  		data = vcpu->arch.time;
>  		break;
>  	default:
> +		if (!get_msr_mce(vcpu, msr, &data))
> +			break;
>  		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
>  		return 1;
>  	}
> @@ -1443,6 +1491,87 @@ static int vcpu_ioctl_tpr_access_reporti
>  	return 0;
>  }
>   

Again, why split?

>  
> +static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> +					u64 mcg_cap)
> +{
> +	int r;
> +	unsigned bank_num = mcg_cap & 0xff, bank;
> +	u64 *banks;
> +
> +	r = -EINVAL;
> +	if (!bank_num)
> +		goto out;
> +	r = -ENOMEM;
> +	banks = kzalloc(bank_num * sizeof(u64) * 4, GFP_KERNEL);
>   

If banks is already allocated, you'll leak it.

Why not always allocate it on vcpu setup?

> +static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> +				      struct kvm_x86_mce *mce)
> +{
> +	u64 mcg_cap = vcpu->arch.mcg_cap;
> +	unsigned bank_num = mcg_cap & 0xff;
> +	u64 *banks = vcpu->arch.mce_banks;
> +
> +	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
> +		return -EINVAL;
> +	/*
> +	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
> +	 * reporting is disabled
> +	 */
> +	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
> +	    vcpu->arch.mcg_ctl != ~(u64)0)
> +		return 0;
> +	banks += 4 * mce->bank;
> +	/*
> +	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
> +	 * reporting is disabled for the bank
> +	 */
> +	if ((mce->status & MCI_STATUS_UC) && banks[0] != ~(u64)0)
> +		return 0;
> +	if (mce->status & MCI_STATUS_UC) {
> +		u64 status = mce->status;
> +		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
> +		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
> +			printk(KERN_DEBUG "kvm: set_mce: "
> +			       "injects mce exception while "
> +			       "previous one is in progress!\n");
> +			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
> +			return 0;
> +		}
> +		if (banks[1] & MCI_STATUS_VAL)
> +			status |= MCI_STATUS_OVER;
> +		banks[1] = mce->status;
> +		banks[2] = mce->addr;
> +		banks[3] = mce->misc;
> +		vcpu->arch.mcg_status = mce->mcg_status;
> +		kvm_queue_exception(vcpu, MC_VECTOR);
> +	} else if (!(banks[1] & MCI_STATUS_VAL) ||
> +		   (!(banks[1] & MCI_STATUS_UC) &&
> +		    !((mcg_cap & MCG_TES_P) && ((banks[1]>>53) & 0x3) < 2))) {
> +		u64 status = mce->status;
> +		if (banks[1] & MCI_STATUS_VAL)
> +			status |= MCI_STATUS_OVER;
> +		banks[1] = mce->status;
> +		banks[2] = mce->addr;
> +		banks[3] = mce->misc;
> +	} else
> +		banks[1] |= MCI_STATUS_OVER;
> +	return 0;
> +}
>   

Can userspace just use KVM_SET_MSR for this?

> +	case KVM_X86_SETUP_MCE: {
> +		u64 mcg_cap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
> +			goto out;
> +		/*
> +		 * extended machine-check state registers and CMCI are
> +		 * not supported.
> +		 */
> +		mcg_cap &= ~(MCG_EXT_P|MCG_CMCI_P);
>   

Instead of silently dropping, should return an error.

> +		if (copy_to_user(argp, &mcg_cap, sizeof mcg_cap))
> +			goto out;
>   

And not copy.



>  #define KVM_TRC_SHIFT           16
>  /*
>   * kvm trace categories
> @@ -528,6 +540,9 @@ struct kvm_irq_routing {
>  #define KVM_NMI                   _IO(KVMIO,  0x9a)
>  /* Available with KVM_CAP_SET_GUEST_DEBUG */
>  #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debug)
> +/* MCE for x86 */
> +#define KVM_X86_SETUP_MCE           _IOWR(KVMIO,  0x9a, __u64)
> +#define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9b, struct kvm_x86_mce)
>   

Please add a KVM_CAP_ to advertise this capability.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

