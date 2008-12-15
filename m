Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYLOWi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYLOWi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYLOWiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:38:18 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:15602 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751844AbYLOWiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:38:17 -0500
Date: Tue, 16 Dec 2008 01:38:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/7] power_supply: PCF50633 battery charger driver
Message-ID: <20081215223811.GA2210@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110323.3307.84154.stgit@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20081214110323.3307.84154.stgit@cff.thadambail>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Balaji,

It's great to see OpenMoko patches submitted, much thanks
for your work!

You can find few comments below.

On Sun, Dec 14, 2008 at 04:33:23PM +0530, Balaji Rao wrote:
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/power/Kconfig            |    6 +
>  drivers/power/Makefile           |    2 
>  drivers/power/pcf50633-charger.c |  285 ++++++++++++++++++++++++++++++++++++++

>  3 files changed, 293 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/pcf50633-charger.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 52f8676..04f6316 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -75,4 +75,10 @@ config BATTERY_BQ27x00
>  	help
>  	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
>  
> +config CHARGER_PCF50633
> +	tristate "NXP PCF50633 MBC"
> +	depends on MFD_PCF50633
> +	help
> +	 Say Y to include support for NXP PCF50633 Main Battery Charger.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index e6f6865..62bcb76 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -24,3 +24,5 @@ obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
>  obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
>  obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
>  obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
> +
> +obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> new file mode 100644
> index 0000000..d4a0de5
> --- /dev/null
> +++ b/drivers/power/pcf50633-charger.c
> @@ -0,0 +1,285 @@
> +/* NXP PCF50633 Main Battery Charger Driver
> + *
> + * (C) 2006-2008 by Openmoko, Inc.
> + * Author: Balaji Rao <balajirrao@openmoko.org>
> + * All rights reserved.
> + *
> + * Broken down from monstrous PCF50633 driver mainly by
> + * Harald Welte, Andy Green and Werner Almesberger
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +

The code should explicitly include all the needed headers.

#include <linux/kernel.h> (for container_of, sprintf, ...)
#include <linux/module.h> (MODULE_, EXPORT_SYMBOL macros)
#include <linux/init.h> (initcalls)
#include <linux/types.h> (ssize_t)
#include <linux/device.h> (dev_info e.t.c.)
#include <linux/platform_device.h>
#include <linux/power_supply.h>

> +#include <linux/mfd/pcf50633/core.h>
> +#include <linux/mfd/pcf50633/mbc.h>
> +
> +void pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
> +{
> +	int ret;
> +	u8 bits;
> +
> +	if (ma >= 1000)
> +		bits = PCF50633_MBCC7_USB_1000mA;
> +	else if (ma >= 500)
> +		bits = PCF50633_MBCC7_USB_500mA;
> +	else if (ma >= 100)
> +		bits = PCF50633_MBCC7_USB_100mA;
> +	else
> +		bits = PCF50633_MBCC7_USB_SUSPEND;
> +
> +	ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC7,
> +					PCF50633_MBCC7_USB_MASK, bits);
> +	if (ret)
> +		dev_err(pcf->dev, "error setting usb curlim to %d mA\n", ma);
> +	else
> +		dev_info(pcf->dev, "usb curlim to %d mA\n", ma);
> +
> +	power_supply_changed(&pcf->mbc.usb);
> +}
> +EXPORT_SYMBOL_GPL(pcf50633_mbc_usb_curlim_set);
> +
> +static ssize_t
> +show_chgmode(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct pcf50633 *pcf = dev_get_drvdata(dev);
> +

Stray empty line.

> +	u8 mbcs2 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
> +	u8 chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
> +
> +	return sprintf(buf, "%d\n", chgmod);
> +}
> +static DEVICE_ATTR(chgmode, S_IRUGO, show_chgmode, NULL);
> +
> +static ssize_t
> +show_usblim(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct pcf50633 *pcf = dev_get_drvdata(dev);
> +	u8 usblim = pcf50633_reg_read(pcf, PCF50633_REG_MBCC7) &
> +						PCF50633_MBCC7_USB_MASK;
> +	unsigned int ma;
> +
> +	if (usblim == PCF50633_MBCC7_USB_1000mA)
> +		ma = 1000;
> +	else if (usblim == PCF50633_MBCC7_USB_500mA)
> +		ma = 500;
> +	else if (usblim == PCF50633_MBCC7_USB_100mA)
> +		ma = 100;
> +	else
> +		ma = 0;
> +
> +	return sprintf(buf, "%u\n", ma);
> +}
> +
> +static ssize_t set_usblim(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct pcf50633 *pcf = dev_get_drvdata(dev);
> +	unsigned long ma;
> +	int ret;
> +
> +	ret = strict_strtoul(buf, 10, &ma);
> +	if (ret)
> +		return -EINVAL;
> +
> +	pcf50633_mbc_usb_curlim_set(pcf, ma);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(usb_curlim, S_IRUGO | S_IWUSR, show_usblim, set_usblim);
> +
> +static struct attribute *pcf50633_mbc_sysfs_entries[] = {
> +	&dev_attr_chgmode.attr,
> +	&dev_attr_usb_curlim.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mbc_attr_group = {
> +	.name	= NULL,			/* put in device directory */
> +	.attrs	= pcf50633_mbc_sysfs_entries,
> +};
> +
> +static void
> +pcf50633_mbc_irq_handler(struct pcf50633 *pcf, int irq, void *unused)
> +{
> +	struct pcf50633_mbc *mbc;
> +
> +	mbc = &pcf->mbc;

struct pcf50633_mbc *mbc = &pcf->mbc; would save us two lines.

> +
> +	/* USB */
> +	if (irq == PCF50633_IRQ_USBINS) {
> +		mbc->usb_online = 1;
> +	} else if (irq == PCF50633_IRQ_USBREM) {
> +		mbc->usb_online = 0;
> +		mbc->usb_active = 0;
> +		pcf50633_mbc_usb_curlim_set(pcf, 0);
> +	}
> +
> +	/* Adapter */
> +	if (irq == PCF50633_IRQ_ADPINS) {
> +		pcf->mbc.adapter_online = 1;
> +		pcf->mbc.adapter_active = 1;
> +	} else if (irq == PCF50633_IRQ_ADPREM) {
> +		mbc->adapter_online = 0;
> +		mbc->adapter_active = 0;
> +	}
> +
> +	if (irq == PCF50633_IRQ_BATFULL) {
> +		mbc->usb_active = 0;
> +		mbc->adapter_active = 0;
> +	}
> +
> +	power_supply_changed(&mbc->usb);
> +	power_supply_changed(&mbc->adapter);
> +
> +	if (pcf->pdata->mbc_event_callback)
> +		pcf->pdata->mbc_event_callback(pcf, irq);
> +}
> +
> +static int adapter_get_property(struct power_supply *psy,
> +			enum power_supply_property psp,
> +			union power_supply_propval *val)
> +{
> +	int ret = 0;
> +	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		val->intval =  mbc->adapter_online;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int usb_get_property(struct power_supply *psy,
> +			enum power_supply_property psp,
> +			union power_supply_propval *val)
> +{
> +	int ret = 0;
> +	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		val->intval = mbc->usb_online;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static enum power_supply_property power_props[] = {
> +	POWER_SUPPLY_PROP_ONLINE,
> +};
> +
> +static const u8 mbc_irq_handlers[] = {
> +	PCF50633_IRQ_ADPINS,
> +	PCF50633_IRQ_ADPREM,
> +	PCF50633_IRQ_USBINS,
> +	PCF50633_IRQ_USBREM,
> +	PCF50633_IRQ_BATFULL,
> +	PCF50633_IRQ_CHGHALT,
> +	PCF50633_IRQ_THLIMON,
> +	PCF50633_IRQ_THLIMOFF,
> +	PCF50633_IRQ_USBLIMON,
> +	PCF50633_IRQ_USBLIMOFF,
> +	PCF50633_IRQ_LOWSYS,
> +	PCF50633_IRQ_LOWBAT,
> +};
> +
> +int __init pcf50633_mbc_probe(struct platform_device *pdev)
> +{
> +	struct pcf50633 *pcf;
> +	struct pcf50633_mbc *mbc;
> +	int ret, i;

int ret;
int i;

> +
> +	pcf = platform_get_drvdata(pdev);
> +	mbc = &pcf->mbc;

The two lines can be placed on the same lines with variables
definitions.

> +
> +	/* Set up IRQ handlers */
> +	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
> +		pcf->irq_handler[mbc_irq_handlers[i]] =
> +					pcf50633_mbc_irq_handler;

Ugh. Is there any particular reason why you don't implement a
chained interrupt controller in the PCF core? (as in
drivers/mfd/asic3.c, for example).

That way you could do ordinary request_irq() for the MFD devices'
interrupts.

(I can only guess: you didn't make it because PCF is on the
I2C bus, and it's just easier to handle devices via single
workqueue in the core driver?)

> +	/* Create power supplies */
> +	mbc->adapter.name		= "adapter";
> +	mbc->adapter.type		= POWER_SUPPLY_TYPE_MAINS;
> +	mbc->adapter.properties		= power_props;
> +	mbc->adapter.num_properties	= ARRAY_SIZE(power_props);
> +	mbc->adapter.get_property	= &adapter_get_property;
> +	mbc->adapter.supplied_to	= pcf->pdata->batteries;
> +	mbc->adapter.num_supplicants	= pcf->pdata->num_batteries;
> +
> +	mbc->usb.name			= "usb";
> +	mbc->usb.type			= POWER_SUPPLY_TYPE_USB;
> +	mbc->usb.properties		= power_props;
> +	mbc->usb.num_properties		= ARRAY_SIZE(power_props);
> +	mbc->usb.get_property		= usb_get_property;
> +	mbc->usb.supplied_to		= pcf->pdata->batteries;
> +	mbc->usb.num_supplicants	= pcf->pdata->num_batteries;
> +
> +	ret = power_supply_register(&pdev->dev, &mbc->adapter);
> +	if (ret)
> +		dev_err(pcf->dev, "failed to register adapter\n");
> +
> +	ret = power_supply_register(&pdev->dev, &mbc->usb);
> +	if (ret)
> +		dev_err(pcf->dev, "failed to register usb\n");
> +
> +	return sysfs_create_group(&pdev->dev.kobj, &mbc_attr_group);

If this fail we'll leak two registered power supplies...

> +}
> +
> +static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
> +{
> +	struct pcf50633 *pcf;
> +
> +	pcf = platform_get_drvdata(pdev);

This could be placed on a single line.

> +
> +	/* Remove IRQ handlers */
> +	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
> +		pcf->irq_handler[mbc_irq_handlers[i]] = NULL;
> +
> +	return 0;

The function doesn't handle power supplies unregistration?

> +}
> +
> +struct platform_driver pcf50633_mbc_driver = {
> +	.driver = {
> +		.name = "pcf50633-mbc",
> +	},
> +	.probe = pcf50633_mbc_probe,
> +	.remove = __devexit_p(pcf50633_mbc_remove),
> +};
> +
> +static int __init pcf50633_mbc_init(void)
> +{
> +		return platform_driver_register(&pcf50633_mbc_driver);

One tab is enough.

> +}
> +module_init(pcf50633_mbc_init);
> +
> +static void __exit pcf50633_mbc_exit(void)
> +{
> +		platform_driver_unregister(&pcf50633_mbc_driver);

Ditto.

> +}
> +module_exit(pcf50633_mbc_exit);
> +
> +MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
> +MODULE_DESCRIPTION("PCF50633 mbc driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:pcf50633-mbc");

Thanks again,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
