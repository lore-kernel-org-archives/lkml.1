Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZC2LwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZC2LwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZC2Lv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:51:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZC2Lv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:51:56 -0400
Message-ID: <49CF60D8.1060305@redhat.com>
Date: Sun, 29 Mar 2009 14:51:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kvm mmu: enabling 1GB pages by extending backing_size
 funtion
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch enables support for 1GB pages in KVM by implementing
> the support in backing_size().
>
> @@ -490,18 +492,30 @@ static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
>  static enum kvm_page_size backing_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	struct kvm_memory_slot *slot;
> -
> -	if (has_wrprotected_page(vcpu->kvm, gfn))
> -		return KVM_PAGE_SIZE_4k;
> -
> -	if (host_page_size(vcpu->kvm, gfn) < KVM_PAGE_SIZE_2M)
> -		return KVM_PAGE_SIZE_4k;
> +	enum kvm_page_size host_size, ret;
>  
>  	slot = gfn_to_memslot(vcpu->kvm, gfn);
>  	if (slot && slot->dirty_bitmap)
>  		return KVM_PAGE_SIZE_4k;
>  
> -	return KVM_PAGE_SIZE_2M;
> +	host_size = host_page_size(vcpu->kvm, gfn);
> +
> +	switch (host_size) {
> +	case KVM_PAGE_SIZE_1G:
> +		if (!has_wrprotected_largepage(vcpu->kvm, gfn)) {
> +			ret = KVM_PAGE_SIZE_1G;
> +			break;
> +		}
>   

What if there's a wrprotected_page in there?

> +	case KVM_PAGE_SIZE_2M:
> +		if (!has_wrprotected_page(vcpu->kvm, gfn)) {
> +			ret = KVM_PAGE_SIZE_2M;
> +			break;
> +		}
> +	default:
> +		ret = KVM_PAGE_SIZE_4k;
> +	}
> +
> +	return ret;
>  }
>  
>  /*
>   


-- 
error compiling committee.c: too many arguments to function

