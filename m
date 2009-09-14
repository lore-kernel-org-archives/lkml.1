Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZINKNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZINKNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZINKNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:13:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:39278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZINKNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:13:30 -0400
Date: Mon, 14 Sep 2009 12:13:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID patches for 2.6.32 merge window
In-Reply-To: <1252922794.3421.3.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.0909141210590.17028@wotan.suse.de>
References: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de> <1252922794.3421.3.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Marcel Holtmann wrote:

> > could you please pull from 'for-linus' branch of
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> > 
> > to receive HID patches accumulated for 2.6.32 merge window.
> 
> I am missing the patch to free the transport drivers from having to
> manually disconnect hidinput and hidraw. All the hid->claimed handling
> should really be hidden from the transport drivers.

Hi Marcel,

right, thanks for spotting this. The patch below has been rotting in my 
'waiting-for-ack' queue for quite some time. I was apparently waiting for 
your Ack for the drivers/net/bluetooth part, and forgot about it when it 
didn't come.

If you're OK with that, I'll include it in the next pile. Thanks.





From: Jiri Kosina <jkosina@suse.cz>
Subject: HID: consolidate connect and disconnect into core code

HID core registers input, hidraw and hiddev devices, but leaves 
unregistering it up to the individual driver, which is not really nice. 
Let's move all the logic to the core.

Reported-by: Marcel Holtmann <marcel@holtmann.org>
Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f2c21d5..3b776d7 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1218,6 +1218,17 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 }
 EXPORT_SYMBOL_GPL(hid_connect);
 
+void hid_disconnect(struct hid_device *hdev)
+{
+	if (hdev->claimed & HID_CLAIMED_INPUT)
+		hidinput_disconnect(hdev);
+	if (hdev->claimed & HID_CLAIMED_HIDDEV)
+		hdev->hiddev_disconnect(hdev);
+	if (hdev->claimed & HID_CLAIMED_HIDRAW)
+		hidraw_disconnect(hdev);
+}
+EXPORT_SYMBOL_GPL(hid_disconnect);
+
 /* a list of devices for which there is a specialized driver on HID bus */
 static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 3c1fcb7..0aa180b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1047,13 +1047,6 @@ static void usbhid_stop(struct hid_device *hid)
 
 	hid_cancel_delayed_stuff(usbhid);
 
-	if (hid->claimed & HID_CLAIMED_INPUT)
-		hidinput_disconnect(hid);
-	if (hid->claimed & HID_CLAIMED_HIDDEV)
-		hiddev_disconnect(hid);
-	if (hid->claimed & HID_CLAIMED_HIDRAW)
-		hidraw_disconnect(hid);
-
 	hid->claimed = 0;
 
 	usb_free_urb(usbhid->urbin);
@@ -1091,7 +1084,7 @@ static struct hid_ll_driver usb_hid_driver = {
 	.hidinput_input_event = usb_hidinput_input_event,
 };
 
-static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
+static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct usb_device *dev = interface_to_usbdev(intf);
@@ -1123,6 +1116,7 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
 	hid->hiddev_connect = hiddev_connect;
+	hid->hiddev_disconnect = hiddev_disconnect;
 	hid->hiddev_hid_event = hiddev_hid_event;
 	hid->hiddev_report_event = hiddev_report_event;
 #endif
@@ -1183,7 +1177,7 @@ err:
 	return ret;
 }
 
-static void hid_disconnect(struct usb_interface *intf)
+static void usbhid_disconnect(struct usb_interface *intf)
 {
 	struct hid_device *hid = usb_get_intfdata(intf);
 	struct usbhid_device *usbhid;
@@ -1365,8 +1359,8 @@ MODULE_DEVICE_TABLE (usb, hid_usb_ids);
 
 static struct usb_driver hid_driver = {
 	.name =		"usbhid",
-	.probe =	hid_probe,
-	.disconnect =	hid_disconnect,
+	.probe =	usbhid_probe,
+	.disconnect =	usbhid_disconnect,
 #ifdef CONFIG_PM
 	.suspend =	hid_suspend,
 	.resume =	hid_resume,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 53489fd..1c5955d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -494,6 +494,7 @@ struct hid_device {							/* device report descriptor */
 
 	/* hiddev event handler */
 	int (*hiddev_connect)(struct hid_device *, unsigned int);
+	void (*hiddev_disconnect)(struct hid_device *);
 	void (*hiddev_hid_event) (struct hid_device *, struct hid_field *field,
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
@@ -685,6 +686,7 @@ struct hid_device *hid_allocate_device(void);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
+void hid_disconnect(struct hid_device *hid);
 
 /**
  * hid_map_usage - map usage input bits
@@ -794,6 +796,7 @@ static inline int __must_check hid_hw_start(struct hid_device *hdev,
  */
 static inline void hid_hw_stop(struct hid_device *hdev)
 {
+	hid_disconnect(hdev);
 	hdev->ll_driver->stop(hdev);
 }
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index b186768..6593574 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -570,11 +570,8 @@ static int hidp_session(void *arg)
 		session->input = NULL;
 	}
 
-	if (session->hid) {
-		if (session->hid->claimed & HID_CLAIMED_INPUT)
-			hidinput_disconnect(session->hid);
+	if (session->hid)
 		hid_destroy_device(session->hid);
-	}
 
 	/* Wakeup user-space polling for socket errors */
 	session->intr_sock->sk->sk_err = EUNATCH;
@@ -729,8 +726,6 @@ static void hidp_stop(struct hid_device *hid)
 	skb_queue_purge(&session->ctrl_transmit);
 	skb_queue_purge(&session->intr_transmit);
 
-	if (hid->claimed & HID_CLAIMED_INPUT)
-		hidinput_disconnect(hid);
 	hid->claimed = 0;
 }
 


-- 
Jiri Kosina
SUSE Labs, Novell Inc.
