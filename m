Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXEKKXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXEKKXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXEKKXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:23:10 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4348 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755945AbXEKKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:23:08 -0400
Date: Fri, 11 May 2007 12:23:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-ID: <20070511122329.6edad2ba@hyperion.delvare>
In-Reply-To: <528646bc0705101337s1f938b44w62dd738f68a92c67@mail.gmail.com>
References: <11785707423303-git-send-email-grant.likely@secretlab.ca>
	<20070510134850.64075278@hyperion.delvare>
	<528646bc0705101337s1f938b44w62dd738f68a92c67@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, 10 May 2007 14:37:54 -0600, Grant Likely wrote:
> Thanks for the comments Jean.  I've got some questions/comments below.
> 
> On 5/10/07, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi Grant,
> >
> > On Mon,  7 May 2007 14:45:42 -0600, Grant Likely wrote:
> > > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > > ---
> > >  drivers/i2c/chips/Kconfig  |   10 ++
> > >  drivers/i2c/chips/Makefile |    1 +
> > >  drivers/i2c/chips/ds1682.c |  363 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 374 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/i2c/chips/ds1682.c
> > >
> >
> > Please fix the following warnings:
> >
> > drivers/i2c/chips/ds1682.c: In function 'ds1682_store':
> > drivers/i2c/chips/ds1682.c:129: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'
> > drivers/i2c/chips/ds1682.c: In function 'ds1682_user_data_store':
> > drivers/i2c/chips/ds1682.c:220: warning: format '%i' expects type 'int', but argument 4 has type 'size_t'
> 
> Hmmm; I didn't see those warning here, but I'm probably running on a
> different arch (ppc32).  I'll make it more robust.

Typical warning that hows on either 32-bit or 64-bit systems but not
both. It's usually easily fixed by replacing %i by %zi.

> > > +     help
> > > +       If you say yes here you get support for Dallas Semiconductor
> > > +       DS1682 Total Elapsed Time Recorder
> > > +
> > > +       This driver can also be built as a module.  If so, the module
> > > +       will be called ds1682.
> > > +
> >
> > I know this isn't exactly a RTC chip, but this is still related with
> > timekeeping, so wouldn't it be better placed under drivers/rtc?
> > Alessandro, what do you think?
> 
> I was following the lead of the ds1337 and ds1374 chips, but I will
> happily move it if so desired.

Said drivers are in the process of being moved to drivers/rtc - which
is why I was asking.

> > > +/*
> > > + * Low level chip access functions
> > > + */
> > > +static int ds1682_read(struct i2c_client *client, int reg, void *buf, int len)
> > > +{
> > > +     u8 *bytes = buf;
> > > +     int val;
> > > +
> > > +     while (len--) {
> > > +             val = i2c_smbus_read_byte_data(client, reg++);
> > > +             if (val < 0)
> > > +                     return -EIO;
> > > +             *bytes++ = val;
> > > +     }
> > > +     return 0;
> > > +}
> >
> > Did you check if the device supports I2C block reads? This would be
> > much faster, and might also solve consistency issues. Are you certain
> > that the above brings you back bytes which all belong to the same
> > "time measurement"? Does the device latch the register values on the
> > first read?
> >
> > I find it strange that you use an I2C block write when writing values
> > to the chip, but individual byte reads in the other direction.
> 
> Mostly because i2c_smbus_write_i2c_block_data allows me to specify the
> tranfer length, but i2c_smbus_read_i2c_block_data does not.  I
> couldn't figure out how to request an exact transfer size and I was
> using ds1374 as an example which also transfers byte-at-a-time.

Ah. Very good point. I always considered this
(i2c_smbus_read_i2c_block_data not allowing the caller to specify the
transfer length) a bug. Maybe the time has come to finally fix it, so
that drivers which need that kind of transaction can finally use it.
I'll work on it, patch to follow.

> > > +
> > > +     /* Note: Ignoring 'kind' value as the ds1682 uses a fixed address */
> >
> > The "kind" value has nothing to do with the address. It tells you if
> > the user asked (through a module parameter) for the device
> > detection/identification to be skipped. Which brings me to the point
> > that your driver does no device identification at all. Fortunately,
> > address 0x6b isn't very popular, but I would still like to see some
> > detection code. Is there a way to identify the DS1682? I know that such
> > devices usually (unfortunately) don't have an identification register,
> > but maybe there are unused configuration bits which can be checked? Or
> > you can check the number of registers?
> 
> :-(  No, there is no way to id the device from the contents of the
> registers.  How do I test for the number of registers?

Try a byte read of the last register, followed by a byte read of the
next register (which doesn't exist). Some chips will succeed the first
read and fail the second one, allowing you to test the number of
registers. The pca9539 driver does this if you want an example.

But it is also possible that reading a non-existent register will
return something (not an error), such as the value of the last read
register, or the value of an arbitrary register. You really have to
try. The user-space tool "i2cdump" comes in handy for such tests.

If there really is no way to detect the chip, this is one more reason
to switch to the new i2c model.

> > > +
> > > +     return 0;
> > > +
> > > +      exit_attr_userdata:
> >
> > Please use a single space for label indentation.
> 
> This was done by scripts/Lindent.  I'll change it if you really want
> me to.  I've gotten into the habit of running all my code through
> Lindent before committing to avoid as many whitespace complaints as
> possible.
> 
> If this spacing is wrong, does Lindent need to be fixed?
> 
> > > +static struct i2c_driver ds1682_driver = {
> > > +     .driver = {
> > > +                .name = "ds1682",
> > > +                },
> >
> > Indentation.
> 
> Ditto on Lindent.

Thanks for using Lindent, I can only encourage people to do that
especially for new drivers. As a matter of fact, the rest of your
driver was perfect with regards to indentation :) However, if Lindent
indeed did these two mistakes, it needs to be fixed.

-- 
Jean Delvare
