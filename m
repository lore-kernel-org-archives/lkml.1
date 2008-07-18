Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYGRVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYGRVsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGRVs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:48:29 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:36961 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753298AbYGRVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:48:28 -0400
Date: Fri, 18 Jul 2008 17:48:25 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820
	reserved
Message-ID: <20080718214825.GA8132@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807181322.37500.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807181322.37500.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
  I'll test the new patch shortly. When I do, I'll put back in
your debug patches to try to get a complete log with pci=verbose
and initcall_debug with PCIEASPM disabled. Hopefully the probing
is done in the same general fashion with and without PCIEASPM so
we can deduce what exactly is being probed when my MacBook Pro
freezes during boot with PCIEASPM enabled. I consider the fact
that booting 2.6.26 always freezes the kernel when PCIEASPM
is enabled to be the more serious bug (since once Fedora ships
2.6.26 kernels I'll be stuck always building my own).
                     Jack


On Fri, Jul 18, 2008 at 01:22:36PM -0700, Yinghai Lu wrote:
> 
> for MacBookPro2
> 
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |   64 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 47 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -293,7 +293,7 @@ static acpi_status __init find_mboard_re
>  	return AE_OK;
>  }
>  
> -static int __init is_acpi_reserved(unsigned long start, unsigned long end)
> +static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
>  {
>  	struct resource mcfg_res;
>  
> @@ -310,6 +310,41 @@ static int __init is_acpi_reserved(unsig
>  	return mcfg_res.flags;
>  }
>  
> +typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
> +
> +static int __init is_mmconf_reserved(check_reserved_t is_reserved,
> +		u64 addr, u64 size, int i,
> +	        typeof(pci_mmcfg_config[0]) *cfg, int with_e820)
> +{
> +	u64 old_size = size;
> +	int valid = 0;
> +
> +	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
> +		size >>= 1;
> +		if (size < (16UL<<20))
> +			break;
> +	}
> +
> +	if (size >= (16UL<<20) || size == old_size) {
> +		printk(KERN_NOTICE
> +		       "PCI: MCFG area at %Lx reserved in %s\n",
> +			addr, with_e820?"E820":"ACPI motherboard resources");
> +		valid = 1;
> +
> +		if (old_size != size) {
> +			/* update end_bus_number */
> +			cfg->end_bus_number = cfg->start_bus_number + ((size>>20) - 1);
> +			printk(KERN_NOTICE "PCI: updated MCFG configuration %d: base %lx "
> +			       "segment %hu buses %u - %u\n",
> +			       i, (unsigned long)cfg->address, cfg->pci_segment,
> +			       (unsigned int)cfg->start_bus_number,
> +			       (unsigned int)cfg->end_bus_number);
> +		}
> +	}
> +
> +	return valid;
> +}
> +
>  static void __init pci_mmcfg_reject_broken(int early)
>  {
>  	typeof(pci_mmcfg_config[0]) *cfg;
> @@ -324,21 +359,21 @@ static void __init pci_mmcfg_reject_brok
>  
>  	for (i = 0; i < pci_mmcfg_config_num; i++) {
>  		int valid = 0;
> -		u32 size = (cfg->end_bus_number + 1) << 20;
> +		u64 addr, size;
> +
>  		cfg = &pci_mmcfg_config[i];
> +		addr = cfg->start_bus_number;
> +		addr <<= 20;
> +		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
> +		size <<= 20;
>  		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
>  		       "segment %hu buses %u - %u\n",
>  		       i, (unsigned long)cfg->address, cfg->pci_segment,
>  		       (unsigned int)cfg->start_bus_number,
>  		       (unsigned int)cfg->end_bus_number);
>  
> -		if (!early &&
> -		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
> -			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
> -			       "in ACPI motherboard resources\n",
> -			       cfg->address);
> -			valid = 1;
> -		}
> +		if (!early)
> +			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
>  
>  		if (valid)
>  			continue;
> @@ -347,16 +382,11 @@ static void __init pci_mmcfg_reject_brok
>  			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
>  			       " reserved in ACPI motherboard resources\n",
>  			       cfg->address);
> +
>  		/* Don't try to do this check unless configuration
>  		   type 1 is available. how about type 2 ?*/
> -		if (raw_pci_ops && e820_all_mapped(cfg->address,
> -						  cfg->address + size - 1,
> -						  E820_RESERVED)) {
> -			printk(KERN_NOTICE
> -			       "PCI: MCFG area at %Lx reserved in E820\n",
> -			       cfg->address);
> -			valid = 1;
> -		}
> +		if (raw_pci_ops)
> +			valid = is_mmconf_reserved(e820_all_mapped, addr, size, i, cfg, 1);
>  
>  		if (!valid)
>  			goto reject;
