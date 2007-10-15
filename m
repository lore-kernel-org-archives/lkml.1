Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXJOFIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXJOFIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJOFIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:08:38 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:41115 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbXJOFIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=fdwBzO9a7kuGz0zHFMbofIANHcDabM3DP77gkVFxLqQ7aY/hmVw4/SxI4LtLsMrEGwZksVLxDjwSBRZ4ObKeQ4nDwXMoaccBNa/cqNBtWmnIgy+Zi4SEFIaf6oA5zsobnaun1TXZ7YERTAt5RLMihjvhv2ZgcaA8FwPqg27AsZ4=
Message-ID: <4712F5CF.3030807@gmail.com>
Date: Sun, 14 Oct 2007 23:08:31 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [ patch .24-rc0 4/5 ] SuperIO locks coordinator - use in drivers/char/pc8736x-gpio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

04 - use superio-locks in drivers/char/pc8736x_gpio

this driver keeps the slot for the lifetime of the driver 
( __init til __exit ), since the driver needs the sio-port
to change pin configurations.

patches 03,04 were tested on a soekris 4801 a year ago,
the box is currently busy.  Together they sanity-test
the sharing of a reservation with 2 different life-cycles.


Signed-off-by:  Jim Cromie <jim.cromie@gmail.com>
---
hwmon-superio-pc8736x-gpio
 Kconfig        |    1 
 pc8736x_gpio.c |   83 ++++++++++++++++++++++-----------------------------------
 2 files changed, 34 insertions(+), 50 deletions(-)

diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/char/Kconfig hwmon-superio.old/drivers/char/Kconfig
--- hwmon-fan-push-offset/drivers/char/Kconfig	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/char/Kconfig	2007-10-14 17:22:23.000000000 -0600
@@ -943,6 +943,7 @@ config PC8736x_GPIO
 	depends on X86
 	default SCx200_GPIO	# mostly N
 	select NSC_GPIO		# needed for support routines
+	select SUPERIO_LOCKS
 	help
 	  Give userspace access to the GPIO pins on the National
 	  Semiconductor PC-8736x (x=[03456]) SuperIO chip.  The chip
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/char/pc8736x_gpio.c hwmon-superio.old/drivers/char/pc8736x_gpio.c
--- hwmon-fan-push-offset/drivers/char/pc8736x_gpio.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/char/pc8736x_gpio.c	2007-10-14 17:22:23.000000000 -0600
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/nsc_gpio.h>
 #include <linux/platform_device.h>
+#include <linux/superio-locks.h>
 #include <asm/uaccess.h>
 
 #define DEVNAME "pc8736x_gpio"
@@ -36,13 +37,12 @@ static DEFINE_MUTEX(pc8736x_gpio_config_
 static unsigned pc8736x_gpio_base;
 static u8 pc8736x_gpio_shadow[4];
 
-#define SIO_BASE1       0x2E	/* 1st command-reg to check */
-#define SIO_BASE2       0x4E	/* alt command-reg to check */
+static struct superio* gate;
 
-#define SIO_SID		0x20	/* SuperI/O ID Register */
-#define SIO_SID_VALUE	0xe9	/* Expected value in SuperI/O ID Register */
-
-#define SIO_CF1		0x21	/* chip config, bit0 is chip enable */
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2E, 0x4E },
+	.device_ids   = { 0xE1, 0xE8, 0xE4, 0xE5, 0xE9, 0 },
+};
 
 #define PC8736X_GPIO_RANGE	16 /* ioaddr range */
 #define PC8736X_GPIO_CT		32 /* minors matching 4 8 bit ports */
@@ -52,6 +52,7 @@ static u8 pc8736x_gpio_shadow[4];
 #define SIO_GPIO_UNIT	0x7	/* unit number of GPIO */
 #define SIO_VLM_UNIT	0x0D
 #define SIO_TMS_UNIT	0x0E
+#define SIO_CF1		0x21	/* chip config, bit0 is chip enable */
 
 /* config-space addrs to read/write each unit's runtime addr */
 #define SIO_BASE_HADDR		0x60
@@ -62,7 +63,6 @@ static u8 pc8736x_gpio_shadow[4];
 #define SIO_GPIO_PIN_CONFIG     0xF1
 #define SIO_GPIO_PIN_EVENT      0xF2
 
-static unsigned char superio_cmd = 0;
 static unsigned char selected_device = 0xFF;	/* bogus start val */
 
 /* GPIO port runtime access, functionality */
@@ -76,35 +76,9 @@ static int port_offset[] = { 0, 4, 8, 10
 
 static struct platform_device *pdev;  /* use in dev_*() */
 
-static inline void superio_outb(int addr, int val)
-{
-	outb_p(addr, superio_cmd);
-	outb_p(val, superio_cmd + 1);
-}
-
-static inline int superio_inb(int addr)
-{
-	outb_p(addr, superio_cmd);
-	return inb_p(superio_cmd + 1);
-}
-
-static int pc8736x_superio_present(void)
-{
-	/* try the 2 possible values, read a hardware reg to verify */
-	superio_cmd = SIO_BASE1;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
-		return superio_cmd;
-
-	superio_cmd = SIO_BASE2;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
-		return superio_cmd;
-
-	return 0;
-}
-
 static void device_select(unsigned devldn)
 {
-	superio_outb(SIO_UNIT_SEL, devldn);
+	superio_select(gate, devldn);
 	selected_device = devldn;
 }
 
@@ -112,7 +86,7 @@ static void select_pin(unsigned iminor)
 {
 	/* select GPIO port/pin from device minor number */
 	device_select(SIO_GPIO_UNIT);
-	superio_outb(SIO_GPIO_PIN_SELECT,
+	superio_outb(gate, SIO_GPIO_PIN_SELECT,
 		     ((iminor << 1) & 0xF0) | (iminor & 0x7));
 }
 
@@ -121,19 +95,19 @@ static inline u32 pc8736x_gpio_configure
 {
 	u32 config, new_config;
 
+	superio_enter(gate);
 	mutex_lock(&pc8736x_gpio_config_lock);
 
-	device_select(SIO_GPIO_UNIT);
+	/* read pin's current config value */
 	select_pin(index);
-
-	/* read current config value */
-	config = superio_inb(func_slct);
+	config = superio_inb(gate, func_slct);
 
 	/* set new config */
 	new_config = (config & mask) | bits;
-	superio_outb(func_slct, new_config);
+	superio_outb(gate, func_slct, new_config);
 
 	mutex_unlock(&pc8736x_gpio_config_lock);
+	superio_exit(gate);
 
 	return config;
 }
@@ -259,40 +233,44 @@ static int __init pc8736x_gpio_init(void
 		rc = -ENODEV;
 		goto undo_platform_dev_alloc;
 	}
+	pc8736x_gpio_ops.dev = &pdev->dev;
+
 	dev_info(&pdev->dev, "NatSemi pc8736x GPIO Driver Initializing\n");
 
-	if (!pc8736x_superio_present()) {
+	gate = superio_find(&where);
+	if (!gate) {
 		rc = -ENODEV;
-		dev_err(&pdev->dev, "no device found\n");
+		dev_err(&pdev->dev, "no superio port found\n");
+		// goto err2;
 		goto undo_platform_dev_add;
 	}
-	pc8736x_gpio_ops.dev = &pdev->dev;
 
 	/* Verify that chip and it's GPIO unit are both enabled.
 	   My BIOS does this, so I take minimum action here
 	 */
-	rc = superio_inb(SIO_CF1);
+	superio_enter(gate);
+	rc = superio_inb(gate, SIO_CF1);
 	if (!(rc & 0x01)) {
 		rc = -ENODEV;
 		dev_err(&pdev->dev, "device not enabled\n");
-		goto undo_platform_dev_add;
+		goto undo_superio_enter;
 	}
 	device_select(SIO_GPIO_UNIT);
-	if (!superio_inb(SIO_UNIT_ACT)) {
+	if (!superio_inb(gate, SIO_UNIT_ACT)) {
 		rc = -ENODEV;
 		dev_err(&pdev->dev, "GPIO unit not enabled\n");
-		goto undo_platform_dev_add;
+		goto undo_superio_enter;
 	}
 
 	/* read the GPIO unit base addr that chip responds to */
-	pc8736x_gpio_base = (superio_inb(SIO_BASE_HADDR) << 8
-			     | superio_inb(SIO_BASE_LADDR));
+	pc8736x_gpio_base = (superio_inb(gate, SIO_BASE_HADDR) << 8
+			     | superio_inb(gate, SIO_BASE_LADDR));
 
 	if (!request_region(pc8736x_gpio_base, PC8736X_GPIO_RANGE, DEVNAME)) {
 		rc = -ENODEV;
 		dev_err(&pdev->dev, "GPIO ioport %x busy\n",
 			pc8736x_gpio_base);
-		goto undo_platform_dev_add;
+		goto undo_superio_enter;
 	}
 	dev_info(&pdev->dev, "GPIO ioport %x reserved\n", pc8736x_gpio_base);
 
@@ -319,10 +297,14 @@ static int __init pc8736x_gpio_init(void
 	cdev_init(&pc8736x_gpio_cdev, &pc8736x_gpio_fileops);
 	cdev_add(&pc8736x_gpio_cdev, devid, PC8736X_GPIO_CT);
 
+	superio_exit(gate);	/* no release, we need to stay registered */
 	return 0;
 
 undo_request_region:
 	release_region(pc8736x_gpio_base, PC8736X_GPIO_RANGE);
+undo_superio_enter:
+	superio_exit(gate);
+	superio_release(gate);
 undo_platform_dev_add:
 	platform_device_del(pdev);
 undo_platform_dev_alloc:
@@ -341,6 +323,7 @@ static void __exit pc8736x_gpio_cleanup(
 
 	platform_device_del(pdev);
 	platform_device_put(pdev);
+	superio_release(gate);
 }
 
 module_init(pc8736x_gpio_init);









 

