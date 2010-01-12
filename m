Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196Ab0ALG6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0ALG6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081Ab0ALG6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:58:48 -0500
Received: from ozlabs.org ([203.10.76.45]:45460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab0ALG6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:58:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC, PATCH 6/7 v2] arm/icst307: use common struct clk,
	unify realview and versatile clocks
Message-Id: <1263279511.162400.317863280660.6.gpush@pororo>
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Tue, 12 Jan 2010 17:58:31 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the realview and versatile platforms use an icst307 clock, but have
their own clock structures.

This change introduces a struct icst307_clk, which is common between
realview and versatile. This allows us to take out the platform-specific
clock defintions.

Tested on versatile, compiled only on realview.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 arch/arm/common/Kconfig                 |    1 
 arch/arm/common/icst307.c               |   39 ++++++++++++++--
 arch/arm/include/asm/hardware/icst307.h |   14 ++++-
 arch/arm/mach-realview/Makefile         |    2 
 arch/arm/mach-realview/clock.c          |   56 -----------------------
 arch/arm/mach-realview/clock.h          |   22 ---------
 arch/arm/mach-realview/core.c           |    7 +-
 arch/arm/mach-realview/realview_pba8.c  |    1 
 arch/arm/mach-versatile/Makefile        |    2 
 arch/arm/mach-versatile/clock.c         |   58 ------------------------
 arch/arm/mach-versatile/clock.h         |   23 ---------
 arch/arm/mach-versatile/core.c          |    7 +-
 12 files changed, 54 insertions(+), 178 deletions(-)

diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
index 4efbb9d..05e334c 100644
--- a/arch/arm/common/Kconfig
+++ b/arch/arm/common/Kconfig
@@ -17,6 +17,7 @@ config ICST525
 
 config ICST307
 	bool
+	depends on USE_COMMON_STRUCT_CLK
 
 config SA1111
 	bool
diff --git a/arch/arm/common/icst307.c b/arch/arm/common/icst307.c
index 6d094c1..cd45b88 100644
--- a/arch/arm/common/icst307.c
+++ b/arch/arm/common/icst307.c
@@ -19,6 +19,8 @@
 
 #include <asm/hardware/icst307.h>
 
+#define to_clk_icst307(clk) (container_of(clk, struct clk_icst307, clk))
+
 /*
  * Divisors for each OD setting.
  */
@@ -36,7 +38,7 @@ EXPORT_SYMBOL(icst307_khz);
  */
 static unsigned char idx2s[8] = { 1, 6, 3, 4, 7, 5, 2, 0 };
 
-struct icst307_vco
+static struct icst307_vco
 icst307_khz_to_vco(const struct icst307_params *p, unsigned long freq)
 {
 	struct icst307_vco vco = { .s = 1, .v = p->vd_max, .r = p->rd_max };
@@ -94,9 +96,7 @@ icst307_khz_to_vco(const struct icst307_params *p, unsigned long freq)
 	return vco;
 }
 
-EXPORT_SYMBOL(icst307_khz_to_vco);
-
-struct icst307_vco
+static struct icst307_vco
 icst307_ps_to_vco(const struct icst307_params *p, unsigned long period)
 {
 	struct icst307_vco vco = { .s = 1, .v = p->vd_max, .r = p->rd_max };
@@ -158,4 +158,33 @@ icst307_ps_to_vco(const struct icst307_params *p, unsigned long period)
 	return vco;
 }
 
-EXPORT_SYMBOL(icst307_ps_to_vco);
+static unsigned long clk_icst307_get_rate(struct clk *clk)
+{
+	return to_clk_icst307(clk)->rate;
+}
+
+static long clk_icst307_round_rate(struct clk *clk, unsigned long rate)
+{
+	const struct icst307_params *params = &to_clk_icst307(clk)->params;
+	struct icst307_vco vco;
+	vco = icst307_khz_to_vco(params, rate / 1000);
+	return icst307_khz(params, vco) * 1000;
+}
+
+static int clk_icst307_set_rate(struct clk *clk, unsigned long rate)
+{
+	struct clk_icst307 *v_clk = to_clk_icst307(clk);
+	struct icst307_vco vco;
+
+	vco = icst307_khz_to_vco(&v_clk->params, rate / 1000);
+	v_clk->rate = icst307_khz(&v_clk->params, vco) * 1000;
+	v_clk->setvco(v_clk, vco);
+
+	return 0;
+}
+
+struct clk_operations clk_icst307_operations = {
+	.get_rate = clk_icst307_get_rate,
+	.round_rate = clk_icst307_round_rate,
+	.set_rate = clk_icst307_set_rate,
+};
diff --git a/arch/arm/include/asm/hardware/icst307.h b/arch/arm/include/asm/hardware/icst307.h
index 554f128..c7a3b83 100644
--- a/arch/arm/include/asm/hardware/icst307.h
+++ b/arch/arm/include/asm/hardware/icst307.h
@@ -16,6 +16,8 @@
 #ifndef ASMARM_HARDWARE_ICST307_H
 #define ASMARM_HARDWARE_ICST307_H
 
+#include <linux/clk.h>
+
 struct icst307_params {
 	unsigned long	ref;
 	unsigned long	vco_max;	/* inclusive */
@@ -31,8 +33,14 @@ struct icst307_vco {
 	unsigned char	s;
 };
 
-unsigned long icst307_khz(const struct icst307_params *p, struct icst307_vco vco);
-struct icst307_vco icst307_khz_to_vco(const struct icst307_params *p, unsigned long freq);
-struct icst307_vco icst307_ps_to_vco(const struct icst307_params *p, unsigned long period);
+struct clk_icst307 {
+	struct clk			clk;
+	unsigned long			rate;
+	const struct icst307_params	params;
+	void				(*setvco)(struct clk_icst307 *,
+						  struct icst307_vco);
+};
+
+extern struct clk_operations clk_icst307_operations;
 
 #endif
diff --git a/arch/arm/mach-realview/Makefile b/arch/arm/mach-realview/Makefile
index e704edb..a01b76b 100644
--- a/arch/arm/mach-realview/Makefile
+++ b/arch/arm/mach-realview/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y					:= core.o clock.o
+obj-y					:= core.o
 obj-$(CONFIG_MACH_REALVIEW_EB)		+= realview_eb.o
 obj-$(CONFIG_MACH_REALVIEW_PB11MP)	+= realview_pb11mp.o
 obj-$(CONFIG_MACH_REALVIEW_PB1176)	+= realview_pb1176.o
diff --git a/arch/arm/mach-realview/clock.c b/arch/arm/mach-realview/clock.c
deleted file mode 100644
index 472721c..0000000
--- a/arch/arm/mach-realview/clock.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/clock.c
- *
- *  Copyright (C) 2004 ARM Limited.
- *  Written by Deep Blue Solutions Limited.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/list.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/string.h>
-#include <linux/clk.h>
-#include <linux/mutex.h>
-
-#include <asm/hardware/icst307.h>
-
-#include "clock.h"
-
-#define to_clk_realview(clk) (container_of(clk, struct clk_realview, clk))
-
-static unsigned long clk_realview_get_rate(struct clk *clk)
-{
-	return to_clk_realview(clk)->rate;
-}
-
-static long clk_realview_round_rate(struct clk *clk, unsigned long rate)
-{
-	const struct icst307_params *params = &to_clk_realview(clk)->params;
-	struct icst307_vco vco;
-	vco = icst307_khz_to_vco(params, rate / 1000);
-	return icst307_khz(params, vco) * 1000;
-}
-
-static int clk_realview_set_rate(struct clk *clk, unsigned long rate)
-{
-	struct clk_realview *r_clk = to_clk_realview(clk);
-	struct icst307_vco vco;
-
-	vco = icst307_khz_to_vco(&r_clk->params, rate / 1000);
-	r_clk->rate = icst307_khz(&r_clk->params, vco) * 1000;
-	r_clk->setvco(r_clk, vco);
-
-	return 0;
-}
-
-struct clk_operations clk_realview_operations = {
-	.get_rate = clk_realview_get_rate,
-	.round_rate = clk_realview_round_rate,
-	.set_rate = clk_realview_set_rate,
-};
diff --git a/arch/arm/mach-realview/clock.h b/arch/arm/mach-realview/clock.h
deleted file mode 100644
index 639a381..0000000
--- a/arch/arm/mach-realview/clock.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/clock.h
- *
- *  Copyright (C) 2004 ARM Limited.
- *  Written by Deep Blue Solutions Limited.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-
-struct clk_realview {
-	struct clk			clk;
-	unsigned long			rate;
-	const struct icst307_params	params;
-	void				(*setvco)(struct clk_realview *,
-						  struct icst307_vco);
-};
-
-extern struct clk_operations clk_realview_operations;
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 8102c75..4e1c87f 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -52,7 +52,6 @@
 #include <mach/irqs.h>
 
 #include "core.h"
-#include "clock.h"
 
 #define REALVIEW_REFCOUNTER	(__io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_24MHz_OFFSET)
 
@@ -274,7 +273,7 @@ struct mmci_platform_data realview_mmc1_plat_data = {
  * Clock handling
  */
 
-static void realview_oscvco_set(struct clk_realview *clk, struct icst307_vco vco)
+static void realview_oscvco_set(struct clk_icst307 *clk, struct icst307_vco vco)
 {
 	void __iomem *sys_lock = __io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LOCK_OFFSET;
 	void __iomem *sys_osc;
@@ -293,9 +292,9 @@ static void realview_oscvco_set(struct clk_realview *clk, struct icst307_vco vco
 	writel(0, sys_lock);
 }
 
-static struct clk_realview oscvco_clk = {
+static struct clk_icst307 oscvco_clk = {
 	.clk = {
-		.ops = &clk_realview_operations,
+		.ops = &clk_icst307_operations,
 	},
 	.params	= {
 		.ref		= 24000,
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index fe861e9..0b43c07 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -42,7 +42,6 @@
 #include <mach/irqs.h>
 
 #include "core.h"
-#include "clock.h"
 
 static struct map_desc realview_pba8_io_desc[] __initdata = {
 	{
diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
index ba81e70..97cf4d8 100644
--- a/arch/arm/mach-versatile/Makefile
+++ b/arch/arm/mach-versatile/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y					:= core.o clock.o
+obj-y					:= core.o
 obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
 obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
 obj-$(CONFIG_PCI)			+= pci.o
diff --git a/arch/arm/mach-versatile/clock.c b/arch/arm/mach-versatile/clock.c
deleted file mode 100644
index 16ab90b..0000000
--- a/arch/arm/mach-versatile/clock.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- *  linux/arch/arm/mach-versatile/clock.c
- *
- *  Copyright (C) 2004 ARM Limited.
- *  Written by Deep Blue Solutions Limited.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/list.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/string.h>
-#include <linux/clk.h>
-#include <linux/mutex.h>
-#include <linux/clk.h>
-
-#include <asm/hardware/icst307.h>
-
-#include "clock.h"
-
-#define to_clk_versatile(clk) (container_of(clk, struct clk_versatile, clk))
-
-static unsigned long clk_versatile_get_rate(struct clk *clk)
-{
-	return to_clk_versatile(clk)->rate;
-}
-
-static long clk_versatile_round_rate(struct clk *clk, unsigned long rate)
-{
-	const struct icst307_params *params = &to_clk_versatile(clk)->params;
-	struct icst307_vco vco;
-
-	vco = icst307_khz_to_vco(params, rate / 1000);
-	return icst307_khz(params, vco) * 1000;
-}
-
-static int clk_versatile_set_rate(struct clk *clk, unsigned long rate)
-{
-	struct clk_versatile *v_clk = to_clk_versatile(clk);
-	struct icst307_vco vco;
-
-	vco = icst307_khz_to_vco(&v_clk->params, rate / 1000);
-	v_clk->rate = icst307_khz(&v_clk->params, vco) * 1000;
-	v_clk->setvco(v_clk, vco);
-
-	return 0;
-}
-
-struct clk_operations clk_versatile_operations = {
-	.get_rate = clk_versatile_get_rate,
-	.round_rate = clk_versatile_round_rate,
-	.set_rate = clk_versatile_set_rate,
-};
diff --git a/arch/arm/mach-versatile/clock.h b/arch/arm/mach-versatile/clock.h
deleted file mode 100644
index 6ac30c5..0000000
--- a/arch/arm/mach-versatile/clock.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *  linux/arch/arm/mach-versatile/clock.h
- *
- *  Copyright (C) 2004 ARM Limited.
- *  Written by Deep Blue Solutions Limited.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-
-struct clk_versatile {
-	struct clk			clk;
-	unsigned long			rate;
-	const struct icst307_params	params;
-	void				(*setvco)(struct clk_versatile *,
-						  struct icst307_vco);
-};
-
-extern struct clk_operations clk_versatile_operations;
-
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 2b670bb..e2323d8 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -50,7 +50,6 @@
 #include <asm/mach/map.h>
 
 #include "core.h"
-#include "clock.h"
 
 /*
  * All IO addresses are mapped onto VA 0xFFFx.xxxx, where x.xxxx
@@ -380,7 +379,7 @@ static struct mmci_platform_data mmc0_plat_data = {
  * Clock handling
  */
 
-static void versatile_oscvco_set(struct clk_versatile *clk, struct icst307_vco vco)
+static void versatile_oscvco_set(struct clk_icst307 *clk, struct icst307_vco vco)
 {
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 	void __iomem *sys_lock = sys + VERSATILE_SYS_LOCK_OFFSET;
@@ -395,9 +394,9 @@ static void versatile_oscvco_set(struct clk_versatile *clk, struct icst307_vco v
 	writel(0, sys_lock);
 }
 
-static struct clk_versatile osc4_clk = {
+static struct clk_icst307 osc4_clk = {
 	.clk = {
-		.ops = &clk_versatile_operations,
+		.ops = &clk_icst307_operations,
 	},
 	.params = {
 		.ref		= 24000,
