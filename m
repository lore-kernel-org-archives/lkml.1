Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZIPJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZIPJ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZIPJ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:57:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42589 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZIPJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:57:39 -0400
Date: Wed, 16 Sep 2009 03:57:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Kay, Allen M" <allen.m.kay@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
Message-ID: <20090916095741.GK29320@parisc-linux.org>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:44:00PM -0700, Kay, Allen M wrote:
> This patch enables P2P upstream forwarding in ACS capable PCIe switches.
> This solves two potential problems in virtualization environment where
> a PCIe device is assigned to a guest domain using a HW iommu such as VT-d:

Seems like a good idea.

> @@ -1513,6 +1513,49 @@ void pci_enable_ari(struct pci_dev *dev)
>  }
>  
>  /**
> + * pci_acs_enable - enable ACS if hardware support it
> + * @dev: the PCI device
> + */
> +#define ACS_ENABLED (PCI_EXP_ACS_V|PCI_EXP_ACS_R|PCI_EXP_ACS_C|PCI_EXP_ACS_U)

This is a little hard to read.  I find it easier with spaces, ie:

#define ACS_ENABLED (PCI_EXP_ACS_V | PCI_EXP_ACS_R | PCI_EXP_ACS_C | \
			PCI_EXP_ACS_U)

Now it doesn't fit on one line, but see below.

> +void pci_acs_init(struct pci_dev *dev)
> +{
> +	int pos;
> +	u16 cap;
> +	u16 ctrl;
> +
> +	if (!dev->is_pcie)
> +		return;
> +
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
> +	if (!pos)
> +		return;
> +
> +	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
> +	if ((cap & ACS_ENABLED) != ACS_ENABLED)
> +		dev_info(&dev->dev, "ACS P2P upstream not supported\n");

As I read the ACS spec, the Source Validation and Upstream Forwarding
bits must not be implemented for multifunction devices, so you'll produce
this warning for all non-downstream ports that implement ACS.  Not that
I have any of those.

> +	pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);

Couldn't this:

> +	/* Source Validation */
> +	if (cap & PCI_EXP_ACS_V)
> +		ctrl |= PCI_EXP_ACS_V;
> +
> +	/* P2P Request Redirect */
> +	if (cap & PCI_EXP_ACS_R)
> +		ctrl |= PCI_EXP_ACS_R;
> +
> +	/* P2P Completion Redirect */
> +	if (cap & PCI_EXP_ACS_C)
> +		ctrl |= PCI_EXP_ACS_C;
> +
> +	/* Upstream Forwarding */
> +	if (cap & PCI_EXP_ACS_U)
> +		ctrl |= PCI_EXP_ACS_U;

be written more pithily as:

	ctrl |= (cap & ACS_ENABLED);
?

> +	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
> +}
> +
> +/**
>   * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
>   * @dev: the PCI device
>   * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 5ff4d25..1d8976d 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -202,6 +202,7 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
>  {
>  	return bus->self && bus->self->ari_enabled;
>  }
> +extern void pci_acs_init(struct pci_dev *dev);
>  
>  #ifdef CONFIG_PCI_QUIRKS
>  extern int pci_is_reassigndev(struct pci_dev *dev);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 40e75f6..4a5ec9e 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -991,6 +991,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  
>  	/* Single Root I/O Virtualization */
>  	pci_iov_init(dev);
> +
> +	/* Access Control Service */
> +	pci_acs_init(dev);
>  }
>  
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index fcaee42..90014ad 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -492,6 +492,14 @@
>  #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
>  #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
>  
> +#define  PCI_EXP_ACS_V		0x01	/* Source Validation */
> +#define  PCI_EXP_ACS_B		0x02	/* Translation Blocking */
> +#define  PCI_EXP_ACS_R		0x04	/* P2P Request Redirect */
> +#define  PCI_EXP_ACS_C		0x08	/* P2P Completion Redirect */
> +#define  PCI_EXP_ACS_U		0x10	/* Upstream Forwarding */
> +#define  PCI_EXP_ACS_E		0x20	/* P2P Egress Control */
> +#define  PCI_EXP_ACS_T		0x40	/* Direct Translated P2P */

These definitions are in the wrong place and have the wrong name ;-)

You've put them in the part of the file used for the PCI Express capability,
and named them as if they're part of the PCI Express capability.

>  /* Extended Capabilities (PCI-X 2.0 and Express) */
>  #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
>  #define PCI_EXT_CAP_VER(header)		((header >> 16) & 0xf)
> @@ -501,6 +509,7 @@
>  #define PCI_EXT_CAP_ID_VC	2
>  #define PCI_EXT_CAP_ID_DSN	3
>  #define PCI_EXT_CAP_ID_PWR	4
> +#define PCI_EXT_CAP_ID_ACS	13
>  #define PCI_EXT_CAP_ID_ARI	14
>  #define PCI_EXT_CAP_ID_ATS	15
>  #define PCI_EXT_CAP_ID_SRIOV	16
> @@ -661,4 +670,9 @@
>  #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
>  #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
>  
> +/* Access Control Service */
> +#define PCI_ACS_CAP		0x04	/* ACS Capability Register */

They should be down here instead and named like this:

+#define  PCI_ACS_SV		0x01	/* Source Validation */
+#define  PCI_ACS_TB		0x02	/* Translation Blocking */
+#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
+#define  PCI_ACS_CR		0x08	/* P2P Completion Redirect */
+#define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
+#define  PCI_ACS_EC		0x20	/* P2P Egress Control */
+#define  PCI_ACS_DT		0x40	/* Direct Translated P2P */

Now ACS_ENABLED fits on one line again ;-)

#define ACS_ENABLED (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)

> +#define PCI_ACS_CTRL		0x06	/* ACS Control Register */
> +#define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
> +
>  #endif /* LINUX_PCI_REGS_H */

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
