Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZIAMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZIAMMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZIAMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:12:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbZIAMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:12:47 -0400
Date: Tue, 1 Sep 2009 13:12:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] AB3100 regulator support v1
Message-ID: <20090901121212.GI19719@n2100.arm.linux.org.uk>
References: <20090830103448.GD4334@sirena.org.uk> <Pine.LNX.4.44L0.0908301217410.10608-100000@netrider.rowland.org> <20090830190102.GA4235@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090830190102.GA4235@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 08:01:07PM +0100, Mark Brown wrote:
> On Sun, Aug 30, 2009 at 12:27:32PM -0400, Alan Stern wrote:
> > On Sun, 30 Aug 2009, Mark Brown wrote:
> 
> > > On the face of it (and without having actually looked at a running
> > > system or anything yet) I'm rather surprised that platform based MFD
> > > drivers aren't running into this issue more often.  CCing in Alan who
> > > made the change.
> 
> > I'm not at all familiar with the detailed issues involved here.  
> > Perhaps because of this, I don't see why there's any reason for
> > deadlocking.  __driver_attach() is invoked when a new driver is
> > registered; to avoid problems all you have to do is make sure you
> > aren't holding any device locks when you register a driver.
> 
> Ah, it's platform_driver_probe() that's causing issues.  When it is used
> the devices need to have been registered previously since the driver
> probe function isn't kept around.  In order to do this for the child
> device the driver for the subdevice has to be registered from within the
> probe function of the parent, which is itself happening within the
> parent device registration.

The simple solution to this is to avoid platform_driver_probe() in this
case.  platform_driver_probe() assumes that the device has already been
registered.  If it hasn't, then it really doesn't work.

Rather than plastering over platform_driver_probe() by playing games with
locks, it would be much better to do things the standard way and leave
the sub device probe code around such that it can cope with devices
registered after driver initialization.
