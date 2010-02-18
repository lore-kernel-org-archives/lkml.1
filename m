Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0BRNwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:52:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab0BRNwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:52:31 -0500
Message-ID: <4B7D4614.7040806@redhat.com>
Date: Thu, 18 Feb 2010 15:52:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 03/10] KVM: SVM: Fix schedule-while-atomic on nested exception
 handling
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <1266493115-28386-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266493115-28386-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> Move the actual vmexit routine out of code that runs with
> irqs and preemption disabled.
>
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |   20 +++++++++++++++++---
>   1 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7c96b8b..25d26ec 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -128,6 +128,7 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu);
>   static void svm_complete_interrupts(struct vcpu_svm *svm);
>
>   static int nested_svm_exit_handled(struct vcpu_svm *svm);
> +static int nested_svm_exit_handled_atomic(struct vcpu_svm *svm);
>   static int nested_svm_vmexit(struct vcpu_svm *svm);
>   static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   				      bool has_error_code, u32 error_code);
> @@ -1386,7 +1387,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   	svm->vmcb->control.exit_info_1 = error_code;
>   	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
>
> -	return nested_svm_exit_handled(svm);
> +	return nested_svm_exit_handled_atomic(svm);
>   }
>    

What do you say to


    if (nested_svm_intercepts(svm))
         svm->nested.exit_required = true;

here, and recoding nested_svm_exit_handled() to call 
nested_svm_intercepts()?  I think it improves readability a little by 
avoiding a function that changes behaviour according to how it is called.

Long term, we may want to split out the big switch into the individual 
handlers, to avoid decoding the exit reason twice.

-- 
error compiling committee.c: too many arguments to function

