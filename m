Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXGRTjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXGRTjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXGRTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:39:30 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52848 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbXGRTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:39:29 -0400
Message-ID: <469E6C00.3060506@atmel.com>
Date: Wed, 18 Jul 2007 21:37:36 +0200
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: kernel-avr32 <kernel@avr32linux.org>, David Brownell <david-b@pacbell.net>,
       Andrew Victor <andrew@sanpeople.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 1/1][RESEND] Driver for the Atmel on-chip SSC on AT32AP and
 AT91.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Synchronous Serial Controller (SSC) on Atmel microprocessors are capable of
tranceiving many frame based protocols, like I2S. Tested on the
AT32AP7000/ATSTK1000.

This driver is used in the ALSA sound driver for the AT73C213 external DAC on
the ATSTK1000 development board for AVR32. This sound driver will be submitted
soon.

Hardware documentation can be found in the AT32AP7000 data sheet, which can be
downloaded from http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

I am sorry if anybody is receiving this twice, but it seems like this patch was 
eaten by my mail server the first time I sent it.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
---
  drivers/misc/Kconfig      |   10 ++
  drivers/misc/Makefile     |    1 +
  drivers/misc/atmel-ssc.c  |  175 +++++++++++++++++++++++++
  include/linux/atmel-ssc.h |  312 +++++++++++++++++++++++++++++++++++++++++++++
  4 files changed, 498 insertions(+), 0 deletions(-)
  create mode 100644 drivers/misc/atmel-ssc.c
  create mode 100644 include/linux/atmel-ssc.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 616eee9..0810d83 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -187,5 +187,15 @@ config THINKPAD_ACPI_BAY

  	  If you are not sure, say Y here.

+config ATMEL_SSC
+	tristate "Device driver for Atmel SSC peripheral"
+	depends on AVR32 || ARCH_AT91
+	---help---
+	  This option enables device driver support for Atmel Syncronized
+	  Serial Communication peripheral (SSC).
+
+	  The SSC peripheral supports a wide variety of serial frame based
+	  communications, i.e. I2S, SPI, etc.

+	  If unsure, say N.
  endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 8abbf2f..2d52cc6 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_PHANTOM)		+= phantom.o
  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
  obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
  obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
+obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
new file mode 100644
index 0000000..240a538
--- /dev/null
+++ b/drivers/misc/atmel-ssc.c
@@ -0,0 +1,175 @@
+/*
+ * Atmel SSC driver
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/atmel-ssc.h>
+
+/* Serialize access to ssc_list and user count */
+static spinlock_t user_lock;
+static LIST_HEAD(ssc_list);
+
+struct ssc_device *ssc_request(unsigned int ssc_num)
+{
+	int ssc_valid = 0;
+	struct ssc_device *ssc;
+
+	spin_lock(&user_lock);
+	list_for_each_entry(ssc, &ssc_list, list) {
+		if (ssc->pdev->id == ssc_num) {
+			ssc_valid = 1;
+			break;
+		}
+	}
+
+	if (!ssc_valid) {
+		spin_unlock(&user_lock);
+		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (ssc->user) {
+		spin_unlock(&user_lock);
+		dev_dbg(&ssc->pdev->dev, "module busy\n");
+		return ERR_PTR(-EBUSY);
+	}
+	ssc->user++;
+	spin_unlock(&user_lock);
+
+	clk_enable(ssc->clk);
+
+	return ssc;
+}
+EXPORT_SYMBOL(ssc_request);
+
+void ssc_free(struct ssc_device *ssc)
+{
+	spin_lock(&user_lock);
+	if (ssc->user) {
+		ssc->user--;
+		clk_disable(ssc->clk);
+	} else {
+		dev_dbg(&ssc->pdev->dev, "device already free\n");
+	}
+	spin_unlock(&user_lock);
+}
+EXPORT_SYMBOL(ssc_free);
+
+static int __init ssc_probe(struct platform_device *pdev)
+{
+	int retval = 0;
+	struct resource *regs;
+	struct ssc_device *ssc;
+
+	ssc = kzalloc(sizeof(struct ssc_device), GFP_KERNEL);
+	if (!ssc) {
+		dev_dbg(&pdev->dev, "out of memory\n");
+		retval = -ENOMEM;
+		goto out;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "no mmio resource defined\n");
+		retval = -ENXIO;
+		goto out_free;
+	}
+
+	ssc->clk = clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(ssc->clk)) {
+		dev_dbg(&pdev->dev, "no pclk clock defined\n");
+		retval = -ENXIO;
+		goto out_free;
+	}
+
+	ssc->pdev = pdev;
+	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!ssc->regs) {
+		dev_dbg(&pdev->dev, "ioremap failed\n");
+		retval = -EINVAL;
+		goto out_clk;
+	}
+
+	/* disable all interrupts */
+	clk_enable(ssc->clk);
+	ssc_writel(ssc->regs, IDR, ~0UL);
+	ssc_readl(ssc->regs, SR);
+	clk_disable(ssc->clk);
+
+	ssc->irq = platform_get_irq(pdev, 0);
+	if (!ssc->irq) {
+		dev_dbg(&pdev->dev, "could not get irq\n");
+		retval = -ENXIO;
+		goto out_unmap;
+	}
+
+	spin_lock(&user_lock);
+	list_add_tail(&ssc->list, &ssc_list);
+	spin_unlock(&user_lock);
+
+	platform_set_drvdata(pdev, ssc);
+
+	dev_info(&pdev->dev, "Atmel SSC device at 0x%p (irq %d)\n",
+			ssc->regs, ssc->irq);
+
+	goto out;
+
+out_unmap:
+	iounmap(ssc->regs);
+out_clk:
+	clk_put(ssc->clk);
+out_free:
+	kfree(ssc);
+out:
+	return retval;
+}
+
+static int __devexit ssc_remove(struct platform_device *pdev)
+{
+	struct ssc_device *ssc = platform_get_drvdata(pdev);
+
+	spin_lock(&user_lock);
+	iounmap(ssc->regs);
+	clk_put(ssc->clk);
+	list_del(&ssc->list);
+	kfree(ssc);
+	spin_unlock(&user_lock);
+
+	return 0;
+}
+
+static struct platform_driver ssc_driver = {
+	.remove		= __devexit_p(ssc_remove),
+	.driver		= {
+		.name		= "ssc",
+	},
+};
+
+static int __init ssc_init(void)
+{
+	spin_lock_init(&user_lock);
+	return platform_driver_probe(&ssc_driver, ssc_probe);
+}
+module_init(ssc_init);
+
+static void __exit ssc_exit(void)
+{
+	platform_driver_unregister(&ssc_driver);
+}
+module_exit(ssc_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/atmel-ssc.h b/include/linux/atmel-ssc.h
new file mode 100644
index 0000000..5a4dfc4
--- /dev/null
+++ b/include/linux/atmel-ssc.h
@@ -0,0 +1,312 @@
+#ifndef __INCLUDE_ATMEL_SSC_H
+#define __INCLUDE_ATMEL_SSC_H
+
+#include <linux/platform_device.h>
+#include <linux/list.h>
+
+struct ssc_device {
+	struct list_head	list;
+	void __iomem		*regs;
+	struct platform_device	*pdev;
+	struct clk		*clk;
+	int			user;
+	int			irq;
+};
+
+struct ssc_device * __must_check ssc_request(unsigned int ssc_num);
+void ssc_free(struct ssc_device *ssc);
+
+/* SSC register offsets */
+
+/* SSC Control Register */
+#define SSC_CR				0x00000000
+#define SSC_CR_RXDIS_SIZE			 1
+#define SSC_CR_RXDIS_OFFSET			 1
+#define SSC_CR_RXEN_SIZE			 1
+#define SSC_CR_RXEN_OFFSET			 0
+#define SSC_CR_SWRST_SIZE			 1
+#define SSC_CR_SWRST_OFFSET			15
+#define SSC_CR_TXDIS_SIZE			 1
+#define SSC_CR_TXDIS_OFFSET			 9
+#define SSC_CR_TXEN_SIZE			 1
+#define SSC_CR_TXEN_OFFSET			 8
+
+/* SSC Clock Mode Register */
+#define SSC_CMR				0x00000004
+#define SSC_CMR_DIV_SIZE			12
+#define SSC_CMR_DIV_OFFSET			 0
+
+/* SSC Receive Clock Mode Register */
+#define SSC_RCMR			0x00000010
+#define SSC_RCMR_CKG_SIZE			 2
+#define SSC_RCMR_CKG_OFFSET			 6
+#define SSC_RCMR_CKI_SIZE			 1
+#define SSC_RCMR_CKI_OFFSET			 5
+#define SSC_RCMR_CKO_SIZE			 3
+#define SSC_RCMR_CKO_OFFSET			 2
+#define SSC_RCMR_CKS_SIZE			 2
+#define SSC_RCMR_CKS_OFFSET			 0
+#define SSC_RCMR_PERIOD_SIZE			 8
+#define SSC_RCMR_PERIOD_OFFSET			24
+#define SSC_RCMR_START_SIZE			 4
+#define SSC_RCMR_START_OFFSET			 8
+#define SSC_RCMR_STOP_SIZE			 1
+#define SSC_RCMR_STOP_OFFSET			12
+#define SSC_RCMR_STTDLY_SIZE			 8
+#define SSC_RCMR_STTDLY_OFFSET			16
+
+/* SSC Receive Frame Mode Register */
+#define SSC_RFMR			0x00000014
+#define SSC_RFMR_DATLEN_SIZE			 5
+#define SSC_RFMR_DATLEN_OFFSET			 0
+#define SSC_RFMR_DATNB_SIZE			 4
+#define SSC_RFMR_DATNB_OFFSET			 8
+#define SSC_RFMR_FSEDGE_SIZE			 1
+#define SSC_RFMR_FSEDGE_OFFSET			24
+#define SSC_RFMR_FSLEN_SIZE			 4
+#define SSC_RFMR_FSLEN_OFFSET			16
+#define SSC_RFMR_FSOS_SIZE			 4
+#define SSC_RFMR_FSOS_OFFSET			20
+#define SSC_RFMR_LOOP_SIZE			 1
+#define SSC_RFMR_LOOP_OFFSET			 5
+#define SSC_RFMR_MSBF_SIZE			 1
+#define SSC_RFMR_MSBF_OFFSET			 7
+
+/* SSC Transmit Clock Mode Register */
+#define SSC_TCMR			0x00000018
+#define SSC_TCMR_CKG_SIZE			 2
+#define SSC_TCMR_CKG_OFFSET			 6
+#define SSC_TCMR_CKI_SIZE			 1
+#define SSC_TCMR_CKI_OFFSET			 5
+#define SSC_TCMR_CKO_SIZE			 3
+#define SSC_TCMR_CKO_OFFSET			 2
+#define SSC_TCMR_CKS_SIZE			 2
+#define SSC_TCMR_CKS_OFFSET			 0
+#define SSC_TCMR_PERIOD_SIZE			 8
+#define SSC_TCMR_PERIOD_OFFSET			24
+#define SSC_TCMR_START_SIZE			 4
+#define SSC_TCMR_START_OFFSET			 8
+#define SSC_TCMR_STTDLY_SIZE			 8
+#define SSC_TCMR_STTDLY_OFFSET			16
+
+/* SSC Transmit Frame Mode Register */
+#define SSC_TFMR			0x0000001c
+#define SSC_TFMR_DATDEF_SIZE			 1
+#define SSC_TFMR_DATDEF_OFFSET			 5
+#define SSC_TFMR_DATLEN_SIZE			 5
+#define SSC_TFMR_DATLEN_OFFSET			 0
+#define SSC_TFMR_DATNB_SIZE			 4
+#define SSC_TFMR_DATNB_OFFSET			 8
+#define SSC_TFMR_FSDEN_SIZE			 1
+#define SSC_TFMR_FSDEN_OFFSET			23
+#define SSC_TFMR_FSEDGE_SIZE			 1
+#define SSC_TFMR_FSEDGE_OFFSET			24
+#define SSC_TFMR_FSLEN_SIZE			 4
+#define SSC_TFMR_FSLEN_OFFSET			16
+#define SSC_TFMR_FSOS_SIZE			 3
+#define SSC_TFMR_FSOS_OFFSET			20
+#define SSC_TFMR_MSBF_SIZE			 1
+#define SSC_TFMR_MSBF_OFFSET			 7
+
+/* SSC Receive Hold Register */
+#define SSC_RHR				0x00000020
+#define SSC_RHR_RDAT_SIZE			32
+#define SSC_RHR_RDAT_OFFSET			 0
+
+/* SSC Transmit Hold Register */
+#define SSC_THR				0x00000024
+#define SSC_THR_TDAT_SIZE			32
+#define SSC_THR_TDAT_OFFSET			 0
+
+/* SSC Receive Sync. Holding Register */
+#define SSC_RSHR			0x00000030
+#define SSC_RSHR_RSDAT_SIZE			16
+#define SSC_RSHR_RSDAT_OFFSET			 0
+
+/* SSC Transmit Sync. Holding Register */
+#define SSC_TSHR			0x00000034
+#define SSC_TSHR_TSDAT_SIZE			16
+#define SSC_TSHR_RSDAT_OFFSET			 0
+
+/* SSC Receive Compare 0 Register */
+#define SSC_RC0R			0x00000038
+#define SSC_RC0R_CP0_SIZE			16
+#define SSC_RC0R_CP0_OFFSET			 0
+
+/* SSC Receive Compare 1 Register */
+#define SSC_RC1R			0x0000003c
+#define SSC_RC1R_CP1_SIZE			16
+#define SSC_RC1R_CP1_OFFSET			 0
+
+/* SSC Status Register */
+#define SSC_SR				0x00000040
+#define SSC_SR_CP0_SIZE				 1
+#define SSC_SR_CP0_OFFSET			 8
+#define SSC_SR_CP1_SIZE				 1
+#define SSC_SR_CP1_OFFSET			 9
+#define SSC_SR_ENDRX_SIZE			 1
+#define SSC_SR_ENDRX_OFFSET			 6
+#define SSC_SR_ENDTX_SIZE			 1
+#define SSC_SR_ENDTX_OFFSET			 2
+#define SSC_SR_OVRUN_SIZE			 1
+#define SSC_SR_OVRUN_OFFSET			 5
+#define SSC_SR_RXBUFF_SIZE			 1
+#define SSC_SR_RXBUFF_OFFSET			 7
+#define SSC_SR_RXEN_SIZE			 1
+#define SSC_SR_RXEN_OFFSET			17
+#define SSC_SR_RXRDY_SIZE			 1
+#define SSC_SR_RXRDY_OFFSET			 4
+#define SSC_SR_RXSYN_SIZE			 1
+#define SSC_SR_RXSYN_OFFSET			11
+#define SSC_SR_TXBUFE_SIZE			 1
+#define SSC_SR_TXBUFE_OFFSET			 3
+#define SSC_SR_TXEMPTY_SIZE			 1
+#define SSC_SR_TXEMPTY_OFFSET			 1
+#define SSC_SR_TXEN_SIZE			 1
+#define SSC_SR_TXEN_OFFSET			16
+#define SSC_SR_TXRDY_SIZE			 1
+#define SSC_SR_TXRDY_OFFSET			 0
+#define SSC_SR_TXSYN_SIZE			 1
+#define SSC_SR_TXSYN_OFFSET			10
+
+/* SSC Interrupt Enable Register */
+#define SSC_IER				0x00000044
+#define SSC_IER_CP0_SIZE			 1
+#define SSC_IER_CP0_OFFSET			 8
+#define SSC_IER_CP1_SIZE			 1
+#define SSC_IER_CP1_OFFSET			 9
+#define SSC_IER_ENDRX_SIZE			 1
+#define SSC_IER_ENDRX_OFFSET			 6
+#define SSC_IER_ENDTX_SIZE			 1
+#define SSC_IER_ENDTX_OFFSET			 2
+#define SSC_IER_OVRUN_SIZE			 1
+#define SSC_IER_OVRUN_OFFSET			 5
+#define SSC_IER_RXBUFF_SIZE			 1
+#define SSC_IER_RXBUFF_OFFSET			 7
+#define SSC_IER_RXRDY_SIZE			 1
+#define SSC_IER_RXRDY_OFFSET			 4
+#define SSC_IER_RXSYN_SIZE			 1
+#define SSC_IER_RXSYN_OFFSET			11
+#define SSC_IER_TXBUFE_SIZE			 1
+#define SSC_IER_TXBUFE_OFFSET			 3
+#define SSC_IER_TXEMPTY_SIZE			 1
+#define SSC_IER_TXEMPTY_OFFSET			 1
+#define SSC_IER_TXRDY_SIZE			 1
+#define SSC_IER_TXRDY_OFFSET			 0
+#define SSC_IER_TXSYN_SIZE			 1
+#define SSC_IER_TXSYN_OFFSET			10
+
+/* SSC Interrupt Disable Register */
+#define SSC_IDR				0x00000048
+#define SSC_IDR_CP0_SIZE			 1
+#define SSC_IDR_CP0_OFFSET			 8
+#define SSC_IDR_CP1_SIZE			 1
+#define SSC_IDR_CP1_OFFSET			 9
+#define SSC_IDR_ENDRX_SIZE			 1
+#define SSC_IDR_ENDRX_OFFSET			 6
+#define SSC_IDR_ENDTX_SIZE			 1
+#define SSC_IDR_ENDTX_OFFSET			 2
+#define SSC_IDR_OVRUN_SIZE			 1
+#define SSC_IDR_OVRUN_OFFSET			 5
+#define SSC_IDR_RXBUFF_SIZE			 1
+#define SSC_IDR_RXBUFF_OFFSET			 7
+#define SSC_IDR_RXRDY_SIZE			 1
+#define SSC_IDR_RXRDY_OFFSET			 4
+#define SSC_IDR_RXSYN_SIZE			 1
+#define SSC_IDR_RXSYN_OFFSET			11
+#define SSC_IDR_TXBUFE_SIZE			 1
+#define SSC_IDR_TXBUFE_OFFSET			 3
+#define SSC_IDR_TXEMPTY_SIZE			 1
+#define SSC_IDR_TXEMPTY_OFFSET			 1
+#define SSC_IDR_TXRDY_SIZE			 1
+#define SSC_IDR_TXRDY_OFFSET			 0
+#define SSC_IDR_TXSYN_SIZE			 1
+#define SSC_IDR_TXSYN_OFFSET			10
+
+/* SSC Interrupt Mask Register */
+#define SSC_IMR				0x0000004c
+#define SSC_IMR_CP0_SIZE			 1
+#define SSC_IMR_CP0_OFFSET			 8
+#define SSC_IMR_CP1_SIZE			 1
+#define SSC_IMR_CP1_OFFSET			 9
+#define SSC_IMR_ENDRX_SIZE			 1
+#define SSC_IMR_ENDRX_OFFSET			 6
+#define SSC_IMR_ENDTX_SIZE			 1
+#define SSC_IMR_ENDTX_OFFSET			 2
+#define SSC_IMR_OVRUN_SIZE			 1
+#define SSC_IMR_OVRUN_OFFSET			 5
+#define SSC_IMR_RXBUFF_SIZE			 1
+#define SSC_IMR_RXBUFF_OFFSET			 7
+#define SSC_IMR_RXRDY_SIZE			 1
+#define SSC_IMR_RXRDY_OFFSET			 4
+#define SSC_IMR_RXSYN_SIZE			 1
+#define SSC_IMR_RXSYN_OFFSET			11
+#define SSC_IMR_TXBUFE_SIZE			 1
+#define SSC_IMR_TXBUFE_OFFSET			 3
+#define SSC_IMR_TXEMPTY_SIZE			 1
+#define SSC_IMR_TXEMPTY_OFFSET			 1
+#define SSC_IMR_TXRDY_SIZE			 1
+#define SSC_IMR_TXRDY_OFFSET			 0
+#define SSC_IMR_TXSYN_SIZE			 1
+#define SSC_IMR_TXSYN_OFFSET			10
+
+/* SSC PDC Receive Pointer Register */
+#define SSC_PDC_RPR			0x00000100
+
+/* SSC PDC Receive Counter Register */
+#define SSC_PDC_RCR			0x00000104
+
+/* SSC PDC Transmit Pointer Register */
+#define SSC_PDC_TPR			0x00000108
+
+/* SSC PDC Receive Next Pointer Register */
+#define SSC_PDC_RNPR			0x00000110
+
+/* SSC PDC Receive Next Counter Register */
+#define SSC_PDC_RNCR			0x00000114
+
+/* SSC PDC Transmit Counter Register */
+#define SSC_PDC_TCR			0x0000010c
+
+/* SSC PDC Transmit Next Pointer Register */
+#define SSC_PDC_TNPR			0x00000118
+
+/* SSC PDC Transmit Next Counter Register */
+#define SSC_PDC_TNCR			0x0000011c
+
+/* SSC PDC Transfer Control Register */
+#define SSC_PDC_PTCR			0x00000120
+#define SSC_PDC_PTCR_RXTDIS_SIZE		 1
+#define SSC_PDC_PTCR_RXTDIS_OFFSET		 1
+#define SSC_PDC_PTCR_RXTEN_SIZE			 1
+#define SSC_PDC_PTCR_RXTEN_OFFSET		 0
+#define SSC_PDC_PTCR_TXTDIS_SIZE		 1
+#define SSC_PDC_PTCR_TXTDIS_OFFSET		 9
+#define SSC_PDC_PTCR_TXTEN_SIZE			 1
+#define SSC_PDC_PTCR_TXTEN_OFFSET		 8
+
+/* SSC PDC Transfer Status Register */
+#define SSC_PDC_PTSR			0x00000124
+#define SSC_PDC_PTSR_RXTEN_SIZE			 1
+#define SSC_PDC_PTSR_RXTEN_OFFSET		 0
+#define SSC_PDC_PTSR_TXTEN_SIZE			 1
+#define SSC_PDC_PTSR_TXTEN_OFFSET		 8
+
+/* Bit manipulation macros */
+#define SSC_BIT(name)					\
+	(1 << SSC_##name##_OFFSET)
+#define SSC_BF(name, value)				\
+	(((value) & ((1 << SSC_##name##_SIZE) - 1))	\
+	 << SSC_##name##_OFFSET)
+#define SSC_BFEXT(name, value)				\
+	(((value) >> SSC_##name##_OFFSET)		\
+	 & ((1 << SSC_##name##_SIZE) - 1))
+#define SSC_BFINS(name, value, old)			\
+	(((old) & ~(((1 << SSC_##name##_SIZE) - 1)	\
+	<< SSC_##name##_OFFSET)) | SSC_BF(name, value))
+
+/* Register access macros */
+#define ssc_readl(base, reg)		__raw_readl(base + SSC_##reg)
+#define ssc_writel(base, reg, value)	__raw_writel((value), base + SSC_##reg)
+
+#endif /* __INCLUDE_ATMEL_SSC_H */
-- 
1.5.2.3

-- 
With kind regards,

Hans-Christian Egtvedt, siv.ing. (M.Sc.)
Applications Engineer - AVR32 System Solutions - Atmel Norway
