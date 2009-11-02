Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZKBNDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZKBNDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZKBNDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbZKBNDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:03:34 -0500
Message-ID: <4AEED8A8.9030606@redhat.com>
Date: Mon, 02 Nov 2009 15:03:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] Retry fault before vmentry
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-8-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 01:56 PM, Gleb Natapov wrote:
> When page is swapped in it is mapped into guest memory only after guest
> tries to access it again and generate another fault. To save this fault
> we can map it immediately since we know that guest is going to access
> the page.
>
>    
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 9fe2ecd..b1fe61f 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -375,7 +375,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>    *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
>    *           a negative value on error.
>    */
> -static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
> +static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t cr3, gva_t addr,
>   			       u32 error_code)
>   {
>   	int write_fault = error_code&  PFERR_WRITE_MASK;
> @@ -388,6 +388,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
>   	pfn_t pfn;
>   	int level = PT_PAGE_TABLE_LEVEL;
>   	unsigned long mmu_seq;
> +	gpa_t curr_cr3 = vcpu->arch.cr3;
>
>   	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
>   	kvm_mmu_audit(vcpu, "pre page fault");
> @@ -396,6 +397,13 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
>   	if (r)
>   		return r;
>
> +	if (curr_cr3 != cr3) {
> +		vcpu->arch.cr3 = cr3;
> +		paging_new_cr3(vcpu);
> +		if (kvm_mmu_reload(vcpu))
> +			goto switch_cr3;
> +	}
> +
>    

This is a little frightening.  I can't put my finger on anything 
though.  But playing with cr3 under the guest's feet worries me.

-- 
error compiling committee.c: too many arguments to function

