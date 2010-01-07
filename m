Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322Ab0AGQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0AGQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306Ab0AGQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0AGQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:48:09 -0500
Message-ID: <4B460664.1090006@redhat.com>
Date: Thu, 07 Jan 2010 18:05:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't treat NULL parent_pte as multimapped in mmu_parent_walk()
References: <4B460441.6090602@gmail.com>
In-Reply-To: <4B460441.6090602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 05:56 PM, Roel Kluin wrote:
> If a kvm_mmu_page is not multimapped but parent_pte is NULL
> don't treat it as multimapped and dereference it.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
> This wasn't tested and maybe I misunderstood so please review.
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4c3e5b2..eb17287 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1031,10 +1031,12 @@ static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	struct kvm_mmu_page *parent_sp;
>   	int i;
>
> -	if (!sp->multimapped&&  sp->parent_pte) {
> -		parent_sp = page_header(__pa(sp->parent_pte));
> -		fn(vcpu, parent_sp);
> -		mmu_parent_walk(vcpu, parent_sp, fn);
> +	if (!sp->multimapped) {
> +		if (sp->parent_pte) {
> +			parent_sp = page_header(__pa(sp->parent_pte));
> +			fn(vcpu, parent_sp);
> +			mmu_parent_walk(vcpu, parent_sp, fn);
> +		}
>   		return;
>   	}
>   	hlist_for_each_entry(pte_chain, node,&sp->parent_ptes, link)
>
>    

If sp->parent_pte is NULL then the list walk terminates immediately.

-- 
error compiling committee.c: too many arguments to function

