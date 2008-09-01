Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYIAUIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYIAUIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYIAUIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:08:40 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39238 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbYIAUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:08:39 -0400
Message-ID: <48BC4BC3.1080903@euromail.se>
Date: Mon, 01 Sep 2008 22:08:35 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] input: bcm5974-0.61: New default mouse driver mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KaFhU-00052V-7p.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KaFhU-00052V-7p a74bb7430bdbdf51f30d8c94dd8a78ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the Apple bcm5974 driver only mimics a synaptics touchpad, not a mouse.
This creates unnecessary complications on systems where the synaptics driver is absent
or not configured, such as in a completely new system, or a text console. This patch
provides a default compatibility configuration, which works as a multi-button mouse,
implemented using rudimentary multi-finger options. It yields the following benefits:

* A default Xorg configuration will pick up the mouse input interface, resulting in a
functional mouse pointer out-of-the-box on many systems.

* Two-finger scroll emulates a mouse wheel.

* Three-finger swipe emulates a horizontal mouse wheel.

* Multi-finger clicks emulate the middle and right mouse buttons.

* The mouse driver also works with gpm in text consoles, providing cut-and-paste functionality.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |  238 ++++++++++++++++++++++++++++++++++------
 1 files changed, 202 insertions(+), 36 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ae78bb8..7e18793 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -84,10 +84,33 @@ MODULE_LICENSE("GPL");
 #define dprintk(level, format, a...)\
 	{ if (debug >= level) printk(KERN_DEBUG format, ##a); }

+#define MODE_MOUSE	1
+#define MODE_TOUCHPAD	2
+
 static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activate debugging output");

+static int driver_mode = MODE_MOUSE;
+module_param(driver_mode, int, 0644);
+MODULE_PARM_DESC(driver_mode, "Driver mode (1 - mouse; 2 - touchpad)");
+
+static int mouse_motion_damping = 8;
+module_param(mouse_motion_damping, int, 0644);
+MODULE_PARM_DESC(mouse_motion_damping, "Mouse motion damping");
+
+static int mouse_wheel_damping = 256;
+module_param(mouse_wheel_damping, int, 0644);
+MODULE_PARM_DESC(mouse_wheel_damping, "Vertical mouse wheel damping");
+
+static int mouse_hwheel_damping = 256;
+module_param(mouse_hwheel_damping, int, 0644);
+MODULE_PARM_DESC(mouse_hwheel_damping, "Horizontal mouse wheel damping");
+
+static int mouse_button_mode = 2;
+module_param(mouse_button_mode, int, 0644);
+MODULE_PARM_DESC(mouse_button_mode, "Mouse button mode (1 - unix; 2 - macos)");
+
 /* button data structure */
 struct bt_data {
 	u8 unknown1;		/* constant */
@@ -146,6 +169,15 @@ struct bcm5974_config {
 	struct bcm5974_param y;	/* vertical limits */
 };

+/* mouse driver state */
+struct bcm5974_mouse_state {
+	int fingers;			/* number of fingers on trackpad */
+	int rel_x;			/* horizontal relative counter */
+	int rel_y;			/* vertical relative counter */
+	int wheel_x;			/* horizontal wheel counter */
+	int wheel_y;			/* vertical wheel counter */
+};
+
 /* logical device structure */
 struct bcm5974 {
 	char phys[64];
@@ -159,6 +191,7 @@ struct bcm5974 {
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	struct tp_data *tp_data;	/* trackpad transferred data */
+	struct bcm5974_mouse_state ms;	/* mouse state */
 };

 /* logical dimensions */
@@ -236,71 +269,204 @@ static inline int int2bound(const struct bcm5974_param *p, int x)
 static void setup_events_to_report(struct input_dev *input_dev,
 				   const struct bcm5974_config *cfg)
 {
-	__set_bit(EV_ABS, input_dev->evbit);
-
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-				0, cfg->p.dim, cfg->p.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
-				0, cfg->w.dim, cfg->w.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_X,
-				0, cfg->x.dim, cfg->x.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_Y,
-				0, cfg->y.dim, cfg->y.fuzz, 0);
-
 	__set_bit(EV_KEY, input_dev->evbit);
-	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
+
+	switch (driver_mode) {
+	case MODE_MOUSE:
+		__set_bit(EV_REL, input_dev->evbit);
+		__set_bit(REL_X, input_dev->relbit);
+		__set_bit(REL_Y, input_dev->relbit);
+		__set_bit(REL_HWHEEL, input_dev->relbit);
+		__set_bit(REL_WHEEL, input_dev->relbit);
+		__set_bit(BTN_MIDDLE, input_dev->keybit);
+		__set_bit(BTN_RIGHT, input_dev->keybit);
+		break;
+	case MODE_TOUCHPAD:
+		__set_bit(EV_ABS, input_dev->evbit);
+		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
+		__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+					0, cfg->p.dim, cfg->p.fuzz, 0);
+		input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
+					0, cfg->w.dim, cfg->w.fuzz, 0);
+		input_set_abs_params(input_dev, ABS_X,
+					0, cfg->x.dim, cfg->x.fuzz, 0);
+		input_set_abs_params(input_dev, ABS_Y,
+					0, cfg->y.dim, cfg->y.fuzz, 0);
+		break;
+	}
 }

-/* report button data as logical button state */
+/* update logical mouse button state */
+static void update_bt_mouse_state(struct input_dev *dev,
+				const struct bcm5974_mouse_state *ms,
+				const struct bt_data *bt)
+{
+	const int n = ms->fingers;
+
+	bool left, middle, right;
+	switch (mouse_button_mode) {
+	case 1:
+		left = n <= 1 && bt->button;
+		middle = n == 2 && bt->button;
+		right = n >= 3 && bt->button;
+		break;
+	case 2:
+		left = n <= 1 && bt->button;
+		middle = n >= 3 && bt->button;
+		right = n == 2 && bt->button;
+		break;
+	default:
+		left = bt->button;
+		middle = false;
+		right = false;
+		break;
+	};
+	input_report_key(dev, BTN_LEFT, left);
+	input_report_key(dev, BTN_MIDDLE, middle);
+	input_report_key(dev, BTN_RIGHT, right);
+}
+
+/* update logical touchpad button state */
+static void update_bt_touchpad_state(struct input_dev *dev,
+				const struct bt_data *bt)
+{
+	input_report_key(dev, BTN_LEFT, bt->button);
+}
+
+/* report button data as logical mouse/touchpad button state */
 static int report_bt_state(struct bcm5974 *dev, int size)
 {
 	if (size != sizeof(struct bt_data))
 		return -EIO;

-	input_report_key(dev->input, BTN_LEFT, dev->bt_data->button);
+	switch (driver_mode) {
+	case MODE_MOUSE:
+		update_bt_mouse_state(dev->input, &dev->ms, dev->bt_data);
+		break;
+	case MODE_TOUCHPAD:
+		update_bt_touchpad_state(dev->input, dev->bt_data);
+		break;
+	}
+
 	input_sync(dev->input);

 	return 0;
 }

-/* report trackpad data as logical trackpad state */
-static int report_tp_state(struct bcm5974 *dev, int size)
+/* update logical mouse motion state */
+static void update_tp_mouse_state(struct input_dev *dev,
+				struct bcm5974_mouse_state *ms,
+				const struct bcm5974_config *c,
+				const struct tp_finger *f,
+				int p, int n)
 {
-	const struct bcm5974_config *c = &dev->cfg;
-	const struct tp_finger *f = dev->tp_data->finger;
-	struct input_dev *input = dev->input;
-	const int fingers = (size - 26) / 28;
-	int p = 0, w, x, y, n = 0;
+	int dx = 0, dy = 0, sx = 0, sy = 0, swx = 0, swy = 0;

-	if (size < 26 || (size - 26) % 28 != 0)
-		return -EIO;
+	if (f) {
+		dx = raw2int(f->rel_x);
+		dy = raw2int(f->rel_y);

-	if (fingers) {
-		p = raw2int(f->force_major);
+		dprintk(9,
+			"bcm5974: p: %+05d dx: %+05d dy: %+05d n: %d\n",
+			p, dx, dy, n);
+	}
+
+	if (n >= 3) {
+		/* swipe */
+		ms->rel_x = 0;
+		ms->rel_y = 0;
+		ms->wheel_x += int2scale(&c->x, dx);
+		ms->wheel_y = 0;
+		swx = ms->wheel_x / mouse_hwheel_damping;
+		ms->wheel_x -= swx * mouse_hwheel_damping;
+	} else if (n == 2) {
+		/* scroll */
+		ms->rel_x = 0;
+		ms->rel_y = 0;
+		ms->wheel_x = 0;
+		ms->wheel_y += int2scale(&c->y, dy);
+		swy = ms->wheel_y / mouse_wheel_damping;
+		ms->wheel_y -= swy * mouse_wheel_damping;
+	} else {
+		/* pointer */
+		ms->rel_x += int2scale(&c->x, dx);
+		ms->rel_y += int2scale(&c->y, -dy);
+		ms->wheel_x = 0;
+		ms->wheel_y = 0;
+		sx = ms->rel_x / mouse_motion_damping;
+		sy = ms->rel_y / mouse_motion_damping;
+		ms->rel_x -= sx * mouse_motion_damping;
+		ms->rel_y -= sy * mouse_motion_damping;
+	}
+
+	ms->fingers = n;
+
+	input_report_rel(dev, REL_X, sx);
+	input_report_rel(dev, REL_Y, sy);
+	input_report_rel(dev, REL_HWHEEL, swx);
+	input_report_rel(dev, REL_WHEEL, swy);
+}
+
+/* update logical touchpad state */
+static void update_tp_touchpad_state(struct input_dev *dev,
+				const struct bcm5974_config *c,
+				const struct tp_finger *f,
+				int p, int n)
+{
+	int w, x, y;
+
+	if (f) {
 		w = raw2int(f->size_major);
 		x = raw2int(f->abs_x);
 		y = raw2int(f->abs_y);
-		n = p > 0 ? fingers : 0;

 		dprintk(9,
 			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
 			p, w, x, y, n);

-		input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
-		input_report_abs(input, ABS_X, int2bound(&c->x, x - c->x.devmin));
-		input_report_abs(input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
+		input_report_abs(dev, ABS_TOOL_WIDTH, int2bound(&c->w, w));
+		input_report_abs(dev, ABS_X, int2bound(&c->x, x - c->x.devmin));
+		input_report_abs(dev, ABS_Y, int2bound(&c->y, c->y.devmax - y));
 	}

-	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
+	input_report_abs(dev, ABS_PRESSURE, int2bound(&c->p, p));
+
+	input_report_key(dev, BTN_TOOL_FINGER, n == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, n == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, n > 2);
+}
+
+/* report trackpad data as logical mouse/touchpad state */
+static int report_tp_state(struct bcm5974 *dev, int size)
+{
+	const struct bcm5974_config *c = &dev->cfg;
+	const int fingers = (size - 26) / 28;
+	const struct tp_finger *f = 0;
+	int p = 0, n = 0;
+
+	if (size < 26 || (size - 26) % 28 != 0)
+		return -EIO;
+
+	if (fingers) {
+		f = dev->tp_data->finger;
+		p = raw2int(f->force_major);
+		n = p > 0 ? fingers : 0;
+	}

-	input_report_key(input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
+	switch (driver_mode) {
+	case MODE_MOUSE:
+		update_tp_mouse_state(dev->input, &dev->ms, c, f, p, n);
+		break;
+	case MODE_TOUCHPAD:
+		update_tp_touchpad_state(dev->input, c, f, p, n);
+		break;
+	}

-	input_sync(input);
+	input_sync(dev->input);

 	return 0;
 }
-- 
1.5.4.3

