Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZGVDY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZGVDY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbZGVDY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:24:57 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39360 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZGVDYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:24:50 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: [RFC] [PATCH 4/3] OMAP1: Readd basic support for DSP initialization
Date: Wed, 22 Jul 2009 05:23:06 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jarkko Nikula <jhnikula@gmail.com>,
       Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907220523.08170.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds back support for powering up the DSP. This is required on
OMAP1510 and posiibly other OMAP1 CPU based machines for making back
McBSP1/MsBSP3 working.

I provide this patch as a temporary solution that should enable interested
people to use my ASoC driver for Amstrad Delta before an official DSP support
is added back to the omap or mainline tree.

Created and tested against linux-omap-2.6 commit
7c5cb7862d32cb344be7831d466535d5255e35ac.
Applies and works with linux-2.6.31-rc3 as well.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
diff -Npru a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
--- a/arch/arm/plat-omap/Makefile  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/Makefile  2009-06-01 22:31:15.000000000 +0200
@@ -25,3 +25,5 @@
 # OMAP mailbox framework
 obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
 
+obj-y += dsp/
+
diff -Npru a/arch/arm/plat-omap/dsp/Makefile b/arch/arm/plat-omap/dsp/Makefile
--- a/arch/arm/plat-omap/dsp/Makefile  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/Makefile  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,14 @@
+#
+# Makefile for the OMAP DSP driver.
+#
+
+# The target object and module list name.
+
+obj-y := dsp_common.o
+
+obj-$(CONFIG_OMAP_DSP) += dsp.o
+
+# Declare multi-part drivers
+
+dsp-objs	:= dsp_core.o ipbuf.o mblog.o task.o \
+		   dsp_ctl_core.o dsp_ctl.o taskwatch.o error.o dsp_mem.o \
+		   uaccess_dsp.o
diff -Npru a/arch/arm/plat-omap/dsp/dsp_common.c b/arch/arm/plat-omap/dsp/dsp_common.c
--- a/arch/arm/plat-omap/dsp/dsp_common.c  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/dsp_common.c  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,639 @@
+/*
+ * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
+ *
+ * Copyright (C) 2002-2006 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <asm/io.h>
+#include <asm/tlbflush.h>
+#include <asm/irq.h>
+#include <mach/dsp_common.h>
+#include "dsp.h"
+
+#ifdef CONFIG_ARCH_OMAP1
+#include <mach/tc.h>
+#endif
+
+#if defined(CONFIG_ARCH_OMAP1)
+#define dsp_boot_config(mode)	omap_writew((mode), MPUI_DSP_BOOT_CONFIG)
+#endif
+#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
+#define dsp_boot_config(mode)	writel((mode), DSP_IPI_DSPBOOTCONFIG)
+#endif
+
+struct omap_dsp *omap_dsp;
+
+#if defined(CONFIG_ARCH_OMAP1)
+struct clk *dsp_ck_handle;
+struct clk *api_ck_handle;
+#elif defined(CONFIG_ARCH_OMAP2)
+struct clk *dsp_fck_handle;
+struct clk *dsp_ick_handle;
+#endif
+dsp_long_t dspmem_base, dspmem_size,
+	   daram_base, daram_size,
+	   saram_base, saram_size;
+
+static struct cpustat {
+	struct mutex lock;
+	enum cpustat_e stat;
+	enum cpustat_e req;
+	u16 icrmask;
+#ifdef CONFIG_ARCH_OMAP1
+	struct {
+		int mpui;
+		int mem;
+		int mem_delayed;
+	} usecount;
+	int (*mem_req_cb)(void);
+	void (*mem_rel_cb)(void);
+#endif
+} cpustat = {
+	.stat = CPUSTAT_RESET,
+	.icrmask = 0xffff,
+};
+
+int dsp_set_rstvect(dsp_long_t adr)
+{
+	unsigned long *dst_adr;
+
+	if (adr >= DSPSPACE_SIZE)
+		return -EINVAL;
+
+	dst_adr = dspbyte_to_virt(DSP_BOOT_ADR_DIRECT);
+	/* word swap */
+	*dst_adr = ((adr & 0xffff) << 16) | (adr >> 16);
+	/* fill 8 bytes! */
+	*(dst_adr + 1) = 0;
+	/* direct boot */
+	dsp_boot_config(DSP_BOOT_CONFIG_DIRECT);
+
+	return 0;
+}
+
+dsp_long_t dsp_get_rstvect(void)
+{
+	unsigned long *dst_adr;
+
+	dst_adr = dspbyte_to_virt(DSP_BOOT_ADR_DIRECT);
+	return ((*dst_adr & 0xffff) << 16) | (*dst_adr >> 16);
+}
+
+#ifdef CONFIG_ARCH_OMAP1
+static void simple_load_code(unsigned char *src_c, u16 *dst, int len)
+{
+	int i;
+	u16 *src = (u16 *)src_c;
+	int len_w;
+
+	/* len must be multiple of 2. */
+	if (len & 1)
+		BUG();
+
+	len_w = len / 2;
+	for (i = 0; i < len_w; i++) {
+		/* byte swap copy */
+		*dst = ((*src & 0x00ff) << 8) |
+		       ((*src & 0xff00) >> 8);
+		src++;
+		dst++;
+	}
+}
+
+/* program size must be multiple of 2 */
+#define GBL_IDLE_TEXT_SIZE	52
+#define GBL_IDLE_TEXT_INIT { \
+	/* SAM */ \
+	0x3c, 0x4a,			/* 0x3c4a:     MOV 0x4, AR2 */ \
+	0xf4, 0x41, 0xfc, 0xff,		/* 0xf441fcff: AND 0xfcff, *AR2 */ \
+	/* disable WDT */ \
+	0x76, 0x34, 0x04, 0xb8,		/* 0x763404b8: MOV 0x3404, AR3 */ \
+	0xfb, 0x61, 0x00, 0xf5,		/* 0xfb6100f5: MOV 0x00f5, *AR3 */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	0xfb, 0x61, 0x00, 0xa0,		/* 0xfb6100a0: MOV 0x00a0, *AR3 */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	/* *IER0 = 0, *IER1 = 0 */ \
+	0x3c, 0x0b,			/* 0x3c0b:     MOV 0x0, AR3 */ \
+	0xe6, 0x61, 0x00,		/* 0xe66100:   MOV 0, *AR3 */ \
+	0x76, 0x00, 0x45, 0xb8,		/* 0x76004508: MOV 0x45, AR3 */ \
+	0xe6, 0x61, 0x00,		/* 0xe66100:   MOV 0, *AR3 */ \
+	/* *ICR = 0xffff */ \
+	0x3c, 0x1b,			/* 0x3c1b:     MOV 0x1, AR3 */ \
+	0xfb, 0x61, 0xff, 0xff,		/* 0xfb61ffff: MOV 0xffff, *AR3 */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	/* HOM */ \
+	0xf5, 0x41, 0x03, 0x00,		/* 0xf5410300: OR 0x0300, *AR2 */ \
+	/* idle and loop forever */ \
+	0x7a, 0x00, 0x00, 0x0c,		/* 0x7a00000c: IDLE */ \
+	0x4a, 0x7a,			/* 0x4a7a:     B -6 (infinite loop) */ \
+	0x20, 0x20, 0x20,		/* 0x20:       NOP */ \
+}
+
+/* program size must be multiple of 2 */
+#define CPU_IDLE_TEXT_SIZE	48
+#define CPU_IDLE_TEXT_INIT(icrh, icrl) { \
+	/* SAM */ \
+	0x3c, 0x4b,			/* 0x3c4b:     MOV 0x4, AR3 */ \
+	0xf4, 0x61, 0xfc, 0xff,		/* 0xf461fcff: AND 0xfcff, *AR3 */ \
+	/* disable WDT */ \
+	0x76, 0x34, 0x04, 0xb8,		/* 0x763404b8: MOV 0x3404, AR3 */ \
+	0xfb, 0x61, 0x00, 0xf5,		/* 0xfb6100f5: MOV 0x00f5, *AR3 */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	0xfb, 0x61, 0x00, 0xa0,		/* 0xfb6100a0: MOV 0x00a0, *AR3 */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	/* *IER0 = 0, *IER1 = 0 */ \
+	0x3c, 0x0b,			/* 0x3c0b:     MOV 0x0, AR3 */ \
+	0xe6, 0x61, 0x00,		/* 0xe66100:   MOV 0, *AR3 */ \
+	0x76, 0x00, 0x45, 0xb8,		/* 0x76004508: MOV 0x45, AR3 */ \
+	0xe6, 0x61, 0x00,		/* 0xe66100:   MOV 0, *AR3 */ \
+	/* set ICR = icr */ \
+	0x3c, 0x1b,			/* 0x3c1b:     MOV AR3 0x1 */ \
+	0xfb, 0x61, (icrh), (icrl),	/* 0xfb61****: MOV *AR3, icr */ \
+	0x9a,				/* 0x9a:       PORT */ \
+	/* idle and loop forever */ \
+	0x7a, 0x00, 0x00, 0x0c,		/* 0x7a00000c: IDLE */ \
+	0x4a, 0x7a,			/* 0x4a7a:     B -6 (infinite loop) */ \
+	0x20, 0x20, 0x20		/* 0x20: nop */ \
+}
+
+/*
+ * idle_boot base:
+ * Initialized with DSP_BOOT_ADR_MPUI (=0x010000).
+ * This value is used before DSP Gateway driver is initialized.
+ * DSP Gateway driver will overwrite this value with other value,
+ * to avoid confliction with the user program.
+ */
+static dsp_long_t idle_boot_base = DSP_BOOT_ADR_MPUI;
+
+static void dsp_gbl_idle(void)
+{
+	unsigned char idle_text[GBL_IDLE_TEXT_SIZE] = GBL_IDLE_TEXT_INIT;
+
+	__dsp_reset();
+	clk_enable(api_ck_handle);
+
+#if 0
+	dsp_boot_config(DSP_BOOT_CONFIG_IDLE);
+#endif
+	simple_load_code(idle_text, dspbyte_to_virt(idle_boot_base),
+			 GBL_IDLE_TEXT_SIZE);
+	if (idle_boot_base == DSP_BOOT_ADR_MPUI)
+		dsp_boot_config(DSP_BOOT_CONFIG_MPUI);
+	else
+		dsp_set_rstvect(idle_boot_base);
+
+	__dsp_run();
+	udelay(100);	/* to make things stable */
+	clk_disable(api_ck_handle);
+}
+
+static void dsp_cpu_idle(void)
+{
+	u16 icr_tmp;
+	unsigned char icrh, icrl;
+
+	__dsp_reset();
+	clk_enable(api_ck_handle);
+
+	/*
+	 * icr settings:
+	 * DMA should not sleep for DARAM/SARAM access
+	 * DPLL should not sleep while any other domain is active
+	 */
+	icr_tmp = cpustat.icrmask & ~(DSPREG_ICR_DMA | DSPREG_ICR_DPLL);
+	icrh = icr_tmp >> 8;
+	icrl = icr_tmp & 0xff;
+	{
+		unsigned char idle_text[CPU_IDLE_TEXT_SIZE] = CPU_IDLE_TEXT_INIT(icrh, icrl);
+		simple_load_code(idle_text, dspbyte_to_virt(idle_boot_base),
+				 CPU_IDLE_TEXT_SIZE);
+	}
+	if (idle_boot_base == DSP_BOOT_ADR_MPUI)
+		dsp_boot_config(DSP_BOOT_CONFIG_MPUI);
+	else
+		dsp_set_rstvect(idle_boot_base);
+	__dsp_run();
+	udelay(100);	/* to make things stable */
+	clk_disable(api_ck_handle);
+}
+
+void dsp_set_idle_boot_base(dsp_long_t adr, size_t size)
+{
+	if (adr == idle_boot_base)
+		return;
+	idle_boot_base = adr;
+	if ((size < GBL_IDLE_TEXT_SIZE) ||
+	    (size < CPU_IDLE_TEXT_SIZE)) {
+		printk(KERN_ERR
+		       "omapdsp: size for idle program is not enough!\n");
+		BUG();
+	}
+
+	/* restart idle program with new base address */
+	if (cpustat.stat == CPUSTAT_GBL_IDLE)
+		dsp_gbl_idle();
+	if (cpustat.stat == CPUSTAT_CPU_IDLE)
+		dsp_cpu_idle();
+}
+
+void dsp_reset_idle_boot_base(void)
+{
+	idle_boot_base = DSP_BOOT_ADR_MPUI;
+}
+#else
+void dsp_reset_idle_boot_base(void) { }
+#endif /* CONFIG_ARCH_OMAP1 */
+
+static int init_done;
+
+static int omap_dsp_init(void)
+{
+	mutex_init(&cpustat.lock);
+
+	dspmem_size = 0;
+#ifdef CONFIG_ARCH_OMAP15XX
+	if (cpu_is_omap15xx()) {
+		dspmem_base = OMAP1510_DSP_BASE;
+		dspmem_size = OMAP1510_DSP_SIZE;
+		daram_base = OMAP1510_DARAM_BASE;
+		daram_size = OMAP1510_DARAM_SIZE;
+		saram_base = OMAP1510_SARAM_BASE;
+		saram_size = OMAP1510_SARAM_SIZE;
+	}
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
+	if (cpu_is_omap16xx()) {
+		dspmem_base = OMAP16XX_DSP_BASE;
+		dspmem_size = OMAP16XX_DSP_SIZE;
+		daram_base = OMAP16XX_DARAM_BASE;
+		daram_size = OMAP16XX_DARAM_SIZE;
+		saram_base = OMAP16XX_SARAM_BASE;
+		saram_size = OMAP16XX_SARAM_SIZE;
+	}
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
+	if (cpu_is_omap24xx()) {
+		dspmem_base = DSP_MEM_24XX_VIRT;
+		dspmem_size = DSP_MEM_24XX_SIZE;
+		daram_base = OMAP24XX_DARAM_BASE;
+		daram_size = OMAP24XX_DARAM_SIZE;
+		saram_base = OMAP24XX_SARAM_BASE;
+		saram_size = OMAP24XX_SARAM_SIZE;
+	}
+#endif
+#ifdef CONFIG_ARCH_OMAP34XX
+	/* To be Revisited for 3430 */
+	if (cpu_is_omap34xx()) {
+		return -ENODEV;
+	}
+#endif
+	if (dspmem_size == 0) {
+		printk(KERN_ERR "omapdsp: unsupported omap architecture.\n");
+		return -ENODEV;
+	}
+
+#if defined(CONFIG_ARCH_OMAP1)
+	dsp_ck_handle = clk_get(NULL, "dsp_ck");
+	if (IS_ERR(dsp_ck_handle)) {
+		printk(KERN_ERR "omapdsp: could not acquire dsp_ck handle.\n");
+		return PTR_ERR(dsp_ck_handle);
+	}
+
+	api_ck_handle = clk_get(NULL, "api_ck");
+	if (IS_ERR(api_ck_handle)) {
+		printk(KERN_ERR "omapdsp: could not acquire api_ck handle.\n");
+		if (dsp_ck_handle != NULL)
+			clk_put(dsp_ck_handle);
+		return PTR_ERR(api_ck_handle);
+	}
+
+	/* This is needed for McBSP init, released in late_initcall */
+	clk_enable(api_ck_handle);
+
+	__dsp_enable();
+	mpui_byteswap_off();
+	mpui_wordswap_on();
+	tc_wordswap();
+#elif defined(CONFIG_ARCH_OMAP2)
+	dsp_fck_handle = clk_get(NULL, "dsp_fck");
+	if (IS_ERR(dsp_fck_handle)) {
+		printk(KERN_ERR "omapdsp: could not acquire dsp_fck handle.\n");
+		return PTR_ERR(dsp_fck_handle);
+	}
+
+# if defined(CONFIG_ARCH_OMAP2420)
+	dsp_ick_handle = clk_get(NULL, "dsp_ick");
+# elif defined(CONFIG_ARCH_OMAP2430)
+	/*
+	 * 2430 has no separate switch for DSP ICLK, but this at least
+	 * involves the minimal change to the rest of the code.
+	 */
+	dsp_ick_handle = clk_get(NULL, "iva2_1_ick");
+# endif
+	if (IS_ERR(dsp_ick_handle)) {
+		printk(KERN_ERR "omapdsp: could not acquire dsp_ick handle.\n");
+		if (dsp_fck_handle != NULL)
+			clk_put(dsp_fck_handle);
+		return PTR_ERR(dsp_ick_handle);
+	}
+#endif
+
+	init_done = 1;
+	pr_info("omap_dsp_init() done\n");
+	return 0;
+}
+
+#if defined(CONFIG_ARCH_OMAP1)
+static int __dsp_late_init(void)
+{
+	clk_disable(api_ck_handle);
+	return 0;
+}
+late_initcall(__dsp_late_init);
+#endif
+
+static void dsp_cpustat_update(void)
+{
+	if (!init_done)
+		omap_dsp_init();
+
+	if (cpustat.req == CPUSTAT_RUN) {
+		if (cpustat.stat < CPUSTAT_RUN) {
+#if defined(CONFIG_ARCH_OMAP1)
+			__dsp_reset();
+			clk_enable(api_ck_handle);
+			udelay(10);
+			__dsp_run();
+#elif defined(CONFIG_ARCH_OMAP2)
+			__dsp_core_disable();
+			udelay(10);
+			__dsp_core_enable();
+#endif
+			cpustat.stat = CPUSTAT_RUN;
+		}
+		return;
+	}
+
+	/* cpustat.req < CPUSTAT_RUN */
+
+	if (cpustat.stat == CPUSTAT_RUN) {
+#ifdef CONFIG_ARCH_OMAP1
+		clk_disable(api_ck_handle);
+#endif
+	}
+
+#ifdef CONFIG_ARCH_OMAP1
+	/*
+	 * (1) when ARM wants DARAM access, MPUI should be SAM and
+	 *     DSP needs to be on.
+	 * (2) if any bits of icr is masked, we can not enter global idle.
+	 */
+	if ((cpustat.req == CPUSTAT_CPU_IDLE) ||
+	    (cpustat.usecount.mem > 0) ||
+	    (cpustat.usecount.mem_delayed > 0) ||
+	    ((cpustat.usecount.mpui > 0) && (cpustat.icrmask != 0xffff))) {
+		if (cpustat.stat != CPUSTAT_CPU_IDLE) {
+			dsp_cpu_idle();
+			cpustat.stat = CPUSTAT_CPU_IDLE;
+		}
+		return;
+	}
+
+	/*
+	 * when ARM only needs MPUI access, MPUI can be HOM and
+	 * DSP can be idling.
+	 */
+	if ((cpustat.req == CPUSTAT_GBL_IDLE) ||
+	    (cpustat.usecount.mpui > 0)) {
+		if (cpustat.stat != CPUSTAT_GBL_IDLE) {
+			dsp_gbl_idle();
+			cpustat.stat = CPUSTAT_GBL_IDLE;
+		}
+		return;
+	}
+#endif /* CONFIG_ARCH_OMAP1 */
+
+	/*
+	 * no user, no request
+	 */
+	if (cpustat.stat != CPUSTAT_RESET) {
+#if defined(CONFIG_ARCH_OMAP1)
+		__dsp_reset();
+#elif defined(CONFIG_ARCH_OMAP2)
+		__dsp_core_disable();
+#endif
+		cpustat.stat = CPUSTAT_RESET;
+	}
+}
+
+void dsp_cpustat_request(enum cpustat_e req)
+{
+	mutex_lock(&cpustat.lock);
+	cpustat.req = req;
+	dsp_cpustat_update();
+	mutex_unlock(&cpustat.lock);
+}
+
+enum cpustat_e dsp_cpustat_get_stat(void)
+{
+	return cpustat.stat;
+}
+
+u16 dsp_cpustat_get_icrmask(void)
+{
+	return cpustat.icrmask;
+}
+
+void dsp_cpustat_set_icrmask(u16 mask)
+{
+	mutex_lock(&cpustat.lock);
+	cpustat.icrmask = mask;
+	dsp_cpustat_update();
+	mutex_unlock(&cpustat.lock);
+}
+
+#ifdef CONFIG_ARCH_OMAP1
+void omap_dsp_request_mpui(void)
+{
+	mutex_lock(&cpustat.lock);
+	if (cpustat.usecount.mpui++ == 0)
+		dsp_cpustat_update();
+	mutex_unlock(&cpustat.lock);
+}
+
+void omap_dsp_release_mpui(void)
+{
+	mutex_lock(&cpustat.lock);
+	if (cpustat.usecount.mpui-- == 0) {
+		printk(KERN_ERR
+		       "omapdsp: unbalanced mpui request/release detected.\n"
+		       "         cpustat.usecount.mpui is going to be "
+		       "less than zero! ... fixed to be zero.\n");
+		cpustat.usecount.mpui = 0;
+	}
+	if (cpustat.usecount.mpui == 0)
+		dsp_cpustat_update();
+	mutex_unlock(&cpustat.lock);
+}
+
+#if defined(CONFIG_ARCH_OMAP1) && defined(CONFIG_OMAP_MMU_FWK)
+int omap_dsp_request_mem(void)
+{
+	int ret = 0;
+
+	mutex_lock(&cpustat.lock);
+	if ((cpustat.usecount.mem++ == 0) &&
+	    (cpustat.usecount.mem_delayed == 0)) {
+		if (cpustat.mem_req_cb) {
+			if ((ret = cpustat.mem_req_cb()) < 0) {
+				cpustat.usecount.mem--;
+				goto out;
+			}
+		}
+		dsp_cpustat_update();
+	}
+out:
+	mutex_unlock(&cpustat.lock);
+
+	return ret;
+}
+
+/*
+ * release_mem will be delayed.
+ */
+static void do_release_mem(struct work_struct *dummy)
+{
+	mutex_lock(&cpustat.lock);
+	cpustat.usecount.mem_delayed = 0;
+	if (cpustat.usecount.mem == 0) {
+		dsp_cpustat_update();
+		if (cpustat.mem_rel_cb)
+			cpustat.mem_rel_cb();
+	}
+	mutex_unlock(&cpustat.lock);
+}
+
+static DECLARE_DELAYED_WORK(mem_rel_work, do_release_mem);
+
+int omap_dsp_release_mem(void)
+{
+	mutex_lock(&cpustat.lock);
+
+	/* cancel previous release work */
+	cancel_delayed_work(&mem_rel_work);
+	cpustat.usecount.mem_delayed = 0;
+
+	if (cpustat.usecount.mem-- == 0) {
+		printk(KERN_ERR
+		       "omapdsp: unbalanced memory request/release detected.\n"
+		       "         cpustat.usecount.mem is going to be "
+		       "less than zero! ... fixed to be zero.\n");
+		cpustat.usecount.mem = 0;
+	}
+	if (cpustat.usecount.mem == 0) {
+		cpustat.usecount.mem_delayed = 1;
+		schedule_delayed_work(&mem_rel_work, HZ);
+	}
+
+	mutex_unlock(&cpustat.lock);
+
+	return 0;
+}
+#endif
+
+void dsp_register_mem_cb(int (*req_cb)(void), void (*rel_cb)(void))
+{
+	mutex_lock(&cpustat.lock);
+
+	cpustat.mem_req_cb = req_cb;
+	cpustat.mem_rel_cb = rel_cb;
+
+	/*
+	 * This function must be called while mem is enabled!
+	 */
+	BUG_ON(cpustat.usecount.mem == 0);
+
+	mutex_unlock(&cpustat.lock);
+}
+
+void dsp_unregister_mem_cb(void)
+{
+	mutex_lock(&cpustat.lock);
+	cpustat.mem_req_cb = NULL;
+	cpustat.mem_rel_cb = NULL;
+	mutex_unlock(&cpustat.lock);
+}
+#else
+void dsp_register_mem_cb(int (*req_cb)(void), void (*rel_cb)(void)) { }
+void dsp_unregister_mem_cb(void) { }
+#endif /* CONFIG_ARCH_OMAP1 */
+
+arch_initcall(omap_dsp_init);
+
+#ifdef CONFIG_ARCH_OMAP1
+EXPORT_SYMBOL(omap_dsp_request_mpui);
+EXPORT_SYMBOL(omap_dsp_release_mpui);
+#if defined(CONFIG_ARCH_OMAP1) && defined(CONFIG_OMAP_MMU_FWK)
+EXPORT_SYMBOL(omap_dsp_request_mem);
+EXPORT_SYMBOL(omap_dsp_release_mem);
+#endif
+#endif /* CONFIG_ARCH_OMAP1 */
+
+#ifdef CONFIG_OMAP_DSP_MODULE
+#if defined(CONFIG_ARCH_OMAP1)
+EXPORT_SYMBOL(dsp_ck_handle);
+EXPORT_SYMBOL(api_ck_handle);
+#elif defined(CONFIG_ARCH_OMAP2)
+EXPORT_SYMBOL(dsp_fck_handle);
+EXPORT_SYMBOL(dsp_ick_handle);
+#endif
+EXPORT_SYMBOL(omap_dsp);
+EXPORT_SYMBOL(dspmem_base);
+EXPORT_SYMBOL(dspmem_size);
+EXPORT_SYMBOL(daram_base);
+EXPORT_SYMBOL(daram_size);
+EXPORT_SYMBOL(saram_base);
+EXPORT_SYMBOL(saram_size);
+EXPORT_SYMBOL(dsp_set_rstvect);
+EXPORT_SYMBOL(dsp_get_rstvect);
+#ifdef CONFIG_ARCH_OMAP1
+EXPORT_SYMBOL(dsp_set_idle_boot_base);
+EXPORT_SYMBOL(dsp_reset_idle_boot_base);
+#endif /* CONFIG_ARCH_OMAP1 */
+EXPORT_SYMBOL(dsp_cpustat_request);
+EXPORT_SYMBOL(dsp_cpustat_get_stat);
+EXPORT_SYMBOL(dsp_cpustat_get_icrmask);
+EXPORT_SYMBOL(dsp_cpustat_set_icrmask);
+EXPORT_SYMBOL(dsp_register_mem_cb);
+EXPORT_SYMBOL(dsp_unregister_mem_cb);
+
+EXPORT_SYMBOL(__cpu_flush_kern_tlb_range);
+EXPORT_SYMBOL(cpu_architecture);
+EXPORT_SYMBOL(pmd_clear_bad);
+#endif
diff -Npru a/arch/arm/plat-omap/dsp/dsp.h b/arch/arm/plat-omap/dsp/dsp.h
--- a/arch/arm/plat-omap/dsp/dsp.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/dsp.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,391 @@
+/*
+ * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
+ *
+ * Copyright (C) 2002-2006 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __PLAT_OMAP_DSP_DSP_H
+#define __PLAT_OMAP_DSP_DSP_H
+
+#include "hardware_dsp.h"
+#include <mach/dsp_common.h>
+#include <mach/mmu.h>
+
+
+#ifdef CONFIG_ARCH_OMAP2
+#include "../../../arch/arm/mach-omap2/prm.h"
+#include "../../../arch/arm/mach-omap2/prm-regbits-24xx.h"
+#include "../../../arch/arm/mach-omap2/cm.h"
+#include "../../../arch/arm/mach-omap2/cm-regbits-24xx.h"
+#endif
+
+/*
+ * MAJOR device number: !! allocated arbitrary !!
+ */
+#define OMAP_DSP_CTL_MAJOR		96
+#define OMAP_DSP_TASK_MAJOR		97
+
+#define OLD_BINARY_SUPPORT	y
+
+#ifdef OLD_BINARY_SUPPORT
+#define MBREV_3_0	0x0017
+#define MBREV_3_2	0x0018
+#endif
+
+#define DSP_INIT_PAGE	0xfff000
+
+#ifdef CONFIG_ARCH_OMAP1
+/* idle program will be placed at IDLEPG_BASE. */
+#define IDLEPG_BASE	0xfffe00
+#define IDLEPG_SIZE	0x100
+#endif /* CONFIG_ARCH_OMAP1 */
+
+/* timeout value for DSP response */
+#define DSP_TIMEOUT	(10 * HZ)
+
+enum dsp_mem_type_e {
+	MEM_TYPE_CROSSING = -1,
+	MEM_TYPE_NONE = 0,
+	MEM_TYPE_DARAM,
+	MEM_TYPE_SARAM,
+	MEM_TYPE_EXTERN,
+};
+
+
+typedef int __bitwise arm_dsp_dir_t;
+#define DIR_A2D	((__force arm_dsp_dir_t) 1)
+#define DIR_D2A	((__force arm_dsp_dir_t) 2)
+
+enum cfgstat_e {
+	CFGSTAT_CLEAN = 0,
+	CFGSTAT_READY,
+	CFGSTAT_SUSPEND,
+	CFGSTAT_RESUME,	/* request only */
+	CFGSTAT_MAX
+};
+
+enum errcode_e {
+	ERRCODE_WDT = 0,
+	ERRCODE_MMU,
+	ERRCODE_MAX
+};
+
+/* keep 2 entries for TID_FREE and TID_ANON */
+#define TASKDEV_MAX	254
+
+#define MK32(uw,lw)	(((u32)(uw)) << 16 | (lw))
+#define MKLONG(uw,lw)	(((unsigned long)(uw)) << 16 | (lw))
+#define MKVIRT(uw,lw)	dspword_to_virt(MKLONG((uw), (lw)));
+
+struct sync_seq {
+	u16 da_dsp;
+	u16 da_arm;
+	u16 ad_dsp;
+	u16 ad_arm;
+};
+
+struct mem_sync_struct {
+	struct sync_seq *DARAM;
+	struct sync_seq *SARAM;
+	struct sync_seq *SDRAM;
+};
+
+/* struct mbcmd and union mbcmd_hw must be compatible */
+struct mbcmd {
+	u32 data:16;
+	u32 cmd_l:8;
+	u32 cmd_h:7;
+	u32 seq:1;
+};
+
+#define MBCMD_INIT(h, l, d) { \
+		.cmd_h = (h), \
+		.cmd_l = (l), \
+		.data  = (d), \
+	}
+
+struct mb_exarg {
+	u8 tid;
+	int argc;
+	u16 *argv;
+};
+
+typedef u32 dsp_long_t;	/* must have ability to carry TADD_ABORTADR */
+
+extern void dsp_mbox_start(void);
+extern void dsp_mbox_stop(void);
+extern int dsp_mbox_config(void *p);
+extern int sync_with_dsp(u16 *syncwd, u16 tid, int try_cnt);
+extern int __dsp_mbcmd_send_exarg(struct mbcmd *mb, struct mb_exarg *arg,
+				  int recovery_flag);
+#define dsp_mbcmd_send(mb)		__dsp_mbcmd_send_exarg((mb), NULL, 0)
+#define dsp_mbcmd_send_exarg(mb, arg)	__dsp_mbcmd_send_exarg((mb), (arg), 0)
+extern int dsp_mbcmd_send_and_wait_exarg(struct mbcmd *mb, struct mb_exarg *arg,
+					 wait_queue_head_t *q);
+#define dsp_mbcmd_send_and_wait(mb, q) \
+	dsp_mbcmd_send_and_wait_exarg((mb), NULL, (q))
+
+static inline int __mbcompose_send_exarg(u8 cmd_h, u8 cmd_l, u16 data,
+					     struct mb_exarg *arg,
+					     int recovery_flag)
+{
+	struct mbcmd mb = MBCMD_INIT(cmd_h, cmd_l, data);
+	return __dsp_mbcmd_send_exarg(&mb, arg, recovery_flag);
+}
+#define mbcompose_send(cmd_h, cmd_l, data) \
+	__mbcompose_send_exarg(MBOX_CMD_DSP_##cmd_h, (cmd_l), (data), NULL, 0)
+#define mbcompose_send_exarg(cmd_h, cmd_l, data, arg) \
+	__mbcompose_send_exarg(MBOX_CMD_DSP_##cmd_h, (cmd_l), (data), arg, 0)
+#define mbcompose_send_recovery(cmd_h, cmd_l, data) \
+	__mbcompose_send_exarg(MBOX_CMD_DSP_##cmd_h, (cmd_l), (data), NULL, 1)
+
+static inline int __mbcompose_send_and_wait_exarg(u8 cmd_h, u8 cmd_l,
+						      u16 data,
+						      struct mb_exarg *arg,
+						      wait_queue_head_t *q)
+{
+	struct mbcmd mb = MBCMD_INIT(cmd_h, cmd_l, data);
+	return dsp_mbcmd_send_and_wait_exarg(&mb, arg, q);
+}
+#define mbcompose_send_and_wait(cmd_h, cmd_l, data, q) \
+	__mbcompose_send_and_wait_exarg(MBOX_CMD_DSP_##cmd_h, (cmd_l), (data), \
+					NULL, (q))
+#define mbcompose_send_and_wait_exarg(cmd_h, cmd_l, data, arg, q) \
+	__mbcompose_send_and_wait_exarg(MBOX_CMD_DSP_##cmd_h, (cmd_l), (data), \
+					(arg), (q))
+
+extern struct ipbuf_head *bid_to_ipbuf(u16 bid);
+extern void ipbuf_start(void);
+extern void ipbuf_stop(void);
+extern int ipbuf_config(u16 ln, u16 lsz, void *base);
+extern int ipbuf_sys_config(void *p, arm_dsp_dir_t dir);
+extern int ipbuf_p_validate(void *p, arm_dsp_dir_t dir);
+extern struct ipbuf_head *get_free_ipbuf(u8 tid);
+extern void release_ipbuf(struct ipbuf_head *ipb_h);
+extern void balance_ipbuf(void);
+extern void unuse_ipbuf(struct ipbuf_head *ipb_h);
+extern void unuse_ipbuf_nowait(struct ipbuf_head *ipb_h);
+
+#define release_ipbuf_pvt(ipbuf_pvt) \
+	do { \
+		(ipbuf_pvt)->s = TID_FREE; \
+	} while(0)
+
+extern int mbox_revision;
+
+extern int dsp_cfgstat_request(enum cfgstat_e st);
+extern enum cfgstat_e dsp_cfgstat_get_stat(void);
+extern int dsp_set_runlevel(u8 level);
+
+extern int dsp_task_config_all(u8 n);
+extern void dsp_task_unconfig_all(void);
+extern u8 dsp_task_count(void);
+extern int dsp_taskmod_busy(void);
+extern int dsp_mkdev(char *name);
+extern int dsp_rmdev(char *name);
+extern int dsp_tadd_minor(unsigned char minor, dsp_long_t adr);
+extern int dsp_tdel_minor(unsigned char minor);
+extern int dsp_tkill_minor(unsigned char minor);
+extern long taskdev_state_stale(unsigned char minor);
+extern int dsp_dbg_config(u16 *buf, u16 sz, u16 lsz);
+extern void dsp_dbg_stop(void);
+
+extern int ipbuf_is_held(u8 tid, u16 bid);
+
+extern int dsp_mem_sync_inc(void);
+extern int dsp_mem_sync_config(struct mem_sync_struct *sync);
+extern enum dsp_mem_type_e dsp_mem_type(void *vadr, size_t len);
+extern int dsp_address_validate(void *p, size_t len, char *fmt, ...);
+#ifdef CONFIG_ARCH_OMAP1
+extern void dsp_mem_usecount_clear(void);
+#endif
+extern void exmap_use(void *vadr, size_t len);
+extern void exmap_unuse(void *vadr, size_t len);
+extern unsigned long dsp_virt_to_phys(void *vadr, size_t *len);
+extern void dsp_mem_start(void);
+extern void dsp_mem_stop(void);
+
+extern void dsp_twch_start(void);
+extern void dsp_twch_stop(void);
+extern void dsp_twch_touch(void);
+
+extern void dsp_err_start(void);
+extern void dsp_err_stop(void);
+extern void dsp_err_set(enum errcode_e code, unsigned long arg);
+extern void dsp_err_clear(enum errcode_e code);
+extern int dsp_err_isset(enum errcode_e code);
+
+enum cmd_l_type_e {
+	CMD_L_TYPE_NULL,
+	CMD_L_TYPE_TID,
+	CMD_L_TYPE_SUBCMD,
+};
+
+struct cmdinfo {
+	char *name;
+	enum cmd_l_type_e cmd_l_type;
+	void (*handler)(struct mbcmd *mb);
+};
+
+extern const struct cmdinfo *cmdinfo[];
+
+#define cmd_name(mb)	(cmdinfo[(mb).cmd_h]->name)
+extern char *subcmd_name(struct mbcmd *mb);
+
+extern void mblog_add(struct mbcmd *mb, arm_dsp_dir_t dir);
+
+extern struct omap_mmu dsp_mmu;
+
+#define dsp_mem_enable(addr)	omap_mmu_mem_enable(&dsp_mmu, (addr))
+#define dsp_mem_disable(addr)	omap_mmu_mem_disable(&dsp_mmu, (addr))
+
+#define DSPSPACE_SIZE	0x1000000
+
+#define omap_set_bit_regw(b,r) \
+	do { omap_writew(omap_readw(r) | (b), (r)); } while(0)
+#define omap_clr_bit_regw(b,r) \
+	do { omap_writew(omap_readw(r) & ~(b), (r)); } while(0)
+#define omap_set_bit_regl(b,r) \
+	do { omap_writel(omap_readl(r) | (b), (r)); } while(0)
+#define omap_clr_bit_regl(b,r) \
+	do { omap_writel(omap_readl(r) & ~(b), (r)); } while(0)
+#define omap_set_bits_regl(val,mask,r) \
+	do { omap_writel((omap_readl(r) & ~(mask)) | (val), (r)); } while(0)
+
+#define dspword_to_virt(dw)	((void *)(dspmem_base + ((dw) << 1)))
+#define dspbyte_to_virt(db)	((void *)(dspmem_base + (db)))
+#define virt_to_dspword(va) \
+	((dsp_long_t)(((unsigned long)(va) - dspmem_base) >> 1))
+#define virt_to_dspbyte(va) \
+	((dsp_long_t)((unsigned long)(va) - dspmem_base))
+#define is_dsp_internal_mem(va) \
+	(((unsigned long)(va) >= dspmem_base) &&  \
+	 ((unsigned long)(va) < dspmem_base + dspmem_size))
+#define is_dspbyte_internal_mem(db)	((db) < dspmem_size)
+#define is_dspword_internal_mem(dw)	(((dw) << 1) < dspmem_size)
+
+#ifdef CONFIG_ARCH_OMAP1
+/*
+ * MPUI byteswap/wordswap on/off
+ *   default setting: wordswap = all, byteswap = APIMEM only
+ */
+#define mpui_wordswap_on() \
+	omap_set_bits_regl(MPUI_CTRL_WORDSWAP_ALL, MPUI_CTRL_WORDSWAP_MASK, \
+			   MPUI_CTRL)
+
+#define mpui_wordswap_off() \
+	omap_set_bits_regl(MPUI_CTRL_WORDSWAP_NONE, MPUI_CTRL_WORDSWAP_MASK, \
+			   MPUI_CTRL)
+
+#define mpui_byteswap_on() \
+	omap_set_bits_regl(MPUI_CTRL_BYTESWAP_API, MPUI_CTRL_BYTESWAP_MASK, \
+			   MPUI_CTRL)
+
+#define mpui_byteswap_off() \
+	omap_set_bits_regl(MPUI_CTRL_BYTESWAP_NONE, MPUI_CTRL_BYTESWAP_MASK, \
+			   MPUI_CTRL)
+
+/*
+ * TC wordswap on / off
+ */
+#define tc_wordswap() \
+	do { \
+		omap_writel(TC_ENDIANISM_SWAP_WORD | TC_ENDIANISM_EN, \
+			    TC_ENDIANISM); \
+	} while(0)
+
+#define tc_noswap()	omap_clr_bit_regl(TC_ENDIANISM_EN, TC_ENDIANISM)
+
+/*
+ * enable priority registers, EMIF, MPUI control logic
+ */
+#define __dsp_enable()	omap_set_bit_regw(ARM_RSTCT1_DSP_RST, ARM_RSTCT1)
+#define __dsp_disable()	omap_clr_bit_regw(ARM_RSTCT1_DSP_RST, ARM_RSTCT1)
+#define __dsp_run()	omap_set_bit_regw(ARM_RSTCT1_DSP_EN, ARM_RSTCT1)
+#define __dsp_reset()	omap_clr_bit_regw(ARM_RSTCT1_DSP_EN, ARM_RSTCT1)
+#endif /* CONFIG_ARCH_OMAP1 */
+
+#ifdef CONFIG_ARCH_OMAP2
+/*
+ * PRCM / IPI control logic
+ *
+ * REVISIT: these macros should probably be static inline functions
+ */
+#define __dsp_core_enable() \
+	do { prm_write_mod_reg(prm_read_mod_reg(OMAP24XX_DSP_MOD, RM_RSTCTRL) \
+	     & ~OMAP24XX_RST1_DSP, OMAP24XX_DSP_MOD, RM_RSTCTRL); } while (0)
+#define __dsp_core_disable() \
+	do { prm_write_mod_reg(prm_read_mod_reg(OMAP24XX_DSP_MOD, RM_RSTCTRL) \
+	     | OMAP24XX_RST1_DSP, OMAP24XX_DSP_MOD, RM_RSTCTRL); } while (0)
+#define __dsp_per_enable() \
+	do { prm_write_mod_reg(prm_read_mod_reg(OMAP24XX_DSP_MOD, RM_RSTCTRL) \
+	     & ~OMAP24XX_RST2_DSP, OMAP24XX_DSP_MOD, RM_RSTCTRL); } while (0)
+#define __dsp_per_disable() \
+	do { prm_write_mod_reg(prm_read_mod_reg(OMAP24XX_DSP_MOD, RM_RSTCTRL) \
+	     | OMAP24XX_RST2_DSP, OMAP24XX_DSP_MOD, RM_RSTCTRL); } while (0)
+#endif /* CONFIG_ARCH_OMAP2 */
+
+#if defined(CONFIG_ARCH_OMAP1)
+extern struct clk *dsp_ck_handle;
+extern struct clk *api_ck_handle;
+#elif defined(CONFIG_ARCH_OMAP2)
+extern struct clk *dsp_fck_handle;
+extern struct clk *dsp_ick_handle;
+#endif
+extern dsp_long_t dspmem_base, dspmem_size,
+		  daram_base, daram_size,
+		  saram_base, saram_size;
+
+enum cpustat_e {
+	CPUSTAT_RESET = 0,
+#ifdef CONFIG_ARCH_OMAP1
+	CPUSTAT_GBL_IDLE,
+	CPUSTAT_CPU_IDLE,
+#endif
+	CPUSTAT_RUN,
+	CPUSTAT_MAX
+};
+
+int dsp_set_rstvect(dsp_long_t adr);
+dsp_long_t dsp_get_rstvect(void);
+void dsp_set_idle_boot_base(dsp_long_t adr, size_t size);
+void dsp_reset_idle_boot_base(void);
+void dsp_cpustat_request(enum cpustat_e req);
+enum cpustat_e dsp_cpustat_get_stat(void);
+u16 dsp_cpustat_get_icrmask(void);
+void dsp_cpustat_set_icrmask(u16 mask);
+void dsp_register_mem_cb(int (*req_cb)(void), void (*rel_cb)(void));
+void dsp_unregister_mem_cb(void);
+
+#if defined(CONFIG_ARCH_OMAP1)
+#define command_dvfs_stop(m) (0)
+#define command_dvfs_start(m) (0)
+#elif defined(CONFIG_ARCH_OMAP2)
+#define command_dvfs_stop(m) \
+	(((m)->cmd_l == KFUNC_POWER) && ((m)->data == DVFS_STOP))
+#define command_dvfs_start(m) \
+	(((m)->cmd_l == KFUNC_POWER) && ((m)->data == DVFS_START))
+#endif
+
+extern struct omap_dsp *omap_dsp;
+
+extern int dsp_late_init(void);
+
+#endif /* __PLAT_OMAP_DSP_DSP_H */
diff -Npru a/arch/arm/plat-omap/dsp/hardware_dsp.h b/arch/arm/plat-omap/dsp/hardware_dsp.h
--- a/arch/arm/plat-omap/dsp/hardware_dsp.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/hardware_dsp.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,34 @@
+/*
+ * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
+ *
+ * Copyright (C) 2002-2006 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __OMAP_DSP_HARDWARE_DSP_H
+#define __OMAP_DSP_HARDWARE_DSP_H
+
+#ifdef CONFIG_ARCH_OMAP1
+#include "omap1_dsp.h"
+#endif
+#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3430)
+#include "omap2_dsp.h"
+#endif
+
+#endif /* __OMAP_DSP_HARDWARE_DSP_H */
diff -Npru a/arch/arm/plat-omap/dsp/mmu.h b/arch/arm/plat-omap/dsp/mmu.h
--- a/arch/arm/plat-omap/dsp/mmu.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/mmu.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,140 @@
+#ifndef __PLAT_OMAP_DSP_MMU_H
+#define __PLAT_OMAP_DSP_MMU_H
+
+#ifdef CONFIG_ARCH_OMAP1
+
+#ifdef CONFIG_ARCH_OMAP15XX
+struct omap_mmu dsp_mmu = {
+	.name		= "mmu:dsp",
+	.type		= OMAP_MMU_DSP,
+	.base		= IO_ADDRESS(OMAP1510_DSP_MMU_BASE),
+	.membase	= OMAP1510_DSP_BASE,
+	.memsize	= OMAP1510_DSP_SIZE,
+	.nr_tlb_entries	= 32,
+	.addrspace	= 24,
+	.irq		= INT_1510_DSP_MMU,
+	.ops		= &omap1_mmu_ops,
+};
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
+struct omap_mmu dsp_mmu = {
+	.name		= "mmu:dsp",
+	.type		= OMAP_MMU_DSP,
+	.base		= IO_ADDRESS(OMAP16XX_DSP_MMU_BASE),
+	.membase	= OMAP16XX_DSP_BASE,
+	.memsize	= OMAP16XX_DSP_SIZE,
+	.nr_tlb_entries	= 32,
+	.addrspace	= 24,
+	.irq		= INT_1610_DSP_MMU,
+	.ops		= &omap1_mmu_ops,
+};
+#endif
+#else /* OMAP2 */
+struct omap_mmu dsp_mmu = {
+	.name		= "mmu:dsp",
+	.type		= OMAP_MMU_DSP,
+	.base		= DSP_MMU_24XX_VIRT,
+	.membase	= DSP_MEM_24XX_VIRT,
+	.memsize	= DSP_MEM_24XX_SIZE,
+	.nr_tlb_entries	= 32,
+	.addrspace	= 24,
+	.irq		= INT_24XX_DSP_MMU,
+	.ops		= &omap2_mmu_ops,
+};
+
+#define IOMAP_VAL	0x3f
+#endif
+
+#ifdef CONFIG_FB_OMAP_LCDC_EXTERNAL
+static struct omapfb_notifier_block *omapfb_nb;
+static int omapfb_ready;
+#endif
+
+/*
+ * OMAP1 EMIFF access
+ */
+#ifdef CONFIG_ARCH_OMAP1
+#define EMIF_PRIO_LB_MASK	0x0000f000
+#define EMIF_PRIO_LB_SHIFT	12
+#define EMIF_PRIO_DMA_MASK	0x00000f00
+#define EMIF_PRIO_DMA_SHIFT	8
+#define EMIF_PRIO_DSP_MASK	0x00000070
+#define EMIF_PRIO_DSP_SHIFT	4
+#define EMIF_PRIO_MPU_MASK	0x00000007
+#define EMIF_PRIO_MPU_SHIFT	0
+#define set_emiff_dma_prio(prio) \
+	do { \
+		omap_writel((omap_readl(OMAP_TC_OCPT1_PRIOR) & \
+			     ~EMIF_PRIO_DMA_MASK) | \
+			    ((prio) << EMIF_PRIO_DMA_SHIFT), \
+			    OMAP_TC_OCPT1_PRIOR); \
+	} while(0)
+#else
+#define set_emiff_dma_prio(prio)	do { } while (0)
+#endif /* CONFIG_ARCH_OMAP1 */
+
+#ifdef CONFIG_ARCH_OMAP1
+static int dsp_mmu_itack(void)
+{
+	unsigned long dspadr;
+
+	pr_info("omapdsp: sending DSP MMU interrupt ack.\n");
+	if (!dsp_err_isset(ERRCODE_MMU)) {
+		printk(KERN_ERR "omapdsp: DSP MMU error has not been set.\n");
+		return -EINVAL;
+	}
+	dspadr = dsp_mmu.fault_address & ~(SZ_4K-1);
+	/* FIXME: reserve TLB entry for this */
+	omap_mmu_exmap(&dsp_mmu, dspadr, 0, SZ_4K, EXMAP_TYPE_MEM);
+	pr_info("omapdsp: falling into recovery runlevel...\n");
+	dsp_set_runlevel(RUNLEVEL_RECOVERY);
+	omap_mmu_itack(&dsp_mmu);
+	udelay(100);
+	omap_mmu_exunmap(&dsp_mmu, dspadr);
+	dsp_err_clear(ERRCODE_MMU);
+	return 0;
+}
+
+/*
+ * intmem_enable() / disable():
+ * if the address is in DSP internal memories,
+ * we send PM mailbox commands so that DSP DMA domain won't go in idle
+ * when ARM is accessing to those memories.
+ */
+static int intmem_enable(void)
+{
+	int ret = 0;
+
+	if (dsp_cfgstat_get_stat() == CFGSTAT_READY)
+		ret = mbcompose_send(PM, PM_ENABLE, DSPREG_ICR_DMA);
+
+	return ret;
+}
+
+static void intmem_disable(void) {
+	if (dsp_cfgstat_get_stat() == CFGSTAT_READY)
+		mbcompose_send(PM, PM_DISABLE, DSPREG_ICR_DMA);
+}
+#else
+static int intmem_enable(void) { return 0; }
+static void intmem_disable(void) { }
+static int dsp_mmu_itack(void) { return 0; }
+#endif
+
+#ifdef CONFIG_ARCH_OMAP2
+static inline void dsp_mem_ipi_init(void)
+{
+	int i, dspmem_pg_count;
+	dspmem_pg_count = dspmem_size >> 12;
+	for (i = 0; i < dspmem_pg_count; i++) {
+		writel(i, DSP_IPI_INDEX);
+		writel(DSP_IPI_ENTRY_ELMSIZEVALUE_16, DSP_IPI_ENTRY);
+	}
+	writel(1, DSP_IPI_ENABLE);
+	writel(IOMAP_VAL, DSP_IPI_IOMAP);
+}
+#else
+static inline void dsp_mem_ipi_init(void) { }
+#endif
+
+#endif /* __PLAT_OMAP_DSP_MMU_H */
diff -Npru a/arch/arm/plat-omap/include/mach/mmu.h b/arch/arm/plat-omap/include/mach/mmu.h
--- a/arch/arm/plat-omap/include/mach/mmu.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/include/mach/mmu.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,211 @@
+#ifndef __ARCH_OMAP_MMU_H
+#define __ARCH_OMAP_MMU_H
+
+#include <linux/device.h>
+#include <linux/workqueue.h>
+
+enum exmap_type {
+	EXMAP_TYPE_MEM,
+	EXMAP_TYPE_FB
+};
+
+enum omap_mmu_type {
+	OMAP_MMU_DSP,
+	OMAP_MMU_IVA1,
+	OMAP_MMU_CAMERA,
+};
+
+struct exmap_tbl {
+	unsigned int valid:1;
+	unsigned int prsvd:1;
+	int usecount;		/* reference count by mmap */
+	enum exmap_type type;
+	void *buf;		/* virtual address of the buffer,
+				 * i.e. 0xc0000000 - */
+	void *vadr;		/* DSP shadow space,
+				 * i.e. 0xe0000000 - 0xe0ffffff */
+	unsigned int order;
+	struct {
+		int prev;
+		int next;
+	} link;			/* grouping */
+};
+
+struct cam_ram_regset {
+	union {
+		struct {
+			u16 cam_l;
+			u16 cam_h;
+		};
+
+		u32 cam;
+	};
+
+	union {
+		struct {
+			u16 ram_l;
+			u16 ram_h;
+		};
+
+		u32 ram;
+	};
+};
+
+struct omap_mmu_tlb_lock {
+	int base;
+	int victim;
+};
+
+struct omap_mmu;
+struct omap_mmu_tlb_entry;
+
+#ifdef CONFIG_ARCH_OMAP1
+extern struct omap_mmu_ops omap1_mmu_ops;
+extern void omap_mmu_itack(struct omap_mmu *mmu);
+#elif defined(CONFIG_ARCH_OMAP2)
+extern struct omap_mmu_ops omap2_mmu_ops;
+static inline void omap_mmu_itack(struct omap_mmu *mmu)
+{
+}
+#endif
+
+struct omap_mmu_ops {
+	int (*startup)(struct omap_mmu *mmu);
+	void (*shutdown)(struct omap_mmu *mmu);
+
+	/* TLB operations */
+	void (*read_tlb)(struct omap_mmu *, struct cam_ram_regset *);
+	void (*load_tlb)(struct omap_mmu *, struct cam_ram_regset *);
+	ssize_t (*show)(struct omap_mmu *, char *, struct omap_mmu_tlb_lock *);
+
+	/* CAM / RAM operations */
+	struct cam_ram_regset *(*cam_ram_alloc)(struct omap_mmu *,
+						struct omap_mmu_tlb_entry *);
+	int (*cam_ram_valid)(struct cam_ram_regset *);
+	unsigned long (*cam_va)(struct cam_ram_regset *);
+
+	/* Memory operations */
+	int (*mem_enable)(struct omap_mmu *, void *);
+	int (*mem_disable)(struct omap_mmu *, void *);
+
+	void (*interrupt)(struct omap_mmu *);
+
+	/* PTE attribute operations */
+	pgprot_t (*pte_get_attr)(struct omap_mmu_tlb_entry *);
+};
+
+struct omap_mmu {
+	const char *name;
+	unsigned long base;
+	struct clk *clk;
+
+	unsigned long membase, memsize;
+	struct clk *memclk;
+
+	enum omap_mmu_type type;
+
+	struct device *dev;
+
+	struct rw_semaphore exmap_sem;
+	struct exmap_tbl *exmap_tbl;
+
+	unsigned int nr_tlb_entries;
+	unsigned int nr_exmap_preserved;
+
+	struct mm_struct *twl_mm;
+
+	/* Size of virtual address space, in bits */
+	unsigned int addrspace;
+
+	/* Interrupt */
+	unsigned int irq;
+	unsigned long fault_address;
+	struct work_struct irq_work;
+
+	struct omap_mmu_ops *ops;
+};
+
+#define omap_mmu_internal_memory(mmu, addr)					\
+	(likely(mmu->membase) && (((unsigned long)(addr) >= mmu->membase) &&	\
+		 ((unsigned long)(addr) < mmu->membase + mmu->memsize)))
+
+#define INIT_EXMAP_TBL_ENTRY(ent, b, v, typ, od)	\
+do {						\
+	(ent)->buf		= (b);		\
+	(ent)->vadr		= (v);		\
+	(ent)->valid		= 1;		\
+	(ent)->prsvd		= 0;		\
+	(ent)->usecount		= 0;		\
+	(ent)->type		= (typ);	\
+	(ent)->order		= (od);		\
+	(ent)->link.next	= -1;		\
+	(ent)->link.prev	= -1;		\
+} while (0)
+
+#define INIT_EXMAP_TBL_ENTRY_4KB_PRESERVED(ent, b, v)	\
+do {							\
+	(ent)->buf		= (b);			\
+	(ent)->vadr		= (v);			\
+	(ent)->valid		= 1;			\
+	(ent)->prsvd		= 1;			\
+	(ent)->usecount		= 0;			\
+	(ent)->type		= EXMAP_TYPE_MEM;	\
+	(ent)->order		= 0;			\
+	(ent)->link.next	= -1;			\
+	(ent)->link.prev	= -1;			\
+} while (0)
+
+#define omap_mmu_to_virt(mmu, db)	((void *)((mmu)->membase + (db)))
+#define virt_to_omap_mmu(mmu, va) \
+	(((unsigned long)(va) - (mmu)->membase))
+
+/* arch/arm/plat-omap/mmu.c */
+int omap_mmu_register(struct omap_mmu *mmu);
+void omap_mmu_unregister(struct omap_mmu *mmu);
+
+void omap_mmu_enable(struct omap_mmu *mmu, int reset);
+void omap_mmu_disable(struct omap_mmu *mmu);
+
+int omap_mmu_mem_enable(struct omap_mmu *mmu, void *addr);
+void omap_mmu_mem_disable(struct omap_mmu *mmu, void *addr);
+
+void omap_mmu_read_tlb(struct omap_mmu *mmu, struct omap_mmu_tlb_lock *lock,
+		       struct cam_ram_regset *cr);
+
+int omap_mmu_load_tlb_entry(struct omap_mmu *, struct omap_mmu_tlb_entry *);
+int omap_mmu_clear_tlb_entry(struct omap_mmu *, unsigned long vadr);
+
+int omap_mmu_load_pte_entry(struct omap_mmu *mmu,
+			    struct omap_mmu_tlb_entry *entry);
+int omap_mmu_clear_pte_entry(struct omap_mmu *mmu, unsigned long vadr);
+
+int omap_mmu_kmem_reserve(struct omap_mmu *mmu, unsigned long size);
+void omap_mmu_kmem_release(void);
+
+unsigned long omap_mmu_virt_to_phys(struct omap_mmu *mmu, void *vadr,
+				    size_t *len);
+
+int omap_mmu_exmap(struct omap_mmu *mmu, unsigned long dspadr,
+		   unsigned long padr, unsigned long size,
+		   enum exmap_type type);
+int omap_mmu_exunmap(struct omap_mmu *mmu, unsigned long dspadr);
+void omap_mmu_exmap_flush(struct omap_mmu *mmu);
+void omap_mmu_exmap_use(struct omap_mmu *mmu, void *vadr, size_t len);
+void omap_mmu_exmap_unuse(struct omap_mmu *mmu, void *vadr, size_t len);
+
+int exmap_set_armmmu(struct omap_mmu *mmu, unsigned long virt,
+		     unsigned long phys, unsigned long size);
+void exmap_clear_armmmu(struct omap_mmu *mmu, unsigned long virt,
+			unsigned long size);
+void exmap_setup_preserved_mem_page(struct omap_mmu *mmu, void *buf,
+				    unsigned long dspadr, int index);
+void exmap_clear_mem_page(struct omap_mmu *mmu, unsigned long dspadr);
+int exmap_valid(struct omap_mmu *mmu, void *vadr, size_t len);
+
+/* To be obsolete for backward compatibility */
+ssize_t __omap_mmu_mem_read(struct omap_mmu *mmu, struct bin_attribute *,
+			    char *buf, loff_t offset, size_t count);
+ssize_t __omap_mmu_mem_write(struct omap_mmu *mmu, struct bin_attribute *,
+			    char *buf, loff_t offset, size_t count);
+
+#endif /* __ARCH_OMAP_MMU_H */
diff -Npru a/arch/arm/mach-omap1/mmu.h b/arch/arm/mach-omap1/mmu.h
--- a/arch/arm/mach-omap1/mmu.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/mach-omap1/mmu.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,119 @@
+#ifndef __MACH_OMAP1_MMU_H
+#define __MACH_OMAP1_MMU_H
+
+#include <linux/io.h>
+#include <mach/mmu.h>
+
+#define MMU_LOCK_BASE_MASK		(0x3f << 10)
+#define MMU_LOCK_VICTIM_MASK		(0x3f << 4)
+
+#define OMAP_MMU_PREFETCH		0x00
+#define OMAP_MMU_WALKING_ST		0x04
+#define OMAP_MMU_CNTL			0x08
+#define OMAP_MMU_FAULT_AD_H		0x0c
+#define OMAP_MMU_FAULT_AD_L		0x10
+#define OMAP_MMU_FAULT_ST		0x14
+#define OMAP_MMU_IT_ACK			0x18
+#define OMAP_MMU_TTB_H			0x1c
+#define OMAP_MMU_TTB_L			0x20
+#define OMAP_MMU_LOCK			0x24
+#define OMAP_MMU_LD_TLB			0x28
+#define OMAP_MMU_CAM_H			0x2c
+#define OMAP_MMU_CAM_L			0x30
+#define OMAP_MMU_RAM_H			0x34
+#define OMAP_MMU_RAM_L			0x38
+#define OMAP_MMU_GFLUSH			0x3c
+#define OMAP_MMU_FLUSH_ENTRY		0x40
+#define OMAP_MMU_READ_CAM_H		0x44
+#define OMAP_MMU_READ_CAM_L		0x48
+#define OMAP_MMU_READ_RAM_H		0x4c
+#define OMAP_MMU_READ_RAM_L		0x50
+
+#define OMAP_MMU_CNTL_BURST_16MNGT_EN	0x0020
+#define OMAP_MMU_CNTL_WTL_EN		0x0004
+#define OMAP_MMU_CNTL_MMU_EN		0x0002
+#define OMAP_MMU_CNTL_RESET_SW		0x0001
+
+#define OMAP_MMU_FAULT_AD_H_DP		0x0100
+#define OMAP_MMU_FAULT_AD_H_ADR_MASK	0x00ff
+
+#define OMAP_MMU_FAULT_ST_PREF		0x0008
+#define OMAP_MMU_FAULT_ST_PERM		0x0004
+#define OMAP_MMU_FAULT_ST_TLB_MISS	0x0002
+#define OMAP_MMU_FAULT_ST_TRANS		0x0001
+
+#define OMAP_MMU_IT_ACK_IT_ACK		0x0001
+
+#define OMAP_MMU_CAM_H_VA_TAG_H_MASK		0x0003
+
+#define OMAP_MMU_CAM_L_VA_TAG_L1_MASK		0xc000
+#define OMAP_MMU_CAM_L_VA_TAG_L2_MASK_1MB	0x0000
+#define OMAP_MMU_CAM_L_VA_TAG_L2_MASK_64KB	0x3c00
+#define OMAP_MMU_CAM_L_VA_TAG_L2_MASK_4KB	0x3fc0
+#define OMAP_MMU_CAM_L_VA_TAG_L2_MASK_1KB	0x3ff0
+#define OMAP_MMU_CAM_L_P			0x0008
+#define OMAP_MMU_CAM_L_V			0x0004
+#define OMAP_MMU_CAM_L_PAGESIZE_MASK		0x0003
+#define OMAP_MMU_CAM_L_PAGESIZE_1MB		0x0000
+#define OMAP_MMU_CAM_L_PAGESIZE_64KB		0x0001
+#define OMAP_MMU_CAM_L_PAGESIZE_4KB		0x0002
+#define OMAP_MMU_CAM_L_PAGESIZE_1KB		0x0003
+
+#define OMAP_MMU_CAM_P			OMAP_MMU_CAM_L_P
+#define OMAP_MMU_CAM_V			OMAP_MMU_CAM_L_V
+#define OMAP_MMU_CAM_PAGESIZE_MASK	OMAP_MMU_CAM_L_PAGESIZE_MASK
+#define OMAP_MMU_CAM_PAGESIZE_1MB	OMAP_MMU_CAM_L_PAGESIZE_1MB
+#define OMAP_MMU_CAM_PAGESIZE_64KB	OMAP_MMU_CAM_L_PAGESIZE_64KB
+#define OMAP_MMU_CAM_PAGESIZE_4KB	OMAP_MMU_CAM_L_PAGESIZE_4KB
+#define OMAP_MMU_CAM_PAGESIZE_1KB	OMAP_MMU_CAM_L_PAGESIZE_1KB
+#define OMAP_MMU_CAM_PAGESIZE_16MB	-1 /* unused in omap1 */
+
+#define OMAP_MMU_RAM_L_RAM_LSB_MASK	0xfc00
+#define OMAP_MMU_RAM_L_AP_MASK		0x0300
+#define OMAP_MMU_RAM_L_AP_NA		0x0000
+#define OMAP_MMU_RAM_L_AP_RO		0x0200
+#define OMAP_MMU_RAM_L_AP_FA		0x0300
+
+#define OMAP_MMU_LD_TLB_RD		0x0002
+
+#define INIT_TLB_ENTRY(ent, v, p, ps)			\
+do {							\
+	(ent)->va	= (v);				\
+	(ent)->pa	= (p);				\
+	(ent)->pgsz	= (ps);				\
+	(ent)->prsvd	= 0;				\
+	(ent)->ap	= OMAP_MMU_RAM_L_AP_FA;		\
+	(ent)->tlb	= 1;				\
+} while (0)
+
+#define INIT_TLB_ENTRY_4KB_PRESERVED(ent, v, p)	\
+do {							\
+	(ent)->va	= (v);				\
+	(ent)->pa	= (p);				\
+	(ent)->pgsz	= OMAP_MMU_CAM_PAGESIZE_4KB;	\
+	(ent)->prsvd	= OMAP_MMU_CAM_P;		\
+	(ent)->ap	= OMAP_MMU_RAM_L_AP_FA;		\
+} while (0)
+
+struct omap_mmu_tlb_entry {
+	unsigned long va;
+	unsigned long pa;
+	unsigned int pgsz, prsvd, valid;
+
+	u16 ap;
+	unsigned int tlb;
+};
+
+static inline unsigned short
+omap_mmu_read_reg(struct omap_mmu *mmu, unsigned long reg)
+{
+	return __raw_readw(mmu->base + reg);
+}
+
+static inline void omap_mmu_write_reg(struct omap_mmu *mmu,
+			       unsigned short val, unsigned long reg)
+{
+	__raw_writew(val, mmu->base + reg);
+}
+
+#endif /* __MACH_OMAP1_MMU_H */
diff -Npru a/arch/arm/plat-omap/dsp/omap1_dsp.h b/arch/arm/plat-omap/dsp/omap1_dsp.h
--- a/arch/arm/plat-omap/dsp/omap1_dsp.h  2009-05-12 21:13:59.000000000 +0200
+++ b/arch/arm/plat-omap/dsp/omap1_dsp.h  2009-06-01 22:31:15.000000000 +0200
@@ -0,0 +1,114 @@
+/*
+ * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
+ *
+ * Copyright (C) 2002-2006 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __OMAP_DSP_OMAP1_DSP_H
+#define __OMAP_DSP_OMAP1_DSP_H
+
+#ifdef CONFIG_ARCH_OMAP15XX
+#define OMAP1510_DARAM_BASE	(OMAP1510_DSP_BASE + 0x0)
+#define OMAP1510_DARAM_SIZE	0x10000
+#define OMAP1510_SARAM_BASE	(OMAP1510_DSP_BASE + 0x10000)
+#define OMAP1510_SARAM_SIZE	0x18000
+#endif
+
+#ifdef CONFIG_ARCH_OMAP16XX
+#define OMAP16XX_DARAM_BASE	(OMAP16XX_DSP_BASE + 0x0)
+#define OMAP16XX_DARAM_SIZE	0x10000
+#define OMAP16XX_SARAM_BASE	(OMAP16XX_DSP_BASE + 0x10000)
+#define OMAP16XX_SARAM_SIZE	0x18000
+#endif
+
+/*
+ * Reset Control
+ */
+#define ARM_RSTCT1_SW_RST		0x0008
+#define ARM_RSTCT1_DSP_RST		0x0004
+#define ARM_RSTCT1_DSP_EN		0x0002
+#define ARM_RSTCT1_ARM_RST		0x0001
+
+/*
+ * MPUI
+ */
+#define MPUI_CTRL_WORDSWAP_MASK		0x00600000
+#define MPUI_CTRL_WORDSWAP_ALL		0x00000000
+#define MPUI_CTRL_WORDSWAP_NONAPI	0x00200000
+#define MPUI_CTRL_WORDSWAP_API		0x00400000
+#define MPUI_CTRL_WORDSWAP_NONE		0x00600000
+#define MPUI_CTRL_AP_MASK		0x001c0000
+#define MPUI_CTRL_AP_MDH		0x00000000
+#define MPUI_CTRL_AP_MHD		0x00040000
+#define MPUI_CTRL_AP_DMH		0x00080000
+#define MPUI_CTRL_AP_HMD		0x000c0000
+#define MPUI_CTRL_AP_DHM		0x00100000
+#define MPUI_CTRL_AP_HDM		0x00140000
+#define MPUI_CTRL_BYTESWAP_MASK		0x00030000
+#define MPUI_CTRL_BYTESWAP_NONE		0x00000000
+#define MPUI_CTRL_BYTESWAP_NONAPI	0x00010000
+#define MPUI_CTRL_BYTESWAP_ALL		0x00020000
+#define MPUI_CTRL_BYTESWAP_API		0x00030000
+#define MPUI_CTRL_TIMEOUT_MASK		0x0000ff00
+#define MPUI_CTRL_APIF_HNSTB_DIV_MASK	0x000000f0
+#define MPUI_CTRL_S_NABORT_GL		0x00000008
+#define MPUI_CTRL_S_NABORT_32BIT	0x00000004
+#define MPUI_CTRL_EN_TIMEOUT		0x00000002
+#define MPUI_CTRL_HF_MCUCLK		0x00000001
+#define DSP_BOOT_CONFIG_DIRECT		0x00000000
+#define DSP_BOOT_CONFIG_PSD_DIRECT	0x00000001
+#define DSP_BOOT_CONFIG_IDLE		0x00000002
+#define DSP_BOOT_CONFIG_DL16		0x00000003
+#define DSP_BOOT_CONFIG_DL32		0x00000004
+#define DSP_BOOT_CONFIG_MPUI		0x00000005
+#define DSP_BOOT_CONFIG_INTERNAL	0x00000006
+
+/*
+ * DSP boot mode
+ *   direct:        0xffff00
+ *   pseudo direct: 0x080000
+ *   MPUI:          branch 0x010000
+ *   internel:      branch 0x024000
+ */
+#define DSP_BOOT_ADR_DIRECT		0xffff00
+#define DSP_BOOT_ADR_PSD_DIRECT		0x080000
+#define DSP_BOOT_ADR_MPUI		0x010000
+#define DSP_BOOT_ADR_INTERNAL		0x024000
+
+/*
+ * TC
+ */
+#define TC_ENDIANISM_SWAP		0x00000002
+#define TC_ENDIANISM_SWAP_WORD		0x00000002
+#define TC_ENDIANISM_SWAP_BYTE		0x00000000
+#define TC_ENDIANISM_EN			0x00000001
+
+/*
+ * DSP ICR
+ */
+#define DSPREG_ICR_RESERVED_BITS	0xffc0
+#define DSPREG_ICR_EMIF			0x0020
+#define DSPREG_ICR_DPLL			0x0010
+#define DSPREG_ICR_PER			0x0008
+#define DSPREG_ICR_CACHE		0x0004
+#define DSPREG_ICR_DMA			0x0002
+#define DSPREG_ICR_CPU			0x0001
+
+#endif /* __OMAP_DSP_OMAP1_DSP_H */
