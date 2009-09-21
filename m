Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZIUIEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZIUIEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZIUIEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:04:31 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:51275 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZIUIEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:04:30 -0400
X-IronPort-AV: E=Sophos;i="4.44,423,1249272000"; 
   d="scan'208";a="6612586"
Subject: RE: [spi-devel-general] [PATCH 1/2] spi: new SPI bus
 lock/unlockfunctions
From: Li Yi <yi.li@analog.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901D41FB1@mi8nycmail19.Mi8.com>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
	 <BD79186B4FD85F4B8E60E381CAEE190901D41E44@mi8nycmail19.Mi8.com>
	 <8bd0f97a0909171553s1b7ee725x728bbca2f49511a9@mail.gmail.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901D41FB1@mi8nycmail19.Mi8.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 16:08:36 +0800
Message-ID: <1253520516.3925.143.camel@adam-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2009 08:04:31.0415 (UTC) FILETIME=[26356470:01CA3A92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 19:00 -0400, H Hartley Sweeten wrote:
> On Thursday, September 17, 2009 3:54 PM, Mike Frysinger wrote:
> >> I assume the spi master driver must supply the {lock/unlock}_bus methods
> >> to properly support the locking.
> >
> > currently, yes.  a common solution would be nice.  ideas/patches welcome ;).
> >
> >> But, by returning 0 when the methods
> >> are not supplied you are basically saying all the current master drivers
> >> in mainline support bus locking.  I think this is really only "true" if
> >> spi->master->num_chipselect == 1.
> >
> > right, but that is no different from what we have today.  there is no
> > way for a client to guarantee exclusive access, so you cant write code
> > assuming it in the first place.  the only consumer thus far (mmc_spi)
> > actually errors out if such conditions exist.
> >
> > in other words, we arent breaking anything.
> 
> Actually you are breaking the mmc_spi driver.
> 
> By returning 0 when the methods are not supplied you are saying that the
> master driver supports and locked the bus.  At a minimum, I think spi_lock_bus()
> should return an error code if locking is not supported.
> 
Thanks for the feedback.

The original thought of returning '0' was trying not to break mmc_spi
driver on system without spi_lock_bus() implementation.
What do you think of a check in mmc_spi_probe() like this?

if (spi->master->num_chipselect > 1 && !spi->master->lock_bus) {
	struct count_children cc;

	cc.n = 0;
	cc.bus = spi->dev.bus;
	status = device_for_each_child(spi->dev.parent, &cc,
		maybe_count_child);
	if (status < 0) {
		dev_err(&spi->dev, "can't share SPI bus\n");
		return status;
	}

	dev_warn(&spi->dev, "ASSUMING SPI bus stays unshared!\n");
}

And spi_lock_bus() still returns 0 if not implemented.

> Also, as Andrew Morton pointed out, calling spi_unlock_bus() without having
> a valid lock by calling spi_lock_bus() is a bug.
> 
Will be fixed.

> In addition your patch to mmc_spi should check the return code from
> spi_lock_bus().  If the driver "requires" that the bus be locked it should
> trigger an error path if it cannot be locked.
> 
Will add code to check the return code. 
> >> Also, do you have a master driver that does have the {lock/unlock}_bus
> >> methods?  I would like to see how you handled it.
> >
> > http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=cc54fa8ed63e11a000031bc650d41d57b441803d
> 
> Oiy... The lock/unlock functions are simple enough but the change needed
> to bfin_spi_pump_messages() is a bit complicated.
> 
In spi_bf5xx.c, if a spi device (e.g, whose chip select number is "3")
locks the bus, the global status "locked" is set to "3" - indicates the
spi bus is locked.

> What happens to next_msg if it is for other devices on the bus?
> 
This spi message will be left in the queue until the spi bus is
unlocked. The messages for the spi device holding the lock will be
selected and transferred firstly. 

Regards,
-Yi

