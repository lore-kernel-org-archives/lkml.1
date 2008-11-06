Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYKFNoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYKFNoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYKFNnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:43:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60247 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754114AbYKFNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:43:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] mfd: Add AUXADC support for WM8350
Date: Thu,  6 Nov 2008 13:43:06 +0000
Message-Id: <1225978986-25990-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225978986-25990-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081106134254.GA21855@rakim.wolfsonmicro.main>
 <1225978986-25990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1225978986-25990-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1225978986-25990-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The auxiliary ADC in the WM8350 is shared between several subdevices
so access to it needs to be arbitrated by the core driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c             |   51 ++++++++++++++++++++++++++++++++-
 include/linux/mfd/wm8350/comparator.h |    8 +++++
 include/linux/mfd/wm8350/core.h       |    2 +
 3 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index c013afd..60439bd 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -63,7 +63,6 @@
  */
 static DEFINE_MUTEX(io_mutex);
 static DEFINE_MUTEX(reg_lock_mutex);
-static DEFINE_MUTEX(auxadc_mutex);
 
 /* Perform a physical read from the device.
  */
@@ -1082,6 +1081,55 @@ int wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
 }
 EXPORT_SYMBOL_GPL(wm8350_unmask_irq);
 
+int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
+{
+	u16 reg, result = 0;
+	int tries = 5;
+
+	if (channel < WM8350_AUXADC_AUX1 || channel > WM8350_AUXADC_TEMP)
+		return -EINVAL;
+	if (channel >= WM8350_AUXADC_USB && channel <= WM8350_AUXADC_TEMP
+	    && (scale != 0 || vref != 0))
+		return -EINVAL;
+
+	mutex_lock(&wm8350->auxadc_mutex);
+
+	/* Turn on the ADC */
+	reg = wm8350_reg_read(wm8350, WM8350_POWER_MGMT_5);
+	wm8350_reg_write(wm8350, WM8350_POWER_MGMT_5, reg | WM8350_AUXADC_ENA);
+
+	if (scale || vref) {
+		reg = scale << 13;
+		reg |= vref << 12;
+		wm8350_reg_write(wm8350, WM8350_AUX1_READBACK + channel, reg);
+	}
+
+	reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
+	reg |= 1 << channel | WM8350_AUXADC_POLL;
+	wm8350_reg_write(wm8350, WM8350_DIGITISER_CONTROL_1, reg);
+
+	do {
+		schedule_timeout_interruptible(1);
+		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
+	} while (tries-- && (reg & WM8350_AUXADC_POLL));
+
+	if (!tries)
+		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);
+	else
+		result = wm8350_reg_read(wm8350,
+					 WM8350_AUX1_READBACK + channel);
+
+	/* Turn off the ADC */
+	reg = wm8350_reg_read(wm8350, WM8350_POWER_MGMT_5);
+	wm8350_reg_write(wm8350, WM8350_POWER_MGMT_5,
+			 reg & ~WM8350_AUXADC_ENA);
+
+	mutex_unlock(&wm8350->auxadc_mutex);
+
+	return result & WM8350_AUXADC_DATA1_MASK;
+}
+EXPORT_SYMBOL_GPL(wm8350_read_auxadc);
+
 /*
  * Cache is always host endian.
  */
@@ -1239,6 +1287,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		}
 	}
 
+	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
 	if (irq) {
diff --git a/include/linux/mfd/wm8350/comparator.h b/include/linux/mfd/wm8350/comparator.h
index 0537886..54bc5d0 100644
--- a/include/linux/mfd/wm8350/comparator.h
+++ b/include/linux/mfd/wm8350/comparator.h
@@ -164,4 +164,12 @@
 #define WM8350_AUXADC_BATT			6
 #define WM8350_AUXADC_TEMP			7
 
+struct wm8350;
+
+/*
+ * AUX ADC Readback
+ */
+int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale,
+		       int vref);
+
 #endif
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 9490ec1..cc19005 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -573,6 +573,8 @@ struct wm8350 {
 			 void *src);
 	u16 *reg_cache;
 
+	struct mutex auxadc_mutex;
+
 	/* Interrupt handling */
 	struct work_struct irq_work;
 	struct mutex irq_mutex; /* IRQ table mutex */
-- 
1.5.6.5

