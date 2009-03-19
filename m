Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZCSBnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZCSBnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZCSBnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:43:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:39528 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZCSBnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,386,1233561600"; 
   d="scan'208";a="121793374"
Subject: Re: [PATCH] acpi: Populate DIDL before registering ACPI video
	device on Intel
From: yakui_zhao <yakui.zhao@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       intel-gfx@lists.freedesktop.org
In-Reply-To: <20090311215517.GA32400@srcf.ucam.org>
References: <20090311215517.GA32400@srcf.ucam.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Thu, 19 Mar 2009 09:44:09 +0800
Message-Id: <1237427049.3640.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 05:55 +0800, Matthew Garrett wrote:


     On some HP boxes the acpi video driver depends on the ACPI IGD
Opregion. If the ACPI IGD opregion is not initialized, the _DOD object
will return the incorrect supported devices. In such case when LID is
closed, the SMI will be called and crash will happen. The DIDL field of
ACPI IGD opregion is filled with the supported devices, which is
enumerated by graphics driver(Of course this also depends on the KMS).
If the ACPI IGD opregion is initialized correctly, the ACPI video driver
can be loaded correctly and there is no crash.

IMO the idea in this patch is very reasonable. 

The ACPI video driver will be deferred if the ACPI IGD opregion is
detected. Only when ACPI IGD opregion is initialized, the acpi video
driver will be bound with the ACPI video device. 
    The supported device list is enumerated by graphics driver, which
depends on the KMS.

Hi, Len/Jesse
    Any comments about this patch?
    Can the idea in this patch be accepted? 

Thanks.
   
     
> Intel graphics hardware that implements the ACPI IGD OpRegion spec 
> requires that the list of display devices be populated before any ACPI 
> video methods are called. Detect when this is the case and defer 
> registration until the opregion code calls it. Fixes crashes on HP 
> laptops as seen in kernel bugzilla #11259.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
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
>  
>  #include <acpi/acpi_bus.h>
> @@ -2124,7 +2126,27 @@ static int acpi_video_bus_remove(struct acpi_device *device, int type)
>  	return 0;
>  }
>  
> -static int __init acpi_video_init(void)
> +static int __init intel_opregion_present(void)
> +{
> +#if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
> +	struct pci_dev *dev = NULL;
> +	u32 address;
> +
> +	for_each_pci_dev(dev) {
> +		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
> +			continue;
> +		if (dev->vendor != PCI_VENDOR_ID_INTEL)
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
>  	int result = 0;
>  
> @@ -2141,6 +2163,22 @@ static int __init acpi_video_init(void)
>  
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
>  
>  static void __exit acpi_video_exit(void)
>  {
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 6dab63b..70a9904 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1144,8 +1144,6 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>  	if (!IS_I945G(dev) && !IS_I945GM(dev))
>  		pci_enable_msi(dev->pdev);
>  
> -	intel_opregion_init(dev);
> -
>  	spin_lock_init(&dev_priv->user_irq_lock);
>  	dev_priv->user_irq_refcount = 0;
>  
> @@ -1164,6 +1162,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>  		}
>  	}
>  
> +	/* Must be done after probing outputs */
> +	intel_opregion_init(dev);
> +
>  	return 0;
>  
>  out_iomapfree:
> diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
> index ff01283..60b746f 100644
> --- a/drivers/gpu/drm/i915/i915_opregion.c
> +++ b/drivers/gpu/drm/i915/i915_opregion.c
> @@ -26,6 +26,7 @@
>   */
>  
>  #include <linux/acpi.h>
> +#include <acpi/video.h>
>  
>  #include "drmP.h"
>  #include "i915_drm.h"
> @@ -136,6 +137,12 @@ struct opregion_asle {
>  
>  #define ASLE_CBLV_VALID         (1<<31)
>  
> +#define ACPI_OTHER_OUTPUT (0<<8)
> +#define ACPI_VGA_OUTPUT (1<<8)
> +#define ACPI_TV_OUTPUT (2<<8)
> +#define ACPI_DIGITAL_OUTPUT (3<<8)
> +#define ACPI_LVDS_OUTPUT (4<<8)
> +
>  static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> @@ -282,6 +289,57 @@ static struct notifier_block intel_opregion_notifier = {
>  	.notifier_call = intel_opregion_video_event,
>  };
>  
> +/*
> + * Initialise the DIDL field in opregion. This passes a list of devices to
> + * the firmware. Values are defined by section B.4.2 of the ACPI specification
> + * (version 3)
> + */
> +
> +static void intel_didl_outputs(struct drm_device *dev)
> +{
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +	struct intel_opregion *opregion = &dev_priv->opregion;
> +	struct drm_connector *connector;
> +	int i = 0;
> +
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		int output_type = ACPI_OTHER_OUTPUT;
> +		if (i >= 8) {
> +			dev_printk (KERN_ERR, &dev->pdev->dev,
> +				    "More than 8 outputs detected\n");
> +			return;
> +		}
> +		switch (connector->connector_type) {
> +		case DRM_MODE_CONNECTOR_VGA:
> +		case DRM_MODE_CONNECTOR_DVIA:
> +			output_type = ACPI_VGA_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_Composite:
> +		case DRM_MODE_CONNECTOR_SVIDEO:
> +		case DRM_MODE_CONNECTOR_Component:
> +		case DRM_MODE_CONNECTOR_9PinDIN:
> +			output_type = ACPI_TV_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_DVII:
> +		case DRM_MODE_CONNECTOR_DVID:
> +		case DRM_MODE_CONNECTOR_DisplayPort:
> +		case DRM_MODE_CONNECTOR_HDMIA:
> +		case DRM_MODE_CONNECTOR_HDMIB:
> +			output_type = ACPI_DIGITAL_OUTPUT;
> +			break;
> +		case DRM_MODE_CONNECTOR_LVDS:
> +			output_type = ACPI_LVDS_OUTPUT;
> +			break;
> +		}
> +		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
> +		i++;
> +	}
> +
> +	/* If fewer than 8 outputs, the list must be null terminated */
> +	if (i < 8)
> +		opregion->acpi->didl[i] = 0;
> +}
> +
>  int intel_opregion_init(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> @@ -312,6 +370,10 @@ int intel_opregion_init(struct drm_device *dev)
>  	if (mboxes & MBOX_ACPI) {
>  		DRM_DEBUG("Public ACPI methods supported\n");
>  		opregion->acpi = base + OPREGION_ACPI_OFFSET;
> +		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> +			intel_didl_outputs(dev);
> +			acpi_video_register();
> +		}
>  	} else {
>  		DRM_DEBUG("Public ACPI methods not supported\n");
>  		err = -ENOTSUPP;
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
> 
> 

