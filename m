Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbZFDTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbZFDTUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZFDTUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:20:05 -0400
Received: from tango.0pointer.de ([85.214.72.216]:52227 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZFDTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:20:04 -0400
Date: Thu, 4 Jun 2009 21:19:41 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: [PATCH] V4L: Generate KEY_CAMERA instead of BTN_0 key events on
	input devices
Message-ID: <20090604191941.GB6281@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of V4L drivers generate BTN_0 instead of KEY_CAMERA key presses.

X11 is able to handle KEY_CAMERA automatically these days while BTN_0 is
not treated at all. Thus it would be of big benefit if the camera
drivers would consistently generate KEY_CAMERA. Some drivers (uvc)
already do, this patch updates the remaining drivers to do the same.

I only possess a limited set of webcams, so this isn't tested with
all cameras. The patch is rather trivial and compile tested, so I'd say
it's still good enough to get merged. You decide!

(Resent 2nd time, due to missing Signed-off-by)

Lennart

Signed-off-by: Lennart Poettering <mzxreary@0pointer.de>
---
 drivers/media/video/pwc/pwc-if.c                  |    4 ++--
 drivers/media/video/usbvideo/konicawc.c           |    4 ++--
 drivers/media/video/usbvideo/quickcam_messenger.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 92d4177..db25c30 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -601,7 +601,7 @@ static void pwc_snapshot_button(struct pwc_device *pdev, int down)
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 	if (pdev->button_dev) {
-		input_report_key(pdev->button_dev, BTN_0, down);
+		input_report_key(pdev->button_dev, KEY_CAMERA, down);
 		input_sync(pdev->button_dev);
 	}
 #endif
@@ -1847,7 +1847,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
 	pdev->button_dev->dev.parent = &pdev->udev->dev;
 	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
-	pdev->button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	pdev->button_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	rc = input_register_device(pdev->button_dev);
 	if (rc) {
diff --git a/drivers/media/video/usbvideo/konicawc.c b/drivers/media/video/usbvideo/konicawc.c
index 900ec21..31d57f2 100644
--- a/drivers/media/video/usbvideo/konicawc.c
+++ b/drivers/media/video/usbvideo/konicawc.c
@@ -240,7 +240,7 @@ static void konicawc_register_input(struct konicawc *cam, struct usb_device *dev
 	input_dev->dev.parent = &dev->dev;
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	error = input_register_device(cam->input);
 	if (error) {
@@ -263,7 +263,7 @@ static void konicawc_unregister_input(struct konicawc *cam)
 static void konicawc_report_buttonstat(struct konicawc *cam)
 {
 	if (cam->input) {
-		input_report_key(cam->input, BTN_0, cam->buttonsts);
+		input_report_key(cam->input, KEY_CAMERA, cam->buttonsts);
 		input_sync(cam->input);
 	}
 }
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index fd112f0..803d3e4 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -103,7 +103,7 @@ static void qcm_register_input(struct qcm *cam, struct usb_device *dev)
 	input_dev->dev.parent = &dev->dev;
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	error = input_register_device(cam->input);
 	if (error) {
@@ -126,7 +126,7 @@ static void qcm_unregister_input(struct qcm *cam)
 static void qcm_report_buttonstat(struct qcm *cam)
 {
 	if (cam->input) {
-		input_report_key(cam->input, BTN_0, cam->button_sts);
+		input_report_key(cam->input, KEY_CAMERA, cam->button_sts);
 		input_sync(cam->input);
 	}
 }
-- 
1.6.2.2



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
