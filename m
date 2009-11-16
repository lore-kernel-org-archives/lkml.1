Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZKPQFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZKPQFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZKPQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:05:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52907 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752758AbZKPQFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:05:18 -0500
Date: Mon, 16 Nov 2009 11:05:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@ucw.cz>, USB list <linux-usb@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>, <marcel@holtmann.org>,
       <linux-bluetooth@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: -rc6: something (probably active usb bluetooth) blocks suspend
In-Reply-To: <200911161447.51651.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0911161059470.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009, Oliver Neukum wrote:

> Am Samstag, 14. November 2009 12:10:21 schrieb Pavel Machek:
> > On Mon 2009-11-16 12:48:29, Oliver Neukum wrote:
> > > Am Montag, 16. November 2009 12:22:54 schrieb Pavel Machek:
> > >
> > > Hi Pavle,
> > >
> > :-)
> > :
> > > first the obvious question. Does it work if you down the interface?
> > > (not by killswitch)
> > 
> > Well, I'm not sure how repeatable it is. It happens once in two tries
> > today.
> 
> Ok, so it looks like a race.
> 
> > > > usb 5-1: usb suspend
> > > > usb 5-1: usb auto-resume
> > > > uhci_hcd 0000:00:1d.3: port 1 portsc 0095,01
> > > > usb 5-1: finish resume
> > > > uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23
> > > > us
> > >
> > > Why is the device autoresumed here? Are you using autosuspend?
> > > This is odd, as the freezer should block the send path and remote
> > > wakeups should be deferred.
> > 
> > I believe I have it enabled in kconfig but not during runtime.
> 
> Please check.

If you want to learn the source of the autoresume, do something like
this:

Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -2334,6 +2334,8 @@ int usb_port_resume(struct usb_device *u
 		/* drive resume for at least 20 msec */
 		dev_dbg(&udev->dev, "usb %sresume\n",
 				(msg.event & PM_EVENT_AUTO ? "auto-" : ""));
+		if ((msg.event & PM_EVENT_AUTO) && udev->maxchild == 0)
+			dump_stack();
 		msleep(25);
 
 		/* Virtual root hubs can trigger on GET_PORT_STATUS to

This will show you what is responsible for all autoresumes of non-hub 
USB devices.

Alan Stern

