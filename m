Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbXFWQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbXFWQxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbXFWQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:53:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761AbXFWQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:05 -0400
Date: Sat, 23 Jun 2007 09:52:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: ak@suse.de, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com,
       muli@il.ibm.com, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Message-Id: <20070623095209.248684e7.akpm@linux-foundation.org>
In-Reply-To: <200706221934.59966.yinghai.lu@sun.com>
References: <200706221219.16243.yinghai.lu@sun.com>
	<200706230214.02535.ak@suse.de>
	<467C6906.6020105@sun.com>
	<200706221934.59966.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 19:34:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> [PATCH] x86-64: disable the GART in shutdown
> 
> For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
> installed. when mem is allocated for GART, it will do the memset for clear.
> and for kexec case, the first kernel already enable that, the memset in second
> kernel will cause the system restart. solution will be:
> in second kernel: disable that at first before we try to allocate mem for it.
> or in the first kernel: do disable that before shutdown.
> 

The patch seems to do some slightly inappropriate things.

> 
>  arch/x86_64/kernel/pci-dma.c  |    7 +++++++
>  arch/x86_64/kernel/pci-gart.c |   20 ++++++++++++++++++++
>  arch/x86_64/kernel/reboot.c   |    4 ++++
>  include/asm-x86_64/proto.h    |    2 ++
>  4 files changed, 33 insertions(+)
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index ae091cd..4904d5f 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c
> @@ -571,6 +571,26 @@ static const struct dma_mapping_ops gart_dma_ops = {
>  	.unmap_sg = gart_unmap_sg,
>  };
>  
> +void gart_iommu_shutdown(void)
> +{
> +	struct pci_dev *dev;
> +	int i;
> +
> +	if (dma_ops != &gart_dma_ops)
> +		return;
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

OK.

>  void __init gart_iommu_init(void)
>  { 
>  	struct agp_kern_info info;
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

It'd be better to avoid the ifdef-in-C by providing a stub function in a
header file if !CONFIG_IOMMU.  That's quite standard kernel practice and
might help avoid some other problems...

>  #ifdef CONFIG_PCI
>  /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
>  
> diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
> index 7503068..e6e65c2 100644
> --- a/arch/x86_64/kernel/reboot.c
> +++ b/arch/x86_64/kernel/reboot.c
> @@ -16,6 +16,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  #include <asm/apic.h>
> +#include <asm/proto.h>
>  
>  /*
>   * Power off function, if any
> @@ -81,6 +82,7 @@ static inline void kb_wait(void)
>  void machine_shutdown(void)
>  {
>  	unsigned long flags;
> +
>  	/* Stop the cpus and apics */
>  #ifdef CONFIG_SMP
>  	int reboot_cpu_id;
> @@ -111,6 +113,8 @@ void machine_shutdown(void)
>  	disable_IO_APIC();
>  
>  	local_irq_restore(flags);
> +
> +	pci_iommu_shutdown();
>  }

And does the kernel work OK if CONFIG_PCI=n?  I think so from inspection,
by luck.

>  void machine_emergency_restart(void)
> diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
> index 85255db..fb9f73e 100644
> --- a/include/asm-x86_64/proto.h
> +++ b/include/asm-x86_64/proto.h
> @@ -85,11 +85,13 @@ extern int exception_trace;
>  extern unsigned cpu_khz;
>  extern unsigned tsc_khz;
>  
> +extern void pci_iommu_shutdown(void);

This is the only pci-related function which is declared in proto.h.  I
suspect you chose the wrong header file for this declaration.


>  extern void no_iommu_init(void);
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
>  #ifdef CONFIG_IOMMU
>  extern void gart_iommu_init(void);
> +extern void gart_iommu_shutdown(void);
>  extern void __init gart_parse_options(char *);
>  extern void iommu_hole_init(void);
>  extern int fallback_aper_order;
