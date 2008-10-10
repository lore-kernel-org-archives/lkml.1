Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbYJJUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbYJJUpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758978AbYJJUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:44:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758970AbYJJUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:44:49 -0400
Date: Fri, 10 Oct 2008 13:40:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, madhu.cr@ti.com
Subject: Re: [PATCH 2/5] HDQ: BQ27000 HDQ Slave Interface Driver
Message-Id: <20081010134051.93be2ae9.akpm@linux-foundation.org>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF2@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF2@dbde02.ent.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 12:49:19 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> From: Madhusudhan Chikkature <madhu.cr@ti.com>
> 
> This patch provides the BQ27000 slave interface driver.
> 
> ...
>
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/w1/slaves/w1_bq27000.c	2008-09-26 14:43:42.000000000 +0530
> @@ -0,0 +1,120 @@
> +/*
> + * drivers/w1/slaves/w1_bq27000.c
> + *
> + * Copyright (C) 2007 Texas Instruments, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/types.h>
> +#include <linux/platform_device.h>
> +#include <linux/mutex.h>
> +
> +#include "../w1.h"
> +#include "../w1_int.h"
> +#include "../w1_family.h"
> +
> +#define HDQ_CMD_READ	(0)
> +#define HDQ_CMD_WRITE	(1<<7)
> +
> +int F_ID;
> +int family_id;

No, we don't want to add kernel-wide symbols with names like this. 
Please either rename them to something which clearly identifies the
subsystem to which they belong, or make them static.

> +void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
> +{
> +	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
> +	if (!dev) {
> +		pr_info("Could not obtain slave dev ptr\n");
> +		return;
> +	}
> +
> +	w1_write_8(sl->master, HDQ_CMD_WRITE | reg);
> +	w1_write_8(sl->master, buf);
> +}
> +EXPORT_SYMBOL(w1_bq27000_write);
> +
> +int w1_bq27000_read(struct device *dev, u8 reg)
> +{
> +	u8 val;
> +	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
> +	if (!dev)
> +		return 0;
> +
> +	w1_write_8(sl->master, HDQ_CMD_READ | reg);
> +	val = w1_read_8(sl->master);
> +
> +	return val;
> +}
> +EXPORT_SYMBOL(w1_bq27000_read);

It's conventional to put a blank line between end-of-locals and
start-of-code.

> +static int w1_bq27000_add_slave(struct w1_slave *sl)
> +{
> +	int ret;
> +	int id = 1;
> +	struct platform_device *pdev;
> +
> +	pdev = platform_device_alloc("bq27000-battery", id);

Like that.

> +	if (!pdev) {
> +		ret = -ENOMEM;
> +		return ret;
> +	}
> +	pdev->dev.parent = &sl->dev;
> +
> +	ret = platform_device_add(pdev);
> +	if (ret)
> +		goto pdev_add_failed;
> +
> +	dev_set_drvdata(&sl->dev, pdev);
> +
> +	goto success;
> +
> +pdev_add_failed:
> +	platform_device_unregister(pdev);
> +success:
> +	return ret;
> +}
> +
> +static void w1_bq27000_remove_slave(struct w1_slave *sl)
> +{
> +	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
> +	platform_device_unregister(pdev);
> +}
> +
> +static struct w1_family_ops w1_bq27000_fops = {
> +	.add_slave	= w1_bq27000_add_slave,
> +	.remove_slave	= w1_bq27000_remove_slave,
> +};
> +
> +static struct w1_family w1_bq27000_family = {
> +	.fid = 1,
> +	.fops = &w1_bq27000_fops,
> +};
> +
> +static int __init w1_bq27000_init(void)
> +{
> +	if (F_ID)
> +		w1_bq27000_family.fid = F_ID;
> +
> +	return w1_register_family(&w1_bq27000_family);
> +}
> +
> +static void __exit w1_bq27000_exit(void)
> +{
> +	w1_unregister_family(&w1_bq27000_family);
> +}
> +
> +
> +module_init(w1_bq27000_init);
> +module_exit(w1_bq27000_exit);
> +
> +module_param(F_ID, int, S_IRUSR);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Texas Instruments Ltd");
> +MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");--

