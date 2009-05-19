Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZESNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZESNnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZESNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:43:10 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:36918 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZESNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SFZWMETTlG99u4TLVm1MFn+InAFWrsmLm7SQtPrE5LDZeem5juZWIs9c/sbKEQJiSJ
         bvK6BsQhlv8mav7Cola7PRB40Kb4KcMuurY6Vgx56AXAzc81QUvc/EJ5eWqmWhUfjnau
         kHzkG43OEwomUNjcUzzs9bRfdlh/eVUlO83Rs=
Subject: [PATCH] MFD: PCAP core driver.
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Harald Welte <laforge@gnumonks.org>,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 10:42:46 -0300
Message-Id: <1242740566.6142.54.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCAP Asic as present on EZX phones is a multi function device with
voltage regulators, touch screen controller, RTC and audio codec.
It has two SPI ports, typically one is connected to the application
processor and another to the baseband, this driver provides read/write
functions to its registers and an irq demultiplexer.

This chip is used on a lot of Motorola phones, it was manufactured by TI
as a custom product with the name PTWL93017, later this design evolved
into the ATLAS PMIC from Freescale (MC13783).

Since the last submission we moved ADC and regulator code out of the core
driver and switched to generic irq.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 arch/arm/mach-pxa/Kconfig             |    1 +
 arch/arm/mach-pxa/include/mach/irqs.h |   29 ++++
 drivers/mfd/Kconfig                   |    7 +
 drivers/mfd/Makefile                  |    2 +
 drivers/mfd/ezx-pcap.c                |  277 +++++++++++++++++++++++++++++++++
 include/linux/mfd/ezx-pcap.h          |  225 ++++++++++++++++++++++++++
 6 files changed, 541 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 17d3fbd..73c8f19 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -429,6 +429,7 @@ config PXA_EZX
 	select PXA27x
 	select IWMMXT
 	select HAVE_PWM
+	select EZX_PCAP
 
 config MACH_EZX_A780
 	bool "Motorola EZX A780"
diff --git a/arch/arm/mach-pxa/include/mach/irqs.h b/arch/arm/mach-pxa/include/mach/irqs.h
index 32bb4a2..7c0f33b 100644
--- a/arch/arm/mach-pxa/include/mach/irqs.h
+++ b/arch/arm/mach-pxa/include/mach/irqs.h
@@ -190,6 +190,8 @@
 #define NR_IRQS			(IRQ_BOARD_END)
 #elif defined(CONFIG_MACH_ZYLONITE)
 #define NR_IRQS			(IRQ_BOARD_START + 32)
+#elif defined(CONFIG_PXA_EZX)
+#define NR_IRQS			(IRQ_BOARD_START + 23)
 #else
 #define NR_IRQS			(IRQ_BOARD_START)
 #endif
@@ -242,6 +244,33 @@
 #define PCM027_MMCDET_IRQ      PCM027_IRQ(2)
 #define PCM027_PM_5V_IRQ       PCM027_IRQ(3)
 
+/* PCAP2 Interrupts */
+#define PCAP_IRQ(x)		(IRQ_BOARD_START + (x))
+#define PCAP_IRQ_ADCDONE	PCAP_IRQ(0)	/* ADC done port 1 */
+#define PCAP_IRQ_TS		PCAP_IRQ(1)	/* Touch Screen */
+#define PCAP_IRQ_1HZ		PCAP_IRQ(2)	/* 1HZ timer */
+#define PCAP_IRQ_WH		PCAP_IRQ(3)	/* ADC above high limit */
+#define PCAP_IRQ_WL		PCAP_IRQ(4)	/* ADC below low limit */
+#define PCAP_IRQ_TODA		PCAP_IRQ(5)	/* Time of day alarm */
+#define PCAP_IRQ_USB4V		PCAP_IRQ(6)	/* USB above 4V */
+#define PCAP_IRQ_ONOFF		PCAP_IRQ(7)	/* On/Off button */
+#define PCAP_IRQ_ONOFF2		PCAP_IRQ(8)	/* On/Off button 2 */
+#define PCAP_IRQ_USB1V		PCAP_IRQ(9)	/* USB above 1V */
+#define PCAP_IRQ_MOBPORT	PCAP_IRQ(10)
+#define PCAP_IRQ_MIC		PCAP_IRQ(11)	/* Mic attach/HS button */
+#define PCAP_IRQ_HS		PCAP_IRQ(12)	/* Headset attach */
+#define PCAP_IRQ_ST		PCAP_IRQ(13)
+#define PCAP_IRQ_PC		PCAP_IRQ(14)	/* Power Cut */
+#define PCAP_IRQ_WARM		PCAP_IRQ(15)
+#define PCAP_IRQ_EOL		PCAP_IRQ(16)	/* Battery End Of Life */
+#define PCAP_IRQ_CLK		PCAP_IRQ(17)
+#define PCAP_IRQ_SYSRST		PCAP_IRQ(18)	/* System Reset */
+#define PCAP_IRQ_DUMMY		PCAP_IRQ(19)
+#define PCAP_IRQ_ADCDONE2	PCAP_IRQ(20)	/* ADC done port 2 */
+#define PCAP_IRQ_SOFTRESET	PCAP_IRQ(21)
+#define PCAP_IRQ_MNEXB		PCAP_IRQ(22)
+#define PCAP_LAST_IRQ		PCAP_IRQ(22)
+
 /* ITE8152 irqs */
 /* add IT8152 IRQs beyond BOARD_END */
 #ifdef CONFIG_PCI_HOST_ITE8152
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee3927a..060ee14 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -241,6 +241,13 @@ config PCF50633_GPIO
 	 Say yes here if you want to include support GPIO for pins on
 	 the PCF50633 chip.
 
+config EZX_PCAP
+	bool "PCAP Support"
+	depends on SPI_MASTER
+	help
+	  This enables the PCAP ASIC present on EZX Phones. This is
+	  needed for MMC, TouchScreen, Sound, USB, etc..
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3afb519..b768962 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -26,6 +26,8 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
+
 obj-$(CONFIG_MCP)		+= mcp-core.o
 obj-$(CONFIG_MCP_SA11X0)	+= mcp-sa11x0.o
 obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-core.o
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
new file mode 100644
index 0000000..c74d482
--- /dev/null
+++ b/drivers/mfd/ezx-pcap.c
@@ -0,0 +1,277 @@
+/*
+ * Driver for Motorola PCAP2 as present in EZX phones
+ *
+ * Copyright (C) 2006 Harald Welte <laforge@openezx.org>
+ * Copyright (C) 2009 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mfd/ezx-pcap.h>
+#include <linux/spi/spi.h>
+
+struct pcap_chip {
+	struct spi_device *spi;
+	u32 msr;
+	struct work_struct work;
+	struct work_struct msr_work;
+	struct workqueue_struct *workqueue;
+};
+static struct pcap_chip pcap;
+
+/* IO */
+#define PCAP_BUFSIZE	4
+static int ezx_pcap_putget(u32 *data)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+	int status;
+	u32 *buf = kmalloc(PCAP_BUFSIZE, GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	memset(&t, 0, sizeof t);
+	spi_message_init(&m);
+	t.len = PCAP_BUFSIZE;
+	spi_message_add_tail(&t, &m);
+
+	*buf = *data;
+	t.tx_buf = (u8 *) buf;
+	t.rx_buf = (u8 *) buf;
+	status = spi_sync(pcap.spi, &m);
+
+	if (status == 0)
+		*data = *buf;
+	kfree(buf);
+
+	return status;
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
+/* IRQ */
+static inline unsigned int irq2pcap(int irq)
+{
+	return 1 << (irq - PCAP_IRQ(0));
+}
+
+static void pcap_mask_irq(unsigned int irq)
+{
+	pcap.msr |= irq2pcap(irq);
+	queue_work(pcap.workqueue, &pcap.msr_work);
+}
+
+static void pcap_unmask_irq(unsigned int irq)
+{
+	pcap.msr &= ~irq2pcap(irq);
+	queue_work(pcap.workqueue, &pcap.msr_work);
+}
+
+static struct irq_chip pcap_irq_chip = {
+	.name	= "pcap",
+	.mask	= pcap_mask_irq,
+	.unmask	= pcap_unmask_irq,
+};
+
+static void pcap_msr_work(struct work_struct *msr_work)
+{
+	ezx_pcap_write(PCAP_REG_MSR, pcap.msr);
+}
+
+static void pcap_work(struct work_struct *_pcap)
+{
+	u32 msr, isr, service;
+	int irq;
+
+	ezx_pcap_read(PCAP_REG_MSR, &msr);
+	ezx_pcap_read(PCAP_REG_ISR, &isr);
+	ezx_pcap_write(PCAP_REG_ISR, isr);
+
+	local_irq_disable();
+	service = isr & ~msr;
+
+	for (irq = PCAP_IRQ(0); service; service >>= 1, irq++) {
+		if (service & 1) {
+			struct irq_desc *desc = irq_to_desc(irq);
+
+			if (WARN(!desc, KERN_WARNING
+					"Invalid PCAP IRQ %d\n", irq))
+				break;
+
+			if (desc->status & IRQ_DISABLED)
+				note_interrupt(irq, desc, IRQ_NONE);
+			else
+				desc->handle_irq(irq, desc);
+		}
+	}
+	local_irq_enable();
+}
+
+static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	desc->chip->ack(irq);
+	queue_work(pcap.workqueue, &pcap.work);
+	return;
+}
+
+/* subdevs */
+static int pcap_remove_subdev(struct device *dev, void *unused)
+{
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
+static int pcap_add_subdev(struct spi_device *spi, struct pcap_subdev *subdev)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_alloc(subdev->name, subdev->id);
+	pdev->dev.parent = &spi->dev;
+	pdev->dev.platform_data = subdev->platform_data;
+
+	return platform_device_add(pdev);
+}
+
+static int __devexit ezx_pcap_remove(struct spi_device *spi)
+{
+	struct pcap_platform_data *pdata = spi->dev.platform_data;
+
+	destroy_workqueue(pcap.workqueue);
+	free_irq(pdata->irq, NULL);
+
+	/* remove all registered subdevs */
+	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
+
+	pcap.spi = NULL;
+
+	return 0;
+}
+
+static int __devinit ezx_pcap_probe(struct spi_device *spi)
+{
+	struct pcap_platform_data *pdata = spi->dev.platform_data;
+	int i;
+	int ret = -ENODEV;
+
+	/* platform data is required */
+	if (!pdata)
+		goto ret;
+
+	/* we support only one pcap device */
+	if (pcap.spi) {
+		ret = -EBUSY;
+		goto ret;
+	}
+
+	/* setup spi */
+	spi->bits_per_word = 32;
+	spi->mode = SPI_MODE_0 | (pdata->config & PCAP_CS_AH ? SPI_CS_HIGH : 0);
+	ret = spi_setup(spi);
+	if (ret)
+		goto ret;
+
+	pcap.spi = spi;
+
+	/* setup irq */
+	INIT_WORK(&pcap.work, pcap_work);
+	INIT_WORK(&pcap.msr_work, pcap_msr_work);
+	pcap.workqueue = create_singlethread_workqueue("pcapd");
+	if (!pcap.workqueue) {
+		dev_err(&spi->dev, "cant create pcap thread\n");
+		goto null_spi;
+	}
+
+	/* redirect interrupts to AP */
+	if (!(pdata->config & PCAP_SECOND_PORT))
+		ezx_pcap_write(PCAP_REG_INT_SEL, 0);
+
+	/* setup irq chip */
+	for (i = PCAP_IRQ(0); i <= PCAP_LAST_IRQ; i++) {
+		set_irq_chip_and_handler(i, &pcap_irq_chip, handle_simple_irq);
+#ifdef CONFIG_ARM
+		set_irq_flags(i, IRQF_VALID);
+#else
+		set_irq_noprobe(i);
+#endif
+	}
+
+	/* mask/ack all PCAP interrupts */
+	ezx_pcap_write(PCAP_REG_MSR, PCAP_MASK_ALL_INTERRUPT);
+	ezx_pcap_write(PCAP_REG_ISR, PCAP_CLEAR_INTERRUPT_REGISTER);
+	pcap.msr = PCAP_MASK_ALL_INTERRUPT;
+
+	set_irq_type(pdata->irq, IRQ_TYPE_EDGE_RISING);
+	set_irq_chained_handler(pdata->irq, pcap_irq_handler);
+	set_irq_wake(pdata->irq, 1);
+
+	/* setup subdevs */
+	for (i = 0; i < pdata->num_subdevs; i++) {
+		ret = pcap_add_subdev(spi, &pdata->subdevs[i]);
+		if (ret)
+			goto remove_subdevs;
+	}
+
+	/* board specific quirks */
+	if (pdata->init)
+		pdata->init();
+
+	return 0;
+
+remove_subdevs:
+	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
+	for (i = PCAP_IRQ(0); i <= PCAP_LAST_IRQ; i++)
+		set_irq_chip_and_handler(i, NULL, NULL);
+	destroy_workqueue(pcap.workqueue);
+	pcap.workqueue = NULL;
+null_spi:
+	pcap.spi = NULL;
+ret:
+	return ret;
+}
+
+static struct spi_driver ezxpcap_driver = {
+	.probe  = ezx_pcap_probe,
+	.remove = __devexit_p(ezx_pcap_remove),
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
index 0000000..0c3217c
--- /dev/null
+++ b/include/linux/mfd/ezx-pcap.h
@@ -0,0 +1,225 @@
+/*
+ * Copyright 2007 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ * For further information, please see http://wiki.openezx.org/PCAP2
+ */
+
+#ifndef EZX_PCAP_H
+#define EZX_PCAP_H
+
+struct pcap_subdev {
+	int id;
+	const char *name;
+	void *platform_data;
+};
+
+struct pcap_platform_data {
+	unsigned int irq;
+	unsigned int config;
+	void (*init) (void);	/* board specific init */
+	int num_subdevs;
+	struct pcap_subdev *subdevs;
+};
+
+int ezx_pcap_write(u8, u32);
+int ezx_pcap_read(u8, u32 *);
+
+#define PCAP_SECOND_PORT	1
+#define PCAP_CS_AH		2
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
+#define SW1		17
+#define SW2		18
+#define SW3		19
+#define SW1S		20
+#define SW2S		21
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
+#define PCAP_VIB		4
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
+#define PCAP_VIB_MASK		0x3
+#define PCAP_VIB_SHIFT		20
+#define PCAP_VIB_EN		(1 << 19)
+
+/* RTC */
+#define PCAP_RTC_DAY_MASK	0x3fff
+#define PCAP_RTC_TOD_MASK	0xffff
+#define PCAP_RTC_PC_MASK	0x7
+#define SEC_PER_DAY		86400
+
+#endif
-- 
tg: (02b899f..) ezx/pcap (depends on: spi/pxa2xx_spi-fix-dma-resume)
total: 0 errors, 0 warnings, 571 lines checked

pcap.patch has no obvious style problems and is ready for submission.

-- 
Daniel Ribeiro

