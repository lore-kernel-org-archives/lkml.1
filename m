Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbYGRWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbYGRWRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGRWRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56506 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYGRWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:03 -0400
Date: Fri, 18 Jul 2008 15:10:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>, gregkh <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Message-Id: <20080718151037.a54dec8a.randy.dunlap@oracle.com>
In-Reply-To: <200807182201.33913.mb@bu3sch.de>
References: <200807182201.33913.mb@bu3sch.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 22:01:33 +0200 Michael Buesch wrote:

> This driver hooks up the mmc_spi and spi_gpio modules so that
> MMC/SD cards can be used on a GPIO based bus by bitbanging
> the SPI protocol in software.
> 
> This driver provides a sysfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces. It also provides
> a platform device interface API.
> See Documentation/gpiommc.txt for details.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This driver is used in OpenWrt since quite some time, so please
> consider for inclusion in mainline.

Full diffstat here would be Good.

> Index: linux-next/drivers/mmc/host/gpiommc.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/drivers/mmc/host/gpiommc.c	2008-07-18 21:54:05.000000000 +0200
> @@ -0,0 +1,328 @@
> +/*
> + * Driver an MMC/SD card on a bitbanging GPIO SPI bus.
> + * This module hooks up the mmc_spi and spi_gpio modules and also
> + * provides a sysfs interface.
> + *
> + * Copyright 2008 Michael Buesch <mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/mmc/gpiommc.h>
> +#include <linux/platform_device.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spi/spi_gpio.h>
> +
> +
> +#define PFX				"gpio-mmc: "
> +#define GPIOMMC_MAX_NAMELEN_STR		__stringify(GPIOMMC_MAX_NAMELEN)
> +
> +struct gpiommc_device {
> +	struct platform_device *pdev;
> +	struct platform_device *spi_pdev;
> +	struct spi_board_info boardinfo;
> +};
> +
> +
> +MODULE_DESCRIPTION("GPIO based MMC driver");
> +MODULE_AUTHOR("Michael Buesch");
> +MODULE_LICENSE("GPL");
> +
> +
> +static int gpiommc_boardinfo_setup(struct spi_board_info *bi,
> +				   struct spi_master *master,
> +				   void *data)
> +{
> +	struct gpiommc_device *d = data;
> +	struct gpiommc_platform_data *pdata = d->pdev->dev.platform_data;
> +
> +	/* Bind the SPI master to the MMC-SPI host driver. */
> +	strlcpy(bi->modalias, "mmc_spi", sizeof(bi->modalias));
> +
> +	bi->max_speed_hz = pdata->max_bus_speed;
> +	bi->bus_num = master->bus_num;
> +	bi->mode = pdata->mode;
> +
> +	return 0;
> +}
> +
> +static int gpiommc_probe(struct platform_device *pdev)
> +{
> +	struct gpiommc_platform_data *mmc_pdata = pdev->dev.platform_data;
> +	struct spi_gpio_platform_data spi_pdata;
> +	struct gpiommc_device *d;
> +	int err;
> +
> +	err = -ENXIO;
> +	if (!mmc_pdata)
> +		goto error;
> +
> +	/* Allocate the GPIO-MMC device */
> +	err = -ENOMEM;
> +	d = kzalloc(sizeof(*d), GFP_KERNEL);
> +	if (!d)
> +		goto error;
> +	d->pdev = pdev;
> +
> +	/* Create the SPI-GPIO device */
> +	d->spi_pdev = platform_device_alloc(SPI_GPIO_PLATDEV_NAME,
> +					    spi_gpio_next_id());
> +	if (!d->spi_pdev)
> +		goto err_free_d;
> +
> +	memset(&spi_pdata, 0, sizeof(spi_pdata));
> +	spi_pdata.pin_clk = mmc_pdata->pins.gpio_clk;
> +	spi_pdata.pin_miso = mmc_pdata->pins.gpio_do;
> +	spi_pdata.pin_mosi = mmc_pdata->pins.gpio_di;
> +	spi_pdata.pin_cs = mmc_pdata->pins.gpio_cs;
> +	spi_pdata.cs_activelow = mmc_pdata->pins.cs_activelow;
> +	spi_pdata.no_spi_delay = mmc_pdata->no_spi_delay;
> +	spi_pdata.boardinfo_setup = gpiommc_boardinfo_setup;
> +	spi_pdata.boardinfo_setup_data = d;
> +
> +	err = platform_device_add_data(d->spi_pdev, &spi_pdata,
> +				       sizeof(spi_pdata));
> +	if (err)
> +		goto err_free_pdev;
> +	err = platform_device_add(d->spi_pdev);
> +	if (err)
> +		goto err_free_pdata;
> +	platform_set_drvdata(pdev, d);
> +
> +	printk(KERN_INFO PFX "MMC-Card \"%s\" "
> +	       "attached to GPIO pins di=%u, do=%u, clk=%u, cs=%u\n",
> +	       mmc_pdata->name, mmc_pdata->pins.gpio_di,
> +	       mmc_pdata->pins.gpio_do,
> +	       mmc_pdata->pins.gpio_clk,
> +	       mmc_pdata->pins.gpio_cs);
> +
> +	return 0;
> +
> +err_free_pdata:
> +	kfree(d->spi_pdev->dev.platform_data);
> +	d->spi_pdev->dev.platform_data = NULL;
> +err_free_pdev:
> +	platform_device_put(d->spi_pdev);
> +err_free_d:
> +	kfree(d);
> +error:
> +	return err;
> +}
> +
> +static int gpiommc_remove(struct platform_device *pdev)
> +{
> +	struct gpiommc_device *d = platform_get_drvdata(pdev);
> +	struct gpiommc_platform_data *pdata = d->pdev->dev.platform_data;
> +
> +	platform_device_unregister(d->spi_pdev);
> +	printk(KERN_INFO PFX "GPIO based MMC-Card \"%s\" removed\n", pdata->name);
> +	platform_device_put(d->spi_pdev);
> +
> +	return 0;
> +}
> +
> +/* Wrapper for the platform data with context data for the sysfs interface. */
> +struct gpiommc_sysfs_platform_data {
> +	struct gpiommc_platform_data p; /* Keep as first element */
> +
> +	/* The platform device that we allocated. */
> +	struct platform_device *pdev;
> +	/* gpiommc_sysfs_list */
> +	struct list_head list;
> +};
> +
> +static LIST_HEAD(gpiommc_sysfs_list);
> +static DEFINE_MUTEX(gpiommc_sysfs_mutex);
> +
> +static struct gpiommc_sysfs_platform_data *gpiommc_sysfs_find_dev(const char *name)
> +{
> +	struct gpiommc_sysfs_platform_data *pdata;
> +
> +	list_for_each_entry(pdata, &gpiommc_sysfs_list, list) {
> +		if (strcmp(pdata->p.name, name) == 0)
> +			return pdata;
> +	}
> +
> +	return NULL;
> +}
> +
> +static ssize_t gpiommc_add_store(struct device_driver *drv,
> +				 const char *buf, size_t count)
> +{
> +	int res, err;
> +	struct gpiommc_sysfs_platform_data pdata_local, *pdata;
> +	struct platform_device *pdev;
> +	unsigned int no_spi_delay = 0, mode = 0, csactivelow = 0;
> +
> +	mutex_lock(&gpiommc_sysfs_mutex);
> +
> +	pdata = &pdata_local;
> +	memset(pdata, 0, sizeof(*pdata));
> +
> +	err = -EINVAL;
> +	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u %u %u %u %u %u %u %u",
> +		     pdata->p.name,
> +		     &pdata->p.pins.gpio_di,
> +		     &pdata->p.pins.gpio_do,
> +		     &pdata->p.pins.gpio_clk,
> +		     &pdata->p.pins.gpio_cs,
> +		     &mode,
> +		     &pdata->p.max_bus_speed,
> +		     &no_spi_delay,
> +		     &csactivelow);
> +	pdata->p.mode = mode;
> +	pdata->p.no_spi_delay = !!no_spi_delay;
> +	pdata->p.pins.cs_activelow = !!csactivelow;
> +	if (res < 9)
> +		pdata->p.pins.cs_activelow = 1; /* Default: CS = activelow */
> +	if (res < 8)
> +		pdata->p.no_spi_delay = 0; /* Default: Delay turned on */
> +	if (res < 7)
> +		pdata->p.max_bus_speed = 5000000; /* Default: 5Mhz */
> +	if (res < 6)
> +		pdata->p.mode = 0; /* Default: SPI mode 0 */
> +	if (res < 5 || res > 9)
> +		goto out; /* First 5 args are mandatory. */
> +
> +	/* Convert mode so that the SPI subsystem does understand it. */
> +	switch (pdata->p.mode) {
> +	case 0:
> +		pdata->p.mode = SPI_MODE_0;
> +		break;
> +	case 1:
> +		pdata->p.mode = SPI_MODE_1;
> +		break;
> +	case 2:
> +		pdata->p.mode = SPI_MODE_2;
> +		break;
> +	case 3:
> +		pdata->p.mode = SPI_MODE_3;
> +		break;
> +	default:
> +		goto out; /* Invalid mode */
> +	}
> +
> +	err = -EEXIST;
> +	if (gpiommc_sysfs_find_dev(pdata->p.name))
> +		goto out;
> +
> +	err = -ENOMEM;
> +	pdev = platform_device_alloc(GPIOMMC_PLATDEV_NAME, gpiommc_next_id());
> +	if (!pdev)
> +		goto out;
> +
> +	err = platform_device_add_data(pdev, pdata, sizeof(*pdata));
> +	if (err)
> +		goto err_free_pdev;
> +	pdata = pdev->dev.platform_data;
> +
> +	err = platform_device_add(pdev);
> +	if (err)
> +		goto err_free_pdev;
> +
> +	pdata->pdev = pdev;
> +	INIT_LIST_HEAD(&pdata->list);
> +	list_add(&pdata->list, &gpiommc_sysfs_list);
> +
> +	err = 0;
> +out:
> +	mutex_unlock(&gpiommc_sysfs_mutex);
> +
> +	return err ? err : count;
> +
> +err_free_pdev:
> +	platform_device_put(pdev);
> +	goto out;
> +}
> +
> +static ssize_t gpiommc_remove_store(struct device_driver *drv,
> +				    const char *buf, size_t count)
> +{
> +	struct gpiommc_sysfs_platform_data *pdata;
> +	int err;
> +
> +	mutex_lock(&gpiommc_sysfs_mutex);
> +
> +	err = -ENODEV;
> +	pdata = gpiommc_sysfs_find_dev(buf);
> +	if (!pdata)
> +		goto out;
> +
> +	list_del(&pdata->list);
> +	platform_device_unregister(pdata->pdev);
> +
> +out:
> +	mutex_unlock(&gpiommc_sysfs_mutex);
> +
> +	return err ? err : count;
> +}
> +
> +static DRIVER_ATTR(add, 0200,

Use defined symbols instead of inline constants (for 0200).

> +		   NULL, gpiommc_add_store);
> +static DRIVER_ATTR(remove, 0200,
> +		   NULL, gpiommc_remove_store);
> +
> +static struct platform_driver gpiommc_plat_driver = {
> +	.probe	= gpiommc_probe,
> +	.remove	= gpiommc_remove,
> +	.driver	= {
> +		.name	= GPIOMMC_PLATDEV_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +int gpiommc_next_id(void)
> +{
> +	static atomic_t counter = ATOMIC_INIT(-1);
> +
> +	return atomic_inc_return(&counter);
> +}
> +EXPORT_SYMBOL(gpiommc_next_id);
> +
> +static int __init gpiommc_modinit(void)
> +{
> +	int err;
> +
> +	err = platform_driver_register(&gpiommc_plat_driver);
> +	if (err)
> +		return err;
> +	err = driver_create_file(&gpiommc_plat_driver.driver,
> +				 &driver_attr_add);
> +	if (err)
> +		goto err_drv_unreg;
> +	err = driver_create_file(&gpiommc_plat_driver.driver,
> +				 &driver_attr_remove);
> +	if (err)
> +		goto err_remove_add;
> +
> +	return 0;
> +
> +err_remove_add:
> +	driver_remove_file(&gpiommc_plat_driver.driver,
> +			   &driver_attr_add);
> +err_drv_unreg:
> +	platform_driver_unregister(&gpiommc_plat_driver);
> +	return err;
> +}
> +module_init(gpiommc_modinit);
> +
> +static void __exit gpiommc_modexit(void)
> +{
> +	struct gpiommc_sysfs_platform_data *pdata, *pdata_tmp;
> +
> +	driver_remove_file(&gpiommc_plat_driver.driver,
> +			   &driver_attr_remove);
> +	driver_remove_file(&gpiommc_plat_driver.driver,
> +			   &driver_attr_add);
> +
> +	mutex_lock(&gpiommc_sysfs_mutex);
> +	list_for_each_entry_safe(pdata, pdata_tmp, &gpiommc_sysfs_list, list) {
> +		list_del(&pdata->list);
> +		platform_device_unregister(pdata->pdev);
> +	}
> +	mutex_unlock(&gpiommc_sysfs_mutex);
> +
> +	platform_driver_unregister(&gpiommc_plat_driver);
> +}
> +module_exit(gpiommc_modexit);
> Index: linux-next/drivers/mmc/host/Kconfig
> ===================================================================
> --- linux-next.orig/drivers/mmc/host/Kconfig	2008-07-18 21:52:46.000000000 +0200
> +++ linux-next/drivers/mmc/host/Kconfig	2008-07-18 21:57:08.000000000 +0200
> @@ -164,3 +164,23 @@ config MMC_S3C
>  
>  	  If unsure, say N.
>  
> +config GPIOMMC
> +	tristate "MMC/SD over GPIO-based SPI"
> +	depends on MMC && MMC_SPI && SPI_GPIO
> +	help
> +	  This driver hooks up the mmc_spi and spi_gpio modules so that
> +	  MMC/SD cards can be used on a GPIO based bus by bitbanging
> +	  the SPI protocol in software.
> +
> +	  This driver provides a sysfs interface to dynamically create
> +	  and destroy GPIO-based MMC/SD card interfaces. It also provides
> +	  a platform device interface API.
> +	  See Documentation/gpiommc.txt for details.
> +
> +	  The module will be called gpiommc.
> +
> +	  If unsure, say N.
> +
> +config MMC_S3C
> +	tristate "Samsung S3C SD/MMC Card Interface support"
> +	depends on ARCH_S3C2410 && MMC

> Index: linux-next/include/linux/mmc/gpiommc.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/include/linux/mmc/gpiommc.h	2008-07-18 21:54:05.000000000 +0200
> @@ -0,0 +1,62 @@
> +/*
> + * Device driver for MMC/SD cards driven over a GPIO bus.
> + *
> + * Copyright (c) 2008 Michael Buesch
> + *
> + * Licensed under the GNU/GPL version 2.
> + */
> +#ifndef LINUX_GPIOMMC_H_
> +#define LINUX_GPIOMMC_H_
> +
> +#include <linux/types.h>
> +
> +
> +#define GPIOMMC_MAX_NAMELEN		15
> +
> +/** struct gpiommc_pins - Hardware pin assignments

All of these kernel-doc blocks should be like:

/**
 * struct gpiommc_pines - Hardware pin assignments


> + * @gpio_di: The GPIO number of the DATA IN pin
> + * @gpio_do: The GPIO number of the DATA OUT pin
> + * @gpio_clk: The GPIO number of the CLOCK pin
> + * @gpio_cs: The GPIO number of the CHIPSELECT pin
> + * @cs_activelow: If true, the chip is considered selected if @gpio_cs is low.
> + */
> +struct gpiommc_pins {
> +	unsigned int gpio_di;
> +	unsigned int gpio_do;
> +	unsigned int gpio_clk;
> +	unsigned int gpio_cs;
> +	bool cs_activelow;
> +};
> +
> +/** struct gpiommc_platform_data - Platform data for a MMC-over-SPI-GPIO device.
> + * @name: The unique name string of the device.
> + * @pins: The hardware pin assignments.
> + * @mode: The hardware mode. This is either SPI_MODE_0,
> + *        SPI_MODE_1, SPI_MODE_2 or SPI_MODE_3. See the SPI documentation.
> + * @no_spi_delay: Do not use delays in the lowlevel SPI bitbanging code.
> + *                This is not standards compliant, but may be required for some
> + *                embedded machines to gain reasonable speed.
> + * @max_bus_speed: The maximum speed of the SPI bus, in Hertz.
> + */
> +struct gpiommc_platform_data {
> +	char name[GPIOMMC_MAX_NAMELEN + 1];
> +	struct gpiommc_pins pins;
> +	u8 mode;
> +	bool no_spi_delay;
> +	unsigned int max_bus_speed;
> +};
> +
> +/** GPIOMMC_PLATDEV_NAME - The platform device name string.
> + * The name string that has to be used for platform_device_alloc
> + * when allocating a gpiommc device.
> + */
> +#define GPIOMMC_PLATDEV_NAME	"gpiommc"
> +
> +/** gpiommc_next_id - Get another platform device ID number.
> + * This returns the next platform device ID number that has to be used
> + * for platform_device_alloc. The ID is opaque and should not be used for
> + * anything else.
> + */
> +int gpiommc_next_id(void);
> +
> +#endif /* LINUX_GPIOMMC_H_ */
> Index: linux-next/Documentation/gpiommc.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/Documentation/gpiommc.txt	2008-07-18 21:54:05.000000000 +0200
> @@ -0,0 +1,96 @@
> +GPIOMMC - Driver for an MMC/SD card on a bitbanging GPIO SPI bus
> +================================================================
> +
> +The gpiommc module hooks up the mmc_spi and spi_gpio modules for running an
> +MMC or SD card on GPIO pins.
> +
> +Two interfaces for registering a new MMC/SD card device are provided.

                                                           are provided:
   a static

> +A static platform-device based mechanism and a dynamic sysfs based interface.
> +
> +
> +Registering devices via platform-device
> +=======================================
> +
> +The platform-device interface is used for registering MMC/SD devices that are
> +part of the hardware platform. This is most useful only for embedded machines
> +with MMC/SD devices statically connected to the platform GPIO bus.
> +
> +The data structures are declared in <linux/mmc/gpiommc.h>

end sentence with '.'

> +
> +To register a new device, define an instance of struct gpiommc_platform_data.
> +This structure holds any information about how the device is hooked up to the
> +GPIO pins and what hardware modes the device supports. See the docbook-style
> +documentation in the header file for more information on the struct fields.
> +
> +Then allocate a new instance of a platform device by doing:
> +
> +	pdev = platform_device_alloc(GPIOMMC_PLATDEV_NAME, gpiommc_next_id());
> +
> +This will allocate the platform device data structures and hook it up to the
> +gpiommc driver.
> +Then add the gpiommc_platform_data to the platform device.
> +
> +	err = platform_device_add_data(pdev, pdata, sizeof(struct gpiommc_platform_data));
> +
> +You may free the local instance of struct gpiommc_platform_data now.
> +Now simply register the platform device.
> +
> +	err = platform_device_add(pdev);
> +
> +Done. The gpiommc probe routine should be called and you should see a dmesg

s/dmesg/kernel log/  (?)

> +message for the added device.
> +
> +
> +Registering devices via sysfs
> +=============================
> +
> +MMC/SD cards connected via GPIO often are a pretty dynamic thing. For example
> +selfmade hacks for soldering an MMC/SD card to standard GPIO pins on embedded
> +hardware are a common situation.

I think that the two sentences above/below would be better if joined with a comma...

> +So we provide a dynamic interface to conveniently handle adding and removing
> +devices from userspace, without the need to recompile the kernel.
> +
> +There are two sysfs files responsible for that:
> +export ADD=/sys/bus/platform/drivers/gpiommc/add
> +export REMOVE=/sys/bus/platform/drivers/gpiommc/remove
> +
> +To add a new device, simply echo the configuration string to the "add" file.
> +The config string is composed out of the following elements:
> +
> +DEVNAME DIpin DOpin CLKpin CSpin SPIMODE MAXBUSSPEED NO_SPI_DELAY CSACTIVELOW
> +
> +DEVNAME is a unique name string for the device.
> +DIpin is the SPI DI GPIO pin.
> +DOpin is the SPI DO GPIO pin.
> +CLKpin is the SPI CLOCK GPIO pin.
> +CSpin is the SPI CHIPSELECT GPIO pin.
> +SPIMODE is the hardware mode the device will run at. Can be 0-3.
> +MAXBUSSPEED is the maximum bus speed in Hertz.
> +NO_SPI_DELAY can be 1 or 0. If it is 1, then the lowlevel SPI delay
> +will not be performed. This is not standards compliant, but may be required
> +to gain reasonable speeds on embedded hardware.
> +CSACTIVELOW can be 1 or 0. If it is 1, the chip is considered to be selected, if CS
> +is at a logical 0.
> +

Would this be better done via configfs?  sysfs files are supposed to be
single-value files.

> +Note that the elements SPIMODE, MAXBUSSPEED and NO_SPI_DELAY are optional
> +and can be omitted.
> +SPIMODE will default to 0.
> +MAXBUSSSPEED will default to 5Mhz.
> +NO_SPI_DELAY will default to 0.
> +CSACTIVELOW will default to 1.
> +
> +Example:
> +
> +	echo -n "my_device 5 4 3 7 0 1000000 1" > $ADD
> +
> +This will add a new device called "my_device" with the GPIO pins assigned as
> +DI=5, DO=4, CLK=3, CS=7

end sentence with '.'

> +The hardware mode will be SPI_MODE_0.
> +The maximum bus speed will be 1000000 Hz (1Mhz)

ditto

> +And the explicit SPI delay at the lowlevel bitbang loop will be switched off.
> +
> +To remove a device, simply echo the device name string to the "remove" file.
> +
> +Example:
> +
> +	echo -n "my_device" > $REMOVE


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
