Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZBSNsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZBSNsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZBSNrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:50970 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZBSNrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bFNAFbCSg9wsUDiVeNYrbeGzTjkZ+sUlt3hlddl3StHr8l6Hh08bPk0zWLw9bItYPv
         A721iniU/pmxA+yQ7oBoOEynYyN0mlVdBaxsoSy/1qaNf368wCH/Pg6jFD4YspZQbJv6
         f3XIutG/QlRNoE/tXbJuRVnAvklHwC1nlzqBc=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: move common GPIO handling code into plat-pxa
Date: Thu, 19 Feb 2009 21:45:51 +0800
Message-Id: <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

1. add common GPIO handling code into [arch/arm/plat-pxa]

2. common code in <mach/gpio.h> moved into <plat/gpio.h>, new processors
   should implement its own <mach/gpio.h>, provide the following required
   definitions and '#include <plat/gpio.h>' in the end:

   - GPIO_REGS_VIRT for mapped virtual address of the GPIO registers'
     physical I/O memory

   - macros of GPLR(), GPSR(), GPDR() for constant optimization for
     functions gpio_{set,get}_value() (so that bit-bang code can still
     have tolerable performance)

   - NR_BUILTIN_GPIO for the number of onchip GPIO

   - definitions of __gpio_is_inverted() and __gpio_is_occupied(), they
     can be either macros or inlined functions

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/mach-pxa/Makefile             |    2 +-
 arch/arm/mach-pxa/include/mach/gpio.h  |   32 +----------------
 arch/arm/plat-pxa/Makefile             |    1 +
 arch/arm/{mach-pxa => plat-pxa}/gpio.c |   30 +---------------
 arch/arm/plat-pxa/include/plat/gpio.h  |   62 ++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 61 deletions(-)
 rename arch/arm/{mach-pxa => plat-pxa}/gpio.c (89%)
 create mode 100644 arch/arm/plat-pxa/include/plat/gpio.h

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 2d84202..a1b116e 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -4,7 +4,7 @@
 
 # Common support (must be linked before board specific support)
 obj-y				+= clock.o devices.o generic.o irq.o \
-				   time.o gpio.o reset.o
+				   time.o reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
 ifeq ($(CONFIG_CPU_FREQ),y)
diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
index 406fa10..d80c7bc 100644
--- a/arch/arm/mach-pxa/include/mach/gpio.h
+++ b/arch/arm/mach-pxa/include/mach/gpio.h
@@ -99,40 +99,12 @@
 #define GAFR(x)		GPIO_REG(0x54 + (((x) & 0x70) >> 2))
 
 
-/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
- * Those cases currently cause holes in the GPIO number space, the
- * actual number of the last GPIO is recorded by 'pxa_last_gpio'.
- */
-extern int pxa_last_gpio;
-
 #define NR_BUILTIN_GPIO 128
 
-static inline int gpio_get_value(unsigned gpio)
-{
-	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO))
-		return GPLR(gpio) & GPIO_bit(gpio);
-	else
-		return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO)) {
-		if (value)
-			GPSR(gpio) = GPIO_bit(gpio);
-		else
-			GPCR(gpio) = GPIO_bit(gpio);
-	} else {
-		__gpio_set_value(gpio, value);
-	}
-}
-
-#define gpio_cansleep		__gpio_cansleep
 #define gpio_to_bank(gpio)	((gpio) >> 5)
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
 #define irq_to_gpio(irq)	IRQ_TO_GPIO(irq)
 
-
 #ifdef CONFIG_CPU_PXA26x
 /* GPIO86/87/88/89 on PXA26x have their direction bits in GPDR2 inverted,
  * as well as their Alternate Function value being '1' for GPIO in GAFRx.
@@ -165,7 +137,5 @@ static inline int __gpio_is_occupied(unsigned gpio)
 		return GPDR(gpio) & GPIO_bit(gpio);
 }
 
-typedef int (*set_wake_t)(unsigned int irq, unsigned int on);
-
-extern void pxa_init_gpio(int mux_irq, int start, int end, set_wake_t fn);
+#include <plat/gpio.h>
 #endif
diff --git a/arch/arm/plat-pxa/Makefile b/arch/arm/plat-pxa/Makefile
index dcc3cea..b837df4 100644
--- a/arch/arm/plat-pxa/Makefile
+++ b/arch/arm/plat-pxa/Makefile
@@ -4,3 +4,4 @@
 
 obj-y	:= dma.o
 
+obj-$(CONFIG_GENERIC_GPIO)	+= gpio.o
diff --git a/arch/arm/mach-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
similarity index 89%
rename from arch/arm/mach-pxa/gpio.c
rename to arch/arm/plat-pxa/gpio.c
index 7c22670..af819bf 100644
--- a/arch/arm/mach-pxa/gpio.c
+++ b/arch/arm/plat-pxa/gpio.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/arm/mach-pxa/gpio.c
+ *  linux/arch/arm/plat-pxa/gpio.c
  *
  *  Generic PXA GPIO handling
  *
@@ -22,34 +22,6 @@
 
 int pxa_last_gpio;
 
-/*
- * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
- * one set of registers. The register offsets are organized below:
- *
- *           GPLR    GPDR    GPSR    GPCR    GRER    GFER    GEDR
- * BANK 0 - 0x0000  0x000C  0x0018  0x0024  0x0030  0x003C  0x0048
- * BANK 1 - 0x0004  0x0010  0x001C  0x0028  0x0034  0x0040  0x004C
- * BANK 2 - 0x0008  0x0014  0x0020  0x002C  0x0038  0x0044  0x0050
- *
- * BANK 3 - 0x0100  0x010C  0x0118  0x0124  0x0130  0x013C  0x0148
- * BANK 4 - 0x0104  0x0110  0x011C  0x0128  0x0134  0x0140  0x014C
- * BANK 5 - 0x0108  0x0114  0x0120  0x012C  0x0138  0x0144  0x0150
- *
- * NOTE:
- *   BANK 3 is only available on PXA27x and later processors.
- *   BANK 4 and 5 are only available on PXA935
- */
-
-#define GPIO_BANK(n)	(GPIO_REGS_VIRT + BANK_OFF(n))
-
-#define GPLR_OFFSET	0x00
-#define GPDR_OFFSET	0x0C
-#define GPSR_OFFSET	0x18
-#define GPCR_OFFSET	0x24
-#define GRER_OFFSET	0x30
-#define GFER_OFFSET	0x3C
-#define GEDR_OFFSET	0x48
-
 struct pxa_gpio_chip {
 	struct gpio_chip chip;
 	void __iomem	*regbase;
diff --git a/arch/arm/plat-pxa/include/plat/gpio.h b/arch/arm/plat-pxa/include/plat/gpio.h
new file mode 100644
index 0000000..44248cb
--- /dev/null
+++ b/arch/arm/plat-pxa/include/plat/gpio.h
@@ -0,0 +1,62 @@
+#ifndef __PLAT_GPIO_H
+#define __PLAT_GPIO_H
+
+/*
+ * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
+ * one set of registers. The register offsets are organized below:
+ *
+ *           GPLR    GPDR    GPSR    GPCR    GRER    GFER    GEDR
+ * BANK 0 - 0x0000  0x000C  0x0018  0x0024  0x0030  0x003C  0x0048
+ * BANK 1 - 0x0004  0x0010  0x001C  0x0028  0x0034  0x0040  0x004C
+ * BANK 2 - 0x0008  0x0014  0x0020  0x002C  0x0038  0x0044  0x0050
+ *
+ * BANK 3 - 0x0100  0x010C  0x0118  0x0124  0x0130  0x013C  0x0148
+ * BANK 4 - 0x0104  0x0110  0x011C  0x0128  0x0134  0x0140  0x014C
+ * BANK 5 - 0x0108  0x0114  0x0120  0x012C  0x0138  0x0144  0x0150
+ *
+ * NOTE:
+ *   BANK 3 is only available on PXA27x and later processors.
+ *   BANK 4 and 5 are only available on PXA935
+ */
+
+#define GPIO_BANK(n)	(GPIO_REGS_VIRT + BANK_OFF(n))
+
+#define GPLR_OFFSET	0x00
+#define GPDR_OFFSET	0x0C
+#define GPSR_OFFSET	0x18
+#define GPCR_OFFSET	0x24
+#define GRER_OFFSET	0x30
+#define GFER_OFFSET	0x3C
+#define GEDR_OFFSET	0x48
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO))
+		return GPLR(gpio) & GPIO_bit(gpio);
+	else
+		return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO)) {
+		if (value)
+			GPSR(gpio) = GPIO_bit(gpio);
+		else
+			GPCR(gpio) = GPIO_bit(gpio);
+	} else
+		__gpio_set_value(gpio, value);
+}
+
+#define gpio_cansleep		__gpio_cansleep
+
+/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
+ * Those cases currently cause holes in the GPIO number space, the
+ * actual number of the last GPIO is recorded by 'pxa_last_gpio'.
+ */
+extern int pxa_last_gpio;
+
+typedef int (*set_wake_t)(unsigned int irq, unsigned int on);
+
+extern void pxa_init_gpio(int mux_irq, int start, int end, set_wake_t fn);
+#endif /* __PLAT_GPIO_H */
-- 
1.6.0.4

