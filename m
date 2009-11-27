Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZK0H4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZK0H4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZK0Hz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:55:59 -0500
Received: from usul.overt.org ([204.11.33.43]:44839 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZK0Hz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:55:58 -0500
Date: Thu, 26 Nov 2009 23:55:51 -0800
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] port ricoh_mmc to be pci quirk
Message-ID: <20091126235551.2db699e3@fido2.homeip.net>
In-Reply-To: <1259279584.3991.6.camel@maxim-laptop>
References: <1259021583.16650.9.camel@maxim-laptop>
	<20091123162119.3777e14d@fido2.homeip.net>
	<1259160947.10147.1.camel@maxim-laptop>
	<1259161121.10147.4.camel@maxim-laptop>
	<20091125085324.1ef9ae1f@fido2.homeip.net>
	<20091125113501.1f4d42b9.akpm@linux-foundation.org>
	<1259192401.15916.48.camel@maxim-laptop>
	<20091125173019.74d0ddb9@fido2.homeip.net>
	<1259279520.3991.5.camel@maxim-laptop>
	<1259279584.3991.6.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 01:53:04 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> >From 2d3002e29c329d76ca4e26d9f427814151a9648c Mon Sep 17 00:00:00
> >2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 27 Nov 2009 00:53:28 +0200
> Subject: [PATCH] port ricoh_mmc to be pci quirk
> 
> This patch solves nasty problem original driver has.
> Original goal of the ricoh_mmc was to disable this device because
> then, mmc cards can be read using standard SDHCI controller,
> thus avoiding writing of yet another driver.
> However, the act of disablement, makes other pci functions that
> belong to this controller (xD and memstick) shift up one level, thus
> pci core has now wrong idea about these devices.
> 
> To fix this issue, this patch moves the driver into pci quirk
> section, thus it is executes before the pci is enumerated, and
> therefore solving that issue, also same sequence of commands is
> performed on resume for same reasons.
> 
> Also regardless of the above, this way is cleaner.
> 
> You still need to set CONFIG_MMC_RICOH_MMC
> to enable this quirk

I like it. Only comment is that I'd like the printks to identify which
controller is involved. If Andrew is happy with the CONFIG mechanism,
then you've got an ack from me.

Thanks for doing this.

--phil

> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mmc/host/Kconfig     |   10 +-
>  drivers/mmc/host/Makefile    |    1 -
>  drivers/mmc/host/ricoh_mmc.c |  262
> ------------------------------------------
> drivers/pci/quirks.c         |   92 +++++++++++++++ 4 files changed,
> 95 insertions(+), 270 deletions(-) delete mode 100644
> drivers/mmc/host/ricoh_mmc.c
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 432ae83..5cf4beb 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -56,20 +56,16 @@ config MMC_SDHCI_PCI
>  	  If unsure, say N.
>  
>  config MMC_RICOH_MMC
> -	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
> +	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
>  	depends on MMC_SDHCI_PCI
>  	help
> -	  This selects the disabler for the Ricoh MMC Controller.
> This
> +	  This adds a pci quirk to disable Ricoh MMC Controller. This
>  	  proprietary controller is unnecessary because the SDHCI
> driver supports MMC cards on the SD controller, but if it is not
>  	  disabled, it will steal the MMC cards away - rendering them
> -	  useless. It is safe to select this driver even if you don't
> +	  useless. It is safe to select this even if you don't
>  	  have a Ricoh based card reader.
>  
> -
> -	  To compile this driver as a module, choose M here:
> -	  the module will be called ricoh_mmc.
> -
>  	  If unsure, say Y.
>  
>  config MMC_SDHCI_OF
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index abcb040..7b82394 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -12,7 +12,6 @@ obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
>  obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
>  obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
>  obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
> -obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
>  obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
>  obj-$(CONFIG_MMC_SDHCI_PLTFM)	+= sdhci-pltfm.o
>  obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
> diff --git a/drivers/mmc/host/ricoh_mmc.c
> b/drivers/mmc/host/ricoh_mmc.c deleted file mode 100644
> index f627905..0000000
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ /dev/null
> @@ -1,262 +0,0 @@
> -/*
> - *  ricoh_mmc.c - Dummy driver to disable the Rioch MMC controller.
> - *
> - *  Copyright (C) 2007 Philip Langdale, All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> modify
> - * it under the terms of the GNU General Public License as published
> by
> - * the Free Software Foundation; either version 2 of the License, or
> (at
> - * your option) any later version.
> - */
> -
> -/*
> - * This is a conceptually ridiculous driver, but it is required by
> the way
> - * the Ricoh multi-function chips (R5CXXX) work. These chips
> implement
> - * the four main memory card controllers (SD, MMC, MS, xD) and one
> or both
> - * of cardbus or firewire. It happens that they implement SD and MMC
> - * support as separate controllers (and PCI functions). The linux
> SDHCI
> - * driver supports MMC cards but the chip detects MMC cards in
> hardware
> - * and directs them to the MMC controller - so the SDHCI driver
> never sees
> - * them. To get around this, we must disable the useless MMC
> controller.
> - * At that point, the SDHCI controller will start seeing them. As a
> bonus,
> - * a detection event occurs immediately, even if the MMC card is
> already
> - * in the reader.
> - *
> - * It seems to be the case that the relevant PCI registers to
> deactivate the
> - * MMC controller live on PCI function 0, which might be the cardbus
> controller
> - * or the firewire controller, depending on the particular chip in
> question. As
> - * such, it makes what this driver has to do unavoidably ugly. Such
> is life.
> - */
> -
> -#include <linux/pci.h>
> -
> -#define DRIVER_NAME "ricoh-mmc"
> -
> -static const struct pci_device_id pci_ids[] __devinitdata = {
> -	{
> -		.vendor		= PCI_VENDOR_ID_RICOH,
> -		.device		= PCI_DEVICE_ID_RICOH_R5C843,
> -		.subvendor	= PCI_ANY_ID,
> -		.subdevice	= PCI_ANY_ID,
> -	},
> -	{ /* end: all zeroes */ },
> -};
> -
> -MODULE_DEVICE_TABLE(pci, pci_ids);
> -
> -static int ricoh_mmc_disable(struct pci_dev *fw_dev)
> -{
> -	u8 write_enable;
> -	u8 write_target;
> -	u8 disable;
> -
> -	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> -		/* via RL5C476 */
> -
> -		pci_read_config_byte(fw_dev, 0xB7, &disable);
> -		if (disable & 0x02) {
> -			printk(KERN_INFO DRIVER_NAME
> -				": Controller already disabled. " \
> -				"Nothing to do.\n");
> -			return -ENODEV;
> -		}
> -
> -		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
> -		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
> -		pci_read_config_byte(fw_dev, 0x8D, &write_target);
> -		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
> -		pci_write_config_byte(fw_dev, 0xB7, disable | 0x02);
> -		pci_write_config_byte(fw_dev, 0x8E, write_enable);
> -		pci_write_config_byte(fw_dev, 0x8D, write_target);
> -	} else {
> -		/* via R5C832 */
> -
> -		pci_read_config_byte(fw_dev, 0xCB, &disable);
> -		if (disable & 0x02) {
> -			printk(KERN_INFO DRIVER_NAME
> -			       ": Controller already disabled. " \
> -				"Nothing to do.\n");
> -			return -ENODEV;
> -		}
> -
> -		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -		pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -		pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
> -		pci_write_config_byte(fw_dev, 0xCA, write_enable);
> -	}
> -
> -	printk(KERN_INFO DRIVER_NAME
> -	       ": Controller is now disabled.\n");
> -
> -	return 0;
> -}
> -
> -static int ricoh_mmc_enable(struct pci_dev *fw_dev)
> -{
> -	u8 write_enable;
> -	u8 write_target;
> -	u8 disable;
> -
> -	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> -		/* via RL5C476 */
> -
> -		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
> -		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
> -		pci_read_config_byte(fw_dev, 0x8D, &write_target);
> -		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
> -		pci_read_config_byte(fw_dev, 0xB7, &disable);
> -		pci_write_config_byte(fw_dev, 0xB7, disable & ~0x02);
> -		pci_write_config_byte(fw_dev, 0x8E, write_enable);
> -		pci_write_config_byte(fw_dev, 0x8D, write_target);
> -	} else {
> -		/* via R5C832 */
> -
> -		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -		pci_read_config_byte(fw_dev, 0xCB, &disable);
> -		pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -		pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> -		pci_write_config_byte(fw_dev, 0xCA, write_enable);
> -	}
> -
> -	printk(KERN_INFO DRIVER_NAME
> -	       ": Controller is now re-enabled.\n");
> -
> -	return 0;
> -}
> -
> -static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
> -				     const struct pci_device_id *ent)
> -{
> -	u8 rev;
> -	u8 ctrlfound = 0;
> -
> -	struct pci_dev *fw_dev = NULL;
> -
> -	BUG_ON(pdev == NULL);
> -	BUG_ON(ent == NULL);
> -
> -	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &rev);
> -
> -	printk(KERN_INFO DRIVER_NAME
> -		": Ricoh MMC controller found at %s [%04x:%04x] (rev
> %x)\n",
> -		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
> -		(int)rev);
> -
> -	while ((fw_dev =
> -		pci_get_device(PCI_VENDOR_ID_RICOH,
> -			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
> -		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn)
> &&
> -		    PCI_FUNC(fw_dev->devfn) == 0 &&
> -		    pdev->bus == fw_dev->bus) {
> -			if (ricoh_mmc_disable(fw_dev) != 0)
> -				return -ENODEV;
> -
> -			pci_set_drvdata(pdev, fw_dev);
> -
> -			++ctrlfound;
> -			break;
> -		}
> -	}
> -
> -	fw_dev = NULL;
> -
> -	while (!ctrlfound &&
> -	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
> -					PCI_DEVICE_ID_RICOH_R5C832,
> fw_dev))) {
> -		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn)
> &&
> -		    PCI_FUNC(fw_dev->devfn) == 0 &&
> -		    pdev->bus == fw_dev->bus) {
> -			if (ricoh_mmc_disable(fw_dev) != 0)
> -				return -ENODEV;
> -
> -			pci_set_drvdata(pdev, fw_dev);
> -
> -			++ctrlfound;
> -		}
> -	}
> -
> -	if (!ctrlfound) {
> -		printk(KERN_WARNING DRIVER_NAME
> -		       ": Main Ricoh function not found. Cannot
> disable controller.\n");
> -		return -ENODEV;
> -	}
> -
> -	return 0;
> -}
> -
> -static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
> -{
> -	struct pci_dev *fw_dev = NULL;
> -
> -	fw_dev = pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev == NULL);
> -
> -	ricoh_mmc_enable(fw_dev);
> -
> -	pci_set_drvdata(pdev, NULL);
> -}
> -
> -static int ricoh_mmc_suspend_late(struct pci_dev *pdev, pm_message_t
> state) -{
> -	struct pci_dev *fw_dev = NULL;
> -
> -	fw_dev = pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev == NULL);
> -
> -	printk(KERN_INFO DRIVER_NAME ": Suspending.\n");
> -
> -	ricoh_mmc_enable(fw_dev);
> -
> -	return 0;
> -}
> -
> -static int ricoh_mmc_resume_early(struct pci_dev *pdev)
> -{
> -	struct pci_dev *fw_dev = NULL;
> -
> -	fw_dev = pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev == NULL);
> -
> -	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
> -
> -	ricoh_mmc_disable(fw_dev);
> -
> -	return 0;
> -}
> -
> -static struct pci_driver ricoh_mmc_driver = {
> -	.name = 	DRIVER_NAME,
> -	.id_table =	pci_ids,
> -	.probe = 	ricoh_mmc_probe,
> -	.remove =	__devexit_p(ricoh_mmc_remove),
> -	.suspend_late =	ricoh_mmc_suspend_late,
> -	.resume_early =	ricoh_mmc_resume_early,
> -};
> -
> -/*****************************************************************************\
> -
> *
> *
> - * Driver
> init/exit                                                          *
> -
> *
> *
> -\*****************************************************************************/
> - -static int __init ricoh_mmc_drv_init(void) -{
> -	printk(KERN_INFO DRIVER_NAME
> -		": Ricoh MMC Controller disabling driver\n");
> -	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Philip
> Langdale\n"); -
> -	return pci_register_driver(&ricoh_mmc_driver);
> -}
> -
> -static void __exit ricoh_mmc_drv_exit(void)
> -{
> -	pci_unregister_driver(&ricoh_mmc_driver);
> -}
> -
> -module_init(ricoh_mmc_drv_init);
> -module_exit(ricoh_mmc_drv_exit);
> -
> -MODULE_AUTHOR("Philip Langdale <philipl@alumni.utexas.net>");
> -MODULE_DESCRIPTION("Ricoh MMC Controller disabling driver");
> -MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 245d2cd..c8b0f0f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2516,6 +2516,98 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,
> 0x150d, quirk_i82576_sriov); 
>  #endif	/* CONFIG_PCI_IOV */
>  
> +/*
> + * This is a quirk for Ricoh MMC controller found as a part of
> + * mulifunction chip.
> +
> + * This is very similiar and based on ricoh_mmc driver
> + * written by Philip Langdale. Thank you for these magic sequencies.
> +
> + * These chips implement the four main memory card
> + * controllers (SD, MMC, MS, xD) and one or both
> + * of cardbus or firewire. It happens that they implement SD and MMC
> + * support as separate controllers (and PCI functions). The linux
> SDHCI
> + * driver supports MMC cards but the chip detects MMC cards in
> hardware
> + * and directs them to the MMC controller - so the SDHCI driver
> never sees
> + * them. To get around this, we must disable the useless MMC
> controller.
> + * At that point, the SDHCI controller will start seeing them
> + * It seems to be the case that the relevant PCI registers to
> deactivate the
> + * MMC controller live on PCI function 0, which might be the cardbus
> controller
> + * or the firewire controller, depending on the particular chip in
> question +
> + * This has to be done early, because as soon as we disable the MMC
> controller
> + * other pci functions shift up one level, e.g. function #2 becames
> function
> + * #1, and therefore is confusing the pci core.
> + */
> +
> +#ifdef CONFIG_MMC_RICOH_MMC
> +static void ricoh_mmc_fixup_rl5c476(struct pci_dev *dev)
> +{
> +	/* disable via cardbus interface */
> +	u8 write_enable;
> +	u8 write_target;
> +	u8 disable;
> +
> +	/* disable must be done via function #0 */
> +	if (PCI_FUNC(dev->devfn))
> +		return;
> +
> +	pci_read_config_byte(dev, 0xB7, &disable);
> +	if (disable & 0x02)
> +		return;
> +
> +	pci_read_config_byte(dev, 0x8E, &write_enable);
> +	pci_write_config_byte(dev, 0x8E, 0xAA);
> +	pci_read_config_byte(dev, 0x8D, &write_target);
> +	pci_write_config_byte(dev, 0x8D, 0xB7);
> +	pci_write_config_byte(dev, 0xB7, disable | 0x02);
> +	pci_write_config_byte(dev, 0x8E, write_enable);
> +	pci_write_config_byte(dev, 0x8D, write_target);
> +
> +	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
> +	printk(KERN_NOTICE "pci: mmc cards will be supported through
> SDHCI\n"); +}
> +
> +static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
> +{
> +	/* disable via firewire interface */
> +	u8 write_enable;
> +	u8 disable;
> +
> +	/* disable must be done via function #0 */
> +	if (PCI_FUNC(dev->devfn))
> +		return;
> +
> +	pci_read_config_byte(dev, 0xCB, &disable);
> +
> +	if (disable & 0x02)
> +		return;
> +
> +	pci_read_config_byte(dev, 0xCA, &write_enable);
> +	pci_write_config_byte(dev, 0xCA, 0x57);
> +	pci_write_config_byte(dev, 0xCB, disable | 0x02);
> +	pci_write_config_byte(dev, 0xCA, write_enable);
> +
> +	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
> +	printk(KERN_NOTICE "pci: mmc cards will be supported through
> SDHCI\n"); +}
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_RL5C476,
> +	ricoh_mmc_fixup_rl5c476);
> +
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_RL5C476,
> +	ricoh_mmc_fixup_rl5c476);
> +
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_R5C832,
> +	ricoh_mmc_fixup_r5c832);
> +
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_R5C832,
> +	ricoh_mmc_fixup_r5c832);
> +
> +#endif /*CONFIG_MMC_RICOH_MMC*/
> +
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {




--phil
