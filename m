Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYC3L2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYC3L2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYC3L1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:27:51 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44593 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYC3L1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:27:50 -0400
Date: Sun, 30 Mar 2008 15:27:16 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/35] W1: w1 core deadlock and oops fixes, ds2490 updates
Message-ID: <20080330112716.GB15122@2ka.mipt.ru>
References: <20080328122311.GA3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122311.GA3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Fri, Mar 28, 2008 at 07:23:11AM -0500, David Fries (david@fries.net) wrote:
> The Linux one wire system allows talking to little devices, mostly
> sensors.  Sensors such as temperature sensors that I want to put
> around the house, but first the one wire system and ds2490 USB to one
> wire controller driver needs to be stable.  After a kernel panic, I
> did most all of the development inside of qemu.  I had an issue with
> bulk transfers failing unless I told qemu to disconnect and reconnect
> the USB device every time I reloaded, the module, but it worked really
> nicely.  What follows is a long list of fixes and enhancements.  I
> would like some tester feedback.  I only have the ds2490 USB to one
> wire controller and ds18b20 thermometer.

Well, in our private converstion you never showed kernel panic dump or
at least talks about where it was located, but nevertheless I'm overall
ok with your changes. I ack all ds2490 changes and generally do not
object against others, although description of them some times are
really wrong, like what you call a deadlock was intended - driver
specially can not be unloaded while there are users of given bus.

There is another problem with your submission - please split it into 3-5
patches which are logically compound, so that there would not be things
like: patch1: replace A with B, patch2: remove B and the like.
You also have lots of codying style issues in the patchset.

> This set of patches fixes bugs in the one wire driver and the ds2490
> one wire USB controller.  Some of the bugs will deadlock the one wire
> system and print out a message every second reminding you of this.
> Others will panic the system.  One will spam with printk in an
> infinite loop.  The w1_therm slave device driver would overflow the
> userspace buffer, and didn't even work properly with `cat`.

The latter is wrong, and you never showed signs of previous errors,
but looking at the end results I agree that it is better solution
(especially eliminating of the additional thread and related changes).

> In the name of being nice to the rest of the system, I've eliminated a
> thread that was waking up and polling every second, for pretty much
> only startup and shutdown events.  The other thread, w1_process, will
> now block when there isn't anything to do, and if sleeping it will be
> immediately woken for a new search or for preparing to exit.
> 
> ds2490 USB to one wire master driver has been improved.  The original
> code was observed to take 3.91 seconds for a temperature conversion
> and reading with 0.002s user and 3.001s system times.  The system was
> very unresponsive, mostly due to some mdelay(750) calls.  Now it is
> taking 0.860s elapsed with 0.004s user and 0.004s system time.  That
> is pretty good considering that the temperature conversion takes 750ms
> (rounded up to 752ms).  Some of the 108ms overload could be reduced by
> a shorter reset period, overdrive data transfer speed, and combining
> USB operations.  The driver now supports the strong pullup, which is
> useful for parasite powered devices.

Yeah, mdelay was not a good solution.

> I was keeping track of my changes in cvs.  I've included the file, cvs
> version number and log for that commit that make up the given patch.
> The cvs number is just to help me keep everything organized to make
> the patches.  The patches are against 2.6.25-rc4.

Please reorganize your patches into something like this:
1. threads changes
2. master device removal changes (remove slaves which are on the bus
master being removed) and related things
3. ds2490 changes
4. cleanups

or something like that, reviewing 35 small patches which are removing
things past another is not a really good time...

Thank you. I will comment on separate patches.

-- 
	Evgeniy Polyakov
