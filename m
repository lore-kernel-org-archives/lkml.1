Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYA0IZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYA0IZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYA0IYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:24:55 -0500
Received: from mint.qinip.net ([62.100.30.37]:42273 "EHLO mint.qinip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYA0IYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:24:54 -0500
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 03:24:53 EST
Date: Sun, 27 Jan 2008 09:02:24 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
Message-ID: <20080127080224.GA17196@adopmeer.homeip.net>
References: <20080127080005.GA17072@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127080005.GA17072@adopmeer.homeip.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ado@adopmeer.homeip.net
Subject: [PATCH] Elantech touchpad driver update for kernel 2.6.24-rc8-mm1
X-SA-Exim-Version: 4.2.1 (built Tue, 21 Aug 2007 23:39:36 +0000)
X-SA-Exim-Scanned: Yes (on Ado.lan)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Arjan Opmeer <arjan@opmeer.net>

Update to the Elantech touchpad driver. Changes include:

- Fixed an issue on some models where using the physical buttons did not
  work and only tapping the touchpad produced mouse clicks.
- Absolute mode reporting also has an "older" and "newer" packet format
  where the finger tap and parity bits are placed differently. The driver
  makes an educated guess based on the Synaptics Capabilities query which
  layout to expect.
- Implemented a reconnect handler to make suspend and resume work without
  the touchpad and the driver getting out of sync.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>

---

diff -purN -X linux-2.6.24-rc8-mm1.vanilla/Documentation/dontdiff linux-2.6.24-rc8-mm1.vanilla/Documentation/input/elantech.txt linux-2.6.24-rc8-mm1.elantech/Documentation/input/elantech.txt
--- linux-2.6.24-rc8-mm1.vanilla/Documentation/input/elantech.txt	2008-01-26 03:47:16.000000000 +0100
+++ linux-2.6.24-rc8-mm1.elantech/Documentation/input/elantech.txt	2008-01-26 03:50:32.000000000 +0100
@@ -1,17 +1,43 @@
 Elantech Touchpad Driver
 ========================
-        Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+        Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
 
         Extra information found and provided by Steve Havelka
 
-Configuration of the touchpad is performed by writing values to registers
-found under sysfs entries /sys/bus/serio/drivers/psmouse/serio?/reg_*.
+
+Introduction
+~~~~~~~~~~~~
+
+Like most touchpads the Elantech touchpad can be in two modes. One is called
+relative mode in which the touchpad uses its internal controller to
+translate touching the pad and moving your finger into mouse movement
+updates. In this mode the touchpad acts just like a normal wired mouse.
+
+The other is called absolute mode in which the touchpad merely acts as an XY
+grid and as long as there is a finger on the pad continuously sends the
+coordinates of the finger to the driver. Think of it like a tablet where
+your finger is the stylus.
+
+In relative mode the operation of the touchpad can be influenced by
+adjusting the contents of some registers. These registers are represented by
+the driver as sysfs entries under /sys/bus/serio/drivers/psmouse/serio? that
+can be read from and written to.
 
 E.g. to disable tapping while leaving the other settings to the default
-Windows driver value one would:
+Windows driver value one would do:
 
    echo -n 0x32 > reg_10
 
+and to switch the touchpad to absolute mode one would do:
+
+   echo -n 0x16 > reg_10
+
+In absolute mode the touchpad is not using the internal controller, so
+adjusting the registers no longer has the desired effect. However, the
+driver makes sure that in this mode the touchpad can be used with the Xorg
+synaptics driver so any one of the Synaptics configuration utilities should
+also work for adjusting the operation of the Elantech touchpad.
+
 
 Registers
 ~~~~~~~~~
@@ -21,7 +47,7 @@ Registers
    bit   7   6   5   4   3   2   1   0
          B   C   T   D   L   A   S   E
 
-         E: 1 = enable smart edges in other cases
+         E: 1 = enable smart edges unconditionally
          S: 1 = enable smart edges only when dragging
          A: 1 = absolute mode (needs 4 byte packets, see reg_11)
          L: 1 = enable drag lock (see reg_22)
@@ -38,7 +64,7 @@ Registers
          P: 1 = enable parity checking for relative mode
          F: 1 = enable native 4 byte packet mode
          V: 1 = enable vertical scroll area
-         H: 1 = enable horizonal scroll area
+         H: 1 = enable horizontal scroll area
 
 
 * reg_20        (Windows driver default value 0x0a)
@@ -82,7 +108,7 @@ Registers
 
 
 
-Initially the Elantouch Touchpad is in emulation mode and reports 3 byte
+Initially the Elantech touchpad is in emulation mode and reports 3 byte
 standard PS/2 packets and hence works with a standard mouse driver.
 However, it can be configured to talk its native 4 byte relative mode and 4
 byte absolute mode both for which a dedicated driver is needed.
@@ -96,10 +122,9 @@ byte 0:
          c   c  p2  p1   1   M   R   L
 
          L, R, M = 1 when Left, Right, Middle mouse button pressed
-            some models have M as byte 3 odd parity
+            some models have M as byte 3 odd parity bit
          when parity checking is enabled (P = 1):
-            p1 = byte 1 odd parity
-            p2 = byte 2 odd parity
+            p1..p2 = byte 1 and 2 odd parity bit
          c = 1 when corner tap detected
 
 byte 1:
@@ -116,48 +141,72 @@ byte 2:
          dy7..dy0 = y movement;   positive = up,    negative = down
 
 byte 3:
-   bit   7   6   5   4   3   2   1   0
-         w   h  n1  n0  d3  d2  d1  d0
+   parity checking enabled (reg_11, P = 1):
+
+      bit   7   6   5   4   3   2   1   0
+            w   h  n1  n0  ds3 ds2 ds1 ds0
 
-         when parity checking is enabled (P = 1):
             normally:
-               d3..d0 = scroll wheel amount and direction
-                        positive = down or left
-                        negative = up or right
+               ds3..ds0 = scroll wheel amount and direction
+                          positive = down or left
+                          negative = up or right
             when corner tap detected:
-               d0 = 1 when top right corner tapped
-               d1 = 1 when bottom right corner tapped
-               d2 = 1 when bottom left corner tapped
-               d3 = 1 when top left corner tapped
+               ds0 = 1 when top right corner tapped
+               ds1 = 1 when bottom right corner tapped
+               ds2 = 1 when bottom left corner tapped
+               ds3 = 1 when top left corner tapped
             n1..n0 = number of fingers on touchpad
                not all models report this but map one, two and three
                finger taps directly to L, M and R mouse buttons
-            w = 1 when wide finger touch?
             h = 1 when horizontal scroll action
-         otherwise (P = 0):
-            all of byte 3 is vertical scroll amount and direction
-            negative = up
-            positive = down
+            w = 1 when wide finger touch?
+
+   otherwise (reg_11, P = 0):
+
+      bit   7   6   5   4   3   2   1   0
+           ds7 ds6 ds5 ds4 ds3 ds2 ds1 ds0
+
+            ds7..ds0 = vertical scroll amount and direction
+                       negative = up
+                       positive = down
 
 
 Native 4 byte absolute mode packet format
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 byte 0:
-   bit   7   6   5   4   3   2   1   0
-         D   U  p1  p2   1  p3   R   L
+   older models:
+
+      bit   7   6   5   4   3   2   1   0
+            D   U  p1  p2   1  p3   R   L
 
-         L, R = 1 when Left, Right mouse button pressed
-         p1..p3 = parity bit of bytes 1..3
-         D, U = 1 when rocker switch pressed Up, Down
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            D, U = 1 when rocker switch pressed Up, Down
+
+   newer models:
+
+      bit   7   6   5   4   3   2   1   0
+           n1  n0  p2  p1   1  p3   R   L
+
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            n1..n0 = number of fingers on touchpad
 
 byte 1:
-   bit   7   6   5   4   3   2   1   0
-         f   0  th  tw  x9  x8  y9  y8
+   older models:
+
+      bit   7   6   5   4   3   2   1   0
+            f   0  th  tw  x9  x8  y9  y8
+
+            tw = 1 when two finger touch
+            th = 1 when three finger touch
+            f  = 1 when finger touch
+
+   newer models:
 
-         tw = 1 when two finger touch
-         th = 1 when three finger touch
-         f  = 1 when finger touch
+      bit   7   6   5   4   3   2   1   0
+            0   0   0   0  x9  x8  y9  y8
 
 byte 2:
    bit   7   6   5   4   3   2   1   0
diff -purN -X linux-2.6.24-rc8-mm1.vanilla/Documentation/dontdiff linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/elantech.c linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/elantech.c
--- linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/elantech.c	2008-01-26 03:47:23.000000000 +0100
+++ linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/elantech.c	2008-01-26 03:50:54.000000000 +0100
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver
+ * Elantech Touchpad driver (v3)
  *
- * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -57,6 +57,9 @@ static int elantech_write_reg(struct psm
 	return 0;
 }
 
+/*
+ * Dump a complete mouse movement packet to the syslog
+ */
 static void elantech_packet_dump(unsigned char *packet, int size)
 {
 	int	i;
@@ -77,12 +80,18 @@ static void elantech_report_absolute(str
 	unsigned char 		*packet = psmouse->packet;
 	int			fingers;
 
-	/* byte 0:  D   U  p1  p2   1  p3   R   L
-	 * byte 1:  f   0  th  tw  x9  x8  y9  y8
-	 * byte 2: x7  x6  x5  x4  x3  x2  x1  x0
-	 * byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
-	fingers = ((packet[1] & 0x80) >> 7) + ((packet[1] & 0x30) >> 4);
+	if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
+		/* byte 0: n1  n0  p2  p1   1  p3   R   L
+		 * byte 1:  0   0   0   0  x9  x8  y9  y8 */
+		fingers = (packet[0] & 0xc0) >> 6;
+	} else {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L
+		 * byte 1:  f   0  th  tw  x9  x8  y9  y8 */
+		fingers = ((packet[1] & 0x80) >> 7) + ((packet[1] & 0x30) >> 4);
+	}
 	input_report_key(dev, BTN_TOUCH, fingers != 0);
+	/* byte 2: x7  x6  x5  x4  x3  x2  x1  x0
+	 * byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
 	if (fingers == 1) {
 		input_report_abs(dev, ABS_X,
 			((packet[1] & 0x0c) << 6) | packet[2]);
@@ -95,7 +104,8 @@ static void elantech_report_absolute(str
 	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
-	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
+	if (!(etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) &&
+	     (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
 		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40); /* rocker up */
 		input_report_key(dev, BTN_BACK, packet[0] & 0x80); /* rocker down */
 	}
@@ -114,7 +124,7 @@ static void elantech_report_relative(str
 	/* byte 0:  c   c  p2  p1   1   M   R   L
 	 * byte 1: dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
 	 * byte 2: dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
-	 * byte 3:  w   h  n1  n0  d3  d2  d1  d0 */
+	 * byte 3:  w   h  n1  n0  ds3 ds2 ds1 ds0 */
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
 
@@ -123,9 +133,11 @@ static void elantech_report_relative(str
 
 	if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
 		fingers = (packet[3] & 0x30) >> 4;
-		input_report_key(dev, BTN_LEFT, fingers == 1);
-		input_report_key(dev, BTN_MIDDLE, fingers == 2);
-		input_report_key(dev, BTN_RIGHT, fingers == 3);
+		if (fingers) {
+			input_report_key(dev, BTN_LEFT, fingers == 1);
+			input_report_key(dev, BTN_MIDDLE, fingers == 2);
+			input_report_key(dev, BTN_RIGHT, fingers == 3);
+		}
 	}
 
 	cornertap = (((packet[0] & 0xc0) == 0xc0) && ((packet[1] & 0xf0) == 0xf0));
@@ -145,6 +157,7 @@ static void elantech_report_relative(str
 		input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
 		input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
 		input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
+		return;
 	}
 
 	if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
@@ -175,6 +188,7 @@ static psmouse_ret_t elantech_process_by
 	struct elantech_data 	*etd = psmouse->private;
 	struct input_dev 	*dev = psmouse->dev;
 	unsigned char 		*packet = psmouse->packet;
+	unsigned char		p1, p2, p3;
 
 	if (psmouse->pktcnt < psmouse->pktsize)
 		return PSMOUSE_GOOD_DATA;
@@ -183,19 +197,29 @@ static psmouse_ret_t elantech_process_by
 		elantech_packet_dump(packet, psmouse->pktsize);
 
 	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
-		/* byte 0:  D   U  p1  p2   1  p3   R   L */
-		if ((parity[packet[1]] != ((packet[0] & 0x20) >> 5)) ||
-		    (parity[packet[2]] != ((packet[0] & 0x10) >> 4)) ||
-		    (parity[packet[3]] != ((packet[0] & 0x04) >> 2)))
+		if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
+			/* byte 0: n1  n0  p2  p1   1  p3   R   L */
+			p1 = (packet[0] & 0x10) >> 4;
+			p2 = (packet[0] & 0x20) >> 5;
+		} else {
+			/* byte 0:  D   U  p1  p2   1  p3   R   L */
+			p1 = (packet[0] & 0x20) >> 5;
+			p2 = (packet[0] & 0x10) >> 4;
+		}
+		p3 = (packet[0] & 0x04) >> 2;
+		if ((parity[packet[1]] != p1) || (parity[packet[2]] != p2) ||
+		    (parity[packet[3]] != p3))
 			return PSMOUSE_BAD_DATA;
 	} else if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
 		/* byte 0:  c   c  p2  p1   1   M   R   L */
-		if ((parity[packet[1]] != ((packet[0] & 0x10) >> 4)) ||
-		    (parity[packet[2]] != ((packet[0] & 0x20) >> 5)))
+		p1 = (packet[0] & 0x10) >> 4;
+		p2 = (packet[0] & 0x20) >> 5;
+		if ((parity[packet[1]] != p1) || (parity[packet[2]] != p2))
 			return PSMOUSE_BAD_DATA;
 		/* Parity bit has not been sacrificed as middle mouse button bit */
 		if (!(etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)) {
-			if (parity[packet[3]] != ((packet[0] & 0x04) >> 2))
+			p3 = (packet[0] & 0x04) >> 2;
+			if (parity[packet[3]] != p3)
 				return PSMOUSE_BAD_DATA;
 		}
 	}
@@ -216,46 +240,64 @@ static psmouse_ret_t elantech_process_by
  * how to read registers we need to write some default values so we can
  * report their contents when asked to.
  */
-static void elantech_set_defaults(struct psmouse *psmouse)
+static void elantech_set_register_defaults(struct psmouse *psmouse)
 {
 	struct elantech_data 	*etd = psmouse->private;
-	struct input_dev 	*dev = psmouse->dev;
 
 	/*
 	 * For now, use the Elantech Windows driver default values
 	 */
 	etd->reg_10 = 0x12;
-	elantech_write_reg(psmouse, 0x10, etd->reg_10);
 	etd->reg_11 = 0x8f;
-	elantech_write_reg(psmouse, 0x11, etd->reg_11);
 	etd->reg_20 = 0x0a;
-	elantech_write_reg(psmouse, 0x20, etd->reg_20);
 	etd->reg_21 = 0x60;
-	elantech_write_reg(psmouse, 0x21, etd->reg_21);
 	etd->reg_22 = 0xff;
-	elantech_write_reg(psmouse, 0x22, etd->reg_22);
+	etd->reg_25 = 0x03;
+
 	/*
-	 * However, the Windows driver mentions registers 23, 24 and 26
+	 * The Windows driver mentions registers 23, 24 and 26
 	 * but seems to never actually write them
+	 * Set the defaults anyway
 	 */
 	etd->reg_23 = 0x10;
-	/*
-	 * elantech_write_reg(psmouse, 0x23, etd->reg_23);
-	 */
 	etd->reg_24 = 0x10;
 	/*
-	 * elantech_write_reg(psmouse, 0x24, etd->reg_24);
-	 */
-	etd->reg_25 = 0x03;
-	elantech_write_reg(psmouse, 0x25, etd->reg_25);
-	/*
 	 * The Windows driver default value of 0x00 seems wrong as it
 	 * disables smart edge cursor movement
 	 */
 	etd->reg_26 = 0x00;
+}
+
+/*
+ * Write the registers we care about to the touchpad
+ */
+static int elantech_write_registers(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+
 	/*
-	 * elantech_write_reg(psmouse, 0x26, etd->reg_26);
+	 * The Windows driver mentions registers 23, 24 and 26
+	 * but seems to never actually write them
 	 */
+	if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
+	    elantech_write_reg(psmouse, 0x11, etd->reg_11) ||
+	    elantech_write_reg(psmouse, 0x20, etd->reg_20) ||
+	    elantech_write_reg(psmouse, 0x21, etd->reg_21) ||
+	    elantech_write_reg(psmouse, 0x22, etd->reg_22) ||
+	    elantech_write_reg(psmouse, 0x25, etd->reg_25)) {
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Set the appropriate event bits for the input subsystem
+ */
+static void elantech_set_input_params(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
 
 	set_bit(EV_KEY, dev->evbit);
 	set_bit(BTN_LEFT, dev->keybit);
@@ -338,7 +380,8 @@ static ssize_t elantech_set_int_attr(str
 		if (value & ETP_R11_4_BYTE_MODE)
 			psmouse->pktsize = 4;
 		else {
-			/* Force off absolute mode when 4 byte mode is no longer selected */
+			/* Force off absolute mode when 4 byte mode is
+			 * no longer selected */
 			if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
 				etd->reg_10 ^= ETP_R10_ABSOLUTE_MODE;
 				elantech_write_reg(psmouse, 0x10, etd->reg_10);
@@ -393,17 +436,6 @@ static struct attribute_group elantech_a
 };
 
 /*
- * Clean up sysfs entries when disconnecting
- */
-static void elantech_disconnect(struct psmouse *psmouse)
-{
-	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
-				&elantech_attr_group);
-	kfree(psmouse->private);
-	psmouse->private = NULL;
-}
-
-/*
  * Use magic knock to detect Elantech touchpad
  */
 int elantech_detect(struct psmouse *psmouse, int set_properties)
@@ -417,6 +449,10 @@ int elantech_detect(struct psmouse *psmo
 	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
 	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
 
+	/*
+	 * Report this in case there are Elantech models that use a different
+	 * set of magic numbers
+	 */
 	if ((param[0] != 0x3c) || (param[1] != 0x03) || (param[2] != 0xc8)) {
 		pr_info("elantech.c: unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
 			param[0], param[1], param[2]);
@@ -432,6 +468,33 @@ int elantech_detect(struct psmouse *psmo
 }
 
 /*
+ * Clean up sysfs entries when disconnecting
+ */
+static void elantech_disconnect(struct psmouse *psmouse)
+{
+	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
+				&elantech_attr_group);
+	kfree(psmouse->private);
+	psmouse->private = NULL;
+}
+
+/*
+ * Rewrite registers when reconnecting
+ */
+static int elantech_reconnect(struct psmouse *psmouse)
+{
+	if (elantech_detect(psmouse, 0))
+		return -1;
+
+	if (elantech_write_registers(psmouse)) {
+		printk(KERN_ERR "elantech.c: failed to rewrite registers.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
  * Initialize the touchpad and create sysfs entries
  */
 int elantech_init(struct psmouse *psmouse)
@@ -466,20 +529,28 @@ int elantech_init(struct psmouse *psmous
 		etd->capabilities = param[0];
 	}
 
-	elantech_set_defaults(psmouse);
+	elantech_set_register_defaults(psmouse);
+	if (elantech_write_registers(psmouse)) {
+		printk(KERN_ERR "elantech.c: failed to write registers to default state.\n");
+		goto init_fail;
+	}
+	elantech_set_input_params(psmouse);
 
 	psmouse->protocol_handler = elantech_process_byte;
 	psmouse->disconnect = elantech_disconnect;
+	psmouse->reconnect = elantech_reconnect;
 	psmouse->pktsize = 4;
 
 	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
 					&elantech_attr_group);
 	if (error) {
-		printk(KERN_ERR "elantech.c: failed to create sysfs attributes, error: %d\n",
-			error);
-		kfree(etd);
-		return -1;
+		printk(KERN_ERR "elantech.c: failed to create sysfs attributes, error: %d.\n", error);
+		goto init_fail;
 	}
 
 	return 0;
+
+init_fail:
+	kfree(etd);
+	return -1;
 }
diff -purN -X linux-2.6.24-rc8-mm1.vanilla/Documentation/dontdiff linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/elantech.h linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/elantech.h
--- linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/elantech.h	2008-01-26 03:47:23.000000000 +0100
+++ linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/elantech.h	2008-01-26 03:50:52.000000000 +0100
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver
+ * Elantech Touchpad driver (v3)
  *
- * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -48,8 +48,8 @@
  * It seems the touchpad does not report pressure.
  * Just choose some values for compatibility with X Synaptics driver
  */
-#define ETP_MAX_PRESSURE		127
-#define ETP_DEF_PRESSURE		64
+#define ETP_MAX_PRESSURE		255
+#define ETP_DEF_PRESSURE		128
 
 struct elantech_data {
 	unsigned char reg_10;
diff -purN -X linux-2.6.24-rc8-mm1.vanilla/Documentation/dontdiff linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/psmouse-base.c linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/psmouse-base.c
--- linux-2.6.24-rc8-mm1.vanilla/drivers/input/mouse/psmouse-base.c	2008-01-26 03:47:23.000000000 +0100
+++ linux-2.6.24-rc8-mm1.elantech/drivers/input/mouse/psmouse-base.c	2008-01-26 03:52:06.000000000 +0100
@@ -770,6 +770,12 @@ static const struct psmouse_protocol psm
 		.detect		= touchkit_ps2_detect,
 	},
 #endif
+	{
+		.type		= PSMOUSE_CORTRON,
+		.name		= "CortronPS/2",
+		.alias		= "cortps",
+		.detect		= cortron_detect,
+	},
 #ifdef CONFIG_MOUSE_PS2_ELANTECH
 	{
 		.type		= PSMOUSE_ELANTECH,
@@ -780,12 +786,6 @@ static const struct psmouse_protocol psm
 	},
 #endif
 	{
-		.type		= PSMOUSE_CORTRON,
-		.name		= "CortronPS/2",
-		.alias		= "cortps",
-		.detect		= cortron_detect,
-	},
-	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
 		.alias		= "any",
