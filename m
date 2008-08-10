Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYHJW66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYHJW66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYHJW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:58:49 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:37199 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751524AbYHJW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:58:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=oswGXtmCSrLPeaRjSVuUjrlUwWNHkicTGmBGmMOqffcMg9PDAoOvP0IZ2PdkJGAf9D3NXtR1t01VPGBOaOVYCxaaUPz4vNB2PBk3oa2Umat1DV/bFPcZHKwq6z3DqTQn6U8+mFqTbM9rKrDWEZhxu/OCWyaY//ov+VY8GimFCXA=  ;
X-YMail-OSG: mYAXsxkVM1mODWK9.Gp4IQbqDqhb0Lq.4QeydhzUqz7DW930b7lisbYv_SVvPdilfMEoGjvT8_SpYS4Dx9TfaJulhjj818BHtd_OyXGwrLn1CvQg0qrqArG7n1AKuAqHzJ8BueVLcdy939iUvCYIX1hk
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 10 Aug 2008 16:04:04 -0700
From: David Brownell <david-b@pacbell.net>
To: marc.pignat@hevs.ch, khali@linux-fr.org
Subject: Re: [RFC,PATCH] i2c: fix device_init_wakeup place
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
References: <200807291535.45689.marc.pignat@hevs.ch>
 <20080809185619.6211fbf3@hyperion.delvare>
In-Reply-To: <20080809185619.6211fbf3@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080810230404.B2943B2AB@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The current code calls device_init_wakeup() before device_register, but
> > device_register will disable device wakeup.
> > 
> > This patch (against 2.6.27-rc1) move the device_init_wakeup() call in
> > the bus probe function,just before the probe call.
>
> David, can you please help? This part of the code is yours and I have
> no idea how it works.

Patch looked OK to me, except for the one comment below.

The root cause of the bug could be blamed on the new-style code
recycling the legacy i2c_attach_client() code instead of taking
a more driver-model-ish approach.

That forced use of device_register(), instead of device_add() ...
and register() always zero-initializes those wakeup flags.  On the
other hand, add() just takes their original value.  This patch
seems like the most concise fix possible.


>	I am surprised that according to Marc the code
> simply doesn't work at the moment. Didn't you test it?

I thought I had.  The one board I had with a wake-capable I2C
device (i2c/chips/menelaus.c) seems to have an ugly workaround
for the problem this addresses ... I probably just forgot to
remove that workaround, so of course it (still) worked.

(Well, actually I have another now, but its Linux support is
still incomplete, notably power managment.  www.beagleboard.org
can't yet run with mainline kernels.)


> > This will fix 3bbb835d4c53faf0bca62f0e39835926bef40b1f ('New style
> > devices can support driver modle wakeup flags') which in fact has
> > no effect. I think there is no need to fix -stable, because there
> > is no in-tree users of the I2C_CLIENT_WAKE flag.
>
> Interesting point... David, what are you using this code for then? Same
> question for you Marc.

The goal was to make sure that wakeup flags could be initialized
sanely for I2C devices, with RTCs being the most common example.

It would be wrong to have the drivers setting such flags, since they
can't actually know when their IRQs (or whatever) are wakeup-capable.
That kind of information is specific to how any given board is wired.


> > This patch also include a small functionnal change: the I2C_CLIENT_WAKE
> > is no more removed from the client flags, but this should't hurt.
>
> Why do you want to change this?

It's kind of essential to making this patch work!  Else the flag
won't be available when the i2c core gets control of that device
node again, after device_initialize() code zeroes those flags.


> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -108,6 +108,7 @@ static int i2c_device_probe(struct device *dev)
> >  	if (!driver->probe || !driver->id_table)
> >  		return -ENODEV;
> >  	client->driver = driver;

Better would be to preserve any existing settings:

	if (!device_can_wakeup(&client->dev))
		device_init_wakeup(...)

That way the userspace policy setting is preserved unless the
device itself gets removed ... instead of being clobbered by
the simple act of (re)probing a driver.

- Dave


> > +	device_init_wakeup(&client->dev, client->flags & I2C_CLIENT_WAKE);
> >  	dev_dbg(dev, "probe\n");
> >  
> >  	status = driver->probe(client, i2c_match_id(driver->id_table, client));
> > @@ -262,9 +263,8 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
> >  	client->adapter = adap;
> >  
> >  	client->dev.platform_data = info->platform_data;
> > -	device_init_wakeup(&client->dev, info->flags & I2C_CLIENT_WAKE);
> >  
> > -	client->flags = info->flags & ~I2C_CLIENT_WAKE;
> > +	client->flags = info->flags;
> >  	client->addr = info->addr;
> >  	client->irq = info->irq;
> >  
>
