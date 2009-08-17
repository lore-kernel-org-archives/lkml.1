Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZHQHhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZHQHhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZHQHhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:37:38 -0400
Received: from mail.df.lth.se ([194.47.250.12]:43247 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192AbZHQHhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:37:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] MFD AB3100 OTP readout
Date: Mon, 17 Aug 2009 09:37:29 +0200
Message-Id: <1250494649-13361-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability to read out OTP (One-Time Programmable)
registers in the AB3100 MFD ASIC. It's a simple sysfs file you
can cat to prompt. The OTP registers of the AB3100 are used to
store various device-unique information such as customer ID,
product flags and the 3GPP standard IMEI (International Mobile
Equipment Indentity) number.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Makefile     |    2 +-
 drivers/mfd/ab3100-otp.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/ab3100-otp.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6f8a9a1..13128b4 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -43,4 +43,4 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
-obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
+obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o ab3100-otp.o
diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
new file mode 100644
index 0000000..48d998c
--- /dev/null
+++ b/drivers/mfd/ab3100-otp.c
@@ -0,0 +1,123 @@
+/*
+ * drivers/mfd/ab3100_otp.c
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Driver to read out OTP from the AB3100 Mixed-signal circuit
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/ab3100.h>
+
+/* The OTP registers */
+#define AB3100_OTP0		0xb0
+#define AB3100_OTP1		0xb1
+#define AB3100_OTP2		0xb2
+#define AB3100_OTP3		0xb3
+#define AB3100_OTP4		0xb4
+#define AB3100_OTP5		0xb5
+#define AB3100_OTP6		0xb6
+#define AB3100_OTP7		0xb7
+#define AB3100_OTPP		0xbf
+
+static ssize_t show_otp(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct ab3100 *ab = dev_get_drvdata(dev);
+	u8 otpval[8];
+	u8 otpp;
+	u16 cid; /* Customer ID */
+	u32 tac; /* Type Allocation Code */
+	u8 fac;  /* Final Assembly Code */
+	u32 svn; /* Software Version Number */
+	int err;
+	char *bufp = buf;
+
+	err = ab3100_get_register_interruptible(ab, AB3100_OTPP, &otpp);
+	if (err) {
+		printk(KERN_ERR "Unable to read OTPP register\n");
+		return err;
+	}
+
+	err = ab3100_get_register_page_interruptible(ab, AB3100_OTP0,
+						     otpval, 8);
+	if (err) {
+		printk(KERN_ERR "Unable to read OTPO register\n");
+		return err;
+	}
+
+	bufp += sprintf(bufp, "OTP is %s\n",
+			(otpp & 0x80) ? "LOCKED" : "UNLOCKED");
+
+	bufp += sprintf(bufp, "OTP clock switch startup is %s\n",
+			(otpp & 0x40) ? "32kHz" : "34.1kHz (1MHz/30)");
+
+	bufp += sprintf(bufp, "PAF is %s\n",
+			(otpval[1] & 0x80) ? "SET" : "NOT SET");
+
+	bufp += sprintf(bufp, "IMEI is %s\n",
+			(otpval[1] & 0x40) ? "CHANGEABLE" : "NOT CHANGEABLE");
+
+	cid = ((otpval[1] << 8) | otpval[0]) & 0x3fff;
+	bufp += sprintf(bufp, "CID: 0x%04x (decimal: %d)\n", cid, cid);
+	tac = ((otpval[4] & 0x0f) << 16) | (otpval[3] << 8) | otpval[2];
+	fac = ((otpval[5] & 0x0f) << 4) | (otpval[4] >> 4);
+	svn = (otpval[7] << 12) | (otpval[6] << 4) | (otpval[5] >> 4);
+	bufp += sprintf(bufp, "IMEI: %u-%u-%u\n", tac, fac, svn);
+
+	return bufp-buf;
+}
+
+static DEVICE_ATTR(otp, S_IRUGO, show_otp, NULL);
+
+static int __init ab3100_otp_probe(struct platform_device *pdev)
+{
+	int err;
+
+	dev_info(&pdev->dev, "AB3100 OTP readout registered\n");
+
+	/* sysfs entries */
+	err = device_create_file(&pdev->dev, &dev_attr_otp);
+	if (err != 0) {
+		dev_err(&pdev->dev, "AB3100 OTP file registration failed!\n");
+		return err;
+	}
+	return 0;
+}
+
+static int __exit ab3100_otp_remove(struct platform_device *pdev)
+{
+	device_remove_file(&pdev->dev, &dev_attr_otp);
+
+	return 0;
+}
+
+static struct platform_driver ab3100_otp_driver = {
+	.driver = {
+		.name = "ab3100-otp",
+		.owner = THIS_MODULE,
+	},
+	.remove	 = __exit_p(ab3100_otp_remove),
+};
+
+static int __init ab3100_otp_init(void)
+{
+	return platform_driver_probe(&ab3100_otp_driver,
+				     ab3100_otp_probe);
+}
+
+static void __exit ab3100_otp_exit(void)
+{
+	platform_driver_unregister(&ab3100_otp_driver);
+}
+
+module_init(ab3100_otp_init);
+module_exit(ab3100_otp_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
+MODULE_DESCRIPTION("AB3100 OTP Readout Driver");
+MODULE_LICENSE("GPL");
-- 
1.6.2.1

