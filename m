Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYCGQKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYCGQKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYCGQK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:10:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37180 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYCGQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:10:25 -0500
Date: Fri, 7 Mar 2008 08:10:12 -0800
From: Greg KH <greg@kroah.com>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
Message-ID: <20080307161012.GC28439@kroah.com>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 06:11:54PM +0000, Liam Girdwood wrote:
> This patch provides the regulator framework core. The core also provides a
> sysfs interface for userspace information.
> 
> Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/reg-core.c | 1311 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1311 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/reg-core.c
> 
> diff --git a/drivers/regulator/reg-core.c b/drivers/regulator/reg-core.c
> new file mode 100644
> index 0000000..56367ab
> --- /dev/null
> +++ b/drivers/regulator/reg-core.c
> @@ -0,0 +1,1311 @@
> +/*
> + * regulator.c  --  Voltage/Current Regulator framework.
> + *
> + * Copyright 2007, 2008 Wolfson Microelectronics PLC.
> + *
> + * Author: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/regulator/regulator.h>
> +#include <linux/regulator/regulator-drv.h>
> +#include <linux/regulator/regulator-platform.h>
> +
> +#define REGULATOR_VERSION "0.4"
> +
> +static DEFINE_MUTEX(regulator_list_mutex);
> +static LIST_HEAD(regulator_list);
> +
> +/**
> + * struct regulator_cdev
> + *
> + * Voltage / Current regulator class device. One for each regulator.
> + */
> +struct regulator_cdev {
> +	struct regulator_desc *desc;
> +	int use_count;
> +
> +	struct list_head list;
> +	struct list_head consumer_list;
> +	struct blocking_notifier_head notifier;
> +	struct mutex mutex; /* consumer lock */
> +	struct module *owner;
> +	struct class_device cdev;

Can you change this to use a "struct device" instead?  We are trying to
get rid of class_device, and there are only 3 users of it in the kernel
today (memorystick, infiniband, and scsi), and I have patches pending to
fix all of these.  For 2.6.26 I would like to be rid of it finally.

If you want, I would be glad to fix this up for you, it should be a
pretty simple replacement.

> +	struct regulation_constraints *constraints;
> +	struct regulator_cdev *parent;	/* for tree */

And if when you convert, you can get rid of this pointer, it would not
be needed.

> +	void *reg_data;		/* regulator_cdev data */

Nor would this one.  Actually I don't think you need this one today
anyway...

thanks,

greg k-h
