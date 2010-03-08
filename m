Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0CHVOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:14:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62249 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0CHVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Vg91pPFYomN17x/YN0pcektXUd81M5jNOVWo5AuolpuBgCnB74SJTA5cBjnobw7K11
         6NwoftyLtErrgKwMkQQx1CzJSxNBcfX4SAw7U5dyCFw2jeI9fPx8/xJousXYRsOJErUK
         PI5j+9ew2T7NQzsSpIaY9/cp7VYOQXX9L0yYk=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] HID: N-trig MTM Driver fix And cleanup patch 5
Date: Mon,  8 Mar 2010 23:13:45 +0200
Message-Id: <1268082827-2680-5-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268082827-2680-4-git-send-email-micki@n-trig.com>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
 <1268082827-2680-2-git-send-email-micki@n-trig.com>
 <1268082827-2680-3-git-send-email-micki@n-trig.com>
 <1268082827-2680-4-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

udpate ntrig_probe - add call to ntrig_send_report function
to initialize firmware to switch to Multi-touch mode.
Delete input-name our driver don't distinguish pen and touch.
Will be inserted in next version.

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   41 ++++++-----------------------------------
 1 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 8cdb3c2..8bf796c 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -19,6 +19,8 @@
  *	1.3 - N-trig - Change ntrig_input_mapped
  *	1.4 - N-trig - Add ntrig_send_report function
  *		send set feature command to firmware
+ *	1.5 - N-trig udpate ntrig_probe
+ *		add call to ntrig_send_report function
  */
 
 /*
@@ -415,11 +417,6 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
 	struct ntrig_data *nd;
-	struct hid_input *hidinput;
-	struct input_dev *input;
-
-	if (id->driver_data)
-		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
 
 	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
 	if (!nd) {
@@ -427,7 +424,6 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -ENOMEM;
 	}
 
-	nd->reading_mt = 0;
 	hid_set_drvdata(hdev, nd);
 
 	ret = hid_parse(hdev);
@@ -442,35 +438,10 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_free;
 	}
 
-
-	list_for_each_entry(hidinput, &hdev->inputs, list) {
-		input = hidinput->input;
-		switch (hidinput->report->field[0]->application) {
-		case HID_DG_PEN:
-			input->name = "N-Trig Pen";
-			break;
-		case HID_DG_TOUCHSCREEN:
-			__clear_bit(BTN_TOOL_PEN, input->keybit);
-			/*
-			 * A little something special to enable
-			 * two and three finger taps.
-			 */
-			__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
-			__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
-			__set_bit(BTN_TOOL_QUADTAP, input->keybit);
-			/*
-			 * The physical touchscreen (single touch)
-			 * input has a value for physical, whereas
-			 * the multitouch only has logical input
-			 * fields.
-			 */
-			input->name =
-				(hidinput->report->field[0]
-				 ->physical) ?
-				"N-Trig Touchscreen" :
-				"N-Trig MultiTouch";
-			break;
-		}
+	ret = ntrig_send_report(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "send set feature failed\n");
+		goto err_free;
 	}
 
 	return 0;
-- 
1.6.3.3

