Return-Path: <linux-kernel-owner+w=401wt.eu-S1761095AbXJQUFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095AbXJQUFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJQUFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:05:03 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:65166 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbXJQUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:05:00 -0400
Date: Wed, 17 Oct 2007 22:04:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #4] Input/Joystick Driver: add support AD7142
 joystick  driver
Message-ID: <20071017220456.7698de77@hyperion.delvare>
In-Reply-To: <200710171514.40941.rgetz@blackfin.uclinux.org>
References: <1192605120.7920.15.camel@roc-laptop>
	<20071017160702.3316fc24@hyperion.delvare>
	<200710171514.40941.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

On Wed, 17 Oct 2007 15:14:40 -0400, Robin Getz wrote:
> On Wed 17 Oct 2007 10:07, Jean Delvare pondered:
> > Hi Bryan,
> > 
> > On Wed, 17 Oct 2007 15:12:00 +0800, Bryan Wu wrote:
> > > Subject: [PATCH try #4] Input/Joystick Driver: add support AD7142
> > joystick driver
> > > +#define AD7142_I2C_ADDR		0x2C
> > 
> > Not worth a define IMHO, as you use it only once and the context is
> > completely clear.
> 
> > > +static int ad7142_probe(struct i2c_adapter *adap, int addr, int kind)
> > > +{
> > > +	struct ad7142_data *data;
> > > +	struct i2c_client *client;
> > > +	struct input_dev *input_dev;
> > > +	int rc;
> > > +
> > > +	data = kzalloc(sizeof(struct ad7142_data), GFP_KERNEL);
> > > +	if (!data)
> > > +		return -ENOMEM;
> > > +
> > > +	client = &data->client;
> > > +
> > > +	strlcpy(client->name, AD7142_DRV_NAME, I2C_NAME_SIZE);
> > > +	client->addr = addr;
> > > +	client->adapter = adap;
> > > +	client->driver = &ad7142_driver;
> > > +
> > 
> > This is unsafe: you're not doing any kind of detection here. 
> 
> I assume that in order to do things "right", all possible addresses should be 
> probed (for this part, that is 0x2C, 0x2D, 0x2E, 0x2F)?

Not necessarily. Given that detecting this chip safely seems to be
difficult (if not impossible), I'd rather only list the addresses which
are actually known to be used.

> And it should read a device ID (register 0x17 == 0xE62n (where n==rev number))

If the device does have an identification register, then yes you should
test here. However, I seem to understand that the AD7142 uses 2-byte
register addressing, while most I2C devices use 1-byte register
addressing (I2C is tricky in that respect). This means that "reading
from a register" for the AD7142 corresponds to "writing to a register"
for other chips. So even just reading from the device ID register in
the probe function isn't safe.

So to be on the safe side, the ad7142 driver should not probe _any_
address by default. Users should use the "probe" command line parameter
to explicitly ask for a given address to be probed.

> How many values/registers do you need to read before you say "this is the 
> one"? rather than a temp sensor with a similar value somewhere. Is there a 
> table anywhere that maps this out?

No, there is no standard at all. Each driver does its best to identify
the chip depending of the specific register map. When the devices don't
have ID registers, we test for unused bits or registers cycling over
arbitrary boundaries.

> It is pretty difficult just to probe on reset values, since that disallows 
> warm resets. This part - like most other I2C parts, has no external reset, 
> only software reset.

Agreed, don't probe on reset values.

> > The risk is mitigated by the fact
> > that your driver is currently built for Blackfin only, but this might
> > change in the future. 
> 
> The hope is that others can use it - it shouldn't be specific to Blackfin.

It the current state it's not acceptable. Too dangerous.

> > This is a very good reason to switch to a 
> > new-style i2c driver.

That's the way to go, really.

-- 
Jean Delvare
