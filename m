Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbXFYTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbXFYTlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXFYTl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:41:27 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:42250 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXFYTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:41:25 -0400
Date: Mon, 25 Jun 2007 15:41:12 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown v2
Message-ID: <20070625194112.GC5334@rhun.ibm.com>
References: <200706221219.16243.yinghai.lu@sun.com> <467C6906.6020105@sun.com> <200706221934.59966.yinghai.lu@sun.com> <200706251234.04548.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251234.04548.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:34:03PM -0700, Yinghai Lu wrote:

> [PATCH] x86-64: disable the GART in shutdown
> 
> For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
> installed. when using kexec to load second kernel. In the second kernel,
>  when mem is allocated for GART, it will do the memset for clear, it will cause
> restart, because some device still used that for dma.
> solution will be:
> in second kernel: disable that at first before we try to allocate mem for it.
> or in the first kernel: do disable that before shutdown.
> Andi/Eric/Alan prefer to second one for clean shutdown in first kernel.
> Andi also point out need to consider to AGP enable but mem less 4G case too.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
>  arch/x86_64/kernel/pci-dma.c  |    5 +++++
>  arch/x86_64/kernel/pci-gart.c |   21 +++++++++++++++++++++
>  arch/x86_64/kernel/reboot.c   |    4 ++++
>  include/asm-x86_64/proto.h    |    7 +++++++
>  4 files changed, 37 insertions(+)
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index ae091cd..6c4fe16 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c
> @@ -571,6 +571,27 @@ static const struct dma_mapping_ops gart_dma_ops = {
>  	.unmap_sg = gart_unmap_sg,
>  };
>  
> +void gart_iommu_shutdown(void)
> +{
> +	struct pci_dev *dev;
> +	int i;
> +

extra blank line

> +
> +	if (noagp && (dma_ops != &gart_dma_ops))
> +		return;

noagp? did you mean 'no_agp'?

> +
> +	for (i = 0; i < num_k8_northbridges; i++) {
> +		u32 ctl;
> +
> +		dev = k8_northbridges[i];
> +		pci_read_config_dword(dev, 0x90, &ctl);
> +
> +		ctl &= ~1;
> +
> +		pci_write_config_dword(dev, 0x90, ctl);
> +	}
> +}
> +
>  void __init gart_iommu_init(void)
>  { 
>  	struct agp_kern_info info;
> diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
> index 9f80aad..b406b54 100644
> --- a/arch/x86_64/kernel/pci-dma.c
> +++ b/arch/x86_64/kernel/pci-dma.c
> @@ -322,6 +322,11 @@ static int __init pci_iommu_init(void)
>  	return 0;
>  }
>  
> +void pci_iommu_shutdown(void)
> +{
> +	gart_iommu_shutdown();

I really dislike this. Here's how this function is going to look in a
few months:

void pci_iommu_shutdown(void)
{
	gart_iommu_shutdown();

	calgary_iommu_shutdown();

	vtd_iommu_shutdown();

	amd_iommu_shutdown();

	/* etc, ad nauseam */
}

Where all of these are no-ops, except one. Now what's wrong with this
picture?

> diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
> index 85255db..b70aa0c 100644
> --- a/include/asm-x86_64/proto.h
> +++ b/include/asm-x86_64/proto.h
> @@ -85,11 +85,13 @@ extern int exception_trace;
>  extern unsigned cpu_khz;
>  extern unsigned tsc_khz;
>  
> +extern void pci_iommu_shutdown(void);
>  extern void no_iommu_init(void);
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
>  #ifdef CONFIG_IOMMU
>  extern void gart_iommu_init(void);
> +extern void gart_iommu_shutdown(void);
>  extern void __init gart_parse_options(char *);
>  extern void iommu_hole_init(void);
>  extern int fallback_aper_order;
> @@ -101,6 +103,11 @@ extern int fix_aperture;
>  #else
>  #define iommu_aperture 0
>  #define iommu_aperture_allowed 0
> +
> +static inline void gart_iommu_shutdown(void)
> +{
> +}
> +

I suggest include/asm-x86_64/iommu.h for this. proto.h doesn't have
anything to do with it.

Cheers,
Muli
