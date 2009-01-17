Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZAQJ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZAQJ56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 04:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZAQJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 04:57:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:38090 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049AbZAQJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 04:57:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vBK039GqelAtQBccgIphMiWLYXbztnRCotjKWcy41ZnHFSTfHqNL2Vz4Q/Vs1UiNnk
         awAnp+rXpL+P+yK6T3jgmx4/0wosUrld4GPYX02xovq+0GD+QxiV327uT5auQph8YLrh
         YewIjrQa8/3mxbOo2J9oJq1kSYc3iupWQdVjE=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [RFC 2.6.28 2/2] mach-pxa: add and use batch set/get gpio
Date: Sat, 17 Jan 2009 17:57:18 +0800
Message-Id: <12321862462894-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
In-Reply-To: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for pxa specific batch set/get of gpio. This
is exported to gpiolib via the gpio_chip interface and then used within
am300epd.c

Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: linux-embedded@vger.kernel.org
Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
---
 arch/arm/mach-pxa/Kconfig             |    1 +
 arch/arm/mach-pxa/am300epd.c          |   23 ++++++------
 arch/arm/mach-pxa/gpio.c              |   63 +++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/include/mach/gpio.h |   48 +++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index f844425..1b3e631 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -41,6 +41,7 @@ config GUMSTIX_AM200EPD
 	bool "Enable AM200EPD board support"
 
 config GUMSTIX_AM300EPD
+	select GPIOLIB_BATCH
 	bool "Enable AM300EPD board support"
 
 endchoice
diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 4bd10a1..c065368 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -187,24 +187,25 @@ static void am300_cleanup(struct broadsheetfb_par *par)
 
 static u16 am300_get_hdb(struct broadsheetfb_par *par)
 {
-	u16 res = 0;
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
+	int err;
+	u32 val;
 
-	return res;
+	err = gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, 16, &val);
+	if (err) {
+		dev_err(&am300_device->dev, "get failed: %d\n", err);
+		return 0;
+	}
+	return (u16) val;
 }
 
 static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
 {
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+	int err;
+	err = gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
+	if (err)
+		dev_err(&am300_device->dev, "set failed: %d\n", err);
 }
 
-
 static void am300_set_ctl(struct broadsheetfb_par *par, unsigned char bit,
 				u8 state)
 {
diff --git a/arch/arm/mach-pxa/gpio.c b/arch/arm/mach-pxa/gpio.c
index 5fec1e4..46371a1 100644
--- a/arch/arm/mach-pxa/gpio.c
+++ b/arch/arm/mach-pxa/gpio.c
@@ -162,6 +162,67 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
 }
 
+#ifdef CONFIG_GPIOLIB_BATCH
+/*
+ * Set output GPIO level in batches
+ */
+static int pxa_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
+				u32 values, u32 bitmask, int width)
+{
+	struct pxa_gpio_chip *pxa;
+
+	/* we're guaranteed by the caller that offset + bitmask remains
+	 * in this chip.
+	 */
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	/* bitmask is used twice in shifted form */
+	bitmask <<= offset;
+
+	values = (values << offset) & bitmask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPSR_OFFSET);
+
+	values = ~values & bitmask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPCR_OFFSET);
+
+	return 0;
+}
+
+/*
+ * Get output GPIO level in batches
+ */
+static int pxa_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
+				u32 bitmask, int width, u32 *result)
+{
+	u32 values;
+	struct pxa_gpio_chip *pxa;
+
+	/* we're guaranteed by the caller that offset + bitmask remains
+	 * in this chip.
+	 */
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	values = __raw_readl(pxa->regbase + GPLR_OFFSET);
+
+	/* shift the result back into original position */
+	*result = (values >> offset) & bitmask;
+	return 0;
+}
+#endif
+
+/* this is done this way so that we can insert an ifdef-able value
+ * into the following GPIO_CHIP macro
+ */
+#ifdef CONFIG_GPIOLIB_BATCH
+#define SET_BATCH_MACRO	.set_batch 	  = pxa_gpio_set_batch,
+#define GET_BATCH_MACRO	.get_batch	  = pxa_gpio_get_batch,
+#else
+#define SET_BATCH_MACRO
+#define GET_BATCH_MACRO
+#endif
+
 #define GPIO_CHIP(_n)							\
 	[_n] = {							\
 		.regbase = GPIO##_n##_BASE,				\
@@ -173,6 +234,8 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 			.set		  = pxa_gpio_set,		\
 			.base		  = (_n) * 32,			\
 			.ngpio		  = 32,				\
+			SET_BATCH_MACRO					\
+			GET_BATCH_MACRO					\
 		},							\
 	}
 
diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
index 2c538d8..46d9022 100644
--- a/arch/arm/mach-pxa/include/mach/gpio.h
+++ b/arch/arm/mach-pxa/include/mach/gpio.h
@@ -56,6 +56,54 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	}
 }
 
+#ifdef CONFIG_GPIOLIB_BATCH
+static inline int gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
+					int bitwidth)
+{
+	int err = 0;
+	if (__builtin_constant_p(gpio) &&
+		(gpio + bitwidth < NR_BUILTIN_GPIO) &&
+		((gpio + bitwidth) <= roundup(gpio+1, 32))) {
+		int shift;
+
+		shift = gpio % 32;
+		bitmask <<= shift;
+
+		values = (values << shift) & bitmask;
+		if (values)
+			GPSR(gpio) = values;
+
+		values = ~values & bitmask;
+		if (values)
+			GPCR(gpio) = values;
+	} else {
+		err = __gpio_set_batch(gpio, values, bitmask, bitwidth);
+	}
+	return err;
+}
+
+static inline int gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth,
+					u32 *result)
+{
+	int ret = 0;
+	if (__builtin_constant_p(gpio) &&
+		(gpio + bitwidth < NR_BUILTIN_GPIO) &&
+		((gpio + bitwidth) <= roundup(gpio+1, 32))) {
+		int shift;
+		u32 values;
+
+		shift = gpio % 32;
+
+		values = GPLR(gpio);
+
+		*result = (values >> shift) & bitmask;
+	} else {
+		ret = __gpio_get_batch(gpio, bitmask, bitwidth, result);
+	}
+	return ret;
+}
+#endif
+
 #define gpio_cansleep __gpio_cansleep
 
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
-- 
1.5.2.3

