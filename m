Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXJOFHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXJOFHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXJOFHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:07:44 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:40915 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXJOFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=qgeIhnkiTGaUeteOchqPvd58C0OL8OT5onoNju+34V5vN8mrGvZsSC3ON54lvz/TpDGcbG0QG/AnGcijWUT/TnO+qVfalau/O7OLw8cTsU1IKD0rcybNatXUbXIGw47aRK1lJgtcN3GRa/apgLvFMINHPJHAs7gbt/7kb72axr4=
Message-ID: <4712F59A.2030803@gmail.com>
Date: Sun, 14 Oct 2007 23:07:38 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [ patch .24-rc0 3/5 ] SuperIO locks coordinator - use in hwmon/pc87360
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03 - use superio-locks in drivers/hwmon/pc87360

this driver keeps the slot for only during __init, since it 
only needs the sio-port to read the ISA addresses of the 
Logical Devices in the chip, which are then used exclusively.


Signed-off-by:  Jim Cromie <jim.cromie@gmail.com>
---
hwmon-superio-pc87360
 Kconfig   |    1 
 pc87360.c |   73 +++++++++++++++++++++++++-------------------------------------
 2 files changed, 31 insertions(+), 43 deletions(-)



diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/Kconfig hwmon-superio.old/drivers/hwmon/Kconfig
--- hwmon-fan-push-offset/drivers/hwmon/Kconfig	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/Kconfig	2007-10-14 17:22:23.000000000 -0600
@@ -489,6 +495,7 @@ config SENSORS_MAX6650
 config SENSORS_PC87360
 	tristate "National Semiconductor PC87360 family"
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get access to the hardware monitoring
 	  functions of the National Semiconductor PC8736x Super-I/O chips.
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/pc87360.c hwmon-superio.old/drivers/hwmon/pc87360.c
--- hwmon-fan-push-offset/drivers/hwmon/pc87360.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/pc87360.c	2007-10-14 17:22:23.000000000 -0600
@@ -41,6 +41,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/hwmon-vid.h>
+#include <linux/superio-locks.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <asm/io.h>
@@ -64,10 +65,14 @@ MODULE_PARM_DESC(init,
  */
 
 #define DEV	0x07	/* Register: Logical device select */
-#define DEVID	0x20	/* Register: Device ID */
 #define ACT	0x30	/* Register: Device activation */
 #define BASE	0x60	/* Register: Base address */
 
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2E, 0x4E },
+	.device_ids   = { 0xE1, 0xE8, 0xE4, 0xE5, 0xE9, 0 },
+};
+
 #define FSCM	0x09	/* Logical device: fans */
 #define VLM	0x0d	/* Logical device: voltages */
 #define TMS	0x0e	/* Logical device: temperatures */
@@ -77,24 +82,6 @@ static const u8 logdev[3] = { FSCM, VLM,
 #define LD_IN		1
 #define LD_TEMP		2
 
-static inline void superio_outb(int sioaddr, int reg, int val)
-{
-	outb(reg, sioaddr);
-	outb(val, sioaddr+1);
-}
-
-static inline int superio_inb(int sioaddr, int reg)
-{
-	outb(reg, sioaddr);
-	return inb(sioaddr+1);
-}
-
-static inline void superio_exit(int sioaddr)
-{
-	outb(0x02, sioaddr);
-	outb(0x02, sioaddr+1);
-}
-
 /*
  * Logical devices
  */
@@ -817,17 +804,22 @@ static DEVICE_ATTR(name, S_IRUGO, show_n
  * Device detection, registration and update
  */
 
-static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses)
+static int __init pc87360_find(unsigned short *addresses)
 {
 	u16 val;
-	int i;
-	int nrdev; /* logical device count */
+	int i, nrdev; /* logical device count */
 
-	/* No superio_enter */
+	struct superio* const gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
+	devid = gate->devid;		/* Remember the device id */
 
 	/* Identify device */
-	val = superio_inb(sioaddr, DEVID);
-	switch (val) {
+	switch (devid) {
 	case 0xE1: /* PC87360 */
 	case 0xE8: /* PC87363 */
 	case 0xE4: /* PC87364 */
@@ -838,25 +830,23 @@ static int __init pc87360_find(int sioad
 		nrdev = 3;
 		break;
 	default:
-		superio_exit(sioaddr);
+		superio_exit(gate);
 		return -ENODEV;
 	}
-	/* Remember the device id */
-	*devid = val;
 
 	for (i = 0; i < nrdev; i++) {
 		/* select logical device */
-		superio_outb(sioaddr, DEV, logdev[i]);
+		superio_select(gate, logdev[i]);
 
-		val = superio_inb(sioaddr, ACT);
+		val = superio_inb(gate, ACT);
 		if (!(val & 0x01)) {
 			printk(KERN_INFO "pc87360: Device 0x%02x not "
 			       "activated\n", logdev[i]);
 			continue;
 		}
 
-		val = (superio_inb(sioaddr, BASE) << 8)
-		    | superio_inb(sioaddr, BASE + 1);
+		val = (superio_inb(gate, BASE) << 8)
+		    | superio_inb(gate, BASE + 1);
 		if (!val) {
 			printk(KERN_INFO "pc87360: Base address not set for "
 			       "device 0x%02x\n", logdev[i]);
@@ -866,8 +856,8 @@ static int __init pc87360_find(int sioad
 		addresses[i] = val;
 
 		if (i==0) { /* Fans */
-			confreg[0] = superio_inb(sioaddr, 0xF0);
-			confreg[1] = superio_inb(sioaddr, 0xF1);
+			confreg[0] = superio_inb(gate, 0xF0);
+			confreg[1] = superio_inb(gate, 0xF1);
 
 #ifdef DEBUG
 			printk(KERN_DEBUG "pc87360: Fan 1: mon=%d "
@@ -882,12 +872,12 @@ static int __init pc87360_find(int sioad
 #endif
 		} else if (i==1) { /* Voltages */
 			/* Are we using thermistors? */
-			if (*devid == 0xE9) { /* PC87366 */
+			if (devid == 0xE9) { /* PC87366 */
 				/* These registers are not logical-device
 				   specific, just that we won't need them if
 				   we don't use the VLM device */
-				confreg[2] = superio_inb(sioaddr, 0x2B);
-				confreg[3] = superio_inb(sioaddr, 0x25);
+				confreg[2] = superio_inb(gate, 0x2B);
+				confreg[3] = superio_inb(gate, 0x25);
 
 				if (confreg[2] & 0x40) {
 					printk(KERN_INFO "pc87360: Using "
@@ -903,7 +893,8 @@ static int __init pc87360_find(int sioad
 		}
 	}
 
-	superio_exit(sioaddr);
+	superio_exit(gate);
+	superio_release(gate);	/* not needed for any post-load operations */
 	return 0;
 }
 
@@ -1449,12 +1440,8 @@ static int __init pc87360_init(void)
 	int err, i;
 	unsigned short address = 0;
 
-	if (pc87360_find(0x2e, &devid, extra_isa)
-	 && pc87360_find(0x4e, &devid, extra_isa)) {
-		printk(KERN_WARNING "pc87360: PC8736x not detected, "
-		       "module not inserted.\n");
+	if (pc87360_find(extra_isa))
 		return -ENODEV;
-	}
 
 	/* Arbitrarily pick one of the addresses */
 	for (i = 0; i < 3; i++) {













