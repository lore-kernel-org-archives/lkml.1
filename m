Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZBSNtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZBSNtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZBSNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:49874 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbZBSNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kn+LF3wsB18xvJfUYXoDf2wwapGZUbPTbkOHFev57qVQlxESMjQewZgaqbl7bdf3PX
         ldQxVdx+xalIpvc5KlIprtewbPpvaYtbdsn/ICh3Nz5sG5/cvPWurQJL9YA6zXQ3uoQN
         9sZ59lkXT5YKhmniLSsbUwahdkcy0L/CrdcY4=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: add GPIO support for pxa168
Date: Thu, 19 Feb 2009 21:45:54 +0800
Message-Id: <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/Kconfig                      |    2 +
 arch/arm/mach-mmp/include/mach/gpio.h |   36 +++++++++++++++++++++++++++++++++
 arch/arm/mach-mmp/pxa168.c            |   19 +++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/gpio.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7eaf910..165d396 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -490,6 +490,8 @@ config ARCH_PXA
 config ARCH_MMP
 	bool "Marvell PXA168"
 	depends on MMU
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select GENERIC_TIME
diff --git a/arch/arm/mach-mmp/include/mach/gpio.h b/arch/arm/mach-mmp/include/mach/gpio.h
new file mode 100644
index 0000000..0b1443b
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/gpio.h
@@ -0,0 +1,36 @@
+#ifndef __ASM_MACH_GPIO_H
+#define __ASM_MACH_GPIO_H
+
+#include <mach/addr-map.h>
+#include <mach/irqs.h>
+#include <asm-generic/gpio.h>
+
+#define GPIO_REGS_VIRT	(APB_VIRT_BASE + 0x19000)
+
+#define BANK_OFF(n)	(((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
+#define GPIO_REG(x)	(*((volatile u32 *)(GPIO_REGS_VIRT + (x))))
+
+#define NR_BUILTIN_GPIO	(128)
+
+#define gpio_to_bank(gpio)	((gpio) >> 5)
+#define gpio_to_irq(gpio)	(IRQ_GPIO_START + (gpio))
+#define irq_to_gpio(irq)	((irq) - IRQ_GPIO_START)
+
+
+#define __gpio_is_inverted(gpio)	(0)
+#define __gpio_is_occupied(gpio)	(0)
+
+/* NOTE: these macros are defined here to make optimization of
+ * gpio_{get,set}_value() to work when 'gpio' is a constant.
+ * Usage of these macros otherwise is no longer recommended,
+ * use generic GPIO API whenever possible.
+ */
+#define GPIO_bit(gpio)	(1 << ((gpio) & 0x1f))
+
+#define GPLR(x)		GPIO_REG(BANK_OFF((x) >> 5) + 0x00)
+#define GPDR(x)		GPIO_REG(BANK_OFF((x) >> 5) + 0x0c)
+#define GPSR(x)		GPIO_REG(BANK_OFF((x) >> 5) + 0x18)
+#define GPCR(x)		GPIO_REG(BANK_OFF((x) >> 5) + 0x24)
+
+#include <plat/gpio.h>
+#endif /* __ASM_MACH_GPIO_H */
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
index 546db19..db2356b 100644
--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -12,19 +12,38 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/io.h>
+#include <linux/clk.h>
 
 #include <mach/addr-map.h>
 #include <mach/cputype.h>
 #include <mach/regs-apbc.h>
 #include <mach/irqs.h>
+#include <mach/gpio.h>
 #include <mach/dma.h>
 
 #include "common.h"
 #include "clock.h"
 
+#define APMASK(i)	(GPIO_REGS_VIRT + BANK_OFF(i) + 0x09c)
+
+static void __init pxa168_init_gpio(void)
+{
+	int i;
+
+	clk_enable(&clk_pxa168_gpio);
+
+	/* unmask GPIO edge detection for all 4 banks - APMASKx */
+	for (i = 0; i < 4; i++)
+		__raw_writel(0xffffffff, APMASK(i));
+
+	pxa_init_gpio(IRQ_PXA168_GPIOX, 0, 127, NULL);
+}
+
 void __init pxa168_init_irq(void)
 {
 	icu_init_irq();
+	pxa168_init_gpio();
 }
 
 /* clocks for external use */
-- 
1.6.0.4

