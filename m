Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZJLS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZJLS5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZJLS5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:57:34 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:48902 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbZJLS5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nomeEPvDn9BOWJ8hbQj969VNR2iqUcqdy2mFpljrt/LYRkjIf9PX0eauOpoqSsb8Sl
         K79LVF87JL+T8Fzom8enya3ZdgxaT0hPLSij7H7eKxauHAv8aMaSRetFiU+ygfTCRLgX
         0lS/eUjJ23vw7PMa0vvbcNhKLFSVsDGZkjTTc=
MIME-Version: 1.0
In-Reply-To: <5d5443650910080244m59d4519u289450a0e8ae3454@mail.gmail.com>
References: <20091007061830.GA7606@july>
	 <5d5443650910080244m59d4519u289450a0e8ae3454@mail.gmail.com>
Date: Tue, 13 Oct 2009 00:26:53 +0530
Message-ID: <5d5443650910121156x37ba6cd7w230bda9aef4df55@mail.gmail.com>
Subject: Re: [PATCH 6/6] haptic: ISA1200 haptic device support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-i2c@vger.kernel.org, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Thu, Oct 8, 2009 at 3:14 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
> Adding linux-i2c as it is i2c client driver and Ben Dooks for samsung
> pwm driver API usage.
>
> On Wed, Oct 7, 2009 at 11:48 AM, Kyungmin Park
> <kyungmin.park@samsung.com> wrote:
>> I2C based ISA1200 haptic driver support.
>> This chip supports both internal and external.
>> But only external configuration are implemented.
>
> Probably following text would look better:
>
> Add Imagis ISA1200 haptics chip driver support. This chip supports
> internal and external PWM configuration. This patch only supports
> external PWM configuration.
>
>> new file mode 100644
>> index 0000000..51c4ea4
>> --- /dev/null
>> +++ b/drivers/haptic/isa1200.c
>> @@ -0,0 +1,429 @@
>> +/*
>> + *  isa1200.c - Haptic Motor
>> + *
>> + *  Copyright (C) 2009 Samsung Electronics
>> + *  Kyungmin Park <kyungmin.park@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/gpio.h>
>> +#include <linux/haptic.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/pwm.h>
>> +#include <linux/ctype.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/i2c/isa1200.h>
>> +#include "haptic.h"
>> +
>> +struct isa1200_chip {
>> +       struct i2c_client *client;
>> +       struct pwm_device *pwm;
>> +       struct haptic_classdev cdev;
>> +       struct work_struct work;
>> +       struct timer_list timer;
>> +
>> +       unsigned int    len;            /* LDO enable */
>> +       unsigned int    hen;            /* Haptic enable */
>> +
>> +       int enable;
>> +       int powered;
>> +
>> +       int level;
>> +       int level_max;
>> +
>> +       int ldo_level;
>> +};
>> +
>> +
>> +static void isa1200_chip_power_on(struct isa1200_chip *haptic)
>> +{
>> +       if (haptic->powered)
>> +               return;
>> +       haptic->powered = 1;
>> +       /* Use smart mode enable control */
>
> You mean here that, enabling smart mode control by writing ISA1200
> register over I2C will be added later, right?
>
>> +
>> +static void isa1200_setup(struct i2c_client *client)
>> +{
>> +       struct isa1200_chip *chip = i2c_get_clientdata(client);
>> +       int value;
>> +
>> +       gpio_set_value(chip->len, 1);
>> +       udelay(250);
>> +       gpio_set_value(chip->len, 1);
>> +
>
> Please clarify:
>
> In your hardware configuration, you are enabling internal LDO above?
> It may not be true for all the hardware configuration and it might be
> grounded. If true, please make this as platform data so that it can be
> selected run time.
>
>> +       value = isa1200_read_reg(client, ISA1200_SCTRL0);
>> +       value &= ~ISA1200_LDOADJ_MASK;
>> +       value |= chip->ldo_level;
>> +       isa1200_write_reg(client, ISA1200_SCTRL0, value);
>> +
>> +       value = ISA1200_HAPDREN | ISA1200_OVERHL | ISA1200_HAPDIGMOD_PWM_IN |
>> +               ISA1200_PWMMOD_DIVIDER_128;
>> +       isa1200_write_reg(client, ISA1200_HCTRL0, value);
>> +
>> +       value = ISA1200_EXTCLKSEL | ISA1200_BIT6_ON | ISA1200_MOTTYP_LRA |
>
> Probably motor type could be different too. Please see what other
> parameters you could become as platform data for this chip and can be
> tuned by h/w designer for the product design.
>
>> +               ISA1200_SMARTEN | ISA1200_SMARTOFFT_64;
>
> Oh. You are enabling smart control here.
>
>> +       isa1200_write_reg(client, ISA1200_HCTRL1, value);
>> +
>> +       value = isa1200_read_reg(client, ISA1200_HCTRL2);
>> +       value |= ISA1200_SEEN;
>> +       isa1200_write_reg(client, ISA1200_HCTRL2, value);
>> +       isa1200_chip_power_off(chip);
>> +       isa1200_chip_power_on(chip);
>> +
>> +       /* TODO */
>
> ?? some todo text?
>
>> +}
>> +
>> +static int __devinit isa1200_probe(struct i2c_client *client,
>> +                       const struct i2c_device_id *id)
>> +{
>> +       struct isa1200_chip *chip;
>> +       struct haptic_platform_data *pdata;
>> +       int ret;
>> +
>
> You need to add i2c_check_functionality call with smbus_byte_data.
>
>> +       pdata = client->dev.platform_data;
>> +       if (!pdata) {
>> +               dev_err(&client->dev, "%s: no platform data\n", __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       chip = kzalloc(sizeof(struct isa1200_chip), GFP_KERNEL);
>> +       if (!chip)
>> +               return -ENOMEM;
>> +
>> +       chip->client = client;
>> +       chip->cdev.set = isa1200_chip_set;
>> +       chip->cdev.get = isa1200_chip_get;
>> +       chip->cdev.show_enable = isa1200_chip_show_enable;
>> +       chip->cdev.store_enable = isa1200_chip_store_enable;
>> +       chip->cdev.store_oneshot = isa1200_chip_store_oneshot;
>> +       chip->cdev.show_level = isa1200_chip_show_level;
>> +       chip->cdev.store_level = isa1200_chip_store_level;
>> +       chip->cdev.show_level_max = isa1200_chip_show_level_max;
>> +       chip->cdev.name = pdata->name;
>> +       chip->enable = 0;
>> +       chip->level = PWM_HAPTIC_DEFAULT_LEVEL;
>> +       chip->level_max = PWM_HAPTIC_DEFAULT_LEVEL;
>> +       chip->ldo_level = pdata->ldo_level;
>> +
>> +       if (pdata->setup_pin)
>> +               pdata->setup_pin();
>> +       chip->len = pdata->gpio;
>> +       chip->hen = pdata->gpio;
>> +       chip->pwm = pwm_request(pdata->pwm_timer, "haptic");
>> +       if (IS_ERR(chip->pwm)) {
>> +               dev_err(&client->dev, "unable to request PWM for haptic.\n");
>> +               ret = PTR_ERR(chip->pwm);
>> +               goto error_pwm;
>> +       }
>> +
>> +       INIT_WORK(&chip->work, isa1200_chip_work);
>> +
>> +       /* register our new haptic device */
>> +       ret = haptic_classdev_register(&client->dev, &chip->cdev);
>> +       if (ret < 0) {
>> +               dev_err(&client->dev, "haptic_classdev_register failed\n");
>> +               goto error_classdev;
>> +       }
>> +
>> +       ret = sysfs_create_group(&chip->cdev.dev->kobj, &haptic_group);
>> +       if (ret)
>> +               goto error_enable;
>
> Why the user of haptics class has to call this? I assume that once the
> user of haptics class registers with it, the class itself should
> create the necessary sysfs files and user driver doesn't have to worry
> about it except providing necessary hooks.
>
>> +
>> +       init_timer(&chip->timer);
>> +       chip->timer.data = (unsigned long)chip;
>> +       chip->timer.function = &isa1200_chip_timer;
>
> like to use setup_timer?
>
>> +
>> +       i2c_set_clientdata(client, chip);
>> +
>> +       if (gpio_is_valid(pdata->gpio)) {
>> +               ret = gpio_request(pdata->gpio, "haptic enable");
>> +               if (ret)
>> +                       goto error_gpio;
>> +               gpio_direction_output(pdata->gpio, 1);
>> +       }
>> +
>> +       isa1200_setup(client);
>> +
>> +       printk(KERN_INFO "isa1200 %s registered\n", pdata->name);
>> +       return 0;
>> +
>> +error_gpio:
>> +       gpio_free(pdata->gpio);
>> +error_enable:
>> +       sysfs_remove_group(&chip->cdev.dev->kobj, &haptic_group);
>> +error_classdev:
>> +       haptic_classdev_unregister(&chip->cdev);
>> +error_pwm:
>> +       pwm_free(chip->pwm);
>> +       kfree(chip);
>> +       return ret;
>> +}
>> +
>> +static int __devexit isa1200_remove(struct i2c_client *client)
>> +{
>> +       struct isa1200_chip *chip = i2c_get_clientdata(client);
>> +
>> +       if (gpio_is_valid(chip->len))
>> +               gpio_free(chip->len);
>> +
>> +       sysfs_remove_group(&chip->cdev.dev->kobj, &haptic_group);
>> +       haptic_classdev_unregister(&chip->cdev);
>
> Where is del_timer_sync and cancel_work ?
>
>> +       pwm_free(chip->pwm);
>> +       kfree(chip);
>> +       return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int isa1200_suspend(struct i2c_client *client, pm_message_t mesg)
>> +{
>> +       struct isa1200_chip *chip = i2c_get_clientdata(client);
>> +       isa1200_chip_power_off(chip);
>> +       return 0;
>> +}
>> +
>> +static int isa1200_resume(struct i2c_client *client)
>> +{
>> +       isa1200_setup(client);
>> +       return 0;
>> +}
>> +#else
>> +#define isa1200_suspend                NULL
>> +#define isa1200_resume         NULL
>> +#endif
>> +
>> +static const struct i2c_device_id isa1200_id[] = {
>> +       { "isa1200", 0 },

For haptics use-case it is very natural to have multiple instance of
these chips to driver different say top-bottom or right-and-left
mounted motors to create various patterns. I hope haptics class and
this isa1200 is safe for such usage including sysfs naming
conventions.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
