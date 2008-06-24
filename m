Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYFXRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYFXRHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYFXRHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:07:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFXRHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:07:09 -0400
Date: Tue, 24 Jun 2008 19:06:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080624190648.00ebbf6c@hyperion.delvare>
In-Reply-To: <200806121257.47936.david-b@pacbell.net>
References: <200806091541.43899.u.luckas@road.de>
	<200806111131.50501.david-b@pacbell.net>
	<20080612204408.6f0a3e04@hyperion.delvare>
	<200806121257.47936.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Sorry for the late answer.

On Thu, 12 Jun 2008 12:57:47 -0700, David Brownell wrote:
> On Thursday 12 June 2008, Jean Delvare wrote:
> 
> > > So while (a) having i2c and some i2c_adapter drivers at subsys_initcall
> > > is an essential first step, the *link order* issue comes up in two other
> > > ways:  (b1) drivers "outside the I2C tree and *before* it in link order"
> > > that may need to be subsys_initcall too, thus depending on core I2C
> > > stuff being available, and (b2) some other subsystems may need to rely
> > > on I2C in their bringup, such as by enabling a specific power domain
> > > and the chips using it.
> > 
> > (b1) and (b2) are the same problem as far as I can see, and is down to:
> > is the needed i2c_adapter driver initialized early enough.
> 
> ... and *BEFORE* the "i2c_client" driver.  Moving I2C earlier in the
> link order may be necessary to ensure that.

Ah, I'm getting it now (it took time, sorry.) You want the i2c core and
bus driver to be available not to let the i2c client driver register (it
doesn't need the i2c bus driver for that) but to actually bind to and
initialize whatever device it is driving, because other subsystem need
this initialization to happen before themselves can work. That's the
part I had been missing from the beginning.

> Yes, (b2) is essentially the "30,000 foot view" of the problem for
> which (b1) is the lower altitude "5,000 foot view".  The PCI version
> of that problem has the relevant init code running at arch_initcall
> level (in at least those MIPS cases) and also getting linked before
> all the code in the "drivers" subtree.
> 
> 
> > Which can be 
> > solved by either using subsys_initcall in said driver, or by moving
> > said driver earlier in the link order. Do we agree on this?
> 
> No; that would be a case of moving other subsystems *AFTER* I2C in
> the link order, not moving any i2c_client driver earlier.

I think I had bus drivers in mind when I wrote that, not i2c client
drivers.

> Remember, you were wanting (appropriately!) to move drivers out of
> the i2c subtree when they have a better home.  And in this case,
> (b2) explains why that surfaces this requirement for earlier init
> of I2C ... if those drivers were in drivers/i2c/chips, the link order
> would not be an issue.

I think there would still be an issue as long as i2c is late in the
linking order. If i2c is early in the linking order and chip drivers
are in drivers/i2c/chips, I agree there is no problem. But as I already
said I don't want this to happen, it doesn't really matter.

> > (...)
> > Now I am a bit confused as to your position about how to solve the
> > problem. In an earlier post, you were claiming that using
> > subsys_initcall in i2c bus drivers wasn't an abuse. And now you suggest
> > that moving i2c earlier in the build order is the way to go. As I
> > understand it we have no reason to do both. Or do we?
> 
> We have reason to do both.  That's why I called out cases (a) vs (b)
> (and b1/b2) above.  They address different problems.
> 
> This is confusing stuff, in part because this part of initialization
> is all driven by side effects and is thus normally hidden.
> 
> The arch_initcall/subsys_initcall/device_initcall/... stuff (a) is at
> least partially explicit.  But the sequencing of initcalls within a
> given grouping (b) is purely a link order side effect.
> 
> So every time changing the link order comes up, confusion arises.

I think I have a clearer picture of the whole problem and dependencies
now, thanks. Meaning that anyone who has an actual problem with the
current link order is free to work up a patch and send it to me and
I'll review it. I won't be driving the effort myself, as I don't have
any system requiring these changes, I don't think I would be the right
person for the job.

-- 
Jean Delvare
