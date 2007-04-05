Return-Path: <linux-kernel-owner+w=401wt.eu-S1767015AbXDEOnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767015AbXDEOnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767018AbXDEOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:43:15 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:18433 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767015AbXDEOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:43:12 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 10:42:33 -0400
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 43/90] ARM: OMAP: TUSB EVM init
Message-ID: <20070405144230.GH24297@atomide.com>
References: <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <20070404114430.4b9fa9d1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <20070404114430.4b9fa9d1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Randy Dunlap <randy.dunlap@oracle.com> [070404 14:43]:
> On Wed,  4 Apr 2007 14:05:22 -0400 Tony Lindgren wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Add init support for the TUSB6010 EVM board, as connected to H4.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  arch/arm/mach-omap2/usb-tusb6010.c |  333 ++++++++++++++++++++++++++++++++++++
> >  1 files changed, 333 insertions(+), 0 deletions(-)
> 
> ...
> 
> externs should be in some header file.

Following is an updated version. I'll add also gpmc_get_fclk_period()
to 60/90 ARM: OMAP: Merge gpmc changes from N800 tree.

Tony

--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0043-ARM-OMAP-TUSB-EVM-init.txt"

>From 713e6a124cb7b411cff3f41121554acfa1a11a2f Mon Sep 17 00:00:00 2001
From: David Brownell <dbrownell@users.sourceforge.net>
Date: Thu, 7 Dec 2006 14:03:49 -0800
Subject: [PATCH 43/90] ARM: OMAP: TUSB EVM init

Add init support for the TUSB6010 EVM board, as connected to H4.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/usb-tusb6010.c |  333 ++++++++++++++++++++++++++++++++++++
 1 files changed, 333 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap2/usb-tusb6010.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/arm/mach-omap2/usb-tusb6010.c	2007-04-05 10:32:37.000000000 -0400
@@ -0,0 +1,331 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/usb-tusb6010.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+
+#include <linux/usb/musb.h>
+
+#include <asm/arch/gpmc.h>
+#include <asm/arch/gpio.h>
+
+
+static u8		async_cs, sync_cs;
+static unsigned		refclk_psec;
+
+
+/* t2_ps, when quantized to fclk units, must happen no earlier than
+ * the clock after after t1_NS.
+ *
+ * Return a possibly updated value of t2_ps, converted to nsec.
+ */
+static unsigned
+next_clk(unsigned t1_NS, unsigned t2_ps, unsigned fclk_ps)
+{
+	unsigned	t1_ps = t1_NS * 1000;
+	unsigned	t1_f, t2_f;
+
+	if ((t1_ps + fclk_ps) < t2_ps)
+		return t2_ps / 1000;
+
+	t1_f = (t1_ps + fclk_ps - 1) / fclk_ps;
+	t2_f = (t2_ps + fclk_ps - 1) / fclk_ps;
+
+	if (t1_f >= t2_f)
+		t2_f = t1_f + 1;
+
+	return (t2_f * fclk_ps) / 1000;
+}
+
+/* NOTE:  timings are from tusb 6010 datasheet Rev 1.8, 12-Sept 2006 */
+
+static int tusb_set_async_mode(unsigned sysclk_ps, unsigned fclk_ps)
+{
+	struct gpmc_timings	t;
+	unsigned		t_acsnh_advnh = sysclk_ps + 3000;
+	unsigned		tmp;
+
+	memset(&t, 0, sizeof(t));
+
+	/* CS_ON = t_acsnh_acsnl */
+	t.cs_on = 8;
+	/* ADV_ON = t_acsnh_advnh - t_advn */
+	t.adv_on = next_clk(t.cs_on, t_acsnh_advnh - 7000, fclk_ps);
+
+	/*
+	 * READ ... from omap2420 TRM fig 12-13
+	 */
+
+	/* ADV_RD_OFF = t_acsnh_advnh */
+	t.adv_rd_off = next_clk(t.adv_on, t_acsnh_advnh, fclk_ps);
+
+	/* OE_ON = t_acsnh_advnh + t_advn_oen (then wait for nRDY) */
+	t.oe_on = next_clk(t.adv_on, t_acsnh_advnh + 1000, fclk_ps);
+
+	/* ACCESS = counters continue only after nRDY */
+	tmp = t.oe_on * 1000 + 300;
+	t.access = next_clk(t.oe_on, tmp, fclk_ps);
+
+	/* OE_OFF = after data gets sampled */
+	tmp = t.access * 1000;
+	t.oe_off = next_clk(t.access, tmp, fclk_ps);
+
+	t.cs_rd_off = t.oe_off;
+
+	tmp = t.cs_rd_off * 1000 + 7000 /* t_acsn_rdy_z */;
+	t.rd_cycle = next_clk(t.cs_rd_off, tmp, fclk_ps);
+
+	/*
+	 * WRITE ... from omap2420 TRM fig 12-15
+	 */
+
+	/* ADV_WR_OFF = t_acsnh_advnh */
+	t.adv_wr_off = t.adv_rd_off;
+
+	/* WE_ON = t_acsnh_advnh + t_advn_wen (then wait for nRDY) */
+	t.we_on = next_clk(t.adv_wr_off, t_acsnh_advnh + 1000, fclk_ps);
+
+	/* WE_OFF = after data gets sampled */
+	tmp = t.we_on * 1000 + 300;
+	t.we_off = next_clk(t.we_on, tmp, fclk_ps);
+
+	t.cs_wr_off = t.we_off;
+
+	tmp = t.cs_wr_off * 1000 + 7000 /* t_acsn_rdy_z */;
+	t.wr_cycle = next_clk(t.cs_wr_off, tmp, fclk_ps);
+
+	return gpmc_cs_set_timings(async_cs, &t);
+}
+
+static int tusb_set_sync_mode(unsigned sysclk_ps, unsigned fclk_ps)
+{
+	struct gpmc_timings	t;
+	unsigned		t_scsnh_advnh = sysclk_ps + 3000;
+	unsigned		tmp;
+
+	memset(&t, 0, sizeof(t));
+	t.cs_on = 8;
+
+	/* ADV_ON = t_acsnh_advnh - t_advn */
+	t.adv_on = next_clk(t.cs_on, t_scsnh_advnh - 7000, fclk_ps);
+
+	/* GPMC_CLK rate = fclk rate / div */
+	t.sync_clk = 12 /* 11.1 nsec */;
+	tmp = (t.sync_clk * 1000 + fclk_ps - 1) / fclk_ps;
+	if (tmp > 4)
+		return -ERANGE;
+	if (tmp <= 0)
+		tmp = 1;
+	t.page_burst_access = (fclk_ps * tmp) / 1000;
+
+	/*
+	 * READ ... based on omap2420 TRM fig 12-19, 12-20
+	 */
+
+	/* ADV_RD_OFF = t_scsnh_advnh */
+	t.adv_rd_off = next_clk(t.adv_on, t_scsnh_advnh, fclk_ps);
+
+	/* OE_ON = t_scsnh_advnh + t_advn_oen * fclk_ps (then wait for nRDY) */
+	tmp = (t.adv_rd_off * 1000) + (3 * fclk_ps);
+	t.oe_on = next_clk(t.adv_on, tmp, fclk_ps);
+
+	/* ACCESS = number of clock cycles after t_adv_eon */
+	tmp = (t.oe_on * 1000) + (5 * fclk_ps);
+	t.access = next_clk(t.oe_on, tmp, fclk_ps);
+
+	/* OE_OFF = after data gets sampled */
+	tmp = (t.access * 1000) + (1 * fclk_ps);
+	t.oe_off = next_clk(t.access, tmp, fclk_ps);
+
+	t.cs_rd_off = t.oe_off;
+
+	tmp = t.cs_rd_off * 1000 + 7000 /* t_scsn_rdy_z */;
+	t.rd_cycle = next_clk(t.cs_rd_off, tmp, fclk_ps);
+
+	/*
+	 * WRITE ... based on omap2420 TRM fig 12-21
+	 */
+
+	/* ADV_WR_OFF = t_scsnh_advnh */
+	t.adv_wr_off = t.adv_rd_off;
+
+	/* WE_ON = t_scsnh_advnh + t_advn_wen * fclk_ps (then wait for nRDY) */
+	tmp = (t.adv_wr_off * 1000) + (3 * fclk_ps);
+	t.we_on = next_clk(t.adv_wr_off, tmp, fclk_ps);
+
+	/* WE_OFF = number of clock cycles after t_adv_wen */
+	tmp = (t.we_on * 1000) + (6 * fclk_ps);
+	t.we_off = next_clk(t.we_on, tmp, fclk_ps);
+
+	t.cs_wr_off = t.we_off;
+
+	tmp = t.cs_wr_off * 1000 + 7000 /* t_scsn_rdy_z */;
+	t.wr_cycle = next_clk(t.cs_wr_off, tmp, fclk_ps);
+
+	return gpmc_cs_set_timings(sync_cs, &t);
+}
+
+/* tusb driver calls this when it changes the chip's clocking */
+int tusb6010_platform_retime(unsigned is_refclk)
+{
+	static const char	error[] =
+		KERN_ERR "tusb6010 %s retime error %d\n";
+
+	unsigned	fclk_ps = gpmc_get_fclk_period();
+	unsigned	sysclk_ps;
+	int		status;
+
+	if (!refclk_psec)
+		return -ENODEV;
+
+	sysclk_ps = is_refclk ? refclk_psec : TUSB6010_OSCCLK_60;
+
+	status = tusb_set_async_mode(sysclk_ps, fclk_ps);
+	if (status < 0) {
+		printk(error, "async", status);
+		goto done;
+	}
+	status = tusb_set_sync_mode(sysclk_ps, fclk_ps);
+	if (status < 0)
+		printk(error, "sync", status);
+done:
+	return status;
+}
+EXPORT_SYMBOL_GPL(tusb6010_platform_retime);
+
+static struct resource tusb_resources[] = {
+	/* Order is significant!  The start/end fields
+	 * are updated during setup..
+	 */
+	{ /* Asynchronous access */
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* Synchronous access */
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* IRQ */
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 tusb_dmamask = ~(u32)0;
+
+static struct platform_device tusb_device = {
+	.name		= "musb_hdrc",
+	.id		= -1,
+	.dev = {
+		.dma_mask		= &tusb_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources	= ARRAY_SIZE(tusb_resources),
+	.resource	= tusb_resources,
+};
+
+
+/* this may be called only from board-*.c setup code */
+int __init
+tusb6010_setup_interface(struct musb_hdrc_platform_data *data,
+		unsigned ps_refclk, unsigned waitpin,
+		unsigned async, unsigned sync,
+		unsigned irq, unsigned dmachan)
+{
+	int		status;
+	static char	error[] __initdata =
+		KERN_ERR "tusb6010 init error %d, %d\n";
+
+	/* ASYNC region, primarily for PIO */
+	status = gpmc_cs_request(async, SZ_16M, (unsigned long *)
+				&tusb_resources[0].start);
+	if (status < 0) {
+		printk(error, 1, status);
+		return status;
+	}
+	tusb_resources[0].end = tusb_resources[0].start + 0x9ff;
+	async_cs = async;
+	gpmc_cs_write_reg(async, GPMC_CS_CONFIG1,
+			  GPMC_CONFIG1_PAGE_LEN(2)
+			| GPMC_CONFIG1_WAIT_READ_MON
+			| GPMC_CONFIG1_WAIT_WRITE_MON
+			| GPMC_CONFIG1_WAIT_PIN_SEL(waitpin)
+			| GPMC_CONFIG1_READTYPE_ASYNC
+			| GPMC_CONFIG1_WRITETYPE_ASYNC
+			| GPMC_CONFIG1_DEVICESIZE_16
+			| GPMC_CONFIG1_DEVICETYPE_NOR
+			| GPMC_CONFIG1_MUXADDDATA);
+
+
+	/* SYNC region, primarily for DMA */
+	status = gpmc_cs_request(sync, SZ_16M, (unsigned long *)
+				&tusb_resources[1].start);
+	if (status < 0) {
+		printk(error, 2, status);
+		return status;
+	}
+	tusb_resources[1].end = tusb_resources[1].start + 0x9ff;
+	sync_cs = sync;
+	gpmc_cs_write_reg(sync, GPMC_CS_CONFIG1,
+			  GPMC_CONFIG1_READMULTIPLE_SUPP
+			| GPMC_CONFIG1_READTYPE_SYNC
+			| GPMC_CONFIG1_WRITEMULTIPLE_SUPP
+			| GPMC_CONFIG1_WRITETYPE_SYNC
+			| GPMC_CONFIG1_CLKACTIVATIONTIME(1)
+			| GPMC_CONFIG1_PAGE_LEN(2)
+			| GPMC_CONFIG1_WAIT_READ_MON
+			| GPMC_CONFIG1_WAIT_WRITE_MON
+			| GPMC_CONFIG1_WAIT_PIN_SEL(waitpin)
+			| GPMC_CONFIG1_DEVICESIZE_16
+			| GPMC_CONFIG1_DEVICETYPE_NOR
+			| GPMC_CONFIG1_MUXADDDATA
+			/* fclk divider gets set later */
+			);
+
+	/* IRQ */
+	status = omap_request_gpio(irq);
+	if (status < 0) {
+		printk(error, 3, status);
+		return status;
+	}
+	omap_set_gpio_direction(irq, 1);
+	tusb_resources[2].start = irq + IH_GPIO_BASE;
+
+	/* set up memory timings ... can speed them up later */
+	if (!ps_refclk) {
+		printk(error, 4, status);
+		return -ENODEV;
+	}
+	refclk_psec = ps_refclk;
+	status = tusb6010_platform_retime(1);
+	if (status < 0) {
+		printk(error, 5, status);
+		return status;
+	}
+
+	/* finish device setup ... */
+	if (!data) {
+		printk(error, 6, status);
+		return -ENODEV;
+	}
+	data->multipoint = 1;
+	tusb_device.dev.platform_data = data;
+
+	/* REVISIT let the driver know what DMA channels work */
+	if (!dmachan)
+		tusb_device.dev.dma_mask = NULL;
+
+	/* so far so good ... register the device */
+	status = platform_device_register(&tusb_device);
+	if (status < 0) {
+		printk(error, 7, status);
+		return status;
+	}
+	return 0;
+}

--Q0rSlbzrZN6k9QnT--
