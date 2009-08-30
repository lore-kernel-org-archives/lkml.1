Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZH3Kez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZH3Kez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 06:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZH3Key
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 06:34:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50218 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZH3Key (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 06:34:54 -0400
Date: Sun, 30 Aug 2009 11:34:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Message-ID: <20090830103448.GD4334@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
 <20090821105636.GA2850@sirena.org.uk>
 <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.6.104.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] AB3100 regulator support v1
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 01:03:38AM +0200, Linus Walleij wrote:

[While setting up a child platform device from a platform driver
probe...]

> >> +     /* This would seem logical but makes everything break... */
> >> +     /* pdev->dev.parent = parent; */

> > Err...  it does?  In what way?

> The sub-platform devices are added, but when I add a platform driver for
> them, the probing does not commence, because they hang in
> driver base/dd.c: __driver_attach() trying to take the parent semaphore,
> i.e. this line:

> 	if (dev->parent)	/* Needed for USB */
> 		down(&dev->parent->sem);

> In this case the parent is ab3100-regulators, the platform device for
> the set of regulators.

On the face of it (and without having actually looked at a running
system or anything yet) I'm rather surprised that platform based MFD
drivers aren't running into this issue more often.  CCing in Alan who
made the change.

However, fixing this is not required to avoid the issue for this
particular driver.  The problem is being caused because in addition to
the core MFD driver for the device you've chosen to create both a
platform device covering all regulators and further per-regulator child
platform devices.  If you create only one level of child device for the
MFD you'll avoid the issue because your core device is an I2C device.
Either have a device per regulator or have a single device which
registers multiple regulators.  The regulator API doesn't mind what you
do so long as it gets a parent for the class device so do whatever seems
sensible for your driver.
