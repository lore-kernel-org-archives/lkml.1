Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYLBTeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYLBTeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYLBTbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:31:40 -0500
Received: from bungle.evilgeniuses.org.uk ([195.10.223.155]:1543 "EHLO
	bungle.evilgeniuses.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709AbYLBTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:31:34 -0500
X-Greylist: delayed 1467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 14:31:34 EST
Subject: [PATCH] [ov511] Export snapshot button through input layer
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-q6MXkGNbdLelg2nslhuX"
Date: Tue, 02 Dec 2008 19:07:03 +0000
Message-Id: <1228244823.8307.1458.camel@cookie.hadess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q6MXkGNbdLelg2nslhuX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Patch says it all.

Comments appreciated, but please keep me on CC: as I'm not subscribed to
LKML.

Cheers

--=-q6MXkGNbdLelg2nslhuX
Content-Disposition: attachment; filename="0001--ov511-Export-snapshot-button-through-input-layer.patch"
Content-Type: text/x-patch; name="0001--ov511-Export-snapshot-button-through-input-layer.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>From dea35acfe9ef161fb44cc0efbbd700472f5f1bc9 Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Tue, 2 Dec 2008 19:03:06 +0000
Subject: [PATCH] [ov511] Export snapshot button through input layer

Register an input device with one button, and for the supported
OV511 webcams, poll and check whether the snapshot button has been
pressed on each new frame.
---
 drivers/media/video/ov511.c |   84 +++++++++++++++++++++++++++++++++++++++++-
 drivers/media/video/ov511.h |    1 +
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 210f124..bad665b 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -352,6 +352,73 @@ rvfree(void *mem, unsigned long size)
 
 /**********************************************************************
  *
+ * Input device
+ *
+ **********************************************************************/
+#ifdef CONFIG_OV511_INPUT_EVDEV
+#warn foobar
+static int ov511_input_init(struct usb_ov511 *ov)
+{
+	struct usb_device *udev = ov->udev;
+	struct input_dev *input;
+	char *phys = NULL;
+	int ret;
+
+	input = input_allocate_device();
+	if (input == NULL)
+		return -ENOMEM;
+
+	phys = kmalloc(6 + strlen(udev->bus->bus_name) + strlen(udev->devpath),
+			GFP_KERNEL);
+	if (phys == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	sprintf(phys, "usb-%s-%s", udev->bus->bus_name, udev->devpath);
+
+	input->name = ov->name;
+	input->phys = phys;
+	usb_to_input_id(udev, &input->id);
+	input->dev.parent = &ov->intf->dev;
+
+	set_bit(EV_KEY, input->evbit);
+	set_bit(KEY_CAMERA, input->keybit);
+
+	if ((ret = input_register_device(input)) < 0)
+		goto error;
+
+	ov->key_input = input;
+	return 0;
+
+error:
+	input_free_device(input);
+	kfree(phys);
+	return ret;
+}
+
+static void ov511_input_cleanup(struct usb_ov511 *ov)
+{
+	if (ov->key_input)
+		input_unregister_device(ov->key_input);
+}
+
+static void ov511_input_report_key(struct usb_ov511 *ov, unsigned int code,
+	int value)
+{
+	if (ov->key_input) {
+		input_report_key(ov->key_input, code, value);
+		input_sync(ov->key_input);
+	}
+}
+
+#else
+#define ov511_input_init(dev) 0
+#define ov511_input_cleanup(dev)
+#define ov511_input_report_key(dev, code, value)
+#endif /* CONFIG_OV511_INPUT_EVDEV */
+
+/**********************************************************************
+ *
  * Register I/O
  *
  **********************************************************************/
@@ -1105,7 +1172,6 @@ ov51x_clear_snapshot(struct usb_ov511 *ov)
 	}
 }
 
-#if 0
 /* Checks the status of the snapshot button. Returns 1 if it was pressed since
  * it was last cleared, and zero in all other cases (including errors) */
 static int
@@ -1130,7 +1196,6 @@ ov51x_check_snapshot(struct usb_ov511 *ov)
 
 	return status;
 }
-#endif
 
 /* This does an initial reset of an OmniVision sensor and ensures that I2C
  * is synchronized. Returns <0 for failure.
@@ -4388,6 +4453,12 @@ redo:
 			if ((ov->snap_enabled) && (frame->snapshot)) {
 				frame->snapshot = 0;
 				ov51x_clear_snapshot(ov);
+			} else if (!ov->snap_enabled && ov->bclass == BCL_OV511) {
+				if (ov51x_check_snapshot(ov) == 1) {
+					ov511_input_report_key(ov, KEY_CAMERA, 1);
+					ov511_input_report_key(ov, KEY_CAMERA, 0);
+					ov51x_clear_snapshot(ov);
+				}
 			}
 
 			/* Decompression, format conversion, etc... */
@@ -5877,6 +5948,13 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
+	/* Snapshot is currently only supported on OV511,
+	 * so no need to register the input device if it's not supported */
+	if (!ov->snap_enabled && ov->bclass == BCL_OV511) {
+		if (ov511_input_init(dev) < 0)
+			dev_warn(&ov->dev->dev, "Could not register input device\n");
+	}
+
 	return 0;
 
 error:
@@ -5919,6 +5997,8 @@ ov51x_disconnect(struct usb_interface *intf)
 	if (ov->vdev)
 		video_unregister_device(ov->vdev);
 
+	ov511_input_cleanup(ov);
+
 	for (n = 0; n < OV511_NUMFRAMES; n++)
 		ov->frame[n].grabstate = FRAME_ERROR;
 
diff --git a/drivers/media/video/ov511.h b/drivers/media/video/ov511.h
index 70d99e5..a9346c7 100644
--- a/drivers/media/video/ov511.h
+++ b/drivers/media/video/ov511.h
@@ -468,6 +468,7 @@ struct usb_ov511 {
 	wait_queue_head_t wq;	/* Processes waiting */
 
 	int snap_enabled;	/* Snapshot mode enabled */
+	struct input_dev *key_input;/* The input device for the snapshot button */
 
 	int bridge;		/* Type of bridge (BRG_*) */
 	int bclass;		/* Class of bridge (BCL_*) */
-- 
1.6.0.4


--=-q6MXkGNbdLelg2nslhuX--

