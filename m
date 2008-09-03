Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbYICMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbYICMCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYICMCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:02:04 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49640 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYICMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:02:01 -0400
Message-ID: <48BE7CB0.7090201@euromail.se>
Date: Wed, 03 Sep 2008 14:01:52 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bcm5974-0.63: Finger counting improved
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1Kar3e-00051X-9N.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Kar3e-00051X-9N f9bfad5a17fceded6cbad49ae17e680a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A finger counting method based on pressure information from all fingers is introduced. Together
with a pressure hysteresis window, this yields a more stable counting of the number of fingers
on the trackpad.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   54 ++++++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ae78bb8..acc401d 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
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
@@ -273,32 +278,47 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct tp_finger *f = dev->tp_data->finger;
 	struct input_dev *input = dev->input;
 	const int fingers = (size - 26) / 28;
-	int p = 0, w, x, y, n = 0;
+	int nmin = 0, nmax = 0, p = 0, w = 0, x = 0, y = 0;

 	if (size < 26 || (size - 26) % 28 != 0)
 		return -EIO;

-	if (fingers) {
-		p = raw2int(f->force_major);
-		w = raw2int(f->size_major);
-		x = raw2int(f->abs_x);
-		y = raw2int(f->abs_y);
-		n = p > 0 ? fingers : 0;
-
-		dprintk(9,
-			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
-			p, w, x, y, n);
+	for (; f != dev->tp_data->finger + fingers; f++) {
+		int ptest = raw2int(f->force_major);
+		if (ptest > PRESSURE_LOW) {
+			if (!nmax++) {
+				p = ptest;
+				w = raw2int(f->size_major);
+				x = raw2int(f->abs_x) - c->x.devmin;
+				y = c->y.devmax - raw2int(f->abs_y);
+			}
+		}
+		if (ptest > PRESSURE_HIGH)
+			nmin++;

-		input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
-		input_report_abs(input, ABS_X, int2bound(&c->x, x - c->x.devmin));
-		input_report_abs(input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
 	}

+	if (dev->fingers < nmin)
+		dev->fingers = nmin;
+	if (dev->fingers > nmax)
+		dev->fingers = nmax;
+
+	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);
+
 	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
+	input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
+
+	if (nmax > 0) {
+		dprintk(9,
+			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d "
+			"nmin: %d nmax: %d\n",
+			p, w, x, y, nmin, nmax);

-	input_report_key(input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
+		input_report_abs(input, ABS_X, int2bound(&c->x, x));
+		input_report_abs(input, ABS_Y, int2bound(&c->y, y));
+	}

 	input_sync(input);

-- 
1.5.4.3

