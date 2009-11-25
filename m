Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbZKYMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbZKYMc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbZKYMcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732AbZKYMcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:32:54 -0500
Message-ID: <4B0D23E8.3060508@redhat.com>
Date: Wed, 25 Nov 2009 14:32:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 02/12] Add PV MSR to enable asynchronous page faults
 delivery.
References: <1258985167-29178-1-git-send-email-gleb@redhat.com> <1258985167-29178-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1258985167-29178-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 04:05 PM, Gleb Natapov wrote:
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    3 ++
>   arch/x86/include/asm/kvm_para.h |    2 +
>   arch/x86/kvm/x86.c              |   42 +++++++++++++++++++++++++++++++++++++-
>   include/linux/kvm.h             |    1 +
>   4 files changed, 46 insertions(+), 2 deletions(-)
>
>   #define MSR_KVM_WALL_CLOCK  0x11
>   #define MSR_KVM_SYSTEM_TIME 0x12
> +#define MSR_KVM_ASYNC_PF_EN 0x13
>    

Please use MSRs from the range 0x4b564dxx.  The numbers below are 
reserved by Intel (and in fact used by the old Pentiums).

Need documentation for the new MSR, say in Documentation/kvm/msr.txt.

> +static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	u64 gpa = data&  ~0x3f;
> +	int offset = offset_in_page(gpa);
> +	unsigned long addr;
> +
> +	addr = gfn_to_hva(vcpu->kvm, gpa>>  PAGE_SHIFT);
> +	if (kvm_is_error_hva(addr))
> +		return 1;
> +
> +	vcpu->arch.apf_data = (u32 __user*)(addr + offset);
> +
> +	/* check if address is mapped */
> +	if (get_user(offset, vcpu->arch.apf_data)) {
> +		vcpu->arch.apf_data = NULL;
> +		return 1;
> +	}
>    

What if the memory slot arrangement changes?  This needs to be 
revalidated (and gfn_to_hva() called again).

> +	return 0;
> +}
> +
>   int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   {
>   	switch (msr) {
> @@ -1029,6 +1049,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   		kvm_request_guest_time_update(vcpu);
>   		break;
>   	}
> +	case MSR_KVM_ASYNC_PF_EN:
> +		vcpu->arch.apf_msr_val = data;
> +		if (data&  1) {
> +			if (kvm_pv_enable_async_pf(vcpu, data))
> +				return 1;
>    

Need to check before setting the msr value, so subsequent reads return 
the old value.

> +		} else
> +			vcpu->arch.apf_data = NULL;
>    

Need to check that bits 1:5 are zero.  I think it's cleaner to move all 
of the code to kvm_pv_enable_async_pf(), to have everything in one place.


-- 
error compiling committee.c: too many arguments to function

