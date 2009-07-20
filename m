Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZGTXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZGTXz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZGTXz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:55:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34024 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbZGTXz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:55:56 -0400
Date: Mon, 20 Jul 2009 20:44:09 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] kvm: use get_desc_base() and get_desc_limit()
Message-ID: <20090720234409.GB14647@amt.cnet>
References: <20090718145830.GA11275@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718145830.GA11275@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 11:58:32PM +0900, Akinobu Mita wrote:
> Use get_desc_base() and get_desc_limit() to get the base address and
> limit in desc_struct.
> 
> Cc: Avi Kivity <avi@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---

Applied both, thanks.

>  arch/x86/kvm/x86.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe5474a..38d9b53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -132,8 +132,7 @@ unsigned long segment_base(u16 selector)
>  		table_base = segment_base(ldt_selector);
>  	}
>  	d = (struct desc_struct *)(table_base + (selector & ~7));
> -	v = d->base0 | ((unsigned long)d->base1 << 16) |
> -		((unsigned long)d->base2 << 24);
> +	v = get_desc_base(d);
>  #ifdef CONFIG_X86_64
>  	if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
>  		v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
> @@ -3617,11 +3616,8 @@ static void kvm_set_segment(struct kvm_vcpu *vcpu,
>  static void seg_desct_to_kvm_desct(struct desc_struct *seg_desc, u16 selector,
>  				   struct kvm_segment *kvm_desct)
>  {
> -	kvm_desct->base = seg_desc->base0;
> -	kvm_desct->base |= seg_desc->base1 << 16;
> -	kvm_desct->base |= seg_desc->base2 << 24;
> -	kvm_desct->limit = seg_desc->limit0;
> -	kvm_desct->limit |= seg_desc->limit << 16;
> +	kvm_desct->base = get_desc_base(seg_desc);
> +	kvm_desct->limit = get_desc_limit(seg_desc);
>  	if (seg_desc->g) {
>  		kvm_desct->limit <<= 12;
>  		kvm_desct->limit |= 0xfff;
> @@ -3700,11 +3696,7 @@ static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
>  static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
>  			     struct desc_struct *seg_desc)
>  {
> -	u32 base_addr;
> -
> -	base_addr = seg_desc->base0;
> -	base_addr |= (seg_desc->base1 << 16);
> -	base_addr |= (seg_desc->base2 << 24);
> +	u32 base_addr = get_desc_base(seg_desc);
>  
>  	return vcpu->arch.mmu.gva_to_gpa(vcpu, base_addr);
>  }
> @@ -3993,7 +3985,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
>  		}
>  	}
>  
> -	if (!nseg_desc.p || (nseg_desc.limit0 | nseg_desc.limit << 16) < 0x67) {
> +	if (!nseg_desc.p || get_desc_limit(&nseg_desc) < 0x67) {
>  		kvm_queue_exception_e(vcpu, TS_VECTOR, tss_selector & 0xfffc);
>  		return 1;
>  	}
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
