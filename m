Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZG2NI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZG2NI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZG2NI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:08:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZG2NIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:08:54 -0400
Message-ID: <4A704AFF.8070702@redhat.com>
Date: Wed, 29 Jul 2009 16:13:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 03:56 PM, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |   30 +++++++++++++++++++++++-------
>   1 files changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 31467b1..9192c9a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -86,6 +86,15 @@ struct nested_state {
>
>   	/* gpa pointers to the real vectors */
>   	u64 vmcb_msrpm;
> +
> +	/* cache for intercepts of the guest */
> +	u16 intercept_cr_read;
> +	u16 intercept_cr_write;
> +	u16 intercept_dr_read;
> +	u16 intercept_dr_write;
> +	u32 intercept_exceptions;
> +	u64 intercept;
> +
>   };
>
>   struct vcpu_svm {
> @@ -1459,7 +1468,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
>   					void *arg2,
>   					void *opaque)
>   {
> -	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
>   	bool kvm_overrides = *(bool *)opaque;
>   	u32 exit_code = svm->vmcb->control.exit_code;
>
> @@ -1486,38 +1494,38 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
>   	switch (exit_code) {
>   	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
>   		u32 cr_bits = 1<<  (exit_code - SVM_EXIT_READ_CR0);
> -		if (nested_vmcb->control.intercept_cr_read&  cr_bits)
> +		if (svm->nested.intercept_cr_read&  cr_bits)
>   			return 1;
>   		break;
>   	}
>   	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
>   		u32 cr_bits = 1<<  (exit_code - SVM_EXIT_WRITE_CR0);
> -		if (nested_vmcb->control.intercept_cr_write&  cr_bits)
> +		if (svm->nested.intercept_cr_write&  cr_bits)
>   			return 1;
>   		break;
>   	}
>   	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
>   		u32 dr_bits = 1<<  (exit_code - SVM_EXIT_READ_DR0);
> -		if (nested_vmcb->control.intercept_dr_read&  dr_bits)
> +		if (svm->nested.intercept_dr_read&  dr_bits)
>   			return 1;
>   		break;
>   	}
>   	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
>   		u32 dr_bits = 1<<  (exit_code - SVM_EXIT_WRITE_DR0);
> -		if (nested_vmcb->control.intercept_dr_write&  dr_bits)
> +		if (svm->nested.intercept_dr_write&  dr_bits)
>   			return 1;
>   		break;
>   	}
>   	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
>   		u32 excp_bits = 1<<  (exit_code - SVM_EXIT_EXCP_BASE);
> -		if (nested_vmcb->control.intercept_exceptions&  excp_bits)
> +		if (svm->nested.intercept_exceptions&  excp_bits)
>   			return 1;
>   		break;
>   	}
>   	default: {
>   		u64 exit_bits = 1ULL<<  (exit_code - SVM_EXIT_INTR);
>   		nsvm_printk("exit code: 0x%x\n", exit_code);
> -		if (nested_vmcb->control.intercept&  exit_bits)
> +		if (svm->nested.intercept&  exit_bits)
>   			return 1;
>   	}
>   	}
> @@ -1808,6 +1816,14 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
>
>   	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
>
> +	/* cache intercepts */
> +	svm->nested.intercept_cr_read    = nested_vmcb->control.intercept_cr_read;
> +	svm->nested.intercept_cr_write   = nested_vmcb->control.intercept_cr_write;
> +	svm->nested.intercept_dr_read    = nested_vmcb->control.intercept_dr_read;
> +	svm->nested.intercept_dr_write   = nested_vmcb->control.intercept_dr_write;
> +	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
> +	svm->nested.intercept            = nested_vmcb->control.intercept;
> +
>   	force_new_asid(&svm->vcpu);
>   	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
>   	svm->vmcb->control.exit_int_info_err = nested_vmcb->control.exit_int_info_err;
>    

I don't see the benefit of this patch.  Accessing the cache is just as 
expensive as accessing the real vmcb.

-- 
error compiling committee.c: too many arguments to function

