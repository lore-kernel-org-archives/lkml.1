Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbZKZPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbZKZPHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZKZPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:07:11 -0500
Received: from poutre.nerim.net ([62.4.16.124]:59251 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZKZPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:07:10 -0500
Date: Thu, 26 Nov 2009 16:07:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
       jic23@cam.ac.uk, alan@linux.intel.com, linux-acpi@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH 2/2] als: add unique device-ids to the als device class
Message-ID: <20091126160713.5e19eb04@hyperion.delvare>
In-Reply-To: <1259237186-5459-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259237081-4403-1-git-send-email-amit.kucheria@verdurent.com>
	<1259237186-5459-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Thu, 26 Nov 2009 14:06:26 +0200, Amit Kucheria wrote:
> Other devices classes such as hwmon and input class handle assignment of
> unique device-ids inside the core functions instead of pushing it out to
> individual drivers. This reduces code duplication and resulting bugs.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> 
> ---
>  drivers/als/als_sys.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/als/als_sys.c b/drivers/als/als_sys.c
> index e1d6395..aa15ad8 100644
> --- a/drivers/als/als_sys.c
> +++ b/drivers/als/als_sys.c
> @@ -26,22 +26,55 @@
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/kdev_t.h>
> +#include <linux/idr.h>
>  
>  MODULE_AUTHOR("Zhang Rui <rui.zhang@intel.com>");
>  MODULE_DESCRIPTION("Ambient Light Sensor sysfs/class support");
>  MODULE_LICENSE("GPL");
>  
> +#define ALS_ID_PREFIX "als"
> +#define ALS_ID_FORMAT ALS_ID_PREFIX "%d"
> +
>  static struct class *als_class;
>  
> +static DEFINE_IDR(als_idr);
> +static DEFINE_SPINLOCK(idr_lock);
> +
>  /**
>   * als_device_register - register a new Ambient Light Sensor class device
>   * @parent:	the device to register.
>   *
>   * Returns the pointer to the new device
>   */
> -struct device *als_device_register(struct device *dev, char *name)
> +struct device *als_device_register(struct device *dev)

This is a public function but you forgot to update
include/linux/als_sys.h accordingly. This will let the build succeed
but crashes will happen at run time. Fix below.

>  {
> -	return device_create(als_class, dev, MKDEV(0, 0), NULL, name);
> +	int id, err;
> +	struct device *alsdev;
> +
> +again:
> +	if (unlikely(idr_pre_get(&als_idr, GFP_KERNEL) == 0))
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock(&idr_lock);
> +	err = idr_get_new(&als_idr, NULL, &id);
> +	spin_unlock(&idr_lock);
> +
> +	if (unlikely(err == -EAGAIN))
> +		goto again;
> +	else if (unlikely(err))
> +		return ERR_PTR(err);
> +
> +	id = id & MAX_ID_MASK;
> +	alsdev = device_create(als_class, dev, MKDEV(0, 0), NULL,
> +			ALS_ID_FORMAT, id);
> +
> +	if (IS_ERR(alsdev)) {
> +		spin_lock(&idr_lock);
> +		idr_remove(&als_idr, id);
> +		spin_unlock(&idr_lock);
> +	}
> +
> +	return alsdev;
>  }
>  EXPORT_SYMBOL(als_device_register);
>  
> @@ -51,7 +84,16 @@ EXPORT_SYMBOL(als_device_register);
>   */
>  void als_device_unregister(struct device *dev)
>  {
> -	device_unregister(dev);
> +	int id;
> +
> +	if (likely(sscanf(dev_name(dev), ALS_ID_FORMAT, &id) == 1)) {
> +		device_unregister(dev);
> +		spin_lock(&idr_lock);
> +		idr_remove(&als_idr, id);
> +		spin_unlock(&idr_lock);
> +	} else
> +		dev_dbg(dev->parent,
> +			"als_device_unregister() failed: bad class ID!\n");
>  }
>  EXPORT_SYMBOL(als_device_unregister);
>  

Other than that I am very happy with this change, which kills 46 lines
of code in the tsl2550 driver (and virtually the same in every other
light sensor driver.) Please merge the following fix:

--- linux-2.6.32-rc8.orig/include/linux/als_sys.h	2009-11-26 15:32:38.000000000 +0100
+++ linux-2.6.32-rc8/include/linux/als_sys.h	2009-11-26 15:44:08.000000000 +0100
@@ -29,7 +29,7 @@
 #define ALS_ILLUMINANCE_MIN 0
 #define ALS_ILLUMINANCE_MAX -1
 
-struct device *als_device_register(struct device *dev, char *name);
+struct device *als_device_register(struct device *dev);
 void als_device_unregister(struct device *dev);
 
 #endif /* __ALS_SYS_H__ */


And then you can add:

Acked-by: Jean Delvare <khali@linux-fr.org>

That being said... If we want user-space to know what device is there,
we may want to still let drivers pass a name string to
als_device_register() and let the ALS core create a "name" sysfs
attribute returning the string in question. This would be much lighter
(for individual drivers) than the previous situation, as the string in
question would be a constant (e.g. "TSL2550".) Opinions?

-- 
Jean Delvare
