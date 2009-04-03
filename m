Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZDCCI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZDCCI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZDCCIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:08:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60272 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZDCCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:08:16 -0400
Message-ID: <49D56F87.9030104@jp.fujitsu.com>
Date: Fri, 03 Apr 2009 11:08:07 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] Add support for turning PCIe ECRC on or off
References: <20090402221751.11757.36392.stgit@bob.kio>
In-Reply-To: <20090402221751.11757.36392.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson wrote:
> Add support for turning PCIe ECRC on or off
> 
> Adds support for PCI Express transaction layer end-to-end CRC checking
> (ECRC).  This patch will enable/disable ECRC checking by setting/clearing
> the ECRC Check Enable and/or ECRC Generation Enable bits for devices that
> support ECRC.
> 
> The ECRC setting is controlled by the "pcie_ecrc=" command-line option. If
> this option is not set or is set to 'default", the enable and generation
> bits are left in whatever state that firmware/BIOS sets them to.  The
> "off" setting turns them off, and the "on" option turns them on (if the
> device supports it).
> 
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> ---
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1754fed..c346b55 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1776,6 +1776,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  		force	Enable ASPM even on devices that claim not to support it.
>  			WARNING: Forcing ASPM on may cause system lockups.
>  
> +	pcie_ecrc=	[PCI] Enable/disable PCIe ECRC (transaction layer
> +			end-to-end CRC checking).
> +			pcie_ecrc=default: Use BIOS/firmware settings.
> +			pcie_ecrc=off: Turn ECRC off
> +			pcie_ecrc=on: Turn ECRC on.
> +
>  	pcmv=		[HW,PCMCIA] BadgePAD 4
>  
>  	pd.		[PARIDE]
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index 5a0c6ad..d90f831 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -46,3 +46,15 @@ config PCIEASPM_DEBUG
>  	help
>  	  This enables PCI Express ASPM debug support. It will add per-device
>  	  interface to control ASPM.
> +
> +#
> +# PCI Express ECRC
> +#
> +config PCIEECRC
> +	bool "PCI Express ECRC support"
> +	depends on PCI
> +	help
> +	  Enables PCI Express ECRC (transaction layer end-to-end CRC
> +	  checking)
> +
> +	  When in doubt, say N.
> diff --git a/drivers/pci/pcie/Makefile b/drivers/pci/pcie/Makefile
> index 11f6bb1..acef212 100644
> --- a/drivers/pci/pcie/Makefile
> +++ b/drivers/pci/pcie/Makefile
> @@ -5,6 +5,9 @@
>  # Build PCI Express ASPM if needed
>  obj-$(CONFIG_PCIEASPM)		+= aspm.o
>  
> +# Build PCI Express ECRC if needed
> +obj-$(CONFIG_PCIEECRC)		+= ecrc.o
> +
>  pcieportdrv-y			:= portdrv_core.o portdrv_pci.o portdrv_bus.o
>  
>  obj-$(CONFIG_PCIEPORTBUS)	+= pcieportdrv.o
> diff --git a/drivers/pci/pcie/ecrc.c b/drivers/pci/pcie/ecrc.c
> new file mode 100644
> index 0000000..eeb93df
> --- /dev/null
> +++ b/drivers/pci/pcie/ecrc.c
> @@ -0,0 +1,94 @@
> +/*
> + *    Enables/disables PCIe ECRC checking.
> + *
> + *    (C) Copyright 20009 Hewlett-Packard Development Company, L.P.
> + *    Andrew Patterson <andrew.patterson@hp.com>
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; version 2 of the License.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + *    General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + *    02111-1307, USA.
> + *
> + */
> +
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/pci.h>
> +#include <linux/pci_regs.h>
> +#include <linux/errno.h>
> +#include "../pci.h"
> +
> +#define ECRC_POLICY_DEFAULT 0		/* ECRC set by BIOS */
> +#define ECRC_POLICY_OFF     1		/* ECRC off */
> +#define ECRC_POLICY_ON      2		/* ECRC on */
> +
> +static int ecrc_policy = ECRC_POLICY_DEFAULT;
> +
> +static const char *ecrc_policy_str[] = {
> +	[ECRC_POLICY_DEFAULT] = "default",
> +	[ECRC_POLICY_OFF] = "off",
> +	[ECRC_POLICY_ON] = "on"
> +};
> +
> +/**
> + * pcie_set_ercr_checking - enable/disable PCIe ECRC checking
> + * @dev: the PCI device
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int pcie_set_ecrc_checking(struct pci_dev *dev)
> +{
> +	int pos;
> +	u32 reg32;
> +
> +	if (!dev->is_pcie)
> +		return -ENODEV;
> +
> +	/* Use firmware/BIOS setting if default */
> +	if (ecrc_policy == ECRC_POLICY_DEFAULT)
> +		return 0;
> +
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
> +	if (!pos)
> +		return -ENODEV;
> +
> +	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
> +	if (ecrc_policy == ECRC_POLICY_OFF) {
> +		reg32 &= ~(PCI_ERR_CAP_ECRC_GENE | PCI_ERR_CAP_ECRC_CHKE);
> +	} else if (ecrc_policy == ECRC_POLICY_ON) {
> +		if (reg32 & PCI_ERR_CAP_ECRC_GENC)
> +			reg32 |= PCI_ERR_CAP_ECRC_GENE;
> +		if (reg32 & PCI_ERR_CAP_ECRC_CHKC)
> +			reg32 |= PCI_ERR_CAP_ECRC_CHKE;
> +	}
> +	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pcie_set_ecrc_checking);

I think this EXPORT_SYMBOL_GPL() is redundant.

By the way, I have the following question and comment, though I'm not
familiar with ECRC at all.

- This patch seems to change PCI Express Advanced Error capabilities
  and Control Register. Can we do it without requesting control over
  PCI Express Advanced Error reporting?

- What about implementing ECRC on/off feature as one of the feature
  of existing AER driver.

Thanks,
Kenji Kaneshige



> +
> +static int __init pcie_ecrc_get_policy(char *str)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ecrc_policy_str); i++)
> +		if (!strncmp(str, ecrc_policy_str[i],
> +			     strlen(ecrc_policy_str[i])))
> +			break;
> +	if (i >= ARRAY_SIZE(ecrc_policy_str))
> +		return 0;
> +
> +	ecrc_policy = i;
> +	return 1;
> +}
> +__setup("pcie_ecrc=", pcie_ecrc_get_policy);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e2f3dd0..e2b0ab5 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -984,6 +984,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  
>  	/* Single Root I/O Virtualization */
>  	pci_iov_init(dev);
> +
> +	/* PCIe ECRC */
> +	pcie_set_ecrc_checking(dev);
>  }
>  
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 507552d..080afd8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -879,6 +879,15 @@ static inline int pcie_aspm_enabled(void)
>  extern int pcie_aspm_enabled(void);
>  #endif
>  
> +#ifndef CONFIG_PCIEECRC
> +static inline int pcie_set_ecrc_checking(struct pci_dev *dev)
> +{
> +	return 0;
> +}
> +#else
> +extern int pcie_set_ecrc_checking(struct pci_dev *dev);
> +#endif
> +
>  #define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
>  
>  #ifdef CONFIG_HT_IRQ
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


