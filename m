Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYKMVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYKMVKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYKMVKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:10:23 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:44103 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYKMVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:10:20 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Jiri Kosina" <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] HID: don't grab devices with no input
Date: Thu, 13 Nov 2008 22:10:00 +0100
Message-Id: <1226610600-22899-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <Pine.LNX.4.44L0.0811131040160.2380-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0811131040160.2380-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> This suggests that a lot of the work in usbhid_start should be 
> performed earlier, before calling hid_add_device.  After all, why 
> bother registering a USB device on the input bus if usbhid isn't going 
> to be able to drive it?

None of the code can be moved to the usbhid probe function, because all
of it depends on the driver's (potential) report_fixup.

However I suggest moving this test to the probe which ensures performing
the test early enough.

Andi, could you test the attached patch?

--

Some devices have no input interrupt endpoint. These won't be handled
by usbhid, but currently they are not refused and reside on hid bus.

Perform this checking earlier so that we refuse to control such
a device early enough (and not pass it to the hid bus at all).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f7e0d71..2c5cb10 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -845,12 +845,6 @@ static int usbhid_start(struct hid_device *hid)
 		}
 	}
 
-	if (!usbhid->urbin) {
-		err_hid("couldn't find an input interrupt endpoint");
-		ret = -ENODEV;
-		goto fail;
-	}
-
 	init_waitqueue_head(&usbhid->wait);
 	INIT_WORK(&usbhid->reset_work, hid_reset);
 	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
@@ -947,15 +941,26 @@ static struct hid_ll_driver usb_hid_driver = {
 
 static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
+	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usbhid_device *usbhid;
 	struct hid_device *hid;
+	unsigned int n, has_in = 0;
 	size_t len;
 	int ret;
 
 	dbg_hid("HID probe called for ifnum %d\n",
 			intf->altsetting->desc.bInterfaceNumber);
 
+	for (n = 0; n < interface->desc.bNumEndpoints; n++)
+		if (usb_endpoint_dir_in(&interface->endpoint[n].desc))
+			has_in++;
+	if (!has_in) {
+		dev_err(&intf->dev, "couldn't find an input interrupt "
+				"endpoint");
+		return -ENODEV;
+	}
+
 	hid = hid_allocate_device();
 	if (IS_ERR(hid))
 		return PTR_ERR(hid);
-- 
1.6.0.3

