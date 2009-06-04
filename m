Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZFDSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZFDSgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZFDSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:36:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZFDSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GD2cEkBJFFnaOLEefTvBgglUhhpfKCo3f8kUsaFXffPNg8KZDDTa/HOatilo9knSRt
         LSbmmGWwmkbthI/KGbWbWGYCIqtrWc9CXHWauLy+gyQE8VjJzVcmLJkm5H88V67MIXvQ
         zUQhEUZRWnjHu/SBtGeKG2iU/Vs6EsuEFf5xU=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 2/7] MFD: ASIC3: add clock handling for MFD cells
Date: Thu,  4 Jun 2009 20:36:11 +0200
Message-Id: <1244140576-18006-3-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ASIC3 has to work on both PXA and S3C and since their
struct clk implementations differ, we can't register out
clocks with the clkdev mechanism (yet?).
For now we have to keep clock handling internal to this
driver and enable/disable the clocks via the
mfd_cell->enable/disable functions.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 8e1653a..ed7f0c1 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -25,6 +25,48 @@
 
 #include <linux/mfd/asic3.h>
 
+enum {
+	ASIC3_CLOCK_SPI,
+	ASIC3_CLOCK_OWM,
+	ASIC3_CLOCK_PWM0,
+	ASIC3_CLOCK_PWM1,
+	ASIC3_CLOCK_LED0,
+	ASIC3_CLOCK_LED1,
+	ASIC3_CLOCK_LED2,
+	ASIC3_CLOCK_SD_HOST,
+	ASIC3_CLOCK_SD_BUS,
+	ASIC3_CLOCK_SMBUS,
+	ASIC3_CLOCK_EX0,
+	ASIC3_CLOCK_EX1,
+};
+
+struct asic3_clk {
+	int enabled;
+	unsigned int cdex;
+	unsigned long rate;
+};
+
+#define INIT_CDEX(_name, _rate)	\
+	[ASIC3_CLOCK_##_name] = {		\
+		.cdex = CLOCK_CDEX_##_name,	\
+		.rate = _rate,			\
+	}
+
+struct asic3_clk asic3_clk_init[] __initdata = {
+	INIT_CDEX(SPI, 0),
+	INIT_CDEX(OWM, 5000000),
+	INIT_CDEX(PWM0, 0),
+	INIT_CDEX(PWM1, 0),
+	INIT_CDEX(LED0, 0),
+	INIT_CDEX(LED1, 0),
+	INIT_CDEX(LED2, 0),
+	INIT_CDEX(SD_HOST, 24576000),
+	INIT_CDEX(SD_BUS, 12288000),
+	INIT_CDEX(SMBUS, 0),
+	INIT_CDEX(EX0, 32768),
+	INIT_CDEX(EX1, 24576000),
+};
+
 struct asic3 {
 	void __iomem *mapping;
 	unsigned int bus_shift;
@@ -34,6 +76,8 @@ struct asic3 {
 	u16 irq_bothedge[4];
 	struct gpio_chip gpio;
 	struct device *dev;
+
+	struct asic3_clk clocks[ARRAY_SIZE(asic3_clk_init)];
 };
 
 static int asic3_gpio_get(struct gpio_chip *chip, unsigned offset);
@@ -573,6 +617,37 @@ static int asic3_gpio_remove(struct platform_device *pdev)
 	return gpiochip_remove(&asic->gpio);
 }
 
+static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
+{
+	unsigned long flags;
+	u32 cdex;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	if (clk->enabled++ == 0) {
+		cdex = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
+		cdex |= clk->cdex;
+		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
+	}
+	spin_unlock_irqrestore(&asic->lock, flags);
+
+	return 0;
+}
+
+static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)
+{
+	unsigned long flags;
+	u32 cdex;
+
+	WARN_ON(clk->enabled == 0);
+
+	spin_lock_irqsave(&asic->lock, flags);
+	if (--clk->enabled == 0) {
+		cdex = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
+		cdex &= ~clk->cdex;
+		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
+	}
+	spin_unlock_irqrestore(&asic->lock, flags);
+}
 
 /* Core */
 static int __init asic3_probe(struct platform_device *pdev)
@@ -638,6 +713,11 @@ static int __init asic3_probe(struct platform_device *pdev)
 		goto out_irq;
 	}
 
+	/* Making a per-device copy is only needed for the
+	 * theoretical case of multiple ASIC3s on one board:
+	 */
+	memcpy(asic->clocks, asic3_clk_init, sizeof(asic3_clk_init));
+
 	dev_info(asic->dev, "ASIC3 Core driver\n");
 
 	return 0;
-- 
1.6.3.1

