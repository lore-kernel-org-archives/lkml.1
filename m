Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZGCMgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZGCMgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZGCMgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:36:41 -0400
Received: from starsky.19inch.net ([193.28.45.41]:37331 "EHLO
	starsky.19inch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZGCMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:36:40 -0400
X-Greylist: delayed 1770 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 08:36:40 EDT
Date: Fri, 3 Jul 2009 13:06:30 +0100 (BST)
From: Paul Sladen <lkml@paul.sladen.org>
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: Sean Young <sean@mess.org>, Michael Hofmann <mh21@piware.de>
Subject: igotU mini GPS datalogger (navman/non-standard usb-serial)
Message-ID: <Pine.LNX.4.21.0907031016210.19803-100000@starsky.19inch.net>
X-GPG-Key: DSA/E90CFA24
X-message-flag: Please use plain text when replying--not HTML.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This matchbox-sized GPS logger presents a non-standard serial point.

There is a single incoming endpoint 0x81; reading from this gets you NMEA
sentences[4]---so the USB ID (0df7:0900) was added to to the 'navman' module
back in March 2009.[0] This gets you _live_ GPS data, but not access to the
flash/datalog (which is what makes the device useful/interesting!).

Somebody else later got some traces[1] from the supplied Win32
software/driver and the outgoing writes to the device are done via
USB control messages; eg:

   usb_control_msg(type=0x21, req=0x09, value=0x0200, index=0, length <= 8)

   //  req 0x09 == USB_REQ_SET_CONFIGURATION (?)
   // type 0x21 == USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_ENDPOINT_OUT ?

This allows reading/writing/fetching various registers/flash blocks.

That is working to a point from userspace; the ideal might be to just have
the kernel expose a standard bi-directional serial port (the current
'navman.ko' currently silently drops out-going writes) and let
userspace/gpsbabel write to that, thus still allowing NMEA dumping to work
out of the box like any other GPS and to add the rest to gpsbabel.

In terms of similarly accessed hardware, the closest I found---using
equivalent write method (so likely to be the same usb<->serial chip) is a
proposed 'usb/misc/phidgetservo.c' driver[2] that later ended up in-tree as
a whole suite of phidget*.  Some "iMON VFD/LCD" (2x16 text read-out thingy)
appears to be doing a similar thing too[3].

Does the access method in question ring a bell as being close to any of the
other drivers?

	-Paul

[0] http://thread.gmane.org/gmane.linux.usb.general/15802
[1] http://launchpad.net/igotu2gpx/+download
[2] http://lwn.net/Articles/82642/
[3] http://codeka.com/forums/viewtopic.php?f=3&t=23&st=0&sk=t&sd=a#p148
[4] http://www.paul.sladen.org/toys/igotu/test.py
-- 
Why do one side of a triangle when you can do all three.  Somewhere, GB.

