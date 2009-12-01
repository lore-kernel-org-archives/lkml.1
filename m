Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZLAPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZLAPiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZLAPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:38:53 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11180 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZLAPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:38:52 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: fix bridge 64bit flag setting
Date: Tue, 1 Dec 2009 08:38:55 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Williamson <alex.williamson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@parisc-linux.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>
References: <20091130212228.7555.43533.stgit@debian.lart> <4B14B928.2000108@kernel.org> <4B14BFDD.3020802@kernel.org>
In-Reply-To: <4B14BFDD.3020802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912010838.56945.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009 12:03:57 am Yinghai Lu wrote:
> 
> Alex found one system that one pci bridge pref mmio 64 is not set correctly.
> aka, the upper32 base/limit is not cleaned.
> he found that bridge is supporting 64 bit pref mmio, but device under that
> does not support that. so that IORESOURCE_MEM_64 get cleared in pbus_size_mem()

I think it's wrong that pbus_size_mem() fiddles with IORESOURCE_MEM_64
in bus resources based on where BARs of devices on that bus live.  That
feels fragile.

The question of whether the bridge supports 64-bit apertures is
strictly a hardware property of the bridge.  It has nothing to do
with where we place downstream devices.

Is there really a problem with writing to PCI_PREF_BASE_UPPER32
unconditionally?  As Alex pointed out, per 3.2.5.10 of the bridge
spec, the UPPER32 registers are read-only if only 32-bit apertures
are supported.  If you mentioned a problem with doing this
unconditionally, I missed it.

The only place we test IORESOURCE_MEM_64 for a bus resource is when
we're programming PCI_PREF_BASE_UPPER32.  If we think it's important
to program it conditionally, why don't we skip IORESOURCE_MEM_64
altogether, and just look at the bits in PCI_PREF_MEMORY_BASE directly?
E.g., something like this:

	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &l);
	if ((l & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
	}

Then we don't have to maintain flags at all, and it's easy to verify
that the code corresponds to the spec.

Bjorn

> the fix will be:
> make pci_bridge_check_ranges() to store the PCI_PREF_RANGE_TYPE_64 in addition
> to IORESOURCE_MEM_64. just like pci_read_bridge_bases()
> and later will use that bit in  pci_setup_bridge_mmio_pref instead of
> IORESOURCE_MEM_64.
> also avoid touching upper32 regs if the bridge does not support 64bit pref.
> 
> Reported-by: Alex Williamson <alex.williamson@hp.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -289,7 +289,6 @@ static void pci_setup_bridge_mmio_pref(s
>  	struct resource *res;
>  	struct pci_bus_region region;
>  	u32 l, bu, lu;
> -	int pref_mem64;
>  
>  	/* Clear out the upper 32 bits of PREF limit.
>  	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
> @@ -297,7 +296,6 @@ static void pci_setup_bridge_mmio_pref(s
>  	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
>  
>  	/* Set up PREF base/limit. */
> -	pref_mem64 = 0;
>  	bu = lu = 0;
>  	res = bus->resource[2];
>  	pcibios_resource_to_bus(bridge, &region, res);
> @@ -305,7 +303,6 @@ static void pci_setup_bridge_mmio_pref(s
>  		l = (region.start >> 16) & 0xfff0;
>  		l |= region.end & 0xfff00000;
>  		if (res->flags & IORESOURCE_MEM_64) {
> -			pref_mem64 = 1;
>  			bu = upper_32_bits(region.start);
>  			lu = upper_32_bits(region.end);
>  		}
> @@ -317,7 +314,7 @@ static void pci_setup_bridge_mmio_pref(s
>  	}
>  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
>  
> -	if (pref_mem64) {
> +	if (res->flags & PCI_PREF_RANGE_TYPE_64) {
>  		/* Set the upper 32 bits of PREF base & limit. */
>  		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
>  		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> @@ -385,8 +382,10 @@ static void pci_bridge_check_ranges(stru
>  	}
>  	if (pmem) {
>  		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
> -		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
> +		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
>  			b_res[2].flags |= IORESOURCE_MEM_64;
> +			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
> +		}
>  	}
>  
>  	/* double check if bridge does support 64 bit pref */
> 


