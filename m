Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYCUT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYCUT7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYCUT72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:59:28 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:34180 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753058AbYCUT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:59:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J1TeA4rv+Y2VqysYqjt1dC8N0cpLocQvoBfvZ9xm+cYEQgnbgMAqAs7ibPt5XDpEZgjTLKcxtNLb8kG8FU4kEm9fLzZCwY9/1f6GrFJHXBxThJ3wodFTzrDylqkkuxXJ1jferR7+vDV8aHSl6o3t0ok3ydqLm4E8mYGrXv9arzM=  ;
X-YMail-OSG: OMBGKggVM1kgnDo_cn4_vCnC.qHljiDtTiAOaNCS5ujhrC3Z.mKkY2olWtrpCjTpH_upo1uWpG2Z1W34yiT70oBBGwsH6s1SxHfr8OPxfBn7So2DyQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc6] hw_random doc updates
Date: Fri, 21 Mar 2008 12:59:25 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211259.25645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update documentation for the hw_random support to be current:

 - Documentation/hw_random.txt has been updated to reflect the
   current code:  it's a framework now, a "core" with a small
   sysfs interface, that hardware-specific drivers plug in to.
   Text specific to Intel hardware is now at the end.

 - Kconfig now references the Documentation/hw_random.txt file
   and better explains what this really does.

Both chunks of documentation now higlight the fact that the kernel
entropy pool is maintained by "rngd", and this driver has nothing
directly to do with that important task.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/hw_random.txt    |   59 +++++++++++++++++++++++++++--------------
 drivers/char/hw_random/Kconfig |    9 +++++-
 2 files changed, 48 insertions(+), 20 deletions(-)

--- osk2.orig/Documentation/hw_random.txt	2006-08-29 09:02:18.000000000 -0700
+++ osk2/Documentation/hw_random.txt	2008-03-21 12:48:24.000000000 -0700
@@ -1,33 +1,26 @@
-	Hardware driver for Intel/AMD/VIA Random Number Generators (RNG)
-	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
-	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
-
 Introduction:
 
-	The hw_random device driver is software that makes use of a
+	The hw_random framework is software that makes use of a
 	special hardware feature on your CPU or motherboard,
-	a Random Number Generator (RNG).
+	a Random Number Generator (RNG).  The software has two parts:
+	a core providing the /dev/hw_random character device and its
+	sysfs support, plus a hardware-specific driver that plugs
+	into that core.
 
-	In order to make effective use of this device driver, you
+	To make the most effective use of these mechanisms, you
 	should download the support software as well.  Download the
 	latest version of the "rng-tools" package from the
 	hw_random driver's official Web site:
 
 		http://sourceforge.net/projects/gkernel/
 
-About the Intel RNG hardware, from the firmware hub datasheet:
-
-	The Firmware Hub integrates a Random Number Generator (RNG)
-	using thermal noise generated from inherently random quantum
-	mechanical properties of silicon. When not generating new random
-	bits the RNG circuitry will enter a low power state. Intel will
-	provide a binary software driver to give third party software
-	access to our RNG for use as a security feature. At this time,
-	the RNG is only to be used with a system in an OS-present state.
+	Those tools use /dev/hw_random to fill the kernel entropy pool,
+	which is used internally and exported by the /dev/urandom and
+	/dev/random special files.
 
 Theory of operation:
 
-	Character driver.  Using the standard open()
+	CHARACTER DEVICE.  Using the standard open()
 	and read() system calls, you can read random data from
 	the hardware RNG device.  This data is NOT CHECKED by any
 	fitness tests, and could potentially be bogus (if the
@@ -36,9 +29,37 @@ Theory of operation:
 	a security-conscious person would run fitness tests on the
 	data before assuming it is truly random.
 
-	/dev/hwrandom is char device major 10, minor 183.
+	The rng-tools package uses such tests in "rngd", and lets you
+	run them by hand with a "rngtest" utility.
 
-Driver notes:
+	/dev/hw_random is char device major 10, minor 183.
+
+	CLASS DEVICE.  There is a /sys/class/misc/hw_random node with
+	two unique attributes, "rng_available" and "rng_current".  The
+	"rng_available" attribute lists the hardware-specific drivers
+	available, while "rng_current" lists the one which is currently
+	connected to /dev/hw_random.  If your system has more than one
+	RNG available, you may change the one used by writing a name from
+	the list in "rng_available" into "rng_current".
+
+==========================================================================
+
+	Hardware driver for Intel/AMD/VIA Random Number Generators (RNG)
+	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
+	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
+
+
+About the Intel RNG hardware, from the firmware hub datasheet:
+
+	The Firmware Hub integrates a Random Number Generator (RNG)
+	using thermal noise generated from inherently random quantum
+	mechanical properties of silicon. When not generating new random
+	bits the RNG circuitry will enter a low power state. Intel will
+	provide a binary software driver to give third party software
+	access to our RNG for use as a security feature. At this time,
+	the RNG is only to be used with a system in an OS-present state.
+
+Intel RNG Driver notes:
 
 	* FIXME: support poll(2)
 
--- osk2.orig/drivers/char/hw_random/Kconfig	2008-03-07 14:37:30.000000000 -0800
+++ osk2/drivers/char/hw_random/Kconfig	2008-03-21 12:40:32.000000000 -0700
@@ -9,7 +9,14 @@ config HW_RANDOM
 	  Hardware Random Number Generator Core infrastructure.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called rng-core.
+	  module will be called rng-core.  This provides a device
+	  that's usually called /dev/hw_random, and which exposes one
+	  of possibly several hardware random number generators.
+
+	  These hardware random number generators do not feed directly
+	  into the kernel's random number generator.  That is usually
+	  handled by the "rngd" daemon.  Documentation/hw_random.txt
+	  has more information.
 
 	  If unsure, say Y.
 
