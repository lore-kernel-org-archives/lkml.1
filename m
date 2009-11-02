Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbZKBU5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbZKBU5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbZKBU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:57:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbZKBU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:57:12 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd/mc13783: change type of irq handlers to irq_handler_t
Date: Mon,  2 Nov 2009 21:56:25 +0100
Message-Id: <1257195385-15595-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <20091102115101.GF29351@sirena.org.uk>
References: <20091102115101.GF29351@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Hello,

now I changed the signature of the mc13783 irq handlers to irq_handler_t
as suggested by Mark Brown.

For easier review you can find the incremental diff below.  If this is
considered OK, I'd squash it into the original commits (all but the
drivers/rtc/rtc-mc13783.c bits into "mfd/mc13783: near complete
rewrite", and drivers/rtc/rtc-mc13783.c into "Add Freescale MC13783 RTC
driver").

The patch is that big as I had to change the irq variable to int (from
unsigned) and so had to update some conditions to check the irq to be in
range.  The last few hunks in drivers/mfd/mc13783-core.c are necessary
to make the mc13783 struct available to the irq handler.

Best regards
Uwe

 drivers/mfd/mc13783-core.c          |   65 ++++++++++++++++++++---------------
 drivers/rtc/rtc-mc13783.c           |    8 ++--
 include/linux/mfd/mc13783-private.h |    3 +-
 include/linux/mfd/mc13783.h         |   18 ++++-----
 4 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index 63a5104..90644d9 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -268,13 +268,16 @@ int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 }
 EXPORT_SYMBOL(mc13783_reg_rmw);
 
-int mc13783_mask(struct mc13783 *mc13783, unsigned int irq)
+int mc13783_mask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
 	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
 	u32 mask;
 
+	if (irq < 0 || irq >= MC13783_NUM_IRQ)
+		return -EINVAL;
+
 	ret = mc13783_reg_read(mc13783, offmask, &mask);
 	if (ret)
 		return ret;
@@ -287,13 +290,16 @@ int mc13783_mask(struct mc13783 *mc13783, unsigned int irq)
 }
 EXPORT_SYMBOL(mc13783_mask);
 
-int mc13783_unmask(struct mc13783 *mc13783, unsigned int irq)
+int mc13783_unmask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
 	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
 	u32 mask;
 
+	if (irq < 0 || irq >= MC13783_NUM_IRQ)
+		return -EINVAL;
+
 	ret = mc13783_reg_read(mc13783, offmask, &mask);
 	if (ret)
 		return ret;
@@ -306,14 +312,13 @@ int mc13783_unmask(struct mc13783 *mc13783, unsigned int irq)
 }
 EXPORT_SYMBOL(mc13783_unmask);
 
-int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
-		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
-		const char *name, void *dev)
+int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev)
 {
 	BUG_ON(!mutex_is_locked(&mc13783->lock));
 	BUG_ON(!handler);
 
-	if (irq >= MC13783_NUM_IRQ)
+	if (irq < 0 || irq >= MC13783_NUM_IRQ)
 		return -EINVAL;
 
 	if (mc13783->irqhandler[irq])
@@ -326,9 +331,8 @@ int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
 }
 EXPORT_SYMBOL(mc13783_irq_request_nounmask);
 
-int mc13783_irq_request(struct mc13783 *mc13783, unsigned int irq,
-		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
-		const char *name, void *dev)
+int mc13783_irq_request(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev)
 {
 	int ret;
 
@@ -347,12 +351,12 @@ int mc13783_irq_request(struct mc13783 *mc13783, unsigned int irq,
 }
 EXPORT_SYMBOL(mc13783_irq_request);
 
-int mc13783_irq_free(struct mc13783 *mc13783, unsigned int irq, void *dev)
+int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev)
 {
 	int ret;
 	BUG_ON(!mutex_is_locked(&mc13783->lock));
 
-	if (irq >= MC13783_NUM_IRQ || !mc13783->irqhandler[irq] ||
+	if (irq < 0 || irq >= MC13783_NUM_IRQ || !mc13783->irqhandler[irq] ||
 			mc13783->irqdata[irq] != dev)
 		return -EINVAL;
 
@@ -367,18 +371,17 @@ int mc13783_irq_free(struct mc13783 *mc13783, unsigned int irq, void *dev)
 }
 EXPORT_SYMBOL(mc13783_irq_free);
 
-static inline irqreturn_t mc13783_irqhandler(struct mc13783 *mc13783,
-		unsigned int irq)
+static inline irqreturn_t mc13783_irqhandler(struct mc13783 *mc13783, int irq)
 {
-	return mc13783->irqhandler[irq](mc13783, irq, mc13783->irqdata[irq]);
+	return mc13783->irqhandler[irq](irq, mc13783->irqdata[irq]);
 }
 
-int mc13783_ackirq(struct mc13783 *mc13783, unsigned int irq)
+int mc13783_ackirq(struct mc13783 *mc13783, int irq)
 {
 	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
 	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
 
-	BUG_ON(irq >= MC13783_NUM_IRQ);
+	BUG_ON(irq < 0 || irq >= MC13783_NUM_IRQ);
 
 	return mc13783_reg_write(mc13783, offstat, val);
 }
@@ -389,8 +392,7 @@ EXPORT_SYMBOL(mc13783_ackirq);
  * locking: holds mc13783->lock
  */
 static int mc13783_irq_handle(struct mc13783 *mc13783,
-		unsigned int offstat, unsigned int offmask,
-		unsigned int baseirq)
+		unsigned int offstat, unsigned int offmask, int baseirq)
 {
 	u32 stat, mask;
 	int ret = mc13783_reg_read(mc13783, offstat, &stat);
@@ -404,7 +406,7 @@ static int mc13783_irq_handle(struct mc13783 *mc13783,
 		return ret;
 
 	while (stat & ~mask) {
-		unsigned int irq = __ffs(stat & ~mask);
+		int irq = __ffs(stat & ~mask);
 
 		stat &= ~(1 << irq);
 
@@ -454,14 +456,18 @@ static irqreturn_t mc13783_irq_thread(int irq, void *data)
 #define MC13783_ADC1_CHAN0_SHIFT	5
 #define MC13783_ADC1_CHAN1_SHIFT	8
 
-static irqreturn_t mc13783_handler_adcdone(struct mc13783 *mc13783,
-		unsigned int irq, void *data)
+struct mc13783_adcdone_data {
+	struct mc13783 *mc13783;
+	struct completion done;
+};
+
+static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
 {
-	struct completion *done = data;
+	struct mc13783_adcdone_data *adcdone_data = data;
 
-	mc13783_ackirq(mc13783, irq);
+	mc13783_ackirq(adcdone_data->mc13783, irq);
 
-	complete_all(done);
+	complete_all(&adcdone_data->done);
 
 	return IRQ_HANDLED;
 }
@@ -473,8 +479,11 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 {
 	u32 adc0, adc1, old_adc0;
 	int i, ret;
+	struct mc13783_adcdone_data adcdone_data = {
+		.mc13783 = mc13783,
+	};
+	init_completion(&adcdone_data.done);
 
-	DECLARE_COMPLETION_ONSTACK(done);
 	dev_dbg(&mc13783->spidev->dev, "%s\n", __func__);
 
 	mc13783_lock(mc13783);
@@ -522,18 +531,18 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 
 	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
 	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
-			mc13783_handler_adcdone, __func__, &done);
+			mc13783_handler_adcdone, __func__, &adcdone_data);
 
 	mc13783_unlock(mc13783);
 
-	ret = wait_for_completion_interruptible_timeout(&done, HZ);
+	ret = wait_for_completion_interruptible_timeout(&adcdone_data.done, HZ);
 
 	if (!ret)
 		ret = -ETIMEDOUT;
 
 	mc13783_lock(mc13783);
 
-	mc13783_irq_free(mc13783, MC13783_IRQ_ADCDONE, &done);
+	mc13783_irq_free(mc13783, MC13783_IRQ_ADCDONE, &adcdone_data);
 
 	if (mode == MC13783_ADC_MODE_TS)
 		/* restore TSMOD */
diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index 7a1019e..1a4615b 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -114,10 +114,10 @@ out:
 	return ret;
 }
 
-static irqreturn_t mc13783_rtc_update_handler(struct mc13783 *mc13783,
-		unsigned int irq, void *dev)
+static irqreturn_t mc13783_rtc_update_handler(unsigned int irq, void *dev)
 {
 	struct mc13783_rtc *priv = dev;
+	struct mc13783 *mc13783 = priv->mc13783;
 
 	dev_dbg(&priv->rtc->dev, "1HZ\n");
 
@@ -152,10 +152,10 @@ static const struct rtc_class_ops mc13783_rtc_ops = {
 	.update_irq_enable = mc13783_rtc_update_irq_enable,
 };
 
-static irqreturn_t mc13783_rtc_reset_handler(struct mc13783 *mc13783,
-		unsigned int irq, void *dev)
+static irqreturn_t mc13783_rtc_reset_handler(unsigned int irq, void *dev)
 {
 	struct mc13783_rtc *priv = dev;
+	struct mc13783 *mc13783 = priv->mc13783;
 
 	dev_dbg(&priv->rtc->dev, "RTCRST\n");
 	priv->valid = 0;
diff --git a/include/linux/mfd/mc13783-private.h b/include/linux/mfd/mc13783-private.h
index c5eca82..75a1f47 100644
--- a/include/linux/mfd/mc13783-private.h
+++ b/include/linux/mfd/mc13783-private.h
@@ -33,8 +33,7 @@ struct mc13783 {
 	int irq;
 	int flags;
 
-	irqreturn_t (*irqhandler[MC13783_NUM_IRQ])(struct mc13783 *,
-			unsigned int, void *);
+	irq_handler_t irqhandler[MC13783_NUM_IRQ];
 	void *irqdata[MC13783_NUM_IRQ];
 
 	/* XXX these should go as platformdata to the regulator subdevice */
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 910d5cf..3568040 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -21,17 +21,15 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val);
 int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 		u32 mask, u32 val);
 
-int mc13783_irq_request(struct mc13783 *mc13783, unsigned int irq,
-		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
-		const char *name, void *dev);
-int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
-		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
-		const char *name, void *dev);
-int mc13783_irq_free(struct mc13783 *mc13783, unsigned int irq, void *dev);
-int mc13783_ackirq(struct mc13783 *mc13783, unsigned int irq);
-
-int mc13783_mask(struct mc13783 *mc13783, unsigned int irq);
-int mc13783_unmask(struct mc13783 *mc13783, unsigned int irq);
+int mc13783_irq_request(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev);
+int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev);
+int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev);
+int mc13783_ackirq(struct mc13783 *mc13783, int irq);
+
+int mc13783_mask(struct mc13783 *mc13783, int irq);
+int mc13783_unmask(struct mc13783 *mc13783, int irq);
 
 #define MC13783_ADC0		43
 #define MC13783_ADC0_ADREFEN		(1 << 10)
-- 
1.6.5

