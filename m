Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbYKAWmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYKAWmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 18:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKAWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 18:41:53 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:56356 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYKAWlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 18:41:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] USBHID: correct start/stop cycle
Date: Sat,  1 Nov 2008 23:41:46 +0100
Message-Id: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`stop' left out usbhid->urb* pointers and so the next `start' thought
it needs to allocate nothing and used the memory pointers previously
pointed to. This led to memory corruption and device malfunction.

Also don't forget to clear disconnect flag on start which was left set
by the previous `stop'.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 18e5ddd..f0339ae 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -781,6 +781,8 @@ static int usbhid_start(struct hid_device *hid)
 	unsigned int n, insize = 0;
 	int ret;
 
+	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
+
 	usbhid->bufsize = HID_MIN_BUFFER_SIZE;
 	hid_find_max_report(hid, HID_INPUT_REPORT, &usbhid->bufsize);
 	hid_find_max_report(hid, HID_OUTPUT_REPORT, &usbhid->bufsize);
@@ -888,6 +890,9 @@ fail:
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
+	usbhid->urbin = NULL;
+	usbhid->urbout = NULL;
+	usbhid->urbctrl = NULL;
 	hid_free_buffers(dev, hid);
 	mutex_unlock(&usbhid->setup);
 	return ret;
@@ -924,6 +929,9 @@ static void usbhid_stop(struct hid_device *hid)
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbctrl);
 	usb_free_urb(usbhid->urbout);
+	usbhid->urbin = NULL; /* don't mess up next start */
+	usbhid->urbctrl = NULL;
+	usbhid->urbout = NULL;
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
 	mutex_unlock(&usbhid->setup);
-- 
1.6.0.3

