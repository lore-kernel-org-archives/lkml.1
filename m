Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXENR3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXENR3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXENR3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:29:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45823 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbXENR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cW303/+0l8bo4zHs81KqxD53wx9ZsW+rkKvq1xrBg+m6rUsYqsZqj9xHBNP/EKgOUAfqDzVHP4ZVwkt/iOP+6rFLkCpYz/VVCa9Ao9I38CD7ggzlnvxfkpjuyK0E1YG/4pEDct3J6aro7jY6++PI8/oMEKVu56H/oq8BjVYm79M=
Message-ID: <528646bc0705141029w397b11cejec17c770d64d7ce5@mail.gmail.com>
Date: Mon, 14 May 2007 11:29:04 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
In-Reply-To: <20070514105600.5095d38e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
	 <20070514105600.5095d38e@hyperion.delvare>
X-Google-Sender-Auth: 00340a883838dcc7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh.  Well that was a rather sloppy patch on my part.  I'll fix up and resubmit.

On 5/14/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Grant,
>
> On Sun, 13 May 2007 01:43:42 -0600, Grant Likely wrote:
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >
> > Here is the 3rd iteration with the following changes:
> > - Modified to be an i2c "new style" driver based on David Brownell's work
>
> Can we see the corresponding architecture patch (device declaration)?

Yes, I'll include it in the commit comment.  It is for a board that
isn't in mainline (yet) so a seperate patch doesn't make much sense.

>
> > - uses the new prototype for i2c_smbus_read_i2c_block_data() for block data
> >   reads instead of a single byte at a time.
> >
> >  drivers/i2c/chips/ds1682.c |  270 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 270 insertions(+), 0 deletions(-)
>
> Where have the changes to Kconfig and Makefile gone? Without them, this
> patch is a no-op.

Oops, eaten by stgit (or rather; eaten by my inexperience with stgit.

>
> BTW, the config option shouldn't be named SENSORS_DS1682 as your
> original patch had - this device isn't a sensor. It should be just
> "DS1682".

Done.

BTW, I've just left the driver in drivers/i2c/chips.  It seems
sufficiently different from an rtc (and the interface is totally
difference) that putting it in drivers/rtc seems wrong.  If you
disagree, I can change this.

>
> >
> > diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
> > new file mode 100644
> > index 0000000..0a4a89e
> > --- /dev/null
> > +++ b/drivers/i2c/chips/ds1682.c
> > @@ -0,0 +1,270 @@
> > +/*
> > + * Dallas Semiconductor DS1682 Elapsed Time Recorder device driver
> > + *
> > + * Written by: Grant Likely <grant.likely@secretlab.ca>
> > + *
> > + * Copyright (C) 2007 Secret Lab Technologies Ltd.
> > + * Copyright (C) 2005 James Chapman <jchapman@katalix.com>
> > + * Copyright (C) 2000 Russell King
> > + *
> > + * Derived from ds1337 real time clock device driver
j>
> Technically, this is the ds1337 driver on which James and Russell have
> a copyright, not yours. I don't think there is anything left from the
> code you originally copied from, BTW.

ok, fixed.  I like to err on the side of caution when it comes to
copyright notices.

> > + * Simple register attributes
> > + */
> > +SENSOR_DEVICE_ATTR_2(config, S_IRUGO, ds1682_show, NULL, DS1682_REG_CONFIG, 1);
>
> Bug! The last two arguments are swapped.
>
> Also, I don't see the point of exporting this value to user-space, as
> the format is proprietary.

You're right.  Removed.

> > +SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> > +                  4, DS1682_REG_ELAPSED);
> > +SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> > +                  4, DS1682_REG_ALARM);
> > +SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> > +                  2, DS1682_REG_EVT_CNTR);
> > +
> > +static const struct attribute_group ds1682_group = {
> > +     .attrs = (struct attribute *[]) {
> > +             &sensor_dev_attr_config.dev_attr.attr,
> > +             &sensor_dev_attr_elapsed_time.dev_attr.attr,
> > +             &sensor_dev_attr_alarm_time.dev_attr.attr,
> > +             &sensor_dev_attr_event_count.dev_attr.attr,
> > +             NULL,
> > +     },
> > +};
>
> I'm not sure if all compilers support this.

I think it should be okay.  It is used abundantly in the
arch/ppc/syslib/*_devices.c code, and that code is compiled with a lot
of different compiler versions.

> > +static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
> > +                               size_t count)
> > +{
> > +     struct i2c_client *client = kobj_to_i2c_client(kobj);
> > +     int rc;
> > +
> > +     dev_dbg(&client->dev, "ds1682_eeprom_read(p=%p, off=%lli, c=%zi)\n",
> > +             buf, off, count);
> > +
> > +     if (off > DS1682_EEPROM_SIZE)
>
> Should be ">=", otherwise you might end up doing a 0-length I2C block
> read, which is bad.

Right, good catch

> > +
> > +/*
> > + * Called when a device is found at the ds1682 address
> > + */
>
> This comment is no longer true.
>
> > +static int ds1682_probe(struct i2c_client *client)
> > +{
> > +     int err = 0;
> > +
> > +     if (client->addr != 0x6b) {
> > +             dev_err(&client->dev, "%x is not a valid address\n",
> > +                     client->addr);
> > +             return -ENODEV;
> > +     }
>
> Why check this? You should trust the person who wrote the device
> definition in the platform code. The only reason why the older i2c chip
> drivers did address checks is because that was one preliminary
> device identification step. With the new model, you don't need to
> identify the device, you already know what's there as per
> architecture-level device declaration.

Me being paranoid a guess.  Removed.

>
> Not checking the address even has a benefit: if a compatible device
> exists (today or in the future) with a different address, we don't need
> to patch the driver to support it.
>
> > +
> > +     if (!i2c_check_functionality(client->adapter,
> > +                                  I2C_FUNC_SMBUS_READ_BYTE_DATA |
> > +                                  I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
>
> This no longer reflects what the driver is using.
>
> > +             dev_err(&client->dev, "i2c bus does not support the ds1682\n");
> > +             goto exit;
> > +     }
> > +
> > +     if (sysfs_create_group(&client->dev.kobj, &ds1682_group))
>
> Missing "err = ".

Gah!

Thanks for the comments,
g.

-- 
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
