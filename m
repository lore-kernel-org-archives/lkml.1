Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYLNLgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYLNLgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYLNLfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:33 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34173 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYLNLfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:30 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 1/7] mfd: PCF50633 core driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Date: Sun, 14 Dec 2008 16:32:10 +0530
Message-ID: <20081214110210.3307.38767.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the core of the PCF50633 driver. This core driver has
generic register read/write functions and does interrupt management for its
sub devices.

This patch is against linux-2.6.git

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/Kconfig                |    9 
 drivers/mfd/Makefile               |    4 
 drivers/mfd/pcf50633-core.c        |  681 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/adc.h   |   88 +++++
 include/linux/mfd/pcf50633/core.h  |  212 +++++++++++
 include/linux/mfd/pcf50633/gpio.h  |   52 +++
 include/linux/mfd/pcf50633/input.h |   29 ++
 include/linux/mfd/pcf50633/led.h   |   24 +
 include/linux/mfd/pcf50633/mbc.h   |  137 +++++++
 include/linux/mfd/pcf50633/pmic.h  |   75 ++++
 include/linux/mfd/pcf50633/rtc.h   |   43 ++
 11 files changed, 1353 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/pcf50633-core.c
 create mode 100644 include/linux/mfd/pcf50633/adc.h
 create mode 100644 include/linux/mfd/pcf50633/core.h
 create mode 100644 include/linux/mfd/pcf50633/gpio.h
 create mode 100644 include/linux/mfd/pcf50633/input.h
 create mode 100644 include/linux/mfd/pcf50633/led.h
 create mode 100644 include/linux/mfd/pcf50633/mbc.h
 create mode 100644 include/linux/mfd/pcf50633/pmic.h
 create mode 100644 include/linux/mfd/pcf50633/rtc.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8cd3dd9..fb1f0f7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -153,6 +153,15 @@ config MFD_WM8350_I2C
 	  I2C as the control interface.  Additional options must be
 	  selected to enable support for the functionality of the chip.
 
+config MFD_PCF50633
+	tristate "Support for NXP PCF50633"
+	depends on I2C
+	help
+	  Say yes here if you have NXP PCF50633 chip on your board.
+	  This core driver provides register access and IRQ handling
+	  facilities, and registers devices for the various functions
+	  so that function-specific drivers can bind to them.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9a5ad8a..6a4add8 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -31,4 +31,6 @@ obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-assabet.o
 endif
 obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
-obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
\ No newline at end of file
+obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
+
+obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
new file mode 100644
index 0000000..5274921
--- /dev/null
+++ b/drivers/mfd/pcf50633-core.c
@@ -0,0 +1,681 @@
+/* NXP PCF50633 Power Management Unit (PMU) driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * 	   Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/pcf50633/core.h>
+
+static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(pcf->i2c_client, reg,
+				num, data);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error reading %d regs at %d\n", num, reg);
+
+	return ret;
+}
+
+static int __pcf50633_write(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
+{
+	int ret;
+
+	ret = i2c_smbus_write_i2c_block_data(pcf->i2c_client, reg,
+				num, data);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error writing %d regs at %d\n", num, reg);
+
+	return ret;
+
+}
+
+/* Read a block of upto 32 regs  */
+int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
+					int nr_regs, u8 *data)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+
+	ret = __pcf50633_read(pcf, reg, nr_regs, data);
+
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_read_block);
+
+/* Write a block of upto 32 regs  */
+int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
+					int nr_regs, u8 *data)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+
+	ret = __pcf50633_write(pcf, reg, nr_regs, data);
+
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_write_block);
+
+u8 pcf50633_reg_read(struct pcf50633 *pcf, u8 reg)
+{
+	u8 val;
+
+	mutex_lock(&pcf->lock);
+
+	__pcf50633_read(pcf, reg, 1, &val);
+
+	mutex_unlock(&pcf->lock);
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_read);
+
+int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+
+	ret = __pcf50633_write(pcf, reg, 1, &val);
+
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_write);
+
+int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	val &= mask;
+
+	mutex_lock(&pcf->lock);
+
+	ret = __pcf50633_read(pcf, reg, 1, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp &= ~mask;
+	tmp |= val;
+	ret = __pcf50633_write(pcf, reg, 1, &tmp);
+
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_set_bit_mask);
+
+int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	mutex_lock(&pcf->lock);
+
+	ret = __pcf50633_read(pcf, reg, 1, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp &= ~val;
+	ret = __pcf50633_write(pcf, reg, 1, &tmp);
+
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_clear_bits);
+
+/* sysfs attributes */
+static ssize_t show_dump_regs(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct pcf50633 *pcf = dev_get_drvdata(dev);
+	u8 dump[16];
+	int n, n1, idx = 0;
+	char *buf1 = buf;
+	static u8 address_no_read[] = { /* must be ascending */
+		PCF50633_REG_INT1,
+		PCF50633_REG_INT2,
+		PCF50633_REG_INT3,
+		PCF50633_REG_INT4,
+		PCF50633_REG_INT5,
+		0 /* terminator */
+	};
+
+	for (n = 0; n < 256; n += sizeof(dump)) {
+		for (n1 = 0; n1 < sizeof(dump); n1++)
+			if (n == address_no_read[idx]) {
+				idx++;
+				dump[n1] = 0x00;
+			} else
+				dump[n1] = pcf50633_reg_read(pcf, n + n1);
+
+		hex_dump_to_buffer(dump, sizeof(dump), 16, 1, buf1, 128, 0);
+		buf1 += strlen(buf1);
+		*buf1++ = '\n';
+		*buf1 = '\0';
+	}
+
+	return buf1 - buf;
+}
+static DEVICE_ATTR(dump_regs, 0400, show_dump_regs, NULL);
+
+static ssize_t show_resume_reason(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pcf50633 *pcf = dev_get_drvdata(dev);
+	int n;
+
+	n = sprintf(buf, "%02x%02x%02x%02x%02x\n",
+				pcf->resume_reason[0],
+				pcf->resume_reason[1],
+				pcf->resume_reason[2],
+				pcf->resume_reason[3],
+				pcf->resume_reason[4]);
+
+	return n;
+}
+static DEVICE_ATTR(resume_reason, 0400, show_resume_reason, NULL);
+
+static struct attribute *pcf_sysfs_entries[] = {
+	&dev_attr_dump_regs.attr,
+	&dev_attr_resume_reason.attr,
+	NULL,
+};
+
+static struct attribute_group pcf_attr_group = {
+	.name	= NULL,			/* put in device directory */
+	.attrs	= pcf_sysfs_entries,
+};
+
+
+static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
+{
+	u8 reg, bits, tmp;
+	int ret = 0, idx;
+
+	idx = irq >> 3;
+	reg =  PCF50633_REG_INT1M + idx;
+	bits = 1 << (irq & 0x07);
+
+	mutex_lock(&pcf->lock);
+
+	if (mask) {
+		ret = __pcf50633_read(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		tmp |= bits;
+
+		ret = __pcf50633_write(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		pcf->mask_regs[idx] &= ~bits;
+		pcf->mask_regs[idx] |= bits;
+	} else {
+		ret = __pcf50633_read(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		tmp &= ~bits;
+
+		ret = __pcf50633_write(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		pcf->mask_regs[idx] &= ~bits;
+	}
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+
+int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
+{
+	dev_info(pcf->dev, "Masking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 1);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask);
+
+int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq)
+{
+	dev_info(pcf->dev, "Unmasking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 0);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_unmask);
+
+int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq)
+{
+	u8 reg, bits;
+
+	reg =  irq >> 3;
+	bits = 1 << (irq & 0x07);
+
+	return pcf->mask_regs[reg] & bits;
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask_get);
+
+static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
+{
+	if (pcf->irq_handler[irq].handler)
+		pcf->irq_handler[irq].handler(pcf, irq,
+					pcf->irq_handler[irq].data);
+}
+
+/* Maximum amount of time ONKEY is held before emergency action is taken */
+#define PCF50633_ONKEY1S_TIMEOUT 8
+
+static void pcf50633_irq_worker(struct work_struct *work)
+{
+	struct pcf50633 *pcf;
+	int ret, i, j;
+	u8 pcf_int[5], chgstat;
+
+	pcf = container_of(work, struct pcf50633, irq_work);
+
+	/* Read the 5 INT regs in one transaction */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
+						ARRAY_SIZE(pcf_int), pcf_int);
+	if (ret != ARRAY_SIZE(pcf_int)) {
+		dev_err(pcf->dev, "Error reading INT registers\n");
+
+		/*
+		 * If this doesn't ACK the interrupt to the chip, we'll be
+		 * called once again as we're level triggered.
+		 */
+		goto out;
+	}
+
+	/* We immediately read the usb and adapter status. We thus make sure
+	 * only of USBINS/USBREM IRQ handlers are called */
+	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~(1 << PCF50633_INT1_USBREM);
+		else
+			pcf_int[0] &= ~(1 << PCF50633_INT1_USBINS);
+	}
+
+	/* Make sure only one of ADPINS or ADPREM is set */
+	if (pcf_int[0] & (PCF50633_INT1_ADPINS | PCF50633_INT1_ADPREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPREM);
+		else
+			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPINS);
+	}
+
+	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
+			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
+			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
+
+	/* Some revisions of the chip don't have a 8s standby mode on
+	 * ONKEY1S press. We try to manually do it in such cases. */
+	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
+		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
+							pcf->onkey1s_held);
+		if (pcf->onkey1s_held++ == PCF50633_ONKEY1S_TIMEOUT)
+			if (pcf->pdata->force_shutdown)
+				pcf->pdata->force_shutdown(pcf);
+	}
+
+	if (pcf_int[2] & PCF50633_INT3_ONKEY1S) {
+		dev_info(pcf->dev, "ONKEY1S held\n");
+		pcf->onkey1s_held = 1 ;
+
+		/* Unmask IRQ_SECOND */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT1M,
+						PCF50633_INT1_SECOND);
+
+		/* Unmask IRQ_ONKEYR */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT2M,
+						PCF50633_INT2_ONKEYR);
+	}
+
+	if ((pcf_int[1] & PCF50633_INT2_ONKEYR) && pcf->onkey1s_held) {
+		pcf->onkey1s_held = 0;
+
+		/* Mask SECOND and ONKEYR interrupts */
+		if (pcf->mask_regs[0] & PCF50633_INT1_SECOND)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT1M,
+					PCF50633_INT1_SECOND,
+					PCF50633_INT1_SECOND);
+
+		if (pcf->mask_regs[1] & PCF50633_INT2_ONKEYR)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT2M,
+					PCF50633_INT2_ONKEYR,
+					PCF50633_INT2_ONKEYR);
+	}
+
+	/* Have we just resumed ? */
+	if (pcf->is_suspended) {
+		pcf->is_suspended = 0;
+
+		/* Set the resume reason filtering out non resumers */
+		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
+			pcf->resume_reason[i] = pcf_int[i] &
+						pcf->pdata->resumers[i];
+
+		/* Make sure we don't pass on any ONKEY events to
+		 * userspace now */
+		pcf_int[1] &= ~(PCF50633_INT2_ONKEYR | PCF50633_INT2_ONKEYF);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pcf_int); i++) {
+		/* Unset masked interrupts */
+		pcf_int[i] &= ~pcf->mask_regs[i];
+
+		for (j = 0; j < 8 ; j++)
+			if (pcf_int[i] & (1 << j))
+				pcf50633_irq_call_handler(pcf, (i * 8) + j);
+	}
+
+out:
+	put_device(pcf->dev);
+	enable_irq(pcf->irq);
+}
+
+static irqreturn_t pcf50633_irq(int irq, void *data)
+{
+	struct pcf50633 *pcf = data;
+
+	dev_dbg(pcf->dev, "pcf50633_irq\n");
+
+	get_device(pcf->dev);
+	disable_irq(pcf->irq);
+	schedule_work(&pcf->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static void
+pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
+						struct platform_device **pdev)
+{
+	int ret;
+
+	*pdev = platform_device_alloc(name, -1);
+
+	if (!pdev) {
+		dev_err(pcf->dev, "Falied to allocate %s\n", name);
+		return;
+	}
+
+	(*pdev)->dev.parent = pcf->dev;
+	platform_set_drvdata(*pdev, pcf);
+
+	ret = platform_device_add(*pdev);
+	if (ret) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n", name, ret);
+		platform_device_put(*pdev);
+		*pdev = NULL;
+	}
+}
+
+#ifdef CONFIG_PM
+static int pcf50633_suspend(struct device *dev, pm_message_t state)
+{
+	struct pcf50633 *pcf;
+	int ret = 0, i;
+	u8 res[5];
+
+	pcf = dev_get_drvdata(dev);
+
+	/* Make sure our interrupt handlers are not called
+	 * henceforth */
+	disable_irq(pcf->irq);
+
+	/* Make sure that any running IRQ worker has quit */
+	cancel_work_sync(&pcf->irq_work);
+
+	/* Save the masks */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error saving irq masks\n");
+		goto out;
+	}
+
+	/* Write wakeup irq masks */
+	for (i = 0; i < ARRAY_SIZE(res); i++)
+		res[i] = ~pcf->pdata->resumers[i];
+
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+					ARRAY_SIZE(res), &res[0]);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error writing wakeup irq masks\n");
+		goto out;
+	}
+
+	pcf->is_suspended = 1;
+
+out:
+	return ret;
+}
+
+static int pcf50633_resume(struct device *dev)
+{
+	struct pcf50633 *pcf;
+	int ret;
+
+	pcf = dev_get_drvdata(dev);
+
+	/* Write the saved mask registers */
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
+
+	get_device(pcf->dev);
+
+	/*
+	 * Clear any pending interrupts and set resume reason if any.
+	 * This will leave with enable_irq()
+	 */
+	pcf50633_irq_worker(&pcf->irq_work);
+
+	return 0;
+}
+#else
+#define pcf50633_suspend NULL
+#define pcf50633_resume NULL
+#endif
+
+static int pcf50633_probe(struct i2c_client *client,
+				const struct i2c_device_id *ids)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_platform_data *pdata;
+	int i, ret = 0;
+	int version, variant;
+	u8 mbcs1;
+
+	pdata = client->dev.platform_data;
+
+	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
+	if (!pcf)
+		return -ENOMEM;
+
+	pcf->pdata = pdata;
+	pdata->pcf = pcf;
+
+	mutex_init(&pcf->lock);
+
+	i2c_set_clientdata(client, pcf);
+	pcf->dev = &client->dev;
+	pcf->i2c_client = client;
+
+	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
+
+	version = pcf50633_reg_read(pcf, 0);
+	variant = pcf50633_reg_read(pcf, 1);
+	if (version < 0 || variant < 0) {
+		dev_err(pcf->dev, "Unable to probe pcf50633\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_info(pcf->dev, "Probed device version %d variant %d\n",
+							version, variant);
+
+	/* Enable all inteerupts except RTC SECOND */
+	pcf->mask_regs[0] = 0x80;
+	pcf50633_reg_write(pcf, PCF50633_REG_INT1M, pcf->mask_regs[0]);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT2M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT3M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
+
+	pcf50633_client_dev_register(pcf, "pcf50633-input",
+						&pcf->input.pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
+						&pcf->rtc.pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
+						&pcf->mbc.pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-adc",
+						&pcf->adc.pdev);
+
+	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("pcf50633-regltr", i);
+		if (!pdev) {
+			dev_err(pcf->dev, "Cannot create regulator\n");
+			continue;
+		}
+
+		pdev->dev.parent = pcf->dev;
+		pdev->dev.platform_data = &pdata->reg_init_data[i];
+		pdev->dev.driver_data = pcf;
+		pcf->pmic.pdev[i] = pdev;
+
+		platform_device_add(pdev);
+	}
+
+	pcf->irq = client->irq;
+
+	if (client->irq) {
+		set_irq_handler(client->irq, handle_level_irq);
+		ret = request_irq(client->irq, pcf50633_irq,
+				IRQF_TRIGGER_LOW, "pcf50633", pcf);
+
+		if (ret) {
+			dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+			goto err;
+		}
+	} else {
+		dev_err(pcf->dev, "No IRQ configured\n");
+		goto err;
+	}
+
+	if (enable_irq_wake(client->irq) < 0)
+		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
+			"in this hardware revision", client->irq);
+
+	mbcs1 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS1);
+
+	if (mbcs1 & PCF50633_MBCS1_USBPRES)
+		pcf50633_irq_call_handler(pcf, PCF50633_IRQ_USBINS);
+	if (mbcs1 & PCF50633_MBCS1_ADAPTPRES)
+		pcf50633_irq_call_handler(pcf, PCF50633_IRQ_ADPINS);
+
+	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
+	if (ret)
+		dev_err(pcf->dev, "error creating sysfs entries\n");
+
+	if (pdata->probe_done)
+		pdata->probe_done(pcf);
+
+	return 0;
+
+err:
+	kfree(pcf);
+	return ret;
+}
+
+static int pcf50633_remove(struct i2c_client *client)
+{
+	struct pcf50633 *pcf = i2c_get_clientdata(client);
+
+	free_irq(pcf->irq, pcf);
+	kfree(pcf);
+
+	return 0;
+}
+
+static struct i2c_device_id pcf50633_id_table[] = {
+	{"pcf50633", 0x73},
+};
+
+static struct i2c_driver pcf50633_driver = {
+	.driver = {
+		.name	= "pcf50633",
+		.suspend = pcf50633_suspend,
+		.resume	= pcf50633_resume,
+	},
+	.id_table = pcf50633_id_table,
+	.probe = pcf50633_probe,
+	.remove = pcf50633_remove,
+};
+
+static int __init pcf50633_init(void)
+{
+	return i2c_add_driver(&pcf50633_driver);
+}
+
+static void pcf50633_exit(void)
+{
+	i2c_del_driver(&pcf50633_driver);
+}
+
+MODULE_DESCRIPTION("I2C chip driver for NXP PCF50633 PMU");
+MODULE_AUTHOR("Harald Welte <laforge@openmoko.org>");
+MODULE_LICENSE("GPL");
+
+module_init(pcf50633_init);
+module_exit(pcf50633_exit);
diff --git a/include/linux/mfd/pcf50633/adc.h b/include/linux/mfd/pcf50633/adc.h
new file mode 100644
index 0000000..13862bf
--- /dev/null
+++ b/include/linux/mfd/pcf50633/adc.h
@@ -0,0 +1,88 @@
+/*
+ * adc.h  -- Driver for NXP PCF50633 ADC
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_ADC_H
+#define __LINUX_MFD_PCF50633_ADC_H
+
+#include <linux/platform_device.h>
+
+/* ADC Registers */
+#define PCF50633_REG_ADCC3		0x52
+#define PCF50633_REG_ADCC2		0x53
+#define PCF50633_REG_ADCC1		0x54
+#define PCF50633_REG_ADCS1		0x55
+#define PCF50633_REG_ADCS2		0x56
+#define PCF50633_REG_ADCS3		0x57
+
+#define PCF50633_ADCC1_ADCSTART		0x01
+#define PCF50633_ADCC1_RES_10BIT	0x02
+#define PCF50633_ADCC1_AVERAGE_NO	0x00
+#define PCF50633_ADCC1_AVERAGE_4	0x04
+#define PCF50633_ADCC1_AVERAGE_8	0x08
+#define PCF50633_ADCC1_AVERAGE_16	0x0c
+#define PCF50633_ADCC1_MUX_BATSNS_RES	0x00
+#define PCF50633_ADCC1_MUX_BATSNS_SUBTR	0x10
+#define PCF50633_ADCC1_MUX_ADCIN2_RES	0x20
+#define PCF50633_ADCC1_MUX_ADCIN2_SUBTR	0x30
+#define PCF50633_ADCC1_MUX_BATTEMP	0x60
+#define PCF50633_ADCC1_MUX_ADCIN1	0x70
+#define PCF50633_ADCC1_AVERAGE_MASK	0x0c
+#define PCF50633_ADCC1_ADCMUX_MASK	0xf0
+
+#define PCF50633_ADCC2_RATIO_NONE	0x00
+#define PCF50633_ADCC2_RATIO_BATTEMP	0x01
+#define PCF50633_ADCC2_RATIO_ADCIN1	0x02
+#define PCF50633_ADCC2_RATIO_BOTH	0x03
+#define PCF50633_ADCC2_RATIOSETTL_100US 0x04
+
+#define PCF50633_ADCC3_ACCSW_EN		0x01
+#define PCF50633_ADCC3_NTCSW_EN		0x04
+#define PCF50633_ADCC3_RES_DIV_TWO	0x10
+#define PCF50633_ADCC3_RES_DIV_THREE	0x00
+
+#define PCF50633_ADCS3_REF_NTCSW	0x00
+#define PCF50633_ADCS3_REF_ACCSW	0x10
+#define PCF50633_ADCS3_REF_2V0		0x20
+#define PCF50633_ADCS3_REF_VISA		0x30
+#define PCF50633_ADCS3_REF_2V0_2	0x70
+#define PCF50633_ADCS3_ADCRDY		0x80
+
+#define PCF50633_ADCS3_ADCDAT1L_MASK	0x03
+#define PCF50633_ADCS3_ADCDAT2L_MASK	0x0c
+#define PCF50633_ADCS3_ADCDAT2L_SHIFT	2
+#define PCF50633_ASCS3_REF_MASK		0x70
+
+
+struct pcf50633;
+
+#define PCF50633_MAX_ADC_FIFO_DEPTH 8
+
+struct pcf50633_adc_request;
+
+struct pcf50633_adc {
+	struct platform_device *pdev;
+
+	/* Private stuff */
+	struct pcf50633_adc_request *queue[PCF50633_MAX_ADC_FIFO_DEPTH];
+	int queue_head;
+	int queue_tail;
+	struct mutex queue_mutex;
+};
+
+extern int
+pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
+		void (*callback)(struct pcf50633 *, void *, int),
+		void *callback_param);
+extern int
+pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg);
+
+#endif /* __LINUX_PCF50633_ADC_H */
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
new file mode 100644
index 0000000..b69ff9c
--- /dev/null
+++ b/include/linux/mfd/pcf50633/core.h
@@ -0,0 +1,212 @@
+/*
+ * core.h  -- Core driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_CORE_H
+#define __LINUX_MFD_PCF50633_CORE_H
+
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/power_supply.h>
+
+#include <linux/mfd/pcf50633/pmic.h>
+#include <linux/mfd/pcf50633/input.h>
+#include <linux/mfd/pcf50633/mbc.h>
+#include <linux/mfd/pcf50633/rtc.h>
+#include <linux/mfd/pcf50633/adc.h>
+#include <linux/mfd/pcf50633/gpio.h>
+
+struct pcf50633;
+
+struct pcf50633_platform_data {
+	struct regulator_init_data reg_init_data[PCF50633_NUM_REGULATORS];
+
+	char **batteries;
+	int num_batteries;
+
+	/* Callbacks */
+	void (*probe_done)(struct pcf50633 *);
+	void (*mbc_event_callback)(struct pcf50633 *, int);
+	void (*regulator_registered)(struct pcf50633 *, int);
+	void (*force_shutdown)(struct pcf50633 *);
+
+	u8 resumers[5];
+
+	/* Runtime data - filled by driver afer probe */
+	struct pcf50633 *pcf;
+};
+
+struct pcf50633_irq {
+	void (*handler)(struct pcf50633 *, int, void *);
+	void *data;
+};
+
+int pcf50633_irq_mask(struct pcf50633 *pcf, int irq);
+int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq);
+int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq);
+
+int pcf50633_read_block(struct pcf50633 *, u8 reg,
+					int nr_regs, u8 *data);
+int pcf50633_write_block(struct pcf50633 *pcf, u8 reg,
+					int nr_regs, u8 *data);
+u8 pcf50633_reg_read(struct pcf50633 *, u8 reg);
+int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val);
+
+int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val);
+int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 bits);
+
+/* Interrupt registers */
+
+#define PCF50633_REG_INT1	0x02
+#define PCF50633_REG_INT2	0x03
+#define PCF50633_REG_INT3	0x04
+#define PCF50633_REG_INT4	0x05
+#define PCF50633_REG_INT5	0x06
+
+#define PCF50633_REG_INT1M	0x07
+#define PCF50633_REG_INT2M	0x08
+#define PCF50633_REG_INT3M	0x09
+#define PCF50633_REG_INT4M	0x0a
+#define PCF50633_REG_INT5M	0x0b
+
+enum {
+	/* Chip IRQs */
+	PCF50633_IRQ_ADPINS,
+	PCF50633_IRQ_ADPREM,
+	PCF50633_IRQ_USBINS,
+	PCF50633_IRQ_USBREM,
+	PCF50633_IRQ_RESERVED1,
+	PCF50633_IRQ_RESERVED2,
+	PCF50633_IRQ_ALARM,
+	PCF50633_IRQ_SECOND,
+	PCF50633_IRQ_ONKEYR,
+	PCF50633_IRQ_ONKEYF,
+	PCF50633_IRQ_EXTON1R,
+	PCF50633_IRQ_EXTON1F,
+	PCF50633_IRQ_EXTON2R,
+	PCF50633_IRQ_EXTON2F,
+	PCF50633_IRQ_EXTON3R,
+	PCF50633_IRQ_EXTON3F,
+	PCF50633_IRQ_BATFULL,
+	PCF50633_IRQ_CHGHALT,
+	PCF50633_IRQ_THLIMON,
+	PCF50633_IRQ_THLIMOFF,
+	PCF50633_IRQ_USBLIMON,
+	PCF50633_IRQ_USBLIMOFF,
+	PCF50633_IRQ_ADCRDY,
+	PCF50633_IRQ_ONKEY1S,
+	PCF50633_IRQ_LOWSYS,
+	PCF50633_IRQ_LOWBAT,
+	PCF50633_IRQ_HIGHTMP,
+	PCF50633_IRQ_AUTOPWRFAIL,
+	PCF50633_IRQ_DWN1PWRFAIL,
+	PCF50633_IRQ_DWN2PWRFAIL,
+	PCF50633_IRQ_LEDPWRFAIL,
+	PCF50633_IRQ_LEDOVP,
+	PCF50633_IRQ_LDO1PWRFAIL,
+	PCF50633_IRQ_LDO2PWRFAIL,
+	PCF50633_IRQ_LDO3PWRFAIL,
+	PCF50633_IRQ_LDO4PWRFAIL,
+	PCF50633_IRQ_LDO5PWRFAIL,
+	PCF50633_IRQ_LDO6PWRFAIL,
+	PCF50633_IRQ_HCLDOPWRFAIL,
+	PCF50633_IRQ_HCLDOOVL,
+
+	/* Always last */
+	PCF50633_NUM_IRQ,
+};
+
+struct pcf50633 {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+
+	struct pcf50633_platform_data *pdata;
+	int irq;
+	struct pcf50633_irq irq_handler[PCF50633_NUM_IRQ];
+	struct work_struct irq_work;
+	struct mutex lock;
+
+	u8 mask_regs[5];
+
+	u8 suspend_irq_masks[5];
+	u8 resume_reason[5];
+	int is_suspended;
+
+	int onkey1s_held;
+
+	struct pcf50633_pmic pmic;
+	struct pcf50633_input input;
+	struct pcf50633_mbc mbc;
+	struct pcf50633_rtc rtc;
+	struct pcf50633_adc adc;
+};
+
+enum pcf50633_reg_int1 {
+	PCF50633_INT1_ADPINS	= 0x01,	/* Adapter inserted */
+	PCF50633_INT1_ADPREM	= 0x02,	/* Adapter removed */
+	PCF50633_INT1_USBINS	= 0x04,	/* USB inserted */
+	PCF50633_INT1_USBREM	= 0x08,	/* USB removed */
+	/* reserved */
+	PCF50633_INT1_ALARM	= 0x40, /* RTC alarm time is reached */
+	PCF50633_INT1_SECOND	= 0x80,	/* RTC periodic second interrupt */
+};
+
+enum pcf50633_reg_int2 {
+	PCF50633_INT2_ONKEYR	= 0x01, /* ONKEY rising edge */
+	PCF50633_INT2_ONKEYF	= 0x02, /* ONKEY falling edge */
+	PCF50633_INT2_EXTON1R	= 0x04, /* EXTON1 rising edge */
+	PCF50633_INT2_EXTON1F	= 0x08, /* EXTON1 falling edge */
+	PCF50633_INT2_EXTON2R	= 0x10, /* EXTON2 rising edge */
+	PCF50633_INT2_EXTON2F	= 0x20, /* EXTON2 falling edge */
+	PCF50633_INT2_EXTON3R	= 0x40, /* EXTON3 rising edge */
+	PCF50633_INT2_EXTON3F	= 0x80, /* EXTON3 falling edge */
+};
+
+enum pcf50633_reg_int3 {
+	PCF50633_INT3_BATFULL	= 0x01, /* Battery full */
+	PCF50633_INT3_CHGHALT	= 0x02,	/* Charger halt */
+	PCF50633_INT3_THLIMON	= 0x04,
+	PCF50633_INT3_THLIMOFF	= 0x08,
+	PCF50633_INT3_USBLIMON	= 0x10,
+	PCF50633_INT3_USBLIMOFF	= 0x20,
+	PCF50633_INT3_ADCRDY	= 0x40, /* ADC result ready */
+	PCF50633_INT3_ONKEY1S	= 0x80,	/* ONKEY pressed 1 second */
+};
+
+enum pcf50633_reg_int4 {
+	PCF50633_INT4_LOWSYS		= 0x01,
+	PCF50633_INT4_LOWBAT		= 0x02,
+	PCF50633_INT4_HIGHTMP		= 0x04,
+	PCF50633_INT4_AUTOPWRFAIL	= 0x08,
+	PCF50633_INT4_DWN1PWRFAIL	= 0x10,
+	PCF50633_INT4_DWN2PWRFAIL	= 0x20,
+	PCF50633_INT4_LEDPWRFAIL	= 0x40,
+	PCF50633_INT4_LEDOVP		= 0x80,
+};
+
+enum pcf50633_reg_int5 {
+	PCF50633_INT5_LDO1PWRFAIL	= 0x01,
+	PCF50633_INT5_LDO2PWRFAIL	= 0x02,
+	PCF50633_INT5_LDO3PWRFAIL	= 0x04,
+	PCF50633_INT5_LDO4PWRFAIL	= 0x08,
+	PCF50633_INT5_LDO5PWRFAIL	= 0x10,
+	PCF50633_INT5_LDO6PWRFAIL	= 0x20,
+	PCF50633_INT5_HCLDOPWRFAIL	= 0x40,
+	PCF50633_INT5_HCLDOOVL		= 0x80,
+};
+
+/* misc. registers */
+#define PCF50633_REG_OOCSHDWN	0x0c
+
+#endif
+
diff --git a/include/linux/mfd/pcf50633/gpio.h b/include/linux/mfd/pcf50633/gpio.h
new file mode 100644
index 0000000..33bf7c7
--- /dev/null
+++ b/include/linux/mfd/pcf50633/gpio.h
@@ -0,0 +1,52 @@
+/*
+ * gpio.h -- GPIO driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_GPIO_H
+#define __LINUX_MFD_PCF50633_GPIO_H
+
+#define PCF50633_GPIO1		1
+#define PCF50633_GPIO2		2
+#define PCF50633_GPIO3		3
+#define PCF50633_GPO		4
+
+#define PCF50633_REG_GPIO1CFG	0x14
+#define PCF50633_REG_GPIO2CFG	0x15
+#define PCF50633_REG_GPIO3CFG	0x16
+#define PCF50633_REG_GPOCFG 	0x17
+
+#define PCF50633_GPOCFG_GPOSEL_MASK	0x07
+
+enum pcf50633_reg_gpocfg {
+	PCF50633_GPOCFG_GPOSEL_0	= 0x00,
+	PCF50633_GPOCFG_GPOSEL_LED_NFET	= 0x01,
+	PCF50633_GPOCFG_GPOSEL_SYSxOK	= 0x02,
+	PCF50633_GPOCFG_GPOSEL_CLK32K	= 0x03,
+	PCF50633_GPOCFG_GPOSEL_ADAPUSB	= 0x04,
+	PCF50633_GPOCFG_GPOSEL_USBxOK	= 0x05,
+	PCF50633_GPOCFG_GPOSEL_ACTPH4	= 0x06,
+	PCF50633_GPOCFG_GPOSEL_1	= 0x07,
+	PCF50633_GPOCFG_GPOSEL_INVERSE	= 0x08,
+};
+
+struct pcf50633;
+
+int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val);
+u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio);
+
+int pcf50633_gpio_invert_set(struct pcf50633 *, int gpio, int invert);
+int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio);
+
+int pcf50633_gpio_power_supply_set(struct pcf50633 *,
+					int gpio, int regulator, int on);
+#endif /* __LINUX_MFD_PCF50633_GPIO_H */
+
+
diff --git a/include/linux/mfd/pcf50633/input.h b/include/linux/mfd/pcf50633/input.h
new file mode 100644
index 0000000..fd10302
--- /dev/null
+++ b/include/linux/mfd/pcf50633/input.h
@@ -0,0 +1,29 @@
+/*
+ * input.h  -- Input driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_INPUT_H
+#define __LINUX_MFD_PCF50633_INPUT_H
+
+#include <linux/platform_device.h>
+#include <linux/input.h>
+
+#define PCF50633_OOCSTAT_ONKEY	0x01
+#define PCF50633_REG_OOCSTAT	0x12
+#define PCF50633_REG_OOCMODE	0x10
+
+struct pcf50633_input {
+	struct input_dev *input_dev;
+	struct platform_device *pdev;
+};
+
+#endif
+
diff --git a/include/linux/mfd/pcf50633/led.h b/include/linux/mfd/pcf50633/led.h
new file mode 100644
index 0000000..c84a97e
--- /dev/null
+++ b/include/linux/mfd/pcf50633/led.h
@@ -0,0 +1,24 @@
+/*
+ * led.h  -- LED driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_LED_H
+#define __LINUX_MFD_PCF50633_LED_H
+
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_LEDOUT 0x28
+#define PCF50633_REG_LEDENA 0x29
+#define PCF50633_REG_LEDCTL 0x2a
+#define PCF50633_REG_LEDDIM 0x2b
+
+#endif
+
diff --git a/include/linux/mfd/pcf50633/mbc.h b/include/linux/mfd/pcf50633/mbc.h
new file mode 100644
index 0000000..7843934
--- /dev/null
+++ b/include/linux/mfd/pcf50633/mbc.h
@@ -0,0 +1,137 @@
+/*
+ * mbc.h  -- Driver for NXP PCF50633 Main Battery Charger
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_MBC_H
+#define __LINUX_MFD_PCF50633_MBC_H
+
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_MBCC1	0x43
+#define PCF50633_REG_MBCC2	0x44
+#define PCF50633_REG_MBCC3	0x45
+#define PCF50633_REG_MBCC4	0x46
+#define PCF50633_REG_MBCC5	0x47
+#define PCF50633_REG_MBCC6	0x48
+#define PCF50633_REG_MBCC7	0x49
+#define PCF50633_REG_MBCC8	0x4a
+#define PCF50633_REG_MBCS1	0x4b
+#define PCF50633_REG_MBCS2	0x4c
+#define PCF50633_REG_MBCS3	0x4d
+
+enum pcf50633_reg_mbcc1 {
+	PCF50633_MBCC1_CHGENA		= 0x01,	/* Charger enable */
+	PCF50633_MBCC1_AUTOSTOP		= 0x02,
+	PCF50633_MBCC1_AUTORES		= 0x04, /* automatic resume */
+	PCF50633_MBCC1_RESUME		= 0x08, /* explicit resume cmd */
+	PCF50633_MBCC1_RESTART		= 0x10, /* restart charging */
+	PCF50633_MBCC1_PREWDTIME_60M	= 0x20,	/* max. precharging time */
+	PCF50633_MBCC1_WDTIME_1H	= 0x00,
+	PCF50633_MBCC1_WDTIME_2H	= 0x40,
+	PCF50633_MBCC1_WDTIME_4H	= 0x80,
+	PCF50633_MBCC1_WDTIME_6H	= 0xc0,
+};
+#define PCF50633_MBCC1_WDTIME_MASK	  0xc0
+
+enum pcf50633_reg_mbcc2 {
+	PCF50633_MBCC2_VBATCOND_2V7	= 0x00,
+	PCF50633_MBCC2_VBATCOND_2V85	= 0x01,
+	PCF50633_MBCC2_VBATCOND_3V0	= 0x02,
+	PCF50633_MBCC2_VBATCOND_3V15	= 0x03,
+	PCF50633_MBCC2_VMAX_4V		= 0x00,
+	PCF50633_MBCC2_VMAX_4V20	= 0x28,
+	PCF50633_MBCC2_VRESDEBTIME_64S	= 0x80,	/* debounce time (32/64sec) */
+};
+
+enum pcf50633_reg_mbcc7 {
+	PCF50633_MBCC7_USB_100mA	= 0x00,
+	PCF50633_MBCC7_USB_500mA	= 0x01,
+	PCF50633_MBCC7_USB_1000mA	= 0x02,
+	PCF50633_MBCC7_USB_SUSPEND	= 0x03,
+	PCF50633_MBCC7_BATTEMP_EN	= 0x04,
+	PCF50633_MBCC7_BATSYSIMAX_1A6	= 0x00,
+	PCF50633_MBCC7_BATSYSIMAX_1A8	= 0x40,
+	PCF50633_MBCC7_BATSYSIMAX_2A0	= 0x80,
+	PCF50633_MBCC7_BATSYSIMAX_2A2	= 0xc0,
+};
+#define PCF50633_MBCC7_USB_MASK 0x03
+
+enum pcf50633_reg_mbcc8 {
+	PCF50633_MBCC8_USBENASUS	= 0x10,
+};
+
+enum pcf50633_reg_mbcs1 {
+	PCF50633_MBCS1_USBPRES		= 0x01,
+	PCF50633_MBCS1_USBOK		= 0x02,
+	PCF50633_MBCS1_ADAPTPRES	= 0x04,
+	PCF50633_MBCS1_ADAPTOK		= 0x08,
+	PCF50633_MBCS1_TBAT_OK		= 0x00,
+	PCF50633_MBCS1_TBAT_ABOVE	= 0x10,
+	PCF50633_MBCS1_TBAT_BELOW	= 0x20,
+	PCF50633_MBCS1_TBAT_UNDEF	= 0x30,
+	PCF50633_MBCS1_PREWDTEXP	= 0x40,
+	PCF50633_MBCS1_WDTEXP		= 0x80,
+};
+
+enum pcf50633_reg_mbcs2_mbcmod {
+	PCF50633_MBCS2_MBC_PLAY		= 0x00,
+	PCF50633_MBCS2_MBC_USB_PRE	= 0x01,
+	PCF50633_MBCS2_MBC_USB_PRE_WAIT	= 0x02,
+	PCF50633_MBCS2_MBC_USB_FAST	= 0x03,
+	PCF50633_MBCS2_MBC_USB_FAST_WAIT = 0x04,
+	PCF50633_MBCS2_MBC_USB_SUSPEND	= 0x05,
+	PCF50633_MBCS2_MBC_ADP_PRE	= 0x06,
+	PCF50633_MBCS2_MBC_ADP_PRE_WAIT	= 0x07,
+	PCF50633_MBCS2_MBC_ADP_FAST	= 0x08,
+	PCF50633_MBCS2_MBC_ADP_FAST_WAIT = 0x09,
+	PCF50633_MBCS2_MBC_BAT_FULL	= 0x0a,
+	PCF50633_MBCS2_MBC_HALT		= 0x0b,
+};
+#define PCF50633_MBCS2_MBC_MASK		0x0f
+enum pcf50633_reg_mbcs2_chgstat {
+	PCF50633_MBCS2_CHGS_NONE	= 0x00,
+	PCF50633_MBCS2_CHGS_ADAPTER	= 0x10,
+	PCF50633_MBCS2_CHGS_USB		= 0x20,
+	PCF50633_MBCS2_CHGS_BOTH	= 0x30,
+};
+#define PCF50633_MBCS2_RESSTAT_AUTO	0x40
+
+enum pcf50633_reg_mbcs3 {
+	PCF50633_MBCS3_USBLIM_PLAY	= 0x01,
+	PCF50633_MBCS3_USBLIM_CGH	= 0x02,
+	PCF50633_MBCS3_TLIM_PLAY	= 0x04,
+	PCF50633_MBCS3_TLIM_CHG		= 0x08,
+	PCF50633_MBCS3_ILIM		= 0x10,	/* 1: Ibat > Icutoff */
+	PCF50633_MBCS3_VLIM		= 0x20,	/* 1: Vbat == Vmax */
+	PCF50633_MBCS3_VBATSTAT		= 0x40,	/* 1: Vbat > Vbatcond */
+	PCF50633_MBCS3_VRES		= 0x80, /* 1: Vbat > Vth(RES) */
+};
+
+#define PCF50633_MBCC2_VBATCOND_MASK	  0x03
+#define PCF50633_MBCC2_VMAX_MASK	  0x3c
+
+struct pcf50633;
+
+void pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma);
+
+struct pcf50633_mbc {
+	int adapter_active;
+	int adapter_online;
+	int usb_active;
+	int usb_online;
+
+	struct power_supply usb;
+	struct power_supply adapter;
+
+	struct platform_device *pdev;
+};
+#endif
+
diff --git a/include/linux/mfd/pcf50633/pmic.h b/include/linux/mfd/pcf50633/pmic.h
new file mode 100644
index 0000000..395da7c
--- /dev/null
+++ b/include/linux/mfd/pcf50633/pmic.h
@@ -0,0 +1,75 @@
+#ifndef __LINUX_MFD_PCF50633_PMIC_H
+#define __LINUX_MFD_PCF50633_PMIC_H
+
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_AUTOOUT	0x1a
+#define PCF50633_REG_AUTOENA	0x1b
+#define PCF50633_REG_AUTOCTL	0x1c
+#define PCF50633_REG_AUTOMXC	0x1d
+#define PCF50633_REG_DOWN1OUT	0x1e
+#define PCF50633_REG_DOWN1ENA	0x1f
+#define PCF50633_REG_DOWN1CTL	0x20
+#define PCF50633_REG_DOWN1MXC	0x21
+#define PCF50633_REG_DOWN2OUT	0x22
+#define PCF50633_REG_DOWN2ENA	0x23
+#define PCF50633_REG_DOWN2CTL	0x24
+#define PCF50633_REG_DOWN2MXC	0x25
+#define PCF50633_REG_MEMLDOOUT	0x26
+#define PCF50633_REG_MEMLDOENA	0x27
+#define PCF50633_REG_LDO1OUT	0x2d
+#define PCF50633_REG_LDO1ENA	0x2e
+#define PCF50633_REG_LDO2OUT	0x2f
+#define PCF50633_REG_LDO2ENA	0x30
+#define PCF50633_REG_LDO3OUT	0x31
+#define PCF50633_REG_LDO3ENA	0x32
+#define PCF50633_REG_LDO4OUT	0x33
+#define PCF50633_REG_LDO4ENA	0x34
+#define PCF50633_REG_LDO5OUT	0x35
+#define PCF50633_REG_LDO5ENA	0x36
+#define PCF50633_REG_LDO6OUT	0x37
+#define PCF50633_REG_LDO6ENA	0x38
+#define PCF50633_REG_HCLDOOUT	0x39
+#define PCF50633_REG_HCLDOENA	0x3a
+#define PCF50633_REG_HCLDOOVL	0x40
+
+enum pcf50633_regulator_enable {
+	PCF50633_REGULATOR_ON		= 0x01,
+	PCF50633_REGULATOR_ON_GPIO1	= 0x02,
+	PCF50633_REGULATOR_ON_GPIO2	= 0x04,
+	PCF50633_REGULATOR_ON_GPIO3	= 0x08,
+};
+#define PCF50633_REGULATOR_ON_MASK	0x0f
+
+enum pcf50633_regulator_phase {
+	PCF50633_REGULATOR_ACTPH1	= 0x00,
+	PCF50633_REGULATOR_ACTPH2	= 0x10,
+	PCF50633_REGULATOR_ACTPH3	= 0x20,
+	PCF50633_REGULATOR_ACTPH4	= 0x30,
+};
+#define PCF50633_REGULATOR_ACTPH_MASK	0x30
+
+
+enum pcf50633_regulator_id {
+	PCF50633_REGULATOR_AUTO,
+	PCF50633_REGULATOR_DOWN1,
+	PCF50633_REGULATOR_DOWN2,
+	PCF50633_REGULATOR_LDO1,
+	PCF50633_REGULATOR_LDO2,
+	PCF50633_REGULATOR_LDO3,
+	PCF50633_REGULATOR_LDO4,
+	PCF50633_REGULATOR_LDO5,
+	PCF50633_REGULATOR_LDO6,
+	PCF50633_REGULATOR_HCLDO,
+	PCF50633_REGULATOR_MEMLDO,
+
+	PCF50633_NUM_REGULATORS
+};
+
+extern const u8 pcf50633_regulator_registers[];
+
+struct pcf50633_pmic {
+	struct platform_device *pdev[PCF50633_NUM_REGULATORS];
+};
+#endif
+
diff --git a/include/linux/mfd/pcf50633/rtc.h b/include/linux/mfd/pcf50633/rtc.h
new file mode 100644
index 0000000..ce8ad8f
--- /dev/null
+++ b/include/linux/mfd/pcf50633/rtc.h
@@ -0,0 +1,43 @@
+/*
+ * rtc.h  -- RTC driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_RTC_H
+#define __LINUX_MFD_PCF50633_RTC_H
+
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_RTCSC	0x59 /* Second */
+#define PCF50633_REG_RTCMN	0x5a /* Minute */
+#define PCF50633_REG_RTCHR	0x5b /* Hour */
+#define PCF50633_REG_RTCWD	0x5c /* Weekday */
+#define PCF50633_REG_RTCDT	0x5d /* Day */
+#define PCF50633_REG_RTCMT	0x5e /* Month */
+#define PCF50633_REG_RTCYR	0x5f /* Year */
+#define PCF50633_REG_RTCSCA	0x60 /* Alarm Second */
+#define PCF50633_REG_RTCMNA	0x61 /* Alarm Minute */
+#define PCF50633_REG_RTCHRA	0x62 /* Alarm Hour */
+#define PCF50633_REG_RTCWDA	0x63 /* Alarm Weekday */
+#define PCF50633_REG_RTCDTA	0x64 /* Alarm Day */
+#define PCF50633_REG_RTCMTA	0x65 /* Alarm Month */
+#define PCF50633_REG_RTCYRA	0x66 /* Alarm Year */
+
+struct pcf50633_rtc {
+	int alarm_enabled;
+	int second_enabled;
+
+	struct rtc_device *rtc_dev;
+	struct platform_device *pdev;
+};
+
+#endif
+

