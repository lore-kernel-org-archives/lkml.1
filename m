Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXKSUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXKSUha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXKSUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:37:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:42094 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751038AbXKSUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:37:21 -0500
X-Authenticated: #24222693
X-Provags-ID: V01U2FsdGVkX1/argU+dTLamgSDxyYOvA+QGAsVTM1JpBya87Afsw
	JvQ07ipNS2s4LX
From: Robert Gerlach <khnz@gmx.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Date: Mon, 19 Nov 2007 21:37:13 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200711191350.31965.khnz@gmx.de> <20071119092633.42d6d6b0@freepuppy.rosehill>
In-Reply-To: <20071119092633.42d6d6b0@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711192137.14747.khnz@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 19 November 2007 18:26:32 schrieben Sie:
> On Mon, 19 Nov 2007 13:50:30 +0100
>
> Robert Gerlach <khnz@gmx.de> wrote:
> > Am Montag 19 November 2007 05:43:07 schrieb Stephen Hemminger:
> > > On Sun, 18 Nov 2007 23:36:58 +0100
> > >
> > > Robert Gerlach <khnz@gmx.de> wrote:
> > > > Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> > > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> > > >
> > > > Please make sure that this module is not autoload on Lifebook tablets
> > > > (T series and P1[56]10). It works fine, but only supports a subset of
> > > > features (4 of 7 buttons and no display orientation for my T4010).
> > >
> > > I would rather get those tablets working (with help). Rather than
> > > trying to enumerate all the possible DMI values of the full range of
> > > different laptops.
> >
> > I've played with apanel some month ago. I've never found the keys and the
> > switch over the I2C bus. So I was starting my own module (fsc_btns) to
> > play with the IO range announced by ACPI. There I found it all. But my
> > module doesn't work on all Lifebooks (S7110 for example; has no such ACPI
> > device).
>
> If the device doesn't have the buttons, then the probe routine won't find
> them and it should just exit and unload itself.  Now it may be too noisy
> right now and it might not detect properly, if so, that is where the bug
> is.

Sorry, bad writing. What I want to say, apanel loads fine and works for the 4 
keys. Apanel and fsc_btns works side by side too and (in this case) keys 
reported twice, that's the bug.

For my T4010, apanel found 2 devices, devno 1 and 6 both with method=4 chip=4 
slave=25. The working keys are scrolldown (reported as prog2), scrollup 
(prog1), display rotation (www) and Fn (mail). If I find a way to make the 
other keys work, I will happily add it. Currently I have no idea.

By the way, input-kbd segv for apanel on my box. This fixed it for me:
--- orig/apanel.c	2007-11-19 20:41:58.000000000 +0100
+++ apanel.c	2007-11-19 20:44:54.000000000 +0100
@@ -274,8 +274,8 @@
 	idev->phys = "apanel/input0";
 	idev->id.bustype = BUS_HOST;
 	idev->dev.parent = &ap->client.dev;
-	idev->getkeycode = apanel_getkeycode;
-	idev->setkeycode = apanel_setkeycode;
+	idev->keycode = ap->keymap;
+	idev->keycodesize = sizeof(ap->keymap[0]);
 
 	set_bit(EV_KEY, idev->evbit);
 

  Robert
