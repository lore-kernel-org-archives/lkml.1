Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZFTBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZFTBSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbZFTBR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:17:58 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39075 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757002AbZFTBRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:54 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: u.5uWToVM1n5ZsyDRGiwCBWexmreUvlxZq.6V3FbRydLpp2w2_a3g5__008yrdurA7CnEWa1MQ8FXUBg0fvx1kJxfd5oZhMLc1XpqhhBbAc7OYsmeYDUuckBXya3P_TRKKGAtvlCIi71OlEBdyUYk.JkMRfXp8y.4yo8T4L3YS2YdMh_NwOvESjtLIjJmOXLhBCE8eS3I4pFVK0NZmBs70muItytznW7CHnbepzoUDNS8BrsTDjc2Fl7y4r.mLglfVKzUmf2O.8uqBfW4zQ0wxXcMmOV7YheMnrKALOr9HLMIDSEDXwSwjwcLDlyaKEuhgCBsquW7IxTq5rnaqbp9Q4bErBDC_zQhI1IRqWAr9V7GFNHlLfm.0U-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 03/13] generic GPIO support for the Freescale Coldire 5206e.
Date: Fri, 19 Jun 2009 18:11:02 -0700
Message-Id: <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 5206e.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68knommu/platform/5206e/Makefile |    2 +-
 arch/m68knommu/platform/5206e/config.c |    1 +
 arch/m68knommu/platform/5206e/gpio.c   |   49 ++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletions(-)
 create mode 100644 arch/m68knommu/platform/5206e/gpio.c

diff --git a/arch/m68knommu/platform/5206e/Makefile b/arch/m68knommu/platform/5206e/Makefile
index a439d9a..113c333 100644
--- a/arch/m68knommu/platform/5206e/Makefile
+++ b/arch/m68knommu/platform/5206e/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
index db90254..1b80073 100644
--- a/arch/m68knommu/platform/5206e/config.c
+++ b/arch/m68knommu/platform/5206e/config.c
@@ -16,6 +16,7 @@
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
+#include <asm/mcfuart.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfuart.h>
 
diff --git a/arch/m68knommu/platform/5206e/gpio.c b/arch/m68knommu/platform/5206e/gpio.c
new file mode 100644
index 0000000..20720e5
--- /dev/null
+++ b/arch/m68knommu/platform/5206e/gpio.c
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

