Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbYJJU5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbYJJU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762478AbYJJU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:57:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761556AbYJJU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:57:19 -0400
Date: Fri, 10 Oct 2008 13:38:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, madhu.cr@ti.com
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
Message-Id: <20081010133845.8b82fac3.akpm@linux-foundation.org>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 12:46:25 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> From: Madhusudhan Chikkature <madhu.cr@ti.com>
> 
> The HDQ/1-Wire module of TI OMAP2430/3430 platforms implement the hardware
> protocol of the master functions of the Benchmark HDQ and the Dallas
> Semiconductor 1-Wire protocols. These protocols use a single wire for
> communication between the master (HDQ/1-Wire controller) and the slave
> (HDQ/1-Wire external compliant device).
> 
> This patch provides the HDQ driver to suppport TI OMAP2430/3430 platforms.

Every tab character in all five patches was converted to eight-spaces by
your email client.  Please fix the mailer and resend everything.

> +++ linux-2.6/drivers/w1/masters/omap_hdq.c     2008-09-26 14:28:36.000000000 +0530
> @@ -0,0 +1,730 @@
> +/*
> + * drivers/w1/masters/omap_hdq.c
> + *
> + * Copyright (C) 2007 Texas Instruments, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <asm/irq.h>
> +#include <mach/hardware.h>

We conventionally put a blank line between the linux/ includes and the
asm/ includes.

> +static int omap_hdq_get(struct hdq_data *hdq_data);
> +static int omap_hdq_put(struct hdq_data *hdq_data);
> +static int omap_hdq_break(struct hdq_data *hdq_data);

These three aren't strictly needed, because these functions are defined
before first use.  I think it's best to not declare them.

> +static int hdq_wait_for_flag(struct hdq_data *hdq_data, u32 offset,
> +               u8 flag, u8 flag_set, u8 *status)
> +{
> +       int ret = 0;
> +       unsigned long timeout = jiffies + OMAP_HDQ_TIMEOUT;
> +
> +       if (flag_set == OMAP_HDQ_FLAG_CLEAR) {
> +               /* wait for the flag clear */
> +               while (((*status = hdq_reg_in(hdq_data, offset)) & flag)
> +                       && time_before(jiffies, timeout)) {
> +                       set_current_state(TASK_UNINTERRUPTIBLE);
> +                       schedule_timeout(1);

Use schedule_timeout_uninterruptible(1)

> +               }
> +               if (*status & flag)
> +                       ret = -ETIMEDOUT;
> +       } else if (flag_set == OMAP_HDQ_FLAG_SET) {
> +               /* wait for the flag set */
> +               while (!((*status = hdq_reg_in(hdq_data, offset)) & flag)
> +                       && time_before(jiffies, timeout)) {
> +                       set_current_state(TASK_UNINTERRUPTIBLE);
> +                       schedule_timeout(1);

elsewhere..

> +               }
> +               if (!(*status & flag))
> +                       ret = -ETIMEDOUT;
> +       } else
> +               return -EINVAL;
> +
> +       return ret;
> +}
> +
> +/* write out a byte and fill *status with HDQ_INT_STATUS */
> +static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
> +{
> +       int ret;
> +       u8 tmp_status;
> +       unsigned long irqflags;
> +
> +       *status = 0;
> +
> +       spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> +       /* clear interrupt flags via a dummy read */
> +       hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
> +       /* ISR loads it with new INT_STATUS */
> +       hdq_data->hdq_irqstatus = 0;
> +       spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
> +
> +       hdq_reg_out(hdq_data, OMAP_HDQ_TX_DATA, val);
> +
> +       /* set the GO bit */
> +       hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, OMAP_HDQ_CTRL_STATUS_GO,
> +               OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
> +       /* wait for the TXCOMPLETE bit */
> +       ret = wait_event_interruptible_timeout(hdq_wait_queue,
> +               hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
> +       if (ret < 0) {
> +               dev_dbg(hdq_data->dev, "wait interrupted");
> +               return -EINTR;
> +       }

Is this desirable?  The user hits ^C and the driver bails out?

I assume so, but was this tested?

> +       spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> +       *status = hdq_data->hdq_irqstatus;
> +       spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);

It's unusual to put a lock around a single atomic move instruction.

> +       /* check irqstatus */
> +       if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
> +               dev_dbg(hdq_data->dev, "timeout waiting for"
> +                       "TXCOMPLETE/RXCOMPLETE, %x", *status);
> +               return -ETIMEDOUT;
> +       }
> +
> +       /* wait for the GO bit return to zero */
> +       ret = hdq_wait_for_flag(hdq_data, OMAP_HDQ_CTRL_STATUS,
> +                       OMAP_HDQ_CTRL_STATUS_GO,
> +                       OMAP_HDQ_FLAG_CLEAR, &tmp_status);
> +       if (ret) {
> +               dev_dbg(hdq_data->dev, "timeout waiting GO bit"
> +                       "return to zero, %x", tmp_status);
> +               return ret;
> +       }
> +
> +       return ret;
> +}
>
> ...
>
> +/* Issue break pulse to the device */
> +static int omap_hdq_break(struct hdq_data *hdq_data)
> +{
> +       int ret;
> +       u8 tmp_status;
> +       unsigned long irqflags;
> +
> +       ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
> +       if (ret < 0)
> +               return -EINTR;
> +
> +       if (!hdq_data->hdq_usecount) {
> +               mutex_unlock(&hdq_data->hdq_mutex);
> +               return -EINVAL;
> +       }
> +
> +       spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> +       /* clear interrupt flags via a dummy read */
> +       hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
> +       /* ISR loads it with new INT_STATUS */
> +       hdq_data->hdq_irqstatus = 0;
> +       spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
> +
> +       /* set the INIT and GO bit */
> +       hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS,
> +               OMAP_HDQ_CTRL_STATUS_INITIALIZATION | OMAP_HDQ_CTRL_STATUS_GO,
> +               OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_INITIALIZATION |
> +               OMAP_HDQ_CTRL_STATUS_GO);
> +
> +       /* wait for the TIMEOUT bit */
> +       ret = wait_event_interruptible_timeout(hdq_wait_queue,
> +               hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
> +       if (ret < 0) {
> +               dev_dbg(hdq_data->dev, "wait interrupted");
> +               mutex_unlock(&hdq_data->hdq_mutex);
> +               return -EINTR;

Multiple-return-statements-per-function are a common source of
maintenance problems: locking errors, resource leaks.  This is why
kernel code usually does the `goto out' way of avoiding this.

So.. please consider.  In this case

	ret = -EINTR;
	goto out;

would fit nicely.

> +       }
> +
> +       spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> +       tmp_status = hdq_data->hdq_irqstatus;
> +       spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
> +       /* check irqstatus */
> +       if (!(tmp_status & OMAP_HDQ_INT_STATUS_TIMEOUT)) {
> +               dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x",
> +                               tmp_status);
> +               mutex_unlock(&hdq_data->hdq_mutex);
> +               return -ETIMEDOUT;

Here too.

> +       }
> +       /*
> +        * wait for both INIT and GO bits rerurn to zero.
> +        * zero wait time expected for interrupt mode.
> +        */
> +       ret = hdq_wait_for_flag(hdq_data, OMAP_HDQ_CTRL_STATUS,
> +                       OMAP_HDQ_CTRL_STATUS_INITIALIZATION |
> +                       OMAP_HDQ_CTRL_STATUS_GO, OMAP_HDQ_FLAG_CLEAR,
> +                       &tmp_status);
> +       if (ret)
> +               dev_dbg(hdq_data->dev, "timeout waiting INIT&GO bits"
> +                       "return to zero, %x", tmp_status);
> +
> +       mutex_unlock(&hdq_data->hdq_mutex);
> +
> +       return ret;
> +}
> +
> +static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
> +{
> +       int ret;
> +       u8 status;
> +       unsigned long irqflags;
> +       unsigned long timeout = jiffies + OMAP_HDQ_TIMEOUT;
> +
> +       ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
> +       if (ret < 0)
> +               return -EINTR;
> +
> +       if (!hdq_data->hdq_usecount) {
> +               mutex_unlock(&hdq_data->hdq_mutex);
> +               return -EINVAL;
> +       }
> +
> +       if (!(hdq_data->hdq_irqstatus & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
> +               hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS,
> +                       OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO,
> +                       OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
> +               /*
> +                * The RX comes immediately after TX. It
> +                * triggers another interrupt before we
> +                * sleep. So we have to wait for RXCOMPLETE bit.
> +                */
> +               while (!(hdq_data->hdq_irqstatus
> +                       & OMAP_HDQ_INT_STATUS_RXCOMPLETE)
> +                       && time_before(jiffies, timeout)) {
> +                       set_current_state(TASK_UNINTERRUPTIBLE);
> +                       schedule_timeout(1);

schedule_timeout_uninterruptible(1)

If we were to implement the presently-missing
wait_event_uninterruptible_timeout() (like
wait_event_interruptible_timeout), could we use it here?

> +               }
> +               hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, 0,
> +                       OMAP_HDQ_CTRL_STATUS_DIR);
> +               spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
> +               status = hdq_data->hdq_irqstatus;
> +               spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
> +               /* check irqstatus */
> +               if (!(status & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
> +                       dev_dbg(hdq_data->dev, "timeout waiting for"
> +                               "RXCOMPLETE, %x", status);
> +                       mutex_unlock(&hdq_data->hdq_mutex);
> +                       return -ETIMEDOUT;
> +               }
> +       }
> +       /* the data is ready. Read it in! */
> +       *val = hdq_reg_in(hdq_data, OMAP_HDQ_RX_DATA);
> +       mutex_unlock(&hdq_data->hdq_mutex);
> +
> +       return 0;
> +
> +}
> +
>
> ...
>
> +static int __init omap_hdq_probe(struct platform_device *pdev)
> +{
> +       struct hdq_data *hdq_data;
> +       struct resource *res;
> +       int ret, irq;
> +       u8 rev;
> +
> +       if (!pdev)
> +               return -ENODEV;

Can this happen?

> +       hdq_data = kmalloc(sizeof(*hdq_data), GFP_KERNEL);
> +       if (!hdq_data) {
> +               dev_dbg(&pdev->dev, "unable to allocate memory\n");
> +               ret = -ENODEV;

-ENOMEM

> +               goto err_kmalloc;
> +       }
> +
> +       hdq_data->dev = &pdev->dev;
> +       platform_set_drvdata(pdev, hdq_data);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_dbg(&pdev->dev, "unable to get resource\n");
> +               ret = ENXIO;

bzzt, that should have been -ENXIO.

> +               goto err_resource;
> +       }
> +
> +       hdq_data->hdq_base = ioremap(res->start, SZ_4K);
> +       if (!hdq_data->hdq_base) {
> +               dev_dbg(&pdev->dev, "ioremap failed\n");
> +               ret = -EINVAL;
> +               goto err_ioremap;
> +       }
> +
> +       /* get interface & functional clock objects */
> +       hdq_data->hdq_ick = clk_get(&pdev->dev, "hdq_ick");
> +       hdq_data->hdq_fck = clk_get(&pdev->dev, "hdq_fck");
> +
> +       if (IS_ERR(hdq_data->hdq_ick) || IS_ERR(hdq_data->hdq_fck)) {
> +               dev_dbg(&pdev->dev, "Can't get HDQ clock objects\n");
> +               if (IS_ERR(hdq_data->hdq_ick)) {
> +                       ret = PTR_ERR(hdq_data->hdq_ick);
> +                       goto err_clk;
> +               }
> +               if (IS_ERR(hdq_data->hdq_fck)) {
> +                       ret = PTR_ERR(hdq_data->hdq_fck);
> +                       clk_put(hdq_data->hdq_ick);
> +                       goto err_clk;
> +               }
> +       }
> +
> +       hdq_data->hdq_usecount = 0;
> +       mutex_init(&hdq_data->hdq_mutex);
> +
> +       if (clk_enable(hdq_data->hdq_ick)) {
> +               dev_dbg(&pdev->dev, "Can not enable ick\n");
> +               ret = -ENODEV;
> +               goto err_ick;
> +       }
> +
> +       if (clk_enable(hdq_data->hdq_fck)) {
> +               dev_dbg(&pdev->dev, "Can not enable fck\n");
> +               ret = -ENODEV;
> +               goto err_fck;
> +       }

ooh, I like err_ick and err_fck a lot.  They sound like akpm review
comments at the end of a long day.

> +       rev = hdq_reg_in(hdq_data, OMAP_HDQ_REVISION);
> +       dev_info(&pdev->dev, "OMAP HDQ Hardware Rev %c.%c. Driver in %s mode\n",
> +               (rev >> 4) + '0', (rev & 0x0f) + '0', "Interrupt");
> +
> +       spin_lock_init(&hdq_data->hdq_spinlock);
> +       omap_hdq_break(hdq_data);
> +
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0) {
> +               ret = -ENXIO;
> +               goto err_irq;
> +       }
> +
> +       ret = request_irq(irq, hdq_isr, IRQF_DISABLED, "omap_hdq", hdq_data);
> +       if (ret < 0) {
> +               dev_dbg(&pdev->dev, "could not request irq\n");
> +               goto err_irq;
> +       }
> +
> +       /* don't clock the HDQ until it is needed */
> +       clk_disable(hdq_data->hdq_ick);
> +       clk_disable(hdq_data->hdq_fck);
> +
> +       omap_w1_master.data = hdq_data;
> +
> +       ret = w1_add_master_device(&omap_w1_master);
> +       if (ret) {
> +               dev_dbg(&pdev->dev, "Failure in registering w1 master\n");
> +               goto err_w1;
> +       }
> +
> +       return 0;
> +
> +err_w1:
> +err_irq:
> +       clk_disable(hdq_data->hdq_fck);
> +
> +err_fck:
> +       clk_disable(hdq_data->hdq_ick);
> +
> +err_ick:
> +       clk_put(hdq_data->hdq_ick);
> +       clk_put(hdq_data->hdq_fck);
> +
> +err_clk:
> +       iounmap(hdq_data->hdq_base);
> +
> +err_ioremap:
> +err_resource:
> +       platform_set_drvdata(pdev, NULL);
> +       kfree(hdq_data);
> +
> +err_kmalloc:
> +       return ret;
> +
> +}
> +
> +static int omap_hdq_remove(struct platform_device *pdev)
> +{
> +       struct hdq_data *hdq_data = platform_get_drvdata(pdev);
> +
> +       mutex_lock(&hdq_data->hdq_mutex);
> +
> +       if (0 != hdq_data->hdq_usecount) {

Well.  Lots of people dislike that trick.  It's used to catch
accidental use of = where == was intended, but the compiler will warn
anyway.  There's less point in using it for !=.

> +               dev_dbg(&pdev->dev, "removed when use count is not zero\n");
> +               return -EBUSY;
> +       }
> +
> +       mutex_unlock(&hdq_data->hdq_mutex);
> +
> +       /* remove module dependency */
> +       clk_put(hdq_data->hdq_ick);
> +       clk_put(hdq_data->hdq_fck);
> +       free_irq(INT_24XX_HDQ_IRQ, hdq_data);
> +       platform_set_drvdata(pdev, NULL);
> +       iounmap(hdq_data->hdq_base);
> +       kfree(hdq_data);
> +
> +       return 0;
> +}
> +
> +static int __init
> +omap_hdq_init(void)
> +{
> +       return platform_driver_register(&omap_hdq_driver);
> +}
> +module_init(omap_hdq_init);
> +
> +static void __exit
> +omap_hdq_exit(void)
> +{
> +       platform_driver_unregister(&omap_hdq_driver);
> +}
> +module_exit(omap_hdq_exit);
> +
> +module_param(w1_id, int, S_IRUSR);
> +MODULE_PARM_DESC(w1_id, "1-wire id for the slave detection");
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("HDQ driver Library");
> +MODULE_LICENSE("GPL");

The code looks pretty good.

