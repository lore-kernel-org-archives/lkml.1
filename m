Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625Ab0ANXKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0ANXKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554Ab0ANXKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:10:01 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:22413 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0ANXKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:00 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/pci: intel ioh need to subtract mmconf range
Date: Thu, 14 Jan 2010 16:09:18 -0700
User-Agent: KMail/1.9.10
Cc: Jeff Garrett <jeff@jgarrett.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
References: <20100113053736.GA6720@jgarrett.org> <201001141108.03129.bjorn.helgaas@hp.com> <4B4F9ECB.4060805@kernel.org>
In-Reply-To: <4B4F9ECB.4060805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141609.19290.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 January 2010 03:46:35 pm Yinghai Lu wrote:
> 
> Bjorn pointed out we need to remove mmconf range
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/intel_bus.c |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/intel_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/intel_bus.c
> +++ linux-2.6/arch/x86/pci/intel_bus.c
> @@ -46,6 +46,20 @@ static inline void print_ioh_resources(s
>  
>  #define RANGE_NUM 16
>  
> +static void __devinit subtract_mmconf(struct range *range, int nr)
> +{
> +#ifdef CONFIG_PCI_MMCONFIG
> +	struct pci_mmcfg_region *cfg;
> +
> +	if (list_empty(&pci_mmcfg_list))
> +		return;
> +
> +        list_for_each_entry(cfg, &pci_mmcfg_list, list)
> +		subtract_range(range, nr, cfg->res.start,
> +			 cfg->res.end + 1);
> +#endif

This can't be right, can it?  Let's say the kernel was built with
CONFIG_PCI_MMCONFIG turned off, or the user used "pci=nommconf",
or the kernel decides not to use MMCONFIG for some other reason.

In that case, the hardware may still be configured to support
MMCONFIG, but the pci_mmcfg_list will be empty, so your code will
leave the window alone.  We might assign some of that MMCONFIG
space to a device, but the hardware will route it to MMCONFIG,
not to the device.

Bjorn

> +}
> +
>  static void __devinit pci_root_bus_res(struct pci_dev *dev)
>  {
>  	u16 word;
> @@ -96,6 +110,7 @@ static void __devinit pci_root_bus_res(s
>  
>  		subtract_range(range, RANGE_NUM, vt_base, vt_end + 1);
>  	}
> +	subtract_mmconf(range, RANGE_NUM);
>  	for (i = 0; i < RANGE_NUM; i++) {
>  		if (!range[i].end)
>  			continue;
> @@ -112,8 +127,18 @@ static void __devinit pci_root_bus_res(s
>  	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
>  	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
>  	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
> -	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
> -			 IORESOURCE_MEM, 0);
> +	memset(range, 0, sizeof(range));
> +	add_range(range, RANGE_NUM, 0, mmioh_base, mmioh_end + 1);
> +	/* mmconf could be above 4g */
> +	subtract_mmconf(range, RANGE_NUM);
> +	for (i = 0; i < RANGE_NUM; i++) {
> +		if (!range[i].end)
> +			continue;
> +
> +		update_res(info, cap_resource(range[i].start),
> +			   cap_resource(range[i].end - 1),
> +			   IORESOURCE_MEM, 0);
> +	}
>  
>  	print_ioh_resources(info);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


