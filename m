Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbXDDR4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbXDDR4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDDR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:56:11 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:37032 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXDDR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:56:05 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/90] ARM: OMAP: Place SMS and SDRC into smart idle mode
Date: Wed,  4 Apr 2007 13:46:28 -0400
Message-Id: <11757088791107-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757088774110-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Place SMS and SDRC into smart idle mode

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/io.c     |    2 +
 arch/arm/mach-omap2/memory.c |   48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index a0728c3..748920f 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -26,6 +26,7 @@
 extern void omap_sram_init(void);
 extern int omap2_clk_init(void);
 extern void omap2_check_revision(void);
+extern void omap2_init_memory(void);
 extern void gpmc_init(void);
 
 /*
@@ -67,5 +68,6 @@ void __init omap2_init_common_hw(void)
 {
 	omap2_mux_init();
 	omap2_clk_init();
+	omap2_init_memory();
 	gpmc_init();
 }
diff --git a/arch/arm/mach-omap2/memory.c b/arch/arm/mach-omap2/memory.c
index 85cbc2a..f173aa8 100644
--- a/arch/arm/mach-omap2/memory.c
+++ b/arch/arm/mach-omap2/memory.c
@@ -30,6 +30,38 @@
 #include "prcm-regs.h"
 #include "memory.h"
 
+#define SMS_BASE		0x68008000
+#define SMS_SYSCONFIG		0x010
+
+#define SDRC_BASE		0x68009000
+#define SDRC_SYSCONFIG		0x010
+#define SDRC_SYSSTATUS		0x014
+
+static const u32 sms_base = IO_ADDRESS(SMS_BASE);
+static const u32 sdrc_base = IO_ADDRESS(SDRC_BASE);
+
+
+static inline void sms_write_reg(int idx, u32 val)
+{
+	__raw_writel(val, sms_base + idx);
+}
+
+static inline u32 sms_read_reg(int idx)
+{
+	return __raw_readl(sms_base + idx);
+}
+
+static inline void sdrc_write_reg(int idx, u32 val)
+{
+	__raw_writel(val, sdrc_base + idx);
+}
+
+static inline u32 sdrc_read_reg(int idx)
+{
+	return __raw_readl(sdrc_base + idx);
+}
+
+
 static struct memory_timings mem_timings;
 
 u32 omap2_memory_get_slow_dll_ctrl(void)
@@ -99,3 +131,19 @@ void omap2_init_memory_params(u32 force_lock_to_unlock_mode)
 	/* 90 degree phase for anything below 133Mhz + disable DLL filter */
 	mem_timings.slow_dll_ctrl |= ((1 << 1) | (3 << 8));
 }
+
+void __init omap2_init_memory(void)
+{
+	u32 l;
+
+	l = sms_read_reg(SMS_SYSCONFIG);
+	l &= ~(0x3 << 3);
+	l |= (0x2 << 3);
+	sms_write_reg(SMS_SYSCONFIG, l);
+
+	l = sdrc_read_reg(SDRC_SYSCONFIG);
+	l &= ~(0x3 << 3);
+	l |= (0x2 << 3);
+	sdrc_write_reg(SDRC_SYSCONFIG, l);
+
+}
-- 
1.4.4.2

