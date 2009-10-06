Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbZJFWCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbZJFWCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbZJFWCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:02:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:18105 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144AbZJFWCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:02:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,515,1249282800"; 
   d="scan'208";a="500471180"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@sous-sol.org" <chris@sous-sol.org>
Date: Tue, 6 Oct 2009 15:01:34 -0700
Subject: RE: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Topic: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Index: AcpGzUsjZj+ktnSRSYK/HqBRdwJsSgAAEy6QAAC11oA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
 <4ACBB8B0.9030102@goop.org> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better move to somewhere arch independent as I'm calling this in architectural independent PCI driver code.

-----Original Message-----
From: Kay, Allen M 
Sent: Tuesday, October 06, 2009 2:47 PM
To: 'Jeremy Fitzhardinge'
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx; chris@sous-sol.org
Subject: RE: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding

> That's pretty ugly; duplicate externs are pretty bad idea.  Why not just
> include the right header?  If its because its asm-x86, I'm happy to move
> the definitions to somewhere more common.

The main reason is lack of access of xen header files in driver/pci directory.  If we can move xen header files to include/asm-x86, then the ugliness will go away.

Specifically, I would like to access header file containing xen_domain_type and associated enum definition from driver/pci directory.

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: Tuesday, October 06, 2009 2:38 PM
To: Kay, Allen M
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx; chris@sous-sol.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding

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
