Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZCTT0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZCTT0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZCTTZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:25:59 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:44449 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZCTTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:25:57 -0400
Subject: Re: [PATCH v2] acpi: Populate DIDL before registering ACPI video
 device on Intel
From: Eric Anholt <eric@anholt.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090319213539.GA24898@srcf.ucam.org>
References: <20090311215517.GA32400@srcf.ucam.org>
	 <20090319213539.GA24898@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kXQj2fF0OY1/ptgx3/aG"
Date: Fri, 20 Mar 2009 12:25:50 -0700
Message-Id: <1237577150.8448.8.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kXQj2fF0OY1/ptgx3/aG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 21:35 +0000, Matthew Garrett wrote:
> [ACPI] Populate DIDL before registering ACPI video device on Intel
>=20
> Intel graphics hardware that implements the ACPI IGD OpRegion spec=20
> requires that the list of display devices be populated before any ACPI=20
> video methods are called. Detect when this is the case and defer=20
> registration until the opregion code calls it. Fixes crashes on HP=20
> laptops as seen in kernel bugzilla #11259.
>    =20
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

As far as DRM changes,

Acked-by: Eric Anholt <eric@anholt.net>

(I'm assuming this'll go through the ACPI tree)


> ---
>=20
> This version fixes an attempted re-registration of the video device on=20
> resume.
>=20
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index bb5ed05..64e987c 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -37,6 +37,8 @@
>  #include <linux/thermal.h>
>  #include <linux/video_output.h>
>  #include <linux/sort.h>
> +#include <linux/pci.h>
> +#include <linux/pci_ids.h>
>  #include <asm/uaccess.h>
> =20
>  #include <acpi/acpi_bus.h>
> @@ -2124,7 +2126,27 @@ static int acpi_video_bus_remove(struct acpi_devic=
e *device, int type)
>  	return 0;
>  }
> =20
> -static int __init acpi_video_init(void)
> +static int __init intel_opregion_present(void)
> +{
> +#if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
> +	struct pci_dev *dev =3D NULL;
> +	u32 address;
> +
> +	for_each_pci_dev(dev) {
> +		if ((dev->class >> 8) !=3D PCI_CLASS_DISPLAY_VGA)
> +			continue;
> +		if (dev->vendor !=3D PCI_VENDOR_ID_INTEL)
> +			continue;
> +		pci_read_config_dword(dev, 0xfc, &address);
> +		if (!address)
> +			continue;
> +		return 1;
> +	}
> +#endif
> +	return 0;
> +}
> +
> +int acpi_video_register(void)
>  {
>  	int result =3D 0;
> =20
> @@ -2141,6 +2163,22 @@ static int __init acpi_video_init(void)
> =20
>  	return 0;
>  }
> +EXPORT_SYMBOL(acpi_video_register);
> +
> +/*
> + * This is kind of nasty. Hardware using Intel chipsets may require
> + * the video opregion code to be run first in order to initialise
> + * state before any ACPI video calls are made. To handle this we defer
> + * registration of the video class until the opregion code has run.
> + */
> +
> +static int __init acpi_video_init(void)
> +{
> +	if (intel_opregion_present())
> +		return 0;
> +
> +	return acpi_video_register();
> +}
> =20
>  static void __exit acpi_video_exit(void)
>  {
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_=
dma.c
> index 6dab63b..5881b6a 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1144,8 +1144,6 @@ int i915_driver_load(struct drm_device *dev, unsign=
ed long flags)
>  	if (!IS_I945G(dev) && !IS_I945GM(dev))
>  		pci_enable_msi(dev->pdev);
> =20
> -	intel_opregion_init(dev);
> -
>  	spin_lock_init(&dev_priv->user_irq_lock);
>  	dev_priv->user_irq_refcount =3D 0;
> =20
> @@ -1164,6 +1162,9 @@ int i915_driver_load(struct drm_device *dev, unsign=
ed long flags)
>  		}
>  	}
> =20
> +	/* Must be done after probing outputs */
> +	intel_opregion_init(dev, 0);
> +
>  	return 0;
> =20
>  out_iomapfree:
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_=
drv.c
> index b293ef0..209592f 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -99,7 +99,7 @@ static int i915_resume(struct drm_device *dev)
> =20
>  	i915_restore_state(dev);
> =20
> -	intel_opregion_init(dev);
> +	intel_opregion_init(dev, 1);
> =20
>  	/* KMS EnterVT equivalent */
>  	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_=
drv.h
> index 17fa408..aee6f9e 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -654,7 +654,7 @@ extern int i915_restore_state(struct drm_device *dev)=
;
> =20
>  #ifdef CONFIG_ACPI
>  /* i915_opregion.c */
> -extern int intel_opregion_init(struct drm_device *dev);
> +extern int intel_opregion_init(struct drm_device *dev, int resume);
>  extern void intel_opregion_free(struct drm_device *dev);
>  extern void opregion_asle_intr(struct drm_device *dev);
>  extern void opregion_enable_asle(struct drm_device *dev);
> diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/=
i915_opregion.c
> index ff01283..6942772 100644
> --- a/drivers/gpu/drm/i915/i915_opregion.c
> +++ b/drivers/gpu/drm/i915/i915_opregion.c
> @@ -26,6 +26,7 @@
>   */
> =20
>  #include <linux/acpi.h>
> +#include <acpi/video.h>
> =20
>  #include "drmP.h"
>  #include "i915_drm.h"
> @@ -136,6 +137,12 @@ struct opregion_asle {
> =20
>  #define ASLE_CBLV_VALID         (1<<31)
> =20
> +#define ACPI_OTHER_OUTPUT (0<<8)
> +#define ACPI_VGA_OUTPUT (1<<8)
> +#define ACPI_TV_OUTPUT (2<<8)
> +#define ACPI_DIGITAL_OUTPUT (3<<8)
> +#define ACPI_LVDS_OUTPUT (4<<8)
> +
>  static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  {
>  	struct drm_i915_private *dev_priv =3D dev->dev_private;
> @@ -282,7 +289,58 @@ static struct notifier_block intel_opregion_notifier=
 =3D {
>  	.notifier_call =3D intel_opregion_video_event,
>  };
> =20
> -int intel_opregion_init(struct drm_device *dev)
> +/*
> + * Initialise the DIDL field in opregion. This passes a list of devices =
to
> + * the firmware. Values are defined by section B.4.2 of the ACPI specifi=
cation
> + * (version 3)
> + */
> +
> +static void intel_didl_outputs(struct drm_device *dev)
> +{
> +	struct drm_i915_private *dev_priv =3D dev->dev_private;
> +	struct intel_opregion *opregion =3D &dev_priv->opregion;
> +	struct drm_connector *connector;
> +	int i =3D 0;
> +
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) =
{
> +		int output_type =3D ACPI_OTHER_OUTPUT;
> +		if (i >=3D 8) {
> +			dev_printk (KERN_ERR, &dev->pdev->dev,
> +				    "More than 8 outputs detected\n");
> +			return;
> +		}
> +		switch (connector->connector_type) {
> +		case DRM_MODE_CONNECTOR_VGA:
> +		case DRM_MODE_CONNECTOR_DVIA:
> +			output_type =3D ACPI_VGA_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_Composite:
> +		case DRM_MODE_CONNECTOR_SVIDEO:
> +		case DRM_MODE_CONNECTOR_Component:
> +		case DRM_MODE_CONNECTOR_9PinDIN:
> +			output_type =3D ACPI_TV_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_DVII:
> +		case DRM_MODE_CONNECTOR_DVID:
> +		case DRM_MODE_CONNECTOR_DisplayPort:
> +		case DRM_MODE_CONNECTOR_HDMIA:
> +		case DRM_MODE_CONNECTOR_HDMIB:
> +			output_type =3D ACPI_DIGITAL_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_LVDS:
> +			output_type =3D ACPI_LVDS_OUTPUT;
> +			break;
> +		}
> +		opregion->acpi->didl[i] |=3D (1<<31) | output_type | i;
> +		i++;
> +	}
> +
> +	/* If fewer than 8 outputs, the list must be null terminated */
> +	if (i < 8)
> +		opregion->acpi->didl[i] =3D 0;
> +}
> +
> +int intel_opregion_init(struct drm_device *dev, int resume)
>  {
>  	struct drm_i915_private *dev_priv =3D dev->dev_private;
>  	struct intel_opregion *opregion =3D &dev_priv->opregion;
> @@ -312,6 +370,11 @@ int intel_opregion_init(struct drm_device *dev)
>  	if (mboxes & MBOX_ACPI) {
>  		DRM_DEBUG("Public ACPI methods supported\n");
>  		opregion->acpi =3D base + OPREGION_ACPI_OFFSET;
> +		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> +			intel_didl_outputs(dev);
> +			if (!resume)
> +				acpi_video_register();
> +		}
>  	} else {
>  		DRM_DEBUG("Public ACPI methods not supported\n");
>  		err =3D -ENOTSUPP;
> diff --git a/include/acpi/video.h b/include/acpi/video.h
> new file mode 100644
> index 0000000..f0275bb
> --- /dev/null
> +++ b/include/acpi/video.h
> @@ -0,0 +1,11 @@
> +#ifndef __ACPI_VIDEO_H
> +#define __ACPI_VIDEO_H
> +
> +#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> +extern int acpi_video_register(void);
> +#else
> +static inline int acpi_video_register(void) { return 0; }
> +#endif
> +
> +#endif
> +
>=20
--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-kXQj2fF0OY1/ptgx3/aG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAknD7b4ACgkQHUdvYGzw6veavQCfRAnLu+xJsiGhdjKk5Ooa6sSF
4nsAlREsh9LLxORhMIW/MELCBShUuHg=
=wiIx
-----END PGP SIGNATURE-----

--=-kXQj2fF0OY1/ptgx3/aG--

