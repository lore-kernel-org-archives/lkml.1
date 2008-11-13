Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYKMMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYKMMoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKMMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:44:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYKMMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:44:12 -0500
Message-ID: <491C2119.6000107@redhat.com>
Date: Thu, 13 Nov 2008 14:44:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] Check for ambiguities in create alias ioctl.
References: <1226586776-18999-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1226586776-18999-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> The current alias ioctl allows for the creation of
> an alias covering a gpa that already exists. It is invalid,
> because the gpa space needs to be uniquely mapped. So, if
> there's a memory slot covering gpa range 0x123000 to 0x124000,
> and we create an alias from any gpa within that range to a different
> target, we create an essential ambiguity that brings no value at
> the cost of a lot of confusion. Right now this confusion
> manifests itself as a BUG() triggered in the rmaps code path.
>   

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7a2aeba..c3b5770 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1591,6 +1591,8 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
>  {
>  	int r, n;
>  	struct kvm_mem_alias *p;
> +	gfn_t base_gfn;
> +	unsigned long npages;
>  
>  	r = -EINVAL;
>  	/* General sanity checks */
> @@ -1607,12 +1609,18 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
>  	    < alias->target_phys_addr)
>  		goto out;
>  
> +	base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
> +	npages = alias->memory_size >> PAGE_SHIFT;
> +
> +	if (gfn_to_memslot(kvm, base_gfn) || gfn_to_memslot(kvm, base_gfn + npages))
> +		goto out;
> +
>   

This says nothing about base_gfn + 17.  Moreover, we don't care if 
base+gfn +npages is mapped - it's outside the half-closed alias range.

Further, a clever attacker would first establish the alias, then the 
memslot, bypassing the checks.  I suggest (a) extracting a function to 
check for range overlap from the memslot code, (b) extending it to check 
for both memslots and aliases, and (c) using it everywhere.

-- 
error compiling committee.c: too many arguments to function

