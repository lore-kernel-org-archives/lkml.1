Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYFJG5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYFJG5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYFJG5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:57:45 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15113 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYFJG5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:57:44 -0400
Date: Tue, 10 Jun 2008 08:57:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080610085708.12c2d2a2@hyperion.delvare>
In-Reply-To: <484DA046.4010804@bluewatersys.com>
References: <200806091541.43899.u.luckas@road.de>
	<20080609135739.GE30971@flint.arm.linux.org.uk>
	<484D947D.1090900@bluewatersys.com>
	<200806091359.12791.david-b@pacbell.net>
	<484DA046.4010804@bluewatersys.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 09:27:34 +1200, Ryan Mallon wrote:
> David Brownell wrote:
> > On Monday 09 June 2008, Ryan Mallon wrote:
> >   
> >>> Talk to i2c and framebuffer people about changing the link order.
> >>>
> >>> i2c should really be initialised before framebuffer devices because
> >>> framebuffer devices tend to want to read DDC from monitors, which is
> >>> basically a I2C EEPROM in the monitor.

This is already the case. i2c-core is initialized with
subsys_initcall(), so it's available to all drivers initialized with
module_init().

> >>> ... but there's probably some reason why it's done the way it is today,
> >>> and changing it could well cause stuff to break.
> >>>       
> >> We have made i2c the first driver subsystem to come up in our 2.6.20
> >> kernel since we use i2c io expanders for power domain control. All we
> >> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is at
> >> the very top of the file. We didn't have any problems with doing this.
> >> YMMV of course.

Why don't you simply initialize the drivers in question with
subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
tps65010 are doing at the moment.

> > OMAP does much the same thing, for the same reason, and the I2C
> > adapter gets initialized earlier too (so power management chips
> > will be fully usable before driver_initcall code runs).
> >
> > Unless there's a downside on x86, I'd just suggest someone submit
> > a patch moving I2C init "early" so it merges in 2.6.27 ... cc to
> > LKML to scare out more potential problems, but I have a hard time
> > imagining there'd really be any.
>
> Okay, heres the patch. Is untested though (other than our experience 
> under 2.6.20), so it probably needs some people to test. I'm not 
> subscribed to LKML, so can people CC me if necessary.
> 
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index f65deda..9eaf236 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -5,6 +5,7 @@
>  # Rewritten to use lists instead of if-statements.
>  #
>  
> +obj-y				+= i2c/
>  obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/

Some i2c bus drivers bit-bang GPIO pins...

>  obj-$(CONFIG_PCI)		+= pci/

... and many are PCI devices, so will this work OK?

>  obj-$(CONFIG_PARISC)		+= parisc/
> @@ -61,7 +62,6 @@ obj-$(CONFIG_GAMEPORT)		+= input/gameport/
>  obj-$(CONFIG_INPUT)		+= input/
>  obj-$(CONFIG_I2O)		+= message/
>  obj-$(CONFIG_RTC_LIB)		+= rtc/
> -obj-y				+= i2c/
>  obj-$(CONFIG_W1)		+= w1/
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/


-- 
Jean Delvare
