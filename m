Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYFZOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYFZOvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYFZOvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:51:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:25636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYFZOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Jo+MHiR3HdzpNcAt0abIvNw++KAI3izaIgxAxa2M1zEdp2oGcg9IflxAVFTtqcVKvP
         H3sZ50PqKfbGVA7JwidD1/0uTUWwBBjax1dbQKQZgUyZGsAyJBtpsehDGMAVyZVLifFY
         LOw/DcOAuu79FVDW/BcTWkPw2c5FEq3I1nE6g=
Subject: [PATCH, RFC] mfd: add clock API support to asic3 using clocklib
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 16:50:52 +0200
Message-Id: <1214491852.30078.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic clock API support for ASIC3 clocks using Dmitry
Baryshkov's clocklib (http://lkml.org/lkml/2008/6/26/278).
The CDEX clocks can be enabled/disabled and the SD host and bus clock 
rates can be changed. Also the clock settings comment for SD HCLK and 
BCLK in asic3.h is moved to the right place.

I am missing information about the spi, pwm, led, smbus and cx clock's
rates, and I'm not sure if the SOURCE0/1 bits in CLOCK_CDEX should be
handled here somehow. The CLOCK_SEL_CX bit in CLOCK_SEL is only used
internally by the IRQ controller, so I guess not handling that is fine.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/Kconfig       |    2 +-
 drivers/mfd/asic3.c       |  146 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/asic3.h |    2 +-
 3 files changed, 147 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5f87a28..a0da724 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -17,7 +17,7 @@ config MFD_SM501
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
+	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && HAVE_CLOCKLIB && ARM
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 50c773c..ced53c8 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -18,11 +18,13 @@
 
 #include <linux/version.h>
 #include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/clocklib.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <linux/platform_device.h>
 
 #include <linux/mfd/asic3.h>
 
@@ -53,6 +55,132 @@ static inline u32 asic3_read_register(struct asic3 *asic,
 			(reg >> asic->bus_shift));
 }
 
+/* clocks */
+struct clk_cdex {
+	unsigned int cdex;
+	unsigned long rate;
+	struct asic3 *asic;
+	struct clk clk;
+};
+
+static int asic3_clock_cdex_enable(struct clk *clk)
+{
+	struct clk_cdex *cclk = container_of(clk, struct clk_cdex, clk);
+	struct asic3 *asic = cclk->asic;
+        int cdex = cclk->cdex;
+	unsigned long flags, val;
+
+	local_irq_save(flags);
+
+	val = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
+	val |= cdex;
+	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), val);
+
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static void asic3_clock_cdex_disable(struct clk *clk)
+{
+	struct clk_cdex *cclk = container_of(clk, struct clk_cdex, clk);
+	struct asic3 *asic = cclk->asic;
+        int cdex = cclk->cdex;
+	unsigned long flags, val;
+
+	local_irq_save(flags);
+
+	val = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, CDEX));
+	val &= ~cdex;
+	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), val);
+
+	local_irq_restore(flags);
+}
+
+static unsigned long asic3_clock_cdex_get_rate(struct clk *clk)
+{
+	struct clk_cdex *cclk = container_of(clk, struct clk_cdex, clk);
+
+	return cclk->rate;
+}
+
+static long asic3_clock_cdex_round_rate(struct clk *clk, unsigned long hz,
+					bool apply)
+{
+	struct clk_cdex *cclk = container_of(clk, struct clk_cdex, clk);
+	unsigned long bit = 0;
+	long rate;
+
+	if (cclk->cdex == CLOCK_CDEX_SD_HOST)
+		bit = CLOCK_SEL_SD_HCLK_SEL;
+	if (cclk->cdex == CLOCK_CDEX_SD_BUS)
+		bit = CLOCK_SEL_SD_BCLK_SEL;
+
+	if (!bit) {
+		rate = cclk->rate;
+
+		if (apply && hz != rate)
+			return -EINVAL;
+
+		return rate;
+	}
+
+	if (hz < 18432000) /* (12.288 MHz + 24.576 MHz)/2 */
+		rate = 12288000;
+	else
+		rate = 24576000;
+
+	if (apply) {
+		struct asic3 *asic = cclk->asic;
+		unsigned long flags, val;
+
+		local_irq_save(flags);
+		val = asic3_read_register(asic, ASIC3_OFFSET(CLOCK, SEL));
+		if (hz < 18432000)
+			val &= ~bit;
+		else
+			val |= bit;
+		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), val);
+		local_irq_restore(flags);
+		cclk->rate = rate;
+	}
+
+	return rate;
+}
+
+static struct clk_ops clk_cdex_ops = {
+	.enable = asic3_clock_cdex_enable,
+	.disable = asic3_clock_cdex_disable,
+	.get_rate = asic3_clock_cdex_get_rate,
+	.round_rate = asic3_clock_cdex_round_rate,
+};
+
+#define INIT_CLOCK_CDEX(_name, _cdex, _rate)		\
+	&(struct clk_cdex) {				\
+		.cdex = CLOCK_CDEX_##_cdex,		\
+		.rate = _rate,				\
+		.clk = {				\
+			.name = _name,			\
+			.ops  = &clk_cdex_ops,		\
+		},					\
+	}.clk
+
+static struct clk *asic3_clks[] = {
+	INIT_CLOCK_CDEX("spi", SPI, 0),
+	INIT_CLOCK_CDEX("ds1wm", OWM, 5000000),
+	INIT_CLOCK_CDEX("pwm0", PWM0, 0),
+	INIT_CLOCK_CDEX("pwm1", PWM1, 0),
+	INIT_CLOCK_CDEX("led0", LED0, 0),
+	INIT_CLOCK_CDEX("led1", LED1, 0),
+	INIT_CLOCK_CDEX("led2", LED2, 0),
+	INIT_CLOCK_CDEX("sdhost", SD_HOST, 12288000),
+	INIT_CLOCK_CDEX("sdbus", SD_BUS, 12288000),
+	INIT_CLOCK_CDEX("smbus", SMBUS, 0),
+	INIT_CLOCK_CDEX("cx", CONTROL_CX, 0),
+	INIT_CLOCK_CDEX("ex0", EX0, 32768),
+	INIT_CLOCK_CDEX("ex1", EX1, 24576000),
+};
+
 /* IRQs */
 #define MAX_ASIC_ISR_LOOPS    20
 #define ASIC3_GPIO_BASE_INCR \
@@ -533,6 +661,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 	struct resource *mem;
 	unsigned long clksel;
 	int ret = 0;
+	int i;
 
 	asic = kzalloc(sizeof(struct asic3), GFP_KERNEL);
 	if (asic == NULL) {
@@ -569,6 +698,17 @@ static int __init asic3_probe(struct platform_device *pdev)
 	clksel = 0;
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), clksel);
 
+	/* Register ASIC3's clocks. */
+	for (i = 0; i < ARRAY_SIZE(asic3_clks); i++) {
+		struct clk_cdex *cclk = container_of(asic3_clks[i], struct clk_cdex, clk);
+		cclk->asic = asic;
+		ret = clk_register(asic3_clks[i]);
+		if (ret < 0)
+			dev_err(asic->dev,
+			       "failed to register clock %s (%d)\n",
+			       asic3_clks[i]->name, ret);
+	}
+
 	ret = asic3_irq_probe(pdev);
 	if (ret < 0) {
 		dev_err(asic->dev, "Couldn't probe IRQs\n");
@@ -608,6 +748,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 
 static int asic3_remove(struct platform_device *pdev)
 {
+	int i;
 	int ret;
 	struct asic3 *asic = platform_get_drvdata(pdev);
 
@@ -616,6 +757,9 @@ static int asic3_remove(struct platform_device *pdev)
 		return ret;
 	asic3_irq_remove(pdev);
 
+	for (i = 0; i < ARRAY_SIZE(asic3_clks); i++)
+		clk_unregister(asic3_clks[i]);
+
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), 0);
 
 	iounmap(asic->mapping);
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 6461a2a..0610449 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -152,7 +152,6 @@ struct asic3_platform_data {
 #define CLOCK_CDEX_LED1         (1 << 7)
 #define CLOCK_CDEX_LED2         (1 << 8)
 
-/* Clocks settings: 1 for 24.576 MHz, 0 for 12.288Mhz */
 #define CLOCK_CDEX_SD_HOST      (1 << 9)   /* R/W: SD host clock source */
 #define CLOCK_CDEX_SD_BUS       (1 << 10)  /* R/W: SD bus clock source ctrl */
 #define CLOCK_CDEX_SMBUS        (1 << 11)
@@ -161,6 +160,7 @@ struct asic3_platform_data {
 #define CLOCK_CDEX_EX0          (1 << 13)  /* R/W: 32.768 kHz crystal */
 #define CLOCK_CDEX_EX1          (1 << 14)  /* R/W: 24.576 MHz crystal */
 
+/* Clocks settings: 1 for 24.576 MHz, 0 for 12.288Mhz */
 #define CLOCK_SEL_SD_HCLK_SEL   (1 << 0)   /* R/W: SDIO host clock select */
 #define CLOCK_SEL_SD_BCLK_SEL   (1 << 1)   /* R/W: SDIO bus clock select */
 
-- 
1.5.5.4


