Return-Path: <linux-kernel-owner+w=401wt.eu-S376165AbXEEBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376165AbXEEBnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031416AbXEEBnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:43:15 -0400
Received: from sp604001mt.neufgp.fr ([84.96.92.60]:64231 "EHLO Smtp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031332AbXEEBnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:43:14 -0400
Date: Sat, 05 May 2007 03:43:10 +0200
From: Florian Loitsch <linux@florian.loitsch.com>
Subject: appletouch position calculation
To: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Message-id: <200705050343.10647.linux@florian.loitsch.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches for the macbook touchpad (appletouch.c):

The first one avoids the interpolation when the number of fingers changes. 
This way user-space programs can filter the jumps that happen at that time.
A patch for the xorg synaptics driver that does exactly that can be found 
here:
http://florian.loitsch.com/touchpad/synaptics/

The second one implements different modes for calculating the position of the 
touchpad configurable through the x_position_mode and y_position_mode 
parameters. The default (0) is the average of all activated sensors (which 
is, what has been done before). The other modes (1, 2 or 3) take into account 
the position of each finger (resp. left-most/top finger, mean of all fingers 
or right-most/bottom finger).

I would appreciate any comments before sending them to the appletouch 
maintainer. (btw is the maintainer Dmitry Torokhov or Alessandro Rubini?)

The patches have been tested on 2.6.20.10 but apply fine on the official 
git-repository dc87c3985e9b442c60994308a96f887579addc39
and the linux-input git-repository 3f07d8796262f6aee135c8dd9a91210da9f888e4

mfg,
// florian loitsch

>From 8e3a295013b18ca8ef2d45fe881103b90afbcea5 Mon Sep 17 00:00:00 2001
From: Florian Loitsch <oss@florian.loitsch.com>
Date: Sat, 5 May 2007 00:28:01 +0200
Subject: [PATCH] don't interpolate movement on finger-change.

---
 drivers/usb/input/appletouch.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/input/appletouch.c b/drivers/usb/input/appletouch.c
index c77291d..7ffe8e7 100644
--- a/drivers/usb/input/appletouch.c
+++ b/drivers/usb/input/appletouch.c
@@ -147,6 +147,7 @@ struct atp {
 	int			valid;		/* are the sensors valid ? */
 	int			x_old;		/* last reported x/y, */
 	int			y_old;		/* used for smoothing */
+	int			fingers_old;	/* used for smoothing too */
 						/* current value of the sensors */
 	signed char		xy_cur[ATP_XSENSORS + ATP_YSENSORS];
 						/* last value of the sensors */
@@ -275,7 +276,7 @@ static inline void atp_report_fingers(struct input_dev 
*input, int fingers)
 
 static void atp_complete(struct urb* urb)
 {
-	int x, y, x_z, y_z, x_f, y_f;
+	int x, y, x_z, y_z, x_f, y_f, fingers;
 	int retval, i, j;
 	struct atp *dev = urb->context;
 
@@ -371,7 +372,7 @@ static void atp_complete(struct urb* urb)
 	if (!dev->valid) {
 		/* first sample */
 		dev->valid = 1;
-		dev->x_old = dev->y_old = -1;
+		dev->fingers_old = dev->x_old = dev->y_old = -1;
 		memcpy(dev->xy_old, dev->xy_cur, sizeof(dev->xy_old));
 
 		if (atp_is_geyser_3(dev)) /* No 17" Macbooks (yet) */
@@ -418,12 +419,13 @@ static void atp_complete(struct urb* urb)
 	y = atp_calculate_abs(dev->xy_acc + ATP_XSENSORS, ATP_YSENSORS,
 			      ATP_YFACT, &y_z, &y_f);
 
+	fingers = max(x_f, y_f);
 	if (x && y) {
 		if (dev->x_old != -1) {
-			x = (dev->x_old * 3 + x) >> 2;
-			y = (dev->y_old * 3 + y) >> 2;
-			dev->x_old = x;
-			dev->y_old = y;
+			if (fingers == dev->fingers_old) {
+				x = (dev->x_old * 3 + x) >> 2;
+				y = (dev->y_old * 3 + y) >> 2;
+			}
 
 			if (debug > 1)
 				printk("appletouch: X: %3d Y: %3d "
@@ -435,8 +437,9 @@ static void atp_complete(struct urb* urb)
 			input_report_abs(dev->input, ABS_Y, y);
 			input_report_abs(dev->input, ABS_PRESSURE,
 					 min(ATP_PRESSURE, x_z + y_z));
-			atp_report_fingers(dev->input, max(x_f, y_f));
+			atp_report_fingers(dev->input, fingers);
 		}
+		dev->fingers_old = fingers;
 		dev->x_old = x;
 		dev->y_old = y;
 	}
-- 
1.5.1


>From b94b05b1e90e6edc30422a62f4d2cde945a8dace Mon Sep 17 00:00:00 2001
From: Florian Loitsch <oss@florian.loitsch.com>
Date: Sat, 5 May 2007 01:41:51 +0200
Subject: [PATCH] different modes to calculate the position.

---
 drivers/usb/input/appletouch.c |  123 +++++++++++++++++++++++++--------------
 1 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/input/appletouch.c b/drivers/usb/input/appletouch.c
index 7ffe8e7..863ac08 100644
--- a/drivers/usb/input/appletouch.c
+++ b/drivers/usb/input/appletouch.c
@@ -136,6 +136,11 @@ MODULE_DEVICE_TABLE (usb, atp_table);
 #define ATP_GEYSER3_MODE_REQUEST_INDEX 0
 #define ATP_GEYSER3_MODE_VENDOR_VALUE 0x04
 
+#define ATP_MEAN_POS 0
+#define ATP_FIRST_FINGER_POS 1
+#define ATP_MEAN_FINGER_POS 2
+#define ATP_LAST_FINGER_POS 3
+
 /* Structure to hold all of our device specific stuff */
 struct atp {
 	char			phys[64];
@@ -183,6 +188,13 @@ static int threshold = ATP_THRESHOLD;
 module_param(threshold, int, 0644);
 MODULE_PARM_DESC(threshold, "Discards any change in data from a sensor 
(trackpad has hundreds of these sensors) less than this value");
 
+static int x_position_mode = ATP_MEAN_POS;
+module_param(x_position_mode, int, 0644);
+MODULE_PARM_DESC(x_position_mode, "0 == mean, 1 == left-most finger, 2 == 
mean of all fingers, 3 == right-most finger");
+static int y_position_mode = ATP_MEAN_POS;
+module_param(y_position_mode, int, 0644);
+MODULE_PARM_DESC(y_position_mode, "0 == mean, 1 == top finger, 2 == mean of 
all fingers, 3 == bottom finger");
+
 static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activate debugging output");
@@ -209,62 +221,85 @@ static inline int atp_is_geyser_3(struct atp *dev)
 		(productId == GEYSER4_JIS_PRODUCT_ID);
 }
 
+/*
+ * depending on the mode either:
+ * - calculates the mean position of all active sensors (ATP_MEAN_POS)
+ * - or calculates the position of each finger and returns
+ *   * the position of the first found finger (ATP_FIRST_FINGER_POS)
+ *   * the mean position of all found fingers (ATP_MEAN_FINGER_POS)
+ *   * the position of the last found finger (ATP_LAST_FINGER_POS)
+ */
 static int atp_calculate_abs(int *xy_sensors, int nb_sensors, int fact,
-			     int *z, int *fingers)
+			     int mode, int *z, int *fingers)
 {
 	int i;
 	/* values to calculate mean */
-	int pcum = 0, psum = 0;
-	int is_increasing = 0;
+	int finger_pcum, finger_psum;
+
+	int finger_pos;
+	int res_pos = 0; /* used as tmp-accumulator too */
+	int first_finger = 1;
 
 	*fingers = 0;
 
-	for (i = 0; i < nb_sensors; i++) {
-		if (xy_sensors[i] < threshold) {
-			if (is_increasing)
-				is_increasing = 0;
+	i = 0;
+	*z = 0;
+	/*
+	 * As introduced by Jason Parekh still searches for humps on the sensors
+	 * (transitions from nonincreasing to increasing) instead of transitions
+	 * from low sensors (no finger reading) to high sensors (finger above
+	 * sensor) to detect fingers.
+	 */
+	do {
+		/* search first/next finger */
+		while (i < nb_sensors && xy_sensors[i] <= threshold) i++;
+		if (i >= nb_sensors)
+			break;
 
-			continue;
+		/* found finger */
+		finger_pcum = (xy_sensors[i] - threshold) * i;
+		finger_psum = (xy_sensors[i] - threshold);
+		i++;
+		/* continue while increasing */
+		while (i < nb_sensors && xy_sensors[i-1] <= xy_sensors[i]) {
+			finger_pcum += (xy_sensors[i] - threshold) * i;
+			finger_psum += (xy_sensors[i] - threshold);
+			i++;
 		}
 
-		/*
-		 * Makes the finger detection more versatile.  For example,
-		 * two fingers with no gap will be detected.  Also, my
-		 * tests show it less likely to have intermittent loss
-		 * of multiple finger readings while moving around (scrolling).
-		 *
-		 * Changes the multiple finger detection to counting humps on
-		 * sensors (transitions from nonincreasing to increasing)
-		 * instead of counting transitions from low sensors (no
-		 * finger reading) to high sensors (finger above
-		 * sensor)
-		 *
-		 * - Jason Parekh <jasonparekh@gmail.com>
-		 */
-		if (i < 1 || (!is_increasing && xy_sensors[i - 1] < xy_sensors[i])) {
-			(*fingers)++;
-			is_increasing = 1;
-		} else if (i > 0 && xy_sensors[i - 1] >= xy_sensors[i]) {
-			is_increasing = 0;
+		/* continue while decreasing (and staying above threshold) */
+		while (i < nb_sensors &&
+		       xy_sensors[i] > threshold &&
+		       xy_sensors[i-1] >= xy_sensors[i])
+		{
+			finger_pcum += (xy_sensors[i] - threshold) * i;
+			finger_psum += (xy_sensors[i] - threshold);
+			i++;
 		}
 
-		/*
-		 * Subtracts threshold so a high sensor that just passes the threshold
-		 * won't skew the calculated absolute coordinate.  Fixes an issue
-		 * where slowly moving the mouse would occassionaly jump a number of
-		 * pixels (let me restate--slowly moving the mouse makes this issue
-		 * most apparent).
-		 */
-		pcum += (xy_sensors[i] - threshold) * i;
-		psum += (xy_sensors[i] - threshold);
-	}
+		if (mode == ATP_MEAN_POS)
+			res_pos += finger_pcum;
+		else {
+			finger_pos = finger_pcum * fact / finger_psum;
+			if ((first_finger && mode == ATP_FIRST_FINGER_POS) ||
+			    mode == ATP_LAST_FINGER_POS)
+				res_pos = finger_pos;
+			else if (mode == ATP_MEAN_FINGER_POS)
+				res_pos += finger_pos;
+		}
 
-	if (psum > 0) {
-		*z = psum;
-		return pcum * fact / psum;
-	}
+		(*fingers)++;
+		*z += finger_psum;
 
-	return 0;
+		first_finger = 0;
+	} while (i < nb_sensors);
+
+	if (mode == ATP_MEAN_POS && *fingers > 0)
+		res_pos = res_pos * fact / *z;
+	else if (mode == ATP_MEAN_FINGER_POS && *fingers > 0)
+		res_pos /= *fingers;
+
+	return res_pos;
 }
 
 static inline void atp_report_fingers(struct input_dev *input, int fingers)
@@ -415,9 +450,9 @@ static void atp_complete(struct urb* urb)
 	dbg_dump("accumulator", dev->xy_acc);
 
 	x = atp_calculate_abs(dev->xy_acc, ATP_XSENSORS,
-			      ATP_XFACT, &x_z, &x_f);
+			      ATP_XFACT, x_position_mode, &x_z, &x_f);
 	y = atp_calculate_abs(dev->xy_acc + ATP_XSENSORS, ATP_YSENSORS,
-			      ATP_YFACT, &y_z, &y_f);
+			      ATP_YFACT, y_position_mode, &y_z, &y_f);
 
 	fingers = max(x_f, y_f);
 	if (x && y) {
-- 
1.5.1

