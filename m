Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbZGGT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbZGGT6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbZGGT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:58:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50537 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756411AbZGGT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:58:25 -0400
Date: Tue, 7 Jul 2009 15:58:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>
Subject: Re: 2.6.31-rc2 warning in drivers/usb/host/ehci-hcd.c
In-Reply-To: <20090707182903.GA12101@Pilar.aei.mpg.de>
Message-ID: <Pine.LNX.4.44L0.0907071554150.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Carlos R. Mafra wrote:

> > My earlier message was wrong; the code in the option driver isn't 
> > really wrong.
> 
> OK, thanks for letting me know.

I take it back.  My original assessment was correct; the driver is 
messed up.

> > What were you doing when this occurred?  Can you get this to happen
> > again?  
> 
> This is easy to reproduce here. I simply have to attach the O2 surfstick
> (HUAWEI Model E 160) and try to connect using Mandriva's 'draknetcenter'.
> The warning appears at some point before connecting (either when it
> asks for the PIN number or when it is searching for the signal).
> But it connects and works afterwards.
> 
> > Can you collect a usbmon trace for when this happens?
> 
> I started to listen the device a few seconds before
> the warning and killed it a bit after. Nevertheless I trimmed the log
> a bit and removed some lines in the beginning/end to reduce its size.

The log was good.  The important part was near the beginning, and it 
proves that the driver isn't behaving the way it should.

> PS: I don't know if it is related, but I can't connect anymore
> after s2ram. 'draknetcenter' says that /dev/ttyUSB1 could not
> be openned (but I need to make more tests to provide more info)...

That's a separate issue.  We can explore it in greater depth if you 
want.

For now, here's a patch to fix the driver.  I don't know why the 
usb_clear_halt call was in there; it doesn't appear to serve any useful 
purpose.  Let me know how well the patch works.

Alan Stern



Index: usb-2.6/drivers/usb/serial/option.c
===================================================================
--- usb-2.6.orig/drivers/usb/serial/option.c
+++ usb-2.6/drivers/usb/serial/option.c
@@ -931,23 +931,11 @@ static int option_open(struct tty_struct
 
 	dbg("%s", __func__);
 
-	/* Reset low level data toggle and start reading from endpoints */
+	/* Start reading from the IN endpoint */
 	for (i = 0; i < N_IN_URB; i++) {
 		urb = portdata->in_urbs[i];
 		if (!urb)
 			continue;
-		if (urb->dev != serial->dev) {
-			dbg("%s: dev %p != %p", __func__,
-				urb->dev, serial->dev);
-			continue;
-		}
-
-		/*
-		 * make sure endpoint data toggle is synchronized with the
-		 * device
-		 */
-		usb_clear_halt(urb->dev, urb->pipe);
-
 		err = usb_submit_urb(urb, GFP_KERNEL);
 		if (err) {
 			dbg("%s: submit urb %d failed (%d) %d",
@@ -956,16 +944,6 @@ static int option_open(struct tty_struct
 		}
 	}
 
-	/* Reset low level data toggle on out endpoints */
-	for (i = 0; i < N_OUT_URB; i++) {
-		urb = portdata->out_urbs[i];
-		if (!urb)
-			continue;
-		urb->dev = serial->dev;
-		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe),
-				usb_pipeout(urb->pipe), 0); */
-	}
-
 	option_send_setup(port);
 
 	return 0;

