Return-Path: <linux-kernel-owner+w=401wt.eu-S1030812AbXDXVR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812AbXDXVR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030767AbXDXVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:17:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:63208 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030682AbXDXVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jiwCOnsi5iYTxFzonR5Co/PPTe/XjU4uPfxxSwqDhowpIvRu2o5X4ra2Xh5jTmbeJHFOWWtmLU3xgo3D+B8XWamH6uUWgB59fMVedyK19FF/xvv+H5tAc2eYO+xy7DN73Vrbr3kdCSLUNRURdSS0gh/xlg+R5wfsh059HtaMs00=
Message-ID: <d9def9db0704241417i2e52aad6p35c5f484c0599550@mail.gmail.com>
Date: Tue, 24 Apr 2007 23:17:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Ashok Raj" <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 6/8] Doc updates for Intel Virtualization Technology for Directed I/O.
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
In-Reply-To: <20070423164957.376691000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070423163837.447443000@linux.intel.com>
	 <20070423164957.376691000@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Ashok Raj <ashok.raj@intel.com> wrote:
> Document Intel IOMMU driver boot option.
>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Index: linux-2.6.21-rc5/Documentation/Intel-IOMMU.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-rc5/Documentation/Intel-IOMMU.txt	2007-04-17
> 05:41:56.000000000 -0700
> @@ -0,0 +1,119 @@
> +Linux IOMMU Support
> +===================
> +
> +The architecture spec can be obtained from the below location.
> +
> +http://www.intel.com/technology/virtualization/
> +
> +This guide gives a quick cheat sheet for some basic understanding.
> +
> +Some Keywords
> +
> +DMAR - DMA remapping
> +DRHD - DMA Engine Reporting Structure
> +RMRR - Reserved memory Region Reporting Structure
> +ZLR  - Zero length reads from PCI devices
> +IOVA - IO Virtual address.
> +
> +Basic stuff
> +-----------
> +
> +ACPI enumerates and lists the different DMA engines in the platform, and
> +device scope relationships between PCI devices and which DMA engine
> controls
> +them.
> +
> +What is RMRR?
> +-------------
> +
> +There are some devices the BIOS controls, for e.g USB devices to perform
> +PS2 emulation. The regions of memory used for these devices are marked
> +reserved in the e820 map. When we turn on DMA translation, DMA to those
> +regions will fail. Hence BIOS uses RMRR to specify these regions along with
> +devices that need to access these regions. OS is expected to setup
> +unity mappings for these regions for these devices to access these regions.
> +
> +How is IOVA generated?
> +---------------------
> +
> +Well behaved drivers call pci_map_*() calls before sending command to
> device
> +that needs to perform DMA. Once DMA is completed and mapping is no longer
> +required, device performs a pci_unmap_*() calls to unmap the region.
> +
> +The Intel IOMMU driver allocates a virtual address per domain. Each PCIE
> +device has its own domain (hence protection). Devices under p2p bridges
> +share the virtual address with all devices under the p2p bridge due to
> +transaction id aliasing for p2p bridges.
> +
> +IOVA generation is pretty generic. We used the same technique as vmalloc()
> +but these are not global address spaces, but separate for each domain.
> +Different DMA engines may support different number of domains.
> +
> +We also allocate gaurd pages with each mapping, so we can attempt to catch
> +any overflow that might happen.
> +

guess you probably mean guard tables here...

Markus

> +
> +Graphics Problems?
> +------------------
> +If you encounter issues with graphics devices, you can try adding
> +option intel_iommu=igfx_off to turn off the integrated graphics engine.
> +
> +If it happens to be a PCI device included in the INCLUDE_ALL Engine,
> +then try the intel_iommu=gfx_workaround to setup a 1-1 map. We hear
> +graphics drivers may be in process of using DMA api's in the near
> +future....
> +
> +Some exceptions to IOVA
> +-----------------------
> +Interrupt ranges are not address translated, (0xfee00000 - 0xfeefffff).
> +The same is true for peer to peer transactions. Hence we reserve the
> +address from PCI MMIO ranges so they are not allocated for IOVA addresses.
> +
> +
> +Fault reporting
> +---------------
> +When errors are reported, the DMA engine signals via an interrupt. The
> fault
> +reason and device that caused it with fault reason is printed on console.
> +
> +See below for sample.
> +
> +
> +Boot Message Sample
> +-------------------
> +
> +Something like this gets printed indicating presence of DMAR tables
> +in ACPI.
> +
> +ACPI: DMAR (v001 A M I  OEMDMAR  0x00000001 MSFT 0x00000097) @
> 0x000000007f5b5ef0
> +
> +When DMAR is being processed and initialized by ACPI, prints DMAR locations
> +and any RMRR's processed.
> +
> +ACPI DMAR:Host address width 36
> +ACPI DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
> +ACPI DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
> +ACPI DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
> +ACPI DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
> +ACPI DMAR:RMRR base: 0x000000007f600000 end: 0x000000007fffffff
> +
> +When DMAR is enabled for use, you will notice..
> +
> +PCI-DMA: Using DMAR IOMMU
> +
> +Fault reporting
> +---------------
> +
> +DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
> +DMAR:[fault reason 05] PTE Write access is not set
> +DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
> +DMAR:[fault reason 05] PTE Write access is not set
> +
> +TBD
> +----
> +
> +- No Performance tuning / analysis yet.
> +- sysfs needs useful data to be populated.
> +  DMAR info, device scope, stats could be exposed to some extent.
> +- Add support to Firmware Developer Kit to test ACPI tables for DMAR.
> +- For compatibility testing, could use unity map domain for all devices,
> just
> +  provide a 1-1 for all useful memory under a single domain for all
> devices.
> +- API for paravirt ops for abstracting functionlity for VMM folks.
> Index: linux-2.6.21-rc5/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.21-rc5.orig/Documentation/kernel-parameters.txt	2007-04-17
> 04:59:42.000000000 -0700
> +++ linux-2.6.21-rc5/Documentation/kernel-parameters.txt	2007-04-17
> 05:41:56.000000000 -0700
> @@ -710,6 +710,26 @@
>
>  	inttest=	[IA64]
>
> +	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
> +		off
> +			Disable intel iommu driver.
> +		forcerw
> +			Some drivers might incorrectly map DMA buffers as
> +			write-only even when the device, requires read/write
> +			mapping.  This option works around the issue in IOMMU
> +			driver by making all write-only map as read/write.
> +			Default is off.
> +		igfx_off [Default Off]
> +			By default, gfx is mapped as normal device. If a gfx
> +			device has a dedicated DMAR unit, the DMAR unit is
> +			bypassed with this option. In this case, gfx device
> +			will use physical address for DMA.
> +		gfx_workaround [Default Off]
> +			gfx devices tend to use physical address for DMA and
> +			avoid using DMA api's. Setting this option permits
> +			the IOMMU driver to set a unity map for all OS
> +			visible memory. Hence the driver can continue to use
> +			physical addresses for DMA.
>  	io7=		[HW] IO7 for Marvel based alpha systems
>  			See comment before marvel_specify_io7 in
>  			arch/alpha/kernel/core_marvel.c.
>
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
