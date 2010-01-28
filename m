Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0A1W0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0A1W0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620Ab0A1W0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:26:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0A1W0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:26:00 -0500
Date: Thu, 28 Jan 2010 20:24:55 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
Message-ID: <20100128222455.GA26274@amt.cnet>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> This patch changes the implementation of of
> kvm_iommu_map_pages to map the pages with the host page size
> into the io virtual address space.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  virt/kvm/iommu.c |  106 ++++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 84 insertions(+), 22 deletions(-)
> 
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 65a5143..92a434d 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -32,12 +32,27 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
>  static void kvm_iommu_put_pages(struct kvm *kvm,
>  				gfn_t base_gfn, unsigned long npages);
>  
> +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			   gfn_t gfn, unsigned long size)
> +{
> +	gfn_t end_gfn;
> +	pfn_t pfn;
> +
> +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);

If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
large iommu translation for it?

> +		/* Map into IO address space */
> +		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> +			      get_order(page_size), flags);
> +
> +		gfn += page_size >> PAGE_SHIFT;

Should increase gfn after checking for failure, otherwise wrong
npages is passed to kvm_iommu_put_pages.

>  
> -		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
> -		r = iommu_map_range(domain,
> -				    gfn_to_gpa(gfn),
> -				    pfn_to_hpa(pfn),
> -				    PAGE_SIZE, flags);
>  		if (r) {
>  			printk(KERN_ERR "kvm_iommu_map_address:"
>  			       "iommu failed to map pfn=%lx\n", pfn);
>  			goto unmap_pages;
>  		}
> -		gfn++;
> +
>  	}
> +
>  	return 0;
>  
>  unmap_pages:
> -	kvm_iommu_put_pages(kvm, slot->base_gfn, i);
> +	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
>  	return r;
>  }

