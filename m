Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbYF3JYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbYF3JYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbYF3JWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62565 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbYF3JWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:43 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 6/8] avr32: Add simple SRAM allocator
Date: Mon, 30 Jun 2008 11:21:14 +0200
Message-Id: <1214817676-30378-7-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-6-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:08.0023 (UTC) FILETIME=[A0F01C70:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Add SRAM allocator for avr32, which is just a thin wrapper around
genalloc.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/Kconfig                   |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c  |   26 ++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/sram.h |   30 ++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-avr32/arch-at32ap/sram.h

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 09ad799..4ff3dea 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -88,6 +88,7 @@ config PLATFORM_AT32AP
 	select MMU
 	select PERFORMANCE_COUNTERS
 	select HAVE_GPIO_LIB
+	select GENERIC_ALLOCATOR
 
 #
 # CPU types
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 3ee5e72..07b21b1 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -20,6 +20,7 @@
 #include <asm/arch/at32ap700x.h>
 #include <asm/arch/board.h>
 #include <asm/arch/portmux.h>
+#include <asm/arch/sram.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -2120,3 +2121,28 @@ void __init setup_platform(void)
 	at32_init_pio(&pio3_device);
 	at32_init_pio(&pio4_device);
 }
+
+struct gen_pool *sram_pool;
+
+static int __init sram_init(void)
+{
+	struct gen_pool *pool;
+
+	/* 1KiB granularity */
+	pool = gen_pool_create(10, -1);
+	if (!pool)
+		goto fail;
+
+	if (gen_pool_add(pool, 0x24000000, 0x8000, -1))
+		goto err_pool_add;
+
+	sram_pool = pool;
+	return 0;
+
+err_pool_add:
+	gen_pool_destroy(pool);
+fail:
+	pr_err("Failed to create SRAM pool\n");
+	return -ENOMEM;
+}
+core_initcall(sram_init);
diff --git a/include/asm-avr32/arch-at32ap/sram.h b/include/asm-avr32/arch-at32ap/sram.h
new file mode 100644
index 0000000..4838dae
--- /dev/null
+++ b/include/asm-avr32/arch-at32ap/sram.h
@@ -0,0 +1,30 @@
+/*
+ * Simple SRAM allocator
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_ARCH_SRAM_H
+#define __ASM_AVR32_ARCH_SRAM_H
+
+#include <linux/genalloc.h>
+
+extern struct gen_pool *sram_pool;
+
+static inline unsigned long sram_alloc(size_t len)
+{
+	if (!sram_pool)
+		return 0UL;
+
+	return gen_pool_alloc(sram_pool, len);
+}
+
+static inline void sram_free(unsigned long addr, size_t len)
+{
+	return gen_pool_free(sram_pool, addr, len);
+}
+
+#endif /* __ASM_AVR32_ARCH_SRAM_H */
-- 
1.5.5.4

