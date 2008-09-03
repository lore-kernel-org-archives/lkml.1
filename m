Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYICUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYICUYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYICUYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:24:03 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:56053 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbYICUYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:24:00 -0400
Message-ID: <48BEF251.6030903@euromail.se>
Date: Wed, 03 Sep 2008 22:23:45 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@osdl.org,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] bcm5974-0.64:  Finger tracking and counting improved
 further
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KaytR-000632-80.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KaytR-000632-80 bc35d438f59f284bfe174f49a1d828ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem of finger tracking, i.e., when to switch focus from one finger to another on the
trackpad, has been improved by utilizing more information from the bcm5974 chip output. This
results in less pointer hopping when many fingers are on the trackpad. In addition, a finger
counting method based on pressure information from all fingers is introduced. Together
with a pressure hysteresis window, this yields a more stable counting of the number of fingers
on the trackpad.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   70 +++++++++++++++++++++++++++++++---------
 1 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ae78bb8..8568211 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -105,7 +105,7 @@ struct tp_header {

 /* trackpad finger structure */
 struct tp_finger {
-	__le16 origin;		/* left/right origin? */
+	__le16 origin;		/* zero when switching track finger */
 	__le16 abs_x;		/* absolute x coodinate */
 	__le16 abs_y;		/* absolute y coodinate */
 	__le16 rel_x;		/* relative x coodinate */
@@ -159,6 +159,7 @@ struct bcm5974 {
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	struct tp_data *tp_data;	/* trackpad transferred data */
+	int fingers;			/* number of fingers on trackpad */
 };

 /* logical dimensions */
@@ -172,6 +173,10 @@ struct bcm5974 {
 #define SN_WIDTH	100		/* width signal-to-noise ratio */
 #define SN_COORD	250		/* coordinate signal-to-noise ratio */

+/* pressure thresholds */
+#define PRESSURE_LOW	(2 * DIM_PRESSURE / SN_PRESSURE)
+#define PRESSURE_HIGH	(3 * PRESSURE_LOW)
+
 /* device constants */
 static const struct bcm5974_config bcm5974_config_table[] = {
 	{
@@ -273,32 +278,65 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct tp_finger *f = dev->tp_data->finger;
 	struct input_dev *input = dev->input;
 	const int fingers = (size - 26) / 28;
-	int p = 0, w, x, y, n = 0;
+	int raw_p, raw_w, raw_x, raw_y;
+	int ptest = 0, origin = 0, nmin = 0, nmax = 0;
+	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;

 	if (size < 26 || (size - 26) % 28 != 0)
 		return -EIO;

+	/* always track the first finger; when detached, start over */
 	if (fingers) {
-		p = raw2int(f->force_major);
-		w = raw2int(f->size_major);
-		x = raw2int(f->abs_x);
-		y = raw2int(f->abs_y);
-		n = p > 0 ? fingers : 0;
+		raw_p = raw2int(f->force_major);
+		raw_w = raw2int(f->size_major);
+		raw_x = raw2int(f->abs_x);
+		raw_y = raw2int(f->abs_y);

 		dprintk(9,
-			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
-			p, w, x, y, n);
+			"bcm5974: raw: p: %+05d w: %+05d x: %+05d y: %+05d\n",
+			raw_p, raw_w, raw_x, raw_y);
+
+		ptest = int2bound(&c->p, raw_p);
+		origin = raw2int(f->origin);
+	}

-		input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
-		input_report_abs(input, ABS_X, int2bound(&c->x, x - c->x.devmin));
-		input_report_abs(input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
+	/* while tracking finger still valid, count all fingers */
+	if (ptest > PRESSURE_LOW && origin) {
+		abs_p = ptest;
+		abs_w = int2bound(&c->w, raw_w);
+		abs_x = int2bound(&c->x, raw_x - c->x.devmin);
+		abs_y = int2bound(&c->y, c->y.devmax - raw_y);
+		for (; f != dev->tp_data->finger + fingers; f++) {
+			ptest = int2bound(&c->p, raw2int(f->force_major));
+			if (ptest > PRESSURE_LOW)
+				nmax++;
+			if (ptest > PRESSURE_HIGH)
+				nmin++;
+		}
 	}

-	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
+	if (dev->fingers < nmin)
+		dev->fingers = nmin;
+	if (dev->fingers > nmax)
+		dev->fingers = nmax;
+
+	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);

-	input_report_key(input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
+	input_report_abs(input, ABS_PRESSURE, abs_p);
+	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
+
+	if (abs_p) {
+		input_report_abs(input, ABS_X, abs_x);
+		input_report_abs(input, ABS_Y, abs_y);
+
+		dprintk(8,
+			"bcm5974: abs: p: %+05d w: %+05d x: %+05d y: %+05d "
+			"nmin: %d nmax: %d n: %d\n",
+			abs_p, abs_w, abs_x, abs_y, nmin, nmax, dev->fingers);
+
+	}

 	input_sync(input);

-- 
1.5.4.3

Diff is against v2.6.27-rc5-103-g0a7574e

