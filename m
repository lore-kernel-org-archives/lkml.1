Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZBRSKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZBRSKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZBRSKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:10:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZBRSKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:10:39 -0500
Date: Wed, 18 Feb 2009 15:10:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm mmu: handle compound pages in kvm_is_mmio_pfn
Message-ID: <20090218181002.GD25719@amt.cnet>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234962540-7131-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



BTW some page bits are erroneously transferred to the struct page's
within the compound page. We've got away with that so far because
these bits (such as dirty and accessed) are not used by the limited
hugetlb/hugetlbfs implementation ATM.

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>

On Wed, Feb 18, 2009 at 02:08:58PM +0100, Joerg Roedel wrote:
> The function kvm_is_mmio_pfn is called before put_page is called on a
> page by KVM. This is a problem when when this function is called on some
> struct page which is part of a compund page. It does not test the
> reserved flag of the compound page but of the struct page within the
> compount page. This is a problem when KVM works with hugepages allocated
> at boot time. These pages have the reserved bit set in all tail pages.
> Only the flag in the compount head is cleared. KVM would not put such a
> page which results in a memory leak.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  virt/kvm/kvm_main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 266bdaf..0ed662d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -535,8 +535,10 @@ static inline int valid_vcpu(int n)
>  
>  inline int kvm_is_mmio_pfn(pfn_t pfn)
>  {
> -	if (pfn_valid(pfn))
> -		return PageReserved(pfn_to_page(pfn));
> +	if (pfn_valid(pfn)) {
> +		struct page *page = compound_head(pfn_to_page(pfn));
> +		return PageReserved(page);
> +	}
>  
>  	return true;
>  }

