Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752780AbYLRGek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbYLRGek (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYLRGea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:34:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbYLRGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:34:29 -0500
Date: Wed, 17 Dec 2008 22:33:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>, sameo@openedhand.com,
        eric miao <eric.miao@marvell.com>, cbou@mail.ru,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC PATCH 2/2] Add Dialog DA9030 battery charger driver
Message-Id: <20081217223357.7467de89.akpm@linux-foundation.org>
In-Reply-To: <4948B09A.70108@compulab.co.il>
References: <4948B09A.70108@compulab.co.il>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 09:56:10 +0200 Mike Rapoport <mike@compulab.co.il> wrote:

> Driver for battery charger integrated into Dialog Semiconductor DA9030 PMIC
> 
> 
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
>  drivers/power/Kconfig          |    7 +
>  drivers/power/Makefile         |    1 +
>  drivers/power/da9030_battery.c |  592 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 600 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 8e0c2b4..db8145c 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -68,4 +68,11 @@ config BATTERY_BQ27x00
>  	help
>  	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
> 
> +config BATTERY_DA903X
> +	tristate "DA903x battery driver"
> +	depends on PMIC_DA903X
> +	help
> +	  Say Y here to enable support for batteries charger integrated into
> +	  DA9030/DA9030 PMICs.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index e8f1ece..58d1b46 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
>  obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
>  obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
>  obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
> +obj-$(CONFIG_BATTERY_DA903X)	+= da903x_battery.o
> diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
> new file mode 100644
> index 0000000..2dd9fef
> --- /dev/null
> +++ b/drivers/power/da9030_battery.c
> @@ -0,0 +1,592 @@
> +/*
> + * Battery charger driver for Dialog Semiconductor DA9030
> + *
> + * Copyright (C) 2008 Compulab, Ltd.
> + * 	Mike Rapoport <mike@compulab.co.il>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/power_supply.h>
> +#include <linux/mfd/da903x.h>
> +
> +#ifdef CONFIG_DEBUG_FS
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#endif

It's not a good ideas to put these includes inside an ifdef.  What
happens is that later someones adds some seq_file stuff outside
CONFIG_DEBUG_FS and it all works nicely so it gets merged.  Then
someone else disables debugfs and boom.

> +#define DA9030_STATUS_CHDET	(1 << 3)
> +
> +#define DA9030_FAULT_LOG		0x0a
> +#define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
> +#define DA9030_FAULT_LOG_VBAT_OVER	(1 << 4)
> +
> +#define DA9030_CHARGE_CONTROL		0x28
> +#define DA9030_CHRG_CHARGER_ENABLE	(1 << 7)
> +
> +#define DA9030_ADC_MAN_CONTROL		0x30
> +#define DA9030_ADC_TBATREF_ENABLE	(1 << 5)
> +#define DA9030_ADC_LDO_INT_ENABLE	(1 << 4)
> +
> +#define DA9030_ADC_AUTO_CONTROL		0x31
> +#define DA9030_ADC_TBAT_ENABLE		(1 << 5)
> +#define DA9030_ADC_VBAT_IN_TXON		(1 << 4)
> +#define DA9030_ADC_VCH_ENABLE		(1 << 3)
> +#define DA9030_ADC_ICH_ENABLE		(1 << 2)
> +#define DA9030_ADC_VBAT_ENABLE		(1 << 1)
> +#define DA9030_ADC_AUTO_SLEEP_ENABLE	(1 << 0)
> +
> +#define DA9030_VBATMON		0x32
> +#define DA9030_VBATMONTXON	0x33
> +#define DA9030_TBATHIGHP	0x34
> +#define DA9030_TBATHIGHN	0x35
> +#define DA9030_TBATLOW		0x36
> +
> +#define DA9030_VBAT_RES		0x41
> +#define DA9030_VBATMIN_RES	0x42
> +#define DA9030_VBATMINTXON_RES	0x43
> +#define DA9030_ICHMAX_RES	0x44
> +#define DA9030_ICHMIN_RES	0x45
> +#define DA9030_ICHAVERAGE_RES	0x46
> +#define DA9030_VCHMAX_RES	0x47
> +#define DA9030_VCHMIN_RES	0x48
> +#define DA9030_TBAT_RES		0x49
> +
> +struct da9030_adc_res {
> +	uint8_t vbat_res;
> +	uint8_t vbatmin_res;
> +	uint8_t vbatmintxon;
> +	uint8_t ichmax_res;
> +	uint8_t ichmin_res;
> +	uint8_t ichaverage_res;
> +	uint8_t vchmax_res;
> +	uint8_t vchmin_res;
> +	uint8_t tbat_res;
> +	uint8_t adc_in4_res;
> +	uint8_t adc_in5_res;
> +};

hm.  Are all the above fields sufficiently obvious as to not need any
description?

> +struct da9030_battery_thresholds {
> +	int tbat_low;
> +	int tbat_high;
> +	int tbat_restart;
> +
> +	int vbat_low;
> +	int vbat_crit;
> +	int vbat_charge_start;
> +	int vbat_charge_stop;
> +	int vbat_charge_restart;
> +
> +	int vcharge_min;
> +	int vcharge_max;
> +};
> +
>
> ...
>
> +static struct dentry *da9030_bat_create_debugfs(struct da9030_charger *charger)
> +{
> +	charger->debug_file = debugfs_create_file("charger", 0666, 0, charger,
> +						 &bat_debug_fops);
> +	return charger->debug_file;
> +}
> +
> +static void da9030_bat_remove_debugfs(struct da9030_charger *charger)
> +{
> +	debugfs_remove(charger->debug_file);
> +}
> +#else
> +#define da9030_bat_create_debugfs(x)	NULL
> +#define da9030_bat_remove_debugfs(x)	do {} while (0)

It would be better to make these stubs regular C functions, please. 
It's more symmetrical, more pleasing to the eye and provides
typechecking when CONFIG_DEBUG_FS=n.

> +#endif
> +
>
> ...
>
> +MODULE_DESCRIPTION("DA9030 battery charger driver");
> +MODULE_AUTHOR("Mike Rapoport, CompuLab");
> +MODULE_LICENSE("GPL");

A neat looking driver.  You deprive me of nits to pick.
