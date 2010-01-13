Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868Ab0AMGrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0AMGrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277Ab0AMGrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:47:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59053 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0AMGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:47:11 -0500
Date: Wed, 13 Jan 2010 07:46:57 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philip Langdale <philipl@overt.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] port ricoh_mmc to be pci quirk
Message-ID: <20100113064657.GB10955@pengutronix.de>
References: <20091125085324.1ef9ae1f@fido2.homeip.net> <20091125113501.1f4d42b9.akpm@linux-foundation.org> <1259192401.15916.48.camel@maxim-laptop> <20091125173019.74d0ddb9@fido2.homeip.net> <1259279520.3991.5.camel@maxim-laptop> <1259279584.3991.6.camel@maxim-laptop> <20091126235551.2db699e3@fido2.homeip.net> <1262964284.12577.27.camel@maxim-laptop> <20100108074001.5df6c997@fido2.homeip.net> <20100112154350.8fa96829.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <20100112154350.8fa96829.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2010 at 03:43:50PM -0800, Andrew Morton wrote:

> I have a note here that Pierre had issues with the patch.  I'm
> uncertain whether those are now resolved?

Looks good in general, minor things I noticed:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
>=20
> This patch solves nasty problem original driver has.
>=20
> Original goal of the ricoh_mmc was to disable this device because then,
> mmc cards can be read using standard SDHCI controller, thus avoiding
> writing of yet another driver.
>=20
> However, the act of disablement, makes other pci functions that belong to
> this controller (xD and memstick) shift up one level, thus pci core has
> now wrong idea about these devices.
>=20
> To fix this issue, this patch moves the driver into the pci quirk section,
> thus it is executes before the pci is enumerated, and therefore solving
> that issue, also same sequence of commands is performed on resume for same
> reasons.
>=20
> Also regardless of the above, this way is cleaner.  You still need to set
> CONFIG_MMC_RICOH_MMC to enable this quirk
>=20
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Philip Langdale <philipl@overt.org>
> Cc: <linux-mmc@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  drivers/mmc/host/Kconfig     |   10 -
>  drivers/mmc/host/Makefile    |    1=20
>  drivers/mmc/host/ricoh_mmc.c |  262 ---------------------------------
>  drivers/pci/quirks.c         |   92 +++++++++++
>  4 files changed, 95 insertions(+), 270 deletions(-)
>=20
> diff -puN drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quir=
k drivers/mmc/host/Kconfig
> --- a/drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quirk
> +++ a/drivers/mmc/host/Kconfig
> @@ -69,20 +69,16 @@ config MMC_SDHCI_PCI
>  	  If unsure, say N.
> =20
>  config MMC_RICOH_MMC
> -	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
> +	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
>  	depends on MMC_SDHCI_PCI
>  	help
> -	  This selects the disabler for the Ricoh MMC Controller. This
> +	  This adds a pci quirk to disable Ricoh MMC Controller. This
>  	  proprietary controller is unnecessary because the SDHCI driver
>  	  supports MMC cards on the SD controller, but if it is not
>  	  disabled, it will steal the MMC cards away - rendering them
> -	  useless. It is safe to select this driver even if you don't
> +	  useless. It is safe to select this even if you don't
>  	  have a Ricoh based card reader.
> =20
> -
> -	  To compile this driver as a module, choose M here:
> -	  the module will be called ricoh_mmc.
> -
>  	  If unsure, say Y.
> =20
>  config MMC_SDHCI_OF
> diff -puN drivers/mmc/host/Makefile~ricoh_mmc-port-from-driver-to-pci-qui=
rk drivers/mmc/host/Makefile
> --- a/drivers/mmc/host/Makefile~ricoh_mmc-port-from-driver-to-pci-quirk
> +++ a/drivers/mmc/host/Makefile
> @@ -12,7 +12,6 @@ obj-$(CONFIG_MMC_IMX)		+=3D imxmmc.o
>  obj-$(CONFIG_MMC_MXC)		+=3D mxcmmc.o
>  obj-$(CONFIG_MMC_SDHCI)		+=3D sdhci.o
>  obj-$(CONFIG_MMC_SDHCI_PCI)	+=3D sdhci-pci.o
> -obj-$(CONFIG_MMC_RICOH_MMC)	+=3D ricoh_mmc.o
>  obj-$(CONFIG_MMC_SDHCI_PLTFM)	+=3D sdhci-pltfm.o
>  obj-$(CONFIG_MMC_SDHCI_S3C)	+=3D sdhci-s3c.o
>  obj-$(CONFIG_MMC_WBSD)		+=3D wbsd.o
> diff -puN drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-port-from-driver-to-pci-=
quirk /dev/null
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ /dev/null
> @@ -1,262 +0,0 @@
> -/*
> - *  ricoh_mmc.c - Dummy driver to disable the Rioch MMC controller.
> - *
> - *  Copyright (C) 2007 Philip Langdale, All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or (at
> - * your option) any later version.
> - */
> -
> -/*
> - * This is a conceptually ridiculous driver, but it is required by the w=
ay
> - * the Ricoh multi-function chips (R5CXXX) work. These chips implement
> - * the four main memory card controllers (SD, MMC, MS, xD) and one or bo=
th
> - * of cardbus or firewire. It happens that they implement SD and MMC
> - * support as separate controllers (and PCI functions). The linux SDHCI
> - * driver supports MMC cards but the chip detects MMC cards in hardware
> - * and directs them to the MMC controller - so the SDHCI driver never se=
es
> - * them. To get around this, we must disable the useless MMC controller.
> - * At that point, the SDHCI controller will start seeing them. As a bonu=
s,
> - * a detection event occurs immediately, even if the MMC card is already
> - * in the reader.
> - *
> - * It seems to be the case that the relevant PCI registers to deactivate=
 the
> - * MMC controller live on PCI function 0, which might be the cardbus con=
troller
> - * or the firewire controller, depending on the particular chip in quest=
ion. As
> - * such, it makes what this driver has to do unavoidably ugly. Such is l=
ife.
> - */
> -
> -#include <linux/pci.h>
> -
> -#define DRIVER_NAME "ricoh-mmc"
> -
> -static const struct pci_device_id pci_ids[] __devinitdata =3D {
> -	{
> -		.vendor		=3D PCI_VENDOR_ID_RICOH,
> -		.device		=3D PCI_DEVICE_ID_RICOH_R5C843,
> -		.subvendor	=3D PCI_ANY_ID,
> -		.subdevice	=3D PCI_ANY_ID,
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
> -	if (fw_dev->device =3D=3D PCI_DEVICE_ID_RICOH_RL5C476) {
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
> -	if (fw_dev->device =3D=3D PCI_DEVICE_ID_RICOH_RL5C476) {
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
> -	u8 ctrlfound =3D 0;
> -
> -	struct pci_dev *fw_dev =3D NULL;
> -
> -	BUG_ON(pdev =3D=3D NULL);
> -	BUG_ON(ent =3D=3D NULL);
> -
> -	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &rev);
> -
> -	printk(KERN_INFO DRIVER_NAME
> -		": Ricoh MMC controller found at %s [%04x:%04x] (rev %x)\n",
> -		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
> -		(int)rev);
> -
> -	while ((fw_dev =3D
> -		pci_get_device(PCI_VENDOR_ID_RICOH,
> -			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
> -		if (PCI_SLOT(pdev->devfn) =3D=3D PCI_SLOT(fw_dev->devfn) &&
> -		    PCI_FUNC(fw_dev->devfn) =3D=3D 0 &&
> -		    pdev->bus =3D=3D fw_dev->bus) {
> -			if (ricoh_mmc_disable(fw_dev) !=3D 0)
> -				return -ENODEV;
> -
> -			pci_set_drvdata(pdev, fw_dev);
> -
> -			++ctrlfound;
> -			break;
> -		}
> -	}
> -
> -	fw_dev =3D NULL;
> -
> -	while (!ctrlfound &&
> -	    (fw_dev =3D pci_get_device(PCI_VENDOR_ID_RICOH,
> -					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
> -		if (PCI_SLOT(pdev->devfn) =3D=3D PCI_SLOT(fw_dev->devfn) &&
> -		    PCI_FUNC(fw_dev->devfn) =3D=3D 0 &&
> -		    pdev->bus =3D=3D fw_dev->bus) {
> -			if (ricoh_mmc_disable(fw_dev) !=3D 0)
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
> -		       ": Main Ricoh function not found. Cannot disable controller.\n"=
);
> -		return -ENODEV;
> -	}
> -
> -	return 0;
> -}
> -
> -static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
> -{
> -	struct pci_dev *fw_dev =3D NULL;
> -
> -	fw_dev =3D pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev =3D=3D NULL);
> -
> -	ricoh_mmc_enable(fw_dev);
> -
> -	pci_set_drvdata(pdev, NULL);
> -}
> -
> -static int ricoh_mmc_suspend_late(struct pci_dev *pdev, pm_message_t sta=
te)
> -{
> -	struct pci_dev *fw_dev =3D NULL;
> -
> -	fw_dev =3D pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev =3D=3D NULL);
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
> -	struct pci_dev *fw_dev =3D NULL;
> -
> -	fw_dev =3D pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev =3D=3D NULL);
> -
> -	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
> -
> -	ricoh_mmc_disable(fw_dev);
> -
> -	return 0;
> -}
> -
> -static struct pci_driver ricoh_mmc_driver =3D {
> -	.name =3D 	DRIVER_NAME,
> -	.id_table =3D	pci_ids,
> -	.probe =3D 	ricoh_mmc_probe,
> -	.remove =3D	__devexit_p(ricoh_mmc_remove),
> -	.suspend_late =3D	ricoh_mmc_suspend_late,
> -	.resume_early =3D	ricoh_mmc_resume_early,
> -};
> -
> -/***********************************************************************=
******\
> - *                                                                      =
     *
> - * Driver init/exit                                                     =
     *
> - *                                                                      =
     *
> -\***********************************************************************=
******/
> -
> -static int __init ricoh_mmc_drv_init(void)
> -{
> -	printk(KERN_INFO DRIVER_NAME
> -		": Ricoh MMC Controller disabling driver\n");
> -	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Philip Langdale\n");
> -
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
> diff -puN drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk dr=
ivers/pci/quirks.c
> --- a/drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk
> +++ a/drivers/pci/quirks.c
> @@ -2515,6 +2515,98 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
> =20
>  #endif	/* CONFIG_PCI_IOV */
> =20
> +/*
> + * This is a quirk for Ricoh MMC controller found as a part of
> + * mulifunction chip.
> +
> + * This is very similiar and based on ricoh_mmc driver
> + * written by Philip Langdale. Thank you for these magic sequencies.

"sequences"

> +
> + * These chips implement the four main memory card
> + * controllers (SD, MMC, MS, xD) and one or both

Reformat the paragraph?

> + * of cardbus or firewire. It happens that they implement SD and MMC
> + * support as separate controllers (and PCI functions). The linux SDHCI
> + * driver supports MMC cards but the chip detects MMC cards in hardware
> + * and directs them to the MMC controller - so the SDHCI driver never se=
es
> + * them. To get around this, we must disable the useless MMC controller.
> + * At that point, the SDHCI controller will start seeing them
> + * It seems to be the case that the relevant PCI registers to deactivate=
 the
> + * MMC controller live on PCI function 0, which might be the cardbus con=
troller
> + * or the firewire controller, depending on the particular chip in quest=
ion
> +
> + * This has to be done early, because as soon as we disable the MMC cont=
roller
> + * other pci functions shift up one level, e.g. function #2 becames func=
tion

"becomes"

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
> +	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");

dev_notice? I'd prefer it and all other quirks use dev_*, too.

> +}
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
> +	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");

dev_notice?

> +}
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
> +	ricoh_mmc_fixup_rl5c476);
> +
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_=
RL5C476,
> +	ricoh_mmc_fixup_rl5c476);
> +
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
> +	ricoh_mmc_fixup_r5c832);
> +
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_=
R5C832,
> +	ricoh_mmc_fixup_r5c832);

Like the other quirks, the declare statements should be directly after the
corresponding fixup-function.

> +
> +#endif /*CONFIG_MMC_RICOH_MMC*/
> +
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {
> _
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the work!

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktNbGEACgkQD27XaX1/VRsUpgCgwAzmyR6jTOem/lC+BEVrQ8D3
jDgAn2YmXxLSCP0y7WnDydzV+h49NA0U
=KSN3
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
