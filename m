Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbYGCHHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbYGCHHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYGCG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:4464 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYGCDCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S5GvyTC/VKLdmGEQbQZ7OALwPxDkewNBbAIpZFbK5aJn6pEiHM+Uq2PID+sxFt8nZd
         LVbROTS9oX6qPUDHw+MW3Am/daUiw+zICjaz/er/w94idSrAlLo5WiYLTmmgZJnIU2pM
         lPdsJIhvItJsyOF22868daH1L0GjK9Y7eioD0=
Message-ID: <9e4733910807022002n3c739c7cs8ed642e4a6027bb6@mail.gmail.com>
Date: Wed, 2 Jul 2008 23:02:23 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       david-b@pacbell.net
In-Reply-To: <20080703010313.26187.99119.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
	 <20080703010313.26187.99119.stgit@trillian.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
>  This patch adds support for populating an SPI bus based on data in the
>  OF device tree.  This is useful for powerpc platforms which use the
>  device tree instead of discrete code for describing platform layout.
>
>  Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>  ---
>
>   drivers/of/Kconfig     |    6 +++
>   drivers/of/Makefile    |    1 +
>   drivers/of/of_spi.c    |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/of_spi.h |   18 ++++++++++
>   4 files changed, 113 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>  index 3a7a11a..edd6e92 100644
>  --- a/drivers/of/Kconfig
>  +++ b/drivers/of/Kconfig
>  @@ -13,3 +13,9 @@ config OF_I2C
>         depends on PPC_OF && I2C
>         help
>           OpenFirmware I2C accessors
>  +
>  +config OF_SPI
>  +       def_tristate SPI
>  +       depends on OF && PPC_OF && SPI
>  +       help
>  +         OpenFirmware SPI accessors
>  diff --git a/drivers/of/Makefile b/drivers/of/Makefile
>  index 548772e..4c3c6f8 100644
>  --- a/drivers/of/Makefile
>  +++ b/drivers/of/Makefile
>  @@ -2,3 +2,4 @@ obj-y = base.o
>   obj-$(CONFIG_OF_DEVICE) += device.o platform.o
>   obj-$(CONFIG_OF_GPIO)   += gpio.o
>   obj-$(CONFIG_OF_I2C)   += of_i2c.o
>  +obj-$(CONFIG_OF_SPI)   += of_spi.o
>  diff --git a/drivers/of/of_spi.c b/drivers/of/of_spi.c
>  new file mode 100644
>  index 0000000..ed0c807
>  --- /dev/null
>  +++ b/drivers/of/of_spi.c
>  @@ -0,0 +1,88 @@
>  +/*
>  + * SPI OF support routines
>  + * Copyright (C) 2008 Secret Lab Technologies Ltd.
>  + *
>  + * Support routines for deriving SPI device attachments from the device
>  + * tree.
>  + */
>  +
>  +#include <linux/of.h>
>  +#include <linux/device.h>
>  +#include <linux/spi/spi.h>
>  +#include <linux/of_spi.h>
>  +
>  +/**
>  + * of_register_spi_devices - Register child devices onto the SPI bus
>  + * @master:    Pointer to spi_master device
>  + * @np:                parent node of SPI device nodes
>  + *
>  + * Registers an spi_device for each child node of 'np' which has a 'reg'
>  + * property.
>  + */
>  +void of_register_spi_devices(struct spi_master *master, struct device_node *np)
>  +{
>  +       struct spi_device *spi;
>  +       struct device_node *nc;
>  +       const u32 *prop;
>  +       const char *sprop;
>  +       int rc;
>  +       int len;
>  +
>  +       for_each_child_of_node(np, nc) {
>  +               /* Alloc an spi_device */
>  +               spi = spi_alloc_device(master);
>  +               if (!spi) {
>  +                       dev_err(&master->dev, "spi_device alloc error for %s\n",
>  +                               nc->full_name);
>  +                       continue;
>  +               }
>  +
>  +               /* Device address */
>  +               prop = of_get_property(nc, "reg", &len);
>  +               if (!prop || len < sizeof(*prop)) {
>  +                       dev_err(&master->dev, "%s has no 'reg' property\n",
>  +                               nc->full_name);
>  +                       continue;
>  +               }
>  +               spi->chip_select = *prop;
>  +
>  +               /* Mode (clock phase/polarity/etc.) */
>  +               if (of_find_property(nc, "spi,cpha", NULL))
>  +                       spi->mode |= SPI_CPHA;
>  +               if (of_find_property(nc, "spi,cpol", NULL))
>  +                       spi->mode |= SPI_CPOL;
>  +
>  +               /* Device speed */
>  +               prop = of_get_property(nc, "max-speed", &len);
>  +               if (!prop || len < sizeof(*prop)) {
>  +                       dev_err(&master->dev, "%s has no 'max-speed' property\n",
>  +                               nc->full_name);
>  +                       continue;
>  +               }
>  +               spi->max_speed_hz = *prop;
>  +
>  +               /* IRQ */
>  +               spi->irq = irq_of_parse_and_map(nc, 0);
>  +
>  +               /* Select device driver */
>  +               sprop = of_get_property(nc, "linux,modalias", &len);
>  +               if (sprop && len > 0)
>  +                       strncpy(spi->modalias, sprop, KOBJ_NAME_LEN);
>  +               else
>  +                       strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN);

You're missing a request_module("%s", info.type) to make sure the
module is loaded.

It might make sense to share code with of_find_i2c_driver() so we have
a common way of guessing module names.

>  +
>  +               /* Store a pointer to the node in the device structure */
>  +               of_node_get(nc);
>  +               spi->dev.archdata.of_node = nc;
>  +
>  +               /* Register the new device */
>  +               rc = spi_add_device(spi);
>  +               if (rc) {
>  +                       dev_err(&master->dev, "spi_device register error %s\n",
>  +                               nc->full_name);
>  +                       spi_dev_put(spi);
>  +               }
>  +
>  +       }
>  +}
>  +EXPORT_SYMBOL(of_register_spi_devices);
>  diff --git a/include/linux/of_spi.h b/include/linux/of_spi.h
>  new file mode 100644
>  index 0000000..5f71ee8
>  --- /dev/null
>  +++ b/include/linux/of_spi.h
>  @@ -0,0 +1,18 @@
>  +/*
>  + * OpenFirmware SPI support routines
>  + * Copyright (C) 2008 Secret Lab Technologies Ltd.
>  + *
>  + * Support routines for deriving SPI device attachments from the device
>  + * tree.
>  + */
>  +
>  +#ifndef __LINUX_OF_SPI_H
>  +#define __LINUX_OF_SPI_H
>  +
>  +#include <linux/of.h>
>  +#include <linux/spi/spi.h>
>  +
>  +extern void of_register_spi_devices(struct spi_master *master,
>  +                                   struct device_node *np);
>  +
>  +#endif /* __LINUX_OF_SPI */
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
