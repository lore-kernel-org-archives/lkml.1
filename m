Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYJTQ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYJTQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJTQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:59:08 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46631 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752269AbYJTQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:59:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sI0L5zg3HXX2zcyC8+q5UueSTwnSUD53hsS6I4E3IYtWTCpcLMi7YTBnShXR7inhGqm0q5OwkdmS0szTsOWmbUXXzP++vb1ET0yGlhWi3x5ic5Ojo/bm+uy0sE9zp9w+oIQAUKaafZjW1IYQQkaghkjM7U36Rv9v0ZTLd/Gu3z0=  ;
X-YMail-OSG: Il3JfpsVM1lfBGEyTQDEkVWWunQZjROGV_vg90u9lx6473BxIVfR5E4vRoVENxHVAlprWTYiMuKrmy1rIp3LLkwvtVr9bzPeAh8OWnNTMqIjBEWLFQ6JETq6nv3fUv3Ed39j_GUAEXIoVzL0Xf2AXijx
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Jackson <mpfj@mimc.co.uk>
Subject: Re: [PATCH v2] Add Dallas DS1390 RTC chip
Date: Mon, 20 Oct 2008 09:59:03 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net
References: <48FC442E.9070206@mimc.co.uk>
In-Reply-To: <48FC442E.9070206@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810200959.03486.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008, Mark Jackson wrote:
> +config RTC_DRV_DS1390
> +       tristate "Dallas/Maxim DS1390"
> +       help
> +         If you say yes here you get support for the DS1390 and probably
> +         other chips connected with SPI.

According to the datasheet at

  http://www.maxim-ic.com/quick_view2.cfm/qv_pk/4359

the DS1390, DS1391, DS1392, DS1393, and DS1394 chips are essentially
all the same except that the control register for the '91 and '92
has different bits.

So it looks like this driver should already support three chips, if
the spi_board_info has the right spi->mode bits set:  SPI_MODE_* and
SPI_3WIRE.  And if there were platform_data defined to hold the
initial control register setting, two more ... configuring that
trickle charger would already justify having platform_data too.

Please strike the "probably" and list at least those three chips.


> +         The first seven registers on these chips hold an RTC, and other
> +         registers may add features such as NVRAM, a trickle charger for
> +         the RTC/NVRAM backup power, and alarms.  This driver may not
> +         expose all those available chip features.

The "these chips" language bothers me.  This looks like cut'n'paste
from the rtc-ds1307 language, but you don't actually describe what
chips the driver handles.

I'd rather see the description say which other chips it expects to
handle, and have the description match.  All of these have alarms
and a trickle charger for backup power, but none have NVRAM.


> +/* drivers/rtc/rtc-ds1390.c

It's a bit of a nit, but the convention is 

	/*
	 * rtc-ds1390.c -- driver for DS1390 and related SPI RTCs
	 *
	 * Copyright (C) ... etc

Maybe with a separate "written by Mark Jackson" next to the copyright.

> + *
> + * Copyright (C) 2008 Mercury IMC Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Driver for DS1390 spi RTC
> + *

And to keep changelogs out of source code; that's what GIT is for!


> + * Changelog:
> + *
> + * 04-Apr-2008: Mark Jackson <mpfj@mimc.co.uk>
> + *             - Initial version based on rtc-max6902
> + *             - No alarm support though !!
> + */

My personal taste is to have the copyright comment cover ONLY the
copyright (and licensing) issues, and have a separate comment
describing open issues with the code.  In this case, that would
be no support for the alarm, any other aspect of the control
register, or (unless it was set up by pre-OS code) the trickle
charger ... 


> +static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
> +{
> +       ...
> +       return 0;

Especially since you don't currently have logic to handle the
initialization from first power up (clearing OSF etc), it'd be
good to "return rtc_valid_tm(dt);".


> +       status = spi_sync(spi, &message);
> +       if (status == 0)
> +               return message.status;
> +
> +       return 0;

Nowadays that can just be "return spi_sync(...)".

Although ... you can make this code be a bunch simpler
by using spi_write_then_read().


> +static struct spi_driver ds1390_driver = {
> +       .driver = {
> +               .name   = "rtc-ds1390",
> +               .bus    = &spi_bus_type,

Rule of thumb:  always let the bus code set driver->bus,
never set it yourself.

> +               .owner  = THIS_MODULE,
> +       },
> +       .probe  = ds1390_probe,
> +       .remove = __devexit_p(ds1390_remove),
> +};

