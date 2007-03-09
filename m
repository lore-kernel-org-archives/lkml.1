Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbXCIVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbXCIVps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbXCIVps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:45:48 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:32356 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932642AbXCIVpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:45:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UjJ4MPU1gm01UpAqc4NIfMzpAY6WTUmyvQuv57nkj2G3Mxnv0VpWQCqwe/rWJQEs+Bu1dLeMbLYHeJBIkYD8n7k04iyVI/h6GdbhvnKAAZTyawbPpQDEl1Eox62qGT00JbkDJxSR6zWCrQEAfCHO3fGOgSmpR/vhhmSbYN0pCfo=  ;
X-YMail-OSG: jP729NYVM1msuM9RbQOgrXuLOjfBd8ZqYBM0xohg8x0k.2UoD8gs4TJQIPK_Ssr4N0f1PTvncP5kwNUkeTJdsAlLqHNAxbIyNcTIIRA3EFjRjLdaqO2k8odEXW6VNtWEJeLg.tS_9TeDmKA-
From: David Brownell <david-b@pacbell.net>
To: =?iso-8859-1?q?H=E5vard_Skinnemoen?= <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
Date: Fri, 9 Mar 2007 13:45:43 -0800
User-Agent: KMail/1.7.1
Cc: "Jean Delvare" <khali@linux-fr.org>, "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703090945.38880.david-b@pacbell.net> <200703091130.13547.david-b@pacbell.net> <52293.172.21.0.22.1173473006.squirrel@pat.norway.atmel.com>
In-Reply-To: <52293.172.21.0.22.1173473006.squirrel@pat.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200703091345.44744.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 12:43 pm, Håvard Skinnemoen wrote:
> On Fri, March 9, 2007 20:30, David Brownell wrote:
> > On Friday 09 March 2007 10:48 am, Haavard Skinnemoen wrote:
> >> This is a very simple bitbanging i2c bus driver utilizing the new
> >> arch-neutral GPIO API. Useful for chips that don't have a built-in
> >> i2c controller, additional i2c busses, or testing purposes.
> >
> > That's the right idea!  But remember that not all GPIOs support
> > reading back the actual value on SCL ...
> 
> The idea is to keep the output value at 0 and switch the output driver on
> and off. I assumed that changing the direction was the easiest way to
> achieve this.
> 
> I never really thought about output-only pins. Is it actually possible to
> implement i2c properly on such hardware?

Not strictly; but folk do so, and the results are compatible-enough
for many purposes.  Certainly a quick glance at i2c-algo-bit tells
me that it knows how to cope with output-only SCL.  A generic GPIO
driver "should" be able to at least act sanely given such a pin.


> > I2C has another interesting special case.  at91_set_multi_drive()
> > would be appropriate (yes?) for ARCH_AT91 to use on SCL, to best
> > support both clock stretching and multi-master configurations.
> 
> Isn't it better to switch the direction to input since the driver needs to
> watch the pin state in order to support clock stretching and multi-master?

Not necessarily ... reading the GPIO pad state works regardless of what
direction was configured on most chips (including AT91 and AVR32), but
not all of them.

Certainly multi-drive/open-drain outputs get the electical stuff right
without that.  Russell's explanation says the reason to switch direction
is to disable the non-open-drain output drivers.

There are several options lurking, that a generic I2C bitbanger "ought"
to handle.  Existence of open-drain outputs is one issue.  Ability to
change direction is another; as is ability to read the value on output
pads.  Your code assumed one set of answers; others are possible.


> The gpio_set_value() calls should go away and the output value should be
> explicitly set to 0 when turning on the output drivers. In its present
> form, the driver happens to work on my hardware, which is all I really
> cared about when writing it ;-)

As I said in a different way above!  If open drain outputs are available,
and the actual values can be read on output pins, then I think both pins
can be configured as outputs and left that way.

 
> >> +	printk(KERN_INFO "i2c-gpio: using pins 0x%x (sda) 0x%x (scl)\n",
> >> +	       pdata->sda_pin, pdata->scl_pin);
> >
> > Please, no hex there.  I think dev_info() would be better; and it
> > might be nice to report whether clock stretching is supported.
> 
> Ok, but how do I inform i2c-algo-bit about whether or not clock stretching
> is supported?

Reading the code, I see it's automatic if you don't provide getscl()...

- Dave

