Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZAEBxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZAEBxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZAEBxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:53:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:63815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZAEBxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:53:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,330,1228118400"; 
   d="scan'208";a="654516412"
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
From: Zhao Yakui <yakui.zhao@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20090104093103.46167d23@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104093103.46167d23@infradead.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 10:03:12 +0800
Message-Id: <1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 09:31 -0800, Arjan van de Ven wrote:
> From 20af3efd07b775a27a997e3df1039e20ea18f62b Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make ACPI bus drivers probe asynchronous
> 
> the various ACPI bus drivers have non-overlapping devices and can
> each be run asynchronous. Some of the ACPI drivers (especially the
> battery one, but others as well) can take quite a long time to probe.
It seems that all the ACPI drivers are registered asynchronously after
this change. 
   But there exists some dependency between some ACPI device drivers. It
is not very reasonable that the device driver is loaded asynchronously
if there exists the dependency between some drivers. 

For example: 
   On some boxes the info of battery is related with Embedded
controller. The EC driver should be loaded completely before registering
battery driver.
   On some boxes there exist the devices of ACPI power resource. And the
device power state is transited by controlling power resource. In such
case the power resource device driver should be loaded completely before
transiting the device power state.


Best regards.

> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/acpi/scan.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 39b7233..a9e542d 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -8,6 +8,7 @@
>  #include <linux/acpi.h>
>  #include <linux/signal.h>
>  #include <linux/kthread.h>
> +#include <linux/async.h>
>  
>  #include <acpi/acpi_drivers.h>
>  #include <acpi/acinterp.h>	/* for acpi_ex_eisa_id_to_string() */
> @@ -578,6 +579,19 @@ static int acpi_start_single_object(struct acpi_device *device)
>  	return result;
>  }
>  
> +static void acpi_bus_register_async(void *data, async_cookie_t cookie)
> +{
> +	int ret;
> +	struct acpi_driver *driver = data;
> +	driver->drv.name = driver->name;
> +	driver->drv.bus = &acpi_bus_type;
> +	driver->drv.owner = driver->owner;
> +
> +	async_synchronize_cookie(cookie);
> +
> +	ret = driver_register(&driver->drv);
> +	WARN_ON(ret != 0);
> +}
>  /**
>   * acpi_bus_register_driver - register a driver with the ACPI bus
>   * @driver: driver being registered
> @@ -588,16 +602,11 @@ static int acpi_start_single_object(struct acpi_device *device)
>   */
>  int acpi_bus_register_driver(struct acpi_driver *driver)
>  {
> -	int ret;
>  
>  	if (acpi_disabled)
>  		return -ENODEV;
> -	driver->drv.name = driver->name;
> -	driver->drv.bus = &acpi_bus_type;
> -	driver->drv.owner = driver->owner;
> -
> -	ret = driver_register(&driver->drv);
> -	return ret;
> +	async_schedule(acpi_bus_register_async, driver);
> +	return 0;
>  }
>  
>  EXPORT_SYMBOL(acpi_bus_register_driver);
> -- 
> 1.6.0.6
> 
> 

