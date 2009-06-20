Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbZFTBT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbZFTBT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbZFTBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:09 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39110 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759247AbZFTBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:18:00 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: ze4KO8EVM1luWmlS2ZgmAbo1CI.5Wbbb0Qb3pEVetcSaS6uhEu8Qj_UFnoTzKzYw5sFqpyh9WCm080gq0RaCEAaOTmDb7Sct8wf2vDSCVjkLGAJAfrEVw.mOx3GRmE1Saxro1RvhyjmMFV.4FzcRKwUijmlE.Zpd3reFi_YGXFODfQ1d3aGCRk6c2p6j3qthylEiV1kf3iBEhHSYc.G8tNyBKJXfaoIh98pxN1nWaVrtRoKH8hY2q_FPGQFWRig0G7.SGvjXgZsspMavimNDoqRtfarnK.yJCec14SK2DcF6fPU.KRfMovfRTAzoz3GqnLuehMn79p5h3U4TGMiyIp90W8h33V2.7NvDpwICrKIeTp0hEXExRtA-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 08/13] generic GPIO support for the Freescale Coldfire 5272.
Date: Fri, 19 Jun 2009 18:11:07 -0700
Message-Id: <1245460272-4329-9-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 5272.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m5272sim.h      |   24 ++++++----
 arch/m68knommu/platform/5272/Makefile |    2 +-
 arch/m68knommu/platform/5272/gpio.c   |   81 +++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 10 deletions(-)
 create mode 100644 arch/m68knommu/platform/5272/gpio.c

diff --git a/arch/m68k/include/asm/m5272sim.h b/arch/m68k/include/asm/m5272sim.h
index 6217edc..0665ba1 100644
--- a/arch/m68k/include/asm/m5272sim.h
+++ b/arch/m68k/include/asm/m5272sim.h
@@ -63,16 +63,22 @@
 #define	MCFSIM_DCMR1		0x5c		/* DRAM 1 Mask reg (r/w) */
 #define	MCFSIM_DCCR1		0x63		/* DRAM 1 Control reg (r/w) */
 
-#define	MCFSIM_PACNT		0x80		/* Port A Control (r/w) */
-#define	MCFSIM_PADDR		0x84		/* Port A Direction (r/w) */
-#define	MCFSIM_PADAT		0x86		/* Port A Data (r/w) */
-#define	MCFSIM_PBCNT		0x88		/* Port B Control (r/w) */
-#define	MCFSIM_PBDDR		0x8c		/* Port B Direction (r/w) */
-#define	MCFSIM_PBDAT		0x8e		/* Port B Data (r/w) */
-#define	MCFSIM_PCDDR		0x94		/* Port C Direction (r/w) */
-#define	MCFSIM_PCDAT		0x96		/* Port C Data (r/w) */
-#define	MCFSIM_PDCNT		0x98		/* Port D Control (r/w) */
+#define	MCFSIM_PACNT		(MCF_MBAR + 0x80) /* Port A Control (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x84) /* Port A Direction (r/w) */
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x86) /* Port A Data (r/w) */
+#define	MCFSIM_PBCNT		(MCF_MBAR + 0x88) /* Port B Control (r/w) */
+#define	MCFSIM_PBDDR		(MCF_MBAR + 0x8c) /* Port B Direction (r/w) */
+#define	MCFSIM_PBDAT		(MCF_MBAR + 0x8e) /* Port B Data (r/w) */
+#define	MCFSIM_PCDDR		(MCF_MBAR + 0x94) /* Port C Direction (r/w) */
+#define	MCFSIM_PCDAT		(MCF_MBAR + 0x96) /* Port C Data (r/w) */
+#define	MCFSIM_PDCNT		(MCF_MBAR + 0x98) /* Port D Control (r/w) */
 
 
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX			48
+#define MCFGPIO_IRQ_MAX			-1
+#define MCFGPIO_IRQ_VECBASE		-1
 /****************************************************************************/
 #endif	/* m5272sim_h */
diff --git a/arch/m68knommu/platform/5272/Makefile b/arch/m68knommu/platform/5272/Makefile
index 26135d9..3d90e6d 100644
--- a/arch/m68knommu/platform/5272/Makefile
+++ b/arch/m68knommu/platform/5272/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/5272/gpio.c b/arch/m68knommu/platform/5272/gpio.c
new file mode 100644
index 0000000..1542dd5
--- /dev/null
+++ b/arch/m68knommu/platform/5272/gpio.c
@@ -0,0 +1,81 @@
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
+			.label			= "PA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PADDR,
+		.podr				= MCFSIM_PADAT,
+		.ppdr				= MCFSIM_PADAT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 16,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PBDDR,
+		.podr				= MCFSIM_PBDAT,
+		.ppdr				= MCFSIM_PBDAT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PC",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 32,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PCDDR,
+		.podr				= MCFSIM_PCDAT,
+		.ppdr				= MCFSIM_PCDAT,
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

