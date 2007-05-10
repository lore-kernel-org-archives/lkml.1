Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbXEJAmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbXEJAmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXEJAmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:42:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741AbXEJAmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:42:15 -0400
Date: Wed, 9 May 2007 17:42:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ACPI: fix oops after dock driver fails to initialize
Message-Id: <20070509174203.93b5b02f.akpm@linux-foundation.org>
In-Reply-To: <4640FC3B.3010005@redhat.com>
References: <4640FC3B.3010005@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 18:39:55 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> 

You didn't write much.

Oh, it was an attachment.  thwap.

> ACPI: fix oops after dock driver fails to initialize
> 
> The driver tests the dock_station pointer for nonnull
> to check whether it has initialized properly. But in
> some cases dock_station will be non-null after being
> freed when driver init fails. Fix by zeroing the
> pointer after freeing.
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> 
> ---
>  drivers/acpi/dock.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- 2.6.21-d390.orig/drivers/acpi/dock.c
> +++ 2.6.21-d390/drivers/acpi/dock.c
> @@ -698,6 +698,7 @@ static int dock_add(acpi_handle handle)
>  	if (ret) {
>  		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
>  		kfree(dock_station);
> +		dock_station = NULL;
>  		return ret;
>  	}
>  	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
> @@ -705,6 +706,7 @@ static int dock_add(acpi_handle handle)
>  		printk("Error %d adding sysfs file\n", ret);
>  		platform_device_unregister(&dock_device);
>  		kfree(dock_station);
> +		dock_station = NULL;
>  		return ret;
>  	}
>  	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
> @@ -713,6 +715,7 @@ static int dock_add(acpi_handle handle)
>  		device_remove_file(&dock_device.dev, &dev_attr_docked);
>  		platform_device_unregister(&dock_device);
>  		kfree(dock_station);
> +		dock_station = NULL;
>  		return ret;
>  	}
>  
> @@ -725,6 +728,7 @@ static int dock_add(acpi_handle handle)
>  	dd = alloc_dock_dependent_device(handle);
>  	if (!dd) {
>  		kfree(dock_station);
> +		dock_station = NULL;
>  		ret = -ENOMEM;
>  		goto dock_add_err_unregister;
>  	}
> @@ -752,6 +756,7 @@ dock_add_err_unregister:
>  	device_remove_file(&dock_device.dev, &dev_attr_undock);
>  	platform_device_unregister(&dock_device);
>  	kfree(dock_station);
> +	dock_station = NULL;
>  	return ret;
>  }
>  
> @@ -785,6 +790,7 @@ static int dock_remove(void)
>  
>  	/* free dock station memory */
>  	kfree(dock_station);
> +	dock_station = NULL;
>  	return 0;
>  }
>  

I think you're missing a case, here:

	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
	if (ret) {
		printk("Error %d adding sysfs file\n", ret);
		platform_device_unregister(&dock_device);
		kfree(dock_station);
		return ret;
	}

also, the code duplication in there is unpleasing.  Doesn't this look
better?  


 drivers/acpi/dock.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-fix-oops-after-dock-driver-fails-to-initialize drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-fix-oops-after-dock-driver-fails-to-initialize
+++ a/drivers/acpi/dock.c
@@ -714,31 +714,24 @@ static int dock_add(acpi_handle handle)
 	dock_device.name = dock_device_name;
 	ret = platform_device_register(&dock_device);
 	if (ret) {
-		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
-		kfree(dock_station);
-		return ret;
+		printk(KERN_ERR PREFIX "Error %d registering dock device\n",
+				ret);
+		goto err;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_register;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		device_remove_file(&dock_device.dev, &dev_attr_docked);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_sysfs_1;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_sysfs_2;
 	}
 
 	/* Find dependent devices */
@@ -749,7 +742,6 @@ static int dock_add(acpi_handle handle)
 	/* add the dock station as a device dependent on itself */
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
-		kfree(dock_station);
 		ret = -ENOMEM;
 		goto dock_add_err_unregister;
 	}
@@ -773,10 +765,15 @@ static int dock_add(acpi_handle handle)
 dock_add_err:
 	kfree(dd);
 dock_add_err_unregister:
+err_sysfs_2:
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
+err_sysfs_1:
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+err_register:
 	platform_device_unregister(&dock_device);
+err:
 	kfree(dock_station);
+	dock_station = NULL;
 	return ret;
 }
 
@@ -810,6 +807,7 @@ static int dock_remove(void)
 
 	/* free dock station memory */
 	kfree(dock_station);
+	dock_station = NULL;
 	return 0;
 }
 
_

