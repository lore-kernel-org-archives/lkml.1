Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYDRDJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYDRDJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYDRDIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:08:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYDRDIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:08:50 -0400
Date: Thu, 17 Apr 2008 20:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle
 CONFIG_USB_DEVICE_CLASS=y
Message-Id: <20080417200844.d0cf612d.akpm@linux-foundation.org>
In-Reply-To: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 19:11:03 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
> with duplicate major:minor numbers to be registered.  In effect they
> represent a usb specific address space for major:minor numbers so add 'usb'
> as a directory along side 'block' and 'char'.
> 

hm.  That's a somewhat nasty patch you have there.

> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index ba21118..bce5e4b 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -30,6 +30,10 @@ int (*platform_notify_remove)(struct device *dev) = NULL;
>  static struct kobject *dev_kobj;
>  static struct kobject *char_kobj;
>  static struct kobject *block_kobj;
> +#ifdef CONFIG_USB_DEVICE_CLASS
> +extern struct class *usb_classdev_class;

This should be in a header file, but where?

> +static struct kobject *usb_kobj;
> +#endif
>  
>  #ifdef CONFIG_BLOCK
>  static inline int device_is_not_partition(struct device *dev)
> @@ -764,7 +768,13 @@ static void device_remove_class_symlinks(struct device *dev)
>  
>  static struct kobject *device_to_dev_kobj(struct device *dev)
>  {
> -	return dev->class == &block_class ? block_kobj : char_kobj;
> +	if (dev->class == &block_class)
> +		return block_kobj;

Does the existing code compile-n-work with CONFIG_BLOCK=n?

> +#ifdef CONFIG_USB_DEVICE_CLASS	
> +	if (usb_classdev_class && dev->class == usb_classdev_class)
> +		return usb_kobj;
> +#endif 
> +#ifdef CONFIG_USB_DEVICE_CLASS
> +	usb_kobj = kobject_create_and_add("usb", dev_kobj);
> +	if (!usb_kobj)
> +		goto usb_kobj_err;
> +#endif
> +#ifdef CONFIG_USB_DEVICE_CLASS
> + usb_kobj_err:
> +	kobject_put(char_kobj);
> +#endif
> +#ifdef CONFIG_USB_DEVICE_CLASS
> +	kobject_put(usb_kobj);
> +#endif

mutter.  I'd have thought that with suitable fiddling most of this code
could be moved into the USB core and some of it (the
kobject_create_and_add()) can be done via USB's initcalls.

this:

--- a/drivers/base/core.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y-fix
+++ a/drivers/base/core.c
@@ -31,7 +31,6 @@ static struct kobject *dev_kobj;
 static struct kobject *char_kobj;
 static struct kobject *block_kobj;
 #ifdef CONFIG_USB_DEVICE_CLASS
-extern struct class *usb_classdev_class;
 static struct kobject *usb_kobj;
 #endif
 
diff -puN drivers/usb/core/devio.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y-fix drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y-fix
+++ a/drivers/usb/core/devio.c
@@ -43,6 +43,7 @@
 #include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/module.h>
+#include <linux/device.h>
 #include <linux/usb.h>
 #include <linux/usbdevice_fs.h>
 #include <linux/cdev.h>
diff -puN include/linux/device.h~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y-fix include/linux/device.h
--- a/include/linux/device.h~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y-fix
+++ a/include/linux/device.h
@@ -623,4 +623,6 @@ extern const char *dev_driver_string(str
 #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-*")
 
+extern struct class *usb_classdev_class;
+
 #endif /* _DEVICE_H_ */
_

deworsens things slightly.

