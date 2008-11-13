Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYKMWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYKMWKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYKMWK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:10:28 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:52588 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYKMWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:10:28 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1 v2] HID: don't grab devices with no input
Date: Thu, 13 Nov 2008 23:10:21 +0100
Message-Id: <1226614221-17118-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <491CA495.7010007@gmail.com>
References: <491CA495.7010007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have no input interrupt endpoint. These won't be handled
by usbhid, but currently they are not refused and reside on hid bus.

Perform this checking earlier so that we refuse to control such
a device early enough (and not pass it to the hid bus at all).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 05402e9..9c9bd4c 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -850,12 +850,6 @@ static int usbhid_start(struct hid_device *hid)
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
@@ -958,15 +952,26 @@ static struct hid_ll_driver usb_hid_driver = {
 
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
+		if (usb_endpoint_is_int_in(&interface->endpoint[n].desc))
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
1.6.0.4

