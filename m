Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZFTBTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZFTBTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbZFTBSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:03 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39101 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759358AbZFTBR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:57 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: x2F39kkVM1nTprTA5oQ6AAi02p5ZJg4LqIn0l4SA_mYuyZfcR46Pc3GpjY4SfBnz3hpios3vWoOXrbBDWPHyt6CqIDxMdI7DLaTmgg0GyzWJO0eMPvKk1TGanrXPH6SyxUyjk6Fsd3J1v1MfUwZKG7VCehQrqxwWQm9D9anhnS7g2wkR0tP.ipICUxMQVXfATRUNiLBnVbGkAj7wnYryvIM.4osZH2r2GSQ2HbBuyOpDz4HLbNZesgytFde5SDyKxcBALPMWp8o6yq5RssRp940LWLjfNjzqS5Rr6Rb38tqqpa.Yn3apxZIu23gM_lU_Wwgi95Dgfcr4jbvrh4tOV6i0ToNyydzH6ZTBIhQEbsp7JCsg_rJFico-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 06/13] generic GPIO support for the Freescale Coldfire 5249.
Date: Fri, 19 Jun 2009 18:11:05 -0700
Message-Id: <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 5249.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m5249sim.h      |   23 +++++++-----
 arch/m68knommu/platform/5249/Makefile |    2 +-
 arch/m68knommu/platform/5249/gpio.c   |   65 +++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 10 deletions(-)
 create mode 100644 arch/m68knommu/platform/5249/gpio.c

diff --git a/arch/m68k/include/asm/m5249sim.h b/arch/m68k/include/asm/m5249sim.h
index 366eb86..2c23a83 100644
--- a/arch/m68k/include/asm/m5249sim.h
+++ b/arch/m68k/include/asm/m5249sim.h
@@ -73,14 +73,14 @@
 /*
  *	General purpose IO registers (in MBAR2).
  */
-#define	MCFSIM2_GPIOREAD	0x0		/* GPIO read values */
-#define	MCFSIM2_GPIOWRITE	0x4		/* GPIO write values */
-#define	MCFSIM2_GPIOENABLE	0x8		/* GPIO enabled */
-#define	MCFSIM2_GPIOFUNC	0xc		/* GPIO function */
-#define	MCFSIM2_GPIO1READ	0xb0		/* GPIO1 read values */
-#define	MCFSIM2_GPIO1WRITE	0xb4		/* GPIO1 write values */
-#define	MCFSIM2_GPIO1ENABLE	0xb8		/* GPIO1 enabled */
-#define	MCFSIM2_GPIO1FUNC	0xbc		/* GPIO1 function */
+#define	MCFSIM2_GPIOREAD	(MCF_MBAR2 + 0x000)	/* GPIO read values */
+#define	MCFSIM2_GPIOWRITE	(MCF_MBAR2 + 0x004)	/* GPIO write values */
+#define	MCFSIM2_GPIOENABLE	(MCF_MBAR2 + 0x008)	/* GPIO enabled */
+#define	MCFSIM2_GPIOFUNC	(MCF_MBAR2 + 0x00C)	/* GPIO function */
+#define	MCFSIM2_GPIO1READ	(MCF_MBAR2 + 0x0B0)	/* GPIO1 read values */
+#define	MCFSIM2_GPIO1WRITE	(MCF_MBAR2 + 0x0B4)	/* GPIO1 write values */
+#define	MCFSIM2_GPIO1ENABLE	(MCF_MBAR2 + 0x0B8)	/* GPIO1 enabled */
+#define	MCFSIM2_GPIO1FUNC	(MCF_MBAR2 + 0x0BC)	/* GPIO1 function */
 
 #define	MCFSIM2_GPIOINTSTAT	0xc0		/* GPIO interrupt status */
 #define	MCFSIM2_GPIOINTCLEAR	0xc0		/* GPIO interrupt clear */
@@ -100,7 +100,12 @@
 #define	MCFSIM2_IDECONFIG1	0x18c		/* IDEconfig1 */
 #define	MCFSIM2_IDECONFIG2	0x190		/* IDEconfig2 */
 
-
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX		64
+#define MCFGPIO_IRQ_MAX		-1
+#define MCFGPIO_IRQ_VECBASE	-1
 /*
  *	Macro to set IMR register. It is 32 bits on the 5249.
  */
diff --git a/arch/m68knommu/platform/5249/Makefile b/arch/m68knommu/platform/5249/Makefile
index a439d9a..113c333 100644
--- a/arch/m68knommu/platform/5249/Makefile
+++ b/arch/m68knommu/platform/5249/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/5249/gpio.c b/arch/m68knommu/platform/5249/gpio.c
new file mode 100644
index 0000000..69e7866
--- /dev/null
+++ b/arch/m68knommu/platform/5249/gpio.c
@@ -0,0 +1,65 @@
+/*
+ * Coldfire generic GPIO support
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfgpio.h>
+ 
+static struct mcf_gpio_chip mcf_gpio_chips[] = {
+	{
+		.gpio_chip			= {
+			.label			= "GPIO0",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 32,
+		},
+		.pddr				= MCFSIM2_GPIOENABLE,
+		.podr				= MCFSIM2_GPIOWRITE,
+		.ppdr				= MCFSIM2_GPIOREAD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "GPIO1",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 32,
+			.ngpio			= 32,
+		},
+		.pddr				= MCFSIM2_GPIO1ENABLE,
+		.podr				= MCFSIM2_GPIO1WRITE,
+		.ppdr				= MCFSIM2_GPIO1READ,
+	},
+};
+
+static int __init mcf_gpio_init(void)
+{
+	unsigned i = 0;
+	while (i < ARRAY_SIZE(mcf_gpio_chips))
+		(void)gpiochip_add((struct gpio_chip *)&mcf_gpio_chips[i++]);
+	return 0;
+}
+
+core_initcall(mcf_gpio_init);
-- 
1.5.6.5

