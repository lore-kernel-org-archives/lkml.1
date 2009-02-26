Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbZBZVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbZBZVgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZBZVg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:36:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbZBZVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:36:24 -0500
Date: Thu, 26 Feb 2009 13:35:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: unsik Kim <donari75@gmail.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       shdl@zakalwe.fi, linux-arm-kernel@lists.arm.linux.org.uk,
       harvey.harrison@gmail.com, linux-embedded@vger.kernel.org,
       minchan.kim@gmail.com, donari75@gmail.com
Subject: Re: [PATCH] mflash: Initial support
Message-Id: <20090226133509.27b58014.akpm@linux-foundation.org>
In-Reply-To: <1235554274-794-1-git-send-email-donari75@gmail.com>
References: <1235554274-794-1-git-send-email-donari75@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 18:31:14 +0900
unsik Kim <donari75@gmail.com> wrote:

> This driver supports mflash IO mode for linux.
> 
> Mflash is embedded flash drive and mainly targeted mobile and consumer
> electronic devices.
> 
> Internally, mflash has nand flash and other hardware logics and supports
> 2 different operation (ATA, IO) modes. ATA mode doesn't need any new
> driver and currently works well under standard IDE subsystem. Actually it's
> one chip SSD. IO mode is ATA-like custom mode for the host that doesn't have
> IDE interface.
> 
> Followings are brief descriptions about IO mode.
> A. IO mode based on ATA protocol and uses some custom command. (read confirm,
> write confirm)
> B. IO mode uses SRAM bus interface.
> C. IO mode supports 4kB boot area, so host can boot from mflash.
> 

Have we fully explored the option of controlling this device with the
current ATA or IDE code, rather than creating a whole new parallel
block device implementation?

>
> ...
>
> --- /dev/null
> +++ b/drivers/block/mg_disk.c
> @@ -0,0 +1,981 @@
> +/*
> + *  drivers/block/mg_disk.c
> + *
> + *  Support for the mGine m[g]flash IO mode.
> + *  Based on legacy hd.c
> + *
> + * (c) 2008 mGine Co.,LTD
> + * (c) 2008 unsik Kim <donari75@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/blkdev.h>
> +#include <linux/hdreg.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/mg_disk.h>
> +
> +#define MG_RES_SEC (CONFIG_MG_DISK_RES << 1)
> +
> +static void mg_request(struct request_queue *);
> +
> +static void mg_dump_status(const char *msg, unsigned int stat,
> +		struct mg_host *host)
> +{
> +	char *name = MG_DISK_NAME"?";

The "?" seems strange.  Why do we want to print "mgd?" here?

> +	struct request *req;
> +
> +	if (host->breq) {
> +		req = elv_next_request(host->breq);
> +		if (req)
> +			name = req->rq_disk->disk_name;
> +	}
> +
> +	printk(KERN_DEBUG "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
> +	if (stat & MG_REG_STATUS_BIT_BUSY)
> +		printk("Busy ");
> +	if (stat & MG_REG_STATUS_BIT_READY)
> +		printk("DriveReady ");
> +	if (stat & MG_REG_STATUS_BIT_WRITE_FAULT)
> +		printk("WriteFault ");
> +	if (stat & MG_REG_STATUS_BIT_SEEK_DONE)
> +		printk("SeekComplete ");
> +	if (stat & MG_REG_STATUS_BIT_DATA_REQ)
> +		printk("DataRequest ");
> +	if (stat & MG_REG_STATUS_BIT_CORRECTED_ERROR)
> +		printk("CorrectedError ");
> +	if (stat & MG_REG_STATUS_BIT_ERROR)
> +		printk("Error ");
> +	printk("}\n");
> +	if ((stat & MG_REG_STATUS_BIT_ERROR) == 0) {
> +		host->error = 0;
> +	} else {
> +		host->error = inb(host->dev_base + MG_REG_ERROR);
> +		printk(KERN_DEBUG "%s: %s: error=0x%02x { ", name, msg,
> +				host->error & 0xff);
> +		if (host->error & MG_REG_ERR_BBK)
> +			printk("BadSector ");
> +		if (host->error & MG_REG_ERR_UNC)
> +			printk("UncorrectableError ");
> +		if (host->error & MG_REG_ERR_IDNF)
> +			printk("SectorIdNotFound ");
> +		if (host->error & MG_REG_ERR_ABRT)
> +			printk("DriveStatusError ");
> +		if (host->error & MG_REG_ERR_AMNF)
> +			printk("AddrMarkNotFound ");
> +		printk("}");
> +		if (host->error &
> +				(MG_REG_ERR_BBK | MG_REG_ERR_UNC |
> +				 MG_REG_ERR_IDNF | MG_REG_ERR_AMNF)) {
> +			if (host->breq) {
> +				req = elv_next_request(host->breq);
> +				if (req)
> +					printk(", sector=%ld", req->sector);
> +			}
> +
> +		}
> +		printk("\n");
> +	}
> +}
> +
> +static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
> +{
> +	u8 status;
> +	u64 expire, cur_jiffies;

cur_jiffies64 would be a clearer name.

> +	host->error = MG_ERR_NONE;
> +	expire = get_jiffies_64() + msecs_to_jiffies(msec);

But why is this code using jiffies_64 at all?  Why not use plain old
jiffies and unsigned longs?


> +	status = inb(host->dev_base + MG_REG_STATUS);
> +	do {
> +		cur_jiffies = get_jiffies_64();
> +		if (status & MG_REG_STATUS_BIT_BUSY) {
> +			if (expect == MG_REG_STATUS_BIT_BUSY)
> +				break;
> +		} else {
> +			/* Check the error condition! */
> +			if (status & MG_REG_STATUS_BIT_ERROR) {
> +				mg_dump_status("mg_wait", status, host);
> +				break;
> +			}
> +
> +			if (expect == MG_STAT_READY)
> +				if (MG_READY_OK(status))
> +					break;
> +
> +			if (expect == MG_REG_STATUS_BIT_DATA_REQ)
> +				if (status & MG_REG_STATUS_BIT_DATA_REQ)
> +					break;
> +		}
> +		status = inb(host->dev_base + MG_REG_STATUS);
> +	} while (cur_jiffies < expire);

This loop will not handle jiffy wrap properly.  Use
time_after/time_before/etc.

> +	if (cur_jiffies >= expire)

ditto.

> +		host->error = MG_ERR_TIMEOUT;
> +
> +	return host->error;
> +}

This function appears to be doing up-to-multi-second busy wait looping.
Bad.

Can we fix this by waiting for some interrupt?  Presumably not.  Can we
at least do something to prevent it from locking up the whole machine
for long periods while it chews up vast amounts of power?  Evan a silly
msleep(1) in there would help tremendously.

> +static void mg_unexpected_intr(struct mg_host *host)
> +{
> +	u32 status = inb(host->dev_base + MG_REG_STATUS);
> +
> +	mg_dump_status("mg_unexpected_intr", status, host);
> +}
> +
> +static irqreturn_t mg_irq(int irq, void *dev_id)
> +{
> +	struct mg_host *host = dev_id;
> +	void (*handler)(struct mg_host *) = host->mg_do_intr;
> +
> +	host->mg_do_intr = 0;
> +	del_timer(&host->timer);
> +	if (!handler)
> +		handler = mg_unexpected_intr;
> +	handler(host);
> +	return IRQ_HANDLED;
> +}
> +
> +static void mg_ide_fixstring(u8 *s, const int bytecount)
> +{
> +	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
> +
> +	/* convert from big-endian to host byte order */
> +	for (p = s ; p != end ; p += 2)

It's more conventional to omit the space before the semicolon in `for'
statements.

> +		be16_to_cpus((u16 *) p);
> +
> +	/* strip leading blanks */
> +	p = s;
> +	while (s != end && *s == ' ')
> +		++s;
> +	/* compress internal blanks and strip trailing blanks */
> +	while (s != end && *s) {
> +		if (*s++ != ' ' || (s != end && *s && *s != ' '))
> +			*p++ = *(s-1);
> +	}
> +	/* wipe out trailing garbage */
> +	while (p != end)
> +		*p++ = '\0';
> +}

erk, what's this doing?  Regularizing some ID text which it read from
the device, it seems.

It should have a nice comment explaining this, and perhaps explaining
the transformations which it attempts to make.

Because I'm sure that there's library code in the kernel which does at
least some of whatever-this-function-does.  Steve Rostedt presently has
some infrastructure code of this nature under review.

> +static int mg_get_disk_id(struct mg_host *host)
> +{
> +	u32 i, res;
> +	s32 err;
> +	u16 *id = (u16 *)&host->id_data;
> +	struct mg_drv_data *prv_data = host->dev->platform_data;
> +
> +	if (!prv_data->use_polling)
> +		outb(MG_REG_CTRL_INTR_DISABLE,
> +				host->dev_base + MG_REG_DRV_CTRL);
> +
> +	outb(MG_CMD_ID, host->dev_base + MG_REG_COMMAND);
> +	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
> +	if (err)
> +		return err;
> +
> +	for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
> +		id[i] = le16_to_cpu(inw(host->dev_base + MG_BUFF_OFFSET +
> +					i * 2));
> +
> +	outb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
> +	err = mg_wait(host, MG_STAT_READY, 3000);
> +	if (err)
> +		return err;
> +
> +	if ((host->id_data.field_valid & 1) == 0)
> +		return MG_ERR_TRANSLATION;
> +
> +#ifdef __BIG_ENDIAN
> +	host->id_data.lba_capacity = (host->id_data.lba_capacity << 16)
> +		| (host->id_data.lba_capacity >> 16);
> +#endif /* __BIG_ENDIAN */
> +	if (MG_RES_SEC) {
> +		/* modify cyls, lba_capacity */
> +		host->id_data.cyls = (host->id_data.lba_capacity - MG_RES_SEC) /
> +			host->id_data.heads / host->id_data.sectors;

Could a bad device trick the kernel into doing a divide-by-zero here?

> +		res = host->id_data.lba_capacity - host->id_data.cyls *
> +			host->id_data.heads * host->id_data.sectors;
> +		host->id_data.lba_capacity -= res;
> +	}
> +	host->tot_sectors = host->id_data.lba_capacity;
> +	mg_ide_fixstring(host->id_data.model,
> +			sizeof(host->id_data.model));
> +	mg_ide_fixstring(host->id_data.serial_no,
> +			sizeof(host->id_data.serial_no));
> +	mg_ide_fixstring(host->id_data.fw_rev,
> +			sizeof(host->id_data.fw_rev));
> +	printk(KERN_INFO "mg_disk: model: %s\n", host->id_data.model);
> +	printk(KERN_INFO "mg_disk: firm: %.8s\n", host->id_data.fw_rev);
> +	printk(KERN_INFO "mg_disk: serial: %s\n",
> +			host->id_data.serial_no);
> +	printk(KERN_INFO "mg_disk: %d + reserved %d sectors\n",
> +			host->tot_sectors, res);
> +
> +	if (!prv_data->use_polling)
> +		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
> +
> +	return err;
> +}
>
> ...
>
> +static int mg_resume(struct platform_device *plat_dev)
> +{
> +	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
> +	struct mg_host *host = prv_data->host;
> +
> +	if (mg_wait(host, MG_STAT_READY, 3000))
> +		return -EIO;
> +
> +	outb(MG_CMD_WAKEUP, host->dev_base + MG_REG_COMMAND);
> +	mdelay(1);

There's no way in which the reader of this code can determine why this
delay is here, and why it has this duration.  Comments shold be added
to fix this!

Can we avoid using a busy-waiting delay?

> +	if (mg_wait(host, MG_STAT_READY, 3000))
> +		return -EIO;
> +
> +	if (!prv_data->use_polling)
> +		outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
> +
> +	return 0;
> +}
> +
> +static int mg_probe(struct platform_device *plat_dev)
> +{
> +	struct mg_host *host;
> +	struct resource *rsc;
> +	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
> +	int err = 0;
> +
> +	if (!prv_data) {
> +		printk(KERN_ERR	"%s:%d fail (no driver_data)\n",
> +				__func__, __LINE__);
> +		err = -EINVAL;
> +		goto probe_err;
> +	}
> +
> +	/* alloc mg_host */
> +	host = kmalloc(sizeof(struct mg_host), GFP_KERNEL);
> +	if (!host) {
> +		printk(KERN_ERR "%s:%d fail (no memory for mg_host)\n",
> +				__func__, __LINE__);
> +		err = -ENOMEM;
> +		goto probe_err;
> +	}
> +	memset(host, 0, sizeof(struct mg_host));

use kzalloc()

> +	host->major = MG_DISK_MAJ;
> +
> +	/* link each other */
> +	prv_data->host = host;
> +	host->dev = &plat_dev->dev;
> +
> +	/* io remap */
> +	rsc = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
> +	if (!rsc) {
> +		printk(KERN_ERR "%s:%d platform_get_resource fail\n",
> +				__func__, __LINE__);
> +		err = -EINVAL;
> +		goto probe_err_2;
> +	}
> +	host->dev_base = (unsigned long)ioremap(rsc->start , rsc->end + 1);

ioremap() returns `void __iomem *'.  Casting it into an unsigned long
loses the sparse-checkable annotation and loses the (correct)
information that this is an address.

IOW, host->dev_base has the wrong type, doesn't it?


> +	if (!host->dev_base) {
> +		printk(KERN_ERR "%s:%d ioremap fail\n",
> +				__func__, __LINE__);
> +		err = -EIO;
> +		goto probe_err_2;
> +	}
> +	MG_DBG("dev_base = 0x%x\n", (u32)host->dev_base);
> +
> +	/* get reset pin */
> +	rsc = platform_get_resource(plat_dev, IORESOURCE_IO, 0);
> +	if (!rsc) {
> +		printk(KERN_ERR "%s:%d get reset pin fail\n",
> +				__func__, __LINE__);
> +		err = -EIO;
> +		goto probe_err_3;
> +	}
> +	host->rst = rsc->start;
> +
> +	/* init rst pin */
> +	err = gpio_request(host->rst, "mg_rst");
> +	if (err)
> +		goto probe_err_3;
> +	gpio_direction_output(host->rst, 1);

Did this driver express a dependency on GPIO in its Kconfig?

> +	/* disk init */
> +	err = mg_disk_init(host);
> +	if (err) {
> +		printk(KERN_ERR "%s:%d fail (err code : %d)\n",
> +				__func__, __LINE__, err);
> +		err = -EIO;
> +		goto probe_err_3a;
> +	}
> +
>
> ...
>

