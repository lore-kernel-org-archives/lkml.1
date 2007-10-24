Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXJXDyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXJXDyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXJXDyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:54:14 -0400
Received: from mint.qinip.net ([62.100.30.37]:36988 "EHLO mint.qinip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXJXDyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:54:13 -0400
Date: Wed, 24 Oct 2007 05:54:10 +0200
From: Arjan Opmeer <arjan@opmeer.net>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
Message-ID: <20071024035410.GA12650@adopmeer.homeip.net>
References: <20071024035002.GA12026@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024035002.GA12026@adopmeer.homeip.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ado@adopmeer.homeip.net
Subject: [PATCH] Elantech touchpad driver update for kernel 2.6.23-mm1
X-SA-Exim-Version: 4.2.1 (built Tue, 21 Aug 2007 23:39:36 +0000)
X-SA-Exim-Scanned: Yes (on Ado.lan)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Arjan Opmeer <arjan@opmeer.net>

Update to the Elantech touchpad driver. Changes include:

- Absolute mode reporting is now working on my laptop.
- Fixed the use of a wrong constant in the Synaptics Identify query
- Added Synaptics Modes query as newer versions of the Windows Elantech
  driver seem to try that query too.
- Make an educated guess bases on the Synaptics Capabilities query whether
  middle mouse button reporting works and how finger taps are reported.
- Added a debug option.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>

---
diff -purN -X linux-2.6.23-mm1.vanilla/Documentation/dontdiff linux-2.6.23-mm1.vanilla/Documentation/input/elantech.txt linux-2.6.23-mm1.elantech/Documentation/input/elantech.txt
--- linux-2.6.23-mm1.vanilla/Documentation/input/elantech.txt	2007-10-22 05:24:20.000000000 +0200
+++ linux-2.6.23-mm1.elantech/Documentation/input/elantech.txt	2007-10-22 05:24:55.000000000 +0200
@@ -1,68 +1,75 @@
 Elantech Touchpad Driver
 ========================
-	Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+        Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
 
+        Extra information found and provided by Steve Havelka
 
-Configuration of the touchpad is performed by writing register values to the
-corresponding sysfs entries found under /sys/bus/serio/drivers/psmouse/serioX
+Configuration of the touchpad is performed by writing values to registers
+found under sysfs entries /sys/bus/serio/drivers/psmouse/serio?/reg_*.
+
+E.g. to disable tapping while leaving the other settings to the default
+Windows driver value one would:
+
+   echo -n 0x32 > reg_10
 
 
 Registers
----------
+~~~~~~~~~
 
-* reg_10	(Windows driver default value 0x12)
+* reg_10        (Windows driver default value 0x12)
 
    bit   7   6   5   4   3   2   1   0
-         0   C   T   D   L   R   S   E
+         B   C   T   D   L   A   S   E
 
          E: 1 = enable smart edges in other cases
          S: 1 = enable smart edges only when dragging
-         R: 1 = raw mode (needs 4 byte packets, see reg_11)
+         A: 1 = absolute mode (needs 4 byte packets, see reg_11)
          L: 1 = enable drag lock (see reg_22)
          D: 1 = disable dynamic resolution
          T: 1 = disable tapping
          C: 1 = enable corner tap
+         B: 1 = swap left and right button
 
-* reg_11	(Windows driver default value 0x8f)
+* reg_11        (Windows driver default value 0x8f)
 
    bit   7   6   5   4   3   2   1   0
-         1   0   0   H   V   1   P   N
+         1   0   0   H   V   1   F   P
 
-         N: 1 = bit 4 or 5 of byte 0 is 1 (non null top nibble ?)
-         P: 1 = enable native 4 byte packet mode (forced on by driver)
+         P: 1 = enable parity checking for relative mode
+         F: 1 = enable native 4 byte packet mode
          V: 1 = enable vertical scroll area
          H: 1 = enable horizonal scroll area
 
 
-* reg_20	(Windows driver default value 0x0a)
+* reg_20        (Windows driver default value 0x0a)
 
          single finger width?
 
-* reg_21	(Windows driver default value 0x60)
+* reg_21        (Windows driver default value 0x60)
 
          scroll area width (small: 0x40 ... wide: 0xff)
 
-* reg_22	(Windows driver default value 0xff)
+* reg_22        (Windows driver default value 0xff)
 
          drag lock time out (short: 0x14 ... long: 0xfe; 0xff =never)
 
-* reg_23	(Windows driver default value 0x10)
+* reg_23        (Windows driver default value 0x10)
 
          tap make timeout?
 
          Note: the Windows driver does not write this register
 
-* reg_24	(Windows driver default value 0x10)
+* reg_24        (Windows driver default value 0x10)
 
          tap release timeout?
 
          Note: the Windows driver does not write this register
 
-* reg_25	(Windows driver default value 0x03)
+* reg_25        (Windows driver default value 0x03)
 
          smart edge cursor speed (0x02 = slow, 0x03 = medium, 0x04 = fast)
 
-* reg_26	(Windows driver default value 0x00 ?? )
+* reg_26        (Windows driver default value 0x00 ?? )
 
          smart edge activation area width?
 
@@ -77,18 +84,22 @@ Registers
 
 Initially the Elantouch Touchpad is in emulation mode and reports 3 byte
 standard PS/2 packets and hence works with a standard mouse driver.
-However, it can be configured to talk its native 4 byte mode and a raw 4
+However, it can be configured to talk its native 4 byte relative mode and 4
 byte absolute mode both for which a dedicated driver is needed.
 
 
 Native 4 byte relative mode packet format
------------------------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 byte 0:
    bit   7   6   5   4   3   2   1   0
-         c   c   ?   ?   1   M   R   L
+         c   c  p2  p1   1   M   R   L
 
          L, R, M = 1 when Left, Right, Middle mouse button pressed
+            some models have M as byte 3 odd parity
+         when parity checking is enabled (P = 1):
+            p1 = byte 1 odd parity
+            p2 = byte 2 odd parity
          c = 1 when corner tap detected
 
 byte 1:
@@ -106,30 +117,39 @@ byte 2:
 
 byte 3:
    bit   7   6   5   4   3   2   1   0
-         w   h   0   0  d3  d2  d1  d0
+         w   h  n1  n0  d3  d2  d1  d0
 
-         normally:
-            d3..d0 = scroll wheel amount and direction
-                     positive = down or left
-                     negative = up or right
-         when corner tap detected:
-            d0 = 1 when top right corner tapped
-            d1 = 1 when bottom right corner tapped
-            d2 = 1 when bottom left corner tapped
-            d3 = 1 when top left corner tapped
-         w = 1 when wide finger touch?
-         h = 1 when horizontal scroll action
+         when parity checking is enabled (P = 1):
+            normally:
+               d3..d0 = scroll wheel amount and direction
+                        positive = down or left
+                        negative = up or right
+            when corner tap detected:
+               d0 = 1 when top right corner tapped
+               d1 = 1 when bottom right corner tapped
+               d2 = 1 when bottom left corner tapped
+               d3 = 1 when top left corner tapped
+            n1..n0 = number of fingers on touchpad
+               not all models report this but map one, two and three
+               finger taps directly to L, M and R mouse buttons
+            w = 1 when wide finger touch?
+            h = 1 when horizontal scroll action
+         otherwise (P = 0):
+            all of byte 3 is vertical scroll amount and direction
+            negative = up
+            positive = down
 
 
-Native 4 byte raw absolute mode packet format
----------------------------------------------
+Native 4 byte absolute mode packet format
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 byte 0:
    bit   7   6   5   4   3   2   1   0
-         0   0  z2  z1   1  z0   R   L
+         D   U  p1  p2   1  p3   R   L
 
          L, R = 1 when Left, Right mouse button pressed
-         z2..z0 = some touch weigth?
+         p1..p3 = parity bit of bytes 1..3
+         D, U = 1 when rocker switch pressed Up, Down
 
 byte 1:
    bit   7   6   5   4   3   2   1   0
diff -purN -X linux-2.6.23-mm1.vanilla/Documentation/dontdiff linux-2.6.23-mm1.vanilla/drivers/input/mouse/elantech.c linux-2.6.23-mm1.elantech/drivers/input/mouse/elantech.c
--- linux-2.6.23-mm1.vanilla/drivers/input/mouse/elantech.c	2007-10-22 05:17:57.000000000 +0200
+++ linux-2.6.23-mm1.elantech/drivers/input/mouse/elantech.c	2007-10-22 05:48:47.000000000 +0200
@@ -18,14 +18,12 @@
 #include "synaptics.h"
 #include "elantech.h"
 
-#define ETP_RAW_MODE 		0x04
-#define ETP_4_BYTE_MODE 	0x02
-
-/* These values work with the touchpad on my laptop. Do they need adjustment? */
-#define ETP_XMIN 		32
-#define ETP_XMAX 		0x240
-#define ETP_YMIN 		32
-#define ETP_YMAX 		0x160
+/*
+ * Native absolute mode reporting has odd parity check on the last 3 bytes.
+ * Native relative mode can have odd parity checking on second and third byte,
+ * or last 3 bytes depending on model.
+ */
+static unsigned char parity[256];
 
 /*
  * Send a synaptics style special commands
@@ -49,7 +47,7 @@ static int elantech_write_reg(struct psm
 	if ((reg > 0x11) && (reg < 0x20))
 		return -1;
 
-	if (psmouse_sliced_command(psmouse, ELANTECH_COMMAND) ||
+	if (psmouse_sliced_command(psmouse, ELANTECH_COMMAND_START) ||
 	    psmouse_sliced_command(psmouse, reg) ||
 	    psmouse_sliced_command(psmouse, val) ||
 	    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
@@ -59,67 +57,153 @@ static int elantech_write_reg(struct psm
 	return 0;
 }
 
+static void elantech_packet_dump(unsigned char *packet, int size)
+{
+	int	i;
+
+	printk(KERN_DEBUG "elantech.c: PS/2 packet [");
+	for (i = 0; i < size; i++)
+		printk("%s0x%02x ", (i) ? ", " : " ", packet[i]);
+	printk("]\n");
+}
+
 /*
- * Process byte stream from mouse and interpret complete data packages
+ * Report absolute mode input events
  */
-static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
+static void elantech_report_absolute(struct psmouse *psmouse)
 {
 	struct elantech_data 	*etd = psmouse->private;
 	struct input_dev 	*dev = psmouse->dev;
 	unsigned char 		*packet = psmouse->packet;
-	unsigned int 		z;
+	int			fingers;
 
-	if (psmouse->pktcnt < 4)
-		return PSMOUSE_GOOD_DATA;
+	/* byte 0:  D   U  p1  p2   1  p3   R   L
+	 * byte 1:  f   0  th  tw  x9  x8  y9  y8
+	 * byte 2: x7  x6  x5  x4  x3  x2  x1  x0
+	 * byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
+	fingers = ((packet[1] & 0x80) >> 7) + ((packet[1] & 0x30) >> 4);
+	input_report_key(dev, BTN_TOUCH, fingers != 0);
+	if (fingers == 1) {
+		input_report_abs(dev, ABS_X,
+			((packet[1] & 0x0c) << 6) | packet[2]);
+		input_report_abs(dev, ABS_Y, ETP_YMAX -
+			(((packet[1] & 0x03) << 8) | packet[3]));
+	}
+	input_report_abs(dev, ABS_PRESSURE, (fingers) ? ETP_DEF_PRESSURE : 0);
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
+		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40); /* rocker up */
+		input_report_key(dev, BTN_BACK, packet[0] & 0x80); /* rocker down */
+	}
+}
 
-	if (etd->reg_10 & ETP_RAW_MODE) {
-		/*
-		 * What to do with this value? It varies too wildly to work
-		 * as a useful z distance
-		 */
-		z = ((packet[0] & 0x30) >> 3) | ((packet[0] & 0x04) >> 2);
-		input_report_key(dev, BTN_TOUCH, packet[1] & 0x80);
-		if ((packet[1] & 0x30) == 0) {
-			input_report_abs(dev, ABS_X,
-				((packet[1] & 0x0c) << 6) | packet[2]);
-			input_report_abs(dev, ABS_Y,
-				ETP_YMIN + ETP_YMAX -
-				(((packet[1] & 0x03) << 8) | packet[3]));
-		}
-		input_report_key(dev, BTN_TOOL_FINGER,    packet[1] & 0x80);
-		input_report_key(dev, BTN_TOOL_DOUBLETAP, packet[1] & 0x10);
-		input_report_key(dev, BTN_TOOL_TRIPLETAP, packet[1] & 0x20);
-		input_report_key(dev, BTN_LEFT,  packet[0] & 0x01);
-		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
-	} else {
-		input_report_key(dev, BTN_LEFT,   packet[0] & 0x01);
+/*
+ * Report relative mode input events
+ */
+static void elantech_report_relative(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+	int 			fingers, cornertap;
+
+	/* byte 0:  c   c  p2  p1   1   M   R   L
+	 * byte 1: dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
+	 * byte 2: dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
+	 * byte 3:  w   h  n1  n0  d3  d2  d1  d0 */
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+
+	if (etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)
 		input_report_key(dev, BTN_MIDDLE, packet[0] & 0x04);
-		input_report_key(dev, BTN_RIGHT,  packet[0] & 0x02);
 
-		if ((packet[0] & 0xc0) && (packet[1] & 0xf0)) {
-			input_report_key(dev, BTN_0, packet[3] & 0x01);	/* top right */
-			input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
-			input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
-			input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
-		} else if (packet[3] & 0x0f) {
-			if (packet[3] & 0x40)
+	if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
+		fingers = (packet[3] & 0x30) >> 4;
+		input_report_key(dev, BTN_LEFT, fingers == 1);
+		input_report_key(dev, BTN_MIDDLE, fingers == 2);
+		input_report_key(dev, BTN_RIGHT, fingers == 3);
+	}
+
+	cornertap = (((packet[0] & 0xc0) == 0xc0) && ((packet[1] & 0xf0) == 0xf0));
+	if (!cornertap) {
+		input_report_rel(dev, REL_X, (int) (packet[1] & 0x7f) -
+					     (int) (packet[1] & 0x80));
+		input_report_rel(dev, REL_Y, (int) (packet[2] & 0x80) -
+					     (int) (packet[2] & 0x7f));
+	}
+
+	/* No more information in 3 bytes */
+	if (!(etd->reg_11 & ETP_R11_4_BYTE_MODE))
+		return;
+
+	if (cornertap) {
+		input_report_key(dev, BTN_0, packet[3] & 0x01);	/* top right */
+		input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
+		input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
+		input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
+	}
+
+	if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
+		if (packet[3] & 0x0f) {
+			if (packet[3] & 0x40) {
 				input_report_rel(dev, REL_HWHEEL,
 					(int) (packet[3] & 0x08) -
 					(int) (packet[3] & 0x07));
-			else
+			} else {
 				input_report_rel(dev, REL_WHEEL,
 					(int) (packet[3] & 0x08) -
 					(int) (packet[3] & 0x07));
+			}
 		}
+	} else {
+		if (packet[3])
+			input_report_rel(dev, REL_WHEEL,
+				(int) (packet[3] & 0x80) -
+				(int) (packet[3] & 0x7f));
+	}
+}
 
-		if (packet[1])
-			input_report_rel(dev, REL_X,
-				(int) (packet[1] & 0x7f) -
-				(int) (packet[1] & 0x80));
-		if (packet[2])
-			input_report_rel(dev, REL_Y,
-				(int) (packet[2] & 0x80) -
-				(int) (packet[2] & 0x7f));
+/*
+ * Process byte stream from mouse and interpret complete data packets
+ */
+static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+
+	if (psmouse->pktcnt < psmouse->pktsize)
+		return PSMOUSE_GOOD_DATA;
+
+	if (etd->debug)
+		elantech_packet_dump(packet, psmouse->pktsize);
+
+	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L */
+		if ((parity[packet[1]] != ((packet[0] & 0x20) >> 5)) ||
+		    (parity[packet[2]] != ((packet[0] & 0x10) >> 4)) ||
+		    (parity[packet[3]] != ((packet[0] & 0x04) >> 2)))
+			return PSMOUSE_BAD_DATA;
+	} else if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
+		/* byte 0:  c   c  p2  p1   1   M   R   L */
+		if ((parity[packet[1]] != ((packet[0] & 0x10) >> 4)) ||
+		    (parity[packet[2]] != ((packet[0] & 0x20) >> 5)))
+			return PSMOUSE_BAD_DATA;
+		/* Parity bit has not been sacrificed as middle mouse button bit */
+		if (!(etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)) {
+			if (parity[packet[3]] != ((packet[0] & 0x04) >> 2))
+				return PSMOUSE_BAD_DATA;
+		}
+	}
+
+	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+		elantech_report_absolute(psmouse);
+	} else {
+		elantech_report_relative(psmouse);
 	}
 
 	input_sync(dev);
@@ -183,6 +267,12 @@ static void elantech_set_defaults(struct
 	set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
 	set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
 
+	/* Rocker button */
+	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
+		set_bit(BTN_FORWARD, dev->keybit);
+		set_bit(BTN_BACK, dev->keybit);
+	}
+
 	/* Corner taps */
 	set_bit(BTN_0, dev->keybit);
 	set_bit(BTN_1, dev->keybit);
@@ -198,6 +288,7 @@ static void elantech_set_defaults(struct
 	set_bit(EV_ABS, dev->evbit);
 	input_set_abs_params(dev, ABS_X, ETP_XMIN, ETP_XMAX, 0, 0);
 	input_set_abs_params(dev, ABS_Y, ETP_YMIN, ETP_YMAX, 0, 0);
+	input_set_abs_params(dev, ABS_PRESSURE, 0, ETP_MAX_PRESSURE, 0, 0);
 }
 
 struct elantech_attr_data {
@@ -235,9 +326,26 @@ static ssize_t elantech_set_int_attr(str
 	if (*rest || value > 255)
 		return -EINVAL;
 
-	/* Force 4 byte packet mode because driver expects this */
-	if (attr->reg == 0x11)
-		value |= ETP_4_BYTE_MODE;
+	if (attr->reg == 0x10) {
+		/* Force on 4 byte mode when absolute mode gets selected */
+		if ((value & ETP_R10_ABSOLUTE_MODE) &&
+		   !(etd->reg_11 & ETP_R11_4_BYTE_MODE)) {
+			etd->reg_11 |= ETP_R11_4_BYTE_MODE;
+			elantech_write_reg(psmouse, 0x11, etd->reg_11);
+			psmouse->pktsize = 4;
+		}
+	} else if (attr->reg == 0x11) {
+		if (value & ETP_R11_4_BYTE_MODE)
+			psmouse->pktsize = 4;
+		else {
+			/* Force off absolute mode when 4 byte mode is no longer selected */
+			if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+				etd->reg_10 ^= ETP_R10_ABSOLUTE_MODE;
+				elantech_write_reg(psmouse, 0x10, etd->reg_10);
+			}
+			psmouse->pktsize = 3;
+		}
+	}
 
 	*reg = value;
 	elantech_write_reg(psmouse, attr->reg, value);
@@ -264,6 +372,7 @@ ELANTECH_INT_ATTR(reg_23, 0x23);
 ELANTECH_INT_ATTR(reg_24, 0x24);
 ELANTECH_INT_ATTR(reg_25, 0x25);
 ELANTECH_INT_ATTR(reg_26, 0x26);
+ELANTECH_INT_ATTR(debug, 0);
 
 static struct attribute *elantech_attrs[] = {
 	&psmouse_attr_reg_10.dattr.attr,
@@ -275,6 +384,7 @@ static struct attribute *elantech_attrs[
 	&psmouse_attr_reg_24.dattr.attr,
 	&psmouse_attr_reg_25.dattr.attr,
 	&psmouse_attr_reg_26.dattr.attr,
+	&psmouse_attr_debug.dattr.attr,
 	NULL
 };
 
@@ -312,16 +422,6 @@ int elantech_detect(struct psmouse *psmo
 			param[0], param[1], param[2]);
 		return -1;
 	}
-	/* Why does the Elantech Windows driver try this?
-	 * For now just report it and see if it makes sense
-	 * when more people use this driver
-	 */
-	if (!synaptics_send_cmd(psmouse, SYN_QUE_MODEL, param))
-		pr_info("elantech.c: Synaptics identify query result 0x%02x, 0x%02x, 0x%02x.\n",
-			param[0], param[1], param[2]);
-	if (!synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, param))
-		pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
-			param[0], param[1], param[2]);
 
 	if (set_properties) {
 		psmouse->vendor = "Elantech";
@@ -336,14 +436,36 @@ int elantech_detect(struct psmouse *psmo
  */
 int elantech_init(struct psmouse *psmouse)
 {
-	struct elantech_data 	*priv;
-	int			error;
-
-	priv = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
-	psmouse->private = priv;
-	if (!priv)
+	struct elantech_data 	*etd;
+	int			i, error;
+	unsigned char		param[3];
+
+	etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
+	psmouse->private = etd;
+	if (!etd)
 		return -1;
 
+	parity[0] = 1;
+	for (i = 1; i < 256; i++)
+		parity[i] = (parity[i & (i - 1)] ^ 1);
+
+	/*
+	 * Why does the Elantech Windows driver try this?
+	 * For now just report it and see if it makes sense
+	 * when more people use this driver
+	 */
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_IDENTIFY, param))
+		pr_info("elantech.c: Synaptics identify query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_MODES, param))
+		pr_info("elantech.c: Synaptics modes query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, param)) {
+		pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+		etd->capabilities = param[0];
+	}
+
 	elantech_set_defaults(psmouse);
 
 	psmouse->protocol_handler = elantech_process_byte;
@@ -355,7 +477,7 @@ int elantech_init(struct psmouse *psmous
 	if (error) {
 		printk(KERN_ERR "elantech.c: failed to create sysfs attributes, error: %d\n",
 			error);
-		kfree(priv);
+		kfree(etd);
 		return -1;
 	}
 
diff -purN -X linux-2.6.23-mm1.vanilla/Documentation/dontdiff linux-2.6.23-mm1.vanilla/drivers/input/mouse/elantech.h linux-2.6.23-mm1.elantech/drivers/input/mouse/elantech.h
--- linux-2.6.23-mm1.vanilla/drivers/input/mouse/elantech.h	2007-10-22 05:17:57.000000000 +0200
+++ linux-2.6.23-mm1.elantech/drivers/input/mouse/elantech.h	2007-10-22 05:25:23.000000000 +0200
@@ -13,7 +13,43 @@
 #ifndef _ELANTECH_H
 #define _ELANTECH_H
 
-#define ELANTECH_COMMAND	0x11	/* Commands start with this value */
+/*
+ * Commands start with this value
+ */
+#define ELANTECH_COMMAND_START		0x11
+
+/*
+ * Register bitmasks
+ */
+#define ETP_R10_ABSOLUTE_MODE		0x04
+#define ETP_R11_PARITY_CHECKING		0x01
+#define ETP_R11_4_BYTE_MODE 		0x02
+
+/*
+ * Capability bitmasks
+ */
+#define ETP_CAP_REPORTS_MIDDLE_BUTTON	0x02
+#define ETP_CAP_HAS_ROCKER		0x04
+#define ETP_CAP_ALTERNATE_TAP_BITS	0x10
+
+/*
+ * One hard to find application note states that X axis range is 0 to 576
+ * and Y axis range is 0 to 384.
+ * Edge fuzz might be necessary because of bezel around the touchpad.
+ */
+#define ETP_EDGE_FUZZ			32
+
+#define ETP_XMIN 			(  0 + ETP_EDGE_FUZZ)
+#define ETP_XMAX 			(576 - ETP_EDGE_FUZZ)
+#define ETP_YMIN 			(  0 + ETP_EDGE_FUZZ)
+#define ETP_YMAX 			(384 - ETP_EDGE_FUZZ)
+
+/*
+ * It seems the touchpad does not report pressure.
+ * Just choose some values for compatibility with X Synaptics driver
+ */
+#define ETP_MAX_PRESSURE		127
+#define ETP_DEF_PRESSURE		64
 
 struct elantech_data {
 	unsigned char reg_10;
@@ -25,6 +61,8 @@ struct elantech_data {
 	unsigned char reg_24;
 	unsigned char reg_25;
 	unsigned char reg_26;
+	unsigned char debug;
+	unsigned char capabilities;
 };
 
 #ifdef CONFIG_MOUSE_PS2_ELANTECH
