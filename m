Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFWKj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFWKj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXFWKjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:39:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:21436 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXFWKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:39:50 -0400
Date: Sat, 23 Jun 2007 03:39:47 -0700
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Message-ID: <20070623103947.GA4441@rhun.cust.hotspot.t-mobile.com>
References: <200706221219.16243.yinghai.lu@sun.com> <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com> <200706221934.59966.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221934.59966.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 07:34:59PM -0700, Yinghai Lu wrote:
> [PATCH] x86-64: disable the GART in shutdown
> 
> For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
> installed. when mem is allocated for GART, it will do the memset for clear.
> and for kexec case, the first kernel already enable that, the memset in second
> kernel will cause the system restart. solution will be:
> in second kernel: disable that at first before we try to allocate mem for it.
> or in the first kernel: do disable that before shutdown.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 

[snip]

> diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
> index 9f80aad..64f2ab3 100644
> --- a/arch/x86_64/kernel/pci-dma.c
> +++ b/arch/x86_64/kernel/pci-dma.c
> @@ -322,6 +322,13 @@ static int __init pci_iommu_init(void)
>  	return 0;
>  }
>  
> +void pci_iommu_shutdown(void)
> +{
> +#ifdef CONFIG_IOMMU
> +	gart_iommu_shutdown();
> +#endif
> +}

I'm going to need exactly the same hook fro Calgary, as well Intel for
VT-d, and AMD for their upcoming IOMMU, etc. How about we do

struct iommu_ops {
  struct dma_ops {
    ...
  }
  void (*shutdown)(void);
}

And then pci_iommu_shutdown() becomes

if (iommu_ops->shutdown)
  iommu_ops->shutdown();

?

Cheers,
Muli

