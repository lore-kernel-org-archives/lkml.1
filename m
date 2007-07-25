Return-Path: <linux-kernel-owner+w=401wt.eu-S935383AbXGYS7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383AbXGYS7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766007AbXGYS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:58:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25801 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759927AbXGYS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:58:48 -0400
Message-ID: <46A79DE0.8060405@ru.mvista.com>
Date: Wed, 25 Jul 2007 23:00:48 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
In-Reply-To: <20070725165318.5331.23795.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Bordug wrote:

> This is now very similar to pata_platform.c, they both use
> same platform data structure and same resources.

> To achieve that, byte_lanes_swapping platform data variable
> and platform specified iops removed from that driver. It's fine,
> since those were never used anyway.

    Hopefully, PPC will never need them.

> pata_platform and ide_platform are carrying same driver names,
> to easily switch between these drivers, without need to touch
> platform code.

> diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
> new file mode 100644
> index 0000000..0b3f5b5
> --- /dev/null
> +++ b/drivers/ide/legacy/ide_platform.c
> @@ -0,0 +1,181 @@
> +/*
> + * Platform IDE driver
> + *
> + * Copyright (C) 2007 MontaVista Software
> + *
> + * Maintainer: Kumar Gala <galak@kernel.crashing.org>

    Poor Kumar, I guess he was surprised be being assigned a maintainer of the 
driver he didn't write (well, even if it borrowed some code from his earlier 
one ;-)...

> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/ide.h>
> +#include <linux/ioport.h>
> +#include <linux/module.h>
> +#include <linux/pata_platform.h>
> +#include <linux/io.h>
> +
> +static struct {
> +	void __iomem *plat_ide_mapbase;
> +	void __iomem *plat_ide_alt_mapbase;
> +	ide_hwif_t *hwif;
> +	int index;
> +} hwif_prop;
> +
> +static ide_hwif_t *__devinit plat_ide_locate_hwif(void __iomem *base,
> +	    void __iomem *ctrl, struct pata_platform_info *pdata, int irq,
> +	    int mmio)
> +{
> +	unsigned long port = (unsigned long)base;
> +	ide_hwif_t *hwif;
> +	int index, i;
> +
> +	for (index = 0; index < MAX_HWIFS; ++index) {
> +		hwif = ide_hwifs + index;
> +		if (hwif->io_ports[IDE_DATA_OFFSET] == port)
> +			goto found;
> +	}
> +
> +	for (index = 0; index < MAX_HWIFS; ++index) {
> +		hwif = ide_hwifs + index;
> +		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
> +			goto found;
> +	}
> +
> +	return NULL;
> +
> +found:
> +
> +	hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
> +
> +	port += (1 << pdata->ioport_shift);
> +	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
> +	     i++, port += (1 << pdata->ioport_shift))

    Looks like shift doesn't buy as anything, why not just use stride?

> +		hwif->hw.io_ports[i] = port;
> +
> +	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
> +
> +	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
> +	hwif->hw.irq = hwif->irq = irq;
> +
> +	hwif->hw.dma = NO_DMA;
> +	hwif->hw.chipset = ide_generic;
> +
> +	if (mmio) {
> +		hwif->mmio = 1;
> +		default_hwif_mmiops(hwif);
> +	}

    And why default_hwif_iops(hwif) is not called else?
    And I remember the previos variant was overriding INSW()/OUTSW() methods 
-- turned out to be unnecessary? :-)

> +
> +	hwif_prop.hwif = hwif;
> +	hwif_prop.index = index;
> +
> +	return hwif;
> +}
> +
> +static int __devinit plat_ide_probe(struct platform_device *pdev)
> +{
> +	struct resource *res_base, *res_alt, *res_irq;
> +	ide_hwif_t *hwif;
> +	struct pata_platform_info *pdata;
> +	int ret = 0;
> +	int mmio = 0;
> +
> +	pdata = pdev->dev.platform_data;
> +
> +	/* get a pointer to the register memory */
> +	res_base = platform_get_resource(pdev, IORESOURCE_IO, 0);
> +	res_alt = platform_get_resource(pdev, IORESOURCE_IO, 1);
> +
> +	if (!res_base || !res_alt) {
> +		res_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		res_alt = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		if (!res_base || !res_alt) {
> +			ret = -ENOMEM;

    ENODEV or EINVAL you mean? :-)

> +			goto out;

    Bleh... just return please.

> +		}
> +		mmio = 1;
> +	}
> +
> +	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res_irq) {
> +		ret = -EINVAL;
> +		goto out;

    Bleh... return -EINVAL, please. Or maybe -ENODEV.

> +	}
> +
[...]
> +	hwif = plat_ide_locate_hwif(hwif_prop.plat_ide_mapbase,
> +	         hwif_prop.plat_ide_alt_mapbase, pdata, res_irq->start, mmio);
> +
> +	if (!hwif) {
> +		ret = -ENODEV;
> +		goto out;

    Bleh... please just

return -ENODEV.

> +	}
> +	hwif->gendev.parent = &pdev->dev;
> +	hwif->noprobe = 0;
> +
> +	probe_hwif_init(hwif);
> +
> +	platform_set_drvdata(pdev, hwif);
> +	ide_proc_register_port(hwif);
> +
> +	return 0;
> +
> +out:

    No need to abuse the function cleanup style when you have nothing to 
cleanup. :-/

> +	return ret;
> +}
> +
> +static int __devexit plat_ide_remove(struct platform_device *pdev)
> +{
> +	ide_hwif_t *hwif = pdev->dev.driver_data;
> +
> +	if (hwif != hwif_prop.hwif) {
> +		dev_printk(KERN_DEBUG, &pdev->dev, "%s: hwif value error",
> +		           pdev->name);
> +	} else {
> +		ide_unregister(hwif_prop.index);
> +		hwif_prop.index = 0;
> +		hwif_prop.hwif = NULL;
> +	}
> +

    I'd have interchanged the success/failure branches...

> +	return 0;
> +}
> +
> +static struct platform_driver platform_ide_driver = {
> +	.driver {
> +		.name = "pata_platform",
> +	},
> +	.probe = plat_ide_probe,
> +	.remove = __devexit_p(plat_ide_remove),
> +};
> +
> +static int __init platform_ide_init(void)
> +{
> +	return platform_driver_register(&platform_ide_driver);
> +}
> +
> +static void __exit platform_ide_exit(void)
> +{
> +	platform_driver_unregister(&platform_ide_driver);
> +}
> +
> +MODULE_DESCRIPTION("Platform IDE driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(platform_ide_init);
> +module_exit(platform_ide_exit);
