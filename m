Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbYEWFiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbYEWFiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYEWFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:38:36 -0400
Received: from colo.lackof.org ([198.49.126.79]:43962 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYEWFif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:38:35 -0400
Date: Thu, 22 May 2008 23:38:22 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Message-ID: <20080523053822.GA28835@colo.lackof.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221435.11734.yhlu.kernel@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 02:35:11PM -0700, Yinghai Lu wrote:
> 
> so we can printout pci config before kernel touch it
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Yinghai,
No offense, but my first thought was this is debug code that should be
maintained outside the kernel.org tree. It will rarely get used.
Just want people to think about this before saying "great, add it!"

(And this isn't a stab at Jesse since I think he's doing a better
job than I could. I saw his previous reply to this mail.)

Having debugged lots of PCI resource and config issues, I understand
why this is useful and do NOT object to it being included in the tree.

The boot option also needs to be added to Documentation/ .
At least if you want people to use it. :)
Perhaps Jesse can suggest a preferred location.


> Index: linux-2.6/arch/x86/kernel/setup_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_64.c
> +++ linux-2.6/arch/x86/kernel/setup_64.c
> @@ -350,6 +350,11 @@ void __init setup_arch(char **cmdline_p)
>  
>  	parse_early_param();
>  
> +#ifdef CONFIG_PCI
> +	if (pci_early_dump_regs)
> +		early_dump_pci_devices();
> +#endif
> +
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
>  	if (init_ohci1394_dma_early)
>  		init_ohci1394_dma_on_all_controllers();
> Index: linux-2.6/arch/x86/pci/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/common.c
> +++ linux-2.6/arch/x86/pci/common.c
> @@ -20,6 +20,7 @@
>  unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
>  				PCI_PROBE_MMCONF;
>  
> +unsigned int pci_early_dump_regs;
>  static int pci_bf_sort;
>  int pci_routeirq;
>  int pcibios_last_bus = -1;
> @@ -489,6 +490,9 @@ char * __devinit  pcibios_setup(char *st
>  	} else if (!strcmp(str, "use_crs")) {
>  		pci_probe |= PCI_USE__CRS;
>  		return NULL;
> +	} else if (!strcmp(str, "earlydump")) {

Please call this "pci_early_dump" (I prefer with underscores but don't care).
Don't want it confused with kernel dumps (LKCD) or any other
general debugging tools.

thanks,
grant

> +		pci_early_dump_regs = 1;
> +		return NULL;
>  	} else if (!strcmp(str, "routeirq")) {
>  		pci_routeirq = 1;
>  		return NULL;
> Index: linux-2.6/arch/x86/pci/early.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/early.c
> +++ linux-2.6/arch/x86/pci/early.c
> @@ -57,3 +57,54 @@ int early_pci_allowed(void)
>  	return (pci_probe & (PCI_PROBE_CONF1|PCI_PROBE_NOEARLY)) ==
>  			PCI_PROBE_CONF1;
>  }
> +
> +void early_dump_pci_device(u8 bus, u8 slot, u8 func)
> +{
> +	int i;
> +	int j;
> +	u32 val;
> +
> +	printk("PCI: %02x:%02x:%02x", bus, slot, func);
> +
> +	for (i = 0; i < 256; i += 4) {
> +		if (!(i & 0x0f))
> +			printk("\n%04x:",i);
> +
> +		val = read_pci_config(bus, slot, func, i);
> +		for (j = 0; j < 4; j++) {
> +			printk(" %02x", val & 0xff);
> +			val >>= 8;
> +		}
> +	}
> +	printk("\n");
> +}
> +
> +void early_dump_pci_devices(void)
> +{
> +	unsigned bus, slot, func;
> +
> +	if (!early_pci_allowed())
> +		return;
> +
> +	for (bus = 0; bus < 256; bus++) {
> +		for (slot = 0; slot < 32; slot++) {
> +			for (func = 0; func < 8; func++) {
> +				u32 class;
> +				u8 type;
> +				class = read_pci_config(bus, slot, func,
> +							PCI_CLASS_REVISION);
> +				if (class == 0xffffffff)
> +					break;
> +
> +				early_dump_pci_device(bus, slot, func);
> +
> +				/* No multi-function device? */
> +				type = read_pci_config_byte(bus, slot, func,
> +							       PCI_HEADER_TYPE);
> +				if (!(type & 0x80))
> +					break;
> +			}
> +		}
> +	}
> +}
> +
> Index: linux-2.6/include/asm-x86/pci-direct.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/pci-direct.h
> +++ linux-2.6/include/asm-x86/pci-direct.h
> @@ -14,4 +14,7 @@ extern void write_pci_config_byte(u8 bus
>  
>  extern int early_pci_allowed(void);
>  
> +extern unsigned int pci_early_dump_regs;
> +extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
> +extern void early_dump_pci_devices(void);
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
