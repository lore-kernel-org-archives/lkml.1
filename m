Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbXFVUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbXFVUUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXFVUUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:20:43 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:52925 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXFVUUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:20:42 -0400
Date: Fri, 22 Jun 2007 13:20:41 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net,
       =?X-UNKNOWN?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in	zc0301_core.c
In-Reply-To: <1182518566.14289.20.camel@gaivota>
Message-ID: <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it> <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Mauro Carvalho Chehab wrote:
> Hi Roman,
>
> Several instabilities on Kconfig started to happen after replacing
> Kconfig menus to use menuconfig, as this one, reported by Oliver:

This is the same problem I explained before:
http://www.linuxtv.org/pipermail/v4l-dvb-maintainer/2007-May/004121.html

What you have is tristate depends on bool depends on tristate.  The bool
between the two tristates "promotes" the first tristate from m to y.

> In this specific case, all V4L USB drivers depends on V4L_USB_DRIVERS,
> that depends, in turn, on USB. So, if USB is not selected,
> V4L_USB_DRIVERS should be unselected, unselecting zc0301.

If you set USB=n, then you can not turn on V4L_USB_DRIVERS and in turn
USB_ZC0301 can't be turned on.  That does work correctly.

The problem is that if USB=m, then because V4L_USB_DRIVERS is a bool, it is
possible to set V4L_USB_DRIVERS=y.  Now you can set USB_ZC0301=y, because
USB_ZC0301 only depends on V4L_USB_DRIVERS and that is 'y'.  So you end up
with USB=m and USB_ZC0301=y, which shouldn't be allowed.

There are two easy solutions to this that I can think of.  First,
just make the menuconfig a tristate:
diff -r dfbe7cc4e21e drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig       Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/media/video/Kconfig       Fri Jun 22 13:14:29 2007 -0700
@@ -687,7 +687,7 @@ config VIDEO_CAFE_CCIC
 #

 menuconfig V4L_USB_DRIVERS
-       bool "V4L USB devices"
+       tristate "V4L USB devices"
        depends on USB
        default y

Now the menuconfig entry will be a tristate, which seems kind of odd.  If
USB=m, then you won't be able to set V4L_USB_DRIVERS to 'y', only to 'n' or
'm', and in turn none of the USB devices can be set to 'y'.

Or another way, add the dependencies of the menuconfig to the if statement:
diff -r dfbe7cc4e21e drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig       Thu Jun 21 16:02:50 2007 -0700
+++ b/drivers/media/video/Kconfig       Fri Jun 22 13:10:43 2007 -0700
@@ -691,7 +691,7 @@ menuconfig V4L_USB_DRIVERS
        depends on USB
        default y

-if V4L_USB_DRIVERS
+if V4L_USB_DRIVERS && USB

 source "drivers/media/video/pvrusb2/Kconfig"

Now all the usb drivers will gain USB as a dependency directly and can't be
set to something higher than USB.
