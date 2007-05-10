Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXEJHpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXEJHpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXEJHpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:45:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbXEJHp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:45:29 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] ACPI: dock: use dynamically allocated platform device
Date: Thu, 10 May 2007 03:44:12 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070509150704.64e454ab.kristen.c.accardi@intel.com>
In-Reply-To: <20070509150704.64e454ab.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100344.12706.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This batch of 7 patches is applied to acpi-test.

thanks,
-Len

On Wednesday 09 May 2007 18:07, Kristen Carlson Accardi wrote:
> ACPI: dock: use dynamically allocated platform device
> 
> Get rid of no release function warnings by switching to dynamically
> allocating the platform_device and using the platform device release
> routine in the base driver.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Index: 2.6-git/drivers/acpi/dock.c
> ===================================================================
> --- 2.6-git.orig/drivers/acpi/dock.c
> +++ 2.6-git/drivers/acpi/dock.c
> @@ -41,7 +41,7 @@ MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESC
>  MODULE_LICENSE("GPL");
>  
>  static struct atomic_notifier_head dock_notifier_list;
> -static struct platform_device dock_device;
> +static struct platform_device *dock_device;
>  static char dock_device_name[] = "dock";
>  
>  struct dock_station {
> @@ -327,7 +327,7 @@ static void hotplug_dock_devices(struct 
>  
>  static void dock_event(struct dock_station *ds, u32 event, int num)
>  {
> -	struct device *dev = &dock_device.dev;
> +	struct device *dev = &dock_device->dev;
>  	/*
>  	 * Indicate that the status of the dock station has
>  	 * changed.
> @@ -710,37 +710,36 @@ static int dock_add(acpi_handle handle)
>  	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  
>  	/* initialize platform device stuff */
> -	dock_device.name = dock_device_name;
> -	ret = platform_device_register(&dock_device);
> -	if (ret) {
> -		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
> +	dock_device =
> +		platform_device_register_simple(dock_device_name, 0, NULL, 0);
> +	if (IS_ERR(dock_device)) {
>  		kfree(dock_station);
>  		dock_station = NULL;
> -		return ret;
> +		return PTR_ERR(dock_device);
>  	}
> -	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
> +	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
>  	if (ret) {
>  		printk("Error %d adding sysfs file\n", ret);
> -		platform_device_unregister(&dock_device);
> +		platform_device_unregister(dock_device);
>  		kfree(dock_station);
>  		dock_station = NULL;
>  		return ret;
>  	}
> -	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
> +	ret = device_create_file(&dock_device->dev, &dev_attr_undock);
>  	if (ret) {
>  		printk("Error %d adding sysfs file\n", ret);
> -		device_remove_file(&dock_device.dev, &dev_attr_docked);
> -		platform_device_unregister(&dock_device);
> +		device_remove_file(&dock_device->dev, &dev_attr_docked);
> +		platform_device_unregister(dock_device);
>  		kfree(dock_station);
>  		dock_station = NULL;
>  		return ret;
>  	}
> -	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
> +	ret = device_create_file(&dock_device->dev, &dev_attr_uid);
>  	if (ret) {
>  		printk("Error %d adding sysfs file\n", ret);
> -		device_remove_file(&dock_device.dev, &dev_attr_docked);
> -		device_remove_file(&dock_device.dev, &dev_attr_undock);
> -		platform_device_unregister(&dock_device);
> +		device_remove_file(&dock_device->dev, &dev_attr_docked);
> +		device_remove_file(&dock_device->dev, &dev_attr_undock);
> +		platform_device_unregister(dock_device);
>  		kfree(dock_station);
>  		dock_station = NULL;
>  		return ret;
> @@ -779,10 +778,10 @@ static int dock_add(acpi_handle handle)
>  dock_add_err:
>  	kfree(dd);
>  dock_add_err_unregister:
> -	device_remove_file(&dock_device.dev, &dev_attr_docked);
> -	device_remove_file(&dock_device.dev, &dev_attr_undock);
> -	device_remove_file(&dock_device.dev, &dev_attr_uid);
> -	platform_device_unregister(&dock_device);
> +	device_remove_file(&dock_device->dev, &dev_attr_docked);
> +	device_remove_file(&dock_device->dev, &dev_attr_undock);
> +	device_remove_file(&dock_device->dev, &dev_attr_uid);
> +	platform_device_unregister(dock_device);
>  	kfree(dock_station);
>  	dock_station = NULL;
>  	return ret;
> @@ -812,10 +811,10 @@ static int dock_remove(void)
>  		printk(KERN_ERR "Error removing notify handler\n");
>  
>  	/* cleanup sysfs */
> -	device_remove_file(&dock_device.dev, &dev_attr_docked);
> -	device_remove_file(&dock_device.dev, &dev_attr_undock);
> -	device_remove_file(&dock_device.dev, &dev_attr_uid);
> -	platform_device_unregister(&dock_device);
> +	device_remove_file(&dock_device->dev, &dev_attr_docked);
> +	device_remove_file(&dock_device->dev, &dev_attr_undock);
> +	device_remove_file(&dock_device->dev, &dev_attr_uid);
> +	platform_device_unregister(dock_device);
>  
>  	/* free dock station memory */
>  	kfree(dock_station);
> 
> 
