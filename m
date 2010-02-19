Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0BSKbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:31:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:20381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0BSKbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:31:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,502,1262592000"; 
   d="scan'208";a="493799175"
Date: Fri, 19 Feb 2010 11:33:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v2 2/3] i2c: convert i2c-isch to platform_device
Message-ID: <20100219103301.GB10255@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DBB2.7020601@compulab.co.il>
 <4B7C0E5D.3070909@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7C0E5D.3070909@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Wed, Feb 17, 2010 at 05:42:21PM +0200, Denis Turischev wrote:
> acpi_check_region will be implemented in mfd-core, therefore v2 version avoids
> this check
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
This patch doesnt apply properly against neither my mfd tree nor Linus tree.
Could you refresh it against the latest Linus tree, please ?
Same applies to the GPIO patch, btw.

Cheers,
Samuel.


> --- linux-2.6.33-rc7.orig/drivers/i2c/busses/i2c-isch.c	2010-02-07 00:17:12.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/i2c/busses/i2c-isch.c	2010-02-17 17:08:53.000000000 +0200
> @@ -27,7 +27,7 @@
>  */
> 
>  #include <linux/module.h>
> -#include <linux/pci.h>
> +#include <linux/platform_device.h>
>  #include <linux/kernel.h>
>  #include <linux/delay.h>
>  #include <linux/stddef.h>
> @@ -46,12 +46,6 @@
>  #define SMBHSTDAT1	(7 + sch_smba)
>  #define SMBBLKDAT	(0x20 + sch_smba)
> 
> -/* count for request_region */
> -#define SMBIOSIZE	64
> -
> -/* PCI Address Constants */
> -#define SMBBA_SCH	0x40
> -
>  /* Other settings */
>  #define MAX_TIMEOUT	500
> 
> @@ -63,7 +57,6 @@
>  #define SCH_BLOCK_DATA		0x05
> 
>  static unsigned short sch_smba;
> -static struct pci_driver sch_driver;
>  static struct i2c_adapter sch_adapter;
> 
>  /*
> @@ -256,37 +249,23 @@
>  	.algo		= &smbus_algorithm,
>  };
> 
> -static struct pci_device_id sch_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
> -	{ 0, }
> -};
> -
> -MODULE_DEVICE_TABLE(pci, sch_ids);
> -
> -static int __devinit sch_probe(struct pci_dev *dev,
> -				const struct pci_device_id *id)
> +static int __devinit smbus_sch_probe(struct platform_device *dev)
>  {
> +	struct resource *res;
>  	int retval;
> -	unsigned int smba;
> 
> -	pci_read_config_dword(dev, SMBBA_SCH, &smba);
> -	if (!(smba & (1 << 31))) {
> -		dev_err(&dev->dev, "SMBus I/O space disabled!\n");
> -		return -ENODEV;
> -	}
> +	res = platform_get_resource(dev, IORESOURCE_IO, 0);
> +	if (!res)
> +		return -EBUSY;
> 
> -	sch_smba = (unsigned short)smba;
> -	if (sch_smba == 0) {
> -		dev_err(&dev->dev, "SMBus base address uninitialized!\n");
> -		return -ENODEV;
> -	}
> -	if (acpi_check_region(sch_smba, SMBIOSIZE, sch_driver.name))
> -		return -ENODEV;
> -	if (!request_region(sch_smba, SMBIOSIZE, sch_driver.name)) {
> +	if (!request_region(res->start, resource_size(res), dev->name)) {
>  		dev_err(&dev->dev, "SMBus region 0x%x already in use!\n",
>  			sch_smba);
>  		return -EBUSY;
>  	}
> +
> +	sch_smba = res->start;
> +
>  	dev_dbg(&dev->dev, "SMBA = 0x%X\n", sch_smba);
> 
>  	/* set up the sysfs linkage to our parent device */
> @@ -298,37 +277,43 @@
>  	retval = i2c_add_adapter(&sch_adapter);
>  	if (retval) {
>  		dev_err(&dev->dev, "Couldn't register adapter!\n");
> -		release_region(sch_smba, SMBIOSIZE);
> +		release_region(res->start, resource_size(res));
>  		sch_smba = 0;
>  	}
> 
>  	return retval;
>  }
> 
> -static void __devexit sch_remove(struct pci_dev *dev)
> +static int __devexit smbus_sch_remove(struct platform_device *pdev)
>  {
> +	struct resource *res;
>  	if (sch_smba) {
>  		i2c_del_adapter(&sch_adapter);
> -		release_region(sch_smba, SMBIOSIZE);
> +		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> +		release_region(res->start, resource_size(res));
>  		sch_smba = 0;
>  	}
> +
> +	return 0;
>  }
> 
> -static struct pci_driver sch_driver = {
> -	.name		= "isch_smbus",
> -	.id_table	= sch_ids,
> -	.probe		= sch_probe,
> -	.remove		= __devexit_p(sch_remove),
> +static struct platform_driver smbus_sch_driver = {
> +	.driver = {
> +		.name = "isch_smbus",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe		= smbus_sch_probe,
> +	.remove		= __devexit_p(smbus_sch_remove),
>  };
> 
>  static int __init i2c_sch_init(void)
>  {
> -	return pci_register_driver(&sch_driver);
> +	return platform_driver_register(&smbus_sch_driver);
>  }
> 
>  static void __exit i2c_sch_exit(void)
>  {
> -	pci_unregister_driver(&sch_driver);
> +	platform_driver_unregister(&smbus_sch_driver);
>  }
> 
>  MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
> @@ -337,3 +322,4 @@
> 
>  module_init(i2c_sch_init);
>  module_exit(i2c_sch_exit);
> +MODULE_ALIAS("platform:isch_smbus");

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
