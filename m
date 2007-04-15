Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXDOQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXDOQfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXDOQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:35:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXDOQfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:35:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 18:37:39 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151316.26136.rjw@sisk.pl> <200704150814.01747.david-b@pacbell.net>
In-Reply-To: <200704150814.01747.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151837.40756.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 April 2007 17:14, David Brownell wrote:
> On Sunday 15 April 2007 4:16 am, Rafael J. Wysocki wrote:
> > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> 
> > > > > > Yes, it's a Asus M2N-SLI-Deluxe Mainboard with a Athlon64 3200+
> > > > > > single core CPU.
> 
> And NVidia southbridge, so OHCI not UHCI (plus EHCI) ... one experiment
> would be to disable the EHCI (high speed USB) support in BIOS, to make
> for a simpler hardware configuration, and see if that makes BIOS happier.
> (Or better, just take EHCI out of your Linux config.)  Likewise, taking
> the 8042 drivers out of Linux.
> 
> I wouldn't be surprised if those factors didn't matter, but it'd be good
> to rule them out.

I think the disabling of i8042 support might help.

> > > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > > This is kinda interesting because I'm normally using a USB keyboard
> > > > and sure enough, if I hook up a normal keyboard and disable USB
> > > > legacy support in the BIOS, then suspend to disk works multiple
> > > > times. I'd still rather like to use my USB keyboard though. ;)
> > 
> > Well, I think that when you're using the USB keyboard and the USB legacy
> > support, the i8042 driver thinks it has a keyboard to handle and tries to
> > handle it during the suspend, which fails.  I don't know why it fails during
> > the second suspend, though.
> 
> The "legacy" support in at least some cases involves BIOS having a
> small USB stack -- enough to handle a keyboard or mouse in "boot mode"
> (plus sometimes a USB disk or CDROM) -- and poking the i8042 chip to
> act as if *IT* received the data bytes that really came over USB.

That's what happens here, I think.

> I sure don't know the ins-and-outs of such schemes (ISTR there are
> others), but my guess is that either the 8042 or OHCI got confused,
> at least in conjunction with the lowlevel magic ACPI was doing.

Yes.

> That's all black magic though, as far as I can understand it ...

Well, my theory is the following:

Without the patch, platform_finish() runs before the i8042's .resume() which is
done as though a real keyboard were present, but the ACPI magic is not done
and this confuses the heck out of the controller.  Still, it doesn't go mad at
this point just yet (it probably isn't fully functional either, although we
don't see that, because it's not really used), but next, during the subsequent
suspend, it gets poked while device_power_up() is running and goes belly
up.

> > Dmitry, could you please have a look?
> > 
> > > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > > as USB legacy support is disabled (however without legacy support I
> > > can't use the USB keyboard to control grub).
> > 
> > I think using the 'shutdown' mode of suspend would be better.  There's a little
> > point in using 'platform' on desktop systems anyway.
> > 
> > Frankly, I don't know what to do about it.  If we move platform_finish() after
> > device_resume(), some systems may be broken ...
> 
> What I'm curious about is exactly why the patch matters.  What ACPI
> magic is being invoked to confuse, or unconfuse, those controllers?

I think the patch helps, because it makes the ACPI magic be done while the
i8042's .resume() is being executed.

Which makes me think the following patch might help:

 drivers/input/serio/i8042.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc6/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.21-rc6.orig/drivers/input/serio/i8042.c	2007-04-07 12:15:19.000000000 +0200
+++ linux-2.6.21-rc6/drivers/input/serio/i8042.c	2007-04-15 18:30:01.000000000 +0200
@@ -846,7 +846,8 @@ static long i8042_panic_blink(long count
 static int i8042_suspend(struct platform_device *dev, pm_message_t state)
 {
 	if (dev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
+		if (state.event == PM_EVENT_SUSPEND
+		    || state.event == PM_EVENT_PRETHAW)
 			i8042_controller_reset();
 
 		dev->dev.power.power_state = state;
