Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZBVKkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZBVKkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZBVKkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:40:24 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:47850 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZBVKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:40:24 -0500
Date: Sun, 22 Feb 2009 11:40:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222114000.137cc754@hyperion.delvare>
In-Reply-To: <20090222102217.GB28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
	<20090222011936.35b21d6b@i1501.lan.towertech.it>
	<20090222082829.GG16596@n2100.arm.linux.org.uk>
	<20090222105205.4e8165da@hyperion.delvare>
	<20090222102217.GB28025@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 10:22:17 +0000, Russell King - ARM Linux wrote:
> On Sun, Feb 22, 2009 at 10:52:05AM +0100, Jean Delvare wrote:
> > Russell,
> > 
> > On Sun, 22 Feb 2009 08:28:29 +0000, Russell King - ARM Linux wrote:
> > > So, really, I'm not listening to NACKs from anyone for this.  The only
> > > thing I'll listen to is something _constructive_ to make it work again.
> > > I'm sure Andrew Morton will back me up on this.
> > 
> > ... and now you say we should fix it in the day and then threaten us?
> > Come on.
> 
> I'm serious.  It's a regression, it needs fixing.
> 
> > > The problem is that this *is* a regression, and therefore must be fixed
> > > in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
> > > the conversion until a proper fix can be done.
> > 
> > You can't claim it is a regression that must be fixed in 2.6.29,
> > because it is already broken in 2.6.28, and even 2.6.27, and nobody
> > complained.
> 
> Sorry, our definitions of what's a regression are different, and you are
> wrong.  As I've already said to you, it worked in 2.6.25-rc and it worked
> last time I tested which was a 2.6.27-rc kernel.

Maybe I'm wrong but at least I am polite.

And I pretty much doubt it worked with a 2.6.27-rc kernel, given that
the patch which broke it went into 2.6.27-rc1. So you are just as wrong
as I am.

> If every single kernel has to be tested on every single machine to find
> "regressions" in your terminology, that's all I'd be doing.  Get real.
> It's not practical to do that.
> 
> So, yes, I'm going to continue claiming that this is a regression and
> needs to be fixed.
> 
> > > So, please provide constructive suggestions on how to add boardinfo to
> > > this in a sane way, or we revert PCF8583 back to something which works.
> > 
> > Alessandro nicely proposed to solve your problem the right way if you
> > provided the required technical information, which, as far as I can
> > see, you didn't. I asked for hardware details and you didn't provide
> > them either.
> 
> I'm sorry, what hardware details are you wanting that I didn't give.
> I've said it's the PCF8583 driver.  I've said that the bus driver is
> i2c-acorn.c, even giving its location in the kernel tree.
> 
> It's a bit banged I2C bus.  It's on the main board.  It's connected to
> expansion cards.  It uses 5V signalling with pull up resistors.
> 
> I don't think I've missed anything out.
> 
> > So let me ask more precise questions, and hopefully we will get
> > somewhere.
> > 
> > 1* How many different system types is i2c-acorn used on?
> 
> It used to be used on four, two of which have been long since removed,
> and one was removed in the last merge window.  So it's now only used on
> one platform.
> 
> > 2* Do all these systems have a PCF8583 RTC chip?
> 
> Yes.
> 
> > 3* At which address does the PCF8583 chip live on these systems? I
> >    guess 0x50.
> 
> Looking back in the history of the driver, yes, it's 0x50.
> 
> > 4* Is there any acorn-specific piece of code which is run when the
> >    Linux kernel boots?
> 
> For the riscpc, arch/arm/mach-rpc
> 
> > Depending on the answer to these questions, I can think of 3 different
> > nice ways to fix the regression. Reverting
> > 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 is not one of them,
> 
> Well, I've tried it, and unfortunately it doesn't work.  The result is
> that with the board_info in place, the i2c-acorn bus seems to no longer
> be registered as bus 0, but becomes bus 1.

The following patch should fix it:

---
 drivers/i2c/busses/i2c-acorn.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.29-rc5.orig/drivers/i2c/busses/i2c-acorn.c	2009-02-21 14:33:57.000000000 +0100
+++ linux-2.6.29-rc5/drivers/i2c/busses/i2c-acorn.c	2009-02-22 11:33:10.000000000 +0100
@@ -83,6 +83,7 @@ static struct i2c_algo_bit_data ioc_data
 };
 
 static struct i2c_adapter ioc_ops = {
+	.nr			= 0,
 	.algo_data		= &ioc_data,
 };
 
@@ -90,7 +91,7 @@ static int __init i2c_ioc_init(void)
 {
 	force_ones = FORCE_ONES | SCL | SDA;
 
-	return i2c_bit_add_bus(&ioc_ops);
+	return i2c_bit_add_numbered_bus(&ioc_ops);
 }
 
 module_init(i2c_ioc_init);

> > because 1*
> > it would potentially cause regressions on other systems and 2* it would
> > make the rtc-pcf8583 driver use an API which is marked as deprecated.
> 
> That's bullshit in light of the fact that this used to work, but then
> a patch was merged which stopped it working.  That's a regression on
> the main platform which PCF8583 was written for.  Plain and simple.


-- 
Jean Delvare
