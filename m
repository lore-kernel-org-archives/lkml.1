Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYGVTKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYGVTKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYGVTKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:10:31 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:33998 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYGVTKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:10:30 -0400
Subject: Re: [PATCH 1/2] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in
	error handling code
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Julia Lawall <julia@diku.dk>
Cc: avi@qumranet.com, kvm@vger.kernel.org, xiantao.zhang@intel.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807221843140.2670@ask.diku.dk>
References: <Pine.LNX.4.64.0807221843140.2670@ask.diku.dk>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 21:11:04 +0200
Message-Id: <1216753864.28082.11.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tir, 22 07 2008 kl. 18:44 +0200, skrev Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> There is a call to local_irq_restore in the normal exit case, so it would
> seem that there should be one on an error return as well.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression l;
> expression E,E1,E2;
> @@
> 
> local_irq_save(l);
> ... when != local_irq_restore(l)
>     when != spin_unlock_irqrestore(E,l)
>     when any
>     when strict
> (
> if (...) { ... when != local_irq_restore(l)
>                when != spin_unlock_irqrestore(E1,l)
> +   local_irq_restore(l);
>     return ...;
> }
> |
> if (...)
> +   {local_irq_restore(l);
>     return ...;
> +   }
> |
> spin_unlock_irqrestore(E2,l);
> |
> local_irq_restore(l);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/ia64/kvm/kvm-ia64.c      |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index 318b811..14e5c99 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -125,8 +125,10 @@ void kvm_arch_hardware_enable(void *garbage)
>  				PAGE_KERNEL));
>  	local_irq_save(saved_psr);
>  	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
> -	if (slot < 0)
> +	if (slot < 0) {
> +		local_irq_restore(saved_psr);
>  		return;
> +	}
>  	local_irq_restore(saved_psr);

If this change makes sense, how about merging the two local_irq_restore
calls and put them before the if? And shouldn't your checker be able to
figure this?

>  
>  	spin_lock(&vp_lock);
> @@ -160,8 +162,10 @@ void kvm_arch_hardware_disable(void *garbage)
>  
>  	local_irq_save(saved_psr);
>  	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
> -	if (slot < 0)
> +	if (slot < 0) {
> +		local_irq_restore(saved_psr);
>  		return;
> +	}
>  	local_irq_restore(saved_psr);
>  
Same as above.

>  	status = ia64_pal_vp_exit_env(host_iva);
> @@ -1258,6 +1262,7 @@ static int vti_vcpu_setup(struct kvm_vcpu *vcpu, int id)
>  uninit:
>  	kvm_vcpu_uninit(vcpu);
>  fail:
> +	local_irq_restore(psr);
>  	return r;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

