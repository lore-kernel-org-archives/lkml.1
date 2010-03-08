Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0CHVRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:17:17 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0CHVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:17:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=jKMwS3+NyjjaAYiXIZCGBhcomDny2J12309Dd0agGHjbSAOM8lwirk41+tUWGEv66Q
         vDN+fQ/kEFHFa5hmtOn7FABkxmDvBrHWEsj7PKjcILzb67X2uaM56HcMwDhH9UXOQlBI
         9UZSkA8tssprLpyznVkma7UYrMB/719ZoUFLU=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] HID: N-trig MTM Driver fix And cleanup patch 7
Date: Mon,  8 Mar 2010 23:17:04 +0200
Message-Id: <1268083024-3029-1-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <micki@n-trig.com>
References: <micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Last Patch Update ntrig_event. Add Change Log To Driver.
Used Rafi Rubin comments and update the driver.
This Driver was tested for sevral month by N-trig with
User space application developed By N-trig.
The MT protocol as been tested and work good with our applications.
N-trig will update the driver in the kernel, when a new version will
be release (Bug/feature). N-trig will release DEB package contains
user space application to support hid-ntrig driver.
For Any Comment Or Question Please Send an email to N-trig.

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |  310 ++++++++++++++++++++++++++---------------------
 1 files changed, 171 insertions(+), 139 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index f88533e..588f26f 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -24,6 +24,18 @@
  *	1.6 - N-trig Update ntrig_init print version number
  *		update struct hid_driver
  *		update struct hid_device_id
+ *	2.0 - N-trig Major Change - fully Support MTM Firware
+ *		Used Rafi comments and update the driver.
+ *		This Driver was tested for sevral mounth by N-trig with
+ *		User space application developed By N-trig.
+ *		The MT protocol as been tested
+ *		work good with our applications.
+ *		N-trig will update the driver
+ *		in the kernel, when a new version will
+ *		be release (Bug/feature).
+ *		For Any Comment Or Question Please Send an
+ *		email to N-trig.
+ *
  */
 
 /*
@@ -109,24 +121,28 @@ static int debug;
 			MODULE_NAME , ## arg); \
 	} while (0)
 
-#define NTRIG_DUPLICATE_USAGES	0x001
 
-#define nt_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
-					EV_KEY, (c))
 
+/*
+ * N-trig HID Report Structure
+ * The driver will support MTM firwmare Pen, Finger (Up to 6)
+ */
 struct ntrig_data {
-	/* Incoming raw values for a single contact */
-	__u16 x, y, w, h;
-	__u16 id;
-	__u8 confidence;
-
-	bool reading_mt;
-	__u8 first_contact_confidence;
-
-	__u8 mt_footer[4];
-	__u8 mt_foot_count;
+	__u8  pressure;
+	__u8  events;
+	__s32 btn_pressed;
+	__u16 x_cord;
+	__u16 y_cord;
+	__u16 frame_index;
+	__u8  finger_id;
+	__u16 dx;
+	__u16 dy;
+	__u8  generic_byte;
+	__u8  isPalm;
+	__u8  msc_cnt;
+	__u8  real_fingers;
+	__u8  fake_fingers;
 };
-
 static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -212,9 +228,9 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 
 /*
  * this function is called upon all reports
- * so that we can filter contact point information,
- * decide whether we are in multi or single touch mode
- * and call input_mt_sync after each point if necessary
+ * Pen report end with input_sync
+ * Finger report: we separate between each finger by input_mt_sync
+ * the report end with input_sync
  */
 static int ntrig_event(struct hid_device *hid, struct hid_field *field,
 			struct hid_usage *usage, __s32 value)
@@ -222,152 +238,168 @@ static int ntrig_event(struct hid_device *hid, struct hid_field *field,
 	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
 
-	/* No special handling needed for the pen */
-	if (field->application == HID_DG_PEN)
-		return 0;
-
+       /*
+	* The easy way to  Distinguish between Pen And
+	* MultiTouch According to report size
+	* Pen         report->size - 72
+	* Multi-Touch report->size - 744
+	*/
 	if (hid->claimed & HID_CLAIMED_INPUT) {
+		/*
+		 * Update Common Fields For Pen and MultiTouch
+		 */
 		switch (usage->hid) {
-		case 0xff000001:
-			/* Tag indicating the start of a multitouch group */
-			nd->reading_mt = 1;
-			nd->first_contact_confidence = 0;
-			break;
-		case HID_DG_CONFIDENCE:
-			nd->confidence = value;
-			break;
 		case HID_GD_X:
-			nd->x = value;
-			/* Clear the contact footer */
-			nd->mt_foot_count = 0;
+			nd->x_cord = value;
 			break;
 		case HID_GD_Y:
-			nd->y = value;
-			break;
-		case HID_DG_CONTACTID:
-			nd->id = value;
+			nd->y_cord = value;
 			break;
-		case HID_DG_WIDTH:
-			nd->w = value;
-			break;
-		case HID_DG_HEIGHT:
-			nd->h = value;
-			/*
-			 * when in single touch mode, this is the last
-			 * report received in a finger event. We want
-			 * to emit a normal (X, Y) position
-			 */
-			if (!nd->reading_mt) {
-				input_report_key(input, BTN_TOOL_DOUBLETAP,
-						 (nd->confidence != 0));
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
-			break;
-		case 0xff000002:
+		}
+		if (field->application == HID_DG_PEN) {
 			/*
-			 * we receive this when the device is in multitouch
-			 * mode. The first of the three values tagged with
-			 * this usage tells if the contact point is real
-			 * or a placeholder
+			 * Pen Button state
 			 */
-
-			/* Shouldn't get more than 4 footer packets, so skip */
-			if (nd->mt_foot_count >= 4)
+			switch (usage->hid) {
+			case HID_DG_INRANGE:
+				nd->events = value;
 				break;
-
-			nd->mt_footer[nd->mt_foot_count++] = value;
-
-			/* if the footer isn't complete break */
-			if (nd->mt_foot_count != 4)
+			case HID_DG_TIPSWITCH:
+				nd->events |= (value << 1);
 				break;
-
-			/* Pen activity signal, trigger end of touch. */
-			if (nd->mt_footer[2]) {
-				nd->confidence = 0;
+			case HID_DG_BARRELSWITCH:
+				nd->events |= (value << 2);
 				break;
-			}
-
-			/* If the contact was invalid */
-			if (!(nd->confidence && nd->mt_footer[0])
-					|| nd->w <= 250
-					|| nd->h <= 190) {
-				nd->confidence = 0;
+			case HID_DG_INVERT:
+				nd->events |= (value << 3);
 				break;
+			case HID_DG_ERASER:
+				nd->events |= (value << 4);
+				break;
+			case HID_DG_TIPPRESSURE:
+				/*
+				 * Last Report Received For Pen Event
+				 */
+				nd->pressure = value;
+				input_report_abs(input, ABS_MT_TOOL_TYPE,
+					MT_TOOL_PEN);
+				input_report_abs(input, ABS_MT_POSITION_X,
+					nd->x_cord);
+				input_report_abs(input, ABS_MT_POSITION_Y,
+					nd->y_cord);
+				/*
+				 * Handle Button Code
+				 */
+				switch (nd->events) {
+				case EVENT_PEN_IN_RANGE:
+					if (0 != nd->btn_pressed) {
+						input_event(input, EV_KEY,
+						  nd->btn_pressed, 0x00);
+						nd->btn_pressed = 0;
+					}
+					break;
+				case EVENT_PEN_TIP:
+					if (BTN_LEFT != nd->btn_pressed) {
+						nd->btn_pressed = BTN_LEFT;
+						input_event(input, EV_KEY,
+						  nd->btn_pressed, 0x01);
+					}
+					break;
+				case EVENT_TOUCH_PEN:  /* FALLTHRU */
+				case EVENT_PEN_RIGHT:
+					if (BTN_RIGHT != nd->btn_pressed) {
+						nd->btn_pressed = BTN_RIGHT;
+						input_event(input, EV_KEY,
+						    nd->btn_pressed, 0x01);
+					}
+					break;
+				}
+				input_report_abs(input, ABS_PRESSURE,
+				  nd->pressure);
+				input_sync(input);
+				ntrig_dbg("X=%d Y=%d Button=%d Pressure=%d\n",
+				    nd->x_cord, nd->y_cord,
+				    nd->btn_pressed, nd->pressure);
 			}
-
-			/* emit a normal (X, Y) for the first point only */
-			if (nd->id == 0) {
-				nd->first_contact_confidence = nd->confidence;
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
-			if (nd->w > nd->h) {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 1);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->w);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->h);
-			} else {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 0);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->h);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->w);
-			}
-			input_mt_sync(field->hidinput->input);
-			break;
-
-		case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
-			if (!nd->reading_mt)
+		} else { /* MultiTouch Report */
+			switch (usage->hid) {
+			case HID_DG_CONTACTCOUNT:
+				nd->real_fingers = value;
+				nd->fake_fingers = MAX_FINGERS_SUPPORT - value;
 				break;
-
-			nd->reading_mt = 0;
-
-			if (nd->first_contact_confidence) {
-				switch (value) {
-				case 0:	/* for single touch devices */
-				case 1:
-					input_report_key(input,
-							BTN_TOOL_DOUBLETAP, 1);
+			case MTM_FRAME_INDEX: /* Index 1 */
+				nd->frame_index = value;
+				break;
+			case HID_DG_TIPSWITCH:	/* FALLTHRU */
+			case HID_DG_INRANGE:	/* FALLTHRU */
+			case HID_DG_CONFIDENCE: /* Not Relevant-Index 2 - 4 */
+				break;
+			case HID_DG_CONTACTID: /* Index 5 */
+				nd->finger_id = value;
+				break;
+			case HID_DG_WIDTH:/* Index 6 - 7*/
+				nd->dx = value;
+				break;
+			case HID_DG_HEIGHT:/* Index 8 - 9 */
+				nd->dy = value;
+				/* Start The Sequence of MSC bytes */
+				nd->msc_cnt = 0;
+				break;
+			case MTM_PROPROETARY:/* Index 10 - 14 */
+				nd->msc_cnt++;
+				switch (nd->msc_cnt) {
+				case REPORT_GENERIC1:
+					nd->generic_byte = value;
+					break;
+				case REPORT_MT:
 					break;
-				case 2:
-					input_report_key(input,
-							BTN_TOOL_TRIPLETAP, 1);
+				case REPORT_PALM:
+					nd->isPalm = value;
+					break;
+				case REPORT_GENERIC2:
+					if ((X_CORD_VAL == nd->x_cord) && (Y_CORD_VAL == nd->y_cord) &&
+					    (DX_CORD_VAL == nd->dx) && (DY_CORD_VAL == nd->dy) &&
+					    (GENERIC_BYTE_VAL == value)) {
+						if (MAX_FINGERS_SUPPORT == nd->fake_fingers--) {
+							input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
+							input_report_abs(input, ABS_MT_TRACKING_ID, END_OF_REPORT);
+							input_event(input, EV_MSC, MSC_SCAN, nd->frame_index);
+							input_sync(input);
+							ntrig_dbg("Session Sync Frame %x\n", nd->frame_index);
+						} else
+							ntrig_dbg("Fake Finger %x\n", nd->frame_index);
+					} else {
+						input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
+						input_report_abs(input, ABS_MT_TRACKING_ID, nd->finger_id);
+						input_report_abs(input, ABS_MT_POSITION_X, nd->x_cord);
+						input_report_abs(input, ABS_MT_POSITION_Y, nd->y_cord);
+						input_report_abs(input, ABS_MT_TOUCH_MAJOR, nd->dx);
+						input_report_abs(input, ABS_MT_TOUCH_MINOR, nd->dy);
+						input_event(input, EV_MSC, MSC_PULSELED, nd->generic_byte);
+						input_event(input, EV_MSC, MSC_SERIAL, nd->isPalm);
+						input_mt_sync(input);
+						ntrig_dbg("Real Finger Index %x Count %d X=%d Y=%d DX=%d DY=%d FirstOccur=%d Palm=%d\n",
+							nd->frame_index, nd->real_fingers, nd->x_cord,
+							nd->y_cord, nd->dx, nd->dy,
+							nd->generic_byte, nd->isPalm);
+						if (0 == --nd->real_fingers) {
+							input_event(input, EV_MSC, MSC_SCAN, nd->frame_index);
+							input_sync(input);
+							ntrig_dbg("Real Finger Sync Frame %x\n", nd->frame_index);
+						}
+					}
 					break;
-				case 3:
-				default:
-					input_report_key(input,
-							BTN_TOOL_QUADTAP, 1);
 				}
-				input_report_key(input, BTN_TOUCH, 1);
-			} else {
-				input_report_key(input,
-						BTN_TOOL_DOUBLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_TRIPLETAP, 0);
-				input_report_key(input,
-						BTN_TOOL_QUADTAP, 0);
+				break;
 			}
-			break;
-
-		default:
-			/* fallback to the generic hidinput handling */
-			return 0;
 		}
 	}
-
 	/* we have handled the hidinput part, now remains hiddev */
-	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_hid_event)
+	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
 		hid->hiddev_hid_event(hid, field, usage, value);
 
 	return 1;
 }
-
 /*
  * This function used to configure N-trig firmware
  * The first command we need to send to firmware is change
@@ -479,7 +511,7 @@ static struct hid_driver ntrig_driver = {
 
 static int __init ntrig_init(void)
 {
-	info("N-trig Driver Version 1.6\n");
+	info("N-trig Driver Version 2\n");
 	return hid_register_driver(&ntrig_driver);
 }
 
-- 
1.6.3.3

