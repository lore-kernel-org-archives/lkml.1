Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYFLSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYFLSov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYFLSok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:44:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:11848 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYFLSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:44:39 -0400
Date: Thu, 12 Jun 2008 20:44:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080612204408.6f0a3e04@hyperion.delvare>
In-Reply-To: <200806111131.50501.david-b@pacbell.net>
References: <200806091541.43899.u.luckas@road.de>
	<200806101355.07792.david-b@pacbell.net>
	<20080611101130.1a667abe@hyperion.delvare>
	<200806111131.50501.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 11 Jun 2008 11:31:50 -0700, David Brownell wrote:
> On Wednesday 11 June 2008, Jean Delvare wrote:
> > Hi David,
> > 
> > On Tue, 10 Jun 2008 13:55:07 -0700, David Brownell wrote:
> > > > Why don't you simply initialize the drivers in question with
> > > > subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> > > > tps65010 are doing at the moment.
> > > 
> > > If they happen to sit outside the I2C tree and *before* it in
> > > link order, things will misbehave.
> > 
> > Well, i2c system bus drivers shouldn't sit outside of the I2C tree, so
> > that's not a problem. If you start accepting that drivers live at
> > random places in the source tree, then there's simply no way to get
> > things right.
> 
> The "drivers in question" aren't necessarily all i2c_adapter drivers,
> or even *only* i2c_adapter drivers (they could expose an i2c_adapter
> interface as a secondary function).

Drivers exposing an i2c interface as a secondary function are, in my
experience, not drivers for system i2c bus. So, we just don't care
about them here.

Non-i2c_adapter drivers, are up to their respective subsystem
maintainers. i2c-core is initialized early thanks to subsys_initcall,
so if the needed i2c_adapter is also initialized early (be it thanks to
subsys_initcall or to the link order), my job, as the i2c subsystem
maintainer, is done.

> I think I introduced the term "system bus driver", but you didn't read
> it the way I meant it.  To elaborate a bit:  "system bus" as in "a bus
> used for system bringup and management".  On PCs, the main such bus is
> PCI but there are little fragments of other stuff too.  Many smaller
> embedded systems use I2C for that (and don't have PCI).  The drivers
> relevant are both (a) the bus driver itself, e.g. i2c_adapter or its
> PCI analogue, and (b) drivers for devices on that bus.
> 
> So while (a) having i2c and some i2c_adapter drivers at subsys_initcall
> is an essential first step, the *link order* issue comes up in two other
> ways:  (b1) drivers "outside the I2C tree and *before* it in link order"
> that may need to be subsys_initcall too, thus depending on core I2C
> stuff being available, and (b2) some other subsystems may need to rely
> on I2C in their bringup, such as by enabling a specific power domain
> and the chips using it.

(b1) and (b2) are the same problem as far as I can see, and is down to:
is the needed i2c_adapter driver initialized early enough. Which can be
solved by either using subsys_initcall in said driver, or by moving
said driver earlier in the link order. Do we agree on this? I think we
do.

> > (...)
> > These were only two examples. We have i2c bus drivers depending on PCI,
> > parport, USB, ISA, GPIO and serio. Given the current linking order,
> > this makes it impossible to move I2C up in the link order without
> > moving all these too.
> 
> Not really; those particular i2c_adapter drivers don't actually get used
> early in system bringup.  They aren't subsys_initcall, and neither of
> the (b1) or (b2) cases apply.  Moving those adapters doesn't imply moving
> those other subsystems.

If said subsystems are designed properly, I agree. But it they are not,
I suspect it's easier to not move the "external" i2c bus drivers, than
to fix these subsystems. But maybe I'm wrong on that.

> Example:  USB subsystem is initialized early (subsystem_init).  From then
> on, drivers can register freely -- including i2c-tiny-usb.  The usbcore
> code remembers them, and then when the HCDs (analogues: i2c_adapter) start
> to connect, usb devices enumerate and get bound to devices as needed.  So
> it doesn't matter *when* i2c-tiny-usb does its module_init(), so long as
> it's after usbcore does its subsys_initcall.

You're right, I had forgotten about subsys_initcall here, I was only
watching the link order. My bad.

> Likewise for PCI.  As I said earlier, GPIO is already covered (has to
> be usable before initcalls could be run, etc).  I think i2c-parport
> should behave OK too,

I have a doubt on parport, given that
  grep -r _initcall drivers/parport
doesn't return anything.

> and i2c-parport-light.

i2c-parport-light doesn't depend on anything (thus the name), so it
can't have any problem. I shouldn't have mentioned it, sorry.

> > My feeling is that we won't be able to solve this without first moving
> > the different type of i2c bus drivers (and possibly chip drivers) to
> > separate directories. For example, moving external I2C bus drivers
> > (i2c-parport-light, i2c-parport, i2c-taos-evm and i2c-tiny-usb) to a
> > separate directory that is always initialized late, would remove the
> > dependencies on parport, serio and USB for the "must initialize i2c
> > early" problem.
> 
> I think you're looking at this wrong.  First, as I noted already,
> most of those drivers don't have this issue.  Second, if there *are*
> such issues, they'd be bus-specific issues to resolve, not reasons
> to avoid fixing the (b1) and (b2) problems by moving I2C earlier.

Not a reason to not change the link order, you're right. But definitely
a good reason to watch for breakage as we do, so that we can fix them.

Now I am a bit confused as to your position about how to solve the
problem. In an earlier post, you were claiming that using
subsys_initcall in i2c bus drivers wasn't an abuse. And now you suggest
that moving i2c earlier in the build order is the way to go. As I
understand it we have no reason to do both. Or do we?

Thanks,
-- 
Jean Delvare
