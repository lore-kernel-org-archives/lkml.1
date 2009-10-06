Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbZJFVic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbZJFVic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbZJFVib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:38:31 -0400
Received: from claw.goop.org ([74.207.240.146]:47738 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbZJFVia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:38:30 -0400
Message-ID: <4ACBB8B0.9030102@goop.org>
Date: Tue, 06 Oct 2009 14:37:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Allen Kay <allen.m.kay@intel.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
In-Reply-To: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 13:33, Allen Kay wrote:
> Changes from v3 to v4:
>         - enable ACS only if iommu is enabled or if kernel is running as xen dom0
>         - changed xen_domain_type from enum to #define to allow it to be used
>           in pci/probe.c and to avoid excessive changes to code structure.
>   

Why can't it be used as an enum?

> +++ b/drivers/pci/pci.h
> @@ -311,4 +311,14 @@ static inline int pci_resource_alignment(struct pci_dev *dev,
>  	return resource_alignment(res);
>  }
>  
> +extern void pci_enable_acs(struct pci_dev *dev);
> +
> +#ifdef CONFIG_DMAR
> +extern int iommu_detected;
> +#endif
> +
> +#ifdef CONFIG_XEN
> +extern int xen_domain_type;
> +#endif
>   

That's pretty ugly; duplicate externs are pretty bad idea.  Why not just
include the right header?  If its because its asm-x86, I'm happy to move
the definitions to somewhere more common.

> +
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 8105e32..32703c7 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1014,6 +1014,17 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  
>  	/* Single Root I/O Virtualization */
>  	pci_iov_init(dev);
> +
> +	/* Enable ACS P2P upstream forwarding if HW iommu is detected */
> +	if (iommu_detected)
> +		pci_enable_acs(dev);
> +
> +#ifdef CONFIG_XEN
> +	/* HW iommu is not visible in xen dom0 */
> +	if (xen_domain_type)
> +		pci_enable_acs(dev);
> +#endif
>   

The idea is that you're supposed to use xen_domain() to test for
Xenness; it expands to a constant 0 if Xen isn't configured, so there's
no need to use #ifdefs.

> +
>  }
>  
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index 69a6fba..d13c21c 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -196,7 +196,7 @@ extern irqreturn_t dmar_fault(int irq, void *dev_id);
>  extern int arch_setup_dmar_msi(unsigned int irq);
>  
>  #ifdef CONFIG_DMAR
> -extern int iommu_detected, no_iommu;
> +extern int no_iommu;
>  extern struct list_head dmar_rmrr_units;
>  struct dmar_rmrr_unit {
>  	struct list_head list;		/* list of rmrr units	*/
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index dd0bed4..d798770 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -502,6 +502,7 @@
>  #define PCI_EXT_CAP_ID_VC	2
>  #define PCI_EXT_CAP_ID_DSN	3
>  #define PCI_EXT_CAP_ID_PWR	4
> +#define PCI_EXT_CAP_ID_ACS	13
>  #define PCI_EXT_CAP_ID_ARI	14
>  #define PCI_EXT_CAP_ID_ATS	15
>  #define PCI_EXT_CAP_ID_SRIOV	16
> @@ -662,4 +663,16 @@
>  #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
>  #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
>  
> +/* Access Control Service */
> +#define PCI_ACS_CAP		0x04	/* ACS Capability Register */
> +#define  PCI_ACS_SV		0x01	/* Source Validation */
> +#define  PCI_ACS_TB		0x02	/* Translation Blocking */
> +#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
> +#define  PCI_ACS_CR		0x08	/* P2P Completion Redirect */
> +#define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
> +#define  PCI_ACS_EC		0x20	/* P2P Egress Control */
> +#define  PCI_ACS_DT		0x40	/* Direct Translated P2P */
> +#define PCI_ACS_CTRL		0x06	/* ACS Control Register */
> +#define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
> +
>  #endif /* LINUX_PCI_REGS_H */
>   

NAK

    J
