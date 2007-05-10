Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXEJUiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXEJUiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXEJUh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:37:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:9223 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXEJUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FHrUM4OOO3TMAJnzHqd6EaiHURi6ApHxNvv+4UWpj0Qgw1LNlyoqLAwfkIh5xhqfPVQFbF2m8bP2MhsuxHNAQBWesUgACLOa9m4I3rWW6dkcarHM/RLCaO3yvs5vUqzTbY4uFBF/Xh3T4zFUVs8lFoKtNjA/XyMCOOEWkeZHfdI=
Message-ID: <528646bc0705101337s1f938b44w62dd738f68a92c67@mail.gmail.com>
Date: Thu, 10 May 2007 14:37:54 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
In-Reply-To: <20070510134850.64075278@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11785707423303-git-send-email-grant.likely@secretlab.ca>
	 <20070510134850.64075278@hyperion.delvare>
X-Google-Sender-Auth: db7a87546a0aae20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments Jean.  I've got some questions/comments below.

On 5/10/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Grant,
>
> On Mon,  7 May 2007 14:45:42 -0600, Grant Likely wrote:
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  drivers/i2c/chips/Kconfig  |   10 ++
> >  drivers/i2c/chips/Makefile |    1 +
> >  drivers/i2c/chips/ds1682.c |  363 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 374 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/chips/ds1682.c
> >
>
> Please fix the following warnings:
>
> drivers/i2c/chips/ds1682.c: In function 'ds1682_store':
> drivers/i2c/chips/ds1682.c:129: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'
> drivers/i2c/chips/ds1682.c: In function 'ds1682_user_data_store':
> drivers/i2c/chips/ds1682.c:220: warning: format '%i' expects type 'int', but argument 4 has type 'size_t'

Hmmm; I didn't see those warning here, but I'm probably running on a
different arch (ppc32).  I'll make it more robust.

> > +     help
> > +       If you say yes here you get support for Dallas Semiconductor
> > +       DS1682 Total Elapsed Time Recorder
> > +
> > +       This driver can also be built as a module.  If so, the module
> > +       will be called ds1682.
> > +
>
> I know this isn't exactly a RTC chip, but this is still related with
> timekeeping, so wouldn't it be better placed under drivers/rtc?
> Alessandro, what do you think?

I was following the lead of the ds1337 and ds1374 chips, but I will
happily move it if so desired.

> > +static unsigned short normal_i2c[] = { DS1682_ADDR, I2C_CLIENT_END };
> > +
> > +I2C_CLIENT_INSMOD;
> > +
> > +/*
> > + * Low level chip access functions
> > + */
> > +static int ds1682_read(struct i2c_client *client, int reg, void *buf, int len)
> > +{
> > +     u8 *bytes = buf;
> > +     int val;
> > +
> > +     while (len--) {
> > +             val = i2c_smbus_read_byte_data(client, reg++);
> > +             if (val < 0)
> > +                     return -EIO;
> > +             *bytes++ = val;
> > +     }
> > +     return 0;
> > +}
>
> Did you check if the device supports I2C block reads? This would be
> much faster, and might also solve consistency issues. Are you certain
> that the above brings you back bytes which all belong to the same
> "time measurement"? Does the device latch the register values on the
> first read?
>
> I find it strange that you use an I2C block write when writing values
> to the chip, but individual byte reads in the other direction.

Mostly because i2c_smbus_write_i2c_block_data allows me to specify the
tranfer length, but i2c_smbus_read_i2c_block_data does not.  I
couldn't figure out how to request an exact transfer size and I was
using ds1374 as an example which also transfers byte-at-a-time.

> > +static ssize_t ds1682_store(struct device *dev,
> > +                         struct device_attribute *attr, const char *buf,
> > +                         size_t count)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     int reg;
> > +     int regsize;
> > +     char *endp;
> > +     u32 val;
> > +     int rc;
> > +
> > +     /* Sanitize the input */
> > +     reg = ds1682_attr_to_reg(attr, &regsize);
> > +
> > +     if ((reg < 0) || (count >= 16) || (buf[count] != '\0')) {
>
> How could buf[count] not be '\0'? As far as I know this is guaranteed
> by the underlying sysfs code. I also don't see the point of checking
> the value of count.

Both of these checks are from an ignorance of sysfs.  I didn't know
what was guaranteed and based on what was writting in LDDv3, I thought
that I could end up receiving a page of *anything* from userspace.
I've just looked through the code, and fill_write_buffer() does do
what you said.  I'll remove these checks.

> > +
> > +/*
> > + * Called when a device is found at the ds1682 address
> > + */
> > +static struct i2c_driver ds1682_driver;
> > +static int ds1682_detect(struct i2c_adapter *adapter, int address, int kind)
> > +{
> > +     struct i2c_client *new_client;
>
> Please rename this to just "client". This "new_client" name is a
> disease :(

Heh; I'll submit a patch for Documentation/i2c/writing-clients too then.

> > +     if (!(new_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
> > +             err = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     new_client->addr = address;
> > +     new_client->adapter = adapter;
> > +     new_client->driver = &ds1682_driver;
> > +     new_client->flags = 0;
>
> Not needed, the kzalloc above did it for you.

This is also from Documentation/i2c/writing-clients.  I'll fix this.

>
> > +
> > +     /* Note: Ignoring 'kind' value as the ds1682 uses a fixed address */
>
> The "kind" value has nothing to do with the address. It tells you if
> the user asked (through a module parameter) for the device
> detection/identification to be skipped. Which brings me to the point
> that your driver does no device identification at all. Fortunately,
> address 0x6b isn't very popular, but I would still like to see some
> detection code. Is there a way to identify the DS1682? I know that such
> devices usually (unfortunately) don't have an identification register,
> but maybe there are unused configuration bits which can be checked? Or
> you can check the number of registers?

:-(  No, there is no way to id the device from the contents of the
registers.  How do I test for the number of registers?

> > +
> > +     return 0;
> > +
> > +      exit_attr_userdata:
>
> Please use a single space for label indentation.

This was done by scripts/Lindent.  I'll change it if you really want
me to.  I've gotten into the habit of running all my code through
Lindent before committing to avoid as many whitespace complaints as
possible.

If this spacing is wrong, does Lindent need to be fixed?

> > +static struct i2c_driver ds1682_driver = {
> > +     .driver = {
> > +                .name = "ds1682",
> > +                },
>
> Indentation.

Ditto on Lindent.

>
> The code is quite nice otherwise, good work!

Thanks, I'll fix it up and resubmit.

g.
