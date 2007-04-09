Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXDIVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXDIVkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXDIVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:40:23 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33399 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030285AbXDIVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:48 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 8/18] ARM: OMAP: omap2/gpmc updates
Date: Mon,  9 Apr 2007 17:30:51 -0400
Message-Id: <11761542912185-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154286590-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

GPMC updates:
 - bugfixes: wrong/missing flags, omitted write, wrong test
 - don't map memory segments starting at zero
 - improve debug messaging
 - export gpmc_get_fclk_perio]d() since it's needed to calc timings
 - expect gpmc_cs_set_timings() caller to have initialized sync vs async

Note that this API is glitchy; likely the best fix would be to add
a member to "struct gpmc_timings" to hold GPMC_CONFIG1, since that
holds one key aspect of the GPMC timings (the gpmc_fclk divisor,
and sync vs. async == whether that divisor matters).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpmc.c       |   33 ++++++++++++++++++++++-----------
 include/asm-arm/arch-omap/gpmc.h |    3 ++-
 2 files changed, 24 insertions(+), 12 deletions(-)

--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -88,7 +88,7 @@ u32 gpmc_cs_read_reg(int cs, int idx)
 }
 
 /* TODO: Add support for gpmc_fck to clock framework and use it */
-static unsigned long gpmc_get_fclk_period(void)
+unsigned long gpmc_get_fclk_period(void)
 {
 	/* In picoseconds */
 	return 1000000000 / ((clk_get_rate(gpmc_l3_clk)) / 1000);
@@ -120,15 +120,21 @@ static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 	else
 		ticks = gpmc_ns_to_ticks(time);
 	nr_bits = end_bit - st_bit + 1;
-	if (ticks >= 1 << nr_bits)
+	if (ticks >= 1 << nr_bits) {
+#ifdef DEBUG
+		printk(KERN_INFO "GPMC CS%d: %-10s* %3d ns, %3d ticks >= %d\n",
+				cs, name, time, ticks, 1 << nr_bits);
+#endif
 		return -1;
+	}
 
 	mask = (1 << nr_bits) - 1;
 	l = gpmc_cs_read_reg(cs, reg);
 #ifdef DEBUG
-	printk(KERN_INFO "GPMC CS%d: %-10s: %d ticks, %3lu ns (was %i ticks)\n",
+	printk(KERN_INFO
+		"GPMC CS%d: %-10s: %3d ticks, %3lu ns (was %3i ticks) %3d ns\n",
 	       cs, name, ticks, gpmc_get_fclk_period() * ticks / 1000,
-	       (l >> st_bit) & mask);
+			(l >> st_bit) & mask, time);
 #endif
 	l &= ~(mask << st_bit);
 	l |= ticks << st_bit;
@@ -157,7 +163,7 @@ int gpmc_cs_calc_divider(int cs, unsigned int sync_clk)
 	div = l / gpmc_get_fclk_period();
 	if (div > 4)
 		return -1;
-	if (div < 0)
+	if (div <= 0)
 		div = 1;
 
 	return div;
@@ -191,14 +197,19 @@ int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
 
 	GPMC_SET_ONE(GPMC_CS_CONFIG5, 24, 27, page_burst_access);
 
+	/* caller is expected to have initialized CONFIG1 to cover
+	 * at least sync vs async
+	 */
+	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
+	if (l & (GPMC_CONFIG1_READTYPE_SYNC | GPMC_CONFIG1_WRITETYPE_SYNC)) {
 #ifdef DEBUG
-	printk(KERN_INFO "GPMC CS%d CLK period is %lu (div %d)\n",
-	       cs, gpmc_get_fclk_period(), div);
+		printk(KERN_INFO "GPMC CS%d CLK period is %lu ns (div %d)\n",
+				cs, (div * gpmc_get_fclk_period()) / 1000, div);
 #endif
-
-	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
-	l &= ~0x03;
-	l |= (div - 1);
+		l &= ~0x03;
+		l |= (div - 1);
+		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, l);
+	}
 
 	return 0;
 }
--- a/include/asm-arm/arch-omap/gpmc.h
+++ b/include/asm-arm/arch-omap/gpmc.h
@@ -23,9 +23,10 @@
 #define GPMC_CS_NAND_DATA	0x24
 
 #define GPMC_CONFIG1_WRAPBURST_SUPP     (1 << 31)
-#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 20)
+#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 30)
 #define GPMC_CONFIG1_READTYPE_ASYNC     (0 << 29)
 #define GPMC_CONFIG1_READTYPE_SYNC      (1 << 29)
+#define GPMC_CONFIG1_WRITEMULTIPLE_SUPP (1 << 28)
 #define GPMC_CONFIG1_WRITETYPE_ASYNC    (0 << 27)
 #define GPMC_CONFIG1_WRITETYPE_SYNC     (1 << 27)
 #define GPMC_CONFIG1_CLKACTIVATIONTIME(val) ((val & 3) << 25)
-- 
1.4.4.2

