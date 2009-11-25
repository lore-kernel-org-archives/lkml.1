Return-Path: <linux-kernel-owner+w=401wt.eu-S934711AbZKYNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbZKYNJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbZKYNJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:09:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934613AbZKYNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:09:47 -0500
Message-ID: <4B0D2C90.2060200@redhat.com>
Date: Wed, 25 Nov 2009 15:09:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 09/12] Retry fault before vmentry
References: <1258985167-29178-1-git-send-email-gleb@redhat.com> <1258985167-29178-10-git-send-email-gleb@redhat.com>
In-Reply-To: <1258985167-29178-10-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 04:06 PM, Gleb Natapov wrote:
> When page is swapped in it is mapped into guest memory only after guest
> tries to access it again and generate another fault. To save this fault
> we can map it immediately since we know that guest is going to access
> the page.
>
>
> -static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
> +static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t cr3, gva_t gpa,
>   				u32 error_code)
>   {
>   	pfn_t pfn;
> @@ -2230,7 +2233,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>   	smp_rmb();
>
> -	if (can_do_async_pf(vcpu)) {
> +	if (cr3 == vcpu->arch.cr3&&  can_do_async_pf(vcpu)) {
>    

Why check cr3 here?

> -static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
> +static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t cr3, gva_t addr,
>   			       u32 error_code)
>    

I'd be slightly happier if we had a page_fault_other_cr3() op that 
switched cr3, called the original, then switched back (the tdp version 
need not change anything).

-- 
error compiling committee.c: too many arguments to function

