Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZHRUwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZHRUwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHRUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:52:39 -0400
Received: from mail.df.lth.se ([194.47.250.12]:53127 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbZHRUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:52:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] MFD AB3100 OTP readout v2
Date: Tue, 18 Aug 2009 22:52:26 +0200
Message-Id: <1250628746-10077-1-git-send-email-linus.walleij@stericsson.com>
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
Reviewed-by: Samuel Ortiz <sameo@linux.intel.com>
---
ChangeLog v1->v2:
- added Kconfig entry making all OTP support optional and
  thus it also makes more sense to have it as a subdevice
  in a single, separate .c file.
- added a local state holder for the driver instead of
  reading out these values causing I2C traffic for no
  good reason as they cannot change anyway.
- move all properties over to one value per file sysfs
  entries.
- moved the human-readable file with summary to debugfs
  and only compile it in if debugfs was selected.
---
 drivers/mfd/Kconfig      |    9 ++
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/ab3100-otp.c |  268 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 278 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/ab3100-otp.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 491ac0f..fc3eab5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -256,6 +256,15 @@ config AB3100_CORE
 	  LEDs, vibrator, system power and temperature, power management
 	  and ALSA sound.
 
+config AB3100_OTP
+	tristate "ST-Ericsson AB3100 OTP functions"
+	depends on AB3100_CORE
+	default y if AB3100_CORE
+	help
+	  Select this to enable the AB3100 Mixed Signal IC OTP (one-time
+	  programmable memory) support. This exposes a sysfs file to read
+	  out OTP values.
+
 config EZX_PCAP
 	bool "PCAP Support"
 	depends on GENERIC_HARDIRQS && SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6f8a9a1..b61e5c9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -44,3 +44,4 @@ obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
+obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
new file mode 100644
index 0000000..0499b20
--- /dev/null
+++ b/drivers/mfd/ab3100-otp.c
@@ -0,0 +1,268 @@
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
+#include <linux/debugfs.h>
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
+/**
+ * struct ab3100_otp
+ * @dev containing device
+ * @ab3100 a pointer to the parent ab3100 device struct
+ * @locked whether the OTP is locked, after locking, no more bits
+ *       can be changed but before locking it is still possible
+ *       to change bits from 1->0.
+ * @freq clocking frequency for the OTP, this frequency is either
+ *       32768Hz or 1MHz/30
+ * @paf product activation flag, indicates whether this is a real
+ *       product (paf true) or a lab board etc (paf false)
+ * @imeich if this is set it is possible to override the
+ *       IMEI number found in the tac, fac and svn fields with
+ *       (secured) software
+ * @cid customer ID
+ * @tac type allocation code of the IMEI
+ * @fac final assembly code of the IMEI
+ * @svn software version number of the IMEI
+ * @debugfs a debugfs file used when dumping to file
+ */
+struct ab3100_otp {
+	struct device *dev;
+	struct ab3100 *ab3100;
+	bool locked;
+	u32 freq;
+	bool paf;
+	bool imeich;
+	u16 cid:14;
+	u32 tac:20;
+	u8 fac;
+	u32 svn:20;
+	struct dentry *debugfs;
+};
+
+static int __init ab3100_otp_read(struct ab3100_otp *otp)
+{
+	struct ab3100 *ab = otp->ab3100;
+	u8 otpval[8];
+	u8 otpp;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab, AB3100_OTPP, &otpp);
+	if (err) {
+		dev_err(otp->dev, "unable to read OTPP register\n");
+		return err;
+	}
+
+	err = ab3100_get_register_page_interruptible(ab, AB3100_OTP0,
+						     otpval, 8);
+	if (err) {
+		dev_err(otp->dev, "unable to read OTP register page\n");
+		return err;
+	}
+
+	/* Cache OTP properties, they never change by nature */
+	otp->locked = (otpp & 0x80);
+	otp->freq = (otpp & 0x40) ? 32768 : 34100;
+	otp->paf = (otpval[1] & 0x80);
+	otp->imeich = (otpval[1] & 0x40);
+	otp->cid = ((otpval[1] << 8) | otpval[0]) & 0x3fff;
+	otp->tac = ((otpval[4] & 0x0f) << 16) | (otpval[3] << 8) | otpval[2];
+	otp->fac = ((otpval[5] & 0x0f) << 4) | (otpval[4] >> 4);
+	otp->svn = (otpval[7] << 12) | (otpval[6] << 4) | (otpval[5] >> 4);
+	return 0;
+}
+
+/*
+ * This is a simple debugfs human-readable file that dumps out
+ * the contents of the OTP.
+ */
+#ifdef CONFIG_DEBUGFS
+static int show_otp(struct seq_file *s, void *v)
+{
+	struct ab3100_otp *otp = s->private;
+	int err;
+
+	seq_printf(s, "OTP is %s\n", otp->locked ? "LOCKED" : "UNLOCKED");
+	seq_printf(s, "OTP clock switch startup is %uHz\n", otp->freq);
+	seq_printf(s, "PAF is %s\n", otp->paf ? "SET" : "NOT SET");
+	seq_printf(s, "IMEI is %s\n", otp->imeich ?
+		   "CHANGEABLE" : "NOT CHANGEABLE");
+	seq_printf(s, "CID: 0x%04x (decimal: %d)\n", otp->cid, otp->cid);
+	seq_printf(s, "IMEI: %u-%u-%u\n", otp->tac, otp->fac, otp->svn);
+	return 0;
+}
+
+static int ab3100_otp_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab3100_otp_show, inode->i_private);
+}
+
+static const struct file_operations ab3100_otp_operations = {
+	.open		= ab3100_otp_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init ab3100_otp_init_debugfs(struct device *dev,
+					  struct ab3100_otp *otp)
+{
+	otp->debugfs = debugfs_create_file("ab3100_otp", S_IFREG | S_IRUGO,
+					   NULL, otp,
+					   &ab3100_otp_operations);
+	if (!otp->debugfs) {
+		dev_err(dev, "AB3100 debugfs OTP file registration failed!\n");
+		return err;
+	}
+}
+
+static void __exit ab3100_otp_exit_debugfs(struct ab3100_otp *otp)
+{
+	debugfs_remove_file(otp->debugfs);
+}
+#else
+/* Compile this out if debugfs not selected */
+static inline int __init ab3100_otp_init_debugfs(struct device *dev,
+						 struct ab3100_otp *otp)
+{
+	return 0;
+}
+
+static inline void __exit ab3100_otp_exit_debugfs(struct ab3100_otp *otp)
+{
+}
+#endif
+
+#define SHOW_AB3100_ATTR(name) \
+static ssize_t ab3100_otp_##name##_show(struct device *dev, \
+			       struct device_attribute *attr, \
+			       char *buf) \
+{\
+	struct ab3100_otp *otp = dev_get_drvdata(dev); \
+	return sprintf(buf, "%u\n", otp->name); \
+}
+
+SHOW_AB3100_ATTR(locked)
+SHOW_AB3100_ATTR(freq)
+SHOW_AB3100_ATTR(paf)
+SHOW_AB3100_ATTR(imeich)
+SHOW_AB3100_ATTR(cid)
+SHOW_AB3100_ATTR(fac)
+SHOW_AB3100_ATTR(tac)
+SHOW_AB3100_ATTR(svn)
+
+static struct device_attribute ab3100_otp_attrs[] = {
+	__ATTR(locked, S_IRUGO, ab3100_otp_locked_show, NULL),
+	__ATTR(freq, S_IRUGO, ab3100_otp_freq_show, NULL),
+	__ATTR(paf, S_IRUGO, ab3100_otp_paf_show, NULL),
+	__ATTR(imeich, S_IRUGO, ab3100_otp_imeich_show, NULL),
+	__ATTR(cid, S_IRUGO, ab3100_otp_cid_show, NULL),
+	__ATTR(fac, S_IRUGO, ab3100_otp_fac_show, NULL),
+	__ATTR(tac, S_IRUGO, ab3100_otp_tac_show, NULL),
+	__ATTR(svn, S_IRUGO, ab3100_otp_svn_show, NULL),
+};
+
+static int __init ab3100_otp_probe(struct platform_device *pdev)
+{
+	struct ab3100_otp *otp;
+	int err = 0;
+	int i;
+
+	otp = kzalloc(sizeof(struct ab3100_otp), GFP_KERNEL);
+	if (!otp) {
+		dev_err(&pdev->dev, "could not allocate AB3100 OTP device\n");
+		return -ENOMEM;
+	}
+	otp->dev = &pdev->dev;
+
+	/* Replace platform data coming in with a local struct */
+	otp->ab3100 = platform_get_drvdata(pdev);
+	platform_set_drvdata(pdev, otp);
+
+	err = ab3100_otp_read(otp);
+	if (err)
+		return err;
+
+	dev_info(&pdev->dev, "AB3100 OTP readout registered\n");
+
+	/* sysfs entries */
+	for (i = 0; i < ARRAY_SIZE(ab3100_otp_attrs); i++) {
+		err = device_create_file(&pdev->dev,
+					 &ab3100_otp_attrs[i]);
+		if (err)
+			goto out_no_sysfs;
+	}
+
+	/* debugfs entries */
+	err = ab3100_otp_init_debugfs(&pdev->dev, otp);
+	if (err)
+		goto out_no_debugfs;
+
+	return 0;
+
+out_no_sysfs:
+	for (i = 0; i < ARRAY_SIZE(ab3100_otp_attrs); i++)
+		device_remove_file(&pdev->dev,
+				   &ab3100_otp_attrs[i]);
+out_no_debugfs:
+	kfree(otp);
+	return err;
+}
+
+static int __exit ab3100_otp_remove(struct platform_device *pdev)
+{
+	struct ab3100_otp *otp = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab3100_otp_attrs); i++)
+		device_remove_file(&pdev->dev,
+				   &ab3100_otp_attrs[i]);
+	ab3100_otp_exit_debugfs(otp);
+	kfree(otp);
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

