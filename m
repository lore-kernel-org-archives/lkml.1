Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXFXAPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXFXAPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXFXAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:15:00 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:60342 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXFXAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:14:59 -0400
Date: Sat, 23 Jun 2007 17:14:57 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [patch] 2.6.22-rc Kconfig troubles when using menuconfig
In-Reply-To: <1182637586.10174.36.camel@gaivota>
Message-ID: <Pine.LNX.4.58.0706231648290.4914@shell4.speakeasy.net>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota> 
 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> 
 <Pine.LNX.4.64.0706230915540.26568@fbirervta.pbzchgretzou.qr>
 <1182637586.10174.36.camel@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007, Mauro Carvalho Chehab wrote:
> Your patch seems OK to me, providing that we also add the Andreas patch:

>--- a/drivers/net/Kconfig
>+++ b/drivers/net/Kconfig
>menuconfig NETDEV_1000
>-	bool "Ethernet (1000 Mbit)"
>+	tristate "Ethernet (1000 Mbit)"
> 	depends on !UML
>-	default y
>
> menuconfig NETDEV_10000
>-	bool "Ethernet (10000 Mbit)"
>+	tristate "Ethernet (10000 Mbit)"
> 	depends on !UML
>-	default y

I don't think this part is necessary.  The only thing NETDEV_1000[0]
depend on is UML, which is a boolean.

Here is an alternate patch for this issue.  I fix it by adding the
dependencies of the menuconfig to the "if / endif" block the menuconfig
controls.  That way the menu doesn't turn into a tristate, which doesn't
make a lot of sense.  How can the menu be compiled as a module, when there
is no code associated with it?

------------------------------------------------------------------
Fix Kconfig dependency problems wrt boolean menuconfigs

If one has a dependency chain (tristate)FOO depends on (bool)BAR depends on
(tristate)BAZ, build problems will result.  If BAZ=m, then BAR can be set y,
which allows FOO=y.  It's possible to have FOO=y && BAZ=m, which wouldn't be
allowed if FOO depended directly on BAZ.  In effect, the bool promotes the
tristate from m to y.

This ends up causing a problem with several menuconfigs that look like:

menuconfig BAR
	bool
	depends on BAZ [tristate]
if BAR
config FOO
	tristate
endif

The solution used here is to add the dependencies of BAR to the if statement,
so that items in the if block will gain a direct non-bool-promoted dependency
on BAZ.  This is how it would work if a menu was used instead of an if block.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff -r dfbe7cc4e21e drivers/atm/Kconfig
--- a/drivers/atm/Kconfig	Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/atm/Kconfig	Sat Jun 23 16:41:05 2007 -0700
@@ -7,7 +7,7 @@ menuconfig ATM_DRIVERS
 	depends on NETDEVICES && ATM
 	default y

-if ATM_DRIVERS
+if ATM_DRIVERS && NETDEVICES && ATM

 config ATM_DUMMY
 	tristate "Dummy ATM driver"
diff -r dfbe7cc4e21e drivers/media/dvb/Kconfig
--- a/drivers/media/dvb/Kconfig	Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/media/dvb/Kconfig	Sat Jun 23 16:42:28 2007 -0700
@@ -11,7 +11,7 @@ menuconfig DVB_CAPTURE_DRIVERS
 	---help---
 	  Say Y to select Digital TV adapters

-if DVB_CAPTURE_DRIVERS
+if DVB_CAPTURE_DRIVERS && DVB_CORE

 comment "Supported SAA7146 based PCI Adapters"
 	depends on DVB_CORE && PCI && I2C
diff -r dfbe7cc4e21e drivers/media/radio/Kconfig
--- a/drivers/media/radio/Kconfig	Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/media/radio/Kconfig	Sat Jun 23 16:42:44 2007 -0700
@@ -9,7 +9,7 @@ menuconfig RADIO_ADAPTERS
 	---help---
 	  Say Y here to enable selecting AM/FM radio adapters.

-if RADIO_ADAPTERS
+if RADIO_ADAPTERS && VIDEO_DEV

 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
diff -r dfbe7cc4e21e drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig	Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/media/video/Kconfig	Sat Jun 23 17:10:17 2007 -0700
@@ -11,7 +11,7 @@ menuconfig VIDEO_CAPTURE_DRIVERS
 	  webcams, analog TV, and hybrid analog/digital TV.
 	  Some of those devices also supports FM radio.

-if VIDEO_CAPTURE_DRIVERS
+if VIDEO_CAPTURE_DRIVERS && VIDEO_DEV

 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality"
@@ -347,7 +347,7 @@ endmenu # encoder / decoder chips

 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64 && PCI && VIDEO_DEV
+	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64 && PCI
 	select VIDEO_BUF
 	default n
 	---help---
@@ -691,7 +691,7 @@ menuconfig V4L_USB_DRIVERS
 	depends on USB
 	default y

-if V4L_USB_DRIVERS
+if V4L_USB_DRIVERS && USB

 source "drivers/media/video/pvrusb2/Kconfig"

diff -r dfbe7cc4e21e drivers/net/pcmcia/Kconfig
--- a/drivers/net/pcmcia/Kconfig	Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/net/pcmcia/Kconfig	Sat Jun 23 16:45:44 2007 -0700
@@ -19,7 +19,7 @@ menuconfig NET_PCMCIA

 	  If unsure, say N.

-if NET_PCMCIA
+if NET_PCMCIA && PCMCIA

 config PCMCIA_3C589
 	tristate "3Com 3c589 PCMCIA support"
