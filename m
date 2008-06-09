Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYFIVQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYFIVQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYFIVQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:16:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33207 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYFIVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:16:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Mon, 9 Jun 2008 23:16:55 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <200806092231.32190.oliver@neukum.org> <dd18b0c30806091352g390b1e5dj11118bce07942ef6@mail.gmail.com>
In-Reply-To: <dd18b0c30806091352g390b1e5dj11118bce07942ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092316.56459.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 22:52:21 schrieb Justin Mattock:
> On Mon, Jun 9, 2008 at 8:31 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Montag 09 Juni 2008 22:29:05 schrieb Justin Mattock:
> >> On Mon, Jun 9, 2008 at 7:53 PM, Oliver Neukum <oliver@neukum.org> wrote:
> >> > Am Montag 09 Juni 2008 18:18:19 schrieb Justin Mattock:
> >
> >> >> Cool; just an update, I've suspended the system numerous times it
> >> >> seems appletouch is behaving correctly, in fact
> >> >> I think better, why: when I start the system I have two finger scroll
> >> >> functionality, then when suspending the system
> >> >> after waking up the two finger scroll is still functional.
> >> >> regards;
> >> >>
> >> >
> >> > With last week's patch or today's patch?
> >> >
> >> >        Regards
> >> >                Oliver
> >> >
> >> >
> >>
> >> Last weeks patch.
> >> regards;
> >>
> >
> > Could you also try today's patch?
> >
> >        Regards
> >                Oliver
> >
> >
> 
> Sure, where is it located.
> regards;
> 

Didn't I mail it to you? Anyway, here it is.

	Regards
		Oliver

----

--- linux-2.6.26-rc5/drivers/usb/core/quirks.c	2008-06-05 13:45:57.000000000 +0200
+++ linux-2.6.26-rc5-btusb/drivers/usb/core/quirks.c	2008-06-06 08:12:10.000000000 +0200
@@ -47,6 +47,9 @@ static const struct usb_device_id usb_qu
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* appletouch */
+	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Avision AV600U */
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
--- linux-2.6.26-rc5-btusb/drivers/input/mouse/appletouch.c.alt	2008-06-09 10:40:00.000000000 +0200
+++ linux-2.6.26-rc5-btusb/drivers/input/mouse/appletouch.c	2008-06-09 10:40:03.000000000 +0200
@@ -589,6 +589,20 @@ static void atp_close(struct input_dev *
 	dev->open = 0;
 }
 
+static int handle_geyser(struct atp *dev)
+{
+	struct usb_device *udev = dev->udev;
+
+	if (!atp_is_fountain(dev)) {
+		/* switch to raw sensor mode */
+		if (atp_geyser_init(udev))
+			return -EIO;
+
+		printk(KERN_INFO "appletouch: Geyser mode initialized.\n");
+	}
+	return 0;
+}
+
 static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id)
 {
 	struct atp *dev;
@@ -744,6 +758,20 @@ static void atp_disconnect(struct usb_in
 	printk(KERN_INFO "input: appletouch disconnected\n");
 }
 
+static int recover_dev(struct atp *dev)
+{
+	int rv;
+
+	rv = handle_geyser(dev);
+	if (rv < 0)
+		return rv;
+
+	if (dev->open && usb_submit_urb(dev->urb, GFP_NOIO))
+		return -EIO;
+
+	return 0;	
+}
+
 static int atp_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct atp *dev = usb_get_intfdata(iface);
@@ -764,12 +792,20 @@ static int atp_resume(struct usb_interfa
 	return 0;
 }
 
+static int atp_reset_resume(struct usb_interface *iface)
+{
+	struct atp *dev = usb_get_intfdata(iface);
+
+	return recover_dev(dev);
+}
+
 static struct usb_driver atp_driver = {
 	.name		= "appletouch",
 	.probe		= atp_probe,
 	.disconnect	= atp_disconnect,
 	.suspend	= atp_suspend,
 	.resume		= atp_resume,
+	.reset_resume	= atp_reset_resume,
 	.id_table	= atp_table,
 };
 

