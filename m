Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYFJPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYFJPvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYFJPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:51:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYFJPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:51:05 -0400
Date: Tue, 10 Jun 2008 08:50:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@suse.cz>, linux-usb@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <200806101055.14539.oliver@neukum.org>
Message-ID: <alpine.LFD.1.10.0806100842420.3101@woody.linux-foundation.org>
References: <200806091712.46869.oliver@neukum.org> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org> <20080609215651.GF21429@elf.ucw.cz> <200806101055.14539.oliver@neukum.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jun 2008, Oliver Neukum wrote:
> 
> If a hotfix it must be, here's my take. It works for me, but it isn't
> tested well.
> Alan, what do you think?

Hmm. I hate making functions more complex. Especially if it's an area 
where we'd expect it to change in the future (ie I think we should aim for 
taking into account whether a device is actually open or not). So here's a 
cleaned-up alternative of your approach with the whole "is it persistent" 
logic separated out into a function of its own.

Then, some day, if we get back-pointers to open devices, or we get drievr 
hooks to say "am I mounted" or something, we have a logical place to do 
those things.

Is there perhaps already a way to know whether a driver is actually 
*active* or not (ie not just registered, but somebody has then opened it)? 
I guess there isn't. Oh, well.

		Linus

---
 drivers/usb/core/hub.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8eb4da3..3b0b58e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -644,6 +644,46 @@ static void hub_stop(struct usb_hub *hub)
 
 #ifdef CONFIG_PM
 
+static int persistent_device(struct usb_device *udev)
+{
+	int i, retval;
+	struct usb_host_config *actconfig;
+
+	/* Explicitly not marked persistent? */
+	if (!udev->persist_enabled)
+		return 0;
+
+	/* No active config? */
+	actconfig = udev->actconfig;
+	if (!actconfig)
+		return 0;
+
+	/* FIXME! We should check whether it's open here or not! */
+
+	/*
+	 * Check that all drivers on the active interface have a
+	 * 'reset_resume' entrypoint
+	 */
+	retval = 0;
+	for (i = 0; i < actconfig->desc.bNumInterfaces; i++) {
+		struct usb_interface *intf;
+		struct usb_driver *driver;
+
+		intf = actconfig->interface[i];
+		driver = to_usb_driver(intf->dev.driver);
+		if (!driver)
+			continue;
+		if (!driver->reset_resume)
+			return 0;
+		/*
+		 * We have at least one driver, and that one
+		 * supports 'reset_resume'
+		 */
+		retval = 1;
+	}
+	return retval;
+}
+
 static void hub_restart(struct usb_hub *hub, int type)
 {
 	struct usb_device *hdev = hub->hdev;
@@ -689,8 +729,8 @@ static void hub_restart(struct usb_hub *hub, int type)
 		 * turn off the various status changes to prevent
 		 * khubd from disconnecting it later.
 		 */
-		if (udev->persist_enabled && status == 0 &&
-				!(portstatus & USB_PORT_STAT_ENABLE)) {
+		if (status == 0 && !(portstatus & USB_PORT_STAT_ENABLE) &&
+		    persistent_device(udev)) {
 			if (portchange & USB_PORT_STAT_C_ENABLE)
 				clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_ENABLE);
