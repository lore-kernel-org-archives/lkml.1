Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZK3Spa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZK3Spa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZK3Sp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:45:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36160 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbZK3Sp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:45:26 -0500
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Grazvydas Ignotas'" <notasas@gmail.com>, <linux-kernel@vger.kernel.org>
Cc: "'Anton Vorontsov'" <avorontsov@ru.mvista.com>,
       <linux-omap@vger.kernel.org>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
Subject: RE: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
Date: Mon, 30 Nov 2009 12:45:20 -0600
Message-ID: <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1259333060-24277-1-git-send-email-notasas@gmail.com>
Thread-Index: AcpvcEW1JN6DwTG9RlGf19bPPMbHsACePncg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Grazvydas Ignotas [mailto:notasas@gmail.com]
> Sent: Friday, November 27, 2009 8:44 AM
> To: linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; Madhusudhan Chikkature; linux-omap@vger.kernel.org;
> Grazvydas Ignotas
> Subject: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
> 
> TWL4030/TPS65950 is a multi-function device with integrated charger,
> which allows charging from AC or USB. This driver enables the
> charger and provides several monitoring functions.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
> For this driver to work, TWL4030-core needs to be patched to use
> correct macros so that it registers twl4030_bci platform_device.
> I'll send patches for this later.
> 
>  drivers/power/Kconfig           |    7 +
>  drivers/power/Makefile          |    1 +
>  drivers/power/twl4030_charger.c |  499

Is the file name changed from twl4030_bci_battery.c to twl4030_charger.c because it mainly supports voltage monitoring only while charging? If yes, potentially we can add support for monitoring also in discharge state. Do we intend to change the file name then?

Also adding the tested-on info could be helpful here.

> +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 507 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/twl4030_charger.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index cea6cef..95d7e60 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -110,4 +110,11 @@ config CHARGER_PCF50633
>  	help
>  	 Say Y to include support for NXP PCF50633 Main Battery Charger.
> 
> +config CHARGER_TWL4030
> +	tristate "OMAP TWL4030 BCI charger driver"
> +	depends on TWL4030_CORE
> +	default y
> +	help
> +	  Say Y here to enable support for TWL4030 Battery Charge Interface.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index b96f29d..9cea9b5 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
>  obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
>  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
>  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
> +obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
> diff --git a/drivers/power/twl4030_charger.c
> b/drivers/power/twl4030_charger.c
> new file mode 100644
> index 0000000..604dd56
> --- /dev/null
> +++ b/drivers/power/twl4030_charger.c
> @@ -0,0 +1,499 @@
> +/*
> + * TWL4030/TPS65950 BCI (Battery Charger Interface) driver
> + *
> + * Copyright (C) 2009 GraÅ¾vydas Ignotas <notasas@gmail.com>
> + *
> + * based on twl4030_bci_battery.c by TI
> + * Copyright (C) 2008 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c/twl4030.h>
> +#include <linux/power_supply.h>
> +
> +#define REG_BCIMSTATEC		0x02
> +#define REG_BCIICHG		0x08
> +#define REG_BCIVAC		0x0a
> +#define REG_BCIVBUS		0x0c
> +#define REG_BCIMFSTS4		0x10
> +#define REG_BCICTL1		0x23
> +
> +#define REG_BOOT_BCI		0x07
> +#define REG_STS_HW_CONDITIONS	0x0f
> +
> +#define BCIAUTOWEN		0x20
> +#define CONFIG_DONE		0x10
> +#define CVENAC			0x04
> +#define BCIAUTOUSB		0x02
> +#define BCIAUTOAC		0x01
> +#define BCIMSTAT_MASK		0x3F
> +#define STS_VBUS		0x80
> +#define STS_CHG			0x02
> +#define STS_USB_ID		0x04
> +#define CGAIN			0x20
> +#define USBFASTMCHG		0x04
> +
> +#define STATEC_USB		0x10
> +#define STATEC_AC		0x20
> +#define STATEC_STATUS_MASK	0x0f
> +#define STATEC_QUICK1		0x02
> +#define STATEC_QUICK7		0x07
> +#define STATEC_COMPLETE1	0x0b
> +#define STATEC_COMPLETE4	0x0e
> +
> +#define BCI_DELAY		100
> +
> +struct twl4030_bci_device_info {
> +	struct power_supply	ac;
> +	struct power_supply	usb;
> +	struct delayed_work	bat_work;
> +	bool			started;
> +};
> +
> +/*
> + * clear and set bits on an given register on a given module
> + */
> +static int twl4030_clear_set(u8 mod_no, u8 clear, u8 set, u8 reg)
> +{
> +	u8 val = 0;
> +	int ret;
> +
> +	ret = twl4030_i2c_read_u8(mod_no, &val, reg);
> +	if (ret)
> +		return ret;
> +
> +	val &= ~clear;
> +	val |= set;
> +
> +	return twl4030_i2c_write_u8(mod_no, val, reg);
> +}
> +
> +static int twl4030bci_read_adc_val(u8 reg)
> +{
> +	int ret, temp;
> +	u8 val;
> +
> +	/* read MSB */
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, &val, reg +
> 1);
> +	if (ret)
> +		return ret;
> +
> +	temp = (int)(val & 0x03) << 8;
> +
> +	/* read LSB */
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, &val, reg);
> +	if (ret)
> +		return ret;
> +
> +	return temp | val;
> +}
> +
> +static void twl4030bci_power_work(struct work_struct *work)
> +{
> +	struct twl4030_bci_device_info *di = container_of(work,
> +		struct twl4030_bci_device_info, bat_work.work);
> +
> +	power_supply_changed(&di->ac);
> +	power_supply_changed(&di->usb);
> +}
> +
> +/*
> + * Attend to TWL4030 CHG_PRES (AC charger presence) events
> + */
> +static irqreturn_t twl4030_charger_interrupt(int irq, void *_di)
> +{
> +	struct twl4030_bci_device_info *di = _di;
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +	 * we don't want and can't tolerate.  Although it might be
> +	 * friendlier not to borrow this thread context...
> +	 */
> +	local_irq_enable();
> +#endif
> +
> +	schedule_delayed_work(&di->bat_work, msecs_to_jiffies(BCI_DELAY));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * Enable/Disable AC Charge funtionality.
> + */
> +static int twl4030_charger_enable_ac(bool enable)
> +{
> +	int ret;
> +
> +	if (enable) {
> +		/* forcing the field BCIAUTOAC (BOOT_BCI[0) to 1 */
> +		ret = twl4030_clear_set(TWL4030_MODULE_PM_MASTER, 0,
> +			CONFIG_DONE | BCIAUTOWEN | BCIAUTOAC,
> +			REG_BOOT_BCI);
> +	} else {
> +		/* forcing the field BCIAUTOAC (BOOT_BCI[0) to 0*/
> +		ret = twl4030_clear_set(TWL4030_MODULE_PM_MASTER, BCIAUTOAC,
> +			CONFIG_DONE | BCIAUTOWEN,
> +			REG_BOOT_BCI);
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Check if VBUS power is present
> + */
> +static int twl4030_charger_check_vbus(void)
> +{
> +	int ret;
> +	u8 hwsts;
> +
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &hwsts,
> +		REG_STS_HW_CONDITIONS);
> +	if (ret) {
> +		pr_err("twl4030_bci: error reading STS_HW_CONDITIONS\n");
> +		return ret;
> +	}
> +
> +	pr_debug("check_vbus: HW_CONDITIONS %02x\n", hwsts);
> +
> +	/* in case we also have STS_USB_ID, VBUS is driven by TWL itself */
> +	if ((hwsts & STS_VBUS) && !(hwsts & STS_USB_ID))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * Enable/Disable USB Charge funtionality.
> + */
> +static int twl4030_charger_enable_usb(bool enable)
> +{
> +	int ret;
> +
> +	if (enable) {
> +		/* Check for USB charger conneted */
> +		ret = twl4030_charger_check_vbus();
> +		if (ret < 0)
> +			return ret;
> +
> +		if (!ret)
> +			return -ENXIO;
> +
> +		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
> +		ret = twl4030_clear_set(TWL4030_MODULE_PM_MASTER, 0,
> +			CONFIG_DONE | BCIAUTOWEN | BCIAUTOUSB,
> +			REG_BOOT_BCI);
> +		if (ret)
> +			return ret;
> +
> +		/* forcing USBFASTMCHG(BCIMFSTS4[2]) to 1 */
> +		ret = twl4030_clear_set(TWL4030_MODULE_MAIN_CHARGE, 0,
> +			USBFASTMCHG, REG_BCIMFSTS4);
> +	} else {
> +		ret = twl4030_clear_set(TWL4030_MODULE_PM_MASTER, BCIAUTOUSB,
> +			CONFIG_DONE | BCIAUTOWEN, REG_BOOT_BCI);
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Return voltage (valid while charging only)
> + * 10 bit ADC (0...0x3ff) scales to 0...6V
> + */
> +static int twl4030_get_voltage(int reg)
> +{
> +	int ret = twl4030bci_read_adc_val(reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 6000 * ret / 1023;
> +}
> +
> +/*
> + * TI provided formulas:
> + * CGAIN == 0: ICHG = (BCIICHG * 1.7) / (2^10 â€“ 1) - 0.85
> + * CGAIN == 1: ICHG = (BCIICHG * 3.4) / (2^10 â€“ 1) - 1.7
> + * Here we use integer approximation of:
> + * CGAIN == 0: val * 1.6618 - 0.85
> + * CGAIN == 1: (val * 1.6618 - 0.85) * 2
> + */
> +static int twl4030_charger_get_current(void)
> +{
> +	int curr;
> +	int ret;
> +	u8 bcictl1;
> +
> +	curr = twl4030bci_read_adc_val(REG_BCIICHG);
> +	if (curr < 0)
> +		return curr;
> +
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, &bcictl1,
> +		REG_BCICTL1);
> +	if (ret)
> +		return ret;
> +
> +	ret = (curr * 16618 - 850 * 10000) / 10000;
> +	if (bcictl1 & CGAIN)
> +		ret *= 2;
> +
> +	return ret;
> +}
> +
> +/*
> + * Returns the main charge FSM state
> + * Or < 0 on failure.
> + */
> +static int twl4030bci_state(void)
> +{
> +	int ret;
> +	u8 state;
> +
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
> +		&state, REG_BCIMSTATEC);
> +	if (ret) {
> +		pr_err("twl4030_bci: error reading BCIMSTATEC\n");
> +		return ret;
> +	}
> +
> +	pr_debug("state: %02x\n", state);
> +
> +	return state & BCIMSTAT_MASK;
> +}
> +
> +static int twl4030_bci_state_to_status(int state)
> +{
> +	state &= STATEC_STATUS_MASK;
> +	if (STATEC_QUICK1 <= state && state <= STATEC_QUICK7)
> +		return POWER_SUPPLY_STATUS_CHARGING;
> +	else if (STATEC_COMPLETE1 <= state && state <= STATEC_COMPLETE4)
> +		return POWER_SUPPLY_STATUS_FULL;
> +	else
> +		return POWER_SUPPLY_STATUS_NOT_CHARGING;
> +}
> +
> +static int twl4030_charger_get_property(struct power_supply *psy,
> +					enum power_supply_property psp,
> +					union power_supply_propval *val)
> +{
> +	int is_charging;
> +	int voltage_reg;
> +	int state;
> +	int ret;
> +
> +	state = twl4030bci_state();
> +	if (state < 0)
> +		return state;
> +
> +	if (psy->type == POWER_SUPPLY_TYPE_USB) {
> +		is_charging = state & STATEC_USB;
> +		voltage_reg = REG_BCIVBUS;
> +	} else {
> +		is_charging = state & STATEC_AC;
> +		voltage_reg = REG_BCIVAC;
> +	}
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_STATUS:
> +		if (is_charging)
> +			val->intval = twl4030_bci_state_to_status(state);
> +		else
> +			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		/* charging must be active for meaningful result */
> +		if (!is_charging) {

How about putting a kern_info here?

> +			val->intval = 0;
> +			break;
> +		}
> +		ret = twl4030_get_voltage(voltage_reg);
> +		if (ret < 0)
> +			return ret;
> +		val->intval = ret;
> +		break;
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +		if (!is_charging) {
> +			val->intval = 0;
Ditto
> +			break;
> +		}
> +		/* current measurement is shared between AC and USB */
> +		ret = twl4030_charger_get_current();
> +		if (ret < 0)
> +			return ret;
> +		val->intval = ret;
> +		break;
> +	case POWER_SUPPLY_PROP_ONLINE:
Does this indicate the source of charging like USB or AC??
> +		val->intval = is_charging &&
> +			twl4030_bci_state_to_status(state) !=
> +				POWER_SUPPLY_STATUS_NOT_CHARGING;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static enum power_supply_property twl4030_charger_props[] = {
> +	POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_ONLINE,
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> +};
> +
> +static struct twl4030_bci_device_info twl4030_bci = {
> +	.ac = {
> +		.name		= "twl4030_ac",
> +		.type		= POWER_SUPPLY_TYPE_MAINS,
> +		.properties	= twl4030_charger_props,
> +		.num_properties = ARRAY_SIZE(twl4030_charger_props),
> +		.get_property	= twl4030_charger_get_property,
> +	},
> +	.usb = {
> +		.name		= "twl4030_usb",
> +		.type		= POWER_SUPPLY_TYPE_USB,
> +		.properties	= twl4030_charger_props,
> +		.num_properties = ARRAY_SIZE(twl4030_charger_props),
> +		.get_property	= twl4030_charger_get_property,
> +	},
> +};
> +
> +/*
> + * called by TWL4030 USB transceiver driver on USB_PRES interrupt.
> + */
> +int twl4030charger_usb_en(int enable)
> +{
> +	if (twl4030_bci.started)
> +		schedule_delayed_work(&twl4030_bci.bat_work,
> +			msecs_to_jiffies(BCI_DELAY));
> +
> +	return twl4030_charger_enable_usb(enable);
> +}
> +
> +static int __devinit twl4030_bci_probe(struct platform_device *pdev)
> +{
> +	int irq;
> +	int ret;
> +
> +	twl4030_charger_enable_ac(true);
> +	twl4030_charger_enable_usb(true);
> +
> +	irq = platform_get_irq(pdev, 0);
> +
> +	/* CHG_PRES irq */
> +	ret = request_irq(irq, twl4030_charger_interrupt,
> +		0, pdev->name, &twl4030_bci);
> +	if (ret) {
> +		dev_err(&pdev->dev, "could not request irq %d, status %d\n",
> +			irq, ret);
> +		goto fail_chg_irq;
> +	}
> +
> +	ret = power_supply_register(&pdev->dev, &twl4030_bci.ac);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register ac: %d\n", ret);
> +		goto fail_register_ac;
> +	}
> +
> +	ret = power_supply_register(&pdev->dev, &twl4030_bci.usb);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register usb: %d\n", ret);
> +		goto fail_register_usb;
> +	}
> +
> +	platform_set_drvdata(pdev, &twl4030_bci);
> +
> +	INIT_DELAYED_WORK_DEFERRABLE(&twl4030_bci.bat_work,
> +			twl4030bci_power_work);
> +	schedule_delayed_work(&twl4030_bci.bat_work,
> +			msecs_to_jiffies(BCI_DELAY));
> +	twl4030_bci.started = true;
> +
> +	return 0;
> +
> +fail_register_usb:
> +	power_supply_unregister(&twl4030_bci.ac);
> +fail_register_ac:
> +	free_irq(irq, &twl4030_bci);
> +fail_chg_irq:
> +	twl4030_charger_enable_ac(false);
> +	twl4030_charger_enable_usb(false);
> +
> +	return ret;
> +}
> +
> +static int __devexit twl4030_bci_remove(struct platform_device *pdev)
> +{
> +	struct twl4030_bci_device_info *di = platform_get_drvdata(pdev);
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	di->started = false;
> +	twl4030_charger_enable_ac(false);
> +	twl4030_charger_enable_usb(false);
> +
> +	free_irq(irq, di);
> +
> +	flush_scheduled_work();
> +	power_supply_unregister(&di->ac);
> +	power_supply_unregister(&di->usb);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int twl4030_bci_suspend(struct platform_device *pdev,
> +	pm_message_t state)
> +{
> +	/* flush all pending status updates */
> +	flush_scheduled_work();
> +	return 0;
> +}
> +
> +static int twl4030_bci_resume(struct platform_device *pdev)
> +{
> +	struct twl4030_bci_device_info *di = platform_get_drvdata(pdev);
> +
> +	/* things may have changed while we were away */
> +	schedule_delayed_work(&di->bat_work, msecs_to_jiffies(BCI_DELAY));
> +	return 0;
> +}
> +#else
> +#define twl4030_bci_suspend	NULL
> +#define twl4030_bci_resume	NULL
> +#endif /* CONFIG_PM */
> +
> +static struct platform_driver twl4030_bci_driver = {
> +	.probe		= twl4030_bci_probe,
> +	.remove		= __devexit_p(twl4030_bci_remove),
> +	.suspend	= twl4030_bci_suspend,
> +	.resume		= twl4030_bci_resume,
> +	.driver		= {
> +		.name	= "twl4030_bci",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init twl4030_bci_init(void)
> +{
> +	return platform_driver_register(&twl4030_bci_driver);
> +}
> +module_init(twl4030_bci_init);
> +
> +static void __exit twl4030_bci_exit(void)
> +{
> +	platform_driver_unregister(&twl4030_bci_driver);
> +}
> +module_exit(twl4030_bci_exit);
> +
> +MODULE_AUTHOR("GraÅ¾vydas Ignotas");
> +MODULE_DESCRIPTION("TWL4030 Battery Charger Interface driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:twl4030_bci");
> --
> 1.6.3.3


