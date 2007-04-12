Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXDLHJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXDLHJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXDLHJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:09:09 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43826 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442AbXDLHJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:09:08 -0400
Date: Thu, 12 Apr 2007 11:08:54 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 5/7] [RFC] ds2760 W1 slave
Message-ID: <20070412070854.GA32440@2ka.mipt.ru>
References: <20070411232517.GE20095@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232517.GE20095@zarina>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 12 Apr 2007 11:09:02 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:25:17AM +0400, Anton Vorontsov (cbou@mail.ru) wrote:
> This is W1 slave for ds2760 chip, found inside almost every HP iPaq and
> HTC PDAs/phones.

Hi Anton, I have some cleanup-related comments, patch itself looks good.

> diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
> new file mode 100644
> index 0000000..21b0ef6
> --- /dev/null
> +++ b/drivers/w1/slaves/w1_ds2760.c
> @@ -0,0 +1,162 @@
> +/*
> + * 1-Wire implementation for the ds2760 chip
> + *
> + * Copyright (c) 2004-2005, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> + *
> + * Use consistent with the GNU GPL is permitted,
> + * provided that this copyright notice is
> + * preserved in its entirety in all copies and derived works.
> + *
> + */
> +
> +#include <asm/types.h>

Is it really needed?

> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/device.h>
> +#include <linux/types.h>
> +#include <linux/jiffies.h>
> +
> +#include "../w1.h"
> +#include "../w1_int.h"
> +#include "../w1_family.h"
> +#include "w1_ds2760.h"
> +
> +static int w1_ds2760_io(struct device *dev, char *buf, int addr, size_t count,
> +                        int io)
> +{
> +	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
> +
> +	if (!dev)
> +		return 0;
> +
> +	mutex_lock(&sl->master->mutex);
> +
> +	if (addr > DS2760_DATA_SIZE || addr < 0) {
> +		count = 0;
> +		goto out;
> +	}
> +	if (addr + count > DS2760_DATA_SIZE)
> +		count = DS2760_DATA_SIZE - addr;
> +
> +	if (!w1_reset_select_slave(sl)) {
> +		if (!io) {
> +			w1_write_8(sl->master, W1_DS2760_READ_DATA);
> +			w1_write_8(sl->master, addr);
> +			count = w1_read_block(sl->master, buf, count);
> +		} else {
> +			w1_write_8(sl->master, W1_DS2760_WRITE_DATA);
> +			w1_write_8(sl->master, addr);
> +			w1_write_block(sl->master, buf, count);
> +			/* XXX w1_write_block returns void, not n_written */
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&sl->master->mutex);
> +
> +	return count;
> +}
> +
> +int w1_ds2760_read(struct device *dev, char *buf, int addr, size_t count)
> +{
> +	return w1_ds2760_io(dev, buf, addr, count, 0);
> +}
> +
> +int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
> +{
> +	return w1_ds2760_io(dev, buf, addr, count, 1);
> +}

Both are exported, who use them?

> +/* io = 0 means copy from EEPROM to SRAM, 1 means from SRAM to EEPROM */
> +static int w1_ds2760_eeprom(struct device *dev, int addr, int io)
> +{
> +	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
> +	int ret = 0;
> +
> +	mutex_lock(&sl->master->mutex);
> +
> +	if (!w1_reset_select_slave(sl)) {
> +		if (!io)
> +		    w1_write_8(sl->master, W1_DS2760_RECALL_DATA);
> +		else
> +		    w1_write_8(sl->master, W1_DS2760_COPY_DATA);
> +		w1_write_8(sl->master, addr);
> +	}
> +
> +	mutex_unlock(&sl->master->mutex);
> +
> +	return ret;
> +}
> +
> +int w1_ds2760_recall(struct device *dev, int addr)
> +{
> +	return w1_ds2760_eeprom(dev, addr, 0);
> +}
> +
> +int w1_ds2760_copy(struct device *dev, int addr)
> +{
> +	return w1_ds2760_eeprom(dev, addr, 1);
> +}

The same.

> +static ssize_t w1_ds2760_read_bin(struct kobject *kobj, char *buf, loff_t off,
> +                                  size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	return w1_ds2760_read(dev, buf, off, count);
> +}
> +
> +static struct bin_attribute w1_ds2760_bin_attr = {
> +	.attr = {
> +		.name = "w1_slave",
> +		.mode = S_IRUGO,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = DS2760_DATA_SIZE,
> +	.read = w1_ds2760_read_bin,
> +};
> +
> +static int w1_ds2760_add_slave(struct w1_slave *sl)
> +{
> +	return sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
> +}
> +
> +static void w1_ds2760_remove_slave(struct w1_slave *sl)
> +{
> +	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
> +}
> +
> +static struct w1_family_ops w1_ds2760_fops = {
> +	.add_slave    = w1_ds2760_add_slave,
> +	.remove_slave = w1_ds2760_remove_slave,
> +};
> +
> +static struct w1_family w1_ds2760_family = {
> +	.fid = W1_FAMILY_DS2760,
> +	.fops = &w1_ds2760_fops,
> +};
> +
> +static int __init w1_ds2760_init(void)
> +{
> +	printk("1-Wire driver for the DS2760 battery monitor chip "
> +	       " - (c) 2004-2005, Szabolcs Gyurko\n");
> +	return w1_register_family(&w1_ds2760_family);
> +}

Add something like KERN_INFO into printk.


-- 
	Evgeniy Polyakov
