Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZIIMpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZIIMpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZIIMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:45:55 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52978 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZIIMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:45:54 -0400
Date: Wed, 9 Sep 2009 14:45:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments   
 amc6821 chip
Message-ID: <20090909144554.4cda2297@hyperion.delvare>
In-Reply-To: <5.1.0.14.2.20090909140903.038dbd90@pop3.arnes.si>
References: <20090908170649.855dd1ff.akpm@linux-foundation.org>
	<20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
	<20090908170649.855dd1ff.akpm@linux-foundation.org>
	<5.1.0.14.2.20090909140903.038dbd90@pop3.arnes.si>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Sep 2009 14:24:05 +0200, Tomaz Mertelj wrote:
> At 09:34 9. 9. 2009 +0200, Jean Delvare wrote:
> >Yes please. We got rid of macro-generated callbacks in most hwmon
> >drivers a couple years ago already.
> 
> I do not like macro-generated callbacks myself as well. However, I was 
> impatient to get the
> driver working and since I have seen similar things in a few other drivers ...
> 
> I would prefer a single callback (would require some more work):
> 
> static ssize_t set_temp(
>          struct device *dev,
>          struct device_attribute *attr,
>          const char *buf,
>          size_t count)
> {
>          struct i2c_client *client = to_i2c_client(dev);
>          struct amc6821_data *data = i2c_get_clientdata(client);
>          int nr = to_sensor_dev_attr(attr)->index;
>          int val = simple_strtol(buf, NULL, 10);
>          val = SENSORS_LIMIT(val / 1000, -128, 127);
>          int *pvar;
>          u8 reg;
> 
>          switch (nr) {
>          case GET_SET_TEMP1_MIN:
>                  pvar=&data->temp1_min;
>                  reg=AMC6821_REG_LTEMP_LIMIT_MIN;
>                  break;
>          case ...
> 
>          ...
> 
>          default:
>                  dev_dbg(dev, "Unknown attr->index (%d)\n", nr);
>                  return SOME_ERROR;
>          }
>          mutex_lock(&data->update_lock);
>          *pvar=val;
>          if (i2c_smbus_write_byte_data(client, reg, *pvar)) {
>                  dev_err(&client->dev, "Register write error, aborting.\n");
>                  count = -EIO;
>          }
>          mutex_unlock(&data->update_lock);
>          return count;
> }
> 
> 
> static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO | S_IWUSR, get_temp,
>          set_temp, GET_SET_TEMP1_MIN);
> ...

Yes, would be much better. Or you can make things even better by
defining arrays of variables in your data structure, and arrays for
register numbers too. And if you need to pass 2 identifiers per entry,
you can take a look at struct sensor_device_attribute_2. So you have a
lot of possibilities to make the code more compact. To which degree you
want that, is up to you.

> > > Also, the checkpatch warning
> > >
> > > WARNING: consider using strict_strtol in preference to simple_strtol
> > > #381: FILE: drivers/hwmon/amc6821.c:228:
> > > +       int val = simple_strtol(buf, NULL, 10); \
> > >
> > > is valid.  The problem with simple_strtol() is that it will treat input
> > > of the form "43foo" as "43".  Even though the input was invalid.  A
> > > minor thing, but easily fixed too.
> >
> >Is there any legitimate use of simple_strtol then? I'm wondering why we
> >don't just get rid of it and rename strict_strtol to just strtol.
> 
> I have seen simple_strtol in many hwmon drivers so I thought there might be 
> a reason to do it this way?

Historical, as I recall, the strict variant did not exist when we
converted the first driver. And then copy-and-paste from driver to
driver, and here we are.

-- 
Jean Delvare
