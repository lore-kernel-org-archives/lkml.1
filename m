Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYC1Mya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYC1Mya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYC1MwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:52:09 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56328 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYC1MwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:52:08 -0400
Date: Fri, 28 Mar 2008 07:23:11 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 0/35] W1: w1 core deadlock and oops fixes, ds2490 updates
Message-ID: <20080328122311.GA3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:23:11 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The Linux one wire system allows talking to little devices, mostly
sensors.  Sensors such as temperature sensors that I want to put
around the house, but first the one wire system and ds2490 USB to one
wire controller driver needs to be stable.  After a kernel panic, I
did most all of the development inside of qemu.  I had an issue with
bulk transfers failing unless I told qemu to disconnect and reconnect
the USB device every time I reloaded, the module, but it worked really
nicely.  What follows is a long list of fixes and enhancements.  I
would like some tester feedback.  I only have the ds2490 USB to one
wire controller and ds18b20 thermometer.

This set of patches fixes bugs in the one wire driver and the ds2490
one wire USB controller.  Some of the bugs will deadlock the one wire
system and print out a message every second reminding you of this.
Others will panic the system.  One will spam with printk in an
infinite loop.  The w1_therm slave device driver would overflow the
userspace buffer, and didn't even work properly with `cat`.

In the name of being nice to the rest of the system, I've eliminated a
thread that was waking up and polling every second, for pretty much
only startup and shutdown events.  The other thread, w1_process, will
now block when there isn't anything to do, and if sleeping it will be
immediately woken for a new search or for preparing to exit.

ds2490 USB to one wire master driver has been improved.  The original
code was observed to take 3.91 seconds for a temperature conversion
and reading with 0.002s user and 3.001s system times.  The system was
very unresponsive, mostly due to some mdelay(750) calls.  Now it is
taking 0.860s elapsed with 0.004s user and 0.004s system time.  That
is pretty good considering that the temperature conversion takes 750ms
(rounded up to 752ms).  Some of the 108ms overload could be reduced by
a shorter reset period, overdrive data transfer speed, and combining
USB operations.  The driver now supports the strong pullup, which is
useful for parasite powered devices.

I was keeping track of my changes in cvs.  I've included the file, cvs
version number and log for that commit that make up the given patch.
The cvs number is just to help me keep everything organized to make
the patches.  The patches are against 2.6.25-rc4.

Signed-off-by: David Fries <david@fries.net>

--
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OMvAI852cse6PARAt+SAJsF/dgJcPXk8EWbPiGY5AchABZyFQCfYfBv
WWAgLuntto8HX9uUNmrZgJk=
=EFZ9
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
