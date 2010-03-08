Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0CHVPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:15:00 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62249 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0CHVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=gvYDCzItL0YhcIak4ttOOO8o292NKteNZuA5sdQtxn38RzQtZkn9hze+9XcLEvglos
         J4OborDzL4HvCh75qNh3r7betDYK1K6hMg30m2a4lHG4Q2uNlLW0M3Zpe2vtLlgGOWDU
         StB3CQqps5NvrtH1MZCcBwTAnBxYJ04c+JjEM=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] HID: N-trig MTM Driver fix and cleanup patch 2
Date: Mon,  8 Mar 2010 23:13:42 +0200
Message-Id: <1268082827-2680-2-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268082827-2680-1-git-send-email-micki@n-trig.com>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Change ntrig_input_mapping function

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index e99342d..3602cd0 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -15,6 +15,7 @@
  *		do not have full multi touch support.
  *	1.1 - N-trig - Add Change Log and defines of MTM firmware.
  *		Add debug Paramater change Driver name in hid_driver structure
+ *	1.2 - N-trig - Change ntrig_input_mapping
  */
 
 /*
@@ -118,21 +119,12 @@ struct ntrig_data {
 	__u8 mt_foot_count;
 };
 
-/*
- * this driver is aimed at two firmware versions in circulation:
- *  - dual pen/finger single touch
- *  - finger multitouch, pen not working
- */
-
 static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* No special mappings needed for the pen and single touch */
-	if (field->physical)
-		return 0;
-
 	switch (usage->hid & HID_USAGE_PAGE) {
+
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
 		case HID_GD_X:
@@ -155,12 +147,15 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		/* we do not want to map these for now */
-		case HID_DG_CONTACTID: /* Not trustworthy, squelch for now */
+		case HID_DG_INVERT: /* value is always 0 */
+		case HID_DG_ERASER: /* value is always 0 */
+		case HID_DG_CONTACTID: /* value is useless */
+		case HID_DG_BARRELSWITCH:  /* doubtful */
 		case HID_DG_INPUTMODE:
 		case HID_DG_DEVICEINDEX:
+		case HID_DG_CONTACTCOUNT:
 		case HID_DG_CONTACTMAX:
 			return -1;
-
 		/* width/height mapped on TouchMajor/TouchMinor/Orientation */
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -169,8 +164,8 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
-			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					0, 1, 0, 0);
+			hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_TRACKING_ID);
 			return 1;
 		}
 		return 0;
-- 
1.6.3.3

