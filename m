Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbZJLW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbZJLW1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJLW1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:27:53 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:37752 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758154AbZJLW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:27:52 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: bcm5974: report ABS_MT events
Date: Tue, 13 Oct 2009 00:23:43 +0200
Message-Id: <1255386223-4109-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255386223-4109-1-git-send-email-rydberg@euromail.se>
References: <1255386223-4109-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MxTLp-0001yS-BY.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1MxTLp-0001yS-BY e948de742a558ce1fbc07a6ddd13cebb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes bcm5974 report raw multi-touch (MT) data in the form
of ABS_MT events. The module parameter (nomt) may be used to turn off
the effect of this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   53 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index a700422..9c360ac 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -96,6 +96,10 @@ static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activate debugging output");
 
+static int nomt;
+module_param(nomt, int, 0644);
+MODULE_PARM_DESC(nomt, "Disable multitouch (MT) events");
+
 /* button data structure */
 struct bt_data {
 	u8 unknown1;		/* constant */
@@ -139,6 +143,7 @@ struct tp_finger {
 /* trackpad finger data size, empirically at least ten fingers */
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
 #define SIZEOF_ALL_FINGERS	(16 * SIZEOF_FINGER)
+#define MAX_FINGER_ORIENTATION	16384
 
 /* device-specific parameters */
 struct bcm5974_param {
@@ -284,6 +289,28 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	input_set_abs_params(input_dev, ABS_Y,
 				0, cfg->y.dim, cfg->y.fuzz, 0);
 
+	if (!nomt) {
+		/* finger touch area */
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MINOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		/* finger approach area */
+		input_set_abs_params(input_dev, ABS_MT_WIDTH_MAJOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_WIDTH_MINOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		/* finger orientation */
+		input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
+				     -MAX_FINGER_ORIENTATION,
+				     MAX_FINGER_ORIENTATION, 0, 0);
+		/* finger position */
+		input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+				     cfg->x.devmin, cfg->x.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+				     cfg->y.devmin, cfg->y.devmax, 0, 0);
+	}
+
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
@@ -316,7 +343,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
-	int raw_p, raw_w, raw_x, raw_y, raw_n;
+	int raw_p, raw_w, raw_x, raw_y, raw_n, i;
 	int ptest, origin, ibt = 0, nmin = 0, nmax = 0;
 	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
 
@@ -329,6 +356,30 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 
 	/* always track the first finger; when detached, start over */
 	if (raw_n) {
+
+		/* report raw trackpad data */
+		if (!nomt) {
+			for (i = 0; i < raw_n; i++) {
+				int y = c->y.devmin + c->y.devmax;
+				input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+						 raw2int(f[i].force_major));
+				input_report_abs(input, ABS_MT_TOUCH_MINOR,
+						 raw2int(f[i].force_minor));
+				input_report_abs(input, ABS_MT_WIDTH_MAJOR,
+						 raw2int(f[i].size_major));
+				input_report_abs(input, ABS_MT_WIDTH_MINOR,
+						 raw2int(f[i].size_minor));
+				input_report_abs(input, ABS_MT_ORIENTATION,
+						 MAX_FINGER_ORIENTATION -
+						 raw2int(f[i].orientation));
+				input_report_abs(input, ABS_MT_POSITION_X,
+						 raw2int(f[i].abs_x));
+				input_report_abs(input, ABS_MT_POSITION_Y,
+						 y - raw2int(f[i].abs_y));
+				input_mt_sync(input);
+			}
+		}
+
 		raw_p = raw2int(f->force_major);
 		raw_w = raw2int(f->size_major);
 		raw_x = raw2int(f->abs_x);
-- 
1.6.3.3

