Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYLNLgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYLNLgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYLNLf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:29 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34171 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYLNLf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:27 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 2/7] mfd: PCF50633 adc driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Date: Sun, 14 Dec 2008 16:32:29 +0530
Message-ID: <20081214110229.3307.8141.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support for the PCF50633 ADC. The subtractive mode
is not supported yet.

Since we don't have adc subsystem, it currently lives in drivers/mfd.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/Kconfig        |    7 +
 drivers/mfd/Makefile       |    1 
 drivers/mfd/pcf50633-adc.c |  263 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pcf50633-adc.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fb1f0f7..02e3d73 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -162,6 +162,13 @@ config MFD_PCF50633
 	  facilities, and registers devices for the various functions
 	  so that function-specific drivers can bind to them.
 
+config PCF50633_ADC
+	tristate "Support for NXP PCF50633 ADC"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support for ADC in the
+	 NXP PCF50633 chip.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6a4add8..7a12b09 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
+obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
new file mode 100644
index 0000000..80e40c6
--- /dev/null
+++ b/drivers/mfd/pcf50633-adc.c
@@ -0,0 +1,263 @@
+/* NXP PCF50633 ADC Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+/*
+ * NOTE: This driver does not yet support subtractive ADC mode, which means
+ * you can do only one measurement per read request.
+ */
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/adc.h>
+
+struct pcf50633_adc_request {
+	int mux;
+	int avg;
+	int result;
+	void (*callback)(struct pcf50633 *, void *, int);
+	void *callback_param;
+
+	/* Used in case of sync requests */
+	struct completion completion;
+
+};
+
+static void adc_read_setup(struct pcf50633 *pcf,
+				 int channel, int avg)
+{
+	channel &= PCF50633_ADCC1_ADCMUX_MASK;
+
+	/* kill ratiometric, but enable ACCSW biasing */
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC2, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x01);
+
+	/* start ADC conversion on selected channel */
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC1, channel | avg |
+		    PCF50633_ADCC1_ADCSTART | PCF50633_ADCC1_RES_10BIT);
+
+}
+
+static void trigger_next_adc_job_if_any(struct pcf50633 *pcf)
+{
+	int head, tail;
+
+	mutex_lock(&pcf->adc.queue_mutex);
+
+	head = pcf->adc.queue_head;
+	tail = pcf->adc.queue_tail;
+
+	if (!pcf->adc.queue[head])
+		goto out;
+
+	adc_read_setup(pcf, pcf->adc.queue[head]->mux,
+				pcf->adc.queue[head]->avg);
+out:
+	mutex_unlock(&pcf->adc.queue_mutex);
+}
+
+static int
+adc_enqueue_request(struct pcf50633 *pcf, struct pcf50633_adc_request *req)
+{
+	int head, tail;
+
+	mutex_lock(&pcf->adc.queue_mutex);
+
+	head = pcf->adc.queue_head;
+	tail = pcf->adc.queue_tail;
+
+	if (pcf->adc.queue[tail]) {
+		mutex_unlock(&pcf->adc.queue_mutex);
+		return -EBUSY;
+	}
+
+	pcf->adc.queue[tail] = req;
+	pcf->adc.queue_tail =
+		(tail + 1) & (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
+
+	mutex_unlock(&pcf->adc.queue_mutex);
+
+	trigger_next_adc_job_if_any(pcf);
+
+	return 0;
+}
+
+static void
+pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param, int result)
+{
+	struct pcf50633_adc_request *req;
+
+	/*We know here that the passed param is an adc_request object */
+	req = param;
+
+	req->result = result;
+	complete(&req->completion);
+}
+
+int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
+{
+
+	struct pcf50633_adc_request *req;
+
+	/* req is freed when the result is ready, in interrupt handler */
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->mux = mux;
+	req->avg = avg;
+	req->callback =  pcf50633_adc_sync_read_callback;
+	req->callback_param = req;
+
+	init_completion(&req->completion);
+	adc_enqueue_request(pcf, req);
+	wait_for_completion(&req->completion);
+
+	return req->result;
+}
+EXPORT_SYMBOL_GPL(pcf50633_adc_sync_read);
+
+int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
+			     void (*callback)(struct pcf50633 *, void *, int),
+			     void *callback_param)
+{
+	struct pcf50633_adc_request *req;
+
+	/* req is freed when the result is ready, in interrupt handler */
+	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->mux = mux;
+	req->avg = avg;
+	req->callback = callback;
+	req->callback_param = callback_param;
+
+	adc_enqueue_request(pcf, req);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
+
+static int adc_result(struct pcf50633 *pcf)
+{
+	u8 adcs1, adcs3;
+	u16 result;
+
+	adcs1 = pcf50633_reg_read(pcf, PCF50633_REG_ADCS1);
+	adcs3 = pcf50633_reg_read(pcf, PCF50633_REG_ADCS3);
+	result = (adcs1 << 2) | (adcs3 & PCF50633_ADCS3_ADCDAT1L_MASK);
+
+	dev_dbg(pcf->dev, "adc result = %d\n", result);
+
+	return result;
+}
+
+static void pcf50633_adc_irq(struct pcf50633 *pcf, int irq, void *unused)
+{
+	struct pcf50633_adc_request *req;
+	int head;
+
+	mutex_lock(&pcf->adc.queue_mutex);
+	head = pcf->adc.queue_head;
+
+	req = pcf->adc.queue[head];
+	if (!req) {
+		dev_err(pcf->dev, "pcf50633-adc irq: ADC queue empty\n");
+		mutex_unlock(&pcf->adc.queue_mutex);
+		return;
+	}
+	pcf->adc.queue[head] = NULL;
+	pcf->adc.queue_head = (head + 1) &
+				      (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
+
+	mutex_unlock(&pcf->adc.queue_mutex);
+	req->callback(pcf, req->callback_param, adc_result(pcf));
+
+	kfree(req);
+
+	trigger_next_adc_job_if_any(pcf);
+}
+
+int __init pcf50633_adc_probe(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf;
+
+	pcf = platform_get_drvdata(pdev);
+
+	/* Set up IRQ handlers */
+	pcf->irq_handler[PCF50633_IRQ_ADCRDY].handler = pcf50633_adc_irq;
+
+	mutex_init(&pcf->adc.queue_mutex);
+
+	return 0;
+}
+
+static int __devexit pcf50633_adc_remove(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf;
+	int i, head;
+
+	pcf = platform_get_drvdata(pdev);
+	pcf->irq_handler[PCF50633_IRQ_ADCRDY].handler = NULL;
+
+	mutex_lock(&pcf->adc.queue_mutex);
+
+	head = pcf->adc.queue_head;
+
+	if (pcf->adc.queue[head])
+		dev_err(pcf->dev, "adc driver removed with request pending\n");
+
+	for (i = 0; i < PCF50633_MAX_ADC_FIFO_DEPTH; i++)
+		kfree(pcf->adc.queue[i]);
+
+	mutex_unlock(&pcf->adc.queue_mutex);
+
+	return 0;
+}
+
+struct platform_driver pcf50633_adc_driver = {
+	.driver = {
+		.name = "pcf50633-adc",
+	},
+	.probe = pcf50633_adc_probe,
+	.remove = __devexit_p(pcf50633_adc_remove),
+};
+
+static int __init pcf50633_adc_init(void)
+{
+		return platform_driver_register(&pcf50633_adc_driver);
+}
+module_init(pcf50633_adc_init);
+
+static void __exit pcf50633_adc_exit(void)
+{
+		platform_driver_unregister(&pcf50633_adc_driver);
+}
+module_exit(pcf50633_adc_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 adc driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-adc");
+

