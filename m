Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYGJG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYGJG4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYGJG4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:56:45 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:57841 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYGJG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:56:44 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-28.messagelabs.com!1215673003!10948961!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 10 Jul 2008 08:56:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710065639.GA16794@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jul 2008 06:56:39.0788 (UTC) FILETIME=[1A65EAC0:01C8E25A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Magnus Damm wrote:
> This patch is V2 of uio_pdrv_genirq.c, a platform driver for UIO with
> generic IRQ handling code. This driver is very similar to the regular
> UIO platform driver, but is only suitable for devices that are
> connected to the interrupt controller using unique interrupt lines.
> 
> The uio_pdrv_genirq driver includes generic interrupt handling code
> which disables the serviced interrupt in the interrupt controller
> and makes the user space driver responsible for acknowledging the
> interrupt in the device and reenabling the interrupt in the interrupt
> controller.
> 
> Shared interrupts are not supported since the in-kernel interrupt
> handler will disable the interrupt line in the interrupt controller,
> and in a shared interrupt configuration this will stop other devices
> from delivering interrupts.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Changes since V1
>   - allow user space to enable _and_ disable the interrupt
>   - replaced bitops with spinlock + irq_disabled variable
>   - renamed pdata variable name to priv
> 
>  drivers/uio/Kconfig           |   13 ++
>  drivers/uio/Makefile          |    1
>  drivers/uio/uio_pdrv_genirq.c |  186 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 200 insertions(+)
> 
> --- 0014/drivers/uio/Kconfig
> +++ work/drivers/uio/Kconfig    2008-07-09 17:10:20.000000000 +0900
> @@ -33,6 +33,19 @@ config UIO_PDRV
> 
>           If you don't know what to do here, say N.
> 
> +config UIO_PDRV_GENIRQ
> +       tristate "Userspace I/O platform driver with generic IRQ handling"
> +       help
> +         Platform driver for Userspace I/O devices, including generic
> +         interrupt handling code. Shared interrupts are not supported.
> +
> +         This kernel driver requires that the matching userspace driver
> +         handles interrupts in a special way. Userspace is responsible
> +         for acknowledging the hardware device if needed, and re-enabling
> +         interrupts in the interrupt controller using the write() syscall.
> +
> +         If you don't know what to do here, say N.
> +
>  config UIO_SMX
>         tristate "SMX cryptengine UIO interface"
>         depends on UIO
> --- 0014/drivers/uio/Makefile
> +++ work/drivers/uio/Makefile   2008-07-09 17:10:20.000000000 +0900
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_UIO)      += uio.o
>  obj-$(CONFIG_UIO_CIF)  += uio_cif.o
>  obj-$(CONFIG_UIO_PDRV) += uio_pdrv.o
> +obj-$(CONFIG_UIO_PDRV_GENIRQ)  += uio_pdrv_genirq.o
>  obj-$(CONFIG_UIO_SMX)  += uio_smx.o
> --- /dev/null
> +++ work/drivers/uio/uio_pdrv_genirq.c  2008-07-10 12:24:52.000000000 +0900
> @@ -0,0 +1,186 @@
> +/*
> + * drivers/uio/uio_pdrv_genirq.c
> + *
> + * Userspace I/O platform driver with generic IRQ handling code.
> + *
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on uio_pdrv.c by Uwe Kleine-Koenig,
> + * Copyright (C) 2008 by Digi International Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +#include <linux/spinlock.h>
> +#include <linux/interrupt.h>
> +#include <linux/stringify.h>
> +
> +#define DRIVER_NAME "uio_pdrv_genirq"
> +
> +struct uio_pdrv_genirq_platdata {
> +       struct uio_info *uioinfo;
> +       spinlock_t lock;
> +       int irq_disabled;
> +};
> +
> +static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
> +{
> +       struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> +       unsigned long flags;
> +
> +       /* Just disable the interrupt in the interrupt controller, and
> +        * remember the state so we can allow user space to enable it later.
> +        */
> +       spin_lock_irqsave(&priv->lock, flags);
> +       if (!priv->irq_disabled) {
> +               disable_irq_nosync(irq);
> +               priv->irq_disabled = 1;
> +       }
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +       return IRQ_HANDLED;
> +}
> +
> +static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
> +{
> +       struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> +       unsigned long flags;
> +
> +       /* Allow user space to enable and disable the interrupt
> +        * in the interrupt controller, but keep track of the
> +        * state to prevent per-irq depth damage.
> +        */
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +       if (irq_on && priv->irq_disabled)
> +               enable_irq(dev_info->irq);
> +       else if (!irq_on && !priv->irq_disabled)
> +               disable_irq(dev_info->irq);
I'm not sure if this is a problem on SMP.  Should you use
disable_irq_nosync here, too?  Probably it's OK.

> +
> +       priv->irq_disabled = !irq_on;
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +       return 0;
> +}


> +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
> +       if (ret) {
> +               dev_err(&pdev->dev, "unable to register uio device\n");
> +               goto bad1;
> +       }
> +
> +       platform_set_drvdata(pdev, priv);
This should probably go before uio_register_device.  (Uups, this is an
issue for uio_pdrv, too.)

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
