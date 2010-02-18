Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0BROcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:32:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab0BROcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:32:06 -0500
Message-ID: <4B7D4F62.3010903@redhat.com>
Date: Thu, 18 Feb 2010 16:32:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] KVM: SVM: Make lazy FPU switching work with nested
 svm
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <1266493115-28386-10-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266493115-28386-10-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> TDB.
>
>    

...

> @@ -973,6 +973,7 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
>
>   static void update_cr0_intercept(struct vcpu_svm *svm)
>   {
> +	struct vmcb *vmcb = svm->vmcb;
>   	ulong gcr0 = svm->vcpu.arch.cr0;
>   	u64 *hcr0 =&svm->vmcb->save.cr0;
>
> @@ -984,11 +985,25 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
>
>
>   	if (gcr0 == *hcr0&&  svm->vcpu.fpu_active) {
> -		svm->vmcb->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> -		svm->vmcb->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> +		vmcb->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> +		vmcb->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> +		if (is_nested(svm)) {
> +			struct vmcb *hsave = svm->nested.hsave;
> +
> +			hsave->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> +			hsave->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> +			vmcb->control.intercept_cr_read  |= svm->nested.intercept_cr_read;
> +			vmcb->control.intercept_cr_write |= svm->nested.intercept_cr_write;
>    

Why are the last two lines needed?

> +		}
>   	} else {
>   		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
>   		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
> +		if (is_nested(svm)) {
> +			struct vmcb *hsave = svm->nested.hsave;
> +
> +			hsave->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
> +			hsave->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
> +		}
>   	}
>   }
>    

Maybe it's better to call update_cr0_intercept() after a vmexit instead, 
to avoid this repetition, and since the if () may take a different 
branch for the nested guest and guest cr0.


-- 
error compiling committee.c: too many arguments to function

