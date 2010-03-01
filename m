Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0CAKyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:54:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0CAKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:54:31 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 1/6] mc13783: rename mc13783_{{un,}mask,ack_irq} to have a mc13783_irq prefix
Date: Mon,  1 Mar 2010 11:53:40 +0100
Message-Id: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the source file group these functions together.

The mc13783 header file provides fallback implementations for the old names
to prevent build failures.  When all users of the old names are fixed to
use the new names these can go away.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c  |   38 +++++++++++++++++++-------------------
 include/linux/mfd/mc13783.h |   24 +++++++++++++++++++++---
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index a1ade23..f89d12d 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -225,7 +225,7 @@ int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 }
 EXPORT_SYMBOL(mc13783_reg_rmw);
 
-int mc13783_mask(struct mc13783 *mc13783, int irq)
+int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
@@ -245,9 +245,9 @@ int mc13783_mask(struct mc13783 *mc13783, int irq)
 
 	return mc13783_reg_write(mc13783, offmask, mask | irqbit);
 }
-EXPORT_SYMBOL(mc13783_mask);
+EXPORT_SYMBOL(mc13783_irq_mask);
 
-int mc13783_unmask(struct mc13783 *mc13783, int irq)
+int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
@@ -267,7 +267,18 @@ int mc13783_unmask(struct mc13783 *mc13783, int irq)
 
 	return mc13783_reg_write(mc13783, offmask, mask & ~irqbit);
 }
-EXPORT_SYMBOL(mc13783_unmask);
+EXPORT_SYMBOL(mc13783_irq_unmask);
+
+int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
+{
+	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
+	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
+
+	BUG_ON(irq < 0 || irq >= MC13783_NUM_IRQ);
+
+	return mc13783_reg_write(mc13783, offstat, val);
+}
+EXPORT_SYMBOL(mc13783_irq_ack);
 
 int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
 		irq_handler_t handler, const char *name, void *dev)
@@ -297,7 +308,7 @@ int mc13783_irq_request(struct mc13783 *mc13783, int irq,
 	if (ret)
 		return ret;
 
-	ret = mc13783_unmask(mc13783, irq);
+	ret = mc13783_irq_unmask(mc13783, irq);
 	if (ret) {
 		mc13783->irqhandler[irq] = NULL;
 		mc13783->irqdata[irq] = NULL;
@@ -317,7 +328,7 @@ int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev)
 			mc13783->irqdata[irq] != dev)
 		return -EINVAL;
 
-	ret = mc13783_mask(mc13783, irq);
+	ret = mc13783_irq_mask(mc13783, irq);
 	if (ret)
 		return ret;
 
@@ -333,17 +344,6 @@ static inline irqreturn_t mc13783_irqhandler(struct mc13783 *mc13783, int irq)
 	return mc13783->irqhandler[irq](irq, mc13783->irqdata[irq]);
 }
 
-int mc13783_ackirq(struct mc13783 *mc13783, int irq)
-{
-	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
-	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
-
-	BUG_ON(irq < 0 || irq >= MC13783_NUM_IRQ);
-
-	return mc13783_reg_write(mc13783, offstat, val);
-}
-EXPORT_SYMBOL(mc13783_ackirq);
-
 /*
  * returns: number of handled irqs or negative error
  * locking: holds mc13783->lock
@@ -422,7 +422,7 @@ static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
 {
 	struct mc13783_adcdone_data *adcdone_data = data;
 
-	mc13783_ackirq(adcdone_data->mc13783, irq);
+	mc13783_irq_ack(adcdone_data->mc13783, irq);
 
 	complete_all(&adcdone_data->done);
 
@@ -486,7 +486,7 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
 	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
 			mc13783_handler_adcdone, __func__, &adcdone_data);
-	mc13783_ackirq(mc13783, MC13783_IRQ_ADCDONE);
+	mc13783_irq_ack(mc13783, MC13783_IRQ_ADCDONE);
 
 	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
 	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 3568040..05619f0 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -26,10 +26,28 @@ int mc13783_irq_request(struct mc13783 *mc13783, int irq,
 int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
 		irq_handler_t handler, const char *name, void *dev);
 int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev);
-int mc13783_ackirq(struct mc13783 *mc13783, int irq);
 
-int mc13783_mask(struct mc13783 *mc13783, int irq);
-int mc13783_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_mask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
+
+static inline int mc13783_mask(struct mc13783 *mc13783, int irq) __deprecated;
+static inline int mc13783_mask(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_mask(mc13783, irq);
+}
+
+static inline int mc13783_unmask(struct mc13783 *mc13783, int irq) __deprecated;
+static inline int mc13783_unmask(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_unmask(mc13783, irq);
+}
+
+static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq) __deprecated;
+static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_ack(mc13783, irq);
+}
 
 #define MC13783_ADC0		43
 #define MC13783_ADC0_ADREFEN		(1 << 10)
-- 
1.7.0

