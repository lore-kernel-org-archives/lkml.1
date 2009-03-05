Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZCERym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZCERym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZCERyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:54:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbZCERyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:54:31 -0500
Date: Thu, 5 Mar 2009 14:53:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kvm/x86/svm: force new asid on vcpu migration
Message-ID: <20090305175333.GA2169@amt.cnet>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236255153-4432-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:12:28PM +0100, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1821c20..0e66bca 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -180,7 +180,7 @@ static inline void kvm_write_cr2(unsigned long val)
>  
>  static inline void force_new_asid(struct kvm_vcpu *vcpu)
>  {
> -	to_svm(vcpu)->asid_generation--;
> +	to_svm(vcpu)->asid_generation = 0;
>  }

Won't the per-cpu asig_generation overflow at some point? 

And can this comparison in pre_svm_run ever be true:

        if (svm->vcpu.cpu != cpu

?

>  static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
> @@ -716,6 +716,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		svm->vmcb->control.tsc_offset += delta;
>  		vcpu->cpu = cpu;
>  		kvm_migrate_timers(vcpu);
> +		force_new_asid(vcpu);
>  	}
>  
>  	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)


