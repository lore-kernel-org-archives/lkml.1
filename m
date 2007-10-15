Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbXJOFL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbXJOFL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXJOFLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:11:20 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:43925 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXJOFLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=PwGSgvZr3dpyd/eds6wkc3g5Pp5bqml16NZ1LxmAjka08wU8KvWhu2hukTnd3yYEMNjiga+xgNad2fQRRS2/m0JYZnJcMx9K0cAVsaKCuP+Ws2YzQzNloDGbIYYNZqpN+S1I3yJ0Qwep40nT7J533+pWfStoycYFo/ahPmCfAqA=
Message-ID: <4712F66F.8040806@gmail.com>
Date: Sun, 14 Oct 2007 23:11:11 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [ patch .24-rc0 5/5 ] SuperIO locks coordinator - use in other hwmon/*.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

05 - use superio-locks in rest of drivers/hwmon/*.c

this patch is compile-tested only, please review for sanity before you 
try running them.  Things to look for - missing superio_release(),
opportunities to use superio_devid(), superio_inw(), etc.


Signed-off-by:  Jim Cromie <jim.cromie@gmail.com>
---
hwmon-superio-others
 Kconfig      |    6 +++
 f71805f.c    |   86 +++++++++++++++-------------------------------
 it87.c       |   80 +++++++++++++++---------------------------
 smsc47b397.c |   63 ++++++++++++---------------------
 smsc47m1.c   |   69 +++++++++++++------------------------
 vt1211.c     |   70 +++++++++++++------------------------
 w83627ehf.c  |  110 +++++++++++++++++++++++++----------------------------------
 7 files changed, 188 insertions(+), 296 deletions(-)

diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/f71805f.c hwmon-superio.old/drivers/hwmon/f71805f.c
--- hwmon-fan-push-offset/drivers/hwmon/f71805f.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/f71805f.c	2007-10-14 17:22:23.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -52,8 +53,6 @@ enum kinds { f71805f, f71872f };
 
 #define F71805F_LD_HWM		0x04
 
-#define SIO_REG_LDSEL		0x07	/* Logical device select */
-#define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
 #define SIO_REG_DEVREV		0x22	/* Device revision */
 #define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */
 #define SIO_REG_FNSEL1		0x29	/* Multi Function Select 1 (F71872F) */
@@ -64,43 +63,15 @@ enum kinds { f71805f, f71872f };
 #define SIO_F71805F_ID		0x0406
 #define SIO_F71872F_ID		0x0341
 
-static inline int
-superio_inb(int base, int reg)
-{
-	outb(reg, base);
-	return inb(base + 1);
-}
-
-static int
-superio_inw(int base, int reg)
-{
-	int val;
-	outb(reg++, base);
-	val = inb(base + 1) << 8;
-	outb(reg, base);
-	val |= inb(base + 1);
-	return val;
-}
+static struct superio* gate;
 
-static inline void
-superio_select(int base, int ld)
-{
-	outb(SIO_REG_LDSEL, base);
-	outb(ld, base + 1);
-}
-
-static inline void
-superio_enter(int base)
-{
-	outb(0x87, base);
-	outb(0x87, base);
-}
-
-static inline void
-superio_exit(int base)
-{
-	outb(0xaa, base);
-}
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2e, 0x4e },
+	.device_ids   = { SIO_F71805F_ID, SIO_F71872F_ID, 0 },
+	.devid_word   = 1,
+	.enter_seq    = { 0x87, 0x87 },
+	.exit_seq     = { 0xAA }
+};
 
 /*
  * ISA constants
@@ -1480,31 +1451,33 @@ exit:
 	return err;
 }
 
-static int __init f71805f_find(int sioaddr, unsigned short *address,
-			       struct f71805f_sio_data *sio_data)
+static int __init f71805f_find(struct f71805f_sio_data *sio_data)
 {
 	int err = -ENODEV;
-	u16 devid;
+	u16 devid, address;
 
 	static const char *names[] = {
 		"F71805F/FG",
 		"F71872F/FG or F71806F/FG",
 	};
-
-	superio_enter(sioaddr);
-
-	devid = superio_inw(sioaddr, SIO_REG_MANID);
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
+	devid = superio_inw(gate, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID)
 		goto exit;
 
-	devid = superio_inw(sioaddr, SIO_REG_DEVID);
 	switch (devid) {
 	case SIO_F71805F_ID:
 		sio_data->kind = f71805f;
 		break;
 	case SIO_F71872F_ID:
 		sio_data->kind = f71872f;
-		sio_data->fnsel1 = superio_inb(sioaddr, SIO_REG_FNSEL1);
+		sio_data->fnsel1 = superio_inb(gate, SIO_REG_FNSEL1);
 		break;
 	default:
 		printk(KERN_INFO DRVNAME ": Unsupported Fintek device, "
@@ -1512,28 +1485,28 @@ static int __init f71805f_find(int sioad
 		goto exit;
 	}
 
-	superio_select(sioaddr, F71805F_LD_HWM);
-	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
+	superio_select(gate, F71805F_LD_HWM);
+	if (!(superio_inb(gate, SIO_REG_ENABLE) & 0x01)) {
 		printk(KERN_WARNING DRVNAME ": Device not activated, "
 		       "skipping\n");
 		goto exit;
 	}
 
-	*address = superio_inw(sioaddr, SIO_REG_ADDR);
-	if (*address == 0) {
+	address = superio_inw(gate, SIO_REG_ADDR);
+	if (address == 0) {
 		printk(KERN_WARNING DRVNAME ": Base address not set, "
 		       "skipping\n");
 		goto exit;
 	}
-	*address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
+	address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = 0;
 	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %u\n",
-	       names[sio_data->kind], *address,
-	       superio_inb(sioaddr, SIO_REG_DEVREV));
+	       names[sio_data->kind], address,
+	       superio_inb(gate, SIO_REG_DEVREV));
 
 exit:
-	superio_exit(sioaddr);
+	superio_exit(gate);
 	return err;
 }
 
@@ -1543,8 +1516,7 @@ static int __init f71805f_init(void)
 	unsigned short address;
 	struct f71805f_sio_data sio_data;
 
-	if (f71805f_find(0x2e, &address, &sio_data)
-	 && f71805f_find(0x4e, &address, &sio_data))
+	if (f71805f_find(&sio_data))
 		return -ENODEV;
 
 	err = platform_driver_register(&f71805f_driver);
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/it87.c hwmon-superio.old/drivers/hwmon/it87.c
--- hwmon-fan-push-offset/drivers/hwmon/it87.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/it87.c	2007-10-14 17:22:23.000000000 -0600
@@ -38,6 +38,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 
 #define DRVNAME "it87"
@@ -54,46 +55,6 @@ static struct platform_device *pdev;
 #define	DEVID	0x20	/* Register: Device ID */
 #define	DEVREV	0x22	/* Register: Device Revision */
 
-static inline int
-superio_inb(int reg)
-{
-	outb(reg, REG);
-	return inb(VAL);
-}
-
-static int superio_inw(int reg)
-{
-	int val;
-	outb(reg++, REG);
-	val = inb(VAL) << 8;
-	outb(reg, REG);
-	val |= inb(VAL);
-	return val;
-}
-
-static inline void
-superio_select(int ldn)
-{
-	outb(DEV, REG);
-	outb(ldn, VAL);
-}
-
-static inline void
-superio_enter(void)
-{
-	outb(0x87, REG);
-	outb(0x01, REG);
-	outb(0x55, REG);
-	outb(0x55, REG);
-}
-
-static inline void
-superio_exit(void)
-{
-	outb(0x02, REG);
-	outb(0x02, VAL);
-}
-
 /* Logical device 4 registers */
 #define IT8712F_DEVID 0x8712
 #define IT8705F_DEVID 0x8705
@@ -103,6 +64,17 @@ superio_exit(void)
 #define IT87_ACT_REG  0x30
 #define IT87_BASE_REG 0x60
 
+static struct superio* gate;
+
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { REG, 0 },
+	.device_ids   = { IT8712F_DEVID, IT8716F_DEVID, IT8718F_DEVID,
+			  IT8705F_DEVID, IT8726F_DEVID, 0 },
+	.devid_word   = 1,
+	.enter_seq    = { 0x87, 0x01, 0x55, 0x55, 0 },
+	.exit_seq     = { 0x02, 0x02, 0 }
+};
+
 /* Logical device 7 registers (IT8712F and later) */
 #define IT87_SIO_PINX2_REG	0x2c	/* Pin selection */
 #define IT87_SIO_VID_REG	0xfc	/* VID value */
@@ -890,10 +862,16 @@ static int __init it87_find(unsigned sho
 {
 	int err = -ENODEV;
 	u16 chip_type;
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
 
-	superio_enter();
-	chip_type = superio_inw(DEVID);
-
+	/* can get this from gate */
+	chip_type = superio_inw(gate, DEVID);
 	switch (chip_type) {
 	case IT8705F_DEVID:
 		sio_data->type = it87;
@@ -916,13 +894,13 @@ static int __init it87_find(unsigned sho
 		goto exit;
 	}
 
-	superio_select(PME);
-	if (!(superio_inb(IT87_ACT_REG) & 0x01)) {
+	superio_select(gate, PME);
+	if (!(superio_inb(gate, IT87_ACT_REG) & 0x01)) {
 		pr_info("it87: Device not activated, skipping\n");
 		goto exit;
 	}
 
-	*address = superio_inw(IT87_BASE_REG) & ~(IT87_EXTENT - 1);
+	*address = superio_inw(gate, IT87_BASE_REG) & ~(IT87_EXTENT - 1);
 	if (*address == 0) {
 		pr_info("it87: Base address not set, skipping\n");
 		goto exit;
@@ -930,17 +908,17 @@ static int __init it87_find(unsigned sho
 
 	err = 0;
 	pr_info("it87: Found IT%04xF chip at 0x%x, revision %d\n",
-		chip_type, *address, superio_inb(DEVREV) & 0x0f);
+		chip_type, *address, superio_inb(gate, DEVREV) & 0x0f);
 
 	/* Read GPIO config and VID value from LDN 7 (GPIO) */
 	if (chip_type != IT8705F_DEVID) {
 		int reg;
 
-		superio_select(GPIO);
+		superio_select(gate, GPIO);
 		if (chip_type == it8718)
-			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
+			sio_data->vid_value = superio_inb(gate, IT87_SIO_VID_REG);
 
-		reg = superio_inb(IT87_SIO_PINX2_REG);
+		reg = superio_inb(gate, IT87_SIO_PINX2_REG);
 		if (reg & (1 << 0))
 			pr_info("it87: in3 is VCC (+5V)\n");
 		if (reg & (1 << 1))
@@ -948,7 +926,7 @@ static int __init it87_find(unsigned sho
 	}
 
 exit:
-	superio_exit();
+	superio_exit(gate);
 	return err;
 }
 
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/Kconfig hwmon-superio.old/drivers/hwmon/Kconfig
--- hwmon-fan-push-offset/drivers/hwmon/Kconfig	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/Kconfig	2007-10-14 17:22:23.000000000 -0600
@@ -218,6 +218,7 @@ config SENSORS_DS1621
 config SENSORS_F71805F
 	tristate "Fintek F71805F/FG, F71806F/FG and F71872F/FG"
 	depends on EXPERIMENTAL
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for hardware monitoring
 	  features of the Fintek F71805F/FG, F71806F/FG and F71872F/FG
@@ -325,6 +328,7 @@ config SENSORS_IBMPEX
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for ITE IT8705F, IT8712F,
 	  IT8716F, IT8718F and IT8726F sensor chips, and the SiS960 clone.
@@ -554,6 +564,7 @@ config SENSORS_SMSC47M192
 	tristate "SMSC LPC47M192 and compatibles"
 	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for the temperature and
 	  voltage sensors of the SMSC LPC47M192, LPC47M15x, LPC47M292
@@ -570,6 +581,7 @@ config SENSORS_SMSC47M192
 config SENSORS_SMSC47B397
 	tristate "SMSC LPC47B397-NC"
 	depends on EXPERIMENTAL
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for the SMSC LPC47B397-NC
 	  sensor chip.
@@ -601,6 +613,7 @@ config SENSORS_VT1211
 	tristate "VIA VT1211"
 	depends on EXPERIMENTAL
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here then you get support for hardware monitoring
 	  features of the VIA VT1211 Super-I/O chip.
@@ -686,6 +700,7 @@ config SENSORS_W83627HF
 config SENSORS_W83627EHF
 	tristate "Winbond W83627EHF/DHG"
 	select HWMON_VID
+	select SUPERIO_LOCKS
 	help
 	  If you say yes here you get support for the hardware
 	  monitoring functionality of the Winbond W83627EHF Super-I/O chip.
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/smsc47b397.c hwmon-superio.old/drivers/hwmon/smsc47b397.c
--- hwmon-fan-push-offset/drivers/hwmon/smsc47b397.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/smsc47b397.c	2007-10-14 17:22:23.000000000 -0600
@@ -36,6 +36,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -44,37 +45,6 @@ static struct platform_device *pdev;
 
 /* Super-I/0 registers and commands */
 
-#define	REG	0x2e	/* The register to read/write */
-#define	VAL	0x2f	/* The value to read/write */
-
-static inline void superio_outb(int reg, int val)
-{
-	outb(reg, REG);
-	outb(val, VAL);
-}
-
-static inline int superio_inb(int reg)
-{
-	outb(reg, REG);
-	return inb(VAL);
-}
-
-/* select superio logical device */
-static inline void superio_select(int ld)
-{
-	superio_outb(0x07, ld);
-}
-
-static inline void superio_enter(void)
-{
-	outb(0x55, REG);
-}
-
-static inline void superio_exit(void)
-{
-	outb(0xAA, REG);
-}
-
 #define SUPERIO_REG_DEVID	0x20
 #define SUPERIO_REG_DEVREV	0x21
 #define SUPERIO_REG_BASE_MSB	0x60
@@ -83,6 +53,15 @@ static inline void superio_exit(void)
 
 #define SMSC_EXTENT		0x02
 
+static struct superio* gate;
+
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2e, 0x4e },
+	.device_ids   = { 0x6f, 0x81, 0 },
+	.enter_seq    = { 0x55, 0 },
+	.exit_seq     = { 0xAA, 0 },
+};
+
 /* 0 <= nr <= 3 */
 static u8 smsc47b397_reg_temp[] = {0x25, 0x26, 0x27, 0x80};
 #define SMSC47B397_REG_TEMP(nr)	(smsc47b397_reg_temp[(nr)])
@@ -332,26 +311,32 @@ static int __init smsc47b397_find(unsign
 {
 	u8 id, rev;
 
-	superio_enter();
-	id = superio_inb(SUPERIO_REG_DEVID);
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
+	id = superio_inb(gate, SUPERIO_REG_DEVID);
 
 	if ((id != 0x6f) && (id != 0x81) && (id != 0x85)) {
-		superio_exit();
+		superio_exit(gate);
 		return -ENODEV;
 	}
 
-	rev = superio_inb(SUPERIO_REG_DEVREV);
+	rev = superio_inb(gate, SUPERIO_REG_DEVREV);
 
-	superio_select(SUPERIO_REG_LD8);
-	*addr = (superio_inb(SUPERIO_REG_BASE_MSB) << 8)
-		 |  superio_inb(SUPERIO_REG_BASE_LSB);
+	superio_select(gate, SUPERIO_REG_LD8);
+	*addr = (superio_inb(gate, SUPERIO_REG_BASE_MSB) << 8)
+		 | superio_inb(gate, SUPERIO_REG_BASE_LSB);
 
 	printk(KERN_INFO DRVNAME ": found SMSC %s "
 		"(base address 0x%04x, revision %u)\n",
 		id == 0x81 ? "SCH5307-NS" : id == 0x85 ? "SCH5317" :
 	       "LPC47B397-NC", *addr, rev);
 
-	superio_exit();
+	superio_exit(gate);
 	return 0;
 }
 
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/smsc47m1.c hwmon-superio.old/drivers/hwmon/smsc47m1.c
--- hwmon-fan-push-offset/drivers/hwmon/smsc47m1.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/smsc47m1.c	2007-10-14 17:22:23.000000000 -0600
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -46,41 +47,18 @@ enum chips { smsc47m1, smsc47m2 };
 
 /* Super-I/0 registers and commands */
 
-#define	REG	0x2e	/* The register to read/write */
-#define	VAL	0x2f	/* The value to read/write */
-
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
-/* logical device for fans is 0x0A */
-#define superio_select() superio_outb(0x07, 0x0A)
-
-static inline void
-superio_enter(void)
-{
-	outb(0x55, REG);
-}
-
-static inline void
-superio_exit(void)
-{
-	outb(0xAA, REG);
-}
-
 #define SUPERIO_REG_ACT		0x30
 #define SUPERIO_REG_BASE	0x60
-#define SUPERIO_REG_DEVID	0x20
+
+static struct superio* gate;
+
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2e, 0x4e },
+	.device_ids   = { 0x51, 0x59, 0x5F, 0x60, 0x6B, 0 },
+	.devid_word   = 1,
+	.enter_seq    = { 0x55, 0 },
+	.exit_seq     = { 0xAA, 0 }
+};
 
 /* Logical device registers */
 
@@ -398,8 +376,14 @@ static int __init smsc47m1_find(unsigned
 {
 	u8 val;
 
-	superio_enter();
-	val = superio_inb(SUPERIO_REG_DEVID);
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
+	val = superio_devid(gate);
 
 	/*
 	 * SMSC LPC47M10x/LPC47M112/LPC47M13x (device id 0x59), LPC47M14x
@@ -434,21 +418,20 @@ static int __init smsc47m1_find(unsigned
 		sio_data->type = smsc47m2;
 		break;
 	default:
-		superio_exit();
+		superio_exit(gate);
 		return -ENODEV;
 	}
-
-	superio_select();
-	*addr = (superio_inb(SUPERIO_REG_BASE) << 8)
-	      |  superio_inb(SUPERIO_REG_BASE + 1);
-	val = superio_inb(SUPERIO_REG_ACT);
+	superio_select(gate, 0x0A);
+	*addr = (superio_inb(gate, SUPERIO_REG_BASE) << 8)
+	      |  superio_inb(gate, SUPERIO_REG_BASE + 1);
+	val = superio_inb(gate, SUPERIO_REG_ACT);
 	if (*addr == 0 || (val & 0x01) == 0) {
 		pr_info(DRVNAME ": Device is disabled, will not use\n");
-		superio_exit();
+		superio_exit(gate);
 		return -ENODEV;
 	}
 
-	superio_exit();
+	superio_exit(gate);
 	return 0;
 }
 
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/vt1211.c hwmon-superio.old/drivers/hwmon/vt1211.c
--- hwmon-fan-push-offset/drivers/hwmon/vt1211.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/vt1211.c	2007-10-14 17:22:23.000000000 -0600
@@ -32,6 +32,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 
 static int uch_config = -1;
@@ -195,34 +196,15 @@ struct vt1211_data {
 /* VT1211 logical device numbers */
 #define SIO_VT1211_LDN_HWMON	0x0b	/* HW monitor */
 
-static inline void superio_outb(int sio_cip, int reg, int val)
-{
-	outb(reg, sio_cip);
-	outb(val, sio_cip + 1);
-}
-
-static inline int superio_inb(int sio_cip, int reg)
-{
-	outb(reg, sio_cip);
-	return inb(sio_cip + 1);
-}
+static struct superio* gate;
 
-static inline void superio_select(int sio_cip, int ldn)
-{
-	outb(SIO_VT1211_LDN, sio_cip);
-	outb(ldn, sio_cip + 1);
-}
-
-static inline void superio_enter(int sio_cip)
-{
-	outb(0x87, sio_cip);
-	outb(0x87, sio_cip);
-}
-
-static inline void superio_exit(int sio_cip)
-{
-	outb(0xaa, sio_cip);
-}
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { SIO_REG_CIP1, SIO_REG_CIP2 },
+	.device_ids   = { SIO_VT1211_ID, 0 },
+	.devid_addr   = SIO_VT1211_DEVID,
+	.enter_seq    = { 0x87, 0x87, 0 },
+	.exit_seq     = { 0xAA, 0 }
+};
 
 /* ---------------------------------------------------------------------
  * Device I/O access
@@ -1277,27 +1259,29 @@ EXIT:
 	return err;
 }
 
-static int __init vt1211_find(int sio_cip, unsigned short *address)
+static int __init vt1211_find(void)
 {
 	int err = -ENODEV;
+	u16 address;
 
-	superio_enter(sio_cip);
-
-	if (superio_inb(sio_cip, SIO_VT1211_DEVID) != SIO_VT1211_ID) {
-		goto EXIT;
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING DRVNAME ": superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
 	}
+	superio_enter(gate);
+	superio_select(gate, SIO_VT1211_LDN_HWMON);
 
-	superio_select(sio_cip, SIO_VT1211_LDN_HWMON);
-
-	if ((superio_inb(sio_cip, SIO_VT1211_ACTIVE) & 1) == 0) {
+	if ((superio_inb(gate, SIO_VT1211_ACTIVE) & 1) == 0) {
 		printk(KERN_WARNING DRVNAME ": HW monitor is disabled, "
 		       "skipping\n");
 		goto EXIT;
 	}
 
-	*address = ((superio_inb(sio_cip, SIO_VT1211_BADDR) << 8) |
-		    (superio_inb(sio_cip, SIO_VT1211_BADDR + 1))) & 0xff00;
-	if (*address == 0) {
+	address = superio_inw(gate, SIO_VT1211_BADDR);
+
+	if (address == 0) {
 		printk(KERN_WARNING DRVNAME ": Base address is not set, "
 		       "skipping\n");
 		goto EXIT;
@@ -1305,11 +1289,11 @@ static int __init vt1211_find(int sio_ci
 
 	err = 0;
 	printk(KERN_INFO DRVNAME ": Found VT1211 chip at 0x%04x, "
-	       "revision %u\n", *address,
-	       superio_inb(sio_cip, SIO_VT1211_DEVREV));
+	       "revision %u\n", address,
+	       superio_inb(gate, SIO_VT1211_DEVREV));
 
 EXIT:
-	superio_exit(sio_cip);
+	superio_exit(gate);
 	return err;
 }
 
@@ -1318,10 +1302,8 @@ static int __init vt1211_init(void)
 	int err;
 	unsigned short address = 0;
 
-	if ((err = vt1211_find(SIO_REG_CIP1, &address)) &&
-	    (err = vt1211_find(SIO_REG_CIP2, &address))) {
+	if ((err = vt1211_find()))
 		goto EXIT;
-	}
 
 	if ((uch_config < -1) || (uch_config > 31)) {
 		err = -EINVAL;
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/w83627ehf.c hwmon-superio.old/drivers/hwmon/w83627ehf.c
--- hwmon-fan-push-offset/drivers/hwmon/w83627ehf.c	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/w83627ehf.c	2007-10-14 17:22:23.000000000 -0600
@@ -48,6 +48,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/superio-locks.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -80,39 +81,23 @@ static const char * w83627ehf_device_nam
 #define SIO_W83627DHG_ID	0xa020
 #define SIO_ID_MASK		0xFFF0
 
-static inline void
-superio_outb(int ioreg, int reg, int val)
-{
-	outb(reg, ioreg);
-	outb(val, ioreg + 1);
-}
+static struct superio* gate;
 
-static inline int
-superio_inb(int ioreg, int reg)
-{
-	outb(reg, ioreg);
-	return inb(ioreg + 1);
-}
-
-static inline void
-superio_select(int ioreg, int ld)
-{
-	outb(SIO_REG_LDSEL, ioreg);
-	outb(ld, ioreg + 1);
-}
-
-static inline void
-superio_enter(int ioreg)
-{
-	outb(0x87, ioreg);
-	outb(0x87, ioreg);
-}
+static __devinit struct superio_search where = {
+	.cmdreg_addrs = { 0x2E, 0x4E },
+	.device_ids   = { SIO_W83627EHF_ID, SIO_W83627EHG_ID,
+			  SIO_W83627DHG_ID, 0 },
+	.devid_mask   = SIO_ID_MASK,
+	.devid_word   = 1,
+	.enter_seq    = { 0x87, 0x87, 0 },
+	.exit_seq     = { 0 }	/* exit handled by my_superio_exit */
+};
 
 static inline void
-superio_exit(int ioreg)
+my_superio_exit(struct superio * gate)
 {
-	outb(0x02, ioreg);
-	outb(0x02, ioreg + 1);
+	outb(0x02, gate->sioaddr);
+	outb(0x02, gate->sioaddr + 1);
 }
 
 /*
@@ -1275,23 +1260,21 @@ static int __devinit w83627ehf_probe(str
 	w83627ehf_init_device(data);
 
 	data->vrm = vid_which_vrm();
-	superio_enter(sio_data->sioreg);
+	superio_enter(gate); /*, sio_data->sioreg); */
 	/* Set VID input sensibility if needed. In theory the BIOS should
 	   have set it, but in practice it's not always the case. */
-	en_vrm10 = superio_inb(sio_data->sioreg, SIO_REG_EN_VRM10);
+	en_vrm10 = superio_inb(gate, SIO_REG_EN_VRM10);
 	if ((en_vrm10 & 0x08) && data->vrm != 100) {
 		dev_warn(dev, "Setting VID input voltage to TTL\n");
-		superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
-			     en_vrm10 & ~0x08);
+		superio_outb(gate, SIO_REG_EN_VRM10, en_vrm10 & ~0x08);
 	} else if (!(en_vrm10 & 0x08) && data->vrm == 100) {
 		dev_warn(dev, "Setting VID input voltage to VRM10\n");
-		superio_outb(sio_data->sioreg, SIO_REG_EN_VRM10,
-			     en_vrm10 | 0x08);
+		superio_outb(gate, SIO_REG_EN_VRM10, en_vrm10 | 0x08);
 	}
 	/* Read VID value */
-	superio_select(sio_data->sioreg, W83627EHF_LD_HWM);
-	if (superio_inb(sio_data->sioreg, SIO_REG_VID_CTRL) & 0x80)
-		data->vid = superio_inb(sio_data->sioreg, SIO_REG_VID_DATA) & 0x3f;
+	superio_select(gate, W83627EHF_LD_HWM);
+	if (superio_inb(gate, SIO_REG_VID_CTRL) & 0x80)
+	  data->vid = superio_inb(gate, SIO_REG_VID_DATA) & 0x3f;
 	else {
 		dev_info(dev, "VID pins in output mode, CPU VID not "
 			 "available\n");
@@ -1300,9 +1283,9 @@ static int __devinit w83627ehf_probe(str
 
 	/* fan4 and fan5 share some pins with the GPIO and serial flash */
 
-	fan5pin = superio_inb(sio_data->sioreg, 0x24) & 0x2;
-	fan4pin = superio_inb(sio_data->sioreg, 0x29) & 0x6;
-	superio_exit(sio_data->sioreg);
+	fan5pin = superio_inb(gate, 0x24) & 0x2;
+	fan4pin = superio_inb(gate, 0x29) & 0x6;
+	my_superio_exit(gate);
 
 	/* It looks like fan4 and fan5 pins can be alternatively used
 	   as fan on/off switches, but fan5 control is write only :/
@@ -1425,20 +1408,24 @@ static struct platform_driver w83627ehf_
 };
 
 /* w83627ehf_find() looks for a '627 in the Super-I/O config space */
-static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
-				 struct w83627ehf_sio_data *sio_data)
+static int __init w83627ehf_find(struct w83627ehf_sio_data *sio_data)
 {
 	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
 	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
 	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
 
-	u16 val;
+	u16 val, addr;
 	const char *sio_name;
 
-	superio_enter(sioaddr);
+	gate = superio_find(&where);
+	if (!gate) {
+		printk(KERN_WARNING "pc87360: superio port not detected, "
+		       "module not intalled.\n");
+		return -ENODEV;
+	}
+	superio_enter(gate);
+	val = superio_devid(gate);
 
-	val = (superio_inb(sioaddr, SIO_REG_DEVID) << 8)
-	    | superio_inb(sioaddr, SIO_REG_DEVID + 1);
 	switch (val & SIO_ID_MASK) {
 	case SIO_W83627EHF_ID:
 		sio_data->kind = w83627ehf;
@@ -1456,33 +1443,33 @@ static int __init w83627ehf_find(int sio
 		if (val != 0xffff)
 			pr_debug(DRVNAME ": unsupported chip ID: 0x%04x\n",
 				 val);
-		superio_exit(sioaddr);
+		my_superio_exit(gate);
 		return -ENODEV;
 	}
 
 	/* We have a known chip, find the HWM I/O address */
-	superio_select(sioaddr, W83627EHF_LD_HWM);
-	val = (superio_inb(sioaddr, SIO_REG_ADDR) << 8)
-	    | superio_inb(sioaddr, SIO_REG_ADDR + 1);
-	*addr = val & IOREGION_ALIGNMENT;
-	if (*addr == 0) {
+	superio_select(gate, W83627EHF_LD_HWM);
+	val = (superio_inb(gate, SIO_REG_ADDR) << 8)
+	    | superio_inb(gate, SIO_REG_ADDR + 1);
+	addr = val & IOREGION_ALIGNMENT;
+	if (addr == 0) {
 		printk(KERN_ERR DRVNAME ": Refusing to enable a Super-I/O "
 		       "device with a base I/O port 0.\n");
-		superio_exit(sioaddr);
+		my_superio_exit(gate);
 		return -ENODEV;
 	}
 
 	/* Activate logical device if needed */
-	val = superio_inb(sioaddr, SIO_REG_ENABLE);
+	val = superio_inb(gate, SIO_REG_ENABLE);
 	if (!(val & 0x01)) {
 		printk(KERN_WARNING DRVNAME ": Forcibly enabling Super-I/O. "
 		       "Sensor is probably unusable.\n");
-		superio_outb(sioaddr, SIO_REG_ENABLE, val | 0x01);
+		superio_outb(gate, SIO_REG_ENABLE, val | 0x01);
 	}
 
-	superio_exit(sioaddr);
-	pr_info(DRVNAME ": Found %s chip at %#x\n", sio_name, *addr);
-	sio_data->sioreg = sioaddr;
+	my_superio_exit(gate);
+	pr_info(DRVNAME ": Found %s chip at %#x\n", sio_name, addr);
+	sio_data->sioreg = gate->sioaddr;
 
 	return 0;
 }
@@ -1496,7 +1483,7 @@ static struct platform_device *pdev;
 static int __init sensors_w83627ehf_init(void)
 {
 	int err;
-	unsigned short address;
+	unsigned short address = 0;
 	struct resource res;
 	struct w83627ehf_sio_data sio_data;
 
@@ -1505,8 +1492,7 @@ static int __init sensors_w83627ehf_init
 	 * when Super-I/O functions move to a separate file, the Super-I/O
 	 * driver will probe 0x2e and 0x4e and auto-detect the presence of a
 	 * w83627ehf hardware monitor, and call probe() */
-	if (w83627ehf_find(0x2e, &address, &sio_data) &&
-	    w83627ehf_find(0x4e, &address, &sio_data))
+	if (w83627ehf_find(&sio_data))
 		return -ENODEV;
 
 	err = platform_driver_register(&w83627ehf_driver);












 

