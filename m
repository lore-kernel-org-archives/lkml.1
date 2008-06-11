Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYFKHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYFKHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYFKHlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:41:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24089 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYFKHlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:41:07 -0400
Date: Wed, 11 Jun 2008 09:40:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080611094039.287ac136@hyperion.delvare>
In-Reply-To: <484F42AC.9030709@bluewatersys.com>
References: <200806091541.43899.u.luckas@road.de>
	<20080609135739.GE30971@flint.arm.linux.org.uk>
	<484D947D.1090900@bluewatersys.com>
	<200806091359.12791.david-b@pacbell.net>
	<484DA046.4010804@bluewatersys.com>
	<20080610085708.12c2d2a2@hyperion.delvare>
	<484F42AC.9030709@bluewatersys.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Wed, 11 Jun 2008 15:12:44 +1200, Ryan Mallon wrote:
> Jean Delvare wrote:
> > Why don't you simply initialize the drivers in question with
> > subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> > tps65010 are doing at the moment.
>
> I still think its a bit nasty marking a driver as subsys_initcall 
> just because one particular setup needs it to be that way. We will
> eventually end up with half of the busses/drivers in i2c marked
> as subsys_initcall for random boards :-).
> 
> How about this patch instead, which replaces module_init and 
> subsys_initcalls in drivers/i2c with a new macro called
> i2c_module_init. If CONFIG_I2C_EARLY is set then it will #define
> to subsys_initcall, otherwise it becomes module_init. This way
> boards that need i2c early can just select CONFIG_I2C_EARLY and
> get all of i2c at subsys_initcall time. The link order should
> guarantee that everything still comes up in the correct order in
> the i2c driver subsystem.
> 
> I have tested this on an ARM ep93xx board with a bit-bashed
> i2c bus, a ds1339 rtc, and two max7311 IO expanders (using 
> the pca953x) both with and without CONFIG_I2C_EARLY_INIT selected.
> Of course it would need much more testing to verify it :-)

Making this a compile time option means that you need different kernels
for different machines, that's highly inconvenient. Or you end up using
the I2C_EARLY_INIT one for all systems, but then why have a
configuration option for it in the first place?

Which problem are you trying to solve? Is there any actual drawback to
abusing subsys_initcall() for the handful of i2c bus drivers which may
need to come up early?

>  drivers/i2c/Kconfig                    |    3 +++
>  drivers/i2c/busses/i2c-acorn.c         |    2 +-
>  drivers/i2c/busses/i2c-ali1535.c       |    2 +-
>  drivers/i2c/busses/i2c-ali1563.c       |    2 +-
>  drivers/i2c/busses/i2c-ali15x3.c       |    2 +-
>  drivers/i2c/busses/i2c-amd756-s4882.c  |    2 +-
>  drivers/i2c/busses/i2c-amd756.c        |    2 +-
>  drivers/i2c/busses/i2c-amd8111.c       |    2 +-
>  drivers/i2c/busses/i2c-at91.c          |    2 +-
>  drivers/i2c/busses/i2c-au1550.c        |    2 +-
>  drivers/i2c/busses/i2c-bfin-twi.c      |    2 +-
>  drivers/i2c/busses/i2c-davinci.c       |    2 +-
>  drivers/i2c/busses/i2c-elektor.c       |    2 +-
>  drivers/i2c/busses/i2c-gpio.c          |    2 +-
>  drivers/i2c/busses/i2c-hydra.c         |    2 +-
>  drivers/i2c/busses/i2c-i801.c          |    2 +-
>  drivers/i2c/busses/i2c-i810.c          |    2 +-
>  drivers/i2c/busses/i2c-ibm_iic.c       |    2 +-
>  drivers/i2c/busses/i2c-iop3xx.c        |    2 +-
>  drivers/i2c/busses/i2c-ixp2000.c       |    2 +-
>  drivers/i2c/busses/i2c-mpc.c           |    2 +-
>  drivers/i2c/busses/i2c-mv64xxx.c       |    2 +-
>  drivers/i2c/busses/i2c-nforce2.c       |    2 +-
>  drivers/i2c/busses/i2c-ocores.c        |    2 +-
>  drivers/i2c/busses/i2c-omap.c          |    2 +-
>  drivers/i2c/busses/i2c-parport-light.c |    2 +-
>  drivers/i2c/busses/i2c-parport.c       |    2 +-
>  drivers/i2c/busses/i2c-pasemi.c        |    2 +-
>  drivers/i2c/busses/i2c-pca-isa.c       |    2 +-
>  drivers/i2c/busses/i2c-pca-platform.c  |    2 +-
>  drivers/i2c/busses/i2c-piix4.c         |    2 +-
>  drivers/i2c/busses/i2c-pmcmsp.c        |    2 +-
>  drivers/i2c/busses/i2c-pnx.c           |    2 +-
>  drivers/i2c/busses/i2c-powermac.c      |    2 +-
>  drivers/i2c/busses/i2c-prosavage.c     |    2 +-
>  drivers/i2c/busses/i2c-pxa.c           |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c       |    2 +-
>  drivers/i2c/busses/i2c-savage4.c       |    2 +-
>  drivers/i2c/busses/i2c-sh7760.c        |    2 +-
>  drivers/i2c/busses/i2c-sh_mobile.c     |    2 +-
>  drivers/i2c/busses/i2c-sibyte.c        |    2 +-
>  drivers/i2c/busses/i2c-simtec.c        |    2 +-
>  drivers/i2c/busses/i2c-sis5595.c       |    2 +-
>  drivers/i2c/busses/i2c-sis630.c        |    2 +-
>  drivers/i2c/busses/i2c-sis96x.c        |    2 +-
>  drivers/i2c/busses/i2c-stub.c          |    2 +-
>  drivers/i2c/busses/i2c-taos-evm.c      |    2 +-
>  drivers/i2c/busses/i2c-tiny-usb.c      |    2 +-
>  drivers/i2c/busses/i2c-versatile.c     |    2 +-
>  drivers/i2c/busses/i2c-via.c           |    2 +-
>  drivers/i2c/busses/i2c-viapro.c        |    2 +-
>  drivers/i2c/busses/i2c-voodoo3.c       |    2 +-
>  drivers/i2c/busses/scx200_acb.c        |    2 +-
>  drivers/i2c/busses/scx200_i2c.c        |    2 +-

Bus drivers i2c-ali1535, i2c-ali1563, i2c-ali15x3, i2c-amd756-s4882,
i2c-amd756, i2c-amd8111, i2c-i801, i2c-nforce2, i2c-piix4, i2c-sis5595,
i2c-sis630, i2c-sis96x, i2c-via and i2c-viapro are for PC machines,
where I2C is never needed early.

Bus drivers i2c-i810, i2c-prosavage and i2c-savage4 are gone, no need
to touch them.

Bus drivers i2c-parport-light, i2c-parport, i2c-taos-evm and
i2c-tiny-usb are for external adapters, so initializing them early
isn't going to work... They depend on parport, serio and usb,
respectively.

i2c-stub is a software only driver for testing purposes, initializing
it early is pointless (it's really only useful as a module.)

>  drivers/i2c/chips/ds1682.c             |    2 +-
>  drivers/i2c/chips/eeprom.c             |    2 +-
>  drivers/i2c/chips/isp1301_omap.c       |    2 +-
>  drivers/i2c/chips/max6875.c            |    2 +-
>  drivers/i2c/chips/menelaus.c           |    2 +-
>  drivers/i2c/chips/pca9539.c            |    2 +-
>  drivers/i2c/chips/pcf8574.c            |    2 +-
>  drivers/i2c/chips/pcf8575.c            |    2 +-
>  drivers/i2c/chips/pcf8591.c            |    2 +-
>  drivers/i2c/chips/tps65010.c           |    2 +-
>  drivers/i2c/chips/tsl2550.c            |    2 +-

Most of these chip drivers only expose sysfs interfaces. Having them
initializing early is pointless. Only a few power management drivers
may be needed early: isp1301_omap, menelaus, tps65010.

>  drivers/i2c/i2c-dev.c                  |    2 +-

User-space interface, never needed early.

>  include/linux/i2c.h                    |    6 ++++++
>  67 files changed, 74 insertions(+), 65 deletions(-)

At the very least, you should only touch the drivers which you know
need to be touched, rather than all drivers "just in case". But I don't
think this is the way to go anyway, unless you can point out an actual
problem with using subsys_initcall() unconditionally.

-- 
Jean Delvare
