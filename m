Return-Path: <linux-kernel-owner+w=401wt.eu-S1422773AbXD3C5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422773AbXD3C5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 22:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422782AbXD3C5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 22:57:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40366 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422773AbXD3C47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 22:56:59 -0400
Date: Sun, 29 Apr 2007 19:59:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI
 motherboard resources
Message-Id: <20070429195925.6a7f56ce.randy.dunlap@oracle.com>
In-Reply-To: <4635510D.4060103@shaw.ca>
References: <4635510D.4060103@shaw.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 20:14:37 -0600 Robert Hancock wrote:

> diff -up linux-2.6.21.1/arch/i386/pci/mmconfig-shared.c linux-2.6.21.1edit/arch/i386/pci/mmconfig-shared.c
> --- linux-2.6.21.1/arch/i386/pci/mmconfig-shared.c	2007-04-27 15:49:26.000000000 -0600
> +++ linux-2.6.21.1edit/arch/i386/pci/mmconfig-shared.c	2007-04-29 19:47:57.000000000 -0600
> @@ -191,9 +191,77 @@ static void __init pci_mmcfg_insert_reso
>  	}
>  }
>  
> +
> +static int __init is_acpi_reserved(unsigned long start, unsigned long end)
> +{
> +	struct resource mcfg_res;
> +	
> +	mcfg_res.start = start;
> +	mcfg_res.end = end;
> +	mcfg_res.flags = 0;
> +
> +	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
> +	
> +	if( !mcfg_res.flags )

	if (!mcfg_res.flags)

> +		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res, NULL);
> +
> +	return mcfg_res.flags;
> +}
> +
> +static void __init pci_mmcfg_reject_broken(void)
>  {
>  	typeof(pci_mmcfg_config[0]) *cfg;
> +	int i;
>  
>  	if ((pci_mmcfg_config_num == 0) ||
>  	    (pci_mmcfg_config == NULL) ||
> @@ -213,18 +281,36 @@ static void __init pci_mmcfg_reject_brok
>  		       "Rejected as broken MCFG.\n");
>  		goto reject;
>  	}
> -
> -	/*
> -	 * Only do this check when type 1 works. If it doesn't work
> -	 * assume we run on a Mac and always use MCFG
> -	 */
> -	if (type == 1 && !e820_all_mapped(cfg->address,
> -					  cfg->address + MMCONFIG_APER_MIN,
> -					  E820_RESERVED)) {
> -		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
> -		       " E820-reserved\n", cfg->address);
> -		goto reject;
> +	
> +	for(i=0; i < pci_mmcfg_config_num; i++) {

	for (i = 0; i < pci_mmcfg_config_num; i++) {

> +		u32 size = (cfg->end_bus_number + 1) << 20;
> +		cfg = &pci_mmcfg_config[i];
> +		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %p segment %hu buses %u - %u\n",

line too long.

> +			i, (void*)cfg->address, cfg->pci_segment, 
> +			(unsigned int)cfg->start_bus_number,
> +			(unsigned int)cfg->end_bus_number);
> +		if(is_acpi_reserved(cfg->address,

		if (
> +				    cfg->address + size - 1))
> +			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
> +				"in ACPI motherboard resources\n",
> +				cfg->address);
> +		else {
> +			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not "
> +				"reserved in ACPI motherboard resources\n",
> +				cfg->address);
> +			/* Don't try to do this check unless configuration type 1 is
> +			   available. */
> +			if((pci_probe & PCI_PROBE_CONF1) && 

			if ((
		and that line ends with a space :(

> +			   e820_all_mapped(cfg->address,
> +					   cfg->address + size - 1,
> +					   E820_RESERVED))
> +				printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved in E820\n",
> +					cfg->address);
> +			else
> +				goto reject;
> +		}
>  	}
> +
>  	return;
>  
>  reject:
> @@ -234,20 +320,46 @@ reject:
>  	pci_mmcfg_config_num = 0;
>  }
>  
> -void __init pci_mmcfg_init(int type)
> +void __init pci_mmcfg_early_init(int type)
> +{
> +	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
> +		return;
> +	
> +	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
> +	   defer until later when the ACPI interpreter is available to better
> +	   validate things. */
> +	if( type == 1 )

	if (type == 1)

> +		return;
> +
> +	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
> +
> +	if ((pci_mmcfg_config_num == 0) ||
> +	    (pci_mmcfg_config == NULL) ||
> +	    (pci_mmcfg_config[0].address == 0))
> +		return;
> +
> +	if (pci_mmcfg_arch_init())
> +		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
> +}

> diff -ruw linux-2.6.21.1/drivers/acpi/bus.c linux-2.6.21.1edit/drivers/acpi/bus.c
> --- linux-2.6.21.1/drivers/acpi/bus.c	2007-04-27 15:49:26.000000000 -0600
> +++ linux-2.6.21.1edit/drivers/acpi/bus.c	2007-04-29 19:22:07.000000000 -0600
> @@ -42,6 +42,7 @@
>  ACPI_MODULE_NAME("bus");
>  #ifdef	CONFIG_X86
>  extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
> +extern void __init pci_mmcfg_late_init(void);

externs should go in header files.  (not that you started this here)

>  #endif
>  
>  struct acpi_device *acpi_root;
> @@ -753,6 +754,9 @@
>  	result = acpi_bus_init();
>  
>  	if (!result) {
> +#ifdef CONFIG_X86
> +		pci_mmcfg_late_init();
> +#endif		
>  #ifdef CONFIG_PM_LEGACY
>  		if (!PM_IS_ACTIVE())
>  			pm_active = 1;
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
