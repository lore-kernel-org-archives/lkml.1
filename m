Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbXLTAll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbXLTAll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXLTAlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:41:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbXLTAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:41:31 -0500
Date: Wed, 19 Dec 2007 16:41:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "peerchen" <peerchen@gmail.com>
Cc: linux-kernel@vger.kernel.org, acurrid@nvidia.com, pchen@nvidia.com,
       ebiederm@xmission.com
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Message-Id: <20071219164125.a3eac8ba.akpm@linux-foundation.org>
In-Reply-To: <200712182300373901202@gmail.com>
References: <200712182300373901202@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 23:00:52 +0800
"peerchen" <peerchen@gmail.com> wrote:

> According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active.
> Set the 'En' bit when setup pci and add the quirk for some nvidia devices. 
> 
> The patch base on kernel 2.6.24-rc5
> 
> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> 
> ---
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/drivers/pci/probe.c linux-2.6.24-rc5/drivers/pci/probe.c
> --- linux-2.6.24-rc5-vanilla/drivers/pci/probe.c	2007-12-18 14:35:46.000000000 -0500
> +++ linux-2.6.24-rc5/drivers/pci/probe.c	2007-12-18 16:28:29.000000000 -0500
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
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c linux-2.6.24-rc5/drivers/pci/quirks.c
> --- linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c	2007-12-18 14:35:46.000000000 -0500
> +++ linux-2.6.24-rc5/drivers/pci/quirks.c	2007-12-18 16:28:41.000000000 -0500
> @@ -1705,6 +1705,45 @@ static void __devinit quirk_nvidia_ck804
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
>  			quirk_nvidia_ck804_msi_ht_cap);
>  
> +static void __devinit quirk_msi_ht_cap_disable(struct pci_dev *dev) {

Please feed all diffs through scripts/checkpatch.pl and review the results.


> +	struct pci_dev *host_bridge;
> +	int pos, ttl = 48;
> +
> +	/* HT MSI mapping should be disabled on devices that are below
> +	 * a non-Hypertransport host bridge. Locate the host bridge...
> + 	 */
> +
> +	if ((host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0))) == NULL) {
> +		printk(KERN_WARNING
> +			 "PCI: quirk_msi_ht_cap_disable didn't locate host bridge\n");
> +		return;
> +	}
> +
> +	if ((pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE)) != 0) {
> +		/* Host bridge is to HT */
> +		return;
> +	}
> +
> +	/* Host bridge is not to HT, disable HT MSI mapping on this device */
> +
> +	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
> +	while (pos && ttl--) {
> +		u8 flags;
> +
> +		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
> +			printk(KERN_INFO "PCI: Quirk disabling HT MSI mapping on %s\n",
> +			       pci_name(dev));
> +
> +			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
> +					      flags & ~HT_MSI_FLAGS_ENABLE);
> +		}
> +		pos = pci_find_next_ht_capability(dev, pos,
> +						  HT_CAPTYPE_MSI_MAPPING);
> +	}
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> +							quirk_msi_ht_cap_disable);

This limit of 48 iterations (ttl) is mysterious.  Perhaps it is described
in the spec?  Either way, I believe it should be documented in code
comments because there is no way on earth that the code reader can tell why
it is there.

>  static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
>  {
>  	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h linux-2.6.24-rc5/include/asm-generic/pci.h
> --- linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h	2007-12-18 14:35:52.000000000 -0500
> +++ linux-2.6.24-rc5/include/asm-generic/pci.h	2007-12-18 16:29:12.000000000 -0500
> @@ -45,6 +45,10 @@ pcibios_select_root(struct pci_dev *pdev
>  
>  #define pcibios_scan_all_fns(a, b)	0
>  
> +#ifndef HAVE_ARCH_HT_ENABLE_MSI_MAPPING
> +#define ht_enable_msi_mapping(a)	0
> +#endif /* HAVE_ARCH_HT_ENABLE_MSI_MAPPING */

Please try to avoid the HAVE_ARCH_foo trick.  It's fairly ugly.  You can do
the Linus trick of:

#ifndef ht_enable_msi_mapping
#define ht_enable_msi_mapping(x) do { } while (0)
#endif

and then, in include/asm-x86/pci.h, do

static inline void ht_enable_msi_mapping(struct pci_dev *dev)
{
	...
}

#define ht_enable_msi_mapping(d) ht_enable_msi_mapping(d)

which has the merit of reducing the number of global symbols, but it's
still pretty unpleasant.


It would be better to just add a stub implementation of
ht_enable_msi_mapping() for all the other architectures - avoid fancy cpp
tricks.

Also, your proposed non-x86 implementation of ht_enable_msi_mapping() is
(effectively) an integer-returning thing whereas your x86 implementation is
a void-returning thing.  Consequently non-x86 architectures will get a
statement-with-no-effect warning when this patch is applied.


>  #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
>  static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
>  {
> diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h linux-2.6.24-rc5/include/asm-x86/pci.h
> --- linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h	2007-12-18 14:35:51.000000000 -0500
> +++ linux-2.6.24-rc5/include/asm-x86/pci.h	2007-12-18 16:28:58.000000000 -0500
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
> +		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
> +			printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
> +						dev->dev.bus_id);
> +
> +			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
> +					      flags | HT_MSI_FLAGS_ENABLE);
> +		}
> +		pos = pci_find_next_ht_capability(dev, pos, HT_CAPTYPE_MSI_MAPPING);
> +	}
> +}
> +#endif

And even though this has only a single callsite, there really is no point
in inlining it.  It's not a fastpath and putting a large and complex
function like this in a header file risks increasing that header file's
include dependencies.

iow, let's put it in arch/x86/pci/ somewhere?
