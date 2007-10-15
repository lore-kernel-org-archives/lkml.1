Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbXJOFHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbXJOFHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXJOFHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:07:11 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:40022 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXJOFHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=fk7KjJWEvLQWCvbhiZr8ZkLxY9x09ktff8LAYAHPsfpoqNsXVtaJnUV6C+q6Ewy67dU56wBRfycYRH9E76QVVf8DynWP+ffHoAtHvszvxD0qHSmWwAnFZvDq3VdIJwcXIm2b1yqoVkbmg87dbqIMUOkrqANOdhRWtmdwOa5szJM=
Message-ID: <4712F576.3080005@gmail.com>
Date: Sun, 14 Oct 2007 23:07:02 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [ patch .24-rc0 2/5 ] SuperIO locks coordinator - use in hwmon/w83627hf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

02 - use superio-locks in drivers/hwmon/w83627hf.c

tested on an AMD-Barton mobo.


Signed-off-by:  Jim Cromie <jim.cromie@gmail.com>
---
hwmon-superio-w83627hf
 Kconfig    |    1 
 w83627hf.c |  140 ++++++++++++++++++++++++-------------------------------------
 2 files changed, 58 insertions(+), 83 deletions(-)

diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/Kconfig hwmon-superio.old/drivers/hwmon/Kconfig
--- hwmon-fan-push-offset/drivers/hwmon/Kconfig	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/Kconfig	2007-10-14 17:22:23.000000000 -0600
@@ -675,6 +688,7 @@ config SENSORS_W83L785TS
 config SENSORS_W83627HF
 	tristate "Winbond W83627HF, W83627THF, W83637HF, W83687THF, W83697HF"
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for the Winbond W836X7 series
 	  of sensor chips: the W83627HF, W83627THF, W83637HF, W83687THF and
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/w83627hf.c hwmon-superio.old/drivers/hwmon/w83627hf.c
--- hwmon-fan-push-offset/drivers/hwmon/w83627hf.c	2007-10-14 17:13:47.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/w83627hf.c	2007-10-14 17:22:23.000000000 -0600
@@ -50,6 +50,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -75,11 +76,6 @@ static int init = 1;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
 
-/* modified from kernel/include/traps.c */
-static int REG;		/* The register to read/write */
-#define	DEV	0x07	/* Register: Logical device select */
-static int VAL;		/* The value to read/write */
-
 /* logical device numbers for superio_select (below) */
 #define W83627HF_LD_FDC		0x00
 #define W83627HF_LD_PRT		0x01
@@ -97,8 +93,6 @@ static int VAL;		/* The value to read/wr
 #define W83627HF_LD_ACPI	0x0a
 #define W83627HF_LD_HWM		0x0b
 
-#define	DEVID	0x20	/* Register: Device ID */
-
 #define W83627THF_GPIO5_EN	0x30 /* w83627thf only */
 #define W83627THF_GPIO5_IOSR	0xf3 /* w83627thf only */
 #define W83627THF_GPIO5_DR	0xf4 /* w83627thf only */
@@ -107,47 +101,25 @@ static int VAL;		/* The value to read/wr
 #define W83687THF_VID_CFG	0xF0 /* w83687thf only */
 #define W83687THF_VID_DATA	0xF1 /* w83687thf only */
 
-static inline void
-superio_outb(int reg, int val)
-{
-	outb(reg, REG);
-	outb(val, VAL);
-}
-
-static inline int
-superio_inb(int reg)
-{
-	outb(reg, REG);
-	return inb(VAL);
-}
-
-static inline void
-superio_select(int ld)
-{
-	outb(DEV, REG);
-	outb(ld, VAL);
-}
-
-static inline void
-superio_enter(void)
-{
-	outb(0x87, REG);
-	outb(0x87, REG);
-}
-
-static inline void
-superio_exit(void)
-{
-	outb(0xAA, REG);
-}
+#define W627_DEVID		0x52
+#define W627THF_DEVID		0x82
+#define W697_DEVID		0x60
+#define W637_DEVID		0x70
+#define W687THF_DEVID		0x85
+
+#define WINB_ACT_REG		0x30
+#define WINB_BASE_REG		0x60
+
+static struct superio* gate;
+
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2e, 0x4e },
+	.device_ids   = { W627_DEVID, W627THF_DEVID, W697_DEVID,
+			  W637_DEVID, W687THF_DEVID, 0 },
+	.enter_seq    = { 0x87, 0x87, 0 },
+	.exit_seq     = { 0xAA, 0 }
+};
 
-#define W627_DEVID 0x52
-#define W627THF_DEVID 0x82
-#define W697_DEVID 0x60
-#define W637_DEVID 0x70
-#define W687THF_DEVID 0x85
-#define WINB_ACT_REG 0x30
-#define WINB_BASE_REG 0x60
 /* Constants specified below */
 
 /* Alignment of the base address */
@@ -995,12 +967,10 @@ show_name(struct device *dev, struct dev
 	return sprintf(buf, "%s\n", data->name);
 }
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
-
-static int __init w83627hf_find(int sioaddr, unsigned short *addr,
-				struct w83627hf_sio_data *sio_data)
+				
+static u16 __init w83627hf_find(struct w83627hf_sio_data *sio_data)
 {
-	int err = -ENODEV;
-	u16 val;
+	u16 val, addr = 0;
 
 	static const __initdata char *names[] = {
 		"W83627HF",
@@ -1010,11 +980,15 @@ static int __init w83627hf_find(int sioa
 		"W83687THF",
 	};
 
-	REG = sioaddr;
-	VAL = sioaddr + 1;
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING DRVNAME ": superio port not detected, "
+		       "module not intalled.\n");
+		return 0;
+	}
+	superio_enter(gate);
+	val = superio_devid(gate);
 
-	superio_enter();
-	val= superio_inb(DEVID);
 	switch (val) {
 	case W627_DEVID:
 		sio_data->type = w83627hf;
@@ -1038,36 +1012,34 @@ static int __init w83627hf_find(int sioa
 		goto exit;
 	}
 
-	superio_select(W83627HF_LD_HWM);
+	superio_select(gate, W83627HF_LD_HWM);
 	force_addr &= WINB_ALIGNMENT;
 	if (force_addr) {
 		printk(KERN_WARNING DRVNAME ": Forcing address 0x%x\n",
 		       force_addr);
-		superio_outb(WINB_BASE_REG, force_addr >> 8);
-		superio_outb(WINB_BASE_REG + 1, force_addr & 0xff);
+		superio_outb(gate, WINB_BASE_REG, force_addr >> 8);
+		superio_outb(gate, WINB_BASE_REG + 1, force_addr & 0xff);
 	}
-	val = (superio_inb(WINB_BASE_REG) << 8) |
-	       superio_inb(WINB_BASE_REG + 1);
-	*addr = val & WINB_ALIGNMENT;
-	if (*addr == 0) {
+	val = superio_inw(gate, WINB_BASE_REG);
+	addr = val & WINB_ALIGNMENT;
+	if (addr == 0) {
 		printk(KERN_WARNING DRVNAME ": Base address not set, "
 		       "skipping\n");
 		goto exit;
 	}
 
-	val = superio_inb(WINB_ACT_REG);
+	val = superio_inb(gate, WINB_ACT_REG);
 	if (!(val & 0x01)) {
 		printk(KERN_WARNING DRVNAME ": Enabling HWM logical device\n");
-		superio_outb(WINB_ACT_REG, val | 0x01);
+		superio_outb(gate, WINB_ACT_REG, val | 0x01);
 	}
 
-	err = 0;
 	pr_info(DRVNAME ": Found %s chip at %#x\n",
-		names[sio_data->type], *addr);
+		names[sio_data->type], addr);
 
  exit:
-	superio_exit();
-	return err;
+	superio_exit(gate);
+	return addr;
 }
 
 #define VIN_UNIT_ATTRS(_X_)	\
@@ -1337,18 +1309,18 @@ static int __devinit w83627thf_read_gpio
 {
 	int res = 0xff, sel;
 
-	superio_enter();
-	superio_select(W83627HF_LD_GPIO5);
+	superio_enter(gate);
+	superio_select(gate, W83627HF_LD_GPIO5);
 
 	/* Make sure these GPIO pins are enabled */
-	if (!(superio_inb(W83627THF_GPIO5_EN) & (1<<3))) {
+	if (!(superio_inb(gate, W83627THF_GPIO5_EN) & (1<<3))) {
 		dev_dbg(&pdev->dev, "GPIO5 disabled, no VID function\n");
 		goto exit;
 	}
 
 	/* Make sure the pins are configured for input
 	   There must be at least five (VRM 9), and possibly 6 (VRM 10) */
-	sel = superio_inb(W83627THF_GPIO5_IOSR) & 0x3f;
+	sel = superio_inb(gate, W83627THF_GPIO5_IOSR) & 0x3f;
 	if ((sel & 0x1f) != 0x1f) {
 		dev_dbg(&pdev->dev, "GPIO5 not configured for VID "
 			"function\n");
@@ -1356,10 +1328,10 @@ static int __devinit w83627thf_read_gpio
 	}
 
 	dev_info(&pdev->dev, "Reading VID from GPIO5\n");
-	res = superio_inb(W83627THF_GPIO5_DR) & sel;
+	res = superio_inb(gate, W83627THF_GPIO5_DR) & sel;
 
 exit:
-	superio_exit();
+	superio_exit(gate);
 	return res;
 }
 
@@ -1367,26 +1339,26 @@ static int __devinit w83687thf_read_vid(
 {
 	int res = 0xff;
 
-	superio_enter();
-	superio_select(W83627HF_LD_HWM);
+	superio_enter(gate);
+	superio_select(gate, W83627HF_LD_HWM);
 
 	/* Make sure these GPIO pins are enabled */
-	if (!(superio_inb(W83687THF_VID_EN) & (1 << 2))) {
+	if (!(superio_inb(gate, W83687THF_VID_EN) & (1 << 2))) {
 		dev_dbg(&pdev->dev, "VID disabled, no VID function\n");
 		goto exit;
 	}
 
 	/* Make sure the pins are configured for input */
-	if (!(superio_inb(W83687THF_VID_CFG) & (1 << 4))) {
+	if (!(superio_inb(gate, W83687THF_VID_CFG) & (1 << 4))) {
 		dev_dbg(&pdev->dev, "VID configured as output, "
 			"no VID function\n");
 		goto exit;
 	}
 
-	res = superio_inb(W83687THF_VID_DATA) & 0x3f;
+	res = superio_inb(gate, W83687THF_VID_DATA) & 0x3f;
 
 exit:
-	superio_exit();
+	superio_exit(gate);
 	return res;
 }
 
@@ -1669,8 +1641,8 @@ static int __init sensors_w83627hf_init(
 	unsigned short address;
 	struct w83627hf_sio_data sio_data;
 
-	if (w83627hf_find(0x2e, &address, &sio_data)
-	 && w83627hf_find(0x4e, &address, &sio_data))
+	address = w83627hf_find(&sio_data);
+	if (!address)
 		return -ENODEV;
 
 	err = platform_driver_register(&w83627hf_driver);
@@ -1692,6 +1664,8 @@ exit:
 
 static void __exit sensors_w83627hf_exit(void)
 {
+	if (gate)
+		superio_release(gate);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&w83627hf_driver);
 }




