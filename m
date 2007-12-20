Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbXLTNnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbXLTNnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbXLTNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:43:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:7770 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760165AbXLTNnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:43:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 20 Dec 2007 05:43:06 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Date: Thu, 20 Dec 2007 21:43:00 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com>
In-Reply-To: <m14pefaclv.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Thread-Index: AchBwYkTgu1+pXA8Q7i5lMc5ymIwGgBTDbIg
References: <200712182300373901202@gmail.com> <m14pefaclv.fsf@ebiederm.dsl.xmission.com>
From: "Peer Chen" <pchen@nvidia.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "peerchen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
X-OriginalArrivalTime: 20 Dec 2007 13:43:01.0891 (UTC) FILETIME=[3D685530:01C8430E]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The quirk is for our Intel platform, we don't want HT MSI mapping
enabled in any of our devices.

BRs
Peer Chen

-----Original Message-----
From: Eric W. Biederman [mailto:ebiederm@xmission.com] 
Sent: Wednesday, December 19, 2007 5:59 AM
To: peerchen
Cc: linux-kernel; akpm; Andy Currid; Peer Chen
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability

"peerchen" <peerchen@gmail.com> writes:

> According to the HyperTransport spec, 'En' indicate if the MSI Mapping
is
> active.
> Set the 'En' bit when setup pci and add the quirk for some nvidia
devices. 
>
> The patch base on kernel 2.6.24-rc5

Ok.  This is starting to look good.

> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
>
> ---
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff
> linux-2.6.24-rc5-vanilla/drivers/pci/probe.c
> linux-2.6.24-rc5/drivers/pci/probe.c
> --- linux-2.6.24-rc5-vanilla/drivers/pci/probe.c 2007-12-18
14:35:46.000000000
> -0500
> +++ linux-2.6.24-rc5/drivers/pci/probe.c 2007-12-18 16:28:29.000000000
-0500
> @@ -721,6 +721,9 @@ static int pci_setup_device(struct pci_d
>  
>  	/* "Unknown power state" */
>  	dev->current_state = PCI_UNKNOWN;
> +	
> +	/* Enable HT MSI mapping */
> +	ht_enable_msi_mapping(dev);
>  
>  	/* Early fixups, before probing the BARs */
>  	pci_fixup_device(pci_fixup_early, dev);
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff
> linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c
> linux-2.6.24-rc5/drivers/pci/quirks.c
> --- linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c 2007-12-18
14:35:46.000000000
> -0500
> +++ linux-2.6.24-rc5/drivers/pci/quirks.c 2007-12-18
16:28:41.000000000 -0500
> @@ -1705,6 +1705,45 @@ static void __devinit quirk_nvidia_ck804
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA,
PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
>  			quirk_nvidia_ck804_msi_ht_cap);
>  
> +static void __devinit quirk_msi_ht_cap_disable(struct pci_dev *dev) {
> +	struct pci_dev *host_bridge;
> +	int pos, ttl = 48;
> +
> +	/* HT MSI mapping should be disabled on devices that are below
> +	 * a non-Hypertransport host bridge. Locate the host bridge...
> + 	 */
> +
> +	if ((host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0))) ==
NULL) {
> +		printk(KERN_WARNING
> + "PCI: quirk_msi_ht_cap_disable didn't locate host bridge\n");
> +		return;
> +	}
> +
> + if ((pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE)) !=
0) {
> +		/* Host bridge is to HT */
> +		return;
> +	}
> +
> +	/* Host bridge is not to HT, disable HT MSI mapping on this
device */
> +
> +	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
> +	while (pos && ttl--) {
> +		u8 flags;
> +
> + if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
> + printk(KERN_INFO "PCI: Quirk disabling HT MSI mapping on %s\n",
> +			       pci_name(dev));
> +
> +			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
> +					      flags &
~HT_MSI_FLAGS_ENABLE);
> +		}
> +		pos = pci_find_next_ht_capability(dev, pos,
> +
HT_CAPTYPE_MSI_MAPPING);
> +	}
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> + quirk_msi_ht_cap_disable);

Could you explain the need for this quirk?

My expectation would be that if we turned an MSI interrupt into a
hypertransport interrupt then if we hit a non-hyptransport bridge
upstream it would just turn the hypertransport interrupts into
whatever makes sense for the upstream bridge.  I can see it being
excess work and adding some latency but I don't see it being a
correctness problem. 

Or are my expectations off and the NVIDIA chipsets do not handle
hypertransport interrupts the way I would expect.  Dropping them
instead of converting when going to a non-hypertransport host bridge.


>  static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
>  {
>  	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff
> linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h
> linux-2.6.24-rc5/include/asm-generic/pci.h
> --- linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h 2007-12-18
> 14:35:52.000000000 -0500
> +++ linux-2.6.24-rc5/include/asm-generic/pci.h 2007-12-18
16:29:12.000000000
> -0500
> @@ -45,6 +45,10 @@ pcibios_select_root(struct pci_dev *pdev
>  
>  #define pcibios_scan_all_fns(a, b)	0
>  
> +#ifndef HAVE_ARCH_HT_ENABLE_MSI_MAPPING
> +#define ht_enable_msi_mapping(a)	0
> +#endif /* HAVE_ARCH_HT_ENABLE_MSI_MAPPING */
> +
>  #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
>  static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int
channel)
>  {
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff
> linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h
> linux-2.6.24-rc5/include/asm-x86/pci.h
> --- linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h 2007-12-18
14:35:51.000000000
> -0500
> +++ linux-2.6.24-rc5/include/asm-x86/pci.h 2007-12-18
16:28:58.000000000 -0500
> @@ -75,6 +75,27 @@ static inline void pci_dma_burst_advice(
>  }
>  #endif
>  
> +#ifdef CONFIG_PCI
> +#define HAVE_ARCH_HT_ENABLE_MSI_MAPPING
> +static inline void ht_enable_msi_mapping(struct pci_dev *dev)
> +{
> +	int pos, ttl = 48;
> +
> +	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
> +	while (pos && ttl--) {
> +		u8 flags;
> +
> + if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
> + printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
> +						dev->dev.bus_id);
> +
> +			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
> +					      flags |
HT_MSI_FLAGS_ENABLE);

Here I see two things that we should do better.
1) If the BIOS has already properly enabled the capability we don't
   need to do anything or print any message.  i.e.
   if (!(flags & HT_MSI_FLAGS_ENABLE)) {
	printk(...)
        pci_write_config_byte()
   }

2) The hypertransport specification allows for an optional register
   that specifies the address of the msi mapping window.  If that
   register is present we should program it to the architectural
   defined address on x86 before enabling the device.
        
   
> +		}
> + pos = pci_find_next_ht_capability(dev, pos, HT_CAPTYPE_MSI_MAPPING);
> +	}
> +}
> +#endif
>  
>  #endif  /* __KERNEL__ */
> -
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
