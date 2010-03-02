Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0CBTnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 14:43:17 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43165 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0CBTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 14:43:16 -0500
Message-ID: <4B8D69D0.1050209@ru.mvista.com>
Date: Tue, 02 Mar 2010 22:41:04 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] ahci: Add platform driver
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru> <20100302182947.GL3445@oksana.dev.rtsoft.ru>
In-Reply-To: <20100302182947.GL3445@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

> This can be used for AHCI-compatible interfaces implemented inside
> a System-On-Chip solutions, or AHCI devices connected via localbus.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
[...]
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> new file mode 100644
> index 0000000..f3f96d6
> --- /dev/null
> +++ b/drivers/ata/ahci_platform.c
> @@ -0,0 +1,196 @@
> +/*
> + * AHCI SATA platform driver
> + *
> + * Copyright 2004-2005  Red Hat, Inc.
> + *   Jeff Garzik <jgarzik@pobox.com>
> + * Copyright 2010  MontaVista Software, LLC.
> + *   Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/libata.h>
> +#include <linux/platform_device.h>
> +#include "ahci.h"
> +#include "ahci_platform.h"
> +
> +static int __devinit ahci_probe(struct platform_device *pdev)
>   

  Does it make sense to make this driver hotplug capable?

> +{
> +	struct device *dev = &pdev->dev;
> +	struct ahci_platform_data *pdata = pdev->dev.platform_data;
> +	struct ata_port_info pi = {
> +		.flags		= AHCI_FLAG_COMMON,
> +		.pio_mask	= ATA_PIO4,
> +		.udma_mask	= ATA_UDMA6,
> +		.port_ops	= &ahci_ops,
> +	};
> +	const struct ata_port_info *ppi[] = { &pi, NULL };
> +	struct ahci_host_priv *hpriv;
> +	struct ata_host *host;
> +	struct resource *res;
> +	int n_ports;
> +	int i;
> +	int rc;
> +
> +	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
>   

   Hm...

> +	ahci_set_em_messages(hpriv, &pi);
> +
> +
>   

   Extra newline?

> +
> +
>   

  Another one?

> +		/* disabled/not-implemented port */
> +		if (!(hpriv->port_map & (1 << i)))
> +			ap->ops = &ata_dummy_port_ops;
> +	}
> +
> +	rc = ahci_reset_controller(host);
> +	if (rc)
> +		goto err0;
> +
> +	ahci_init_controller(host);
> +	ahci_print_info(host, "platform");
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>   

   Could also use platform_get_irq()...

> diff --git a/drivers/ata/ahci_platform.h b/drivers/ata/ahci_platform.h
> new file mode 100644
> index 0000000..f7dd576
> --- /dev/null
> +++ b/drivers/ata/ahci_platform.h
>   

   I doubt that it's good place for declaring the platform data which 
will be used by the platform code. This file should be somewhere in 
include/linux/, don't you think?

> @@ -0,0 +1,29 @@
> +/*
> + * AHCI SATA platform driver
> + *
> + * Copyright 2004-2005  Red Hat, Inc.
> + *   Jeff Garzik <jgarzik@pobox.com>
> + * Copyright 2010  MontaVista Software, LLC.
> + *   Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + */
> +
> +#ifndef _AHCI_PLATFORM_H
> +#define _AHCI_PLATFORM_H
> +
> +struct device;
> +struct ata_port_info;
> +
> +struct ahci_platform_data {
> +	int (*init)(struct device *dev);
> +	void (*exit)(struct device *dev);
> +	const struct ata_port_info *ata_port_info;
> +	unsigned int force_port_map;
> +	unsigned int mask_port_map;
> +};
> +
> +#endif /* _AHCI_PLATFORM_H */
>   

MBR, Sergei

