Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYFKIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYFKIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYFKIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:11:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34459 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYFKILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:11:54 -0400
Date: Wed, 11 Jun 2008 10:11:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080611101130.1a667abe@hyperion.delvare>
In-Reply-To: <200806101355.07792.david-b@pacbell.net>
References: <200806091541.43899.u.luckas@road.de>
	<484DA046.4010804@bluewatersys.com>
	<20080610085708.12c2d2a2@hyperion.delvare>
	<200806101355.07792.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 10 Jun 2008 13:55:07 -0700, David Brownell wrote:
> > Why don't you simply initialize the drivers in question with
> > subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> > tps65010 are doing at the moment.
> 
> If they happen to sit outside the I2C tree and *before* it in
> link order, things will misbehave.

Well, i2c system bus drivers shouldn't sit outside of the I2C tree, so
that's not a problem. If you start accepting that drivers live at
random places in the source tree, then there's simply no way to get
things right.

As for i2c chip drivers, that's the exact reason why I am urging
developers to create function-based subsystems rather than dumping
their drivers in drivers/i2c/chips. If we have all drivers implementing
a given function in a dedicated directory then we can sequence this
directory properly in the link order.

> Agreed init sequencing declarations should Do The Right Thing.
> But those declarations are of two types:  *_initcall() stuff,
> and link order.  We've seen cases where the initcalls alone are
> insufficient.
> 
> > >  
> > > +obj-y				+= i2c/
> > >  obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
> > 
> > Some i2c bus drivers bit-bang GPIO pins...
> > 
> > >  obj-$(CONFIG_PCI)		+= pci/
> > 
> > ... and many are PCI devices, so will this work OK?
> 
> The gpiochip_add() function needed a bit of care to ensure that
> platforms can use GPIOs well before tasking and IRQs work, and
> thus before any initcalls run.  So that's not a problem.
> 
> Re PCI ... someone could investigate.

These were only two examples. We have i2c bus drivers depending on PCI,
parport, USB, ISA, GPIO and serio. Given the current linking order,
this makes it impossible to move I2C up in the link order without
moving all these too.

Also note that we are planing on depending on ACPI for the PC I2C bus
drivers. Which is a problem because video apparently wants to
initialize before ACPI, and now we want to initialize i2c before video.

> For the record, the OMAP tree puts I2C in the link order
> later than this.  It wasn't moved earlier mostly out of
> paranoia like yours.  (See below.  I'm not sure why "cbus"
> is listed twice, or what OMAP boards have similar issues
> with serio ...)

That's easier to get right if you restrict yourself to a single
platform. For the vanilla kernel, the order of the dependencies is way
more difficult to figure out and get right. There are some hints in
drivers/Makefile but most dependencies aren't spelled out.

My feeling is that we won't be able to solve this without first moving
the different type of i2c bus drivers (and possibly chip drivers) to
separate directories. For example, moving external I2C bus drivers
(i2c-parport-light, i2c-parport, i2c-taos-evm and i2c-tiny-usb) to a
separate directory that is always initialized late, would remove the
dependencies on parport, serio and USB for the "must initialize i2c
early" problem.

I've already attempted a categorization of the i2c bus drivers:
http://lists.lm-sensors.org/pipermail/i2c/2008-May/003713.html
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/i2c-group-bus-drivers.patch
I would welcome comments on this, and suggestions for further
categorization of group "other".

I guess we would need to go one step beyond and move the different
groups to different directories. I'm not too happy about moving files
as it makes history navigation a bit harder, but in this specific case
I see no other way.

-- 
Jean Delvare
