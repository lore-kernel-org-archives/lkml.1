Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZAaPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZAaPwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZAaPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:52:17 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59530 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752384AbZAaPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:52:17 -0500
Date: Sat, 31 Jan 2009 15:51:48 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2 RESEND] platform: introduce module id table for
	platform devices
Message-ID: <20090131155147.GU12431@fluff.org.uk>
References: <498464ED.3010607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498464ED.3010607@gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 10:49:17PM +0800, Eric Miao wrote:

> >From 334741bf2768a98e7babde6c2795151bfa0d57f6 Mon Sep 17 00:00:00 2001
> From: Eric Miao <eric.miao@marvell.com>
> Date: Tue, 30 Dec 2008 14:20:59 +0800
> Subject: platform: introduce module id table for platform devices
> 
> Now platform_device is being widely used on SoC processors where the
> peripherals are attached to the system bus, which is simple enough.
> 
> However, silicon IPs for these SoCs are usually shared heavily across
> a family of processors, even products from different companies.  This
> makes the original simple driver name based matching insufficient, or
> simply not straight-forward.
> 
> Introduce a module id table for platform devices, and makes it clear
> that a platform driver is able to support some shared IP and handle
> slight differences across different platforms (by 'driver_data').
> Module alias is handled automatically when a MODULE_DEVICE_TABLE()
> is defined.
> 
> To not disturb the current platform drivers too much, the matched id
> entry is recorded and can be retrieved by platform_get_device_id().
> 
> Signed-off-by: Eric Miao <eric.miao@marvell.com>
> ---
>  drivers/base/platform.c         |   21 ++++++++++++++++++++-
>  include/linux/mod_devicetable.h |    9 +++++++++
>  include/linux/platform_device.h |    6 ++++++
>  scripts/mod/file2alias.c        |   12 ++++++++++++
>  4 files changed, 47 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index d0591f0..45bdc37 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -587,7 +587,8 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct platform_device	*pdev = to_platform_device(dev);
>  
> -	add_uevent_var(env, "MODALIAS=platform:%s", pdev->name);
> +	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> +		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
>  	return 0;
>  }
>  
> @@ -604,10 +605,28 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>   * and compare it against the name of the driver. Return whether they match
>   * or not.
>   */
> +static const struct platform_device_id *platform_match_id(
> +			const struct platform_device_id *id,
> +			struct platform_device *pdev)
> +{
> +	while (id->name[0]) {
> +		if (strcmp(pdev->name, id->name) == 0)
> +			return (pdev->id_entry = id);
> +		id++;
> +	}
> +	return NULL;
> +}
> +
>  static int platform_match(struct device *dev, struct device_driver *drv)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> +	struct platform_driver *pdrv = to_platform_driver(drv);
> +
> +	/* match against the id table first */
> +	if (pdrv->id_table)
> +		return platform_match_id(pdrv->id_table, pdev) != NULL;
>  
> +	/* fall-back to driver name match */
>  	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
>  }
>  
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 97b91d1..5201491 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -447,4 +447,13 @@ struct dmi_system_id {
>  
>  #define DMI_MATCH(a, b)	{ a, b }
>  
> +#define PLATFORM_NAME_SIZE	20
> +#define PLATFORM_MODULE_PREFIX	"platform:"
> +
> +struct platform_device_id {
> +	char name[I2C_NAME_SIZE];
> +	kernel_ulong_t driver_data
> +			__attribute__((aligned(sizeof(kernel_ulong_t))));
> +};
> +

surely you mean PLATFORM_NAME_SIZE in this struct?

>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 4b8cc6a..7edc570 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -12,6 +12,7 @@
>  #define _PLATFORM_DEVICE_H_
>  
>  #include <linux/device.h>
> +#include <linux/mod_devicetable.h>
>  
>  struct platform_device {
>  	const char	* name;
> @@ -19,8 +20,12 @@ struct platform_device {
>  	struct device	dev;
>  	u32		num_resources;
>  	struct resource	* resource;
> +
> +	struct platform_device_id	*id_entry;
>  };
>  
> +#define platform_get_device_id(pdev)	((pdev)->id_entry)
> +
>  #define to_platform_device(x) container_of((x), struct platform_device, dev)
>  
>  extern int platform_device_register(struct platform_device *);
> @@ -57,6 +62,7 @@ struct platform_driver {
>  	int (*resume)(struct platform_device *);
>  	struct pm_ext_ops *pm;
>  	struct device_driver driver;
> +	struct platform_device_id *id_table;
>  };

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
