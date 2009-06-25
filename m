Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZFYKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZFYKJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFYKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:09:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:49649 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZFYKJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:09:24 -0400
Subject: Re: [RFC PATCH 1/2] pci: determine CLS more intelligently
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <4A43234D.9050608@kernel.org>
References: <4A43234D.9050608@kernel.org>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 20:07:34 +1000
Message-Id: <1245924454.22312.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 16:12 +0900, Tejun Heo wrote:
> Till now, CLS has been determined either by arch code or as
> L1_CACHE_BYTES.  Only x86 and ia64 set CLS explicitly and x86 doesn't
> always get it right.  On most configurations, the chance is that
> firmware configures the correct value during boot.
> 
> This patch makes pci_init() determine CLS by looking at what firmware
> has configured.  It scans all devices and if all non-zero values
> agree, the value is used.  If none is configured or there is a
> disagreement, pci_dfl_cache_line_size is used.  arch can set the dfl
> value (via PCI_CACHE_LINE_BYTES or pci_dfl_cache_line_size) or
> override the actual one.
> 
> ia64, x86 and sparc64 updated to set the default cls instead of the
> actual one.  sparc64 is currently the only one using
> PCI_CACHE_LINE_BYTES.  It would be nice to update it to set the
> default variable instead.

Looks ok, I'll have a quick look through though, as we have some weirdo
stuff on some PowerMacs with both PCI/PCI-E and HT off the north bridge
who need different values behind those different segments (for strange
reasons). IIRC, We get away because we never enable MWI on these (ie, I
don't think your patch can cause a regression either way), but I suppose
it would be good if I double checked.

If you don't hear from me mid next week, assume I forgot and merge it,
I'll deal with the consequences :-)

Cheers,
Ben.
 
> RFC PATCH, PLEASE DON'T APPLY YET.
> Cc: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: David Miller <davem@davemloft.net>
> ---
> These two patches are refreshed version of the following patch.
> 
>  http://thread.gmane.org/gmane.linux.kernel.pci/4418/focus=4431
> 
> This patch improves how CLS is determined and was written mainly
> because the original code didn't get it right on my laptop (lenovo
> x61s, the determined value was 32 but the value bios used for other
> devices was 64).  For x86, maybe we can remove the arch specific
> configuration codes in the long run?
> 
> Seems to work fine on my test machine and laptop.  Also builds fine
> for powerpc64 and sparc64.
> 
> Axel, to test, you'll need to build a vanialla kernel with the patches
> applied.  There are pretty good docs about doing that on the web.
> 
> Thanks.
> 
>  arch/ia64/pci/pci.c   |    8 ++++----
>  arch/x86/pci/common.c |    8 ++++----
>  drivers/pci/pci.c     |   49 +++++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 49 insertions(+), 16 deletions(-)
> 
> Index: work/arch/ia64/pci/pci.c
> ===================================================================
> --- work.orig/arch/ia64/pci/pci.c
> +++ work/arch/ia64/pci/pci.c
> @@ -716,7 +716,7 @@ int ia64_pci_legacy_write(struct pci_bus
>  }
>  
>  /* It's defined in drivers/pci/pci.c */
> -extern u8 pci_cache_line_size;
> +extern u8 pci_dfl_cache_line_size;
>  
>  /**
>   * set_pci_cacheline_size - determine cacheline size for PCI devices
> @@ -726,7 +726,7 @@ extern u8 pci_cache_line_size;
>   *
>   * Code mostly taken from arch/ia64/kernel/palinfo.c:cache_info().
>   */
> -static void __init set_pci_cacheline_size(void)
> +static void __init set_pci_dfl_cacheline_size(void)
>  {
>  	unsigned long levels, unique_caches;
>  	long status;
> @@ -746,7 +746,7 @@ static void __init set_pci_cacheline_siz
>  			"(status=%ld)\n", __func__, status);
>  		return;
>  	}
> -	pci_cache_line_size = (1 << cci.pcci_line_size) / 4;
> +	pci_dfl_cache_line_size = (1 << cci.pcci_line_size) / 4;
>  }
>  
>  u64 ia64_dma_get_required_mask(struct device *dev)
> @@ -777,7 +777,7 @@ EXPORT_SYMBOL_GPL(dma_get_required_mask)
>  
>  static int __init pcibios_init(void)
>  {
> -	set_pci_cacheline_size();
> +	set_pci_dfl_cacheline_size();
>  	return 0;
>  }
>  
> Index: work/arch/x86/pci/common.c
> ===================================================================
> --- work.orig/arch/x86/pci/common.c
> +++ work/arch/x86/pci/common.c
> @@ -410,7 +410,7 @@ struct pci_bus * __devinit pcibios_scan_
>  	return bus;
>  }
>  
> -extern u8 pci_cache_line_size;
> +extern u8 pci_dfl_cache_line_size;
>  
>  int __init pcibios_init(void)
>  {
> @@ -426,11 +426,11 @@ int __init pcibios_init(void)
>  	 * and P4. It's also good for 386/486s (which actually have 16)
>  	 * as quite a few PCI devices do not support smaller values.
>  	 */
> -	pci_cache_line_size = 32 >> 2;
> +	pci_dfl_cache_line_size = 32 >> 2;
>  	if (c->x86 >= 6 && c->x86_vendor == X86_VENDOR_AMD)
> -		pci_cache_line_size = 64 >> 2;	/* K7 & K8 */
> +		pci_dfl_cache_line_size = 64 >> 2;	/* K7 & K8 */
>  	else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
> -		pci_cache_line_size = 128 >> 2;	/* P4 */
> +		pci_dfl_cache_line_size = 128 >> 2;	/* P4 */
>  
>  	pcibios_resource_survey();
>  
> Index: work/drivers/pci/pci.c
> ===================================================================
> --- work.orig/drivers/pci/pci.c
> +++ work/drivers/pci/pci.c
> @@ -41,6 +41,19 @@ int pci_domains_supported = 1;
>  unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
>  unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
>  
> +#ifndef PCI_CACHE_LINE_BYTES
> +#define PCI_CACHE_LINE_BYTES L1_CACHE_BYTES
> +#endif
> +
> +/*
> + * The default CLS is used if arch didn't set CLS explicitly and not
> + * all pci devices agree on the same value.  Arch can override either
> + * the dfl or actual value as it sees fit.  Don't forget this is
> + * measured in 32-bit words, not bytes.
> + */
> +u8 pci_dfl_cache_line_size __initdata = PCI_CACHE_LINE_BYTES >> 2;
> +u8 pci_cache_line_size;
> +
>  /**
>   * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
>   * @bus: pointer to PCI bus structure to search
> @@ -1848,14 +1861,6 @@ void pci_clear_mwi(struct pci_dev *dev)
>  
>  #else
>  
> -#ifndef PCI_CACHE_LINE_BYTES
> -#define PCI_CACHE_LINE_BYTES L1_CACHE_BYTES
> -#endif
> -
> -/* This can be overridden by arch code. */
> -/* Don't forget this is measured in 32-bit words, not bytes */
> -u8 pci_cache_line_size = PCI_CACHE_LINE_BYTES / 4;
> -
>  /**
>   * pci_set_cacheline_size - ensure the CACHE_LINE_SIZE register is programmed
>   * @dev: the PCI device for which MWI is to be enabled
> @@ -2631,9 +2636,37 @@ int __attribute__ ((weak)) pci_ext_cfg_a
>  static int __devinit pci_init(void)
>  {
>  	struct pci_dev *dev = NULL;
> +	u8 cls = 0;
> +	u8 tmp;
> +
> +	if (pci_cache_line_size)
> +		printk(KERN_DEBUG "PCI: CLS %u bytes\n",
> +		       pci_cache_line_size << 2);
>  
>  	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>  		pci_fixup_device(pci_fixup_final, dev);
> +		/*
> +		 * If arch hasn't set it explicitly yet, use the CLS
> +		 * value shared by all PCI devices.  If there's a
> +		 * mismatch, fall back to the default value.
> +		 */
> +		if (!pci_cache_line_size) {
> +			pci_read_config_byte(dev, PCI_CACHE_LINE_SIZE, &tmp);
> +			if (!cls)
> +				cls = tmp;
> +			if (!tmp || cls == tmp)
> +				continue;
> +
> +			printk(KERN_DEBUG "PCI: CLS mismatch (%u != %u), "
> +			       "using %u bytes\n", cls << 2, tmp << 2,
> +			       pci_dfl_cache_line_size << 2);
> +			pci_cache_line_size = pci_dfl_cache_line_size;
> +		}
> +	}
> +	if (!pci_cache_line_size) {
> +		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
> +		       cls << 2, pci_dfl_cache_line_size << 2);
> +		pci_cache_line_size = cls;
>  	}
>  
>  	return 0;

