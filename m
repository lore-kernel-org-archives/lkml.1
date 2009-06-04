Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZFDJQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZFDJQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZFDJQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:16:47 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:43649 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZFDJQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p/K8bYpXbV/bkYAaXD2zNV1CBJJX4x2/oQaS/J683kC2FrPdmtO+MqyfoU2l0tfPkn
         dKPO6xEghmd289nmkHI25kfCVpF751B4K58Nn9nFd526sXJuF++gSVbaju47EifsVD3W
         oQ/PW8++//GO3S0HDJeLFDktd0B0BezhUYhL0=
MIME-Version: 1.0
In-Reply-To: <4A278C08.5000206@samsung.com>
References: <4A278C08.5000206@samsung.com>
Date: Thu, 4 Jun 2009 14:46:45 +0530
Message-ID: <5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       kyungmin.park@samsung.com, Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minkyu Kang,

Adding linux-i2c mailing list, so not deleting any code.

On Thu, Jun 4, 2009 at 2:25 PM, Minkyu Kang <mk7.kang@samsung.com> wrote:
> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
> This patch adds support the MAX17040 Fuel Gauge
>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> ---
>  drivers/power/Kconfig            |    8 +
>  drivers/power/Makefile           |    3 +-
>  drivers/power/max17040_battery.c |  306 ++++++++++++++++++++++++++++++++++++++
>  include/linux/max17040_battery.h |   19 +++
>  4 files changed, 335 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/power/max17040_battery.c
>  create mode 100644 include/linux/max17040_battery.h
>
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 33da112..6af5798 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -88,4 +88,12 @@ config CHARGER_PCF50633
>        help
>         Say Y to include support for NXP PCF50633 Main Battery Charger.
>
> +config BATTERY_MAX17040
> +       tristate "Maxim MAX17040 Fuel Gauge"
> +       depends on I2C
> +       help
> +         MAX17040 is fuel-gauge systems for lithium-ion (Li+) batteries
> +         in handheld and portable equipment. The MAX17040 is configured
> +         to operate with a single lithium cell
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 2fcf41d..9c48995 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)    += tosa_battery.o
>  obj-$(CONFIG_BATTERY_WM97XX)   += wm97xx_battery.o
>  obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
>  obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
> -obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
> \ No newline at end of file
> +obj-$(CONFIG_BATTERY_MAX17040))        += max17040_battery.o
> +obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
> diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
> new file mode 100644
> index 0000000..25303ba
> --- /dev/null
> +++ b/drivers/power/max17040_battery.c
> @@ -0,0 +1,306 @@
> +/*
> + *  max17040_battery.c
> + *  fuel-gauge systems for lithium-ion (Li+) batteries
> + *
> + *  Copyright (C) 2009 Samsung Electronics
> + *  Minkyu Kang <mk7.kang@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/power_supply.h>
> +#include <linux/max17040_battery.h>
> +
> +#define MAX17040_VCELL_MSB     0x02
> +#define MAX17040_VCELL_LSB     0x03
> +#define MAX17040_SOC_MSB       0x04
> +#define MAX17040_SOC_LSB       0x05
> +#define MAX17040_MODE_MSB      0x06
> +#define MAX17040_MODE_LSB      0x07
> +#define MAX17040_VER_MSB       0x08
> +#define MAX17040_VER_LSB       0x09
> +#define MAX17040_RCOMP_MSB     0x0C
> +#define MAX17040_RCOMP_LSB     0x0D
> +#define MAX17040_CMD_MSB       0xFE
> +#define MAX17040_CMD_LSB       0xFF
> +
> +#define MAX17040_DELAY         1000
> +#define MAX17040_BATTERY_FULL  95
> +
> +struct max17040_chip {
> +       struct i2c_client       *client;
> +       struct delayed_work     work;
> +
> +       /* State Of Connect */
> +       int online;
> +       /* battery voltage */
> +       int vcell;
> +       /* battery capacity */
> +       int soc;
> +       /* State Of Charge */
> +       int status;
> +};
> +
> +static struct max17040_chip *max17040;
> +static struct max17040_platform_data *pdata;

May be you want to move this pdata under chip structure.

> +
> +static int max17040_get_property(struct power_supply *bat_ps,
> +                           enum power_supply_property psp,
> +                           union power_supply_propval *val)
> +{
> +       switch (psp) {
> +       case POWER_SUPPLY_PROP_STATUS:
> +               val->intval = max17040->status;
> +               break;
> +       case POWER_SUPPLY_PROP_ONLINE:
> +               val->intval = max17040->online;
> +               break;
> +       case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +               val->intval = max17040->vcell;
> +               break;
> +       case POWER_SUPPLY_PROP_CAPACITY:
> +               val->intval = max17040->soc;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static struct power_supply bat_ps = {
> +       .name           = "battery",
> +       .type           = POWER_SUPPLY_TYPE_BATTERY,
> +       .get_property   = max17040_get_property,
> +};
> +
> +static int max17040_write_reg(int reg, u8 value)
> +{
> +       int ret;
> +
> +       ret = i2c_smbus_write_byte_data(max17040->client, reg, value);
> +
> +       if (ret < 0) {
> +               dev_err(&max17040->client->dev,
> +                               "%s: reg 0x%x, val 0x%x, err %d\n",
> +                               __func__, reg, value, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static u8 max17040_read_reg(int reg)
> +{
> +       int ret;
> +
> +       ret = i2c_smbus_read_byte_data(max17040->client, reg);
> +
> +       if (ret < 0) {
> +               dev_err(&max17040->client->dev,
> +                               "%s: reg 0x%x, err %d\n",
> +                               __func__, reg, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static void max17040_reset(void)
> +{
> +       max17040_write_reg(MAX17040_CMD_MSB, 0x54);
> +       max17040_write_reg(MAX17040_CMD_LSB, 0x00);
> +}
> +
> +static void max17040_set_rcomp(u16 val)
> +{
> +       max17040_write_reg(MAX17040_RCOMP_MSB, val >> 8);
> +       max17040_write_reg(MAX17040_RCOMP_LSB, (val << 8) >> 8);
> +}
> +
> +static void max17040_get_vcell(void)
> +{
> +       u8 msb;
> +       u8 lsb;
> +
> +       msb = max17040_read_reg(MAX17040_VCELL_MSB);
> +       lsb = max17040_read_reg(MAX17040_VCELL_LSB);
> +
> +       max17040->vcell = (msb << 4) + (lsb >> 4);
> +}
> +
> +static void max17040_get_soc(void)
> +{
> +       u8 msb;
> +       u8 lsb;
> +
> +       msb = max17040_read_reg(MAX17040_SOC_MSB);
> +       lsb = max17040_read_reg(MAX17040_SOC_LSB);
> +
> +       max17040->soc = msb;
> +}
> +
> +static void max17040_get_version(void)
> +{
> +       u8 msb;
> +       u8 lsb;
> +
> +       msb = max17040_read_reg(MAX17040_VER_MSB);
> +       lsb = max17040_read_reg(MAX17040_VER_LSB);
> +
> +       dev_info(&max17040->client->dev,
> +                       "MAX17040 Fuel-Gauge Ver %d%d\n", msb, lsb);
> +}
> +
> +static void max17040_get_online(void)
> +{
> +       if (pdata->battery_online)
> +               max17040->online = pdata->battery_online();
> +       else
> +               max17040->online = 1;
> +}
> +
> +static void max17040_get_status(void)
> +{
> +       if (!pdata->charger_online || !pdata->charger_enable) {
> +               max17040->status = POWER_SUPPLY_STATUS_UNKNOWN;
> +               return;
> +       }
> +
> +       if (pdata->charger_online()) {
> +               if (pdata->charger_enable())
> +                       max17040->status = POWER_SUPPLY_STATUS_CHARGING;
> +               else
> +                       max17040->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +       } else {
> +               max17040->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +       }
> +
> +       if (max17040->soc > MAX17040_BATTERY_FULL)
> +               max17040->status = POWER_SUPPLY_STATUS_FULL;
> +}
> +
> +static void max17040_work(struct work_struct *work)
> +{
> +       max17040_get_vcell();
> +       max17040_get_soc();
> +       max17040_get_online();
> +       max17040_get_status();
> +
> +       schedule_delayed_work(&max17040->work, MAX17040_DELAY);
> +}
> +
> +static enum power_supply_property max17040_battery_props[] = {
> +       POWER_SUPPLY_PROP_STATUS,
> +       POWER_SUPPLY_PROP_ONLINE,
> +       POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +       POWER_SUPPLY_PROP_CAPACITY,
> +};
> +
> +static int __devinit max17040_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       struct max17040_chip *chip;
> +       int ret;
> +
> +       chip = kzalloc(sizeof(struct max17040_chip), GFP_KERNEL);
> +       if (!chip)
> +               return -ENOMEM;
> +
> +       chip->client = client;
> +       pdata = client->dev.platform_data;
> +
> +       i2c_set_clientdata(client, chip);

Please add i2c_check_functionality check before doing any smbus
read/write operations.

> +       max17040 = chip;

This means that we support only one instance of this chip, right?

> +
> +       max17040_reset();
> +
> +       max17040_get_version();
> +
> +       INIT_DELAYED_WORK_DEFERRABLE(&chip->work, max17040_work);
> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +
> +       bat_ps.properties = max17040_battery_props;
> +       bat_ps.num_properties = ARRAY_SIZE(max17040_battery_props);
> +
> +       ret = power_supply_register(&client->dev, &bat_ps);
> +       if (ret) {
> +               dev_err(&max17040->client->dev,
> +                               "failed: power supply register\n");
> +               cancel_delayed_work(&chip->work);
> +               i2c_set_clientdata(client, NULL);
> +               kfree(chip);
> +               max17040 = NULL;
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int __devexit max17040_remove(struct i2c_client *client)
> +{
> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +       power_supply_unregister(&bat_ps);
> +       cancel_delayed_work(&chip->work);
> +       i2c_set_clientdata(client, NULL);
> +       kfree(chip);
> +       max17040 = NULL;
> +       return 0;
> +}
> +
> +static int max17040_suspend(struct i2c_client *client,
> +               pm_message_t state)
> +{
> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +       cancel_delayed_work(&chip->work);
> +       return 0;
> +}
> +
> +static int max17040_resume(struct i2c_client *client)
> +{
> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +       return 0;
> +}
> +
> +static const struct i2c_device_id max17040_id[] = {
> +       { "max17040", 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(i2c, max17040_id);
> +
> +static struct i2c_driver max17040_i2c_driver = {
> +       .driver = {
> +               .name   = "max17040",
> +       },
> +       .probe          = max17040_probe,
> +       .remove         = __devexit_p(max17040_remove),
> +       .suspend        = max17040_suspend,
> +       .resume         = max17040_resume,
> +       .id_table       = max17040_id,
> +};
> +
> +static int __init max17040_init(void)
> +{
> +       return i2c_add_driver(&max17040_i2c_driver);
> +}
> +module_init(max17040_init);
> +
> +static void __exit max17040_exit(void)
> +{
> +       i2c_del_driver(&max17040_i2c_driver);
> +}
> +module_exit(max17040_exit);
> +
> +MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
> +MODULE_DESCRIPTION("MAX17040 Fuel Gauge");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/max17040_battery.h b/include/linux/max17040_battery.h
> new file mode 100644
> index 0000000..ad97b06
> --- /dev/null
> +++ b/include/linux/max17040_battery.h
> @@ -0,0 +1,19 @@
> +/*
> + *  Copyright (C) 2009 Samsung Electronics
> + *  Minkyu Kang <mk7.kang@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAX17040_BATTERY_H_
> +#define __MAX17040_BATTERY_H_
> +
> +struct max17040_platform_data {
> +       int (*battery_online)(void);
> +       int (*charger_online)(void);
> +       int (*charger_enable)(void);
> +};
> +
> +#endif
> --
> 1.5.4.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
