Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYJASva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYJASva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYJASvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:51:03 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:24167 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753605AbYJASu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:50:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=nwMMRTVajBltpRmDqIHw9L34XjKn3pyEbkYqIh6wh7HAnd8dzO+NmmSVbu5n1NcQBridIlCaFJq5RBaZ7uSwgDyCDZj6VXhUqgEko24nkBJqWaLAe/eAD3fh36yC7vV50Q20aVVJTJr0pCegZvhIVOuBo05Ju84nubUx+/X/C4E=  ;
X-YMail-OSG: 3rdTIAkVM1mLozSTPMd2dj_fVnASNGZR1rzeR4H7mKV4PJYHmCuurcmdYuJpItHBAmam4FovcLXUpVXmjXFD_8Jyw1toonxz.MzCWSXaxz8w_5Mg51lnlgBqQrjE5Sta76cj8zpUSEjVDmuVimIDNEniTegmEbPZa0wTte1zYauPUhEQUg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 2.6.27-rc8 2/2] drivers/rtc/rtc-twl4030.c
Date: Wed, 1 Oct 2008 11:50:50 -0700
User-Agent: KMail/1.9.9
Cc: Samuel Ortiz <sameo@openedhand.com>, Tony Lindgren <tony@atomide.com>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-omap@vger.kernel.org,
       rtc-linux@googlegroups.com
References: <200810011128.34179.david-b@pacbell.net>
In-Reply-To: <200810011128.34179.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810011150.50917.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the RTC in the TWL4030 family chips.

POSTED AS A TWL4030 MFD EXAMPLE -- NOT YET FOR MERGING.

As an example ... since it seems closest of the various sub-chip
drivers to being ready for mainline.  Why not yet for merging?

 - This includes a cleanup patch that's not yet been merged into
   its primary copy (in the OMAP tree), removing needless headers
   that prevent building on non-OMAP systems.

 - The <linux/i2c/...> header file should probably be removed ...
   nothing in it should be needed outside of the RTC driver.

 - IRQ handling issues:

    *	This depends on the TWL4030 MFD core, which isn't merged
	yet (and which may well need discussion first, now that
	it's been posted).

    *	It also depends on TWL4030 "power" interrupt handling,
	which hasn't yet been submitted.

    *	I'm suspecting the IRQ handling is incorrect.  Rather than
	reading REG_PWR_ISR1 again (acking IRQs from other devices!)
	maybe it can just trigger on one (!) edge.

Other than those issues, I think this driver should pretty much
be ready for mainline merge.  It passes "rtctest" and seems
fairly clean.

But as always, review is appreciated.  We all have blind spots;
many-eyes-helps, and all that.  :)

---
 drivers/rtc/Kconfig             |   10 
 drivers/rtc/Makefile            |    1 
 drivers/rtc/rtc-twl4030.c       |  529 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030-rtc.h |  172 ++++++++++++
 4 files changed, 712 insertions(+)

--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -246,6 +246,16 @@ config RTC_DRV_TWL92330
 	  platforms.  The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
+config RTC_DRV_TWL4030
+	tristate "TWL4030/TPS659x0 Real Time Clock"
+	depends on RTC_CLASS && TWL4030_CORE
+	help
+	  If you say yes here you get support for internal Real-Time
+	  Clock of TWL4030/TPS650x0 family chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-twl4030.
+
 config RTC_DRV_S35390A
 	tristate "Seiko Instruments S-35390A"
 	select BITREVERSE
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa11
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
+obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl4030.o
 obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
--- /dev/null
+++ b/drivers/rtc/rtc-twl4030.c
@@ -0,0 +1,529 @@
+/*
+ * rtc-twl4030.c -- TWL4030 Real Time Clock interface
+ *
+ * Copyright (C) 2007 MontaVista Software, Inc
+ * Author: Alexandre Rusev <source@mvista.com>
+ *
+ * Based on original TI driver twl4030-rtc.c
+ *   Copyright (C) 2006 Texas Instruments, Inc.
+ *
+ * Based on rtc-omap.c
+ *   Copyright (C) 2003 MontaVista Software, Inc.
+ *   Author: George G. Davis <gdavis@mvista.com> or <source@mvista.com>
+ *   Copyright (C) 2006 David Brownell
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl4030-rtc.h>
+
+
+#define ALL_TIME_REGS		6
+
+/*
+ * Supports 1 byte read from TWL4030 RTC register.
+ */
+static int twl4030_rtc_read_u8(u8 *data, u8 reg)
+{
+	int ret;
+
+	ret = twl4030_i2c_read_u8(TWL4030_MODULE_RTC, data, reg);
+	if (ret < 0)
+		pr_err("twl4030_rtc: Could not read TWL4030"
+		       "register %X - error %d\n", reg, ret);
+	return ret;
+}
+
+/*
+ * Supports 1 byte write to TWL4030 RTC registers.
+ */
+static int twl4030_rtc_write_u8(u8 data, u8 reg)
+{
+	int ret;
+
+	ret = twl4030_i2c_write_u8(TWL4030_MODULE_RTC, data, reg);
+	if (ret < 0)
+		pr_err("twl4030_rtc: Could not write TWL4030"
+		       "register %X - error %d\n", reg, ret);
+	return ret;
+}
+
+/*
+ * Cache the value for timer/alarm interrupts register; this is
+ * only changed by callers holding rtc ops lock (or resume).
+ */
+static unsigned char rtc_irq_bits;
+
+/*
+ * Enable timer and/or alarm interrupts.
+ */
+static int set_rtc_irq_bit(unsigned char bit)
+{
+	unsigned char val;
+	int ret;
+
+	val = rtc_irq_bits | bit;
+	ret = twl4030_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	if (ret == 0)
+		rtc_irq_bits = val;
+
+	return ret;
+}
+
+/*
+ * Disable timer and/or alarm interrupts.
+ */
+static int mask_rtc_irq_bit(unsigned char bit)
+{
+	unsigned char val;
+	int ret;
+
+	val = rtc_irq_bits & ~bit;
+	ret = twl4030_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	if (ret == 0)
+		rtc_irq_bits = val;
+
+	return ret;
+}
+
+static inline int twl4030_rtc_alarm_irq_set_state(int enabled)
+{
+	int ret;
+
+	if (enabled)
+		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	else
+		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+
+	return ret;
+}
+
+static inline int twl4030_rtc_irq_set_state(int enabled)
+{
+	int ret;
+
+	if (enabled)
+		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+	else
+		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+
+	return ret;
+}
+
+/*
+ * Gets current TWL4030 RTC time and date parameters.
+ *
+ * The RTC's time/alarm representation is not what gmtime(3) requires
+ * Linux to use:
+ *
+ *  - Months are 1..12 vs Linux 0-11
+ *  - Years are 0..99 vs Linux 1900..N (we assume 21st century)
+ */
+static int twl4030_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	int ret;
+	u8 save_control;
+
+	ret = twl4030_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	if (ret < 0)
+		return ret;
+
+	save_control |= BIT_RTC_CTRL_REG_GET_TIME_M;
+
+	ret = twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	if (ret < 0)
+		return ret;
+
+	ret = twl4030_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+			       REG_SECONDS_REG, ALL_TIME_REGS);
+
+	if (ret < 0) {
+		dev_err(dev, "rtc_read_time error %d\n", ret);
+		return ret;
+	}
+
+	tm->tm_sec = bcd2bin(rtc_data[0]);
+	tm->tm_min = bcd2bin(rtc_data[1]);
+	tm->tm_hour = bcd2bin(rtc_data[2]);
+	tm->tm_mday = bcd2bin(rtc_data[3]);
+	tm->tm_mon = bcd2bin(rtc_data[4]) - 1;
+	tm->tm_year = bcd2bin(rtc_data[5]) + 100;
+
+	return ret;
+}
+
+static int twl4030_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned char save_control;
+	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	int ret;
+
+	rtc_data[1] = bin2bcd(tm->tm_sec);
+	rtc_data[2] = bin2bcd(tm->tm_min);
+	rtc_data[3] = bin2bcd(tm->tm_hour);
+	rtc_data[4] = bin2bcd(tm->tm_mday);
+	rtc_data[5] = bin2bcd(tm->tm_mon + 1);
+	rtc_data[6] = bin2bcd(tm->tm_year - 100);
+
+	/* Stop RTC while updating the TC registers */
+	ret = twl4030_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	if (ret < 0)
+		goto out;
+
+	save_control &= ~BIT_RTC_CTRL_REG_STOP_RTC_M;
+	twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	if (ret < 0)
+		goto out;
+
+	/* update all the time registers in one shot */
+	ret = twl4030_i2c_write(TWL4030_MODULE_RTC, rtc_data,
+			REG_SECONDS_REG, ALL_TIME_REGS);
+	if (ret < 0) {
+		dev_err(dev, "rtc_set_time error %d\n", ret);
+		goto out;
+	}
+
+	/* Start back RTC */
+	save_control |= BIT_RTC_CTRL_REG_STOP_RTC_M;
+	ret = twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+
+out:
+	return ret;
+}
+
+/*
+ * Gets current TWL4030 RTC alarm time.
+ */
+static int twl4030_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	int ret;
+
+	ret = twl4030_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+			       REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
+	if (ret < 0) {
+		dev_err(dev, "rtc_read_alarm error %d\n", ret);
+		return ret;
+	}
+
+	/* some of these fields may be wildcard/"match all" */
+	alm->time.tm_sec = bcd2bin(rtc_data[0]);
+	alm->time.tm_min = bcd2bin(rtc_data[1]);
+	alm->time.tm_hour = bcd2bin(rtc_data[2]);
+	alm->time.tm_mday = bcd2bin(rtc_data[3]);
+	alm->time.tm_mon = bcd2bin(rtc_data[4]) - 1;
+	alm->time.tm_year = bcd2bin(rtc_data[5]) + 100;
+
+	/* report cached alarm enable state */
+	if (rtc_irq_bits & BIT_RTC_INTERRUPTS_REG_IT_ALARM_M)
+		alm->enabled = 1;
+
+	return ret;
+}
+
+static int twl4030_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	unsigned char alarm_data[ALL_TIME_REGS + 1];
+	int ret;
+
+	ret = twl4030_rtc_alarm_irq_set_state(0);
+	if (ret)
+		goto out;
+
+	alarm_data[1] = bin2bcd(alm->time.tm_sec);
+	alarm_data[2] = bin2bcd(alm->time.tm_min);
+	alarm_data[3] = bin2bcd(alm->time.tm_hour);
+	alarm_data[4] = bin2bcd(alm->time.tm_mday);
+	alarm_data[5] = bin2bcd(alm->time.tm_mon + 1);
+	alarm_data[6] = bin2bcd(alm->time.tm_year - 100);
+
+	/* update all the alarm registers in one shot */
+	ret = twl4030_i2c_write(TWL4030_MODULE_RTC, alarm_data,
+			REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
+	if (ret) {
+		dev_err(dev, "rtc_set_alarm error %d\n", ret);
+		goto out;
+	}
+
+	if (alm->enabled)
+		ret = twl4030_rtc_alarm_irq_set_state(1);
+out:
+	return ret;
+}
+
+#ifdef	CONFIG_RTC_INTF_DEV
+
+static int twl4030_rtc_ioctl(struct device *dev, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	case RTC_AIE_OFF:
+		return twl4030_rtc_alarm_irq_set_state(0);
+	case RTC_AIE_ON:
+		return twl4030_rtc_alarm_irq_set_state(1);
+	case RTC_UIE_OFF:
+		return twl4030_rtc_irq_set_state(0);
+	case RTC_UIE_ON:
+		return twl4030_rtc_irq_set_state(1);
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#else
+#define	omap_rtc_ioctl	NULL
+#endif
+
+static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
+{
+	unsigned long events = 0;
+	int ret = IRQ_NONE;
+	int res;
+	u8 rd_reg;
+
+	res = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+	if (res)
+		goto out;
+	/*
+	 * Figure out source of interrupt: ALARM or TIMER in RTC_STATUS_REG.
+	 * only one (ALARM or RTC) interrupt source may be enabled
+	 * at time, we also could check our results
+	 * by reading RTS_INTERRUPTS_REGISTER[IT_TIMER,IT_ALARM]
+	 */
+	if (rd_reg & BIT_RTC_STATUS_REG_ALARM_M)
+		events |= RTC_IRQF | RTC_AF;
+	else
+		events |= RTC_IRQF | RTC_UF;
+
+	res = twl4030_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+				   REG_RTC_STATUS_REG);
+	if (res)
+		goto out;
+
+	/* Clear on Read enabled. RTC_IT bit of REG_PWR_ISR1 needs
+	 * 2 reads to clear the interrupt. One read is done in
+	 * do_twl4030_pwrirq(). Doing the second read, to clear
+	 * the bit.
+	 */
+	res = twl4030_i2c_read_u8(TWL4030_MODULE_INT, &rd_reg, REG_PWR_ISR1);
+	if (res)
+		goto out;
+
+	/* Notify RTC core on event */
+	rtc_update_irq(rtc, 1, events);
+
+	ret = IRQ_HANDLED;
+out:
+	return ret;
+}
+
+static struct rtc_class_ops twl4030_rtc_ops = {
+	.ioctl		= twl4030_rtc_ioctl,
+	.read_time	= twl4030_rtc_read_time,
+	.set_time	= twl4030_rtc_set_time,
+	.read_alarm	= twl4030_rtc_read_alarm,
+	.set_alarm	= twl4030_rtc_set_alarm,
+};
+
+static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
+{
+	struct twl4030rtc_platform_data *pdata = pdev->dev.platform_data;
+	struct rtc_device *rtc;
+	int ret = 0;
+	int irq = platform_get_irq(pdev, 0);
+	u8 rd_reg;
+
+	if (irq < 0)
+		return irq;
+
+	if (pdata != NULL && pdata->init != NULL) {
+		ret = pdata->init();
+		if (ret < 0)
+			goto out;
+	}
+
+	rtc = rtc_device_register(pdev->name,
+				  &pdev->dev, &twl4030_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = -EINVAL;
+		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
+			PTR_ERR(rtc));
+		goto out0;
+
+	}
+
+	platform_set_drvdata(pdev, rtc);
+
+	ret = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+
+	if (ret < 0)
+		goto out1;
+
+	if (rd_reg & BIT_RTC_STATUS_REG_POWER_UP_M)
+		dev_warn(&pdev->dev, "Power up reset detected.\n");
+
+	if (rd_reg & BIT_RTC_STATUS_REG_ALARM_M)
+		dev_warn(&pdev->dev, "Pending Alarm interrupt detected.\n");
+
+	/* Clear RTC Power up reset and pending alarm interrupts */
+	ret = twl4030_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
+	if (ret < 0)
+		goto out1;
+
+	ret = request_irq(irq, twl4030_rtc_interrupt,
+				0, rtc->dev.bus_id, rtc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "IRQ is not free.\n");
+		goto out1;
+	}
+
+	/* Check RTC module status, Enable if it is off */
+	ret = twl4030_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	if (ret < 0)
+		goto out2;
+
+	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
+		dev_info(&pdev->dev, "Enabling TWL4030-RTC.\n");
+		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
+		ret = twl4030_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
+		if (ret < 0)
+			goto out2;
+	}
+
+	ret = twl4030_i2c_read_u8(TWL4030_MODULE_INT, &rd_reg, REG_PWR_IMR1);
+	if (ret < 0)
+		goto out2;
+
+	rd_reg &= PWR_RTC_IT_UNMASK;
+	/* MASK PWR - we will need this */
+	ret = twl4030_i2c_write_u8(TWL4030_MODULE_INT, rd_reg, REG_PWR_IMR1);
+	if (ret < 0)
+		goto out2;
+
+	ret = twl4030_i2c_read_u8(TWL4030_MODULE_INT, &rd_reg, REG_PWR_EDR1);
+	if (ret < 0)
+		goto out2;
+
+	/* Rising edge detection enabled, needed for RTC alarm */
+	rd_reg |= 0x80;
+	ret = twl4030_i2c_write_u8(TWL4030_MODULE_INT, rd_reg, REG_PWR_EDR1);
+	if (ret < 0)
+		goto out2;
+
+	/* init cached IRQ enable bits */
+	ret = twl4030_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
+	if (ret < 0)
+		goto out2;
+
+	return ret;
+
+
+out2:
+	free_irq(irq, rtc);
+out1:
+	rtc_device_unregister(rtc);
+out0:
+	if (pdata != NULL && pdata->exit != NULL)
+		pdata->exit();
+out:
+	return ret;
+}
+
+/*
+ * Disable all TWL4030 RTC module interrupts.
+ * Sets status flag to free.
+ */
+static int __devexit twl4030_rtc_remove(struct platform_device *pdev)
+{
+	/* leave rtc running, but disable irqs */
+	struct twl4030rtc_platform_data *pdata = pdev->dev.platform_data;
+	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
+
+	free_irq(irq, rtc);
+
+	if (pdata != NULL && pdata->exit != NULL)
+		pdata->exit();
+
+	rtc_device_unregister(rtc);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static void twl4030_rtc_shutdown(struct platform_device *pdev)
+{
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M |
+			 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+}
+
+#ifdef CONFIG_PM
+
+static unsigned char irqstat;
+
+static int twl4030_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	irqstat = rtc_irq_bits;
+
+	/* REVISIT alarm may need to wake us from sleep */
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M |
+			 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	return 0;
+}
+
+static int twl4030_rtc_resume(struct platform_device *pdev)
+{
+	set_rtc_irq_bit(irqstat);
+	return 0;
+}
+
+#else
+#define twl4030_rtc_suspend NULL
+#define twl4030_rtc_resume  NULL
+#endif
+
+MODULE_ALIAS("platform:twl4030_rtc");
+
+static struct platform_driver twl4030rtc_driver = {
+	.probe		= twl4030_rtc_probe,
+	.remove		= __devexit_p(twl4030_rtc_remove),
+	.shutdown	= twl4030_rtc_shutdown,
+	.suspend	= twl4030_rtc_suspend,
+	.resume		= twl4030_rtc_resume,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "twl4030_rtc",
+	},
+};
+
+static int __init twl4030_rtc_init(void)
+{
+	return platform_driver_register(&twl4030rtc_driver);
+}
+module_init(twl4030_rtc_init);
+
+static void __exit twl4030_rtc_exit(void)
+{
+	platform_driver_unregister(&twl4030rtc_driver);
+}
+module_exit(twl4030_rtc_exit);
+
+MODULE_AUTHOR("Texas Instruments, MontaVista Software");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/include/linux/i2c/twl4030-rtc.h
@@ -0,0 +1,172 @@
+/*
+ * include/asm-arm/arch-omap/twl4030-rtc.h
+ *
+ * Copyright (C) 2006 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __TWL4030_RTC_H__
+#define __TWL4030_RTC_H__
+
+#define REG_SECONDS_REG                          (0x0)
+#define REG_MINUTES_REG                          (0x1)
+#define REG_HOURS_REG                            (0x2)
+#define REG_DAYS_REG                             (0x3)
+#define REG_MONTHS_REG                           (0x4)
+#define REG_YEARS_REG                            (0x5)
+#define REG_WEEKS_REG                            (0x6)
+#define REG_ALARM_SECONDS_REG                    (0x7)
+#define REG_ALARM_MINUTES_REG                    (0x8)
+#define REG_ALARM_HOURS_REG                      (0x9)
+#define REG_ALARM_DAYS_REG                       (0xA)
+#define REG_ALARM_MONTHS_REG                     (0xB)
+#define REG_ALARM_YEARS_REG                      (0xC)
+#define REG_RTC_CTRL_REG                         (0xD)
+#define REG_RTC_STATUS_REG                       (0xE)
+#define REG_RTC_INTERRUPTS_REG                   (0xF)
+#define REG_RTC_COMP_LSB_REG                     (0x10)
+#define REG_RTC_COMP_MSB_REG                     (0x11)
+
+/* REVISIT: these TWL4030 power registers are only used
+ * by rtc-twl4030 driver, move to an appropriate header
+ * if other drivers need the registers
+ */
+/* Power registers */
+#define REG_PWR_ISR1		0x00
+#define REG_PWR_IMR1		0x01
+#define REG_PWR_EDR1		0x05
+
+#define PWR_RTC_IT_UNMASK	 ~(0x08)
+#define PWR_RTC_INT_CLR          0x08
+
+/**** BitField Definitions */
+/* SECONDS_REG Fields */
+#define BIT_SECONDS_REG_SEC0                     (0x000)
+#define BIT_SECONDS_REG_SEC0_M                   (0x0000000F)
+#define BIT_SECONDS_REG_SEC1                     (0x004)
+#define BIT_SECONDS_REG_SEC1_M                   (0x00000070)
+/* MINUTES_REG Fields */
+#define BIT_MINUTES_REG_MIN0                     (0x000)
+#define BIT_MINUTES_REG_MIN0_M                   (0x0000000F)
+#define BIT_MINUTES_REG_MIN1                     (0x004)
+#define BIT_MINUTES_REG_MIN1_M                   (0x00000070)
+/* HOURS_REG Fields */
+#define BIT_HOURS_REG_HOUR0                      (0x000)
+#define BIT_HOURS_REG_HOUR0_M                    (0x0000000F)
+#define BIT_HOURS_REG_HOUR1                      (0x004)
+#define BIT_HOURS_REG_HOUR1_M                    (0x00000030)
+#define BIT_HOURS_REG_PM_NAM                     (0x007)
+#define BIT_HOURS_REG_PM_NAM_M                   (0x00000080)
+/* DAYS_REG Fields */
+#define BIT_DAYS_REG_DAY0                        (0x000)
+#define BIT_DAYS_REG_DAY0_M                      (0x0000000F)
+#define BIT_DAYS_REG_DAY1                        (0x004)
+#define BIT_DAYS_REG_DAY1_M                      (0x00000030)
+/* MONTHS_REG Fields */
+#define BIT_MONTHS_REG_MONTH0                    (0x000)
+#define BIT_MONTHS_REG_MONTH0_M                  (0x0000000F)
+#define BIT_MONTHS_REG_MONTH1                    (0x004)
+#define BIT_MONTHS_REG_MONTH1_M                  (0x00000010)
+/* YEARS_REG Fields */
+#define BIT_YEARS_REG_YEAR0                      (0x000)
+#define BIT_YEARS_REG_YEAR0_M                    (0x0000000F)
+#define BIT_YEARS_REG_YEAR1                      (0x004)
+#define BIT_YEARS_REG_YEAR1_M                    (0x000000F0)
+/* WEEKS_REG Fields */
+#define BIT_WEEKS_REG_WEEK                       (0x000)
+#define BIT_WEEKS_REG_WEEK_M                     (0x00000007)
+/* ALARM_SECONDS_REG Fields */
+#define BIT_ALARM_SECONDS_REG_ALARM_SEC0         (0x000)
+#define BIT_ALARM_SECONDS_REG_ALARM_SEC0_M       (0x0000000F)
+#define BIT_ALARM_SECONDS_REG_ALARM_SEC1         (0x004)
+#define BIT_ALARM_SECONDS_REG_ALARM_SEC1_M       (0x00000070)
+/* ALARM_MINUTES_REG Fields */
+#define BIT_ALARM_MINUTES_REG_ALARM_MIN0         (0x000)
+#define BIT_ALARM_MINUTES_REG_ALARM_MIN0_M       (0x0000000F)
+#define BIT_ALARM_MINUTES_REG_ALARM_MIN1         (0x004)
+#define BIT_ALARM_MINUTES_REG_ALARM_MIN1_M       (0x00000070)
+/* ALARM_HOURS_REG Fields */
+#define BIT_ALARM_HOURS_REG_ALARM_HOUR0          (0x000)
+#define BIT_ALARM_HOURS_REG_ALARM_HOUR0_M        (0x0000000F)
+#define BIT_ALARM_HOURS_REG_ALARM_HOUR1          (0x004)
+#define BIT_ALARM_HOURS_REG_ALARM_HOUR1_M        (0x00000030)
+#define BIT_ALARM_HOURS_REG_ALARM_PM_NAM         (0x007)
+#define BIT_ALARM_HOURS_REG_ALARM_PM_NAM_M       (0x00000080)
+/* ALARM_DAYS_REG Fields */
+#define BIT_ALARM_DAYS_REG_ALARM_DAY0            (0x000)
+#define BIT_ALARM_DAYS_REG_ALARM_DAY0_M          (0x0000000F)
+#define BIT_ALARM_DAYS_REG_ALARM_DAY1            (0x004)
+#define BIT_ALARM_DAYS_REG_ALARM_DAY1_M          (0x00000030)
+/* ALARM_MONTHS_REG Fields */
+#define BIT_ALARM_MONTHS_REG_ALARM_MONTH0        (0x000)
+#define BIT_ALARM_MONTHS_REG_ALARM_MONTH0_M      (0x0000000F)
+#define BIT_ALARM_MONTHS_REG_ALARM_MONTH1        (0x004)
+#define BIT_ALARM_MONTHS_REG_ALARM_MONTH1_M      (0x00000010)
+/* ALARM_YEARS_REG Fields */
+#define BIT_ALARM_YEARS_REG_ALARM_YEAR0          (0x000)
+#define BIT_ALARM_YEARS_REG_ALARM_YEAR0_M        (0x0000000F)
+#define BIT_ALARM_YEARS_REG_ALARM_YEAR1          (0x004)
+#define BIT_ALARM_YEARS_REG_ALARM_YEAR1_M        (0x000000F0)
+/* RTC_CTRL_REG Fields */
+#define BIT_RTC_CTRL_REG_STOP_RTC                (0x000)
+#define BIT_RTC_CTRL_REG_STOP_RTC_M              (0x00000001)
+#define BIT_RTC_CTRL_REG_ROUND_30S               (0x001)
+#define BIT_RTC_CTRL_REG_ROUND_30S_M             (0x00000002)
+#define BIT_RTC_CTRL_REG_AUTO_COMP               (0x002)
+#define BIT_RTC_CTRL_REG_AUTO_COMP_M             (0x00000004)
+#define BIT_RTC_CTRL_REG_MODE_12_24              (0x003)
+#define BIT_RTC_CTRL_REG_MODE_12_24_M            (0x00000008)
+#define BIT_RTC_CTRL_REG_TEST_MODE               (0x004)
+#define BIT_RTC_CTRL_REG_TEST_MODE_M             (0x00000010)
+#define BIT_RTC_CTRL_REG_SET_32_COUNTER          (0x005)
+#define BIT_RTC_CTRL_REG_SET_32_COUNTER_M        (0x00000020)
+#define BIT_RTC_CTRL_REG_GET_TIME                (0x006)
+#define BIT_RTC_CTRL_REG_GET_TIME_M              (0x00000040)
+/* RTC_STATUS_REG Fields */
+#define BIT_RTC_STATUS_REG_RUN                   (0x001)
+#define BIT_RTC_STATUS_REG_RUN_M                 (0x00000002)
+#define BIT_RTC_STATUS_REG_1S_EVENT              (0x002)
+#define BIT_RTC_STATUS_REG_1S_EVENT_M            (0x00000004)
+#define BIT_RTC_STATUS_REG_1M_EVENT              (0x003)
+#define BIT_RTC_STATUS_REG_1M_EVENT_M            (0x00000008)
+#define BIT_RTC_STATUS_REG_1H_EVENT              (0x004)
+#define BIT_RTC_STATUS_REG_1H_EVENT_M            (0x00000010)
+#define BIT_RTC_STATUS_REG_1D_EVENT              (0x005)
+#define BIT_RTC_STATUS_REG_1D_EVENT_M            (0x00000020)
+#define BIT_RTC_STATUS_REG_ALARM                 (0x006)
+#define BIT_RTC_STATUS_REG_ALARM_M               (0x00000040)
+#define BIT_RTC_STATUS_REG_POWER_UP              (0x007)
+#define BIT_RTC_STATUS_REG_POWER_UP_M            (0x00000080)
+
+/* RTC_INTERRUPTS_REG Fields */
+#define BIT_RTC_INTERRUPTS_REG_EVERY             (0x000)
+#define BIT_RTC_INTERRUPTS_REG_EVERY_M           (0x00000003)
+#define BIT_RTC_INTERRUPTS_REG_IT_TIMER          (0x002)
+#define BIT_RTC_INTERRUPTS_REG_IT_TIMER_M        (0x00000004)
+#define BIT_RTC_INTERRUPTS_REG_IT_ALARM          (0x003)
+#define BIT_RTC_INTERRUPTS_REG_IT_ALARM_M        (0x00000008)
+/* RTC_COMP_LSB_REG Fields */
+#define BIT_RTC_COMP_LSB_REG_RTC_COMP_LSB        (0x000)
+#define BIT_RTC_COMP_LSB_REG_RTC_COMP_LSB_M      (0x000000FF)
+/* RTC_COMP_MSB_REG Fields */
+#define BIT_RTC_COMP_MSB_REG_RTC_COMP_MSB        (0x000)
+#define BIT_RTC_COMP_MSB_REG_RTC_COMP_MSB_M      (0x000000FF)
+
+struct twl4030rtc_platform_data {
+	int (*init)(void);
+	void (*exit)(void);
+};
+
+#endif				/* End of __TWL4030_RTC_H__ */
