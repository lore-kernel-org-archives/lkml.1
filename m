Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0CCFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:09:59 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:51311 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr platform and machines
Date: Wed,  3 Mar 2010 10:37:35 +0530
Message-Id: <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock framework for SPEAr is based upon clkdev framework for ARM

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/clock.c               |  525 +++++++++++++++++++++
 arch/arm/mach-spear3xx/include/mach/clkdev.h |   19 +
 arch/arm/mach-spear6xx/clock.c               |  656 ++++++++++++++++++++++++++
 arch/arm/mach-spear6xx/include/mach/clkdev.h |   19 +
 arch/arm/plat-spear/clock.c                  |  433 +++++++++++++++++
 arch/arm/plat-spear/include/plat/clkdev.h    |   20 +
 arch/arm/plat-spear/include/plat/clock.h     |  130 +++++
 7 files changed, 1802 insertions(+), 0 deletions(-)
 create mode 100755 arch/arm/mach-spear3xx/clock.c
 create mode 100644 arch/arm/mach-spear3xx/include/mach/clkdev.h
 create mode 100755 arch/arm/mach-spear6xx/clock.c
 create mode 100644 arch/arm/mach-spear6xx/include/mach/clkdev.h
 create mode 100755 arch/arm/plat-spear/clock.c
 create mode 100644 arch/arm/plat-spear/include/plat/clkdev.h
 create mode 100755 arch/arm/plat-spear/include/plat/clock.h

diff --git a/arch/arm/mach-spear3xx/clock.c b/arch/arm/mach-spear3xx/clock.c
new file mode 100755
index 0000000..005fecc
--- /dev/null
+++ b/arch/arm/mach-spear3xx/clock.c
@@ -0,0 +1,525 @@
+/*
+ * arch/arm/mach-spear3xx/clock.c
+ *
+ * SPEAr3xx machines clock framework source file
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <mach/misc_regs.h>
+#include <plat/clock.h>
+
+/* root clks */
+/* 32 KHz oscillator clock */
+static struct clk osc_32k_clk = {
+	.flags = ALWAYS_ENABLED,
+	.rate = 32 * KHZ,
+};
+
+static struct clk_lookup osc_32k_cl = {
+	.con_id = "osc_32k_clk",
+	.clk = &osc_32k_clk,
+};
+
+/* 24 MHz oscillator clock */
+static struct clk osc_24m_clk = {
+	.flags = ALWAYS_ENABLED,
+	.rate = 24 * MHZ,
+};
+
+static struct clk_lookup osc_24m_cl = {
+	.con_id = "osc_24m_clk",
+	.clk = &osc_24m_clk,
+};
+
+/* clock derived from 32 KHz osc clk */
+/* rtc clock */
+static struct clk rtc_clk = {
+	.pclk = &osc_32k_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = RTC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup rtc_cl = {
+	.dev_id = "rtc",
+	.clk = &rtc_clk,
+};
+
+/* clock derived from 24 MHz osc clk */
+/* pll1 configuration structure */
+static struct pll_clk_config pll1_config = {
+	.mode_reg = PLL1_CTR,
+	.cfg_reg = PLL1_FRQ,
+};
+
+/* PLL1 clock */
+static struct clk pll1_clk = {
+	.pclk = &osc_24m_clk,
+	.en_reg = PLL1_CTR,
+	.en_reg_bit = PLL_ENABLE,
+	.recalc = &pll1_clk_recalc,
+	.private_data = &pll1_config,
+};
+
+static struct clk_lookup pll1_cl = {
+	.con_id = "pll1_clk",
+	.clk = &pll1_clk,
+};
+
+/* PLL3 48 MHz clock */
+static struct clk pll3_48m_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &osc_24m_clk,
+	.rate = 48 * MHZ,
+};
+
+static struct clk_lookup pll3_48m_cl = {
+	.con_id = "pll3_48m_clk",
+	.clk = &pll3_48m_clk,
+};
+
+/* watch dog timer clock */
+static struct clk wdt_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &osc_24m_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup wdt_cl = {
+	.dev_id = "wdt",
+	.clk = &wdt_clk,
+};
+
+/* clock derived from pll1 clk */
+/* cpu clock */
+static struct clk cpu_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &pll1_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup cpu_cl = {
+	.con_id = "cpu_clk",
+	.clk = &cpu_clk,
+};
+
+/* ahb configuration structure */
+static struct bus_clk_config ahb_config = {
+	.reg = CORE_CLK_CFG,
+	.mask = PLL_HCLK_RATIO_MASK,
+	.shift = PLL_HCLK_RATIO_SHIFT,
+};
+
+/* ahb clock */
+static struct clk ahb_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &pll1_clk,
+	.recalc = &bus_clk_recalc,
+	.private_data = &ahb_config,
+};
+
+static struct clk_lookup ahb_cl = {
+	.con_id = "ahb_clk",
+	.clk = &ahb_clk,
+};
+
+/* uart configurations */
+static struct aux_clk_config uart_config = {
+	.synth_reg = UART_CLK_SYNT,
+};
+
+/* uart parents */
+static struct pclk_info uart_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* uart parent select structure */
+static struct pclk_sel uart_pclk_sel = {
+	.pclk_info = uart_pclk_info,
+	.pclk_count = ARRAY_SIZE(uart_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = UART_CLK_MASK,
+};
+
+/* uart clock */
+static struct clk uart_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = UART_CLK_ENB,
+	.pclk_sel = &uart_pclk_sel,
+	.pclk_sel_shift = UART_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &uart_config,
+};
+
+static struct clk_lookup uart_cl = {
+	.dev_id = "uart",
+	.clk = &uart_clk,
+};
+
+/* firda configurations */
+static struct aux_clk_config firda_config = {
+	.synth_reg = FIRDA_CLK_SYNT,
+};
+
+/* firda parents */
+static struct pclk_info firda_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* firda parent select structure */
+static struct pclk_sel firda_pclk_sel = {
+	.pclk_info = firda_pclk_info,
+	.pclk_count = ARRAY_SIZE(firda_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = FIRDA_CLK_MASK,
+};
+
+/* firda clock */
+static struct clk firda_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = FIRDA_CLK_ENB,
+	.pclk_sel = &firda_pclk_sel,
+	.pclk_sel_shift = FIRDA_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &firda_config,
+};
+
+static struct clk_lookup firda_cl = {
+	.dev_id = "firda",
+	.clk = &firda_clk,
+};
+
+/* gpt parents */
+static struct pclk_info gpt_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* gpt parent select structure */
+static struct pclk_sel gpt_pclk_sel = {
+	.pclk_info = gpt_pclk_info,
+	.pclk_count = ARRAY_SIZE(gpt_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = GPT_CLK_MASK,
+};
+
+/* gpt0 configurations */
+static struct aux_clk_config gpt0_config = {
+	.synth_reg = PRSC1_CLK_CFG,
+};
+
+/* gpt0 timer clock */
+static struct clk gpt0_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT0_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt0_config,
+};
+
+static struct clk_lookup gpt0_cl = {
+	.dev_id = "gpt0",
+	.clk = &gpt0_clk,
+};
+
+/* gpt1 configurations */
+static struct aux_clk_config gpt1_config = {
+	.synth_reg = PRSC2_CLK_CFG,
+};
+
+/* gpt1 timer clock */
+static struct clk gpt1_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPT1_CLK_ENB,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT1_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt1_config,
+};
+
+static struct clk_lookup gpt1_cl = {
+	.dev_id = "gpt1",
+	.clk = &gpt1_clk,
+};
+
+/* gpt2 configurations */
+static struct aux_clk_config gpt2_config = {
+	.synth_reg = PRSC3_CLK_CFG,
+};
+
+/* gpt2 timer clock */
+static struct clk gpt2_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPT2_CLK_ENB,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT2_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt2_config,
+};
+
+static struct clk_lookup gpt2_cl = {
+	.dev_id = "gpt2",
+	.clk = &gpt2_clk,
+};
+
+/* clock derived from pll3 clk */
+/* usbh clock */
+static struct clk usbh_clk = {
+	.pclk = &pll3_48m_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = USBH_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup usbh_cl = {
+	.dev_id = "usbh",
+	.clk = &usbh_clk,
+};
+
+/* usbd clock */
+static struct clk usbd_clk = {
+	.pclk = &pll3_48m_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = USBD_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup usbd_cl = {
+	.dev_id = "usbd",
+	.clk = &usbd_clk,
+};
+
+/* clcd clock */
+static struct clk clcd_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &pll3_48m_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup clcd_cl = {
+	.dev_id = "clcd",
+	.clk = &clcd_clk,
+};
+
+/* clock derived from ahb clk */
+/* apb configuration structure */
+static struct bus_clk_config apb_config = {
+	.reg = CORE_CLK_CFG,
+	.mask = HCLK_PCLK_RATIO_MASK,
+	.shift = HCLK_PCLK_RATIO_SHIFT,
+};
+
+/* apb clock */
+static struct clk apb_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ahb_clk,
+	.recalc = &bus_clk_recalc,
+	.private_data = &apb_config,
+};
+
+static struct clk_lookup apb_cl = {
+	.con_id = "apb_clk",
+	.clk = &apb_clk,
+};
+
+/* i2c clock */
+static struct clk i2c_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = I2C_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup i2c_cl = {
+	.dev_id = "i2c",
+	.clk = &i2c_clk,
+};
+
+/* dma clock */
+static struct clk dma_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = DMA_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup dma_cl = {
+	.dev_id = "dma",
+	.clk = &dma_clk,
+};
+
+/* jpeg clock */
+static struct clk jpeg_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = JPEG_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup jpeg_cl = {
+	.dev_id = "jpeg",
+	.clk = &jpeg_clk,
+};
+
+/* gmac clock */
+static struct clk gmac_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GMAC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gmac_cl = {
+	.dev_id = "gmac",
+	.clk = &gmac_clk,
+};
+
+/* smi clock */
+static struct clk smi_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SMI_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup smi_cl = {
+	.dev_id = "smi",
+	.clk = &smi_clk,
+};
+
+/* c3 clock */
+static struct clk c3_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = C3_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup c3_cl = {
+	.dev_id = "c3",
+	.clk = &c3_clk,
+};
+
+/* clock derived from apb clk */
+/* adc clock */
+static struct clk adc_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = ADC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup adc_cl = {
+	.dev_id = "adc",
+	.clk = &adc_clk,
+};
+
+/* ssp clock */
+static struct clk ssp_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SSP_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup ssp_cl = {
+	.dev_id = "ssp",
+	.clk = &ssp_clk,
+};
+
+/* gpio clock */
+static struct clk gpio_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPIO_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gpio_cl = {
+	.dev_id = "gpio",
+	.clk = &gpio_clk,
+};
+
+/* array of all spear 3xx clock lookups */
+static struct clk_lookup *spear_clk_lookups[] = {
+	/* root clks */
+	&osc_32k_cl,
+	&osc_24m_cl,
+
+	/* clock derived from 32 KHz osc clk */
+	&rtc_cl,
+
+	/* clock derived from 24 MHz osc clk */
+	&pll1_cl,
+	&pll3_48m_cl,
+	&wdt_cl,
+
+	/* clock derived from pll1 clk */
+	&cpu_cl,
+	&ahb_cl,
+	&uart_cl,
+	&firda_cl,
+	&gpt0_cl,
+	&gpt1_cl,
+	&gpt2_cl,
+
+	/* clock derived from pll3 clk */
+	&usbh_cl,
+	&usbd_cl,
+	&clcd_cl,
+
+	/* clock derived from ahb clk */
+	&apb_cl,
+	&i2c_cl,
+	&dma_cl,
+	&jpeg_cl,
+	&gmac_cl,
+	&smi_cl,
+	&c3_cl,
+
+	/* clock derived from apb clk */
+	&adc_cl,
+	&ssp_cl,
+	&gpio_cl,
+};
+
+void __init clk_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(spear_clk_lookups); i++)
+		clk_register(spear_clk_lookups[i]);
+
+	recalc_root_clocks();
+}
diff --git a/arch/arm/mach-spear3xx/include/mach/clkdev.h b/arch/arm/mach-spear3xx/include/mach/clkdev.h
new file mode 100644
index 0000000..04b168b
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/clkdev.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/clkdev.h
+ *
+ * Clock Dev framework definitions for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#include <plat/clkdev.h>
+
+#endif /* __ASM_MACH_CLKDEV_H */
diff --git a/arch/arm/mach-spear6xx/clock.c b/arch/arm/mach-spear6xx/clock.c
new file mode 100755
index 0000000..c33b847
--- /dev/null
+++ b/arch/arm/mach-spear6xx/clock.c
@@ -0,0 +1,656 @@
+/*
+ * arch/arm/mach-spear6xx/clock.c
+ *
+ * SPEAr6xx machines clock framework source file
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <mach/misc_regs.h>
+#include <plat/clock.h>
+
+/* root clks */
+/* 32 KHz oscillator clock */
+static struct clk osc_32k_clk = {
+	.flags = ALWAYS_ENABLED,
+	.rate = 32 * KHZ,
+};
+
+static struct clk_lookup osc_32k_cl = {
+	.con_id = "osc_32k_clk",
+	.clk = &osc_32k_clk,
+};
+
+/* 30 MHz oscillator clock */
+static struct clk osc_30m_clk = {
+	.flags = ALWAYS_ENABLED,
+	.rate = 30 * MHZ,
+};
+
+static struct clk_lookup osc_30m_cl = {
+	.con_id = "osc_30m_clk",
+	.clk = &osc_30m_clk,
+};
+
+/* clock derived from 32 KHz osc clk */
+/* rtc clock */
+static struct clk rtc_clk = {
+	.pclk = &osc_32k_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = RTC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup rtc_cl = {
+	.dev_id = "rtc",
+	.clk = &rtc_clk,
+};
+
+/* clock derived from 30 MHz osc clk */
+/* pll1 configuration structure */
+static struct pll_clk_config pll1_config = {
+	.mode_reg = PLL1_CTR,
+	.cfg_reg = PLL1_FRQ,
+};
+
+/* PLL1 clock */
+static struct clk pll1_clk = {
+	.pclk = &osc_30m_clk,
+	.en_reg = PLL1_CTR,
+	.en_reg_bit = PLL_ENABLE,
+	.recalc = &pll1_clk_recalc,
+	.private_data = &pll1_config,
+};
+
+static struct clk_lookup pll1_cl = {
+	.con_id = "pll1_clk",
+	.clk = &pll1_clk,
+};
+
+/* PLL3 48 MHz clock */
+static struct clk pll3_48m_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &osc_30m_clk,
+	.rate = 48 * MHZ,
+};
+
+static struct clk_lookup pll3_48m_cl = {
+	.con_id = "pll3_48m_clk",
+	.clk = &pll3_48m_clk,
+};
+
+/* watch dog timer clock */
+static struct clk wdt_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &osc_30m_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup wdt_cl = {
+	.dev_id = "wdt",
+	.clk = &wdt_clk,
+};
+
+/* clock derived from pll1 clk */
+/* cpu clock */
+static struct clk cpu_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &pll1_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup cpu_cl = {
+	.con_id = "cpu_clk",
+	.clk = &cpu_clk,
+};
+
+/* ahb configuration structure */
+static struct bus_clk_config ahb_config = {
+	.reg = CORE_CLK_CFG,
+	.mask = PLL_HCLK_RATIO_MASK,
+	.shift = PLL_HCLK_RATIO_SHIFT,
+};
+
+/* ahb clock */
+static struct clk ahb_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &pll1_clk,
+	.recalc = &bus_clk_recalc,
+	.private_data = &ahb_config,
+};
+
+static struct clk_lookup ahb_cl = {
+	.con_id = "ahb_clk",
+	.clk = &ahb_clk,
+};
+
+/* uart parents */
+static struct pclk_info uart_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* uart parent select structure */
+static struct pclk_sel uart_pclk_sel = {
+	.pclk_info = uart_pclk_info,
+	.pclk_count = ARRAY_SIZE(uart_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = UART_CLK_MASK,
+};
+
+/* uart configurations */
+static struct aux_clk_config uart_config = {
+	.synth_reg = UART_CLK_SYNT,
+};
+
+/* uart0 clock */
+static struct clk uart0_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = UART0_CLK_ENB,
+	.pclk_sel = &uart_pclk_sel,
+	.pclk_sel_shift = UART_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &uart_config,
+};
+
+static struct clk_lookup uart0_cl = {
+	.dev_id = "uart0",
+	.clk = &uart0_clk,
+};
+
+/* uart1 clock */
+static struct clk uart1_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = UART1_CLK_ENB,
+	.pclk_sel = &uart_pclk_sel,
+	.pclk_sel_shift = UART_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &uart_config,
+};
+
+static struct clk_lookup uart1_cl = {
+	.dev_id = "uart1",
+	.clk = &uart1_clk,
+};
+
+/* firda configurations */
+static struct aux_clk_config firda_config = {
+	.synth_reg = FIRDA_CLK_SYNT,
+};
+
+/* firda parents */
+static struct pclk_info firda_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* firda parent select structure */
+static struct pclk_sel firda_pclk_sel = {
+	.pclk_info = firda_pclk_info,
+	.pclk_count = ARRAY_SIZE(firda_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = FIRDA_CLK_MASK,
+};
+
+/* firda clock */
+static struct clk firda_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = FIRDA_CLK_ENB,
+	.pclk_sel = &firda_pclk_sel,
+	.pclk_sel_shift = FIRDA_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &firda_config,
+};
+
+static struct clk_lookup firda_cl = {
+	.dev_id = "firda",
+	.clk = &firda_clk,
+};
+
+/* clcd configurations */
+static struct aux_clk_config clcd_config = {
+	.synth_reg = CLCD_CLK_SYNT,
+};
+
+/* clcd parents */
+static struct pclk_info clcd_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* clcd parent select structure */
+static struct pclk_sel clcd_pclk_sel = {
+	.pclk_info = clcd_pclk_info,
+	.pclk_count = ARRAY_SIZE(clcd_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = CLCD_CLK_MASK,
+};
+
+/* clcd clock */
+static struct clk clcd_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = CLCD_CLK_ENB,
+	.pclk_sel = &clcd_pclk_sel,
+	.pclk_sel_shift = CLCD_CLK_SHIFT,
+	.recalc = &aux_clk_recalc,
+	.private_data = &clcd_config,
+};
+
+static struct clk_lookup clcd_cl = {
+	.dev_id = "clcd",
+	.clk = &clcd_clk,
+};
+
+/* gpt parents */
+static struct pclk_info gpt_pclk_info[] = {
+	{
+		.pclk = &pll1_clk,
+		.pclk_mask = AUX_CLK_PLL1_MASK,
+		.scalable = 1,
+	}, {
+		.pclk = &pll3_48m_clk,
+		.pclk_mask = AUX_CLK_PLL3_MASK,
+		.scalable = 0,
+	},
+};
+
+/* gpt parent select structure */
+static struct pclk_sel gpt_pclk_sel = {
+	.pclk_info = gpt_pclk_info,
+	.pclk_count = ARRAY_SIZE(gpt_pclk_info),
+	.pclk_sel_reg = PERIP_CLK_CFG,
+	.pclk_sel_mask = GPT_CLK_MASK,
+};
+
+/* gpt0_1 configurations */
+static struct aux_clk_config gpt0_1_config = {
+	.synth_reg = PRSC1_CLK_CFG,
+};
+
+/* gpt0 ARM1 subsystem timer clock */
+static struct clk gpt0_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT0_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt0_1_config,
+};
+
+static struct clk_lookup gpt0_cl = {
+	.dev_id = "gpt0",
+	.clk = &gpt0_clk,
+};
+
+/* gpt1 timer clock */
+static struct clk gpt1_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT1_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt0_1_config,
+};
+
+static struct clk_lookup gpt1_cl = {
+	.dev_id = "gpt1",
+	.clk = &gpt1_clk,
+};
+
+/* gpt2 configurations */
+static struct aux_clk_config gpt2_config = {
+	.synth_reg = PRSC2_CLK_CFG,
+};
+
+/* gpt2 timer clock */
+static struct clk gpt2_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPT2_CLK_ENB,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT2_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt2_config,
+};
+
+static struct clk_lookup gpt2_cl = {
+	.dev_id = "gpt2",
+	.clk = &gpt2_clk,
+};
+
+/* gpt3 configurations */
+static struct aux_clk_config gpt3_config = {
+	.synth_reg = PRSC3_CLK_CFG,
+};
+
+/* gpt3 timer clock */
+static struct clk gpt3_clk = {
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPT3_CLK_ENB,
+	.pclk_sel = &gpt_pclk_sel,
+	.pclk_sel_shift = GPT3_CLK_SHIFT,
+	.recalc = &gpt_clk_recalc,
+	.private_data = &gpt3_config,
+};
+
+static struct clk_lookup gpt3_cl = {
+	.dev_id = "gpt3",
+	.clk = &gpt3_clk,
+};
+
+/* clock derived from pll3 clk */
+/* usbh0 clock */
+static struct clk usbh0_clk = {
+	.pclk = &pll3_48m_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = USBH0_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup usbh0_cl = {
+	.dev_id = "usbh0",
+	.clk = &usbh0_clk,
+};
+
+/* usbh1 clock */
+static struct clk usbh1_clk = {
+	.pclk = &pll3_48m_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = USBH1_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup usbh1_cl = {
+	.dev_id = "usbh1",
+	.clk = &usbh1_clk,
+};
+
+/* usbd clock */
+static struct clk usbd_clk = {
+	.pclk = &pll3_48m_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = USBD_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup usbd_cl = {
+	.dev_id = "usbd",
+	.clk = &usbd_clk,
+};
+
+/* clock derived from ahb clk */
+/* apb configuration structure */
+static struct bus_clk_config apb_config = {
+	.reg = CORE_CLK_CFG,
+	.mask = HCLK_PCLK_RATIO_MASK,
+	.shift = HCLK_PCLK_RATIO_SHIFT,
+};
+
+/* apb clock */
+static struct clk apb_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &ahb_clk,
+	.recalc = &bus_clk_recalc,
+	.private_data = &apb_config,
+};
+
+static struct clk_lookup apb_cl = {
+	.con_id = "apb_clk",
+	.clk = &apb_clk,
+};
+
+/* i2c clock */
+static struct clk i2c_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = I2C_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup i2c_cl = {
+	.dev_id = "i2c",
+	.clk = &i2c_clk,
+};
+
+/* dma clock */
+static struct clk dma_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = DMA_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup dma_cl = {
+	.dev_id = "dma",
+	.clk = &dma_clk,
+};
+
+/* jpeg clock */
+static struct clk jpeg_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = JPEG_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup jpeg_cl = {
+	.dev_id = "jpeg",
+	.clk = &jpeg_clk,
+};
+
+/* gmac clock */
+static struct clk gmac_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GMAC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gmac_cl = {
+	.dev_id = "gmac",
+	.clk = &gmac_clk,
+};
+
+/* smi clock */
+static struct clk smi_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SMI_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup smi_cl = {
+	.dev_id = "smi",
+	.clk = &smi_clk,
+};
+
+/* fsmc clock */
+static struct clk fsmc_clk = {
+	.pclk = &ahb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = FSMC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup fsmc_cl = {
+	.dev_id = "fsmc",
+	.clk = &fsmc_clk,
+};
+
+/* clock derived from apb clk */
+/* adc clock */
+static struct clk adc_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = ADC_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup adc_cl = {
+	.dev_id = "adc",
+	.clk = &adc_clk,
+};
+
+/* ssp0 clock */
+static struct clk ssp0_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SSP0_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup ssp0_cl = {
+	.dev_id = "ssp0",
+	.clk = &ssp0_clk,
+};
+
+/* ssp1 clock */
+static struct clk ssp1_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SSP1_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup ssp1_cl = {
+	.dev_id = "ssp1",
+	.clk = &ssp1_clk,
+};
+
+/* ssp2 clock */
+static struct clk ssp2_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = SSP2_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup ssp2_cl = {
+	.dev_id = "ssp2",
+	.clk = &ssp2_clk,
+};
+
+/* gpio0 ARM subsystem clock */
+static struct clk gpio0_clk = {
+	.flags = ALWAYS_ENABLED,
+	.pclk = &apb_clk,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gpio0_cl = {
+	.dev_id = "gpio0",
+	.clk = &gpio0_clk,
+};
+
+/* gpio1 clock */
+static struct clk gpio1_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPIO1_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gpio1_cl = {
+	.dev_id = "gpio1",
+	.clk = &gpio1_clk,
+};
+
+/* gpio2 clock */
+static struct clk gpio2_clk = {
+	.pclk = &apb_clk,
+	.en_reg = PERIP1_CLK_ENB,
+	.en_reg_bit = GPIO2_CLK_ENB,
+	.recalc = &follow_parent,
+};
+
+static struct clk_lookup gpio2_cl = {
+	.dev_id = "gpio2",
+	.clk = &gpio2_clk,
+};
+
+/* array of all spear 6xx clock lookups */
+static struct clk_lookup *spear_clk_lookups[] = {
+	/* root clks */
+	&osc_32k_cl,
+	&osc_30m_cl,
+
+	/* clock derived from 32 KHz osc clk */
+	&rtc_cl,
+
+	/* clock derived from 30 MHz osc clk */
+	&pll1_cl,
+	&pll3_48m_cl,
+	&wdt_cl,
+
+	/* clock derived from pll1 clk */
+	&cpu_cl,
+	&ahb_cl,
+	&uart0_cl,
+	&uart1_cl,
+	&firda_cl,
+	&clcd_cl,
+	&gpt0_cl,
+	&gpt1_cl,
+	&gpt2_cl,
+	&gpt3_cl,
+
+	/* clock derived from pll3 clk */
+	&usbh0_cl,
+	&usbh1_cl,
+	&usbd_cl,
+
+	/* clock derived from ahb clk */
+	&apb_cl,
+	&i2c_cl,
+	&dma_cl,
+	&jpeg_cl,
+	&gmac_cl,
+	&smi_cl,
+	&fsmc_cl,
+
+	/* clock derived from apb clk */
+	&adc_cl,
+	&ssp0_cl,
+	&ssp1_cl,
+	&ssp2_cl,
+	&gpio0_cl,
+	&gpio1_cl,
+	&gpio2_cl,
+};
+
+void __init clk_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(spear_clk_lookups); i++)
+		clk_register(spear_clk_lookups[i]);
+
+	recalc_root_clocks();
+
+	return 0;
+}
diff --git a/arch/arm/mach-spear6xx/include/mach/clkdev.h b/arch/arm/mach-spear6xx/include/mach/clkdev.h
new file mode 100644
index 0000000..2fb7dbc
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/clkdev.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/clkdev.h
+ *
+ * Clock Dev framework definitions for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#include <plat/clkdev.h>
+
+#endif /* __ASM_MACH_CLKDEV_H */
diff --git a/arch/arm/plat-spear/clock.c b/arch/arm/plat-spear/clock.c
new file mode 100755
index 0000000..bdcae0c
--- /dev/null
+++ b/arch/arm/plat-spear/clock.c
@@ -0,0 +1,433 @@
+/*
+ * arch/arm/plat-spear/clock.c
+ *
+ * Clock framework for SPEAr platform
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <mach/misc_regs.h>
+#include <plat/clock.h>
+
+static DEFINE_SPINLOCK(clocks_lock);
+static LIST_HEAD(root_clks);
+
+static void propagate_rate(struct list_head *);
+
+static int generic_clk_enable(struct clk *clk)
+{
+	unsigned int val;
+
+	if (!clk->en_reg)
+		return -EFAULT;
+
+	val = readl(clk->en_reg);
+	if (unlikely(clk->flags & RESET_TO_ENABLE))
+		val &= ~(1 << clk->en_reg_bit);
+	else
+		val |= 1 << clk->en_reg_bit;
+
+	writel(val, clk->en_reg);
+
+	return 0;
+}
+
+static void generic_clk_disable(struct clk *clk)
+{
+	unsigned int val;
+
+	if (!clk->en_reg)
+		return;
+
+	val = readl(clk->en_reg);
+	if (unlikely(clk->flags & RESET_TO_ENABLE))
+		val |= 1 << clk->en_reg_bit;
+	else
+		val &= ~(1 << clk->en_reg_bit);
+
+	writel(val, clk->en_reg);
+}
+
+/* generic clk ops */
+static struct clkops generic_clkops = {
+	.enable = generic_clk_enable,
+	.disable = generic_clk_disable,
+};
+
+/*
+ * clk_enable - inform the system when the clock source should be running.
+ * @clk: clock source
+ *
+ * If the clock can not be enabled/disabled, this should return success.
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (!clk || IS_ERR(clk))
+		return -EFAULT;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (clk->usage_count++ == 0) {
+		if (clk->ops && clk->ops->enable)
+			ret = clk->ops->enable(clk);
+	}
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_enable);
+
+/*
+ * clk_disable - inform the system when the clock source is no longer required.
+ * @clk: clock source
+ *
+ * Inform the system that a clock source is no longer required by
+ * a driver and may be shut down.
+ *
+ * Implementation detail: if the clock source is shared between
+ * multiple drivers, clk_enable() calls must be balanced by the
+ * same number of clk_disable() calls for the clock source to be
+ * disabled.
+ */
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return;
+
+	WARN_ON(clk->usage_count == 0);
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (--clk->usage_count == 0) {
+		if (clk->ops && clk->ops->disable)
+			clk->ops->disable(clk);
+	}
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+/**
+ * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
+ *		 This is only valid once the clock source has been enabled.
+ * @clk: clock source
+ */
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long flags, rate;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	rate = clk->rate;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+/**
+ * clk_set_parent - set the parent clock source for this clock
+ * @clk: clock source
+ * @parent: parent clock source
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int i, found = 0, val = 0;
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk) || !parent || IS_ERR(parent))
+		return -EFAULT;
+	if (clk->usage_count == 0)
+		return -EBUSY;
+	if (!clk->pclk_sel)
+		return -EPERM;
+	if (clk->pclk == parent)
+		return 0;
+
+	for (i = 0; i < clk->pclk_sel->pclk_count; i++) {
+		if (clk->pclk_sel->pclk_info[i].pclk == parent) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EPERM;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	/* reflect parent change in hardware */
+	val = readl(clk->pclk_sel->pclk_sel_reg);
+	val &= ~(clk->pclk_sel->pclk_sel_mask << clk->pclk_sel_shift);
+	val |= clk->pclk_sel->pclk_info[i].pclk_mask << clk->pclk_sel_shift;
+	writel(val, clk->pclk_sel->pclk_sel_reg);
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	/* reflect parent change in software */
+	clk->recalc(clk);
+	propagate_rate(&clk->children);
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+/* registers clock in platform clock framework */
+void clk_register(struct clk_lookup *cl)
+{
+	struct clk *clk = cl->clk;
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	INIT_LIST_HEAD(&clk->children);
+	if (clk->flags & ALWAYS_ENABLED)
+		clk->ops = NULL;
+	else if (!clk->ops)
+		clk->ops = &generic_clkops;
+
+	/* root clock don't have any parents */
+	if (!clk->pclk && !clk->pclk_sel) {
+		list_add(&clk->sibling, &root_clks);
+		/* add clocks with only one parent to parent's children list */
+	} else if (clk->pclk && !clk->pclk_sel) {
+		list_add(&clk->sibling, &clk->pclk->children);
+	} else {
+		/* add clocks with > 1 parent to 1st parent's children list */
+		list_add(&clk->sibling,
+			 &clk->pclk_sel->pclk_info[0].pclk->children);
+	}
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	/* add clock to arm clockdev framework */
+	clkdev_add(cl);
+}
+
+/**
+ * propagate_rate - recalculate and propagate all clocks in list head
+ *
+ * Recalculates all root clocks in list head, which if the clock's .recalc is
+ * set correctly, should also propagate their rates.
+ */
+static void propagate_rate(struct list_head *lhead)
+{
+	struct clk *clkp, *_temp;
+
+	list_for_each_entry_safe(clkp, _temp, lhead, sibling) {
+		if (clkp->recalc)
+			clkp->recalc(clkp);
+		propagate_rate(&clkp->children);
+	}
+}
+
+/* returns current programmed clocks clock info structure */
+static struct pclk_info *pclk_info_get(struct clk *clk)
+{
+	unsigned int mask, i;
+	unsigned long flags;
+	struct pclk_info *info;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	mask = (readl(clk->pclk_sel->pclk_sel_reg) >> clk->pclk_sel_shift)
+			& clk->pclk_sel->pclk_sel_mask;
+
+	for (i = 0; i < clk->pclk_sel->pclk_count; i++) {
+		if (clk->pclk_sel->pclk_info[i].pclk_mask == mask)
+			info = &clk->pclk_sel->pclk_info[i];
+	}
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return info;
+}
+
+/*
+ * Set pclk as cclk's parent and add clock sibling node to current parents
+ * children list
+ */
+static void change_parent(struct clk *cclk, struct clk *pclk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	list_del(&cclk->sibling);
+	list_add(&cclk->sibling, &pclk->children);
+
+	cclk->pclk = pclk;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/*
+ * calculates current programmed rate of pll1
+ *
+ * In normal mode
+ * rate = (2 * M[15:8] * Fin)/(N * 2^P)
+ *
+ * In Dithered mode
+ * rate = (2 * M[15:0] * Fin)/(256 * N * 2^P)
+ */
+void pll1_clk_recalc(struct clk *clk)
+{
+	struct pll_clk_config *config = clk->private_data;
+	unsigned int num = 2, den = 0, val, mode = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	mode = (readl(config->mode_reg) >> PLL_MODE_SHIFT) &
+		PLL_MODE_MASK;
+
+	val = readl(config->cfg_reg);
+	/* calculate denominator */
+	den = (val >> PLL_DIV_P_SHIFT) & PLL_DIV_P_MASK;
+	den = 1 << den;
+	den *= (val >> PLL_DIV_N_SHIFT) & PLL_DIV_N_MASK;
+
+	/* calculate numerator & denominator */
+	if (!mode) {
+		/* Normal mode */
+		num *= (val >> PLL_NORM_FDBK_M_SHIFT) & PLL_NORM_FDBK_M_MASK;
+	} else {
+		/* Dithered mode */
+		num *= (val >> PLL_DITH_FDBK_M_SHIFT) & PLL_DITH_FDBK_M_MASK;
+		den *= 256;
+	}
+
+	clk->rate = (((clk->pclk->rate/10000) * num) / den) * 10000;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/* calculates current programmed rate of ahb or apb bus */
+void bus_clk_recalc(struct clk *clk)
+{
+	struct bus_clk_config *config = clk->private_data;
+	unsigned int div;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	div = ((readl(config->reg) >> config->shift) & config->mask) + 1;
+	clk->rate = (unsigned long)clk->pclk->rate / div;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/*
+ * calculates current programmed rate of auxiliary synthesizers
+ * used by: UART, FIRDA
+ *
+ * Fout from synthesizer can be given from two equations:
+ * Fout1 = (Fin * X/Y)/2
+ * Fout2 = Fin * X/Y
+ *
+ * Selection of eqn 1 or 2 is programmed in register
+ */
+void aux_clk_recalc(struct clk *clk)
+{
+	struct aux_clk_config *config = clk->private_data;
+	struct pclk_info *pclk_info = NULL;
+	unsigned int num = 1, den = 1, val, eqn;
+	unsigned long flags;
+
+	/* get current programmed parent */
+	pclk_info = pclk_info_get(clk);
+	if (!pclk_info) {
+		spin_lock_irqsave(&clocks_lock, flags);
+		clk->pclk = NULL;
+		clk->rate = 0;
+		spin_unlock_irqrestore(&clocks_lock, flags);
+		return;
+	}
+
+	change_parent(clk, pclk_info->pclk);
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (pclk_info->scalable) {
+		val = readl(config->synth_reg);
+
+		eqn = (val >> AUX_EQ_SEL_SHIFT) & AUX_EQ_SEL_MASK;
+		if (eqn == AUX_EQ1_SEL)
+			den *= 2;
+
+		/* calculate numerator */
+		num = (val >> AUX_XSCALE_SHIFT) & AUX_XSCALE_MASK;
+
+		/* calculate denominator */
+		den *= (val >> AUX_YSCALE_SHIFT) & AUX_YSCALE_MASK;
+		val = (((clk->pclk->rate/10000) * num) / den) * 10000;
+	} else
+		val = clk->pclk->rate;
+
+	clk->rate = val;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/*
+ * calculates current programmed rate of gpt synthesizers
+ * Fout from synthesizer can be given from below equations:
+ * Fout= Fin/((2 ^ (N+1)) * (M+1))
+ */
+void gpt_clk_recalc(struct clk *clk)
+{
+	struct aux_clk_config *config = clk->private_data;
+	struct pclk_info *pclk_info = NULL;
+	unsigned int div = 1, val;
+	unsigned long flags;
+
+	pclk_info = pclk_info_get(clk);
+	if (!pclk_info) {
+		spin_lock_irqsave(&clocks_lock, flags);
+		clk->pclk = NULL;
+		clk->rate = 0;
+		spin_unlock_irqrestore(&clocks_lock, flags);
+		return;
+	}
+
+	change_parent(clk, pclk_info->pclk);
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (pclk_info->scalable) {
+		val = readl(config->synth_reg);
+		div += (val >> GPT_MSCALE_SHIFT) & GPT_MSCALE_MASK;
+		div *= 1 << (((val >> GPT_NSCALE_SHIFT) & GPT_NSCALE_MASK) + 1);
+	}
+
+	clk->rate = (unsigned long)clk->pclk->rate / div;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/*
+ * Used for clocks that always have same value as the parent clock divided by a
+ * fixed divisor
+ */
+void follow_parent(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	clk->rate = clk->pclk->rate;
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+
+/**
+ * recalc_root_clocks - recalculate and propagate all root clocks
+ *
+ * Recalculates all root clocks (clocks with no parent), which if the
+ * clock's .recalc is set correctly, should also propagate their rates.
+ */
+void recalc_root_clocks(void)
+{
+	propagate_rate(&root_clks);
+}
diff --git a/arch/arm/plat-spear/include/plat/clkdev.h b/arch/arm/plat-spear/include/plat/clkdev.h
new file mode 100644
index 0000000..9b1cd54
--- /dev/null
+++ b/arch/arm/plat-spear/include/plat/clkdev.h
@@ -0,0 +1,20 @@
+/*
+ * arch/arm/plat-spear/include/plat/clkdev.h
+ *
+ * Clock Dev framework definitions for SPEAr platform
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_PLAT_CLKDEV_H
+#define __ASM_PLAT_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif /* __ASM_PLAT_CLKDEV_H */
diff --git a/arch/arm/plat-spear/include/plat/clock.h b/arch/arm/plat-spear/include/plat/clock.h
new file mode 100755
index 0000000..c220274
--- /dev/null
+++ b/arch/arm/plat-spear/include/plat/clock.h
@@ -0,0 +1,130 @@
+/*
+ * arch/arm/plat-spear/include/plat/clock.h
+ *
+ * Clock framework definitions for SPEAr platform
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_PLAT_CLOCK_H
+#define __ASM_PLAT_CLOCK_H
+
+#include <linux/list.h>
+#include <asm/clkdev.h>
+#include <linux/types.h>
+
+/* clk values */
+#define KHZ			(1000)
+#define MHZ			(1000000)
+
+/* clk structure flags */
+#define	ALWAYS_ENABLED		(1 << 0) /* clock always enabled */
+#define	RESET_TO_ENABLE		(1 << 1) /* reset register bit to enable clk */
+
+/**
+ * struct clkops - clock operations
+ * @enable: pointer to clock enable function
+ * @disable: pointer to clock disable function
+ */
+struct clkops {
+	int (*enable) (struct clk *);
+	void (*disable) (struct clk *);
+};
+
+/**
+ * struct pclk_info - parents info
+ * @pclk: pointer to parent clk
+ * @pclk_mask: value to be written for selecting this parent
+ * @scalable: Is parent scalable (1 - YES, 0 - NO)
+ */
+struct pclk_info {
+	struct clk *pclk;
+	u8 pclk_mask;
+	u8 scalable;
+};
+
+/**
+ * struct pclk_sel - parents selection configuration
+ * @pclk_info: pointer to array of parent clock info
+ * @pclk_count: number of parents
+ * @pclk_sel_reg: register for selecting a parent
+ * @pclk_sel_mask: mask for selecting parent (can be used to clear bits also)
+ */
+struct pclk_sel {
+	struct pclk_info *pclk_info;
+	u8 pclk_count;
+	unsigned int *pclk_sel_reg;
+	unsigned int pclk_sel_mask;
+};
+
+/**
+ * struct clk - clock structure
+ * @usage_count: num of users who enabled this clock
+ * @flags: flags for clock properties
+ * @rate: programmed clock rate in Hz
+ * @en_reg: clk enable/disable reg
+ * @en_reg_bit: clk enable/disable bit
+ * @ops: clk enable/disable ops - generic_clkops selected if NULL
+ * @recalc: pointer to clock rate recalculate function
+ * @pclk: current parent clk
+ * @pclk_sel: pointer to parent selection structure
+ * @pclk_sel_shift: register shift for selecting parent of this clock
+ * @children: list for childrens or this clock
+ * @sibling: node for list of clocks having same parents
+ * @private_data: clock specific private data
+ */
+struct clk {
+	unsigned int usage_count;
+	unsigned int flags;
+	unsigned long rate;
+	unsigned int *en_reg;
+	u8 en_reg_bit;
+	const struct clkops *ops;
+	void (*recalc) (struct clk *);
+
+	struct clk *pclk;
+	struct pclk_sel *pclk_sel;
+	unsigned int pclk_sel_shift;
+
+	struct list_head children;
+	struct list_head sibling;
+	void *private_data;
+};
+
+/* pll configuration structure */
+struct pll_clk_config {
+	unsigned int *mode_reg;
+	unsigned int *cfg_reg;
+};
+
+/* ahb and apb bus configuration structure */
+struct bus_clk_config {
+	unsigned int *reg;
+	unsigned int mask;
+	unsigned int shift;
+};
+
+/*
+ * Aux clk configuration structure: applicable to GPT, UART and FIRDA
+ */
+struct aux_clk_config {
+	unsigned int *synth_reg;
+};
+
+/* platform specific clock functions */
+void clk_register(struct clk_lookup *cl);
+void recalc_root_clocks(void);
+
+/* clock recalc functions */
+void follow_parent(struct clk *clk);
+void pll1_clk_recalc(struct clk *clk);
+void bus_clk_recalc(struct clk *clk);
+void gpt_clk_recalc(struct clk *clk);
+void aux_clk_recalc(struct clk *clk);
+
+#endif /* __ASM_PLAT_CLOCK_H */
-- 
1.6.0.2

