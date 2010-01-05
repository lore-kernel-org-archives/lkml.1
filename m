Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496Ab0AEN7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0AEN7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447Ab0AEN7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:59:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60545 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754444Ab0AEN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:59:41 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] mfd: Convert WM8350 to genirq
Date: Tue,  5 Jan 2010 13:59:09 +0000
Message-Id: <1262699949-3079-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262699949-3079-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20100105135756.GA2993@rakim.wolfsonmicro.main>
 <1262699949-3079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1262699949-3079-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1262699949-3079-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives us use of the diagnostic facilities genirq provides and
will allow implementation of interrupt support for the WM8350 GPIOs.
Stub functions are provided to ease the transition of the individual
drivers, probably after additional work to pass the IRQ numbers via
the struct devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c        |  155 ++++++++++++++++++++++-----------------
 include/linux/mfd/wm8350/core.h |   44 ++++++++---
 2 files changed, 118 insertions(+), 81 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 655836b..f56c9ad 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -18,7 +18,7 @@
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-#include <linux/workqueue.h>
+#include <linux/irq.h>
 
 #include <linux/mfd/wm8350/core.h>
 #include <linux/mfd/wm8350/audio.h>
@@ -29,8 +29,6 @@
 #include <linux/mfd/wm8350/supply.h>
 #include <linux/mfd/wm8350/wdt.h>
 
-#define WM8350_NUM_IRQ_REGS 7
-
 #define WM8350_INT_OFFSET_1                     0
 #define WM8350_INT_OFFSET_2                     1
 #define WM8350_POWER_UP_INT_OFFSET              2
@@ -366,19 +364,10 @@ static struct wm8350_irq_data wm8350_irqs[] = {
 	},
 };
 
-static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
+static inline struct wm8350_irq_data *irq_to_wm8350_irq(struct wm8350 *wm8350,
+							int irq)
 {
-	mutex_lock(&wm8350->irq_mutex);
-
-	if (wm8350->irq[irq].handler)
-		wm8350->irq[irq].handler(irq, wm8350->irq[irq].data);
-	else {
-		dev_err(wm8350->dev, "irq %d nobody cared. now masked.\n",
-			irq);
-		wm8350_mask_irq(wm8350, irq);
-	}
-
-	mutex_unlock(&wm8350->irq_mutex);
+	return &wm8350_irqs[irq - wm8350->irq_base];
 }
 
 /*
@@ -386,7 +375,9 @@ static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
  * interrupts are clear on read the IRQ line will be reasserted and
  * the physical IRQ will be handled again if another interrupt is
  * asserted while we run - in the normal course of events this is a
- * rare occurrence so we save I2C/SPI reads.
+ * rare occurrence so we save I2C/SPI reads.  We're also assuming that
+ * it's rare to get lots of interrupts firing simultaneously so try to
+ * minimise I/O.
  */
 static irqreturn_t wm8350_irq(int irq, void *irq_data)
 {
@@ -397,7 +388,6 @@ static irqreturn_t wm8350_irq(int irq, void *irq_data)
 	struct wm8350_irq_data *data;
 	int i;
 
-	/* TODO: Use block reads to improve performance? */
 	level_one = wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS)
 		& ~wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK);
 
@@ -416,93 +406,101 @@ static irqreturn_t wm8350_irq(int irq, void *irq_data)
 			sub_reg[data->reg] =
 				wm8350_reg_read(wm8350, WM8350_INT_STATUS_1 +
 						data->reg);
-			sub_reg[data->reg] &=
-				~wm8350_reg_read(wm8350,
-						 WM8350_INT_STATUS_1_MASK +
-						 data->reg);
+			sub_reg[data->reg] &= ~wm8350->irq_masks[data->reg];
 			read_done[data->reg] = 1;
 		}
 
 		if (sub_reg[data->reg] & data->mask)
-			wm8350_irq_call_handler(wm8350, i);
+			handle_nested_irq(wm8350->irq_base + i);
 	}
 
 	return IRQ_HANDLED;
 }
 
-int wm8350_register_irq(struct wm8350 *wm8350, int irq,
-			irq_handler_t handler, unsigned long flags,
-			const char *name, void *data)
+static void wm8350_irq_lock(unsigned int irq)
 {
-	if (irq < 0 || irq >= WM8350_NUM_IRQ || !handler)
-		return -EINVAL;
-
-	if (wm8350->irq[irq].handler)
-		return -EBUSY;
-
-	mutex_lock(&wm8350->irq_mutex);
-	wm8350->irq[irq].handler = handler;
-	wm8350->irq[irq].data = data;
-	mutex_unlock(&wm8350->irq_mutex);
-
-	wm8350_unmask_irq(wm8350, irq);
+	struct wm8350 *wm8350 = get_irq_chip_data(irq);
 
-	return 0;
+	mutex_lock(&wm8350->irq_lock);
 }
-EXPORT_SYMBOL_GPL(wm8350_register_irq);
 
-int wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data)
+static void wm8350_irq_sync_unlock(unsigned int irq)
 {
-	if (irq < 0 || irq >= WM8350_NUM_IRQ)
-		return -EINVAL;
+	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	int i;
 
-	wm8350_mask_irq(wm8350, irq);
+	for (i = 0; i < ARRAY_SIZE(wm8350->irq_masks); i++) {
+		/* If there's been a change in the mask write it back
+		 * to the hardware. */
+		if (wm8350->irq_masks[i] !=
+		    wm8350->reg_cache[WM8350_INT_STATUS_1_MASK + i])
+			WARN_ON(wm8350_reg_write(wm8350,
+					 WM8350_INT_STATUS_1_MASK + i,
+						 wm8350->irq_masks[i]));
+	}
 
-	mutex_lock(&wm8350->irq_mutex);
-	wm8350->irq[irq].handler = NULL;
-	mutex_unlock(&wm8350->irq_mutex);
-	return 0;
+	mutex_unlock(&wm8350->irq_lock);
 }
-EXPORT_SYMBOL_GPL(wm8350_free_irq);
 
-int wm8350_mask_irq(struct wm8350 *wm8350, int irq)
+static void wm8350_irq_enable(unsigned int irq)
 {
-	return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK +
-			       wm8350_irqs[irq].reg,
-			       wm8350_irqs[irq].mask);
+	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+
+	wm8350->irq_masks[irq_data->reg] &= ~irq_data->mask;
 }
-EXPORT_SYMBOL_GPL(wm8350_mask_irq);
 
-int wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
+static void wm8350_irq_disable(unsigned int irq)
 {
-	return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK +
-				 wm8350_irqs[irq].reg,
-				 wm8350_irqs[irq].mask);
+	struct wm8350 *wm8350 = get_irq_chip_data(irq);
+	struct wm8350_irq_data *irq_data = irq_to_wm8350_irq(wm8350, irq);
+
+	wm8350->irq_masks[irq_data->reg] |= irq_data->mask;
 }
-EXPORT_SYMBOL_GPL(wm8350_unmask_irq);
+
+static struct irq_chip wm8350_irq_chip = {
+	.name = "wm8350",
+	.bus_lock = wm8350_irq_lock,
+	.bus_sync_unlock = wm8350_irq_sync_unlock,
+	.disable = wm8350_irq_disable,
+	.enable = wm8350_irq_enable,
+};
 
 int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 		    struct wm8350_platform_data *pdata)
 {
-	int ret;
+	int ret, cur_irq, i;
 	int flags = IRQF_ONESHOT;
 
 	if (!irq) {
-		dev_err(wm8350->dev, "No IRQ configured\n");
-		return -EINVAL;
+		dev_warn(wm8350->dev, "No interrupt support, no core IRQ\n");
+		return 0;
+	}
+
+	if (!pdata || !pdata->irq_base) {
+		dev_warn(wm8350->dev, "No interrupt support, no IRQ base\n");
+		return 0;
 	}
 
+	/* Mask top level interrupts */
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_INT_STATUS_2_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_GPIO_INT_STATUS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK, 0xFFFF);
 
-	mutex_init(&wm8350->irq_mutex);
+	/* Mask all individual interrupts by default and cache the
+	 * masks.  We read the masks back since there are unwritable
+	 * bits in the mask registers. */
+	for (i = 0; i < ARRAY_SIZE(wm8350->irq_masks); i++) {
+		wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK + i,
+				 0xFFFF);
+		wm8350->irq_masks[i] =
+			wm8350_reg_read(wm8350,
+					WM8350_INT_STATUS_1_MASK + i);
+	}
+
+	mutex_init(&wm8350->irq_lock);
 	wm8350->chip_irq = irq;
+	wm8350->irq_base = pdata->irq_base;
 
-	if (pdata && pdata->irq_high) {
+	if (pdata->irq_high) {
 		flags |= IRQF_TRIGGER_HIGH;
 
 		wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
@@ -514,11 +512,32 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 				  WM8350_IRQ_POL);
 	}
 
+	/* Register with genirq */
+	for (cur_irq = wm8350->irq_base;
+	     cur_irq < ARRAY_SIZE(wm8350_irqs) + wm8350->irq_base;
+	     cur_irq++) {
+		set_irq_chip_data(cur_irq, wm8350);
+		set_irq_chip_and_handler(cur_irq, &wm8350_irq_chip,
+					 handle_edge_irq);
+		set_irq_nested_thread(cur_irq, 1);
+
+		/* ARM needs us to explicitly flag the IRQ as valid
+		 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		set_irq_noprobe(cur_irq);
+#endif
+	}
+
 	ret = request_threaded_irq(irq, NULL, wm8350_irq, flags,
 				   "wm8350", wm8350);
 	if (ret != 0)
 		dev_err(wm8350->dev, "Failed to request IRQ: %d\n", ret);
 
+	/* Allow interrupts to fire */
+	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0);
+
 	return ret;
 }
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index cfccb4a..fae08aa 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -579,6 +579,8 @@
 
 #define WM8350_NUM_IRQ				63
 
+#define WM8350_NUM_IRQ_REGS 7
+
 struct wm8350_reg_access {
 	u16 readable;		/* Mask of readable bits */
 	u16 writable;		/* Mask of writable bits */
@@ -600,11 +602,6 @@ extern const u16 wm8352_mode3_defaults[];
 
 struct wm8350;
 
-struct wm8350_irq {
-	irq_handler_t handler;
-	void *data;
-};
-
 struct wm8350_hwmon {
 	struct platform_device *pdev;
 	struct device *classdev;
@@ -626,9 +623,10 @@ struct wm8350 {
 	struct mutex auxadc_mutex;
 
 	/* Interrupt handling */
-	struct mutex irq_mutex; /* IRQ table mutex */
-	struct wm8350_irq irq[WM8350_NUM_IRQ];
+	struct mutex irq_lock;
 	int chip_irq;
+	int irq_base;
+	u16 irq_masks[WM8350_NUM_IRQ_REGS];
 
 	/* Client devices */
 	struct wm8350_codec codec;
@@ -679,13 +677,33 @@ int wm8350_block_write(struct wm8350 *wm8350, int reg, int size, u16 *src);
 /*
  * WM8350 internal interrupts
  */
-int wm8350_register_irq(struct wm8350 *wm8350, int irq,
-			irq_handler_t handler, unsigned long flags,
-			const char *name, void *data);
-int wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data);
+static inline int wm8350_register_irq(struct wm8350 *wm8350, int irq,
+				      irq_handler_t handler,
+				      unsigned long flags,
+				      const char *name, void *data)
+{
+	if (!wm8350->irq_base)
+		return -ENODEV;
+
+	return request_threaded_irq(irq + wm8350->irq_base, NULL,
+				    handler, flags, name, data);
+}
+
+static inline void wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data)
+{
+	free_irq(irq + wm8350->irq_base, data);
+}
+
+static inline void wm8350_mask_irq(struct wm8350 *wm8350, int irq)
+{
+	disable_irq(irq + wm8350->irq_base);
+}
+
+static inline void wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
+{
+	enable_irq(irq + wm8350->irq_base);
+}
 
-int wm8350_mask_irq(struct wm8350 *wm8350, int irq);
-int wm8350_unmask_irq(struct wm8350 *wm8350, int irq);
 int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 		    struct wm8350_platform_data *pdata);
 int wm8350_irq_exit(struct wm8350 *wm8350);
-- 
1.6.5.7

