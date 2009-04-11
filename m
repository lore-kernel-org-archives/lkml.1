Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZDKMEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZDKMEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZDKMEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:04:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbZDKMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:04:21 -0400
Message-ID: <49E08762.1010206@redhat.com>
Date: Sat, 11 Apr 2009 15:04:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com> <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Thu, 2009-04-09 at 23:50 +0800, Avi Kivity wrote:
>   
>> Huang Ying wrote:
>>     
>>> +int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>>> +{
>>> +	switch (msr) {
>>> +	case MSR_EFER:
>>> +		set_efer(vcpu, data);
>>>  		break;
>>>  	case MSR_IA32_DEBUGCTLMSR:
>>>  		if (!data) {
>>> @@ -807,6 +828,8 @@ int kvm_set_msr_common(struct kvm_vcpu *
>>>  		break;
>>>  	}
>>>  	default:
>>> +		if (!set_msr_mce(vcpu, msr, data))
>>> +		    break;
>>>  		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
>>>  		return 1;
>>>  	}
>>>   
>>>       
>> Is there any reason you split kvm_set_msr_common() into two functions?
>>     
>
> I want to group MCE related MSR together. And most MCE MSR read/write
> need to access vcpu->arch.mcg_xxx or vcpu->arch_mce_banks, So I think
> use a MCE specific function would be cleaner.
>
> But It seems that something as follow would be better.
>
> kvm_set_msr_comm()
> {
> 	switch (msr) {
> 	case MSR_IA32_P5_MC_ADDR:
> 	case MSR_IA32_P5_MC_TYPE:
> 	case MSR_IA32_MCG_CAP:
> 	case MSR_IA32_MCG_CTL:
> 	case MSR_IA32_MCG_STATUS:
> 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_MISC + 4 * KVM_MCE_MAX_BANK:
> 		set_msr_mce();
> 		break;
> 	...
> 	}
> 	...
> }
>
>   

Yes.  Just make sure KVM_MCE_MAX_BANK (better change to KVM_MCE_NR_BANK, 
with MAX you never know if it's the index of the last bank or the number 
of banks) doesn't conflict with any other MSRs.

>>> +
>>> +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>>> +{
>>> +	u64 data;
>>> +
>>> +	switch (msr) {
>>> +	case 0xc0010010: /* SYSCFG */
>>> +	case 0xc0010015: /* HWCR */
>>>   
>>>       
>> Please use MSR_ constants (add them if they don't exist yet).
>>     
>
> In fact, this is not added by me. But I can change this by the way.
>   

Oh okay.  So don't change them in this patch.

>> Why not always allocate it on vcpu setup?
>>     
>
> Because the MCE bank number is not fixed, it is based on mcg_cap from
> user space.
>   

Right, but we can allocate the maximum number, no?  it's a fairly small 
amount of memory.

>   
>>> +static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>>> +				      struct kvm_x86_mce *mce)
>>> +{
>>> +	u64 mcg_cap = vcpu->arch.mcg_cap;
>>> +	unsigned bank_num = mcg_cap & 0xff;
>>> +	u64 *banks = vcpu->arch.mce_banks;
>>> +
>>> +	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
>>> +		return -EINVAL;
>>> +	/*
>>> +	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
>>> +	 * reporting is disabled
>>> +	 */
>>> +	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
>>> +	    vcpu->arch.mcg_ctl != ~(u64)0)
>>> +		return 0;
>>> +	banks += 4 * mce->bank;
>>> +	/*
>>> +	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
>>> +	 * reporting is disabled for the bank
>>> +	 */
>>> +	if ((mce->status & MCI_STATUS_UC) && banks[0] != ~(u64)0)
>>> +		return 0;
>>> +	if (mce->status & MCI_STATUS_UC) {
>>> +		u64 status = mce->status;
>>> +		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
>>> +		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
>>> +			printk(KERN_DEBUG "kvm: set_mce: "
>>> +			       "injects mce exception while "
>>> +			       "previous one is in progress!\n");
>>> +			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
>>> +			return 0;
>>> +		}
>>> +		if (banks[1] & MCI_STATUS_VAL)
>>> +			status |= MCI_STATUS_OVER;
>>> +		banks[1] = mce->status;
>>> +		banks[2] = mce->addr;
>>> +		banks[3] = mce->misc;
>>> +		vcpu->arch.mcg_status = mce->mcg_status;
>>> +		kvm_queue_exception(vcpu, MC_VECTOR);
>>> +	} else if (!(banks[1] & MCI_STATUS_VAL) ||
>>> +		   (!(banks[1] & MCI_STATUS_UC) &&
>>> +		    !((mcg_cap & MCG_TES_P) && ((banks[1]>>53) & 0x3) < 2))) {
>>> +		u64 status = mce->status;
>>> +		if (banks[1] & MCI_STATUS_VAL)
>>> +			status |= MCI_STATUS_OVER;
>>> +		banks[1] = mce->status;
>>> +		banks[2] = mce->addr;
>>> +		banks[3] = mce->misc;
>>> +	} else
>>> +		banks[1] |= MCI_STATUS_OVER;
>>> +	return 0;
>>> +}
>>>   
>>>       
>> Can userspace just use KVM_SET_MSR for this?
>>     
>
> In addition to assigning MSR, we have some other logic for MCE, such as
> BANK reporting disabling, overwriting rules, triple fault for UC MCE
> during MCIP. So I think we need some dedicate interface.
>   

Yes, you're right.

>   
>>> +	case KVM_X86_SETUP_MCE: {
>>> +		u64 mcg_cap;
>>> +
>>> +		r = -EFAULT;
>>> +		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
>>> +			goto out;
>>> +		/*
>>> +		 * extended machine-check state registers and CMCI are
>>> +		 * not supported.
>>> +		 */
>>> +		mcg_cap &= ~(MCG_EXT_P|MCG_CMCI_P);
>>>   
>>>       
>> Instead of silently dropping, should return an error.
>>
>>     
>>> +		if (copy_to_user(argp, &mcg_cap, sizeof mcg_cap))
>>> +			goto out;
>>>   
>>>       
>> And not copy.
>>     
>
> This is designed as some kind of feature negotiating. Use space request
> MCE features via mcg_cap, kernel space remove un-supported features and
> return the resulting mcg_cap.
>   

kvm does feature negotiation (really, feature advertising) using 
KVM_CAP_... and KVM_CHECK_EXTENSION.  So there's no need for this.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

