Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbXIKOOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbXIKOOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXIKOO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:14:26 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:58265 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXIKOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:14:24 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 10:14:23 EDT
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: linux-kernel@vger.kernel.org
Subject: [RFC+PATCH] RTC calibration
Date: Tue, 11 Sep 2007 15:48:53 +0200
Message-ID: <ujrmyvt2tyy.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

The STMicroelectronics M41T11 is an RTC chip which is similar in most
ways to the Dallas/Maxim DS1307 or DS1337, except that it supports
software calibration:

http://www.st.com/stonline/books/pdf/docs/6103.pdf

I want to use this calibration feature in an embedded device I'm
working on at TANDBERG Telecom AS.  The basic idea is that when the
device is connected to the network and an accurate reference clock is
available, a userland process will periodically measure the divergence
between the reference clock and the RTC, set the RTC to the correct
time and step the calibration register in the correct direction to
compensate for the observed drift.

The purpose of this is to reduce the extent to which the RTC will
drift when the device is switched off.  Obviously it won't be perfect,
as the temperature will be lower when the device is off than when it
is being calibrated, but the crystal's accuracy curve is reasonably
flat across the relevant temperature range.

Since there is no way to distinguish the M41T11 from its many cousins,
I've forked a new rtc-m41t11 driver from rtc-ds1307, stripped some
irrelevant code, cleaned up the rest, and added support for the
calibration register.

In order to access this from userland, I've added two ioctls,
(RTC_SPEED_UP and RTC_SPEED_DOWN) with corresponding functions in
drivers/rtc/interface.c (rtc_speed_up() and rtc_speed_down()) and
corresponding slots in rtc_class_ops (speed_up and speed_down).

These ioctls etc. take no parameters: speed_up will increase the speed
of the RTC by some unspecified small amount and slow_down will
decrease it by some unspecified small amount.  The application must
simply measure, tweak, wait, measure, tweak, wait etc. until the RTC
is within epsilon of the reference - where epsilon is some number that
takes into account the precision of the RTC and of the reference
clock, system call overhead, etc.  Since the RTC usually has a 1s
precision, epsilon is likely to be =B11s in practice.

My hope is that this interface is simple enough and general enough to
be usable by other RTC chips that may also support calibration, and
that both design and code are of sufficiently quality to make it into
the mainline at some point.

Patch follows my sig.  Comments of all kinds are welcome.

DES
--=20
Dag-Erling Sm=F8rgrav
Senior Software Developer
Linpro AS - www.linpro.no


--=-=-=
Content-Disposition: inline; filename=rtc-m41t11.diff

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index ff9e35c..07e5182 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -206,6 +206,15 @@ config RTC_DRV_PCF8583
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8583.
 
+config RTC_DRV_M41T11
+	tristate "ST M41T11"
+	depends on RTC_CLASS && I2C
+	help
+	  If you say yes here you get support for the ST M41T11 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41t11.
+
 config RTC_DRV_M41T80
 	tristate "ST M41T80 series RTC"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index d3a33aa..468aa0c 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
+obj-$(CONFIG_RTC_DRV_M41T11)	+= rtc-m41t11.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index ad66c6e..189afb4 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -272,3 +272,43 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
+
+int rtc_speed_up(struct rtc_device *rtc)
+{
+	int err = 0;
+
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return -EBUSY;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->speed_up)
+		err = -EINVAL;
+	else
+		err = rtc->ops->speed_up(rtc->dev.parent);
+
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_speed_up);
+
+int rtc_slow_down(struct rtc_device *rtc)
+{
+	int err = 0;
+
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return -EBUSY;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->slow_down)
+		err = -EINVAL;
+	else
+		err = rtc->ops->slow_down(rtc->dev.parent);
+
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_slow_down);
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 005fff3..d35f907 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -223,6 +223,8 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 	switch (cmd) {
 	case RTC_EPOCH_SET:
 	case RTC_SET_TIME:
+	case RTC_SPEED_UP:
+	case RTC_SLOW_DOWN:
 		if (!capable(CAP_SYS_TIME))
 			return -EACCES;
 		break;
@@ -395,6 +397,15 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 	case RTC_UIE_ON:
 		return set_uie(rtc);
 #endif
+
+	case RTC_SPEED_UP:
+		err = rtc_speed_up(rtc);
+		break;
+
+	case RTC_SLOW_DOWN:
+		err = rtc_speed_up(rtc);
+		break;
+
 	default:
 		err = -ENOTTY;
 		break;
diff --git a/drivers/rtc/rtc-m41t11.c b/drivers/rtc/rtc-m41t11.c
new file mode 100644
index 0000000..2d7128f
--- /dev/null
+++ b/drivers/rtc/rtc-m41t11.c
@@ -0,0 +1,319 @@
+/*
+ * rtc-m41t11.c - RTC driver for some ST M41T11, derived from rtc-ds1307.c
+ *
+ *  Copyright (C) 2005 James Chapman (ds1337 core)
+ *  Copyright (C) 2006 David Brownell
+ *  Copyright (C) 2007 TANDBERG Telecom AS
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/string.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+
+static unsigned short normal_i2c[] = { 0x68, I2C_CLIENT_END };
+
+I2C_CLIENT_INSMOD;
+
+#define M41T11_REG_SECS		0x00	/* 00-59 */
+#	define M41T11_BIT_ST		0x80
+#	define M41T11_MASK_SECS		0x7f
+#define M41T11_REG_MIN		0x01	/* 00-59 */
+#	define M41T11_MASK_MIN		0x7f
+#define M41T11_REG_HOUR		0x02	/* 00-23 */
+#	define M41T11_BIT_CEB		0x80
+#	define M41T11_BIT_CB		0x40
+#	define M41T11_MASK_HOUR		0x3f
+#define M41T11_REG_WDAY		0x03	/* 01-07 */
+#	define M41T11_MASK_WDAY		0x7
+#define M41T11_REG_MDAY		0x04	/* 01-31 */
+#	define M41T11_MASK_MDAY		0x3f
+#define M41T11_REG_MONTH	0x05	/* 01-12 */
+#	define M41T11_MASK_MONTH	0x1f
+#define M41T11_REG_YEAR		0x06	/* 00-99 */
+#	define M41T11_MASK_YEAR		0xff
+#define M41T11_REG_CONTROL	0x07
+#	define M41T11_BIT_OUT		0x80
+#	define M41T11_BIT_FT		0x40
+#	define M41T11_BIT_S		0x20
+#	define M41T11_MASK_CAL		0x1f
+
+struct m41t11 {
+	struct i2c_client i2c;
+	struct rtc_device *rtc;
+};
+
+static int m41t11_read(struct m41t11 *m41t11, u8 *data, int len)
+{
+	struct i2c_msg msg[2];
+	int result;
+
+	/* write address register */
+	msg[0].addr = m41t11->i2c.addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = data;
+
+	/* read data */
+	msg[1].addr = m41t11->i2c.addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = len;
+	msg[1].buf = data + 1;
+
+	result = i2c_transfer(m41t11->i2c.adapter, msg, 2);
+	if (result != 2) {
+		dev_err(&m41t11->i2c.dev, "read error %d\n", result);
+		return result;
+	}
+	return 0;
+}
+
+static int m41t11_write(struct m41t11 *m41t11, u8 *data, int len)
+{
+	struct i2c_msg msg[1];
+	int result;
+
+	/* write address register and data */
+	msg[0].addr = m41t11->i2c.addr;
+	msg[0].flags = 0;
+	msg[0].len = 1 + len;
+	msg[0].buf = data;
+
+	result = i2c_transfer(m41t11->i2c.adapter, msg, 1);
+	if (result != 1) {
+		dev_err(&m41t11->i2c.dev, "write error %d\n", result);
+		return result;
+	}
+	return 0;
+}
+
+static int m41t11_get_time(struct device *dev, struct rtc_time *t)
+{
+	struct m41t11 *m41t11 = dev_get_drvdata(dev);
+	u8 regs[8];
+
+	/* read the RTC registers all at once */
+	regs[0] = 0;
+	if (m41t11_read(m41t11, regs, 7) != 0)
+		return -EIO;
+
+	dev_info(dev, "read: %02x %02x %02x %02x %02x %02x %02x\n",
+		regs[1], regs[2], regs[3], regs[4], regs[5], regs[6], regs[7]);
+
+	t->tm_sec = BCD2BIN(regs[1+M41T11_REG_SECS] & M41T11_MASK_SECS);
+	t->tm_min = BCD2BIN(regs[1+M41T11_REG_MIN] & M41T11_MASK_MIN);
+	t->tm_hour = BCD2BIN(regs[1+M41T11_REG_HOUR] & M41T11_MASK_HOUR);
+	t->tm_wday = BCD2BIN(regs[1+M41T11_REG_WDAY] & M41T11_MASK_WDAY) - 1;
+	t->tm_mday = BCD2BIN(regs[1+M41T11_REG_MDAY] & M41T11_MASK_MDAY);
+	t->tm_mon = BCD2BIN(regs[1+M41T11_REG_MONTH] & M41T11_MASK_MONTH) - 1;
+
+	t->tm_year = BCD2BIN(regs[1+M41T11_REG_YEAR]);
+	/* assume 20xx if century bit is set, 19xx otherwise */
+	if (regs[1+M41T11_REG_HOUR] & M41T11_BIT_CB)
+		t->tm_year += 100;
+
+	dev_info(dev, "read secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		t->tm_sec, t->tm_min, t->tm_hour, t->tm_mday,
+		t->tm_mon, t->tm_year, t->tm_wday);
+
+	return 0;
+}
+
+static int m41t11_set_time(struct device *dev, struct rtc_time *t)
+{
+	struct m41t11 *m41t11 = dev_get_drvdata(dev);
+	u8 regs[8], val;
+
+	dev_info(dev, "write secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		t->tm_sec, t->tm_min, t->tm_hour, t->tm_mday,
+		t->tm_mon, t->tm_year, t->tm_wday);
+
+	regs[0] = 0;
+	regs[1+M41T11_REG_SECS] = BIN2BCD(t->tm_sec);
+	regs[1+M41T11_REG_MIN] = BIN2BCD(t->tm_min);
+	regs[1+M41T11_REG_HOUR] = BIN2BCD(t->tm_hour);
+	regs[1+M41T11_REG_WDAY] = BIN2BCD(t->tm_wday + 1);
+	regs[1+M41T11_REG_MDAY] = BIN2BCD(t->tm_mday);
+	regs[1+M41T11_REG_MONTH] = BIN2BCD(t->tm_mon + 1);
+
+	val = t->tm_year % 100;
+	regs[1+M41T11_REG_YEAR] = BIN2BCD(val);
+	regs[1+M41T11_REG_HOUR] |= M41T11_BIT_CEB;
+	if ((t->tm_year / 100) % 2)
+		regs[1+M41T11_REG_HOUR] |= M41T11_BIT_CB;
+
+	dev_info(dev, "write %02x %02x %02x %02x %02x %02x %02x\n",
+		regs[1], regs[2], regs[3], regs[4], regs[5], regs[6], regs[7]);
+
+	if (m41t11_write(m41t11, regs, 7) != 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int m41t11_speed_up(struct device *dev)
+{
+	struct m41t11 *m41t11 = dev_get_drvdata(dev);
+	u8 regs[2];
+
+	regs[0] = M41T11_REG_CONTROL;
+	if (m41t11_read(m41t11, regs, 1) != 0)
+		return -EIO;
+
+	/* XXX */
+
+	return -EIO;
+}
+
+static int m41t11_slow_down(struct device *dev)
+{
+	struct m41t11 *m41t11 = dev_get_drvdata(dev);
+	u8 regs[2];
+
+	regs[0] = M41T11_REG_CONTROL;
+	if (m41t11_read(m41t11, regs, 1) != 0)
+		return -EIO;
+
+	/* XXX */
+
+	return -EIO;
+}
+
+static const struct rtc_class_ops ds13xx_rtc_ops = {
+	.read_time	= m41t11_get_time,
+	.set_time	= m41t11_set_time,
+	.speed_up	= m41t11_speed_up,
+	.slow_down	= m41t11_slow_down,
+};
+
+static struct i2c_driver m41t11_driver;
+
+static int __devinit
+m41t11_detect(struct i2c_adapter *adapter, int address, int kind)
+{
+	struct m41t11 *m41t11;
+	u8 regs[8], val;
+	int err = -ENODEV;
+
+	if (!(m41t11 = kzalloc(sizeof(*m41t11), GFP_KERNEL))) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	strlcpy(m41t11->i2c.name, "m41t11", I2C_NAME_SIZE);
+	m41t11->i2c.addr = address;
+	m41t11->i2c.adapter = adapter;
+	m41t11->i2c.driver = &m41t11_driver;
+	m41t11->i2c.flags = 0;
+	i2c_set_clientdata(&m41t11->i2c, m41t11);
+
+read_rtc:
+	/* read RTC registers */
+	regs[0] = 0;
+	if (m41t11_read(m41t11, regs, 7) != 0) {
+		err = -EIO;
+		goto exit_free;
+	}
+
+	/* minimal sanity checking */
+	if (regs[1+M41T11_REG_SECS] & M41T11_BIT_ST) {
+		/* oscillator was stopped */
+		dev_warn(&m41t11->i2c.dev, "oscillator started; SET TIME!\n");
+		regs[0] = M41T11_REG_SECS;
+		regs[1] = 0;
+		m41t11_write(m41t11, regs, 1);
+		goto read_rtc;
+	}
+	val = BCD2BIN(regs[1+M41T11_REG_SECS] & M41T11_MASK_SECS);
+	if (val > 59)
+		goto exit_free;
+	val = BCD2BIN(regs[1+M41T11_REG_MIN] & M41T11_MASK_MIN);
+	if (val > 59)
+		goto exit_free;
+	val = BCD2BIN(regs[1+M41T11_REG_HOUR] & M41T11_MASK_HOUR);
+	if (val > 23)
+		goto exit_free;
+	val = BCD2BIN(regs[1+M41T11_REG_MDAY] & M41T11_MASK_MDAY);
+	if (val < 1 || val > 31)
+		goto exit_free;
+	val = BCD2BIN(regs[1+M41T11_REG_MONTH] & M41T11_MASK_MONTH);
+	if (val < 1 || val > 12)
+		goto exit_free;
+
+	/* Tell the I2C layer a new client has arrived */
+	if ((err = i2c_attach_client(&m41t11->i2c)) != 0)
+		goto exit_free;
+
+	m41t11->rtc = rtc_device_register(m41t11->i2c.name,
+					  &m41t11->i2c.dev,
+					  &ds13xx_rtc_ops,
+					  THIS_MODULE);
+	if (IS_ERR(m41t11->rtc)) {
+		err = PTR_ERR(m41t11->rtc);
+		dev_err(&m41t11->i2c.dev,
+			"unable to register the class device\n");
+		goto exit_detach;
+	}
+
+	return 0;
+
+exit_detach:
+	i2c_detach_client(&m41t11->i2c);
+exit_free:
+	kfree(m41t11);
+exit:
+	return err;
+}
+
+static int __devinit
+m41t11_attach_adapter(struct i2c_adapter *adapter)
+{
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+		return 0;
+	return i2c_probe(adapter, &addr_data, m41t11_detect);
+}
+
+static int __devexit m41t11_detach_client(struct i2c_client *client)
+{
+	int		err;
+	struct m41t11	*m41t11 = i2c_get_clientdata(client);
+
+	rtc_device_unregister(m41t11->rtc);
+	if ((err = i2c_detach_client(client)))
+		return err;
+	kfree(m41t11);
+	return 0;
+}
+
+static struct i2c_driver m41t11_driver = {
+	.driver = {
+		.name	= "m41t11",
+		.owner	= THIS_MODULE,
+	},
+	.attach_adapter	= m41t11_attach_adapter,
+	.detach_client	= __devexit_p(m41t11_detach_client),
+};
+
+static int __init m41t11_init(void)
+{
+	return i2c_add_driver(&m41t11_driver);
+}
+module_init(m41t11_init);
+
+static void __exit m41t11_exit(void)
+{
+	i2c_del_driver(&m41t11_driver);
+}
+module_exit(m41t11_exit);
+
+MODULE_DESCRIPTION("RTC driver for ST M41T11");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d5e4a4..53e1980 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -91,6 +91,9 @@ struct rtc_pll_info {
 #define RTC_PLL_GET	_IOR('p', 0x11, struct rtc_pll_info)  /* Get PLL correction */
 #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
 
+#define RTC_SPEED_UP	_IO('p', 0x13)  /* speed up a notch */
+#define RTC_SLOW_DOWN	_IO('p', 0x14)  /* slow down a notch */
+
 /* interrupt flags */
 #define RTC_IRQF 0x80 /* any of the following is active */
 #define RTC_PF 0x40
@@ -128,6 +131,8 @@ struct rtc_class_ops {
 	int (*irq_set_state)(struct device *, int enabled);
 	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
+	int (*speed_up)(struct device *);
+	int (*slow_down)(struct device *);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
@@ -196,6 +201,8 @@ extern int rtc_irq_set_state(struct rtc_device *rtc,
 				struct rtc_task *task, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
+extern int rtc_speed_up(struct rtc_device *rtc);
+extern int rtc_slow_down(struct rtc_device *rtc);
 
 typedef struct rtc_task {
 	void (*func)(void *private_data);

--=-=-=--
