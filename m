Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYKVRNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYKVRNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbYKVRM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:12:56 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57461 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbYKVRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=M0MfnwJrKRhdZMYW2fY3Ra6ASdzZKjDkDq+5CKGFFCEk7Ry3cgmo0tBVVjBsCVeBIA
         Hgtf29KqNnATyHRz9Vvd1KoqJIrztRkE2r1Owow3Y9iPPb4NQjv4TF7ya3SmUNtRlLJo
         q5mQevn3xXxBlhc0ZDADNB/zm2eLbo8Jz1/D4=
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, stefan@datenfreihafen.org,
       eric.y.miao@gmail.com, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <200811212125.49068.david-b@pacbell.net>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121160521.016544616@dodger.lab.datenfreihafen.org>
	 <200811212125.49068.david-b@pacbell.net>
Content-Type: multipart/mixed; boundary="=-cmLyTE6YB33sHlsNSrlY"
Date: Sat, 22 Nov 2008 15:12:28 -0200
Message-Id: <1227373948.19591.66.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cmLyTE6YB33sHlsNSrlY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Em Sex, 2008-11-21 às 21:25 -0800, David Brownell escreveu:
> I took a quick glance at this and it seemed like it should be
> able to build without depending on PXA ... should certainly
> not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
> look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
> either.
> 
> It's also worth removing the reverse dependencies ("select X")
> from Kconfig; they don't work very well for the things which
> those dependencies rely on.

Above comments are integrated on the attached patch.

-- 
Daniel Ribeiro

--=-cmLyTE6YB33sHlsNSrlY
Content-Disposition: attachment; filename=pcap.diff
Content-Type: message/rfc822; name=pcap.diff

From: Daniel Ribeiro <drwyrm@gmail.com>
Subject: mfd: PCAP driver
To: sameo@openedhand.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, eric.y.miao@gmail.com, linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Date: Sat, 22 Nov 2008 15:11:49 -0200
Message-Id: <1227373909.19591.65.camel@brutus>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

The PCAP Asic as present on EZX phones is a multi function device with
voltage regulators, irq expander, touch screen controller and audio
codec. It is connected to the processor via SPI, this driver provides
read/write functions to its registers.

Since the last submission we are also using the spi subsystem and
pxa2xx-spi instead of ssp.c directly as before.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 arch/arm/mach-pxa/Kconfig    |    1 +
 drivers/mfd/Kconfig          |    7 +
 drivers/mfd/Makefile         |    2 +
 drivers/mfd/ezx-pcap.c       |  591 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ezx-pcap.h |  290 +++++++++++++++++++++
 5 files changed, 891 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index a062235..d64c15a 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -351,6 +351,7 @@ config PXA_EZX
 	select PXA27x
 	select IWMMXT
 	select HAVE_PWM
+	select EZX_PCAP
 
 config MACH_EZX_A780
 	bool "Motorola EZX A780"
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2572773..79566c2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -153,6 +153,13 @@ config MFD_WM8350_I2C
 	  I2C as the control interface.  Additional options must be
 	  selected to enable support for the functionality of the chip.
 
+config EZX_PCAP
+	bool "PCAP Support"
+	depends on PXA_EZX
+	help
+	  This enables the PCAP ASIC present on EZX Phones. This is
+	  needed for MMC, TouchScreen, Sound, USB, etc..
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9a5ad8a..cbf32e0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -21,6 +21,8 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
+
 obj-$(CONFIG_MCP)		+= mcp-core.o
 obj-$(CONFIG_MCP_SA11X0)	+= mcp-sa11x0.o
 obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-core.o
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
new file mode 100644
index 0000000..939f2ac
--- /dev/null
+++ b/drivers/mfd/ezx-pcap.c
@@ -0,0 +1,591 @@
+/*
+ * Driver for Motorola PCAP2 as present in EZX phones
+ *
+ * Copyright (C) 2006 Harald Welte <laforge@openezx.org>
+ * Copyright (C) 2007-2008 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/mfd/ezx-pcap.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+
+struct pcap_chip {
+	struct spi_device *spi;
+	struct work_struct work;
+	struct workqueue_struct *workqueue;
+	void (*adc_done)(void *);
+	void *adc_data;
+};
+static struct pcap_chip pcap;
+
+static LIST_HEAD(event_list);
+static DEFINE_MUTEX(event_lock);
+static DEFINE_MUTEX(adc_lock);
+
+/* IO */
+static int ezx_pcap_putget(u32 *data)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+
+	memset(&t, 0, sizeof t);
+	spi_message_init(&m);
+	t.len = 4;
+	t.tx_buf = (u8 *)data;
+	t.rx_buf = (u8 *)data;
+	t.bits_per_word = 32;
+	spi_message_add_tail(&t, &m);
+	return spi_sync(pcap.spi, &m);
+}
+
+int ezx_pcap_write(u8 reg_num, u32 value)
+{
+	value &= PCAP_REGISTER_VALUE_MASK;
+	value |= PCAP_REGISTER_WRITE_OP_BIT
+		| (reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
+	return ezx_pcap_putget(&value);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_write);
+
+int ezx_pcap_read(u8 reg_num, u32 *value)
+{
+	*value = PCAP_REGISTER_READ_OP_BIT
+		| (reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
+
+	return ezx_pcap_putget(value);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_read);
+
+/* Voltage regulators */
+int ezx_pcap_set_sw(u8 sw, u8 what, u8 val)
+{
+	u32 tmp;
+
+	ezx_pcap_read(PCAP_REG_LOWPWR, &tmp);
+	tmp &= ~(0xf << (sw + what));
+	tmp |= ((val & 0xf) << (sw + what));
+	return ezx_pcap_write(PCAP_REG_LOWPWR, tmp);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_set_sw);
+
+static u8 vreg_table[][5] = {
+	/*		EN	INDEX	MASK	STBY	LOWPWR	*/
+	[V1]	= {	1,	2,	0x7,	18,	0,	},
+	[V2]	= {	5,	6,	0x1,	19,	22,	},
+	[V3]	= {	7,	8,	0x7,	20,	23,	},
+	[V4]	= {	11,	12,	0x7,	21,	24,	},
+	[V5]	= {	15,	16,	0x3,	0xff,	0xff,	},
+	[V6]	= {	1,	0xff,	0x0,	0xff,	0xff,	},
+	/* FIXME: I have no idea of V7-V10 bits -WM */
+	[V7]	= {	0xff,	0xff,	0x0,	0xff,	0xff,	},
+	[V8]	= {	0xff,	0xff,	0x0,	0xff,	0xff,	},
+	[V9]	= {	0xff,	0xff,	0x0,	0xff,	0xff,	},
+	[V10]	= {	0xff,	0xff,	0x0,	0xff,	0xff,	},
+	[VAUX1]	= {	1,	2,	0x3,	22,	23,	},
+	[VAUX2]	= {	4,	5,	0x3,	0,	1,	},
+	[VAUX3]	= {	7,	8,	0xf,	2,	3,	},
+	[VAUX4]	= {	12,	13,	0x3,	4,	5,	},
+	[VSIM]	= {	17,	18,	0x1,	0xff,	6,	},
+	[VSIM2]	= {	16,	0xff,	0x0,	0xff,	7,	},
+	[VVIB]	= {	19,	20,	0x3,	0xff,	0xff,	},
+	[VC]	= {	0xff,	0xff,	0x0,	24,	0xff,	},
+};
+
+int ezx_pcap_set_vreg(u8 vreg, u8 what, u8 val)
+{
+	struct pcap_platform_data *pdata = pcap.spi->dev.platform_data;
+	u8 reg, shift, mask;
+	u32 tmp;
+
+	switch (vreg) {
+	case V1 ... V5:
+		/* vreg1 is not accessible on port 2 */
+		if (pdata->config & PCAP_SECOND_PORT)
+			return -EINVAL;
+		reg = PCAP_REG_VREG1;
+		break;
+	case V6 ... V10:
+		reg = PCAP_REG_VREG2;
+		break;
+	case VAUX1 ... VC:
+		if ((what == V_LOWPWR || what == V_STBY) && vreg != VAUX1)
+			reg = PCAP_REG_LOWPWR;
+		else
+			reg = PCAP_REG_AUXVREG;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (what) {
+	case V_VAL:
+		shift = vreg_table[vreg][V_VAL];
+		mask = vreg_table[vreg][V_MASK];
+		break;
+	case V_EN:
+	case V_STBY:
+	case V_LOWPWR:
+		shift = vreg_table[vreg][what];
+		mask = 0x1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* invalid setting */
+	if (shift == 0xff || val > mask)
+		return -EINVAL;
+
+	ezx_pcap_read(reg, &tmp);
+	tmp &= ~(mask << shift);
+	tmp |= ((val & mask) << shift);
+	ezx_pcap_write(reg, tmp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_set_vreg);
+
+/* ADC */
+void ezx_pcap_disable_adc(void)
+{
+	u32 tmp;
+
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp &= ~(PCAP_ADC_ADEN|PCAP_ADC_BATT_I_ADC|PCAP_ADC_BATT_I_POLARITY);
+	tmp |= (PCAP_ADC_TS_M_STANDBY << PCAP_ADC_TS_M_SHIFT);
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+	mutex_unlock(&adc_lock);
+}
+
+static void ezx_pcap_adc_event(u32 flags, void *data)
+{
+	void (*adc_done)(void *);
+	void *adc_data;
+
+	if (!pcap.adc_done)
+		return;
+
+	adc_done = pcap.adc_done;
+	adc_data = pcap.adc_data;
+	pcap.adc_done = pcap.adc_data = NULL;
+
+	/* let caller get the results */
+	adc_done(adc_data);
+}
+
+void ezx_pcap_start_adc(u8 bank, u8 time, u32 flags,
+						void *adc_done, void *adc_data)
+{
+	u32 adc;
+	u32 adr;
+
+	mutex_lock(&adc_lock);
+
+	adc = flags | PCAP_ADC_ADEN;
+
+	if (bank == PCAP_ADC_BANK_1)
+		adc |= PCAP_ADC_AD_SEL1;
+
+	ezx_pcap_write(PCAP_REG_ADC, adc);
+
+	pcap.adc_done = adc_done;
+	pcap.adc_data = adc_data;
+
+	if (time == PCAP_ADC_T_NOW) {
+		ezx_pcap_read(PCAP_REG_ADR, &adr);
+		adr = PCAP_ADR_ASC;
+		ezx_pcap_write(PCAP_REG_ADR, adr);
+		return;
+	}
+
+	if (time == PCAP_ADC_T_IN_BURST)
+		adc |= (PCAP_ADC_ATO_IN_BURST << PCAP_ADC_ATO_SHIFT);
+
+	ezx_pcap_write(PCAP_REG_ADC, adc);
+
+	ezx_pcap_read(PCAP_REG_ADR, &adr);
+	adr &= ~PCAP_ADR_ONESHOT;
+	ezx_pcap_write(PCAP_REG_ADR, adr);
+	adr |= PCAP_ADR_ONESHOT;
+	ezx_pcap_write(PCAP_REG_ADR, adr);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_start_adc);
+
+void ezx_pcap_get_adc_channel_result(u8 ch1, u8 ch2, u32 res[])
+{
+	u32 tmp;
+
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp &= ~(PCAP_ADC_ADA1_MASK | PCAP_ADC_ADA2_MASK);
+	tmp |= (ch1 << PCAP_ADC_ADA1_SHIFT) | (ch2 << PCAP_ADC_ADA2_SHIFT);
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+	ezx_pcap_read(PCAP_REG_ADR, &tmp);
+	res[0] = (tmp & PCAP_ADR_ADD1_MASK) >> PCAP_ADR_ADD1_SHIFT;
+	res[1] = (tmp & PCAP_ADR_ADD2_MASK) >> PCAP_ADR_ADD2_SHIFT;
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_get_adc_channel_result);
+
+void ezx_pcap_get_adc_bank_result(u32 res[])
+{
+	int x;
+	u32 tmp[2];
+
+	for (x = 0; x < 7; x += 2) {
+		ezx_pcap_get_adc_channel_result(x, (x+1) % 6, tmp);
+		res[x] = tmp[0];
+		if ((x + 1) < 7)
+			res[x+1] = tmp[1];
+		else
+			res[x+1] = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_get_adc_bank_result);
+
+static void adc_complete(void *data)
+{
+	complete(data);
+}
+
+void ezx_pcap_do_general_adc(u8 bank, u8 ch, u32 *res)
+{
+	u32 tmp[2];
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	ezx_pcap_start_adc(bank, PCAP_ADC_T_NOW, 0, adc_complete, &done);
+	wait_for_completion(&done);
+	ezx_pcap_get_adc_channel_result(ch, 0, tmp);
+	ezx_pcap_disable_adc();
+
+	*res = tmp[0];
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_do_general_adc);
+
+/* event handling */
+static irqreturn_t pcap_irq_handler(int irq, void *dev_id)
+{
+	queue_work(pcap.workqueue, &pcap.work);
+	return IRQ_HANDLED;
+}
+
+static void pcap_work(struct work_struct *_pcap)
+{
+	u32 msr;
+	u32 isr;
+	u32 service;
+	struct pcap_event *cb;
+
+	mutex_lock(&event_lock);
+	ezx_pcap_read(PCAP_REG_MSR, &msr);
+	ezx_pcap_read(PCAP_REG_ISR, &isr);
+	isr &= ~msr;
+
+	list_for_each_entry(cb, &event_list, node) {
+		service = isr & cb->events;
+		if (service) {
+			ezx_pcap_write(PCAP_REG_ISR, service);
+			cb->callback(service, cb->data);
+		}
+	}
+	mutex_unlock(&event_lock);
+}
+
+void ezx_pcap_mask_event(u32 events)
+{
+	u32 msr;
+
+	ezx_pcap_read(PCAP_REG_MSR, &msr);
+	msr |= events;
+	ezx_pcap_write(PCAP_REG_MSR, msr);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_mask_event);
+
+void ezx_pcap_unmask_event(u32 events)
+{
+	u32 msr;
+
+	ezx_pcap_read(PCAP_REG_MSR, &msr);
+	msr &= ~events;
+	ezx_pcap_write(PCAP_REG_MSR, msr);
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_unmask_event);
+
+int ezx_pcap_register_event(u32 events, void *callback, void *data, char *label)
+{
+	struct pcap_event *cb;
+
+	cb = kzalloc(sizeof(struct pcap_event), GFP_KERNEL);
+	if (!cb)
+		return -ENOMEM;
+
+	cb->label = label;
+	cb->events = events;
+	cb->callback = callback;
+	cb->data = data;
+
+	mutex_lock(&event_lock);
+	list_add_tail(&cb->node, &event_list);
+	mutex_unlock(&event_lock);
+
+	ezx_pcap_unmask_event(events);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_register_event);
+
+int ezx_pcap_unregister_event(u32 events)
+{
+	int ret = -EINVAL;
+	struct pcap_event *cb;
+	struct pcap_event *store;
+
+	ezx_pcap_mask_event(events);
+
+	mutex_lock(&event_lock);
+	list_for_each_entry_safe(cb, store, &event_list, node) {
+		if (cb->events & events) {
+			list_del(&cb->node);
+			kfree(cb);
+			ret = 0;
+		}
+	}
+	mutex_unlock(&event_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_unregister_event);
+
+/* sysfs interface */
+static ssize_t pcap_show_regs(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	unsigned int reg, val;
+	char *p = buf;
+
+	for (reg = 0; reg < 32; reg++) {
+		ezx_pcap_read(reg, &val);
+		p += sprintf(p, "%02d %08x\n", reg, val);
+	}
+	return p - buf;
+}
+
+static ssize_t pcap_store_regs(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	unsigned int reg, val;
+	char *p = (char *)buf;
+
+	while (p < (buf + size)) {
+		if ((sscanf(p, "%u %x\n", &reg, &val) != 2) ||
+			reg < 0 || reg >= 32)
+			return -EINVAL;
+		p = strchr(p, '\n') + 1;
+	}
+
+	p = (char *)buf;
+	while (p < (buf + size)) {
+		sscanf(p, "%u %x\n", &reg, &val);
+		ezx_pcap_write(reg, val);
+		p = strchr(p, '\n') + 1;
+	}
+
+	return size;
+}
+
+static ssize_t pcap_show_adc_coin(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_COIN, &res);
+	return sprintf(buf, "%d\n", res);
+}
+static ssize_t pcap_show_adc_battery(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_BATT, &res);
+	return sprintf(buf, "%d\n", res);
+}
+static ssize_t pcap_show_adc_bplus(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_BPLUS, &res);
+	return sprintf(buf, "%d\n", res);
+}
+static ssize_t pcap_show_adc_mobportb(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_MOBPORTB, &res);
+	return sprintf(buf, "%d\n", res);
+}
+static ssize_t pcap_show_adc_temperature(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_TEMPERATURE, &res);
+	return sprintf(buf, "%d\n", res);
+}
+static ssize_t pcap_show_adc_chargerid(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	u32 res;
+
+	ezx_pcap_do_general_adc(PCAP_ADC_BANK_0, PCAP_ADC_CH_CHARGER_ID, &res);
+	return sprintf(buf, "%d\n", res);
+}
+
+static DEVICE_ATTR(regs, 0600, pcap_show_regs, pcap_store_regs);
+static DEVICE_ATTR(adc_coin, 0400, pcap_show_adc_coin, NULL);
+static DEVICE_ATTR(adc_battery, 0400, pcap_show_adc_battery, NULL);
+static DEVICE_ATTR(adc_bplus, 0400, pcap_show_adc_bplus, NULL);
+static DEVICE_ATTR(adc_mobportb, 0400, pcap_show_adc_mobportb, NULL);
+static DEVICE_ATTR(adc_temperature, 0400, pcap_show_adc_temperature, NULL);
+static DEVICE_ATTR(adc_chargerid, 0400, pcap_show_adc_chargerid, NULL);
+
+static int ezx_pcap_setup_sysfs(int create)
+{
+	int ret = 0;
+
+	if (!create)
+		goto remove_all;
+
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_regs);
+	if (ret)
+		goto ret;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_coin);
+	if (ret)
+		goto fail1;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_battery);
+	if (ret)
+		goto fail2;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_bplus);
+	if (ret)
+		goto fail3;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_mobportb);
+	if (ret)
+		goto fail4;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_temperature);
+	if (ret)
+		goto fail5;
+	ret = device_create_file(&pcap.spi->dev, &dev_attr_adc_chargerid);
+	if (ret)
+		goto fail6;
+
+	goto ret;
+
+remove_all:
+fail6:	device_remove_file(&pcap.spi->dev, &dev_attr_adc_temperature);
+fail5:	device_remove_file(&pcap.spi->dev, &dev_attr_adc_mobportb);
+fail4:	device_remove_file(&pcap.spi->dev, &dev_attr_adc_bplus);
+fail3:	device_remove_file(&pcap.spi->dev, &dev_attr_adc_battery);
+fail2:	device_remove_file(&pcap.spi->dev, &dev_attr_adc_coin);
+fail1:	device_remove_file(&pcap.spi->dev, &dev_attr_regs);
+ret:	return ret;
+}
+
+static int ezx_pcap_remove(struct spi_device *spi)
+{
+	struct pcap_platform_data *pdata = spi->dev.platform_data;
+
+	ezx_pcap_setup_sysfs(0);
+	destroy_workqueue(pcap.workqueue);
+	ezx_pcap_unregister_event(PCAP_MASK_ALL_INTERRUPT);
+	free_irq(pdata->irq, NULL);
+
+	return 0;
+}
+
+static int __devinit ezx_pcap_probe(struct spi_device *spi)
+{
+	struct pcap_platform_data *pdata = spi->dev.platform_data;
+	int ret = -ENODEV;
+
+	if (!pdata)
+		goto ret;
+
+	pcap.spi = spi;
+
+	INIT_WORK(&pcap.work, pcap_work);
+	pcap.workqueue = create_singlethread_workqueue("pcapd");
+	if (!pcap.workqueue) {
+		dev_err(&spi->dev, "cant create pcap thread\n");
+		goto ret;
+	}
+
+	/* redirect interrupts to AP */
+	if (!(pdata->config & PCAP_SECOND_PORT))
+		ezx_pcap_write(PCAP_REG_INT_SEL, PCAP_IRQ_ADCDONE2);
+
+	/* set board-specific settings */
+	if (pdata->init)
+		pdata->init();
+
+	ret = ezx_pcap_setup_sysfs(1);
+	if (ret) {
+		dev_err(&spi->dev, "cant create sysfs files\n");
+		goto wq_destroy;
+	}
+
+	/* mask/ack all PCAP interrupts */
+	ezx_pcap_write(PCAP_REG_MSR, PCAP_MASK_ALL_INTERRUPT);
+	ezx_pcap_write(PCAP_REG_ISR, PCAP_CLEAR_INTERRUPT_REGISTER);
+
+	/* register irq for pcap */
+	ret = request_irq(pdata->irq, pcap_irq_handler, IRQF_DISABLED,
+		"PCAP", NULL);
+	if (ret) {
+		dev_err(&spi->dev, "cant request IRQ\n");
+		goto wq_destroy;
+	}
+	set_irq_type(pdata->irq, IRQ_TYPE_EDGE_RISING);
+	set_irq_wake(pdata->irq, 1);
+
+	ezx_pcap_register_event((pdata->config & PCAP_SECOND_PORT) ?
+			PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE,
+			ezx_pcap_adc_event, NULL, "ADC");
+	return 0;
+
+wq_destroy:
+	destroy_workqueue(pcap.workqueue);
+ret:
+	return ret;
+}
+
+static struct spi_driver ezxpcap_driver = {
+	.probe  = ezx_pcap_probe,
+	.remove = ezx_pcap_remove,
+	.driver = {
+		.name   = "ezx-pcap",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int __init ezx_pcap_init(void)
+{
+	return spi_register_driver(&ezxpcap_driver);
+}
+
+static void __exit ezx_pcap_exit(void)
+{
+	spi_unregister_driver(&ezxpcap_driver);
+}
+
+module_init(ezx_pcap_init);
+module_exit(ezx_pcap_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
+MODULE_DESCRIPTION("Motorola PCAP2 ASIC Driver");
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
new file mode 100644
index 0000000..352ac35
--- /dev/null
+++ b/include/linux/mfd/ezx-pcap.h
@@ -0,0 +1,290 @@
+/*
+ * Copyright 2007 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ * For further information, please see http://wiki.openezx.org/PCAP2
+ */
+
+#ifndef EZX_PCAP_H
+#define EZX_PCAP_H
+
+struct pcap_platform_data {
+	unsigned int irq;
+	unsigned int config;
+	void (*init) (void);	/* board specific init */
+};
+
+#define PCAP_SECOND_PORT	1
+
+#define PCAP_REGISTER_WRITE_OP_BIT	0x80000000
+#define PCAP_REGISTER_READ_OP_BIT	0x00000000
+
+#define PCAP_REGISTER_VALUE_MASK	0x01ffffff
+#define PCAP_REGISTER_ADDRESS_MASK	0x7c000000
+#define PCAP_REGISTER_ADDRESS_SHIFT	26
+#define PCAP_REGISTER_NUMBER		32
+#define PCAP_CLEAR_INTERRUPT_REGISTER	0x01ffffff
+#define PCAP_MASK_ALL_INTERRUPT		0x01ffffff
+
+/* registers acessible by both pcap ports */
+#define PCAP_REG_ISR		0x0	/* Interrupt Status */
+#define PCAP_REG_MSR		0x1	/* Interrupt Mask */
+#define PCAP_REG_PSTAT		0x2	/* Processor Status */
+#define PCAP_REG_VREG2		0x6	/* Regulator Bank 2 Control */
+#define PCAP_REG_AUXVREG	0x7	/* Auxiliary Regulator Control */
+#define PCAP_REG_BATT		0x8	/* Battery Control */
+#define PCAP_REG_ADC		0x9	/* AD Control */
+#define PCAP_REG_ADR		0xa	/* AD Result */
+#define PCAP_REG_CODEC		0xb	/* Audio Codec Control */
+#define PCAP_REG_RX_AMPS	0xc	/* RX Audio Amplifiers Control */
+#define PCAP_REG_ST_DAC		0xd	/* Stereo DAC Control */
+#define PCAP_REG_BUSCTRL	0x14	/* Connectivity Control */
+#define PCAP_REG_PERIPH		0x15	/* Peripheral Control */
+#define PCAP_REG_LOWPWR		0x18	/* Regulator Low Power Control */
+#define PCAP_REG_TX_AMPS	0x1a	/* TX Audio Amplifiers Control */
+#define PCAP_REG_GP		0x1b	/* General Purpose */
+#define PCAP_REG_TEST1		0x1c
+#define PCAP_REG_TEST2		0x1d
+#define PCAP_REG_VENDOR_TEST1	0x1e
+#define PCAP_REG_VENDOR_TEST2	0x1f
+
+/* registers acessible by pcap port 1 only (a1200, e2 & e6) */
+#define PCAP_REG_INT_SEL	0x3	/* Interrupt Select */
+#define PCAP_REG_SWCTRL		0x4	/* Switching Regulator Control */
+#define PCAP_REG_VREG1		0x5	/* Regulator Bank 1 Control */
+#define PCAP_REG_RTC_TOD	0xe	/* RTC Time of Day */
+#define PCAP_REG_RTC_TODA	0xf	/* RTC Time of Day Alarm */
+#define PCAP_REG_RTC_DAY	0x10	/* RTC Day */
+#define PCAP_REG_RTC_DAYA	0x11	/* RTC Day Alarm */
+#define PCAP_REG_MTRTMR		0x12	/* AD Monitor Timer */
+#define PCAP_REG_PWR		0x13	/* Power Control */
+#define PCAP_REG_AUXVREG_MASK	0x16	/* Auxiliary Regulator Mask */
+#define PCAP_REG_VENDOR_REV	0x17
+#define PCAP_REG_PERIPH_MASK	0x19	/* Peripheral Mask */
+
+/* interrupts - registers 0x0, 0x1, 0x2, 0x3 */
+#define PCAP_IRQ_ADCDONE	(1 << 0)	/* AD Conversion Done Port 1 */
+#define PCAP_IRQ_TS		(1 << 1)	/* Touch Screen */
+#define PCAP_IRQ_1HZ		(1 << 2)	/* 1HZ Timer */
+#define PCAP_IRQ_WH		(1 << 3)	/* "...high"??? */
+#define PCAP_IRQ_WL		(1 << 4)	/* "...low"??? */
+#define PCAP_IRQ_TODA		(1 << 5)	/* RTC Time Of Day?
+						   (see "RTC_TODA") */
+#define PCAP_IRQ_USB4V		(1 << 6)	/* USB OTG */
+#define PCAP_IRQ_ONOFF		(1 << 7)	/* in blob: "ONOFFSNS" */
+#define PCAP_IRQ_ONOFF2		(1 << 8)	/* in blob: "ONOFFSNS2" */
+#define PCAP_IRQ_USB1V		(1 << 9)	/* USB below 1volt???
+						   in blob: "USBDET_1V" */
+#define PCAP_IRQ_MOBPORT	(1 << 10)	/* GSM-related?? ("mobport",
+						   see 958_MotDoc.pdf);
+						   in blob: "MOBSENSB" */
+#define PCAP_IRQ_MB2		(1 << 11)	/* Mic; in blob: "MB2SNS" */
+#define PCAP_IRQ_A1		(1 << 12)	/* Audio jack;
+						   in blob: "A1SNS" */
+#define PCAP_IRQ_ST		(1 << 13)	/* called "MSTB" in blob */
+#define PCAP_IRQ_PC		(1 << 14)
+#define PCAP_IRQ_WARM		(1 << 15)
+#define PCAP_IRQ_EOL		(1 << 16)	/*  battery End Of Life???
+						   (see below);
+						   in blob: "EOL_STAT" */
+#define PCAP_IRQ_CLK		(1 << 17)	/* called "CLK_STAT" in blob */
+#define PCAP_IRQ_SYSRST		(1 << 18)
+#define PCAP_IRQ_DUMMY		(1 << 19)
+#define PCAP_IRQ_ADCDONE2	(1 << 20)	/* AD Conversion Done Port 2 */
+#define PCAP_IRQ_SOFTRESET	(1 << 21)
+#define PCAP_IRQ_MNEXB		(1 << 22)
+
+/* voltage regulators */
+#define V1		0
+#define V2		1
+#define V3		2
+#define V4		3
+#define V5		4
+#define V6		5
+#define V7		6
+#define V8		7
+#define V9		8
+#define V10		9
+#define VAUX1		10
+#define VAUX2		11
+#define VAUX3		12
+#define VAUX4		13
+#define VSIM		14
+#define VSIM2		15
+#define VVIB		16
+#define VC		17
+
+#define V_EN		0
+#define V_VAL		1
+#define V_MASK		2
+#define V_STBY		3
+#define V_LOWPWR	4
+
+#define PCAP_BATT_DAC_MASK		0x000000ff
+#define PCAP_BATT_DAC_SHIFT		0
+#define PCAP_BATT_B_FDBK		(1 << 8)
+#define PCAP_BATT_EXT_ISENSE		(1 << 9)
+#define PCAP_BATT_V_COIN_MASK		0x00003c00
+#define PCAP_BATT_V_COIN_SHIFT		10
+#define PCAP_BATT_I_COIN		(1 << 14)
+#define PCAP_BATT_COIN_CH_EN		(1 << 15)
+#define PCAP_BATT_EOL_SEL_MASK		0x000e0000
+#define PCAP_BATT_EOL_SEL_SHIFT		17
+#define PCAP_BATT_EOL_CMP_EN		(1 << 20)
+#define PCAP_BATT_BATT_DET_EN		(1 << 21)
+#define PCAP_BATT_THERMBIAS_CTRL	(1 << 22)
+
+#define PCAP_ADC_ADEN			(1 << 0)
+#define PCAP_ADC_RAND			(1 << 1)
+#define PCAP_ADC_AD_SEL1		(1 << 2)
+#define PCAP_ADC_AD_SEL2		(1 << 3)
+#define PCAP_ADC_ADA1_MASK		0x00000070
+#define PCAP_ADC_ADA1_SHIFT		4
+#define PCAP_ADC_ADA2_MASK		0x00000380
+#define PCAP_ADC_ADA2_SHIFT		7
+#define PCAP_ADC_ATO_MASK		0x00003c00
+#define PCAP_ADC_ATO_SHIFT		10
+#define PCAP_ADC_ATOX			(1 << 14)
+#define PCAP_ADC_MTR1			(1 << 15)
+#define PCAP_ADC_MTR2			(1 << 16)
+#define PCAP_ADC_TS_M_MASK		0x000e0000
+#define PCAP_ADC_TS_M_SHIFT		17
+#define PCAP_ADC_TS_REF_LOWPWR		(1 << 20)
+#define PCAP_ADC_TS_REFENB		(1 << 21)
+#define PCAP_ADC_BATT_I_POLARITY	(1 << 22)
+#define PCAP_ADC_BATT_I_ADC		(1 << 23)
+
+#define PCAP_ADC_BANK_0			0
+#define PCAP_ADC_BANK_1			1
+/* ADC bank 0 */
+#define PCAP_ADC_CH_COIN		0
+#define PCAP_ADC_CH_BATT		1
+#define PCAP_ADC_CH_BPLUS		2
+#define PCAP_ADC_CH_MOBPORTB		3
+#define PCAP_ADC_CH_TEMPERATURE		4
+#define PCAP_ADC_CH_CHARGER_ID		5
+#define PCAP_ADC_CH_AD6			6
+/* ADC bank 1 */
+#define PCAP_ADC_CH_AD7			0
+#define PCAP_ADC_CH_AD8			1
+#define PCAP_ADC_CH_AD9			2
+#define PCAP_ADC_CH_TS_X1		3
+#define PCAP_ADC_CH_TS_X2		4
+#define PCAP_ADC_CH_TS_Y1		5
+#define PCAP_ADC_CH_TS_Y2		6
+
+#define PCAP_ADC_T_NOW			0
+#define PCAP_ADC_T_IN_BURST		1
+#define PCAP_ADC_T_OUT_BURST		2
+
+#define PCAP_ADC_ATO_IN_BURST		6
+#define PCAP_ADC_ATO_OUT_BURST		0
+
+#define PCAP_ADC_TS_M_XY		1
+#define PCAP_ADC_TS_M_PRESSURE		2
+#define PCAP_ADC_TS_M_PLATE_X		3
+#define PCAP_ADC_TS_M_PLATE_Y		4
+#define PCAP_ADC_TS_M_STANDBY		5
+#define PCAP_ADC_TS_M_NONTS		6
+
+#define PCAP_ADR_ADD1_MASK		0x000003ff
+#define PCAP_ADR_ADD1_SHIFT		0
+#define PCAP_ADR_ADD2_MASK		0x000ffc00
+#define PCAP_ADR_ADD2_SHIFT		10
+#define PCAP_ADR_ADINC1			(1 << 20)
+#define PCAP_ADR_ADINC2			(1 << 21)
+#define PCAP_ADR_ASC			(1 << 22)
+#define PCAP_ADR_ONESHOT		(1 << 23)
+
+#define PCAP_BUSCTRL_FSENB		(1 << 0)
+#define PCAP_BUSCTRL_USB_SUSPEND	(1 << 1)
+#define PCAP_BUSCTRL_USB_PU		(1 << 2)
+#define PCAP_BUSCTRL_USB_PD		(1 << 3)
+#define PCAP_BUSCTRL_VUSB_EN		(1 << 4)
+#define PCAP_BUSCTRL_USB_PS		(1 << 5)
+#define PCAP_BUSCTRL_VUSB_MSTR_EN	(1 << 6)
+#define PCAP_BUSCTRL_VBUS_PD_ENB	(1 << 7)
+#define PCAP_BUSCTRL_CURRLIM		(1 << 8)
+#define PCAP_BUSCTRL_RS232ENB		(1 << 9)
+#define PCAP_BUSCTRL_RS232_DIR		(1 << 10)
+#define PCAP_BUSCTRL_SE0_CONN		(1 << 11)
+#define PCAP_BUSCTRL_USB_PDM		(1 << 12)
+#define PCAP_BUSCTRL_BUS_PRI_ADJ	(1 << 24)
+
+/* leds */
+#define PCAP_LED0		0
+#define PCAP_LED1		1
+#define PCAP_BL0		2
+#define PCAP_BL1		3
+#define PCAP_LED_3MA		0
+#define PCAP_LED_4MA		1
+#define PCAP_LED_5MA		2
+#define PCAP_LED_9MA		3
+#define PCAP_LED_GPIO_VAL_MASK	0x00ffffff
+#define PCAP_LED_GPIO_EN	0x01000000
+#define PCAP_LED_GPIO_INVERT	0x02000000
+#define PCAP_LED_T_MASK		0xf
+#define PCAP_LED_C_MASK		0x3
+#define PCAP_BL_MASK		0x1f
+#define PCAP_BL0_SHIFT		0
+#define PCAP_LED0_EN		(1 << 5)
+#define PCAP_LED1_EN		(1 << 6)
+#define PCAP_LED0_T_SHIFT	7
+#define PCAP_LED1_T_SHIFT	11
+#define PCAP_LED0_C_SHIFT	15
+#define PCAP_LED1_C_SHIFT	17
+#define PCAP_BL1_SHIFT		20
+
+/* RTC */
+#define PCAP_RTC_DAY_MASK	0x3fff
+#define PCAP_RTC_TOD_MASK	0xffff
+#define PCAP_RTC_PC_MASK	0x7
+#define SEC_PER_DAY		86400
+
+/* LOWPWR */
+#define SW1		8
+#define SW2		16
+
+#define SW_MODE		0
+#define SW_VOLTAGE	4
+
+#define SW_VOLTAGE_900	0x0
+#define SW_VOLTAGE_950	0x1
+#define SW_VOLTAGE_1000	0x2
+#define SW_VOLTAGE_1050	0x3
+#define SW_VOLTAGE_1100	0x4
+#define SW_VOLTAGE_1150	0x5
+#define SW_VOLTAGE_1200	0x6
+#define SW_VOLTAGE_1250	0x7
+#define SW_VOLTAGE_1300	0x8
+#define SW_VOLTAGE_1350	0x9
+#define SW_VOLTAGE_1400	0xa
+#define SW_VOLTAGE_1500	0xb
+#define SW_VOLTAGE_1600	0xc
+#define SW_VOLTAGE_1875	0xd
+#define SW_VOLTAGE_2250	0xe
+#define SW_VOLTAGE_4400	0xf
+
+int ezx_pcap_write(u8, u32);
+int ezx_pcap_read(u8, u32 *);
+int ezx_pcap_set_sw(u8, u8, u8);
+int ezx_pcap_set_vreg(u8, u8, u8);
+void ezx_pcap_start_adc(u8, u8, u32, void *, void *);
+void ezx_pcap_get_adc_channel_result(u8, u8, u32[]);
+void ezx_pcap_get_adc_bank_result(u32[]);
+void ezx_pcap_disable_adc(void);
+void ezx_pcap_do_general_adc(u8, u8, u32 *);
+void ezx_pcap_do_batt_adc(int, u32[]);
+int ezx_pcap_register_event(u32, void *, void *, char *);
+int ezx_pcap_unregister_event(u32);
+void ezx_pcap_mask_event(u32);
+void ezx_pcap_unmask_event(u32);
+
+struct pcap_event {
+	struct list_head node;
+	char *label;
+	u32 events;
+	void (*callback) (u32, void *);
+	void *data;
+};
+
+#endif
-- 
tg: (ed31348..) ezx/pcap (depends on: master)

--=-cmLyTE6YB33sHlsNSrlY--

