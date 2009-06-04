Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZFDSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZFDSgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZFDSfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:35:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZFDSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lwzv+MIYfwC349Fdrlolc2Sco+qKdESfb6BZY0seJwD7vTTzrVyi8synOGnzbBTdB3
         ztybStXzgiKT+tPwkpe4QXQ+Wpii5SG+ou7TW4nkMIAPMihjzeu/XJGS6nvMYBs5Q6kT
         77a1RvCAwO30NSJ8g92P7qLJWZAPCxqV0U1rE=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/7] MFD: ASIC3: add API for EXTCF and SDHWCTRL register manipulation
Date: Thu,  4 Jun 2009 20:36:10 +0200
Message-Id: <1244140576-18006-2-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those registers are needed for PCMCIA and MMC/SDIO operation as
well as for the DS1WM.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/asic3.h |   13 +++++++----
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9e48545..8e1653a 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -52,6 +52,54 @@ static inline u32 asic3_read_register(struct asic3 *asic,
 			(reg >> asic->bus_shift));
 }
 
+void asic3_set_extcf_select(struct device *dev, u32 bits, int value)
+{
+	struct asic3 *asic = dev->driver_data;
+	unsigned long flags;
+	u32 v;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	v = asic3_read_register(asic, ASIC3_OFFSET(EXTCF, SELECT));
+	if (value)
+		v |= bits;
+	else
+		v &= ~bits;
+	asic3_write_register(asic, ASIC3_OFFSET(EXTCF, SELECT), v);
+	spin_unlock_irqrestore(&asic->lock, flags);
+}
+EXPORT_SYMBOL(asic3_set_extcf_select);
+
+void asic3_set_extcf_reset(struct device *dev, u32 bits, int value)
+{
+	struct asic3 *asic = dev->driver_data;
+	unsigned long flags;
+	u32 v;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	v = asic3_read_register(asic, ASIC3_OFFSET(EXTCF, RESET));
+	if (value)
+		v |= bits;
+	else
+		v &= ~bits;
+	asic3_write_register(asic, ASIC3_OFFSET(EXTCF, RESET), v);
+	spin_unlock_irqrestore(&asic->lock, flags);
+}
+
+void asic3_set_sdhwctrl(struct asic3 *asic, u32 bits, int value)
+{
+	unsigned long flags;
+	u32 v;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	v = asic3_read_register(asic, ASIC3_OFFSET(SDHWCTRL, SDCONF));
+	if (value)
+		v |= bits;
+	else
+		v &= ~bits;
+	asic3_write_register(asic, ASIC3_OFFSET(SDHWCTRL, SDCONF), v);
+	spin_unlock_irqrestore(&asic->lock, flags);
+}
+
 /* IRQs */
 #define MAX_ASIC_ISR_LOOPS    20
 #define ASIC3_GPIO_BASE_INCR \
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 322cd6d..cd02d20 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -16,6 +16,9 @@
 
 #include <linux/types.h>
 
+/* for PCMCIA */
+extern void asic3_set_extcf_select(struct device *dev, u32 bits, int value);
+
 struct asic3_platform_data {
 	u16 *gpio_config;
 	unsigned int gpio_config_num;
@@ -227,8 +230,8 @@ struct asic3_platform_data {
 
 
 /* Basic control of the SD ASIC */
-#define ASIC3_SDHWCTRL_Base	0x0E00
-#define ASIC3_SDHWCTRL_SDConf    0x00
+#define ASIC3_SDHWCTRL_BASE     0x0E00
+#define ASIC3_SDHWCTRL_SDCONF     0x00
 
 #define ASIC3_SDHWCTRL_SUSPEND    (1 << 0)  /* 1=suspend all SD operations */
 #define ASIC3_SDHWCTRL_CLKSEL     (1 << 1)  /* 1=SDICK, 0=HCLK */
@@ -242,10 +245,10 @@ struct asic3_platform_data {
 /* SD card power supply ctrl 1=enable */
 #define ASIC3_SDHWCTRL_SDPWR      (1 << 6)
 
-#define ASIC3_EXTCF_Base		0x1100
+#define ASIC3_EXTCF_BASE        0x1100
 
-#define ASIC3_EXTCF_Select         0x00
-#define ASIC3_EXTCF_Reset          0x04
+#define ASIC3_EXTCF_SELECT        0x00
+#define ASIC3_EXTCF_RESET         0x04
 
 #define ASIC3_EXTCF_SMOD0	         (1 << 0)  /* slot number of mode 0 */
 #define ASIC3_EXTCF_SMOD1	         (1 << 1)  /* slot number of mode 1 */
-- 
1.6.3.1

