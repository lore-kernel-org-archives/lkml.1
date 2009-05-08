Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbZEHWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbZEHWkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZEHWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:40:18 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37632 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZEHWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:40:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Date: Fri, 8 May 2009 16:40:10 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
References: <49ED22EC.2040204@kernel.org> <200904291708.52830.bjorn.helgaas@hp.com> <200904300914.22772.bjorn.helgaas@hp.com>
In-Reply-To: <200904300914.22772.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200905081640.12677.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009 09:14:21 am Bjorn Helgaas wrote:
> On Wednesday 29 April 2009 05:08:51 pm Bjorn Helgaas wrote:
> > On Monday 27 April 2009 08:07:01 pm Yinghai Lu wrote:
> > > On Mon, Apr 27, 2009 at 3:24 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > > On Monday 27 April 2009 03:00:16 pm Yinghai Lu wrote:
> > > >> On Mon, Apr 27, 2009 at 1:39 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > >> >> other system may have broken _CRS.
> > > >> >
> > > >> > Do you have examples of problems here, or are you just worried that
> > > >> > there *may* be problems?
> > > >> one system with three chains... with pci=use_crs
> > > >> [    9.365669] pci_bus 0000:00: resource 0 io:  [0x00-0x3af]
> > > >> [    9.371065] pci_bus 0000:00: resource 1 io:  [0x3e0-0xcf7]
> > > >> [    9.376551] pci_bus 0000:00: resource 2 io:  [0x3b0-0x3bb]
> > > >> [    9.382028] pci_bus 0000:00: resource 3 io:  [0x3c0-0x3df]
> > > >> [    9.387513] pci_bus 0000:00: resource 4 io:  [0xd00-0xefff]
> > > >> [    9.393077] pci_bus 0000:00: resource 5 mem: [0x0a0000-0x0bffff]
> > > >> [    9.399084] pci_bus 0000:00: resource 6 mem: [0x0d0000-0x0dffff]
> > > >> [    9.405089] pci_bus 0000:00: resource 7 mem: [0xdd000000-0xdfffffff]
> > > >> [    9.505332] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
> > > >> [    9.510991] pci_bus 0000:40: resource 1 mem: [0xdb000000-0xdcffffff]
> > > >> [    9.553378] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
> > > >> [    9.559036] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]
> > > >>
> > > >> without that: amd_bus.c will read that from pci conf space
> > > >> [    9.310965] pci_bus 0000:00: resource 0 io:  [0x9000-0xefff]
> > > >> [    9.316621] pci_bus 0000:00: resource 1 io:  [0x00-0xfff]
> > > >> [    9.322020] pci_bus 0000:00: resource 2 mem: [0xdd000000-0xdfffffff]
> > > >> [    9.328373] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
> > > >> [    9.334378] pci_bus 0000:00: resource 4 mem: [0xc0000000-0xd9ffffff]
> > > >> [    9.340731] pci_bus 0000:00: resource 5 mem: [0xf0000000-0xffffffff]
> > > >> [    9.347084] pci_bus 0000:00: resource 6 mem: [0x840000000-0xfcffffffff]
> > > >> [    9.444440] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
> > > >> [    9.450099] pci_bus 0000:40: resource 1 io:  [0xf000-0xffff]
> > > >> [    9.455757] pci_bus 0000:40: resource 2 mem: [0xdb000000-0xdcffffff]
> > > >> [    9.498118] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
> > > >> [    9.503777] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]
> > > >
> > > > It's interesting that many of the differences involve the legacy
> > > > VGA I/O ports in the 0x3b0-0x3df range.  My guess is that the AMD
> > > > chipset has special routing for those ranges.  If it didn't, it
> > > > would be difficult to support VGA devices under the other two
> > > > root bridges.  Maybe that VGA routing doesn't show up in the
> > > > bridge's PCI config space.  Can you tell from the ASL whether the
> > > > root bridge _SRS/_PRS/_CRS methods handle the VGA ranges specially?
> > > >
> > > > One of the differences is that PCI config space shows a 64-bit region
> > > > (bus 0000:00 mem 0x840000000-0xfcffffffff) that doesn't show up in
> > > > the _CRS info.  But the _CRS parsing depends on acpi_resource_to_address64(),
> > > > which doesn't know about the ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64
> > > > descriptors added in ACPI 3.0.  So this difference could be a result
> > > > of that Linux bug.  It'd be interesting to see whether the test patch
> > > > below makes a difference.
> > > will check it.
> > 
> > Did you learn anything about this?  I have a PNPACPI patch to parse
> > these new descriptors, but I don't have any machines where I can test
> > it.  If your box uses that descriptor, it'd be nice to test the patch
> > there.
> 
> Oops, I should have just attached the PNPACPI patch in case anybody
> has a box where it can be tested.  One way to test it would be to
> compare the output of "grep . /sys/devices/pnp*/*/{id,resources,options}"
> before and after the patch.  If a BIOS uses the new descriptors, we
> should see some new resources after the patch.

Did anything happen with this?

The longer we wait to make "use_crs" the default, the harder it
will be, so I'd like to push ahead.

Bjorn

> PNPACPI: parse Extended Address Space Descriptors
> 
> From: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Extended Address Space Descriptors are new in ACPI 3.0 and allow the
> BIOS to communicate device resource cacheability attributes (write-back,
> write-through, uncacheable, etc) to the OS.
> 
> Previously, PNPACPI ignored these descriptors, so if a BIOS used them,
> a device could be responding at addresses the OS doesn't know about.
> This patch adds support for these descriptors in _CRS and _PRS.  We
> don't attempt to encode them for _SRS (just like we don't attempt to
> encode the existing 16-, 32-, and 64-bit Address Space Descriptors).
> 
> Unfortunately, I don't have a way to test this.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>  drivers/pnp/pnpacpi/rsparser.c |   45 ++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index adf1785..0864242 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -287,6 +287,25 @@ static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
>  				ACPI_DECODE_16);
>  }
>  
> +static void pnpacpi_parse_allocated_ext_address_space(struct pnp_dev *dev,
> +						      struct acpi_resource *res)
> +{
> +	struct acpi_resource_extended_address64 *p = &res->data.ext_address64;
> +
> +	if (p->producer_consumer == ACPI_PRODUCER)
> +		return;
> +
> +	if (p->resource_type == ACPI_MEMORY_RANGE)
> +		pnpacpi_parse_allocated_memresource(dev,
> +			p->minimum, p->address_length,
> +			p->info.mem.write_protect);
> +	else if (p->resource_type == ACPI_IO_RANGE)
> +		pnpacpi_parse_allocated_ioresource(dev,
> +			p->minimum, p->address_length,
> +			p->granularity == 0xfff ? ACPI_DECODE_10 :
> +				ACPI_DECODE_16);
> +}
> +
>  static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
>  					      void *data)
>  {
> @@ -400,8 +419,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
>  		break;
>  
>  	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
> -		if (res->data.ext_address64.producer_consumer == ACPI_PRODUCER)
> -			return AE_OK;
> +		pnpacpi_parse_allocated_ext_address_space(dev, res);
>  		break;
>  
>  	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> @@ -630,6 +648,28 @@ static __init void pnpacpi_parse_address_option(struct pnp_dev *dev,
>  					   IORESOURCE_IO_FIXED);
>  }
>  
> +static __init void pnpacpi_parse_ext_address_option(struct pnp_dev *dev,
> +						    unsigned int option_flags,
> +						    struct acpi_resource *r)
> +{
> +	struct acpi_resource_extended_address64 *p = &r->data.ext_address64;
> +	unsigned char flags = 0;
> +
> +	if (p->address_length == 0)
> +		return;
> +
> +	if (p->resource_type == ACPI_MEMORY_RANGE) {
> +		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
> +			flags = IORESOURCE_MEM_WRITEABLE;
> +		pnp_register_mem_resource(dev, option_flags, p->minimum,
> +					  p->minimum, 0, p->address_length,
> +					  flags);
> +	} else if (p->resource_type == ACPI_IO_RANGE)
> +		pnp_register_port_resource(dev, option_flags, p->minimum,
> +					   p->minimum, 0, p->address_length,
> +					   IORESOURCE_IO_FIXED);
> +}
> +
>  struct acpipnp_parse_option_s {
>  	struct pnp_dev *dev;
>  	unsigned int option_flags;
> @@ -711,6 +751,7 @@ static __init acpi_status pnpacpi_option_resource(struct acpi_resource *res,
>  		break;
>  
>  	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
> +		pnpacpi_parse_ext_address_option(dev, option_flags, res);
>  		break;
>  
>  	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> 


