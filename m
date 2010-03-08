Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0CHVOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:14:05 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62249 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0CHVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=c2b4ourwZrQjOcmGSO0jUa6HjhAF7Hb1XCyj43CIgFCkYV6ldi7YehzpPdLWK5OyWQ
         B+IOYq6IldaFaTn2HTLxUs7brbRimBH5K4zkL36ZZiDNshuiWHlXc39I8FnDxIK3N6Fh
         IDo9yj+1PgX9BT6EFPuKEEG9QifqozALB1rss=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] HID: N-trig MTM Driver fix and cleanup patch 1
Date: Mon,  8 Mar 2010 23:13:41 +0200
Message-Id: <1268082827-2680-1-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Add Change Log and defines of MTM firmware.
Add debug Paramater change Driver name in hid_driver structure

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   94 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 3234c72..e99342d 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -3,7 +3,18 @@
  *
  *  Copyright (c) 2008 Rafi Rubin
  *  Copyright (c) 2009 Stephane Chatty
+ *  Copyright (c) 2010 N-TRIG
  *
+ *	1.0 - Rafi Rubin ( Version From 2010-02-13 02:13:05)
+ *		This cleans up the identification of multitouch
+ *		groups and enables the end of group sync.
+ *		Taps are now explicitly handled to adjust for the changes in the
+ *		event stream in multitouch mode.
+ *		Added triple and quad tap for the benefit of
+ *		tools that recognize different tap types but
+ *		do not have full multi touch support.
+ *	1.1 - N-trig - Add Change Log and defines of MTM firmware.
+ *		Add debug Paramater change Driver name in hid_driver structure
  */
 
 /*
@@ -16,8 +27,78 @@
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
-
+#include <linux/usb.h>
 #include "hid-ids.h"
+#include "usbhid/usbhid.h"
+
+/*
+ * Pen Event Field Declaration
+ */
+#define	EVENT_PEN_TIP		0x03
+#define	EVENT_PEN_RIGHT		0x05
+#define	EVENT_TOUCH_PEN		0x07
+#define EVENT_PEN_IN_RANGE	0x01
+
+/*
+ * MTM 4 last bytes of report descriptor
+ */
+#define REPORT_GENERIC1		0x01
+#define REPORT_MT		0x02
+#define REPORT_PALM		0x03
+#define REPORT_GENERIC2		0x04
+
+#define NTRIG_USB_DEVICE_ID	0x0001
+
+/*
+ * MTM fields
+ */
+#define PEN_REPORT_SIZE		0x48
+#define MAX_FINGERS_SUPPORT	0x06
+#define END_OF_REPORT		0x64
+
+/*
+ * Dummy Finger Declaration
+ */
+#define X_CORD_VAL		0x00
+#define Y_CORD_VAL		0x00
+#define DX_CORD_VAL		0xFA
+#define DY_CORD_VAL		0x96
+#define GENERIC_BYTE_VAL	0x0D
+
+/*
+ * MTM Parse Event
+ */
+#define MTM_FRAME_INDEX		0xff000001
+#define MTM_PROPROETARY		0xff000002
+
+/*
+ * MTM  Set Feature Commands
+ */
+#define REPORTID_DRIVER_ALIVE	0x0A
+#define REPORTID_CALIBRATION	0x0B
+#define REPORTID_GET_VERSION	0x0C
+#define REPORTID_GET_MODE	0x0D
+#define REPORTID_SET_MODE_PEN	0x0E
+#define REPORTID_SET_MODE_TOUCH	0x0F
+#define REPORTID_SET_MODE_DUAL	0x10
+#define REPORTID_CALIBRATION_RESPOND	0x11
+#define HID_CAPACITORS_CALIB	0x12
+#define HID_GET_CAPACITORS_CALIB_DONE	0x13
+
+
+static int debug;
+
+#define MODULE_NAME "hid_ntrig"
+
+
+#define info(format, arg...) \
+	printk(KERN_INFO "%s: " format , MODULE_NAME , ## arg)
+#define ntrig_dbg(format, arg...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "%s: " format, \
+			MODULE_NAME , ## arg); \
+	} while (0)
 
 #define NTRIG_DUPLICATE_USAGES	0x001
 
@@ -123,8 +204,8 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
  * decide whether we are in multi or single touch mode
  * and call input_mt_sync after each point if necessary
  */
-static int ntrig_event (struct hid_device *hid, struct hid_field *field,
-		                        struct hid_usage *usage, __s32 value)
+static int ntrig_event(struct hid_device *hid, struct hid_field *field,
+			struct hid_usage *usage, __s32 value)
 {
 	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
@@ -133,7 +214,7 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 	if (field->application == HID_DG_PEN)
 		return 0;
 
-        if (hid->claimed & HID_CLAIMED_INPUT) {
+	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case 0xff000001:
 			/* Tag indicating the start of a multitouch group */
@@ -362,7 +443,7 @@ static const struct hid_usage_id ntrig_grabbed_usages[] = {
 };
 
 static struct hid_driver ntrig_driver = {
-	.name = "ntrig",
+	.name = MODULE_NAME,
 	.id_table = ntrig_devices,
 	.probe = ntrig_probe,
 	.remove = ntrig_remove,
@@ -384,4 +465,7 @@ static void __exit ntrig_exit(void)
 
 module_init(ntrig_init);
 module_exit(ntrig_exit);
+
+MODULE_PARM_DESC(debug, "Debug mode enable disable");
+module_param(debug, bool, 0644);
 MODULE_LICENSE("GPL");
-- 
1.6.3.3

