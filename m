Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYFLT57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYFLT57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYFLT5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:57:51 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:29659 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754130AbYFLT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:57:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QM7HFMegrARSY6krdWwa07BPbMeM4YiQIyL+mBuPcJxkVn4Kpl5fx/yYywVbh/L+X1Bt0ePPbYmGg0uSJG7LZbGwpbgt/8DXgplJ+1M7P3zAZtjEZ3C9Q221V2WN6WEjGW0+d2qxdDD7b0iembVeDWShFRVvy/70s8VS/4XCsgY=  ;
X-YMail-OSG: paX9l9wVM1nZKHT0WttPJOJcZMDwX6tHZqSoWCmGSbPCx9wgCEnLZNRsj4.fzD2ZZ8wLalF0FP5ej_TgsqNaPXR5sgf.MGU2zZUUbaSmoMCeTt24ODq6IVY7no0G4xc.wv0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Date: Thu, 12 Jun 2008 12:57:47 -0700
User-Agent: KMail/1.9.9
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <200806091541.43899.u.luckas@road.de> <200806111131.50501.david-b@pacbell.net> <20080612204408.6f0a3e04@hyperion.delvare>
In-Reply-To: <20080612204408.6f0a3e04@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121257.47936.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008, Jean Delvare wrote:

> > So while (a) having i2c and some i2c_adapter drivers at subsys_initcall
> > is an essential first step, the *link order* issue comes up in two other
> > ways:  (b1) drivers "outside the I2C tree and *before* it in link order"
> > that may need to be subsys_initcall too, thus depending on core I2C
> > stuff being available, and (b2) some other subsystems may need to rely
> > on I2C in their bringup, such as by enabling a specific power domain
> > and the chips using it.
> 
> (b1) and (b2) are the same problem as far as I can see, and is down to:
> is the needed i2c_adapter driver initialized early enough.

... and *BEFORE* the "i2c_client" driver.  Moving I2C earlier in the
link order may be necessary to ensure that.

Yes, (b2) is essentially the "30,000 foot view" of the problem for
which (b1) is the lower altitude "5,000 foot view".  The PCI version
of that problem has the relevant init code running at arch_initcall
level (in at least those MIPS cases) and also getting linked before
all the code in the "drivers" subtree.


> Which can be 
> solved by either using subsys_initcall in said driver, or by moving
> said driver earlier in the link order. Do we agree on this?

No; that would be a case of moving other subsystems *AFTER* I2C in
the link order, not moving any i2c_client driver earlier.

Remember, you were wanting (appropriately!) to move drivers out of
the i2c subtree when they have a better home.  And in this case,
(b2) explains why that surfaces this requirement for earlier init
of I2C ... if those drivers were in drivers/i2c/chips, the link order
would not be an issue.


> > > (...)
> > > These were only two examples. We have i2c bus drivers depending on PCI,
> > > parport, USB, ISA, GPIO and serio. Given the current linking order,
> > > this makes it impossible to move I2C up in the link order without
> > > moving all these too.
> > 
> > Not really; those particular i2c_adapter drivers don't actually get used
> > early in system bringup.  They aren't subsys_initcall, and neither of
> > the (b1) or (b2) cases apply.  Moving those adapters doesn't imply moving
> > those other subsystems.
> 
> If said subsystems are designed properly, I agree. But it they are not,
> I suspect it's easier to not move the "external" i2c bus drivers, than
> to fix these subsystems. But maybe I'm wrong on that.

Missing my point:  since those i2c_adapter drivers aren't getting
used early (subsys_initcall etc), this issue *can't* come up with them.
Whether or not those subsystems "play well with others".  This issue
is *only* for drivers outside the i2c subtree which are essential for
system bringup, at the subsys_initcall level.


> > Likewise for PCI.  As I said earlier, GPIO is already covered (has to
> > be usable before initcalls could be run, etc).  I think i2c-parport
> > should behave OK too,
> 
> I have a doubt on parport, given that
>   grep -r _initcall drivers/parport
> doesn't return anything.

I see a bunch of module_init(), which means device_initcall(),
which means well after subsys_initcall().  So i2c-parport should
behave.


> > and i2c-parport-light.
> 
> i2c-parport-light doesn't depend on anything (thus the name), so it
> can't have any problem. I shouldn't have mentioned it, sorry.

Well, it's a legacy driver so automatically has that class of problems
(making its own device node etc) ... but those issues are unrelated to
the $SUBJECT issue.


> > > My feeling is that we won't be able to solve this without first moving
> > > the different type of i2c bus drivers (and possibly chip drivers) to
> > > separate directories. For example, moving external I2C bus drivers
> > > (i2c-parport-light, i2c-parport, i2c-taos-evm and i2c-tiny-usb) to a
> > > separate directory that is always initialized late, would remove the
> > > dependencies on parport, serio and USB for the "must initialize i2c
> > > early" problem.
> > 
> > I think you're looking at this wrong.  First, as I noted already,
> > most of those drivers don't have this issue.  Second, if there *are*
> > such issues, they'd be bus-specific issues to resolve, not reasons
> > to avoid fixing the (b1) and (b2) problems by moving I2C earlier.
> 
> Not a reason to not change the link order, you're right. But definitely
> a good reason to watch for breakage as we do, so that we can fix them.

Always.  :)


> Now I am a bit confused as to your position about how to solve the
> problem. In an earlier post, you were claiming that using
> subsys_initcall in i2c bus drivers wasn't an abuse. And now you suggest
> that moving i2c earlier in the build order is the way to go. As I
> understand it we have no reason to do both. Or do we?

We have reason to do both.  That's why I called out cases (a) vs (b)
(and b1/b2) above.  They address different problems.

This is confusing stuff, in part because this part of initialization
is all driven by side effects and is thus normally hidden.

The arch_initcall/subsys_initcall/device_initcall/... stuff (a) is at
least partially explicit.  But the sequencing of initcalls within a
given grouping (b) is purely a link order side effect.

So every time changing the link order comes up, confusion arises.

- Dave

