Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZFTBSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZFTBSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbZFTBR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:17:56 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39071 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754767AbZFTBRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:53 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: V_lLsjIVM1lH42a4jQgE.G9v5zfBmx88qUni2vj3o_tSmyePaWbMOSfTE14fGIH_a1e69w5MN3_OQ2IsMHZQPz_hhg7xp9AaIkTqNttm68JUjM5oahZBxBmdwlVScWTqEKR3l.Fr5eJf4rZMieY6_nSqsWte21OG2Jsey3duH4npBH4pKDoGWfWRoTLkh1YStBCNA4RFW0.1AlHTdjKd04SS5sdH0UADFZiFJih4lpmE_G8mggUAOuZyujAAiYklRot3n2xSj3bv80qnwLSPH9.fsnjp6HhY5iih0YLnl3t9nJkFYYVMn.aGjgO2VBSt9U0z35cWEpO084jAXkrp3lTvMmIZB_GLIuIK5HVKxHqqWUpljFXjIgo-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 02/13] generic GPIO support for the Freescale Coldfire 5206.
Date: Fri, 19 Jun 2009 18:11:01 -0700
Message-Id: <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 5206.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m5206sim.h      |   10 +++++-
 arch/m68knommu/platform/5206/Makefile |    2 +-
 arch/m68knommu/platform/5206/gpio.c   |   49 +++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 3 deletions(-)
 create mode 100644 arch/m68knommu/platform/5206/gpio.c

diff --git a/arch/m68k/include/asm/m5206sim.h b/arch/m68k/include/asm/m5206sim.h
index 7e3594d..7be8a2d 100644
--- a/arch/m68k/include/asm/m5206sim.h
+++ b/arch/m68k/include/asm/m5206sim.h
@@ -85,10 +85,16 @@
 #define	MCFSIM_PAR		0xcb		/* Pin Assignment reg (r/w) */
 #endif
 
-#define	MCFSIM_PADDR		0x1c5		/* Parallel Direction (r/w) */
-#define	MCFSIM_PADAT		0x1c9		/* Parallel Port Value (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x1c5)	/* Parallel Direction (r/w) */
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x1c9)	/* Parallel Port Value (r/w) */
 
 /*
+ * Generic GPIO
+ */
+#define MCFGPIO_PIN_MAX		8
+#define MCFGPIO_IRQ_VECBASE	-1
+#define MCFGPIO_IRQ_MAX		-1
+/*
  *	Some symbol defines for the Parallel Port Pin Assignment Register
  */
 #ifdef CONFIG_M5206e
diff --git a/arch/m68knommu/platform/5206/Makefile b/arch/m68knommu/platform/5206/Makefile
index a439d9a..113c333 100644
--- a/arch/m68knommu/platform/5206/Makefile
+++ b/arch/m68knommu/platform/5206/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/5206/gpio.c b/arch/m68knommu/platform/5206/gpio.c
new file mode 100644
index 0000000..20720e5
--- /dev/null
+++ b/arch/m68knommu/platform/5206/gpio.c
@@ -0,0 +1,49 @@
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
+			.label			= "PP",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFSIM_PADDR,
+		.podr				= MCFSIM_PADAT,
+		.ppdr				= MCFSIM_PADAT,
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

