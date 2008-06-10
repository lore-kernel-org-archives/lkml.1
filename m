Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbYFJIzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbYFJIzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYFJIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:55:00 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33019 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYFJIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:54:59 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Pavel Machek <pavel@suse.cz>, linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Date: Tue, 10 Jun 2008 10:55:13 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200806091712.46869.oliver@neukum.org> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org> <20080609215651.GF21429@elf.ucw.cz>
In-Reply-To: <20080609215651.GF21429@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101055.14539.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 23:56:51 schrieb Pavel Machek:
> On Mon 2008-06-09 14:39:10, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 9 Jun 2008, Pavel Machek wrote:
> > > 
> > > I believe we should just revert the "CONFIG_USB_PERSIST force on"
> > > patch, and solve this properly in 2.6.27.
> > 
> > Why?
> > 
> > The code would _still_ be buggy with that revert in place. You have to 
> > enable CONFIG_USB_PERSIST just to get even the _possibility_ of the sane 
> > behavior. 
> > 
> > If there is a problem with usblp, it just needs to be fixed. 
> 
> With USB_PERSIST on, you have problem on all drivers but usb-storage,
> AFAICT... because usb-storage seems to be the only driver implementing
> reset_resume.
> 
> I guess it is possible to do something like "if reset_resume() is
> unavailable, try plain resume()" in usb/driver.c, but I'd really
> changes to the suspend/resume callback to go in -rc1 so that they are
> tested properly, and not hot-patch it now.

If a hotfix it must be, here's my take. It works for me, but it isn't
tested well.
Alan, what do you think?

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>

---

--- linux-2.6.25/drivers/usb/core/hub.c	2008-06-09 15:15:13.105058000 +0200
+++ alt/drivers/usb/core/hub.c	2008-06-09 15:43:29.964503000 +0200
@@ -648,7 +648,9 @@ static void hub_stop(struct usb_hub *hub
 static void hub_restart(struct usb_hub *hub, int type)
 {
 	struct usb_device *hdev = hub->hdev;
-	int port1;
+	struct usb_interface *intf;
+	struct usb_driver *driver;
+	int port1, i;
 
 	/* Check each of the children to see if they require
 	 * USB-PERSIST handling or disconnection.  Also check
@@ -692,6 +694,14 @@ static void hub_restart(struct usb_hub *
 		 */
 		if (udev->persist_enabled && status == 0 &&
 				!(portstatus & USB_PORT_STAT_ENABLE)) {
+
+			/* check for devices not supporting reset_resume */
+			for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
+				intf = udev->actconfig->interface[i];
+				driver = to_usb_driver(intf->dev.driver);
+				if (!driver || !driver->reset_resume)
+					goto skip_reset_resume;
+			}
 			if (portchange & USB_PORT_STAT_C_ENABLE)
 				clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_ENABLE);
@@ -705,8 +715,11 @@ static void hub_restart(struct usb_hub *
 		 * but as we may not lock the child device here
 		 * we have to do a "logical" disconnect.
 		 */
-		else if (type == HUB_RESET_RESUME)
-			hub_port_logical_disconnect(hub, port1);
+		else {
+skip_reset_resume:
+			if (type == HUB_RESET_RESUME)
+				hub_port_logical_disconnect(hub, port1);
+		}
 	}
 
 	hub_activate(hub);
