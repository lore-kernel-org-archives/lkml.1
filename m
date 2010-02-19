Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0BSK3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:29:36 -0500
Received: from mga12.intel.com ([143.182.124.36]:52385 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753455Ab0BSK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:29:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,502,1262592000"; 
   d="scan'208";a="245783961"
Date: Fri, 19 Feb 2010 11:30:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100219103048.GA10255@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DB4B.40501@compulab.co.il>
 <4B7D7C13.20703@compulab.co.il>
 <4B7D7CD0.7080202@oracle.com>
 <4B7D807D.9060105@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7D807D.9060105@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Thu, Feb 18, 2010 at 08:01:33PM +0200, Denis Turischev wrote:
> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> functions. Creating and MFD driver for the LPC bridge controller allows
> simultaneous use of SMBus and GPIO interfaces on the SCH.
> 
> v2: added "select MFD_CORE"
> v3: removed "default m"
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
patch applied, many thanks.

Cheers,
Samuel.


> diff -Nru linux-2.6.33-rc7.orig/drivers/mfd/Kconfig linux-2.6.33-rc7/drivers/mfd/Kconfig
> --- linux-2.6.33-rc7.orig/drivers/mfd/Kconfig	2010-02-07 00:17:12.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/mfd/Kconfig	2010-02-18 19:56:19.000000000 +0200
> @@ -348,6 +348,14 @@
>  	  read/write functions for the devices to get access to this chip.
>  	  This chip embeds various other multimedia funtionalities as well.
> 
> +config LPC_SCH
> +	tristate "Intel SCH LPC"
> +	depends on PCI
> +	select MFD_CORE
> +	help
> +	  LPC bridge function of the Intel SCH provides support for
> +	  System Management Bus and General Purpose I/O.
> +
>  endmenu
> 
>  menu "Multimedia Capabilities Port drivers"
> diff -Nru linux-2.6.33-rc7.orig/drivers/mfd/lpc_sch.c linux-2.6.33-rc7/drivers/mfd/lpc_sch.c
> --- linux-2.6.33-rc7.orig/drivers/mfd/lpc_sch.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/mfd/lpc_sch.c	2010-02-11 10:31:54.000000000 +0200
> @@ -0,0 +1,133 @@
> +/*
> + *  lpc_sch.c - LPC interface for Intel Poulsbo SCH
> + *
> + *  LPC bridge function of the Intel SCH contains many other
> + *  functional units, such as Interrupt controllers, Timers,
> + *  Power Management, System Management, GPIO, RTC, and LPC
> + *  Configuration Registers.
> + *
> + *  Copyright (c) 2010 CompuLab Ltd
> + *  Author: Denis Turischev <denis@compulab.co.il>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License 2 as published
> + *  by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/acpi.h>
> +#include <linux/pci.h>
> +#include <linux/mfd/core.h>
> +
> +#define SMBASE		0x40
> +#define SMBUS_IO_SIZE	64
> +
> +#define GPIOBASE	0x44
> +#define GPIO_IO_SIZE	64
> +
> +static struct resource smbus_sch_resource = {
> +		.flags = IORESOURCE_IO,
> +};
> +
> +
> +static struct resource gpio_sch_resource = {
> +		.flags = IORESOURCE_IO,
> +};
> +
> +static struct mfd_cell lpc_sch_cells[] = {
> +	{
> +		.name = "isch_smbus",
> +		.num_resources = 1,
> +		.resources = &smbus_sch_resource,
> +	},
> +	{
> +		.name = "sch_gpio",
> +		.num_resources = 1,
> +		.resources = &gpio_sch_resource,
> +	},
> +};
> +
> +static struct pci_device_id lpc_sch_ids[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
> +
> +static int __devinit lpc_sch_probe(struct pci_dev *dev,
> +				const struct pci_device_id *id)
> +{
> +	unsigned int base_addr_cfg;
> +	unsigned short base_addr;
> +
> +	pci_read_config_dword(dev, SMBASE, &base_addr_cfg);
> +	if (!(base_addr_cfg & (1 << 31))) {
> +		dev_err(&dev->dev, "Decode of the SMBus I/O range disabled\n");
> +		return -ENODEV;
> +	}
> +	base_addr = (unsigned short)base_addr_cfg;
> +	if (base_addr == 0) {
> +		dev_err(&dev->dev, "I/O space for SMBus uninitialized\n");
> +		return -ENODEV;
> +	}
> +
> +	smbus_sch_resource.start = base_addr;
> +	smbus_sch_resource.end = base_addr + SMBUS_IO_SIZE - 1;
> +
> +	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> +	if (!(base_addr_cfg & (1 << 31))) {
> +		dev_err(&dev->dev, "Decode of the GPIO I/O range disabled\n");
> +		return -ENODEV;
> +	}
> +	base_addr = (unsigned short)base_addr_cfg;
> +	if (base_addr == 0) {
> +		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
> +		return -ENODEV;
> +	}
> +
> +	gpio_sch_resource.start = base_addr;
> +	gpio_sch_resource.end = base_addr + GPIO_IO_SIZE - 1;
> +
> +	return mfd_add_devices(&dev->dev, -1,
> +			lpc_sch_cells, ARRAY_SIZE(lpc_sch_cells), NULL, 0);
> +}
> +
> +static void __devexit lpc_sch_remove(struct pci_dev *dev)
> +{
> +	mfd_remove_devices(&dev->dev);
> +}
> +
> +static struct pci_driver lpc_sch_driver = {
> +	.name		= "lpc_sch",
> +	.id_table	= lpc_sch_ids,
> +	.probe		= lpc_sch_probe,
> +	.remove		= __devexit_p(lpc_sch_remove),
> +};
> +
> +static int __init lpc_sch_init(void)
> +{
> +	return pci_register_driver(&lpc_sch_driver);
> +}
> +
> +static void __exit lpc_sch_exit(void)
> +{
> +	pci_unregister_driver(&lpc_sch_driver);
> +}
> +
> +module_init(lpc_sch_init);
> +module_exit(lpc_sch_exit);
> +
> +MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
> +MODULE_DESCRIPTION("LPC interface for Intel Poulsbo SCH");
> +MODULE_LICENSE("GPL");
> diff -Nru linux-2.6.33-rc7.orig/drivers/mfd/Makefile linux-2.6.33-rc7/drivers/mfd/Makefile
> --- linux-2.6.33-rc7.orig/drivers/mfd/Makefile	2010-02-07 00:17:12.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/mfd/Makefile	2010-02-10 15:15:40.000000000 +0200
> @@ -55,4 +55,5 @@
>  obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
>  obj-$(CONFIG_MFD_88PM8607)	+= 88pm8607.o
> -obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> \ No newline at end of file
> +obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> +obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
