Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482Ab0A0QpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0A0QpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190Ab0A0QpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:45:23 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:31520 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab0A0QpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:45:22 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Wed, 27 Jan 2010 09:45:15 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org>
In-Reply-To: <4B5F735B.2040308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001270945.17113.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010 03:57:31 pm Yinghai Lu wrote:
> [PATCH] x86/pci: don't use ioh resource if only have one ioh
> 
> some system could use reosurce out of IOH resources when only one ioh is there.
> 
> could be BIOS have wrong IOH resources and not enable them.

The subtractive decode theory makes sense and would explain what's
happening, but I don't like this patch.

If we assume that this really is a subtractive decode issue, this
patch approaches it the wrong way.  We need to know whether a
particular host bridge is configured for subtractive decode.  This
patch tests whether we have more than one host bridge, which is quite
a different question.

Imagine these system configurations:

  1) a single host bridge with subtractive decode
  2) a single host bridge with only positive decode
  3) multiple host bridges with subtractive decode enabled on one
  4) multiple host bridges with only positive decode

This patch will break if we encounter configs 2 or 3.  In config 2,
this patch assumes the bridge performs subtractive decode, so we
think the bridge forwards more address space than it actually does.
If we try to use that address space, the device will never see the
accesses.  In config 3, this patch assumes there's no subtractive
decode, so we would see Jeff's problem all over again.

For configs 3 and 4, there might be a single host bridge in domain 0,
with the others in different domains.  This patch would find only one
host bridge (the one in domain 0), so we would wrongly assume that ALL
the host bridges use subtractive decode, which is obviously a disaster.

Bjorn

> ---
>  arch/x86/pci/intel_bus.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/intel_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/intel_bus.c
> +++ linux-2.6/arch/x86/pci/intel_bus.c
> @@ -7,9 +7,11 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  #include <asm/pci_x86.h>
> +#include <asm/pci-direct.h>
>  
>  #include "bus_numa.h"
>  
> +static int nr_ioh;
>  static inline void print_ioh_resources(struct pci_root_info *info)
>  {
>  	int res_num;
> @@ -49,6 +51,9 @@ static void __devinit pci_root_bus_res(s
>  	u64 mmioh_base, mmioh_end;
>  	int bus_base, bus_end;
>  
> +	if (nr_ioh < 2)
> +		return;
> +
>  	/* some sys doesn't get mmconf enabled */
>  	if (dev->cfg_size < 0x120)
>  		return;
> @@ -92,3 +97,84 @@ static void __devinit pci_root_bus_res(s
>  
>  /* intel IOH */
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, pci_root_bus_res);
> +
> +static void __init count_ioh(int num, int slot, int func)
> +{
> +	nr_ioh++;
> +}
> +
> +struct pci_check_probe {
> +	u32 vendor;
> +	u32 device;
> +	void (*f)(int num, int slot, int func);
> +};
> +
> +static struct pci_check_probe early_qrk[] __initdata = {
> +	{ PCI_VENDOR_ID_INTEL, 0x342e, count_ioh },
> +	{}
> +};
> +
> +static void __init early_check_pci_dev(int num, int slot, int func)
> +{
> +	u16 vendor;
> +	u16 device;
> +	int i;
> +
> +	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
> +	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
> +
> +	for (i = 0; early_qrk[i].f != NULL; i++) {
> +		if (((early_qrk[i].vendor == PCI_ANY_ID) ||
> +			(early_qrk[i].vendor == vendor)) &&
> +			((early_qrk[i].device == PCI_ANY_ID) ||
> +			(early_qrk[i].device == device)))
> +				early_qrk[i].f(num, slot, func);
> +	}
> +}
> +
> +static void __init early_check_pci_devs(void)
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
> +
> +				class = read_pci_config(bus, slot, func,
> +							PCI_CLASS_REVISION);
> +				if (class == 0xffffffff)
> +					continue;
> +
> +				early_check_pci_dev(bus, slot, func);
> +
> +				if (func == 0) {
> +					type = read_pci_config_byte(bus, slot,
> +								    func,
> +							       PCI_HEADER_TYPE);
> +					if (!(type & 0x80))
> +						break;
> +				}
> +			}
> +		}
> +	}
> +}
> +
> +static int __init intel_postcore_init(void)
> +{
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return 0;
> +
> +	early_check_pci_devs();
> +
> +	if (nr_ioh)
> +		printk(KERN_DEBUG "pci: found %d IOH\n", nr_ioh);
> +
> +	return 0;
> +}
> +postcore_initcall(intel_postcore_init);
> +
> 


