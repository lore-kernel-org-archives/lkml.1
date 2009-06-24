Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZFXON1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZFXON1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFXONT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:13:19 -0400
Received: from ru.mvista.com ([213.79.90.228]:5361 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752077AbZFXONS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:13:18 -0400
Date: Wed, 24 Jun 2009 18:12:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, jtester@gmail.com
Subject: Re: [PATCH] ds2782 battery gas gauge driver
Message-ID: <20090624141214.GA8269@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4A371CDF.3070407@bluewatersys.com> <20090617110908.17b47a18@hyperion.delvare> <4A397BA2.9030702@bluewatersys.com> <4A416B58.8020902@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <4A416B58.8020902@bluewatersys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:55:04AM +1200, Ryan Mallon wrote:
> Ryan Mallon wrote:
> >
> > Updated patch below.
> >
> >   
> Any further comments on this? I got an IP blocked bounce on Anton's
> cbou@mail.ru, so have CC'ed his other address here.

The driver looks OK (modulo some cosmetic issues, but don't
worry, I'll fix them myself).

I'm about to send a pull request for battery tree, so I'll
apply the patch after that (targeting 2.6.31, of course).

Thanks for the driver!

> > ---
> > Add support for the DS2782 stand-alone I2C gas-gauge
> >
> > Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> > ---
> >
> > diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> > index 33da112..b9c818f 100644
> > --- a/drivers/power/Kconfig
> > +++ b/drivers/power/Kconfig
> > @@ -43,6 +43,13 @@ config BATTERY_DS2760
> >  	help
> >  	  Say Y here to enable support for batteries with ds2760 chip.
> >  
> > +config BATTERY_DS2782
> > +	tristate "DS2782 standalone gas-gauge"
> > +	depends on I2C
> > +	help
> > +	  Say Y here to enable support for the DS2782 standalone battery
> > +	  gas-gauge.
> > +
> >  config BATTERY_PMU
> >  	tristate "Apple PMU battery"
> >  	depends on PPC32 && ADB_PMU
> > diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> > index 2fcf41d..ad1ac61 100644
> > --- a/drivers/power/Makefile
> > +++ b/drivers/power/Makefile
> > @@ -19,6 +19,7 @@ obj-$(CONFIG_APM_POWER)		+= apm_power.o
> >  obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
> >  
> >  obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
> > +obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
> >  obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
> >  obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
> >  obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
> > diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> > new file mode 100644
> > index 0000000..cfd4d28
> > --- /dev/null
> > +++ b/drivers/power/ds2782_battery.c
> > @@ -0,0 +1,321 @@
> > +/*
> > + * drivers/power/ds2782_battery.c
> > + *
> > + * I2C client/driver for the Maxim/Dallas DS2782 Stand-Alone Fuel Gauge IC
> > + *
> > + * Copyright (C) 2009 Bluewater Systems Ltd
> > + * Author: Ryan Mallon <ryan@bluewatersys.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/idr.h>
> > +#include <linux/power_supply.h>
> > +
> > +#define DS2782_REG_RARC		0x06	/* Remaining active relative capacity */
> > +
> > +#define DS2782_REG_VOLT_MSB	0x0c
> > +#define DS2782_REG_TEMP_MSB	0x0a
> > +#define DS2782_REG_CURRENT_MSB	0x0e
> > +
> > +/* EEPROM Block */
> > +#define DS2782_REG_RSNSP	0x69	/* Sense resistor value */
> > +
> > +/* Current unit measurement in uA for a 1 milli-ohm sense resistor */
> > +#define DS2782_CURRENT_UNITS	1563
> > +
> > +#define to_ds2782_info(x) container_of(x, struct ds2782_info, battery)
> > +
> > +struct ds2782_info {
> > +	struct i2c_client	*client;
> > +	struct power_supply	battery;
> > +	int			id;
> > +};
> > +
> > +static DEFINE_IDR(battery_id);
> > +static DEFINE_MUTEX(battery_lock);
> > +
> > +static inline int ds2782_read_reg(struct ds2782_info *info, int reg, u8 *val)
> > +{
> > +	int ret = i2c_smbus_read_byte_data(info->client, reg);
> > +	if (ret < 0) {
> > +		dev_err(&info->client->dev, "register read failed\n");
> > +		return ret;
> > +	}
> > +
> > +	*val = ret;
> > +	return 0;
> > +}
> > +
> > +static inline int ds2782_read_reg16(struct ds2782_info *info, int reg_msb,
> > +				    s16 *val)
> > +{
> > +	int ret = swab16(i2c_smbus_read_word_data(info->client, reg_msb));
> > +	if (ret < 0) {
> > +		dev_err(&info->client->dev, "register read failed\n");
> > +		return ret;
> > +	}
> > +
> > +	*val = ret;
> > +	return 0;
> > +}
> > +
> > +static int ds2782_get_temp(struct ds2782_info *info, int *temp)
> > +{
> > +	s16 raw;
> > +	int err;
> > +
> > +	/*
> > +	 * Temperature is measured in units of 0.125 degrees celcius, the
> > +	 * power_supply class measures temperature in tenths of degrees
> > +	 * celsius. The temperature value is stored as a 10 bit number, plus
> > +	 * sign in the upper bits of a 16 bit register.
> > +	 */
> > +	err = ds2782_read_reg16(info, DS2782_REG_TEMP_MSB, &raw);
> > +	if (err)
> > +		return err;
> > +	*temp = ((raw / 32) * 125) / 100;
> > +	return 0;
> > +}
> > +
> > +static int ds2782_get_current(struct ds2782_info *info, int *current_uA)
> > +{
> > +	int sense_res, err;
> > +	u8 sense_res_raw;
> > +	s16 raw;
> > +
> > +	/*
> > +	 * The units of measurement for current are dependent on the value of
> > +	 * the sense resistor.
> > +	 */
> > +	err = ds2782_read_reg(info, DS2782_REG_RSNSP, &sense_res_raw);
> > +	if (err)
> > +		return err;
> > +	if (sense_res_raw == 0) {
> > +		dev_err(&info->client->dev, "sense resistor value is 0\n");
> > +		return -ENXIO;
> > +	}
> > +	sense_res = 1000 / sense_res_raw;
> > +
> > +	dev_dbg(&info->client->dev, "sense resistor = %d milli-ohms\n",
> > +		sense_res);
> > +	err = ds2782_read_reg16(info, DS2782_REG_CURRENT_MSB, &raw);
> > +	if (err)
> > +		return err;
> > +	*current_uA = raw * (DS2782_CURRENT_UNITS / sense_res);
> > +	return 0;
> > +}
> > +
> > +static int ds2782_get_voltage(struct ds2782_info *info, int *voltage_uA)
> > +{
> > +	s16 raw;
> > +	int err;
> > +
> > +	/*
> > +	 * Voltage is measured in units of 4.88mV. The voltage is stored as
> > +	 * a 10-bit number plus sign, in the upper bits of a 16-bit register
> > +	 */
> > +	err = ds2782_read_reg16(info, DS2782_REG_VOLT_MSB, &raw);
> > +	if (err)
> > +		return err;
> > +	*voltage_uA = (raw / 32) * 4800;
> > +	return 0;
> > +}
> > +
> > +static int ds2782_get_capacity(struct ds2782_info *info, int *capacity)
> > +{
> > +	int err;
> > +	u8 raw;
> > +
> > +	err = ds2782_read_reg(info, DS2782_REG_RARC, &raw);
> > +	if (err)
> > +		return err;
> > +	*capacity = raw;
> > +	return raw;
> > +}
> > +
> > +static int ds2782_get_status(struct ds2782_info *info, int *status)
> > +{
> > +	int err, current_uA, capacity;
> > +
> > +	err = ds2782_get_current(info, &current_uA);
> > +	if (err)
> > +		return err;
> > +
> > +	err = ds2782_get_capacity(info, &capacity);
> > +	if (err)
> > +		return err;
> > +
> > +	if (capacity == 100)
> > +		*status = POWER_SUPPLY_STATUS_FULL;
> > +	else if (current_uA == 0)
> > +		*status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> > +	else if (current_uA < 0)
> > +		*status = POWER_SUPPLY_STATUS_DISCHARGING;
> > +	else
> > +		*status = POWER_SUPPLY_STATUS_CHARGING;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ds2782_battery_get_property(struct power_supply *psy,
> > +				       enum power_supply_property prop,
> > +				       union power_supply_propval *val)
> > +{
> > +	struct ds2782_info *info = to_ds2782_info(psy);
> > +	int ret;
> > +
> > +	switch (prop) {
> > +	case POWER_SUPPLY_PROP_STATUS:
> > +		ret = ds2782_get_status(info, &val->intval);
> > +		break;
> > +
> > +	case POWER_SUPPLY_PROP_CAPACITY:
> > +		ret = ds2782_get_capacity(info, &val->intval);
> > +		break;
> > +
> > +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> > +		ret = ds2782_get_voltage(info, &val->intval);
> > +		break;
> > +
> > +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> > +		ret = ds2782_get_current(info, &val->intval);
> > +		break;
> > +
> > +	case POWER_SUPPLY_PROP_TEMP:
> > +		ret = ds2782_get_temp(info, &val->intval);
> > +		break;
> > +
> > +	default:
> > +		ret = -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static enum power_supply_property ds2782_battery_props[] = {
> > +	POWER_SUPPLY_PROP_STATUS,
> > +	POWER_SUPPLY_PROP_CAPACITY,
> > +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> > +	POWER_SUPPLY_PROP_CURRENT_NOW,
> > +	POWER_SUPPLY_PROP_TEMP,
> > +};
> > +
> > +static void ds2782_power_supply_init(struct power_supply *battery)
> > +{
> > +	battery->type			= POWER_SUPPLY_TYPE_BATTERY;
> > +	battery->properties		= ds2782_battery_props;
> > +	battery->num_properties		= ARRAY_SIZE(ds2782_battery_props);
> > +	battery->get_property		= ds2782_battery_get_property;
> > +	battery->external_power_changed	= NULL;
> > +}
> > +
> > +static int ds2782_battery_remove(struct i2c_client *client)
> > +{
> > +	struct ds2782_info *info = i2c_get_clientdata(client);
> > +
> > +	power_supply_unregister(&info->battery);
> > +	kfree(info->battery.name);
> > +
> > +	mutex_lock(&battery_lock);
> > +	idr_remove(&battery_id, info->id);
> > +	mutex_unlock(&battery_lock);
> > +
> > +	i2c_set_clientdata(client, info);
> > +
> > +	kfree(info);
> > +	return 0;
> > +}
> > +
> > +static int ds2782_battery_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *id)
> > +{
> > +	struct ds2782_info *info;
> > +	int ret, num;
> > +
> > +	/* Get an ID for this battery */
> > +	ret = idr_pre_get(&battery_id, GFP_KERNEL);
> > +	if (ret == 0) {
> > +		ret = -ENOMEM;
> > +		goto fail_id;
> > +	}
> > +
> > +	mutex_lock(&battery_lock);
> > +	ret = idr_get_new(&battery_id, client, &num);
> > +	mutex_unlock(&battery_lock);
> > +	if (ret < 0)
> > +		goto fail_id;
> > +
> > +	info = kzalloc(sizeof(struct ds2782_info), GFP_KERNEL);
> > +	if (!info) {
> > +		ret = -ENOMEM;
> > +		goto fail_info;
> > +	}
> > +
> > +	info->battery.name = kasprintf(GFP_KERNEL, "ds2782-%d", num);
> > +	if (!info->battery.name) {
> > +		ret = -ENOMEM;
> > +		goto fail_name;
> > +	}
> > +
> > +	i2c_set_clientdata(client, info);
> > +	info->client = client;
> > +	ds2782_power_supply_init(&info->battery);
> > +
> > +	ret = power_supply_register(&client->dev, &info->battery);
> > +	if (ret) {
> > +		dev_err(&client->dev, "failed to register battery\n");
> > +		goto fail_register;
> > +	}
> > +
> > +	return 0;
> > +
> > +fail_register:
> > +	kfree(info->battery.name);
> > +fail_name:
> > +	i2c_set_clientdata(client, info);
> > +	kfree(info);
> > +fail_info:
> > +	mutex_lock(&battery_lock);
> > +	idr_remove(&battery_id, num);
> > +	mutex_unlock(&battery_lock);
> > +fail_id:
> > +	return ret;
> > +}
> > +
> > +static const struct i2c_device_id ds2782_id[] = {
> > +	{"ds2782", 0},
> > +	{},
> > +};
> > +
> > +static struct i2c_driver ds2782_battery_driver = {
> > +	.driver 	= {
> > +		.name	= "ds2782-battery",
> > +	},
> > +	.probe		= ds2782_battery_probe,
> > +	.remove		= ds2782_battery_remove,
> > +	.id_table	= ds2782_id,
> > +};
> > +
> > +static int __init ds2782_init(void)
> > +{
> > +	return i2c_add_driver(&ds2782_battery_driver);
> > +}
> > +
> > +static void __exit ds2782_exit(void)
> > +{
> > +	i2c_del_driver(&ds2782_battery_driver);
> > +}
> > +
> > +module_init(ds2782_init);
> > +module_exit(ds2782_exit);
> > +
> > +MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
> > +MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
> > +MODULE_LICENSE("GPL");
> >
> >
> >   

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
