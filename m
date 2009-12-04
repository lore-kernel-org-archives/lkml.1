Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZLDKZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZLDKZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZLDKZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:25:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60441 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbZLDKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:25:07 -0500
Date: Fri, 4 Dec 2009 11:25:12 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, valentin.longchamp@epfl.ch,
       daniel@caiaq.de, grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       r.herring@freescale.com
Subject: Re: [RFC][PATCH 05/10] mxc: Add board support for the i.MX51
	babbage board
Message-ID: <20091204102512.GH15126@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:43:10 up 52 days, 21:32, 31 users,  load average: 0.06, 0.09,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:05AM +0200, Amit Kucheria wrote:
> Add basic clock support, cpu identification, I/O mapping and serial port. Boot
> tested on Freescale Babbage 2.5 board.
> 
> Support for FEC ethernet device is also added to allow NFS-root but needs the
> fixes from the following patches to get onboard-ethernet working
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/board-mx51_babbage.c      |  141 +++++
>  arch/arm/mach-mx5/clock.c                   |  817 +++++++++++++++++++++++++++
>  arch/arm/mach-mx5/cpu.c                     |   46 ++
>  arch/arm/mach-mx5/crm_regs.h                |  685 ++++++++++++++++++++++
>  arch/arm/mach-mx5/devices.c                 |   90 +++
>  arch/arm/mach-mx5/devices.h                 |    4 +
>  arch/arm/mach-mx5/mm.c                      |   86 +++
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h |  309 ++++++++++
>  arch/arm/plat-mxc/include/mach/mx51.h       |  481 ++++++++++++++++
>  9 files changed, 2659 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/board-mx51_babbage.c
>  create mode 100644 arch/arm/mach-mx5/clock.c
>  create mode 100644 arch/arm/mach-mx5/cpu.c
>  create mode 100644 arch/arm/mach-mx5/crm_regs.h
>  create mode 100644 arch/arm/mach-mx5/devices.c
>  create mode 100644 arch/arm/mach-mx5/devices.h
>  create mode 100644 arch/arm/mach-mx5/mm.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx51.h
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx51.h
> 
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> new file mode 100644
> index 0000000..a1bc9c4
> --- /dev/null
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -0,0 +1,141 @@
> +/*
> + * Copyright 2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com> All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <mach/common.h>
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/time.h>
> +#include <mach/memory.h>
> +#include <mach/imx-uart.h>
> +#include <mach/iomux-mx51.h>
> +
> +#include "crm_regs.h"
> +#include "devices.h"
> +
> +extern void __init mx51_babbage_io_init(void);
> +
> +/* Pad control groupings */
> +#define MX51_UART1_PAD_CTRL	(PAD_CTL_HYS | PAD_CTL_PKE | PAD_CTL_PUE | PAD_CTL_DSE_HIGH)
> +#define MX51_UART2_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_PUE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
> +#define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
> +
> +/* UART1 */
> +#define MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD	IOMUX_PAD(0x618, 0x228,	IOMUX_CONFIG_ALT0, 0x9e4,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
> +#define MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD	IOMUX_PAD(0x61C, 0x22C, IOMUX_CONFIG_ALT0, 0x0,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
> +#define MX51_BABBAGE_PAD_UART1_RTS__UART1_RTS	IOMUX_PAD(0x620, 0x230, IOMUX_CONFIG_ALT0, 0x9e0, 0, MX51_UART1_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_UART1_CTS__UART1_CTS	IOMUX_PAD(0x624, 0x234, IOMUX_CONFIG_ALT0, 0x0,   0, MX51_UART1_PAD_CTRL)
> +
> +/* UART2 */
> +#define MX51_BABBAGE_PAD_UART2_RXD__UART2_RXD	IOMUX_PAD(0x628, 0x238, IOMUX_CONFIG_ALT0, 0x9ec, 2, MX51_UART2_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_UART2_TXD__UART2_TXD	IOMUX_PAD(0x62C, 0x23C, IOMUX_CONFIG_ALT0, 0x0,   0, MX51_UART2_PAD_CTRL)
> +
> +/* UART3 */
> +#define MX51_BABBAGE_PAD_EIM_D25__UART3_RXD	IOMUX_PAD(0x414, 0x080, IOMUX_CONFIG_ALT3, 0x9f4,   0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D26__UART3_TXD	IOMUX_PAD(0x418, 0x084, IOMUX_CONFIG_ALT3, 0x0,   0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D27__UART3_RTS	IOMUX_PAD(0x41c, 0x088, IOMUX_CONFIG_ALT3, 0x9f0,   0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D24__UART3_CTS	IOMUX_PAD(0x410, 0x07c, IOMUX_CONFIG_ALT3, 0x0,   0, MX51_UART3_PAD_CTRL)
> +

These should go as generic versions to
arch/arm/plat-mxc/include/mach/iomux-mx51.h.


> +
> +#define MX51_BABBAGE_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 1, (PAD_CTL_SRE_SLOW | PAD_CTL_DSE_MED | PAD_CTL_PUS_100K_UP |  PAD_CTL_HYS))
> +
> +static struct platform_device *devices[] __initdata = {
> +	&mxc_fec_device,
> +};
> +
> +static struct pad_desc mx51babbage_pads[] = {
> +	/* UART1 */
> +	MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD,
> +	MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD,
> +	MX51_BABBAGE_PAD_UART1_RTS__UART1_RTS,
> +	MX51_BABBAGE_PAD_UART1_CTS__UART1_CTS,
> +
> +	/* UART2 */
> +	MX51_BABBAGE_PAD_UART2_RXD__UART2_RXD,
> +	MX51_BABBAGE_PAD_UART2_TXD__UART2_TXD,
> +
> +	/* UART3 */
> +	MX51_BABBAGE_PAD_EIM_D25__UART3_RXD,
> +	MX51_BABBAGE_PAD_EIM_D26__UART3_TXD,
> +	MX51_BABBAGE_PAD_EIM_D27__UART3_RTS,
> +	MX51_BABBAGE_PAD_EIM_D24__UART3_CTS,
> +};
> +
> +/* Serial ports */
> +#if defined(CONFIG_SERIAL_IMX) || defined(CONFIG_SERIAL_IMX_MODULE)
> +static struct imxuart_platform_data uart_pdata = {
> +	.flags = IMXUART_HAVE_RTSCTS,
> +};
> +
> +static inline void mxc_init_imx_uart(void)
> +{
> +	mxc_register_device(&mxc_uart_device0, &uart_pdata);
> +	mxc_register_device(&mxc_uart_device1, &uart_pdata);
> +	mxc_register_device(&mxc_uart_device2, &uart_pdata);
> +}
> +#else /* !SERIAL_IMX */
> +static inline void mxc_init_imx_uart(void)
> +{
> +}
> +#endif /* SERIAL_IMX */
> +
> +/*
> + * Board specific fixup function. It is called by \b setup_arch() in
> + * setup.c file very early on during kernel starts. It allows the user to
> + * statically fill in the proper values for the passed-in parameters. None of
> + * the parameters is used currently.
> + *
> + * @param  desc         pointer to \b struct \b machine_desc
> + * @param  tags         pointer to \b struct \b tag
> + * @param  cmdline      pointer to the command line
> + * @param  mi           pointer to \b struct \b meminfo
> + */
> +static void __init fixup_mxc_board(struct machine_desc *desc, struct tag *tags,
> +				   char **cmdline, struct meminfo *mi)
> +{
> +	/* Nothing! */
> +}

Please remove this function

> +
> +/*
> + * Board specific initialization.
> + */
> +static void __init mxc_board_init(void)
> +{
> +	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads, ARRAY_SIZE(mx51babbage_pads));
> +	mxc_init_imx_uart();
> +	platform_add_devices(devices, ARRAY_SIZE(devices));
> +}
> +
> +static void __init mx51_babbage_timer_init(void)
> +{
> +	mx51_clocks_init(32768, 24000000, 22579200, 24576000);
> +}
> +
> +static struct sys_timer mxc_timer = {
> +	.init	= mx51_babbage_timer_init,
> +};
> +
> +MACHINE_START(MX51_BABBAGE, "Freescale MX51 Babbage Board")
> +	/* Maintainer: Amit Kucheria <amit.kucheria@canonical.com> */
> +	.phys_io = AIPS1_BASE_ADDR,
> +	.io_pg_offst = ((AIPS1_BASE_ADDR_VIRT) >> 18) & 0xfffc,
> +	.boot_params = PHYS_OFFSET + 0x100,
> +	.fixup = fixup_mxc_board,
> +	.map_io = mx51_map_io,
> +	.init_irq = mx51_init_irq,
> +	.init_machine = mxc_board_init,
> +	.timer = &mxc_timer,
> +MACHINE_END
> diff --git a/arch/arm/mach-mx5/clock.c b/arch/arm/mach-mx5/clock.c
> new file mode 100644
> index 0000000..7fdfcbc
> --- /dev/null
> +++ b/arch/arm/mach-mx5/clock.c
> @@ -0,0 +1,817 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +
> +#include <asm/clkdev.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/common.h>
> +#include <mach/clock.h>
> +
> +#include "crm_regs.h"
> +
> +static unsigned long pll_base[] = {
> +	(unsigned long)MXC_DPLL1_BASE,
> +	(unsigned long)MXC_DPLL2_BASE,
> +	(unsigned long)MXC_DPLL3_BASE,

These casts show that this array should be of type void __iomem *.


> +};
> +
> +/* External clock values passed-in by the board code */
> +static unsigned long external_high_reference, external_low_reference;
> +static unsigned long oscillator_reference, ckih2_reference;
> +
> +static struct clk osc_clk;
> +static struct clk pll1_main_clk;
> +static struct clk pll1_sw_clk;
> +static struct clk pll2_sw_clk;
> +static struct clk pll3_sw_clk;
> +static struct clk lp_apm_clk;
> +static struct clk periph_apm_clk;
> +static struct clk ahb_clk;
> +static struct clk ipg_clk;
> +
> +#define SPIN_DELAY	1000000 /* in nanoseconds */
> +
> +extern void propagate_rate(struct clk *clk);

This is not used.

> +
> +static int _clk_ccgr_enable(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(clk->enable_reg);
> +	reg |= MXC_CCM_CCGR_MOD_ON << clk->enable_shift;
> +	__raw_writel(reg, clk->enable_reg);
> +
> +	return 0;
> +}
> +
> +static void _clk_ccgr_disable(struct clk *clk)
> +{
> +	u32 reg;
> +	reg = __raw_readl(clk->enable_reg);
> +	reg &= ~(MXC_CCM_CCGR_MOD_OFF << clk->enable_shift);
> +	__raw_writel(reg, clk->enable_reg);
> +
> +}
> +
> +static void _clk_ccgr_disable_inwait(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(clk->enable_reg);
> +	reg &= ~(MXC_CCM_CCGR_CG_MASK << clk->enable_shift);
> +	reg |= MXC_CCM_CCGR_MOD_IDLE << clk->enable_shift;
> +	__raw_writel(reg, clk->enable_reg);
> +}
> +
> +/*
> + * For the 4-to-1 muxed input clock
> + */
> +static inline u32 _get_mux(struct clk *parent, struct clk *m0,
> +			   struct clk *m1, struct clk *m2, struct clk *m3)
> +{
> +	if (parent == m0)
> +		return 0;
> +	else if (parent == m1)
> +		return 1;
> +	else if (parent == m2)
> +		return 2;
> +	else if (parent == m3)
> +		return 3;
> +	else
> +		BUG();
> +
> +	return 0;
> +}
> +
> +static inline unsigned long _get_pll_base(struct clk *pll)
> +{
> +	if (pll == &pll1_main_clk)
> +		return pll_base[0];
> +	else if (pll == &pll2_sw_clk)
> +		return pll_base[1];
> +	else if (pll == &pll3_sw_clk)
> +		return pll_base[2];
> +	else
> +		BUG();
> +
> +	return 0;
> +}
> +
> +static unsigned long _clk_pll_recalc(struct clk *clk)
> +{

The original Freescale code stored the rate in clk->rate without
returning the rate. As this is not true here, can we rename these
functions to x_get_rate?
Also, these leading underscores in the function names look like we have
something to hide. We don't, right?

> +	long mfi, mfn, mfd, pdf, ref_clk, mfn_abs;
> +	unsigned long dp_op, dp_mfd, dp_mfn, dp_ctl, pll_hfsm, dbl;
> +	unsigned long pllbase;
> +	s64 temp;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	pllbase = _get_pll_base(clk);

pllbase should be a void __iomem *.

> +
> +	dp_ctl = __raw_readl(pllbase + MXC_PLL_DP_CTL);
> +	pll_hfsm = dp_ctl & MXC_PLL_DP_CTL_HFSM;
> +	dbl = dp_ctl & MXC_PLL_DP_CTL_DPDCK0_2_EN;
> +
> +	if (pll_hfsm == 0) {
> +		dp_op = __raw_readl(pllbase + MXC_PLL_DP_OP);
> +		dp_mfd = __raw_readl(pllbase + MXC_PLL_DP_MFD);
> +		dp_mfn = __raw_readl(pllbase + MXC_PLL_DP_MFN);
> +	} else {
> +		dp_op = __raw_readl(pllbase + MXC_PLL_DP_HFS_OP);
> +		dp_mfd = __raw_readl(pllbase + MXC_PLL_DP_HFS_MFD);
> +		dp_mfn = __raw_readl(pllbase + MXC_PLL_DP_HFS_MFN);
> +	}
> +	pdf = dp_op & MXC_PLL_DP_OP_PDF_MASK;
> +	mfi = (dp_op & MXC_PLL_DP_OP_MFI_MASK) >> MXC_PLL_DP_OP_MFI_OFFSET;
> +	mfi = (mfi <= 5) ? 5 : mfi;
> +	mfd = dp_mfd & MXC_PLL_DP_MFD_MASK;
> +	mfn = mfn_abs = dp_mfn & MXC_PLL_DP_MFN_MASK;
> +	/* Sign extend to 32-bits */
> +	if (mfn >= 0x04000000) {
> +		mfn |= 0xFC000000;
> +		mfn_abs = -mfn;
> +	}
> +
> +	ref_clk = 2 * parent_rate;
> +	if (dbl != 0)
> +		ref_clk *= 2;
> +
> +	ref_clk /= (pdf + 1);
> +	temp = (u64) ref_clk * mfn_abs;
> +	do_div(temp, mfd + 1);
> +	if (mfn < 0)
> +		temp = -temp;
> +	temp = (ref_clk * mfi) + temp;
> +
> +	return temp;
> +}
> +
> +static int _clk_pll_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	u32 reg;
> +	u32 pllbase;
> +
> +	long mfi, pdf, mfn, mfd = 999999;
> +	s64 temp64;
> +	unsigned long quad_parent_rate;
> +	unsigned long pll_hfsm, dp_ctl;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	pllbase = _get_pll_base(clk);
> +
> +	quad_parent_rate = 4 * parent_rate;
> +	pdf = mfi = -1;
> +	while (++pdf < 16 && mfi < 5)
> +		mfi = rate * (pdf+1) / quad_parent_rate;
> +	if (mfi > 15)
> +		return -1;
> +	pdf--;
> +
> +	temp64 = rate*(pdf+1) - quad_parent_rate*mfi;
> +	do_div(temp64, quad_parent_rate/1000000);
> +	mfn = (long)temp64;
> +
> +	dp_ctl = __raw_readl(pllbase + MXC_PLL_DP_CTL);
> +	/* use dpdck0_2 */
> +	__raw_writel(dp_ctl | 0x1000L, pllbase + MXC_PLL_DP_CTL);
> +	pll_hfsm = dp_ctl & MXC_PLL_DP_CTL_HFSM;
> +	if (pll_hfsm == 0) {
> +		reg = mfi<<4 | pdf;
> +		__raw_writel(reg, pllbase + MXC_PLL_DP_OP);
> +		__raw_writel(mfd, pllbase + MXC_PLL_DP_MFD);
> +		__raw_writel(mfn, pllbase + MXC_PLL_DP_MFN);
> +	} else {
> +		reg = mfi<<4 | pdf;
> +		__raw_writel(reg, pllbase + MXC_PLL_DP_HFS_OP);
> +		__raw_writel(mfd, pllbase + MXC_PLL_DP_HFS_MFD);
> +		__raw_writel(mfn, pllbase + MXC_PLL_DP_HFS_MFN);
> +	}

Nitpick: Please add spaces on both sides of operators like << >> and *

> +
> +	return 0;
> +}
> +
> +static int _clk_pll_enable(struct clk *clk)
> +{
> +	u32 reg;
> +	u32 pllbase;
> +	struct timespec nstimeofday;
> +	struct timespec curtime;
> +
> +	pllbase = _get_pll_base(clk);
> +	reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) | MXC_PLL_DP_CTL_UPEN;
> +	__raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> +
> +	/* Wait for lock */
> +	getnstimeofday(&nstimeofday);
> +	while (!(__raw_readl(pllbase + MXC_PLL_DP_CTL) & MXC_PLL_DP_CTL_LRF)) {
> +		getnstimeofday(&curtime);
> +		if (curtime.tv_nsec - nstimeofday.tv_nsec > SPIN_DELAY)
> +			panic("pll relock failed\n");
> +	}
> +	return 0;
> +}
> +
> +static void _clk_pll_disable(struct clk *clk)
> +{
> +	u32 reg;
> +	u32 pllbase;
> +
> +	pllbase = _get_pll_base(clk);
> +	reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) & ~MXC_PLL_DP_CTL_UPEN;
> +	__raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> +}
> +
> +static int _clk_pll1_sw_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg, mux;
> +
> +	reg = __raw_readl(MXC_CCM_CCSR);
> +
> +	if (parent == &pll1_main_clk) {
> +		reg &= ~MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> +		__raw_writel(reg, MXC_CCM_CCSR);
> +		/* Set the step_clk parent to be lp_apm, to save power. */
> +		mux = _get_mux(&lp_apm_clk, &lp_apm_clk, NULL, &pll2_sw_clk,
> +			       &pll3_sw_clk);

This looks wrong or at least unnecessary. _get_mux will always return 0 if
called like this.


> +		reg = __raw_readl(MXC_CCM_CCSR);
> +		reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +		    (mux << MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +	} else {
> +		if (parent == &lp_apm_clk) {
> +			reg |= MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> +			reg = __raw_readl(MXC_CCM_CCSR);
> +			mux = _get_mux(parent, &lp_apm_clk, NULL, &pll2_sw_clk,
> +				       &pll3_sw_clk);

We are inside if (parent == &lp_apm_clk), so _get_mux will always return
0 here aswell.

> +			reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +			    (mux << MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +		} else {
> +			mux = _get_mux(parent, &lp_apm_clk, NULL, &pll2_sw_clk,
> +				       &pll3_sw_clk);
> +			reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +			    (mux << MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +			__raw_writel(reg, MXC_CCM_CCSR);
> +			reg = __raw_readl(MXC_CCM_CCSR);
> +			reg |= MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> +
> +		}
> +	}
> +	__raw_writel(reg, MXC_CCM_CCSR);
> +	return 0;
> +}
> +
> +static unsigned long _clk_pll1_sw_recalc(struct clk *clk)
> +{
> +	u32 reg, div;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	div = 1;
> +	reg = __raw_readl(MXC_CCM_CCSR);
> +
> +	if (clk->parent == &pll2_sw_clk) {
> +		div = ((reg & MXC_CCM_CCSR_PLL2_PODF_MASK) >>
> +		       MXC_CCM_CCSR_PLL2_PODF_OFFSET) + 1;
> +	} else if (clk->parent == &pll3_sw_clk) {
> +		div = ((reg & MXC_CCM_CCSR_PLL3_PODF_MASK) >>
> +		       MXC_CCM_CCSR_PLL3_PODF_OFFSET) + 1;
> +	}
> +	return parent_rate / div;
> +}
> +
> +static int _clk_pll2_sw_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(MXC_CCM_CCSR);
> +
> +	if (parent == &pll2_sw_clk) {
> +		reg &= ~MXC_CCM_CCSR_PLL2_SW_CLK_SEL;
> +	} else {
> +		reg = (reg & ~MXC_CCM_CCSR_PLL2_SW_CLK_SEL);
> +		reg |= MXC_CCM_CCSR_PLL2_SW_CLK_SEL;

You first clear the bit and then set the very same bit again. Looks like
the first line is wrong.

> +	}
> +	__raw_writel(reg, MXC_CCM_CCSR);
> +	return 0;
> +}
> +
> +static int _clk_lp_apm_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	if (parent == &osc_clk)
> +		reg = __raw_readl(MXC_CCM_CCSR) & ~MXC_CCM_CCSR_LP_APM_SEL;
> +	else
> +		return -EINVAL;
> +
> +	__raw_writel(reg, MXC_CCM_CCSR);
> +
> +	return 0;
> +}
> +
> +static unsigned long _clk_arm_recalc(struct clk *clk)
> +{
> +	u32 cacrr, div;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +	cacrr = __raw_readl(MXC_CCM_CACRR);
> +	div = (cacrr & MXC_CCM_CACRR_ARM_PODF_MASK) + 1;
> +
> +	return parent_rate / div;
> +}
> +
> +static int _clk_periph_apm_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg, mux;
> +	struct timespec nstimeofday;
> +	struct timespec curtime;
> +
> +	mux = _get_mux(parent, &pll1_sw_clk, &pll3_sw_clk, &lp_apm_clk, NULL);
> +
> +	reg = __raw_readl(MXC_CCM_CBCMR) & ~MXC_CCM_CBCMR_PERIPH_CLK_SEL_MASK;
> +	reg |= mux << MXC_CCM_CBCMR_PERIPH_CLK_SEL_OFFSET;
> +	__raw_writel(reg, MXC_CCM_CBCMR);
> +
> +	getnstimeofday(&nstimeofday);
> +	while (__raw_readl(MXC_CCM_CDHIPR) &
> +			MXC_CCM_CDHIPR_PERIPH_CLK_SEL_BUSY) {
> +		getnstimeofday(&curtime);
> +		if (curtime.tv_nsec - nstimeofday.tv_nsec > SPIN_DELAY)
> +			panic("pll _clk_periph_apm_set_parent failed\n");
> +	}
> +	return 0;
> +}
> +
> +static unsigned long _clk_main_bus_recalc(struct clk *clk)
> +{
> +	return clk_get_rate(clk->parent);
> +}
> +
> +static int _clk_main_bus_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	if (parent == &pll2_sw_clk) {
> +		reg = __raw_readl(MXC_CCM_CBCDR) &
> +		    ~MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> +	} else if (parent == &periph_apm_clk) {
> +		reg = __raw_readl(MXC_CCM_CBCDR) | MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> +	} else {
> +		return -EINVAL;
> +	}

This reads better as

	reg = __raw_readl(MXC_CCM_CBCDR);

	if (parent == &pll2_sw_clk)
		reg &= ~MXC_CCM_CBCDR_PERIPH_CLK_SEL;
	else if (parent == &periph_apm_clk)
		reg |= MXC_CCM_CBCDR_PERIPH_CLK_SEL;
	else
		return -EINVAL;


> +	__raw_writel(reg, MXC_CCM_CBCDR);
> +
> +	return 0;
> +}
> +
> +static struct clk main_bus_clk = {
> +	.parent = &pll2_sw_clk,
> +	.set_parent = _clk_main_bus_set_parent,
> +	.get_rate = _clk_main_bus_recalc,
> +};
> +
> +static unsigned long _clk_ahb_recalc(struct clk *clk)
> +{
> +	u32 reg, div;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	reg = __raw_readl(MXC_CCM_CBCDR);
> +	div = ((reg & MXC_CCM_CBCDR_AHB_PODF_MASK) >>
> +	       MXC_CCM_CBCDR_AHB_PODF_OFFSET) + 1;
> +	return parent_rate / div;
> +}
> +
> +
> +static int _clk_ahb_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	u32 reg, div;
> +	struct timespec nstimeofday;
> +	struct timespec curtime;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	div = parent_rate / rate;
> +	if (div > 8 || div < 1 || ((parent_rate / div) != rate))
> +		return -EINVAL;
> +
> +	reg = __raw_readl(MXC_CCM_CBCDR);
> +	reg &= ~MXC_CCM_CBCDR_AHB_PODF_MASK;
> +	reg |= (div - 1) << MXC_CCM_CBCDR_AHB_PODF_OFFSET;
> +	__raw_writel(reg, MXC_CCM_CBCDR);
> +
> +	getnstimeofday(&nstimeofday);
> +	while (__raw_readl(MXC_CCM_CDHIPR) & MXC_CCM_CDHIPR_AHB_PODF_BUSY) {
> +		getnstimeofday(&curtime);
> +		if (curtime.tv_nsec - nstimeofday.tv_nsec > SPIN_DELAY)
> +			panic("_clk_ahb_set_rate failed\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long _clk_ahb_round_rate(struct clk *clk,
> +						unsigned long rate)
> +{
> +	u32 div;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	div = parent_rate / rate;
> +	if (div > 8)
> +		div = 8;
> +	else if (div == 0)
> +		div++;
> +	return parent_rate / div;
> +}
> +
> +
> +static int _clk_max_enable(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	_clk_ccgr_enable(clk);
> +
> +	/* Handshake with MAX when LPM is entered. */
> +	reg = __raw_readl(MXC_CCM_CLPCR);
> +	reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> +	__raw_writel(reg, MXC_CCM_CLPCR);
> +
> +	return 0;
> +}
> +
> +static void _clk_max_disable(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	_clk_ccgr_disable_inwait(clk);
> +
> +	/* No Handshake with MAX when LPM is entered as its disabled. */
> +	reg = __raw_readl(MXC_CCM_CLPCR);
> +	reg |= MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> +	__raw_writel(reg, MXC_CCM_CLPCR);
> +}
> +
> +static unsigned long _clk_ipg_recalc(struct clk *clk)
> +{
> +	u32 reg, div;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	reg = __raw_readl(MXC_CCM_CBCDR);
> +	div = ((reg & MXC_CCM_CBCDR_IPG_PODF_MASK) >>
> +	       MXC_CCM_CBCDR_IPG_PODF_OFFSET) + 1;
> +
> +	return parent_rate / div;
> +}
> +
> +static unsigned long _clk_ipg_per_recalc(struct clk *clk)
> +{
> +	u32 reg, prediv1, prediv2, podf;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	if (clk->parent == &main_bus_clk || clk->parent == &lp_apm_clk) {
> +		/* the main_bus_clk is the one before the DVFS engine */
> +		reg = __raw_readl(MXC_CCM_CBCDR);
> +		prediv1 = ((reg & MXC_CCM_CBCDR_PERCLK_PRED1_MASK) >>
> +			   MXC_CCM_CBCDR_PERCLK_PRED1_OFFSET) + 1;
> +		prediv2 = ((reg & MXC_CCM_CBCDR_PERCLK_PRED2_MASK) >>
> +			   MXC_CCM_CBCDR_PERCLK_PRED2_OFFSET) + 1;
> +		podf = ((reg & MXC_CCM_CBCDR_PERCLK_PODF_MASK) >>
> +			MXC_CCM_CBCDR_PERCLK_PODF_OFFSET) + 1;
> +		return parent_rate / (prediv1 * prediv2 * podf);
> +	} else if (clk->parent == &ipg_clk) {
> +		return clk_get_rate(&ipg_clk);

return parent_rate?

> +	} else {
> +		BUG();
> +	}
> +}
> +
> +static int _clk_ipg_per_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg, mux;
> +
> +	reg = __raw_readl(MXC_CCM_CBCMR);
> +	mux = _get_mux(parent, &main_bus_clk, &lp_apm_clk, &ipg_clk, NULL);
> +	if (mux == 2) {
> +		reg |= MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;
> +	} else {
> +		reg &= ~MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;
> +		if (mux == 0)
> +			reg &= ~MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
> +		else
> +			reg |= MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
> +	}

_get_mux does not seem to make sense in this context. How about:

	reg &= ~MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
	reg &= ~MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;

	if (parent == &ipg_clk)
		reg |= MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;
	else if (parent == &lp_apm_clk)
		reg |= MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
	else if (parent != &main_bus_clk)
		return -EINVAL;


> +	__raw_writel(reg, MXC_CCM_CBCMR);
> +
> +	return 0;
> +}
> +
> +static unsigned long _clk_uart_recalc(struct clk *clk)
> +{
> +	u32 reg, prediv, podf;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	reg = __raw_readl(MXC_CCM_CSCDR1);
> +	prediv = ((reg & MXC_CCM_CSCDR1_UART_CLK_PRED_MASK) >>
> +		  MXC_CCM_CSCDR1_UART_CLK_PRED_OFFSET) + 1;
> +	podf = ((reg & MXC_CCM_CSCDR1_UART_CLK_PODF_MASK) >>
> +		MXC_CCM_CSCDR1_UART_CLK_PODF_OFFSET) + 1;
> +
> +	return parent_rate / (prediv * podf);
> +}
> +
> +static int _clk_uart_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg, mux;
> +
> +	mux = _get_mux(parent, &pll1_sw_clk, &pll2_sw_clk, &pll3_sw_clk,
> +		       &lp_apm_clk);
> +	reg = __raw_readl(MXC_CCM_CSCMR1) & ~MXC_CCM_CSCMR1_UART_CLK_SEL_MASK;
> +	reg |= mux << MXC_CCM_CSCMR1_UART_CLK_SEL_OFFSET;
> +	__raw_writel(reg, MXC_CCM_CSCMR1);
> +
> +	return 0;
> +}
> +
> +static unsigned long get_high_reference_clock_rate(struct clk *clk)
> +{
> +	return external_high_reference;
> +}
> +
> +static unsigned long get_low_reference_clock_rate(struct clk *clk)
> +{
> +	return external_low_reference;
> +}
> +
> +static unsigned long get_oscillator_reference_clock_rate(struct clk *clk)
> +{
> +	return oscillator_reference;
> +}
> +
> +static unsigned long get_ckih2_reference_clock_rate(struct clk *clk)
> +{
> +	return ckih2_reference;
> +}
> +
> +/* External high frequency clock */
> +static struct clk ckih_clk = {
> +	.get_rate = get_high_reference_clock_rate,
> +};
> +
> +static struct clk ckih2_clk = {
> +	.get_rate = get_ckih2_reference_clock_rate,
> +};
> +
> +static struct clk osc_clk = {
> +	.get_rate = get_oscillator_reference_clock_rate,
> +};
> +
> +/* External low frequency (32kHz) clock */
> +static struct clk ckil_clk = {
> +	.get_rate = get_low_reference_clock_rate,
> +};
> +
> +static struct clk pll1_main_clk = {
> +	.parent = &osc_clk,
> +	.get_rate = _clk_pll_recalc,
> +	.enable = _clk_pll_enable,
> +	.disable = _clk_pll_disable,
> +};
> +
> +/* Clock tree block diagram (WIP):
> + *
> + * PLL output -> |
> + *               | CCM Switcher -> CCM_CLK_ROOT_GEN ->
> + * PLL bypass -> |
> + *
> + */
> +
> +/* PLL1 SW supplies to ARM core */
> +static struct clk pll1_sw_clk = {
> +	.parent = &pll1_main_clk,
> +	.set_parent = _clk_pll1_sw_set_parent,
> +	.get_rate = _clk_pll1_sw_recalc,
> +};
> +
> +/* PLL2 SW supplies to AXI/AHB/IP buses */
> +static struct clk pll2_sw_clk = {
> +	.parent = &osc_clk,
> +	.get_rate = _clk_pll_recalc,
> +	.set_rate = _clk_pll_set_rate,
> +	.set_parent = _clk_pll2_sw_set_parent,
> +	.enable = _clk_pll_enable,
> +	.disable = _clk_pll_disable,
> +};
> +
> +/* PLL3 SW supplies to serial clocks like USB, SSI, etc. */
> +static struct clk pll3_sw_clk = {
> +	.parent = &osc_clk,
> +	.set_rate = _clk_pll_set_rate,
> +	.get_rate = _clk_pll_recalc,
> +	.enable = _clk_pll_enable,
> +	.disable = _clk_pll_disable,
> +};
> +
> +/* Low-power Audio Playback Mode clock */
> +static struct clk lp_apm_clk = {
> +	.parent = &osc_clk,
> +	.set_parent = _clk_lp_apm_set_parent,
> +};
> +
> +static struct clk periph_apm_clk = {
> +	.parent = &pll1_sw_clk,
> +	.set_parent = _clk_periph_apm_set_parent,
> +};
> +
> +static struct clk cpu_clk = {
> +	.parent = &pll1_sw_clk,
> +	.get_rate = _clk_arm_recalc,
> +};
> +
> +static struct clk ahb_clk = {
> +	.parent = &main_bus_clk,
> +	.get_rate = _clk_ahb_recalc,
> +	.set_rate = _clk_ahb_set_rate,
> +	.round_rate = _clk_ahb_round_rate,
> +};
> +
> +/* Main IP interface clock for access to registers */
> +static struct clk ipg_clk = {
> +	.parent = &ahb_clk,
> +	.get_rate = _clk_ipg_recalc,
> +};
> +
> +static struct clk ipg_perclk = {
> +	.parent = &lp_apm_clk,
> +	.get_rate = _clk_ipg_per_recalc,
> +	.set_parent = _clk_ipg_per_set_parent,
> +};
> +
> +static struct clk uart_root_clk = {
> +	.parent = &pll2_sw_clk,
> +	.get_rate = _clk_uart_recalc,
> +	.set_parent = _clk_uart_set_parent,
> +};
> +
> +static struct clk ahb_max_clk = {
> +	.parent = &ahb_clk,
> +	.enable_reg = MXC_CCM_CCGR0,
> +	.enable_shift = MXC_CCM_CCGR0_CG14_OFFSET,
> +	.enable = _clk_max_enable,
> +	.disable = _clk_max_disable,
> +};
> +
> +static struct clk aips_tz1_clk = {
> +	.parent = &ahb_clk,
> +	.secondary = &ahb_max_clk,
> +	.enable_reg = MXC_CCM_CCGR0,
> +	.enable_shift = MXC_CCM_CCGR0_CG12_OFFSET,
> +	.enable = _clk_ccgr_enable,
> +	.disable = _clk_ccgr_disable_inwait,
> +};
> +
> +static struct clk aips_tz2_clk = {
> +	.parent = &ahb_clk,
> +	.secondary = &ahb_max_clk,
> +	.enable_reg = MXC_CCM_CCGR0,
> +	.enable_shift = MXC_CCM_CCGR0_CG13_OFFSET,
> +	.enable = _clk_ccgr_enable,
> +	.disable = _clk_ccgr_disable_inwait,
> +};
> +
> +static struct clk gpt_32k_clk = {
> +	.id = 0,
> +	.parent = &ckil_clk,
> +};
> +
> +#define DEFINE_CLOCK(name, i, er, es, gr, sr, p, s)	\
> +	static struct clk name = {			\
> +		.id		= i,			\
> +		.enable_reg	= er,			\
> +		.enable_shift	= es,			\
> +		.get_rate	= gr,			\
> +		.set_rate	= sr,			\
> +		.enable		= _clk_ccgr_enable,	\
> +		.disable	= _clk_ccgr_disable,	\
> +		.parent		= p,			\
> +		.secondary	= s,			\
> +	}
> +
> +/* DEFINE_CLOCK(name, id, enable_reg, enable_shift, get_rate, set_rate, parent, secondary); */
> +
> +/* Shared peripheral bus arbiter */
> +DEFINE_CLOCK(spba_clk, 0, MXC_CCM_CCGR5, MXC_CCM_CCGR0_CG0_OFFSET, NULL,  NULL, &ipg_clk, NULL);
> +
> +/* UART */
> +DEFINE_CLOCK(uart1_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG4_OFFSET, NULL,  NULL, &uart_root_clk, NULL);
> +DEFINE_CLOCK(uart2_clk, 1, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG6_OFFSET, NULL,  NULL, &uart_root_clk, NULL);
> +DEFINE_CLOCK(uart3_clk, 2, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG8_OFFSET, NULL,  NULL, &uart_root_clk, NULL);
> +DEFINE_CLOCK(uart1_ipg_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG3_OFFSET, NULL,  NULL, &ipg_clk, &aips_tz1_clk);
> +DEFINE_CLOCK(uart2_ipg_clk, 1, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG5_OFFSET, NULL,  NULL, &ipg_clk, &aips_tz1_clk);
> +DEFINE_CLOCK(uart3_ipg_clk, 2, MXC_CCM_CCGR1, MXC_CCM_CCGR1_CG7_OFFSET, NULL,  NULL, &ipg_clk, &spba_clk);
> +
> +/* GPT */
> +DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGR2_CG9_OFFSET, NULL,  NULL, &ipg_perclk, NULL);
> +DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGR2_CG10_OFFSET, NULL,  NULL, &ipg_clk, NULL);
> +
> +/* FEC */
> +DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGR2_CG12_OFFSET, NULL,  NULL, &ipg_clk, NULL);
> +
> +#define _REGISTER_CLOCK(d, n, c) \
> +       { \
> +		.dev_id = d, \
> +		.con_id = n,		\
> +		.clk = &c, \
> +       },
> +
> +static struct clk_lookup lookups[] __initdata = {
> +	_REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
> +	_REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
> +	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> +	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
> +	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +};
> +
> +static void clk_tree_init(void)
> +{
> +	u32 reg;
> +
> +	ipg_perclk.set_parent(&ipg_perclk, &lp_apm_clk);
> +
> +	/*
> +	 * Initialise the IPG PER CLK dividers to 3. IPG_PER_CLK should be at
> +	 * 8MHz, its derived from lp_apm.
> +	 */

Is this true for all boards? I can imagine some boards are different.

> +	reg = __raw_readl(MXC_CCM_CBCDR);
> +	reg &= ~MXC_CCM_CBCDR_PERCLK_PRED1_MASK;
> +	reg &= ~MXC_CCM_CBCDR_PERCLK_PRED2_MASK;
> +	reg &= ~MXC_CCM_CBCDR_PERCLK_PODF_MASK;
> +	reg |= (2 << MXC_CCM_CBCDR_PERCLK_PRED1_OFFSET);
> +	__raw_writel(reg, MXC_CCM_CBCDR);
> +
> +	/* set parent for pll1, pll2 and pll3 */
> +	pll1_main_clk.parent = &osc_clk;
> +	pll2_sw_clk.parent = &osc_clk;
> +	pll3_sw_clk.parent = &osc_clk;
> +
> +	/* set ipg_perclk parent */
> +	ipg_perclk.parent = &lp_apm_clk;
> +	reg = __raw_readl(MXC_CCM_CBCMR);
> +	if ((reg & MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL) != 0) {
> +		ipg_perclk.parent = &ipg_clk;
> +	} else {
> +		if ((reg & MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL) == 0)
> +			ipg_perclk.parent = &main_bus_clk;
> +	}
> +}
> +
> +int __init mx51_clocks_init(unsigned long ckil, unsigned long osc, unsigned long ckih1, unsigned long ckih2)
> +{
> +	struct clk **clkp;
> +	int i;
> +
> +	external_low_reference = ckil;
> +	external_high_reference = ckih1;
> +	ckih2_reference = ckih2;
> +	oscillator_reference = osc;
> +
> +	for (i = 0; i < ARRAY_SIZE(lookups); i++)
> +		clkdev_add(&lookups[i]);
> +
> +	clk_tree_init();
> +
> +	clk_enable(&cpu_clk);
> +	clk_enable(&main_bus_clk);
> +
> +	/* System timer */
> +	mxc_timer_init(&gpt_clk, IO_ADDRESS(GPT1_BASE_ADDR), MXC_INT_GPT);
> +	return 0;
> +}
> +
> diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
> new file mode 100644
> index 0000000..65f9e5b
> --- /dev/null
> +++ b/arch/arm/mach-mx5/cpu.c
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + */
> +
> +/*
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + *
> + * This file contains the CPU initialization code.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <mach/hardware.h>
> +#include <asm/io.h>
> +
> +static int __init post_cpu_init(void)
> +{
> +	unsigned int reg;
> +	void __iomem *base;
> +
> +	base = IO_ADDRESS(AIPS1_BASE_ADDR);
> +	__raw_writel(0x0, base + 0x40);
> +	__raw_writel(0x0, base + 0x44);
> +	__raw_writel(0x0, base + 0x48);
> +	__raw_writel(0x0, base + 0x4C);
> +	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +	__raw_writel(reg, base + 0x50);
> +
> +	base = IO_ADDRESS(AIPS2_BASE_ADDR);
> +	__raw_writel(0x0, base + 0x40);
> +	__raw_writel(0x0, base + 0x44);
> +	__raw_writel(0x0, base + 0x48);
> +	__raw_writel(0x0, base + 0x4C);
> +	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +	__raw_writel(reg, base + 0x50);
> +
> +	return 0;
> +}
> +
> +postcore_initcall(post_cpu_init);

This initcall should be protected with a cpu_is_mx51()

> diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
> new file mode 100644
> index 0000000..590e31e
> --- /dev/null
> +++ b/arch/arm/mach-mx5/crm_regs.h
> @@ -0,0 +1,685 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + */
> +
> +/*
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#ifndef __ARCH_ARM_MACH_MX51_CRM_REGS_H__
> +#define __ARCH_ARM_MACH_MX51_CRM_REGS_H__
> +
> +#define MXC_CCM_BASE	((char *)IO_ADDRESS(CCM_BASE_ADDR))
> +#define MXC_DPLL1_BASE	IO_ADDRESS(PLL1_BASE_ADDR)
> +#define MXC_DPLL2_BASE	IO_ADDRESS(PLL2_BASE_ADDR)
> +#define MXC_DPLL3_BASE	IO_ADDRESS(PLL3_BASE_ADDR)
> +
> +/* PLL Register Offsets */
> +#define MXC_PLL_DP_CTL			0x00
> +#define MXC_PLL_DP_CONFIG		0x04
> +#define MXC_PLL_DP_OP			0x08
> +#define MXC_PLL_DP_MFD			0x0C
> +#define MXC_PLL_DP_MFN			0x10
> +#define MXC_PLL_DP_MFNMINUS		0x14
> +#define MXC_PLL_DP_MFNPLUS		0x18
> +#define MXC_PLL_DP_HFS_OP		0x1C
> +#define MXC_PLL_DP_HFS_MFD		0x20
> +#define MXC_PLL_DP_HFS_MFN		0x24
> +#define MXC_PLL_DP_MFN_TOGC		0x28
> +#define MXC_PLL_DP_DESTAT		0x2c
> +
> +/* PLL Register Bit definitions */
> +#define MXC_PLL_DP_CTL_MUL_CTRL		0x2000
> +#define MXC_PLL_DP_CTL_DPDCK0_2_EN	0x1000
> +#define MXC_PLL_DP_CTL_DPDCK0_2_OFFSET	12
> +#define MXC_PLL_DP_CTL_ADE		0x800
> +#define MXC_PLL_DP_CTL_REF_CLK_DIV	0x400
> +#define MXC_PLL_DP_CTL_REF_CLK_SEL_MASK	(3 << 8)
> +#define MXC_PLL_DP_CTL_REF_CLK_SEL_OFFSET	8
> +#define MXC_PLL_DP_CTL_HFSM		0x80
> +#define MXC_PLL_DP_CTL_PRE		0x40
> +#define MXC_PLL_DP_CTL_UPEN		0x20
> +#define MXC_PLL_DP_CTL_RST		0x10
> +#define MXC_PLL_DP_CTL_RCP		0x8
> +#define MXC_PLL_DP_CTL_PLM		0x4
> +#define MXC_PLL_DP_CTL_BRM0		0x2
> +#define MXC_PLL_DP_CTL_LRF		0x1
> +
> +#define MXC_PLL_DP_CONFIG_BIST		0x8
> +#define MXC_PLL_DP_CONFIG_SJC_CE	0x4
> +#define MXC_PLL_DP_CONFIG_AREN		0x2
> +#define MXC_PLL_DP_CONFIG_LDREQ		0x1
> +
> +#define MXC_PLL_DP_OP_MFI_OFFSET	4
> +#define MXC_PLL_DP_OP_MFI_MASK		(0xF << 4)
> +#define MXC_PLL_DP_OP_PDF_OFFSET	0
> +#define MXC_PLL_DP_OP_PDF_MASK		0xF
> +
> +#define MXC_PLL_DP_MFD_OFFSET		0
> +#define MXC_PLL_DP_MFD_MASK		0x07FFFFFF
> +
> +#define MXC_PLL_DP_MFN_OFFSET		0x0
> +#define MXC_PLL_DP_MFN_MASK		0x07FFFFFF
> +
> +#define MXC_PLL_DP_MFN_TOGC_TOG_DIS	(1 << 17)
> +#define MXC_PLL_DP_MFN_TOGC_TOG_EN	(1 << 16)
> +#define MXC_PLL_DP_MFN_TOGC_CNT_OFFSET	0x0
> +#define MXC_PLL_DP_MFN_TOGC_CNT_MASK	0xFFFF
> +
> +#define MXC_PLL_DP_DESTAT_TOG_SEL	(1 << 31)
> +#define MXC_PLL_DP_DESTAT_MFN		0x07FFFFFF
> +
> +/* Register addresses of CCM*/
> +#define MXC_CCM_CCR		(MXC_CCM_BASE + 0x00)
> +#define MXC_CCM_CCDR		(MXC_CCM_BASE + 0x04)
> +#define MXC_CCM_CSR		(MXC_CCM_BASE + 0x08)
> +#define MXC_CCM_CCSR		(MXC_CCM_BASE + 0x0C)
> +#define MXC_CCM_CACRR		(MXC_CCM_BASE + 0x10)
> +#define MXC_CCM_CBCDR		(MXC_CCM_BASE + 0x14)
> +#define MXC_CCM_CBCMR		(MXC_CCM_BASE + 0x18)
> +#define MXC_CCM_CSCMR1		(MXC_CCM_BASE + 0x1C)
> +#define MXC_CCM_CSCMR2		(MXC_CCM_BASE + 0x20)
> +#define MXC_CCM_CSCDR1		(MXC_CCM_BASE + 0x24)
> +#define MXC_CCM_CS1CDR		(MXC_CCM_BASE + 0x28)
> +#define MXC_CCM_CS2CDR		(MXC_CCM_BASE + 0x2C)
> +#define MXC_CCM_CDCDR		(MXC_CCM_BASE + 0x30)
> +#define MXC_CCM_CHSCDR		(MXC_CCM_BASE + 0x34)
> +#define MXC_CCM_CSCDR2		(MXC_CCM_BASE + 0x38)
> +#define MXC_CCM_CSCDR3		(MXC_CCM_BASE + 0x3C)
> +#define MXC_CCM_CSCDR4		(MXC_CCM_BASE + 0x40)
> +#define MXC_CCM_CWDR		(MXC_CCM_BASE + 0x44)
> +#define MXC_CCM_CDHIPR		(MXC_CCM_BASE + 0x48)
> +#define MXC_CCM_CDCR		(MXC_CCM_BASE + 0x4C)
> +#define MXC_CCM_CTOR		(MXC_CCM_BASE + 0x50)
> +#define MXC_CCM_CLPCR		(MXC_CCM_BASE + 0x54)
> +#define MXC_CCM_CISR		(MXC_CCM_BASE + 0x58)
> +#define MXC_CCM_CIMR		(MXC_CCM_BASE + 0x5C)
> +#define MXC_CCM_CCOSR		(MXC_CCM_BASE + 0x60)
> +#define MXC_CCM_CGPR		(MXC_CCM_BASE + 0x64)
> +#define MXC_CCM_CCGR0		(MXC_CCM_BASE + 0x68)
> +#define MXC_CCM_CCGR1		(MXC_CCM_BASE + 0x6C)
> +#define MXC_CCM_CCGR2		(MXC_CCM_BASE + 0x70)
> +#define MXC_CCM_CCGR3		(MXC_CCM_BASE + 0x74)
> +#define MXC_CCM_CCGR4		(MXC_CCM_BASE + 0x78)
> +#define MXC_CCM_CCGR5		(MXC_CCM_BASE + 0x7C)
> +#define MXC_CCM_CCGR6		(MXC_CCM_BASE + 0x80)
> +#define MXC_CCM_CMEOR		(MXC_CCM_BASE + 0x84)
> +
> +/* Define the bits in register CCR */
> +#define MXC_CCM_CCR_COSC_EN		(1 << 12)
> +#define MXC_CCM_CCR_FPM_MULT_MASK	(1 << 11)
> +#define MXC_CCM_CCR_CAMP2_EN		(1 << 10)
> +#define MXC_CCM_CCR_CAMP1_EN		(1 << 9)
> +#define MXC_CCM_CCR_FPM_EN		(1 << 8)
> +#define MXC_CCM_CCR_OSCNT_OFFSET	(0)
> +#define MXC_CCM_CCR_OSCNT_MASK	(0xFF)
> +
> +/* Define the bits in register CCDR */
> +#define MXC_CCM_CCDR_HSC_HS_MASK	(0x1 << 18)
> +#define MXC_CCM_CCDR_IPU_HS_MASK	(0x1 << 17)
> +#define MXC_CCM_CCDR_EMI_HS_MASK	(0x1 << 16)
> +
> +/* Define the bits in register CSR */
> +#define MXC_CCM_CSR_COSR_READY	(1 << 5)
> +#define MXC_CCM_CSR_LVS_VALUE		(1 << 4)
> +#define MXC_CCM_CSR_CAMP2_READY	(1 << 3)
> +#define MXC_CCM_CSR_CAMP1_READY	(1 << 2)
> +#define MXC_CCM_CSR_FPM_READY	(1 << 1)
> +#define MXC_CCM_CSR_REF_EN_B		(1 << 0)
> +
> +/* Define the bits in register CCSR */
> +#define MXC_CCM_CCSR_LP_APM_SEL		(0x1 << 9)
> +#define MXC_CCM_CCSR_STEP_SEL_OFFSET		(7)
> +#define MXC_CCM_CCSR_STEP_SEL_MASK		(0x3 << 7)
> +#define MXC_CCM_CCSR_PLL2_PODF_OFFSET	(5)
> +#define MXC_CCM_CCSR_PLL2_PODF_MASK		(0x3 << 5)
> +#define MXC_CCM_CCSR_PLL3_PODF_OFFSET	(3)
> +#define MXC_CCM_CCSR_PLL3_PODF_MASK		(0x3 << 3)
> +#define MXC_CCM_CCSR_PLL1_SW_CLK_SEL		(1 << 2)
> +#define MXC_CCM_CCSR_PLL2_SW_CLK_SEL		(1 << 1)
> +#define MXC_CCM_CCSR_PLL3_SW_CLK_SEL		(1 << 0)
> +
> +/* Define the bits in register CACRR */
> +#define MXC_CCM_CACRR_ARM_PODF_OFFSET	(0)
> +#define MXC_CCM_CACRR_ARM_PODF_MASK		(0x7)
> +
> +/* Define the bits in register CBCDR */
> +#define MXC_CCM_CBCDR_EMI_CLK_SEL			(0x1 << 26)
> +#define MXC_CCM_CBCDR_PERIPH_CLK_SEL			(0x1 << 25)
> +#define MXC_CCM_CBCDR_DDR_HF_SEL_OFFSET		(30)
> +#define MXC_CCM_CBCDR_DDR_HF_SEL			(0x1 << 30)
> +#define MXC_CCM_CBCDR_DDR_PODF_OFFSET		(27)
> +#define MXC_CCM_CBCDR_DDR_PODF_MASK			(0x7 << 27)
> +#define MXC_CCM_CBCDR_EMI_PODF_OFFSET		(22)
> +#define MXC_CCM_CBCDR_EMI_PODF_MASK			(0x7 << 22)
> +#define MXC_CCM_CBCDR_AXI_B_PODF_OFFSET		(19)
> +#define MXC_CCM_CBCDR_AXI_B_PODF_MASK		(0x7 << 19)
> +#define MXC_CCM_CBCDR_AXI_A_PODF_OFFSET		(16)
> +#define MXC_CCM_CBCDR_AXI_A_PODF_MASK		(0x7 << 16)
> +#define MXC_CCM_CBCDR_NFC_PODF_OFFSET		(13)
> +#define MXC_CCM_CBCDR_NFC_PODF_MASK			(0x7 << 13)
> +#define MXC_CCM_CBCDR_AHB_PODF_OFFSET		(10)
> +#define MXC_CCM_CBCDR_AHB_PODF_MASK			(0x7 << 10)
> +#define MXC_CCM_CBCDR_IPG_PODF_OFFSET		(8)
> +#define MXC_CCM_CBCDR_IPG_PODF_MASK			(0x3 << 8)
> +#define MXC_CCM_CBCDR_PERCLK_PRED1_OFFSET		(6)
> +#define MXC_CCM_CBCDR_PERCLK_PRED1_MASK		(0x3 << 6)
> +#define MXC_CCM_CBCDR_PERCLK_PRED2_OFFSET		(3)
> +#define MXC_CCM_CBCDR_PERCLK_PRED2_MASK		(0x7 << 3)
> +#define MXC_CCM_CBCDR_PERCLK_PODF_OFFSET		(0)
> +#define MXC_CCM_CBCDR_PERCLK_PODF_MASK		(0x7)
> +
> +/* Define the bits in register CBCMR */
> +#define MXC_CCM_CBCMR_VPU_AXI_CLK_SEL_OFFSET	(14)
> +#define MXC_CCM_CBCMR_VPU_AXI_CLK_SEL_MASK		(0x3 << 14)
> +#define MXC_CCM_CBCMR_PERIPH_CLK_SEL_OFFSET		(12)
> +#define MXC_CCM_CBCMR_PERIPH_CLK_SEL_MASK		(0x3 << 12)
> +#define MXC_CCM_CBCMR_DDR_CLK_SEL_OFFSET		(10)
> +#define MXC_CCM_CBCMR_DDR_CLK_SEL_MASK		(0x3 << 10)
> +#define MXC_CCM_CBCMR_ARM_AXI_CLK_SEL_OFFSET	(8)
> +#define MXC_CCM_CBCMR_ARM_AXI_CLK_SEL_MASK		(0x3 << 8)
> +#define MXC_CCM_CBCMR_IPU_HSP_CLK_SEL_OFFSET	(6)
> +#define MXC_CCM_CBCMR_IPU_HSP_CLK_SEL_MASK		(0x3 << 6)
> +#define MXC_CCM_CBCMR_GPU_CLK_SEL_OFFSET		(4)
> +#define MXC_CCM_CBCMR_GPU_CLK_SEL_MASK		(0x3 << 4)
> +#define MXC_CCM_CBCMR_GPU2D_CLK_SEL_OFFSET        (14)
> +#define MXC_CCM_CBCMR_GPU2D_CLK_SEL_MASK      (0x3 << 14)
> +#define MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL		(0x1 << 1)
> +#define MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL		(0x1 << 0)
> +
> +/* Define the bits in register CSCMR1 */
> +#define MXC_CCM_CSCMR1_SSI_EXT2_CLK_SEL_OFFSET		(30)
> +#define MXC_CCM_CSCMR1_SSI_EXT2_CLK_SEL_MASK		(0x3 << 30)
> +#define MXC_CCM_CSCMR1_SSI_EXT1_CLK_SEL_OFFSET		(28)
> +#define MXC_CCM_CSCMR1_SSI_EXT1_CLK_SEL_MASK		(0x3 << 28)
> +#define MXC_CCM_CSCMR1_USB_PHY_CLK_SEL_OFFSET		(26)
> +#define MXC_CCM_CSCMR1_USB_PHY_CLK_SEL			(0x1 << 26)
> +#define MXC_CCM_CSCMR1_UART_CLK_SEL_OFFSET			(24)
> +#define MXC_CCM_CSCMR1_UART_CLK_SEL_MASK			(0x3 << 24)
> +#define MXC_CCM_CSCMR1_USBOH3_CLK_SEL_OFFSET		(22)
> +#define MXC_CCM_CSCMR1_USBOH3_CLK_SEL_MASK			(0x3 << 22)
> +#define MXC_CCM_CSCMR1_ESDHC1_MSHC1_CLK_SEL_OFFSET	(20)
> +#define MXC_CCM_CSCMR1_ESDHC1_MSHC1_CLK_SEL_MASK		(0x3 << 20)
> +#define MXC_CCM_CSCMR1_ESDHC3_CLK_SEL			(0x1 << 19)
> +#define MXC_CCM_CSCMR1_ESDHC4_CLK_SEL			(0x1 << 18)
> +#define MXC_CCM_CSCMR1_ESDHC2_MSHC2_CLK_SEL_OFFSET	(16)
> +#define MXC_CCM_CSCMR1_ESDHC2_MSHC2_CLK_SEL_MASK		(0x3 << 16)
> +#define MXC_CCM_CSCMR1_SSI1_CLK_SEL_OFFSET			(14)
> +#define MXC_CCM_CSCMR1_SSI1_CLK_SEL_MASK			(0x3 << 14)
> +#define MXC_CCM_CSCMR1_SSI2_CLK_SEL_OFFSET			(12)
> +#define MXC_CCM_CSCMR1_SSI2_CLK_SEL_MASK			(0x3 << 12)
> +#define MXC_CCM_CSCMR1_SSI3_CLK_SEL				(0x1 << 11)
> +#define MXC_CCM_CSCMR1_VPU_RCLK_SEL				(0x1 << 10)
> +#define MXC_CCM_CSCMR1_SSI_APM_CLK_SEL_OFFSET		(8)
> +#define MXC_CCM_CSCMR1_SSI_APM_CLK_SEL_MASK		(0x3 << 8)
> +#define MXC_CCM_CSCMR1_TVE_CLK_SEL				(0x1 << 7)
> +#define MXC_CCM_CSCMR1_TVE_EXT_CLK_SEL			(0x1 << 6)
> +#define MXC_CCM_CSCMR1_CSPI_CLK_SEL_OFFSET			(4)
> +#define MXC_CCM_CSCMR1_CSPI_CLK_SEL_MASK			(0x3 << 4)
> +#define MXC_CCM_CSCMR1_SPDIF_CLK_SEL_OFFSET			(2)
> +#define MXC_CCM_CSCMR1_SPDIF_CLK_SEL_MASK			(0x3 << 2)
> +#define MXC_CCM_CSCMR1_SSI_EXT2_COM_CLK_SEL			(0x1 << 1)
> +#define MXC_CCM_CSCMR1_SSI_EXT1_COM_CLK_SEL			(0x1)
> +
> +/* Define the bits in register CSCMR2 */
> +#define MXC_CCM_CSCMR2_DI_CLK_SEL_OFFSET(n)		(26+n*3)
> +#define MXC_CCM_CSCMR2_DI_CLK_SEL_MASK(n)		(0x7 << (26+n*3))
> +#define MXC_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_OFFSET	(24)
> +#define MXC_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_MASK	(0x3 << 24)
> +#define MXC_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_OFFSET	(22)
> +#define MXC_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_MASK	(0x3 << 22)
> +#define MXC_CCM_CSCMR2_ESC_CLK_SEL_OFFSET		(20)
> +#define MXC_CCM_CSCMR2_ESC_CLK_SEL_MASK		(0x3 << 20)
> +#define MXC_CCM_CSCMR2_HSC2_CLK_SEL_OFFSET		(18)
> +#define MXC_CCM_CSCMR2_HSC2_CLK_SEL_MASK		(0x3 << 18)
> +#define MXC_CCM_CSCMR2_HSC1_CLK_SEL_OFFSET		(16)
> +#define MXC_CCM_CSCMR2_HSC1_CLK_SEL_MASK		(0x3 << 16)
> +#define MXC_CCM_CSCMR2_HSI2C_CLK_SEL_OFFSET		(14)
> +#define MXC_CCM_CSCMR2_HSI2C_CLK_SEL_MASK		(0x3 << 14)
> +#define MXC_CCM_CSCMR2_FIRI_CLK_SEL_OFFSET		(12)
> +#define MXC_CCM_CSCMR2_FIRI_CLK_SEL_MASK		(0x3 << 12)
> +#define MXC_CCM_CSCMR2_SIM_CLK_SEL_OFFSET		(10)
> +#define MXC_CCM_CSCMR2_SIM_CLK_SEL_MASK		(0x3 << 10)
> +#define MXC_CCM_CSCMR2_SLIMBUS_COM			(0x1 << 9)
> +#define MXC_CCM_CSCMR2_SLIMBUS_CLK_SEL_OFFSET	(6)
> +#define MXC_CCM_CSCMR2_SLIMBUS_CLK_SEL_MASK		(0x7 << 6)
> +#define MXC_CCM_CSCMR2_SPDIF1_COM			(1 << 5)
> +#define MXC_CCM_CSCMR2_SPDIF0_COM			(1 << 4)
> +#define MXC_CCM_CSCMR2_SPDIF1_CLK_SEL_OFFSET	(2)
> +#define MXC_CCM_CSCMR2_SPDIF1_CLK_SEL_MASK		(0x3 << 2)
> +#define MXC_CCM_CSCMR2_SPDIF0_CLK_SEL_OFFSET	(0)
> +#define MXC_CCM_CSCMR2_SPDIF0_CLK_SEL_MASK		(0x3)
> +
> +/* Define the bits in register CSCDR1 */
> +#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PRED_OFFSET	(22)
> +#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PRED_MASK		(0x7 << 22)
> +#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PODF_OFFSET	(19)
> +#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PODF_MASK		(0x7 << 19)
> +#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PRED_OFFSET	(16)
> +#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PRED_MASK		(0x7 << 16)
> +#define MXC_CCM_CSCDR1_PGC_CLK_PODF_OFFSET			(14)
> +#define MXC_CCM_CSCDR1_PGC_CLK_PODF_MASK			(0x3 << 14)
> +#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PODF_OFFSET	(11)
> +#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PODF_MASK		(0x7 << 11)
> +#define MXC_CCM_CSCDR1_USBOH3_CLK_PRED_OFFSET		(8)
> +#define MXC_CCM_CSCDR1_USBOH3_CLK_PRED_MASK		(0x7 << 8)
> +#define MXC_CCM_CSCDR1_USBOH3_CLK_PODF_OFFSET		(6)
> +#define MXC_CCM_CSCDR1_USBOH3_CLK_PODF_MASK		(0x3 << 6)
> +#define MXC_CCM_CSCDR1_UART_CLK_PRED_OFFSET		(3)
> +#define MXC_CCM_CSCDR1_UART_CLK_PRED_MASK			(0x7 << 3)
> +#define MXC_CCM_CSCDR1_UART_CLK_PODF_OFFSET		(0)
> +#define MXC_CCM_CSCDR1_UART_CLK_PODF_MASK			(0x7)
> +
> +/* Define the bits in register CS1CDR and CS2CDR */
> +#define MXC_CCM_CS1CDR_SSI_EXT1_CLK_PRED_OFFSET	(22)
> +#define MXC_CCM_CS1CDR_SSI_EXT1_CLK_PRED_MASK	(0x7 << 22)
> +#define MXC_CCM_CS1CDR_SSI_EXT1_CLK_PODF_OFFSET	(16)
> +#define MXC_CCM_CS1CDR_SSI_EXT1_CLK_PODF_MASK	(0x3F << 16)
> +#define MXC_CCM_CS1CDR_SSI1_CLK_PRED_OFFSET		(6)
> +#define MXC_CCM_CS1CDR_SSI1_CLK_PRED_MASK		(0x7 << 6)
> +#define MXC_CCM_CS1CDR_SSI1_CLK_PODF_OFFSET		(0)
> +#define MXC_CCM_CS1CDR_SSI1_CLK_PODF_MASK		(0x3F)
> +
> +#define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PRED_OFFSET	(22)
> +#define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PRED_MASK	(0x7 << 22)
> +#define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PODF_OFFSET	(16)
> +#define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PODF_MASK	(0x3F << 16)
> +#define MXC_CCM_CS2CDR_SSI2_CLK_PRED_OFFSET		(6)
> +#define MXC_CCM_CS2CDR_SSI2_CLK_PRED_MASK		(0x7 << 6)
> +#define MXC_CCM_CS2CDR_SSI2_CLK_PODF_OFFSET		(0)
> +#define MXC_CCM_CS2CDR_SSI2_CLK_PODF_MASK		(0x3F)
> +
> +/* Define the bits in register CDCDR */
> +#define MXC_CCM_CDCDR_TVE_CLK_PRED_OFFSET		(28)
> +#define MXC_CCM_CDCDR_TVE_CLK_PRED_MASK		(0x7 << 28)
> +#define MXC_CCM_CDCDR_SPDIF0_CLK_PRED_OFFSET	(25)
> +#define MXC_CCM_CDCDR_SPDIF0_CLK_PRED_MASK		(0x7 << 25)
> +#define MXC_CCM_CDCDR_SPDIF0_CLK_PODF_OFFSET	(19)
> +#define MXC_CCM_CDCDR_SPDIF0_CLK_PODF_MASK		(0x3F << 19)
> +#define MXC_CCM_CDCDR_SPDIF1_CLK_PRED_OFFSET	(16)
> +#define MXC_CCM_CDCDR_SPDIF1_CLK_PRED_MASK		(0x7 << 16)
> +#define MXC_CCM_CDCDR_SPDIF1_CLK_PODF_OFFSET	(9)
> +#define MXC_CCM_CDCDR_SPDIF1_CLK_PODF_MASK		(0x3F << 9)
> +#define MXC_CCM_CDCDR_DI_CLK_PRED_OFFSET		(6)
> +#define MXC_CCM_CDCDR_DI_CLK_PRED_MASK		(0x7 << 6)
> +#define MXC_CCM_CDCDR_USB_PHY_PRED_OFFSET		(3)
> +#define MXC_CCM_CDCDR_USB_PHY_PRED_MASK		(0x7 << 3)
> +#define MXC_CCM_CDCDR_USB_PHY_PODF_OFFSET		(0)
> +#define MXC_CCM_CDCDR_USB_PHY_PODF_MASK		(0x7)
> +
> +/* Define the bits in register CHSCCDR */
> +#define MXC_CCM_CHSCCDR_ESC_CLK_PRED_OFFSET		(12)
> +#define MXC_CCM_CHSCCDR_ESC_CLK_PRED_MASK		(0x7 << 12)
> +#define MXC_CCM_CHSCCDR_ESC_CLK_PODF_OFFSET	(6)
> +#define MXC_CCM_CHSCCDR_ESC_CLK_PODF_MASK		(0x3F << 6)
> +#define MXC_CCM_CHSCCDR_HSC2_CLK_PODF_OFFSET	(3)
> +#define MXC_CCM_CHSCCDR_HSC2_CLK_PODF_MASK		(0x7 << 3)
> +#define MXC_CCM_CHSCCDR_HSC1_CLK_PODF_OFFSET	(0)
> +#define MXC_CCM_CHSCCDR_HSC1_CLK_PODF_MASK		(0x7)
> +
> +/* Define the bits in register CSCDR2 */
> +#define MXC_CCM_CSCDR2_CSPI_CLK_PRED_OFFSET		(25)
> +#define MXC_CCM_CSCDR2_CSPI_CLK_PRED_MASK		(0x7 << 25)
> +#define MXC_CCM_CSCDR2_CSPI_CLK_PODF_OFFSET		(19)
> +#define MXC_CCM_CSCDR2_CSPI_CLK_PODF_MASK		(0x3F << 19)
> +#define MXC_CCM_CSCDR2_SIM_CLK_PRED_OFFSET		(16)
> +#define MXC_CCM_CSCDR2_SIM_CLK_PRED_MASK		(0x7 << 16)
> +#define MXC_CCM_CSCDR2_SIM_CLK_PODF_OFFSET		(9)
> +#define MXC_CCM_CSCDR2_SIM_CLK_PODF_MASK		(0x3F << 9)
> +#define MXC_CCM_CSCDR2_SLIMBUS_CLK_PRED_OFFSET	(6)
> +#define MXC_CCM_CSCDR2_SLIMBUS_PRED_MASK		(0x7 << 6)
> +#define MXC_CCM_CSCDR2_SLIMBUS_PODF_OFFSET		(0)
> +#define MXC_CCM_CSCDR2_SLIMBUS_PODF_MASK		(0x3F)
> +
> +/* Define the bits in register CSCDR3 */
> +#define MXC_CCM_CSCDR3_HSI2C_CLK_PRED_OFFSET	(16)
> +#define MXC_CCM_CSCDR3_HSI2C_CLK_PRED_MASK		(0x7 << 16)
> +#define MXC_CCM_CSCDR3_HSI2C_CLK_PODF_OFFSET	(9)
> +#define MXC_CCM_CSCDR3_HSI2C_CLK_PODF_MASK		(0x3F << 9)
> +#define MXC_CCM_CSCDR3_FIRI_CLK_PRED_OFFSET		(6)
> +#define MXC_CCM_CSCDR3_FIRI_CLK_PRED_MASK		(0x7 << 6)
> +#define MXC_CCM_CSCDR3_FIRI_CLK_PODF_OFFSET		(0)
> +#define MXC_CCM_CSCDR3_FIRI_CLK_PODF_MASK		(0x3F)
> +
> +/* Define the bits in register CSCDR4 */
> +#define MXC_CCM_CSCDR4_CSI_MCLK2_CLK_PRED_OFFSET	(16)
> +#define MXC_CCM_CSCDR4_CSI_MCLK2_CLK_PRED_MASK	(0x7 << 16)
> +#define MXC_CCM_CSCDR4_CSI_MCLK2_CLK_PODF_OFFSET	(9)
> +#define MXC_CCM_CSCDR4_CSI_MCLK2_CLK_PODF_MASK	(0x3F << 9)
> +#define MXC_CCM_CSCDR4_CSI_MCLK1_CLK_PRED_OFFSET	(6)
> +#define MXC_CCM_CSCDR4_CSI_MCLK1_CLK_PRED_MASK	(0x7 << 6)
> +#define MXC_CCM_CSCDR4_CSI_MCLK1_CLK_PODF_OFFSET	(0)
> +#define MXC_CCM_CSCDR4_CSI_MCLK1_CLK_PODF_MASK	(0x3F)
> +
> +/* Define the bits in register CDHIPR */
> +#define MXC_CCM_CDHIPR_ARM_PODF_BUSY			(1 << 16)
> +#define MXC_CCM_CDHIPR_DDR_HF_CLK_SEL_BUSY		(1 << 8)
> +#define MXC_CCM_CDHIPR_DDR_PODF_BUSY			(1 << 7)
> +#define MXC_CCM_CDHIPR_EMI_CLK_SEL_BUSY			(1 << 6)
> +#define MXC_CCM_CDHIPR_PERIPH_CLK_SEL_BUSY		(1 << 5)
> +#define MXC_CCM_CDHIPR_NFC_IPG_INT_MEM_PODF_BUSY	(1 << 4)
> +#define MXC_CCM_CDHIPR_AHB_PODF_BUSY			(1 << 3)
> +#define MXC_CCM_CDHIPR_EMI_PODF_BUSY			(1 << 2)
> +#define MXC_CCM_CDHIPR_AXI_B_PODF_BUSY			(1 << 1)
> +#define MXC_CCM_CDHIPR_AXI_A_PODF_BUSY			(1 << 0)
> +
> +/* Define the bits in register CDCR */
> +#define MXC_CCM_CDCR_ARM_FREQ_SHIFT_DIVIDER			(0x1 << 2)
> +#define MXC_CCM_CDCR_PERIPH_CLK_DVFS_PODF_OFFSET		(0)
> +#define MXC_CCM_CDCR_PERIPH_CLK_DVFS_PODF_MASK		(0x3)
> +
> +/* Define the bits in register CLPCR */
> +#define MXC_CCM_CLPCR_BYPASS_HSC_LPM_HS		(0x1 << 23)
> +#define MXC_CCM_CLPCR_BYPASS_SCC_LPM_HS		(0x1 << 22)
> +#define MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS		(0x1 << 21)
> +#define MXC_CCM_CLPCR_BYPASS_SDMA_LPM_HS		(0x1 << 20)
> +#define MXC_CCM_CLPCR_BYPASS_EMI_LPM_HS		(0x1 << 19)
> +#define MXC_CCM_CLPCR_BYPASS_IPU_LPM_HS		(0x1 << 18)
> +#define MXC_CCM_CLPCR_BYPASS_RTIC_LPM_HS		(0x1 << 17)
> +#define MXC_CCM_CLPCR_BYPASS_RNGC_LPM_HS		(0x1 << 16)
> +#define MXC_CCM_CLPCR_COSC_PWRDOWN			(0x1 << 11)
> +#define MXC_CCM_CLPCR_STBY_COUNT_OFFSET		(9)
> +#define MXC_CCM_CLPCR_STBY_COUNT_MASK		(0x3 << 9)
> +#define MXC_CCM_CLPCR_VSTBY				(0x1 << 8)
> +#define MXC_CCM_CLPCR_DIS_REF_OSC			(0x1 << 7)
> +#define MXC_CCM_CLPCR_SBYOS				(0x1 << 6)
> +#define MXC_CCM_CLPCR_ARM_CLK_DIS_ON_LPM		(0x1 << 5)
> +#define MXC_CCM_CLPCR_LPSR_CLK_SEL_OFFSET		(3)
> +#define MXC_CCM_CLPCR_LPSR_CLK_SEL_MASK		(0x3 << 3)
> +#define MXC_CCM_CLPCR_LPM_OFFSET			(0)
> +#define MXC_CCM_CLPCR_LPM_MASK			(0x3)
> +
> +/* Define the bits in register CISR */
> +#define MXC_CCM_CISR_ARM_PODF_LOADED			(0x1 << 25)
> +#define MXC_CCM_CISR_NFC_IPG_INT_MEM_PODF_LOADED		(0x1 << 21)
> +#define MXC_CCM_CISR_AHB_PODF_LOADED			(0x1 << 20)
> +#define MXC_CCM_CISR_EMI_PODF_LOADED				(0x1 << 19)
> +#define MXC_CCM_CISR_AXI_B_PODF_LOADED			(0x1 << 18)
> +#define MXC_CCM_CISR_AXI_A_PODF_LOADED			(0x1 << 17)
> +#define MXC_CCM_CISR_DIVIDER_LOADED				(0x1 << 16)
> +#define MXC_CCM_CISR_COSC_READY				(0x1 << 6)
> +#define MXC_CCM_CISR_CKIH2_READY				(0x1 << 5)
> +#define MXC_CCM_CISR_CKIH_READY				(0x1 << 4)
> +#define MXC_CCM_CISR_FPM_READY				(0x1 << 3)
> +#define MXC_CCM_CISR_LRF_PLL3					(0x1 << 2)
> +#define MXC_CCM_CISR_LRF_PLL2					(0x1 << 1)
> +#define MXC_CCM_CISR_LRF_PLL1					(0x1)
> +
> +/* Define the bits in register CIMR */
> +#define MXC_CCM_CIMR_MASK_ARM_PODF_LOADED		(0x1 << 25)
> +#define MXC_CCM_CIMR_MASK_NFC_IPG_INT_MEM_PODF_LOADED	(0x1 << 21)
> +#define MXC_CCM_CIMR_MASK_EMI_PODF_LOADED		(0x1 << 20)
> +#define MXC_CCM_CIMR_MASK_AXI_C_PODF_LOADED		(0x1 << 19)
> +#define MXC_CCM_CIMR_MASK_AXI_B_PODF_LOADED		(0x1 << 18)
> +#define MXC_CCM_CIMR_MASK_AXI_A_PODF_LOADED		(0x1 << 17)
> +#define MXC_CCM_CIMR_MASK_DIVIDER_LOADED		(0x1 << 16)
> +#define MXC_CCM_CIMR_MASK_COSC_READY			(0x1 << 5)
> +#define MXC_CCM_CIMR_MASK_CKIH_READY			(0x1 << 4)
> +#define MXC_CCM_CIMR_MASK_FPM_READY			(0x1 << 3)
> +#define MXC_CCM_CIMR_MASK_LRF_PLL3			(0x1 << 2)
> +#define MXC_CCM_CIMR_MASK_LRF_PLL2			(0x1 << 1)
> +#define MXC_CCM_CIMR_MASK_LRF_PLL1			(0x1)
> +
> +/* Define the bits in register CCOSR */
> +#define MXC_CCM_CCOSR_CKO2_EN_OFFSET			(0x1 << 24)
> +#define MXC_CCM_CCOSR_CKO2_DIV_OFFSET			(21)
> +#define MXC_CCM_CCOSR_CKO2_DIV_MASK			(0x7 << 21)
> +#define MXC_CCM_CCOSR_CKO2_SEL_OFFSET			(16)
> +#define MXC_CCM_CCOSR_CKO2_SEL_MASK			(0x1F << 16)
> +#define MXC_CCM_CCOSR_CKOL_EN				(0x1 << 7)
> +#define MXC_CCM_CCOSR_CKOL_DIV_OFFSET			(4)
> +#define MXC_CCM_CCOSR_CKOL_DIV_MASK			(0x7 << 4)
> +#define MXC_CCM_CCOSR_CKOL_SEL_OFFSET			(0)
> +#define MXC_CCM_CCOSR_CKOL_SEL_MASK			(0xF)
> +
> +/* Define the bits in registers CGPR */
> +#define MXC_CCM_CGPR_EFUSE_PROG_SUPPLY_GATE		(0x1 << 4)
> +#define MXC_CCM_CGPR_FPM_SEL				(0x1 << 3)
> +#define MXC_CCM_CGPR_VL_L2BIST_CLKDIV_OFFSET		(0)
> +#define MXC_CCM_CGPR_VL_L2BIST_CLKDIV_MASK		(0x7)
> +
> +/* Define the bits in registers CCGRx */
> +#define MXC_CCM_CCGR_CG_MASK				0x3
> +#define MXC_CCM_CCGR_MOD_OFF				0x0
> +#define MXC_CCM_CCGR_MOD_ON				0x3
> +#define MXC_CCM_CCGR_MOD_IDLE				0x1
> +
> +#define MXC_CCM_CCGR0_CG15_OFFSET			30
> +#define MXC_CCM_CCGR0_CG15_MASK			(0x3 << 30)
> +#define MXC_CCM_CCGR0_CG14_OFFSET			28
> +#define MXC_CCM_CCGR0_CG14_MASK			(0x3 << 28)
> +#define MXC_CCM_CCGR0_CG13_OFFSET			26
> +#define MXC_CCM_CCGR0_CG13_MASK			(0x3 << 26)
> +#define MXC_CCM_CCGR0_CG12_OFFSET			24
> +#define MXC_CCM_CCGR0_CG12_MASK			(0x3 << 24)
> +#define MXC_CCM_CCGR0_CG11_OFFSET			22
> +#define MXC_CCM_CCGR0_CG11_MASK			(0x3 << 22)
> +#define MXC_CCM_CCGR0_CG10_OFFSET			20
> +#define MXC_CCM_CCGR0_CG10_MASK			(0x3 << 20)
> +#define MXC_CCM_CCGR0_CG9_OFFSET			18
> +#define MXC_CCM_CCGR0_CG9_MASK			(0x3 << 18)
> +#define MXC_CCM_CCGR0_CG8_OFFSET			16
> +#define MXC_CCM_CCGR0_CG8_MASK			(0x3 << 16)
> +#define MXC_CCM_CCGR0_CG7_OFFSET			14
> +#define MXC_CCM_CCGR0_CG6_OFFSET			12
> +#define MXC_CCM_CCGR0_CG5_OFFSET			10
> +#define MXC_CCM_CCGR0_CG5_MASK			(0x3 << 10)
> +#define MXC_CCM_CCGR0_CG4_OFFSET			8
> +#define MXC_CCM_CCGR0_CG4_MASK			(0x3 << 8)
> +#define MXC_CCM_CCGR0_CG3_OFFSET			6
> +#define MXC_CCM_CCGR0_CG3_MASK			(0x3 << 6)
> +#define MXC_CCM_CCGR0_CG2_OFFSET			4
> +#define MXC_CCM_CCGR0_CG2_MASK			(0x3 << 4)
> +#define MXC_CCM_CCGR0_CG1_OFFSET			2
> +#define MXC_CCM_CCGR0_CG1_MASK			(0x3 << 2)
> +#define MXC_CCM_CCGR0_CG0_OFFSET			0
> +#define MXC_CCM_CCGR0_CG0_MASK			0x3
> +
> +#define MXC_CCM_CCGR1_CG15_OFFSET			30
> +#define MXC_CCM_CCGR1_CG14_OFFSET			28
> +#define MXC_CCM_CCGR1_CG13_OFFSET			26
> +#define MXC_CCM_CCGR1_CG12_OFFSET			24
> +#define MXC_CCM_CCGR1_CG11_OFFSET			22
> +#define MXC_CCM_CCGR1_CG10_OFFSET			20
> +#define MXC_CCM_CCGR1_CG9_OFFSET			18
> +#define MXC_CCM_CCGR1_CG8_OFFSET			16
> +#define MXC_CCM_CCGR1_CG7_OFFSET			14
> +#define MXC_CCM_CCGR1_CG6_OFFSET			12
> +#define MXC_CCM_CCGR1_CG5_OFFSET			10
> +#define MXC_CCM_CCGR1_CG4_OFFSET			8
> +#define MXC_CCM_CCGR1_CG3_OFFSET			6
> +#define MXC_CCM_CCGR1_CG2_OFFSET			4
> +#define MXC_CCM_CCGR1_CG1_OFFSET			2
> +#define MXC_CCM_CCGR1_CG0_OFFSET			0
> +
> +#define MXC_CCM_CCGR2_CG15_OFFSET			30
> +#define MXC_CCM_CCGR2_CG14_OFFSET			28
> +#define MXC_CCM_CCGR2_CG13_OFFSET			26
> +#define MXC_CCM_CCGR2_CG12_OFFSET			24
> +#define MXC_CCM_CCGR2_CG11_OFFSET			22
> +#define MXC_CCM_CCGR2_CG10_OFFSET			20
> +#define MXC_CCM_CCGR2_CG9_OFFSET			18
> +#define MXC_CCM_CCGR2_CG8_OFFSET			16
> +#define MXC_CCM_CCGR2_CG7_OFFSET			14
> +#define MXC_CCM_CCGR2_CG6_OFFSET			12
> +#define MXC_CCM_CCGR2_CG5_OFFSET			10
> +#define MXC_CCM_CCGR2_CG4_OFFSET			8
> +#define MXC_CCM_CCGR2_CG3_OFFSET			6
> +#define MXC_CCM_CCGR2_CG2_OFFSET			4
> +#define MXC_CCM_CCGR2_CG1_OFFSET			2
> +#define MXC_CCM_CCGR2_CG0_OFFSET			0
> +
> +#define MXC_CCM_CCGR3_CG15_OFFSET			30
> +#define MXC_CCM_CCGR3_CG14_OFFSET			28
> +#define MXC_CCM_CCGR3_CG13_OFFSET			26
> +#define MXC_CCM_CCGR3_CG12_OFFSET			24
> +#define MXC_CCM_CCGR3_CG11_OFFSET			22
> +#define MXC_CCM_CCGR3_CG10_OFFSET			20
> +#define MXC_CCM_CCGR3_CG9_OFFSET			18
> +#define MXC_CCM_CCGR3_CG8_OFFSET			16
> +#define MXC_CCM_CCGR3_CG7_OFFSET			14
> +#define MXC_CCM_CCGR3_CG6_OFFSET			12
> +#define MXC_CCM_CCGR3_CG5_OFFSET			10
> +#define MXC_CCM_CCGR3_CG4_OFFSET			8
> +#define MXC_CCM_CCGR3_CG3_OFFSET			6
> +#define MXC_CCM_CCGR3_CG2_OFFSET			4
> +#define MXC_CCM_CCGR3_CG1_OFFSET			2
> +#define MXC_CCM_CCGR3_CG0_OFFSET			0
> +
> +#define MXC_CCM_CCGR4_CG15_OFFSET			30
> +#define MXC_CCM_CCGR4_CG14_OFFSET			28
> +#define MXC_CCM_CCGR4_CG13_OFFSET			26
> +#define MXC_CCM_CCGR4_CG12_OFFSET			24
> +#define MXC_CCM_CCGR4_CG11_OFFSET			22
> +#define MXC_CCM_CCGR4_CG10_OFFSET			20
> +#define MXC_CCM_CCGR4_CG9_OFFSET			18
> +#define MXC_CCM_CCGR4_CG8_OFFSET			16
> +#define MXC_CCM_CCGR4_CG7_OFFSET			14
> +#define MXC_CCM_CCGR4_CG6_OFFSET			12
> +#define MXC_CCM_CCGR4_CG5_OFFSET			10
> +#define MXC_CCM_CCGR4_CG4_OFFSET			8
> +#define MXC_CCM_CCGR4_CG3_OFFSET			6
> +#define MXC_CCM_CCGR4_CG2_OFFSET			4
> +#define MXC_CCM_CCGR4_CG1_OFFSET			2
> +#define MXC_CCM_CCGR4_CG0_OFFSET			0
> +
> +#define MXC_CCM_CCGR5_CG15_OFFSET			30
> +#define MXC_CCM_CCGR5_CG14_OFFSET			28
> +#define MXC_CCM_CCGR5_CG14_MASK			(0x3 << 28)
> +#define MXC_CCM_CCGR5_CG13_OFFSET			26
> +#define MXC_CCM_CCGR5_CG13_MASK			(0x3 << 26)
> +#define MXC_CCM_CCGR5_CG12_OFFSET			24
> +#define MXC_CCM_CCGR5_CG12_MASK			(0x3 << 24)
> +#define MXC_CCM_CCGR5_CG11_OFFSET			22
> +#define MXC_CCM_CCGR5_CG11_MASK			(0x3 << 22)
> +#define MXC_CCM_CCGR5_CG10_OFFSET			20
> +#define MXC_CCM_CCGR5_CG10_MASK			(0x3 << 20)
> +#define MXC_CCM_CCGR5_CG9_OFFSET			18
> +#define MXC_CCM_CCGR5_CG9_MASK			(0x3 << 18)
> +#define MXC_CCM_CCGR5_CG8_OFFSET			16
> +#define MXC_CCM_CCGR5_CG8_MASK			(0x3 << 16)
> +#define MXC_CCM_CCGR5_CG7_OFFSET			14
> +#define MXC_CCM_CCGR5_CG7_MASK			(0x3 << 14)
> +#define MXC_CCM_CCGR5_CG6_OFFSET			12
> +#define MXC_CCM_CCGR5_CG5_OFFSET			10
> +#define MXC_CCM_CCGR5_CG4_OFFSET			8
> +#define MXC_CCM_CCGR5_CG3_OFFSET			6
> +#define MXC_CCM_CCGR5_CG2_OFFSET			4
> +#define MXC_CCM_CCGR5_CG2_MASK			(0x3 << 4)
> +#define MXC_CCM_CCGR5_CG1_OFFSET			2
> +#define MXC_CCM_CCGR5_CG0_OFFSET			0
> +#define MXC_CCM_CCGR6_CG7_OFFSET            14
> +#define MXC_CCM_CCGR6_CG7_MASK          (0x3 << 14)
> +#define MXC_CCM_CCGR6_CG6_OFFSET			12
> +#define MXC_CCM_CCGR6_CG6_MASK			(0x3 << 12)
> +#define MXC_CCM_CCGR6_CG5_OFFSET			10
> +#define MXC_CCM_CCGR6_CG5_MASK			(0x3 << 10)
> +#define MXC_CCM_CCGR6_CG4_OFFSET			8
> +#define MXC_CCM_CCGR6_CG4_MASK			(0x3 << 8)
> +#define MXC_CCM_CCGR6_CG3_OFFSET			6
> +#define MXC_CCM_CCGR6_CG2_OFFSET			4
> +#define MXC_CCM_CCGR6_CG1_OFFSET			2
> +#define MXC_CCM_CCGR6_CG0_OFFSET			0
> +
> +#define MXC_CORTEXA8_BASE	IO_ADDRESS(ARM_BASE_ADDR)
> +#define MXC_GPC_BASE		IO_ADDRESS(GPC_BASE_ADDR)
> +#define MXC_DPTC_LP_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x80)
> +#define MXC_DPTC_GP_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x100)
> +#define MXC_DVFS_CORE_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x180)
> +#define MXC_DPTC_PER_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x1C0)
> +#define MXC_PGC_IPU_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x220)
> +#define MXC_PGC_VPU_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x240)
> +#define MXC_PGC_GPU_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x260)
> +#define MXC_SRPG_NEON_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x280)
> +#define MXC_SRPG_ARM_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x2A0)
> +#define MXC_SRPG_EMPGC0_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x2C0)
> +#define MXC_SRPG_EMPGC1_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x2D0)
> +#define MXC_SRPG_MEGAMIX_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x2E0)
> +#define MXC_SRPG_EMI_BASE	IO_ADDRESS(GPC_BASE_ADDR + 0x300)
> +
> +/* CORTEXA8 platform */
> +#define MXC_CORTEXA8_PLAT_PVID		(MXC_CORTEXA8_BASE + 0x0)
> +#define MXC_CORTEXA8_PLAT_GPC		(MXC_CORTEXA8_BASE + 0x4)
> +#define MXC_CORTEXA8_PLAT_PIC		(MXC_CORTEXA8_BASE + 0x8)
> +#define MXC_CORTEXA8_PLAT_LPC		(MXC_CORTEXA8_BASE + 0xC)
> +#define MXC_CORTEXA8_PLAT_NEON_LPC	(MXC_CORTEXA8_BASE + 0x10)
> +#define MXC_CORTEXA8_PLAT_ICGC		(MXC_CORTEXA8_BASE + 0x14)
> +#define MXC_CORTEXA8_PLAT_AMC		(MXC_CORTEXA8_BASE + 0x18)
> +#define MXC_CORTEXA8_PLAT_NMC		(MXC_CORTEXA8_BASE + 0x20)
> +#define MXC_CORTEXA8_PLAT_NMS		(MXC_CORTEXA8_BASE + 0x24)
> +
> +/* DVFS CORE */
> +#define MXC_DVFSTHRS		(MXC_DVFS_CORE_BASE + 0x00)
> +#define MXC_DVFSCOUN		(MXC_DVFS_CORE_BASE + 0x04)
> +#define MXC_DVFSSIG1		(MXC_DVFS_CORE_BASE + 0x08)
> +#define MXC_DVFSSIG0		(MXC_DVFS_CORE_BASE + 0x0C)
> +#define MXC_DVFSGPC0		(MXC_DVFS_CORE_BASE + 0x10)
> +#define MXC_DVFSGPC1		(MXC_DVFS_CORE_BASE + 0x14)
> +#define MXC_DVFSGPBT		(MXC_DVFS_CORE_BASE + 0x18)
> +#define MXC_DVFSEMAC		(MXC_DVFS_CORE_BASE + 0x1C)
> +#define MXC_DVFSCNTR		(MXC_DVFS_CORE_BASE + 0x20)
> +#define MXC_DVFSLTR0_0		(MXC_DVFS_CORE_BASE + 0x24)
> +#define MXC_DVFSLTR0_1		(MXC_DVFS_CORE_BASE + 0x28)
> +#define MXC_DVFSLTR1_0		(MXC_DVFS_CORE_BASE + 0x2C)
> +#define MXC_DVFSLTR1_1		(MXC_DVFS_CORE_BASE + 0x30)
> +#define MXC_DVFSPT0 		(MXC_DVFS_CORE_BASE + 0x34)
> +#define MXC_DVFSPT1 		(MXC_DVFS_CORE_BASE + 0x38)
> +#define MXC_DVFSPT2 		(MXC_DVFS_CORE_BASE + 0x3C)
> +#define MXC_DVFSPT3 		(MXC_DVFS_CORE_BASE + 0x40)
> +
> +/* GPC */
> +#define MXC_GPC_CNTR		(MXC_GPC_BASE + 0x0)
> +#define MXC_GPC_PGR		(MXC_GPC_BASE + 0x4)
> +#define MXC_GPC_VCR		(MXC_GPC_BASE + 0x8)
> +#define MXC_GPC_ALL_PU		(MXC_GPC_BASE + 0xC)
> +#define MXC_GPC_NEON		(MXC_GPC_BASE + 0x10)
> +#define MXC_GPC_PGR_ARMPG_OFFSET	8
> +#define MXC_GPC_PGR_ARMPG_MASK		(3 << 8)
> +
> +/* PGC */
> +#define MXC_PGC_IPU_PGCR	(MXC_PGC_IPU_BASE + 0x0)
> +#define MXC_PGC_IPU_PGSR	(MXC_PGC_IPU_BASE + 0xC)
> +#define MXC_PGC_VPU_PGCR	(MXC_PGC_VPU_BASE + 0x0)
> +#define MXC_PGC_VPU_PGSR	(MXC_PGC_VPU_BASE + 0xC)
> +#define MXC_PGC_GPU_PGCR	(MXC_PGC_GPU_BASE + 0x0)
> +#define MXC_PGC_GPU_PGSR	(MXC_PGC_GPU_BASE + 0xC)
> +
> +#define MXC_PGCR_PCR		1
> +#define MXC_SRPGCR_PCR		1
> +#define MXC_EMPGCR_PCR		1
> +#define MXC_PGSR_PSR		1
> +
> +
> +#define MXC_CORTEXA8_PLAT_LPC_DSM	(1 << 0)
> +#define MXC_CORTEXA8_PLAT_LPC_DBG_DSM	(1 << 1)
> +
> +/* SRPG */
> +#define MXC_SRPG_NEON_SRPGCR	(MXC_SRPG_NEON_BASE + 0x0)
> +#define MXC_SRPG_NEON_PUPSCR	(MXC_SRPG_NEON_BASE + 0x4)
> +#define MXC_SRPG_NEON_PDNSCR	(MXC_SRPG_NEON_BASE + 0x8)
> +
> +#define MXC_SRPG_ARM_SRPGCR	(MXC_SRPG_ARM_BASE + 0x0)
> +#define MXC_SRPG_ARM_PUPSCR	(MXC_SRPG_ARM_BASE + 0x4)
> +#define MXC_SRPG_ARM_PDNSCR	(MXC_SRPG_ARM_BASE + 0x8)
> +
> +#define MXC_SRPG_EMPGC0_SRPGCR	(MXC_SRPG_EMPGC0_BASE + 0x0)
> +#define MXC_SRPG_EMPGC0_PUPSCR	(MXC_SRPG_EMPGC0_BASE + 0x4)
> +#define MXC_SRPG_EMPGC0_PDNSCR	(MXC_SRPG_EMPGC0_BASE + 0x8)
> +
> +#define MXC_SRPG_EMPGC1_SRPGCR	(MXC_SRPG_EMPGC1_BASE + 0x0)
> +#define MXC_SRPG_EMPGC1_PUPSCR	(MXC_SRPG_EMPGC1_BASE + 0x4)
> +#define MXC_SRPG_EMPGC1_PDNSCR	(MXC_SRPG_EMPGC1_BASE + 0x8)
> +
> +#define MXC_SRPG_MEGAMIX_SRPGCR		(MXC_SRPG_MEGAMIX_BASE + 0x0)
> +#define MXC_SRPG_MEGAMIX_PUPSCR		(MXC_SRPG_MEGAMIX_BASE + 0x4)
> +#define MXC_SRPG_MEGAMIX_PDNSCR		(MXC_SRPG_MEGAMIX_BASE + 0x8)
> +
> +#define MXC_SRPGC_EMI_SRPGCR	(MXC_SRPGC_EMI_BASE + 0x0)
> +#define MXC_SRPGC_EMI_PUPSCR	(MXC_SRPGC_EMI_BASE + 0x4)
> +#define MXC_SRPGC_EMI_PDNSCR	(MXC_SRPGC_EMI_BASE + 0x8)
> +
> +#endif				/* __ARCH_ARM_MACH_MX51_CRM_REGS_H__ */
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> new file mode 100644
> index 0000000..51e6e7b
> --- /dev/null
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -0,0 +1,90 @@
> +/*
> + * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/platform_device.h>
> +#include <mach/hardware.h>
> +#include <mach/imx-uart.h>
> +
> +static struct resource uart0[] = {
> +	{
> +		.start = UART1_BASE_ADDR,
> +		.end = UART1_BASE_ADDR + 0x0B5,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MXC_INT_UART1,
> +		.end = MXC_INT_UART1,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_uart_device0 = {
> +	.name = "imx-uart",
> +	.id = 0,
> +	.resource = uart0,
> +	.num_resources = ARRAY_SIZE(uart0),
> +};
> +
> +static struct resource uart1[] = {
> +	{
> +		.start = UART2_BASE_ADDR,
> +		.end = UART2_BASE_ADDR + 0x0B5,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MXC_INT_UART2,
> +		.end = MXC_INT_UART2,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_uart_device1 = {
> +	.name = "imx-uart",
> +	.id = 1,
> +	.resource = uart1,
> +	.num_resources = ARRAY_SIZE(uart1),
> +};
> +
> +static struct resource uart2[] = {
> +	{
> +		.start = UART3_BASE_ADDR,
> +		.end = UART3_BASE_ADDR + 0x0B5,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MXC_INT_UART3,
> +		.end = MXC_INT_UART3,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_uart_device2 = {
> +	.name = "imx-uart",
> +	.id = 2,
> +	.resource = uart2,
> +	.num_resources = ARRAY_SIZE(uart2),
> +};
> +
> +static struct resource mxc_fec_resources[] = {
> +	{
> +		.start	= MXC_FEC_BASE_ADDR,
> +		.end	= MXC_FEC_BASE_ADDR + 0xfff,
> +		.flags	= IORESOURCE_MEM,
> +	}, {
> +		.start	= MXC_INT_FEC,
> +		.end	= MXC_INT_FEC,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_fec_device = {
> +	.name = "fec",
> +	.id = 0,
> +	.num_resources = ARRAY_SIZE(mxc_fec_resources),
> +	.resource = mxc_fec_resources,
> +};
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> new file mode 100644
> index 0000000..f339ab8
> --- /dev/null
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -0,0 +1,4 @@
> +extern struct platform_device mxc_uart_device0;
> +extern struct platform_device mxc_uart_device1;
> +extern struct platform_device mxc_uart_device2;
> +extern struct platform_device mxc_fec_device;
> diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
> new file mode 100644
> index 0000000..b258917
> --- /dev/null
> +++ b/arch/arm/mach-mx5/mm.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License.  You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + *
> + * Create static mapping between physical to virtual memory.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/init.h>
> +#include <mach/hardware.h>
> +#include <asm/pgtable.h>
> +#include <asm/mach/map.h>
> +#include <mach/common.h>
> +#include <mach/iomux-v3.h>
> +
> +/*
> + * Define the MX51 memory map.
> + */
> +static struct map_desc mxc_io_desc[] __initdata = {
> +	{
> +	 .virtual = IRAM_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(IRAM_BASE_ADDR),
> +	 .length = IRAM_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = DEBUG_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(DEBUG_BASE_ADDR),
> +	 .length = DEBUG_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = TZIC_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(TZIC_BASE_ADDR),
> +	 .length = TZIC_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = AIPS1_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(AIPS1_BASE_ADDR),
> +	 .length = AIPS1_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = SPBA0_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(SPBA0_BASE_ADDR),
> +	 .length = SPBA0_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = AIPS2_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(AIPS2_BASE_ADDR),
> +	 .length = AIPS2_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = NFC_BASE_ADDR_AXI_VIRT,
> +	 .pfn = __phys_to_pfn(NFC_BASE_ADDR_AXI),
> +	 .length = NFC_AXI_SIZE,
> +	 .type = MT_DEVICE},
> +};
> +
> +/*
> + * This function initializes the memory map. It is called during the
> + * system startup to create static physical to virtual memory mappings
> + * for the IO modules.
> + */
> +void __init mx51_map_io(void)
> +{
> +	u32 tzic_addr;
> +	if (mx51_revision() < CHIP_REV_2_0)
> +		tzic_addr = 0x8FFFC000;
> +	else
> +		tzic_addr = 0xE0003000;
> +	mxc_io_desc[2].pfn =  __phys_to_pfn(tzic_addr);
> +
> +	mxc_set_cpu_type(MXC_CPU_MX51);
> +	mxc_iomux_v3_init(IO_ADDRESS(IOMUXC_BASE_ADDR));
> +	mxc_arch_reset_init(IO_ADDRESS(WDOG_BASE_ADDR));
> +	iotable_init(mxc_io_desc, ARRAY_SIZE(mxc_io_desc));
> +}
> +
> +void __init mx51_init_irq(void)
> +{
> +	mxc_init_irq(IO_ADDRESS(TZIC_BASE_ADDR));
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> new file mode 100644
> index 0000000..0cdb295
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -0,0 +1,309 @@
> +/*
> + * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com> All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#ifndef __MACH_IOMUX_MX51_H__
> +#define __MACH_IOMUX_MX51_H__
> +
> +#include <mach/iomux-v3.h>
> +
> +/*
> + * various IOMUX alternate output functions (1-7)
> + */
> +typedef enum iomux_config {
> +	IOMUX_CONFIG_ALT0,
> +	IOMUX_CONFIG_ALT1,
> +	IOMUX_CONFIG_ALT2,
> +	IOMUX_CONFIG_ALT3,
> +	IOMUX_CONFIG_ALT4,
> +	IOMUX_CONFIG_ALT5,
> +	IOMUX_CONFIG_ALT6,
> +	IOMUX_CONFIG_ALT7,
> +	IOMUX_CONFIG_GPIO,	/* added to help user use GPIO mode */
> +	IOMUX_CONFIG_SION = 0x1 << 4,	/* LOOPBACK:MUX SION bit */
> +} iomux_pin_cfg_t;
> +
> +/*
> + * The naming convention for the pad modes is MX51_PAD_<padname>__<padmode>
> + * If <padname> or <padmode> refers to a GPIO, it is named
> + * GPIO_<unit>_<num> see also iomux-v3.h
> + */
> +
> +/* REVISIT: This was converted using scripts from existing Freescale code to
> + * this form used upstream. Need to verify the name format.
> + */
> +
> +/*						PAD      MUX   ALT INPSE PATH PADCTRL */
> +
> +/* EIM */
> +#define MX51_PAD_EIM_DA0__EIM_DA0	IOMUX_PAD(0x7a8, 0x01c, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA1__EIM_DA1	IOMUX_PAD(0x7a8, 0x020, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA2__EIM_DA2	IOMUX_PAD(0x7a8, 0x024, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA3__EIM_DA3	IOMUX_PAD(0x7a8, 0x028, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA4__EIM_DA4	IOMUX_PAD(0x7ac, 0x02c, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA5__EIM_DA5	IOMUX_PAD(0x7ac, 0x030, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA6__EIM_DA6	IOMUX_PAD(0x7ac, 0x034, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA7__EIM_DA7	IOMUX_PAD(0x7ac, 0x038, 0, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_EIM_DA8__EIM_DA8	IOMUX_PAD(0x7b0, 0x03c, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA9__EIM_DA9	IOMUX_PAD(0x7b0, 0x040, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA10__EIM_DA10	IOMUX_PAD(0x7b0, 0x044, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA11__EIM_DA11	IOMUX_PAD(0x7b0, 0x048, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA12__EIM_DA12	IOMUX_PAD(0x7bc, 0x04c, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA13__EIM_DA13	IOMUX_PAD(0x7bc, 0x050, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA14__EIM_DA14	IOMUX_PAD(0x7bc, 0x054, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_DA15__EIM_DA15	IOMUX_PAD(0x7bc, 0x058, 0, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_2_0__EIM_D16	IOMUX_PAD(0x3f0, 0x05c, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_1__EIM_D17	IOMUX_PAD(0x3f4, 0x060, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_2__EIM_D18	IOMUX_PAD(0x3f8, 0x064, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_3__EIM_D19	IOMUX_PAD(0x3fc, 0x068, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_4__EIM_D20	IOMUX_PAD(0x400, 0x06c, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_5__EIM_D21	IOMUX_PAD(0x404, 0x070, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_6__EIM_D22	IOMUX_PAD(0x408, 0x074, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_7__EIM_D23	IOMUX_PAD(0x40c, 0x078, 1, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_2_8__EIM_D24	IOMUX_PAD(0x410, 0x07c, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D25__EIM_D25	IOMUX_PAD(0x414, 0x080, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D26__EIM_D26	IOMUX_PAD(0x418, 0x084, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_9__EIM_D27	IOMUX_PAD(0x41c, 0x088, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D28__EIM_D28	IOMUX_PAD(0x420, 0x08c, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D29__EIM_D29	IOMUX_PAD(0x424, 0x090, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D30__EIM_D30	IOMUX_PAD(0x428, 0x094, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_D31__EIM_D31	IOMUX_PAD(0x42c, 0x09c, 0, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_2_10__EIM_A16	IOMUX_PAD(0x430, 0x09c, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_11__EIM_A17	IOMUX_PAD(0x434, 0x0a0, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_12__EIM_A18	IOMUX_PAD(0x438, 0x0a4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_13__EIM_A19	IOMUX_PAD(0x43c, 0x0a8, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_14__EIM_A20	IOMUX_PAD(0x440, 0x0ac, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_15__EIM_A21	IOMUX_PAD(0x444, 0x0b0, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_16__EIM_A22	IOMUX_PAD(0x448, 0x0b4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_17__EIM_A23	IOMUX_PAD(0x44c, 0x0b8, 1, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_2_18__EIM_A24	IOMUX_PAD(0x450, 0x0bc, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_19__EIM_A25	IOMUX_PAD(0x454, 0x0c0, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_20__EIM_A26	IOMUX_PAD(0x458, 0x0c4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_21__EIM_A27	IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_EB0__EIM_EB0	IOMUX_PAD(0x460, 0x0cc, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_EIM_EB1__EIM_EB1	IOMUX_PAD(0x464, 0x0d0, 0, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_22__EIM_EB2	IOMUX_PAD(0x468, 0x0d4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_23__EIM_EB3	IOMUX_PAD(0x46c, 0x0d8, 1, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_2_24__EIM_OE	IOMUX_PAD(0x470, 0x0dc, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_25__EIM_CS0	IOMUX_PAD(0x474, 0x0e0, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_26__EIM_CS1	IOMUX_PAD(0x478, 0x0e4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_27__EIM_CS2	IOMUX_PAD(0x47c, 0x0e8, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_28__EIM_CS3	IOMUX_PAD(0x480, 0x0ec, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_29__EIM_CS4	IOMUX_PAD(0x484, 0x0f0, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_30__EIM_CS5	IOMUX_PAD(0x488, 0x0f4, 1, 0x0,   0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_2_31__EIM_DTACK	IOMUX_PAD(0x48c, 0x0f8, 1, 0x0,   0, NO_PAD_CTRL)
> +
> +#define MX51_PAD_GPIO_3_1__EIM_LBA	IOMUX_PAD(0x494, 0xFC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_2__EIM_CRE	IOMUX_PAD(0x4A0, 0x100, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DRAM_CS1__DRAM_CS1	IOMUX_PAD(0x4D0, 0x104, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_3__NANDF_WE_B	IOMUX_PAD(0x4E4, 0x108, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_4__NANDF_RE_B	IOMUX_PAD(0x4E8, 0x10C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_5__NANDF_ALE	IOMUX_PAD(0x4EC, 0x110, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_6__NANDF_CLE	IOMUX_PAD(0x4F0, 0x114, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_7__NANDF_WP_B	IOMUX_PAD(0x4F4, 0x118, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_8__NANDF_RB0	IOMUX_PAD(0x4F8, 0x11C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_9__NANDF_RB1	IOMUX_PAD(0x4FC, 0x120, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_10__NANDF_RB2	IOMUX_PAD(0x500, 0x124, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_11__NANDF_RB3	IOMUX_PAD(0x504, 0x128, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_12__GPIO_NAND	IOMUX_PAD(0x514, 0x12C, 3, 0x0, 0, NO_PAD_CTRL)
> +/* REVISIT: Not sure of these values
> +
> +  #define MX51_PAD_GPIO_1___NANDF_RB4	IOMUX_PAD(, , , 0x0, 0, NO_PAD_CTRL)
> +  #define MX51_PAD_GPIO_3_13__NANDF_RB5	IOMUX_PAD(0x5D8, 0x130, 3, 0x0, 0, NO_PAD_CTRL)
> +  #define MX51_PAD_GPIO_3_15__NANDF_RB7	IOMUX_PAD(0x5E0, 0x138, 3, 0x0, 0, NO_PAD_CTRL)
> +*/
> +#define MX51_PAD_GPIO_3_14__NANDF_RB6	IOMUX_PAD(0x5DC, 0x134, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_16__NANDF_CS0	IOMUX_PAD(0x518, 0x130, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_17__NANDF_CS1	IOMUX_PAD(0x51C, 0x134, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_18__NANDF_CS2	IOMUX_PAD(0x520, 0x138, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_19__NANDF_CS3	IOMUX_PAD(0x524, 0x13C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_20__NANDF_CS4	IOMUX_PAD(0x528, 0x140, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_21__NANDF_CS5	IOMUX_PAD(0x52C, 0x144, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_22__NANDF_CS6	IOMUX_PAD(0x530, 0x148, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_23__NANDF_CS7	IOMUX_PAD(0x534, 0x14C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_24__NANDF_RDY_INT	IOMUX_PAD(0x538, 0x150, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_25__NANDF_D15	IOMUX_PAD(0x53C, 0x154, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_26__NANDF_D14	IOMUX_PAD(0x540, 0x158, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_27__NANDF_D13	IOMUX_PAD(0x544, 0x15C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_28__NANDF_D12	IOMUX_PAD(0x548, 0x160, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_29__NANDF_D11	IOMUX_PAD(0x54C, 0x164, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_30__NANDF_D10	IOMUX_PAD(0x550, 0x168, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_31__NANDF_D9	IOMUX_PAD(0x554, 0x16C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_0__NANDF_D8	IOMUX_PAD(0x558, 0x170, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_1__NANDF_D7	IOMUX_PAD(0x55C, 0x174, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_2__NANDF_D6	IOMUX_PAD(0x560, 0x178, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_3__NANDF_D5	IOMUX_PAD(0x564, 0x17C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_4__NANDF_D4	IOMUX_PAD(0x568, 0x180, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_5__NANDF_D3	IOMUX_PAD(0x56C, 0x184, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_6__NANDF_D2	IOMUX_PAD(0x570, 0x188, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_7__NANDF_D1	IOMUX_PAD(0x574, 0x18C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_8__NANDF_D0	IOMUX_PAD(0x578, 0x190, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_12__CSI1_D8	IOMUX_PAD(0x57C, 0x194, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_13__CSI1_D9	IOMUX_PAD(0x580, 0x198, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D10__CSI1_D10	IOMUX_PAD(0x584, 0x19C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D11__CSI1_D11	IOMUX_PAD(0x588, 0x1A0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D12__CSI1_D12	IOMUX_PAD(0x58C, 0x1A4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D13__CSI1_D13	IOMUX_PAD(0x590, 0x1A8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D14__CSI1_D14	IOMUX_PAD(0x594, 0x1AC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D15__CSI1_D15	IOMUX_PAD(0x598, 0x1B0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D16__CSI1_D16	IOMUX_PAD(0x59C, 0x1B4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D17__CSI1_D17	IOMUX_PAD(0x5A0, 0x1B8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D18__CSI1_D18	IOMUX_PAD(0x5A4, 0x1BC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_D19__CSI1_D19	IOMUX_PAD(0x5A8, 0x1C0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_VSYNC__CSI1_VSYNC	IOMUX_PAD(0x5AC, 0x1C4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_HSYNC__CSI1_HSYNC	IOMUX_PAD(0x5B0, 0x1C8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_PIXCLK__CSI1_PIXCLK	IOMUX_PAD(0x5B4, 0x0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_MCLK__CSI1_MCLK	IOMUX_PAD(0x5B8, 0x0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI1_PKE0__CSI1_PKE0	IOMUX_PAD(0x860, 0x0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_9__CSI2_D12	IOMUX_PAD(0x5BC, 0x1CC, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_10__CSI2_D13	IOMUX_PAD(0x5C0, 0x1D0, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_11__CSI2_D14	IOMUX_PAD(0x5C4, 0x1D4, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_12__CSI2_D15	IOMUX_PAD(0x5C8, 0x1D8, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_11__CSI2_D16	IOMUX_PAD(0x5CC, 0x1DC, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_12__CSI2_D17	IOMUX_PAD(0x5D0, 0x1E0, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_11__CSI2_D18	IOMUX_PAD(0x5D4, 0x1E4, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_12__CSI2_D19	IOMUX_PAD(0x5D8, 0x1E8, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_13__CSI2_VSYNC	IOMUX_PAD(0x5DC, 0x1EC, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_14__CSI2_HSYNC	IOMUX_PAD(0x5E0, 0x1F0, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_15__CSI2_PIXCLK	IOMUX_PAD(0x5E4, 0x1F4, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_CSI2_PKE0__CSI2_PKE0	IOMUX_PAD(0x81C, 0x0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_16__I2C1_CLK	IOMUX_PAD(0x5E8, 0x1F8, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_17__I2C1_DAT	IOMUX_PAD(0x5EC, 0x1FC, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_18__AUD3_BB_TXD	IOMUX_PAD(0x5F0, 0x200, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_19__AUD3_BB_RXD	IOMUX_PAD(0x5F4, 0x204, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_20__AUD3_BB_CK	IOMUX_PAD(0x5F8, 0x208, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_21__AUD3_BB_FS	IOMUX_PAD(0x5FC, 0x20C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_22__CSPI1_MOSI	IOMUX_PAD(0x600, 0x210, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_23__CSPI1_MISO	IOMUX_PAD(0x604, 0x214, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_24__CSPI1_SS0	IOMUX_PAD(0x608, 0x218, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_25__CSPI1_SS1	IOMUX_PAD(0x60C, 0x21C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_26__CSPI1_RDY	IOMUX_PAD(0x610, 0x220, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_27__CSPI1_SCLK	IOMUX_PAD(0x614, 0x224, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_28__UART1_RXD	IOMUX_PAD(0x618, 0x228, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_29__UART1_TXD	IOMUX_PAD(0x61C, 0x22C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_30__UART1_RTS	IOMUX_PAD(0x620, 0x230, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_4_31__UART1_CTS	IOMUX_PAD(0x624, 0x234, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_20__UART2_RXD	IOMUX_PAD(0x628, 0x238, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_21__UART2_TXD	IOMUX_PAD(0x62C, 0x23C, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_22__UART3_RXD	IOMUX_PAD(0x630, 0x240, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_23__UART3_TXD	IOMUX_PAD(0x634, 0x244, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_24__OWIRE_LINE	IOMUX_PAD(0x638, 0x248, 3, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_ROW0__KEY_ROW0	IOMUX_PAD(0x63C, 0x24C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_ROW1__KEY_ROW1	IOMUX_PAD(0x640, 0x250, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_ROW2__KEY_ROW2	IOMUX_PAD(0x644, 0x254, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_ROW3__KEY_ROW3	IOMUX_PAD(0x648, 0x258, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL0__KEY_COL0	IOMUX_PAD(0x64C, 0x25C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL1__KEY_COL1	IOMUX_PAD(0x650, 0x260, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL2__KEY_COL2	IOMUX_PAD(0x654, 0x264, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL3__KEY_COL3	IOMUX_PAD(0x658, 0x268, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL4__KEY_COL4	IOMUX_PAD(0x65C, 0x26C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_KEY_COL5__KEY_COL5	IOMUX_PAD(0x660, 0x270, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_25__USBH1_CLK	IOMUX_PAD(0x678, 0x278, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_26__USBH1_DIR	IOMUX_PAD(0x67C, 0x27C, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_27__USBH1_STP	IOMUX_PAD(0x680, 0x280, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_28__USBH1_NXT	IOMUX_PAD(0x684, 0x284, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_11__USBH1_DATA0	IOMUX_PAD(0x688, 0x288, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_12__USBH1_DATA1	IOMUX_PAD(0x68C, 0x28C, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_13__USBH1_DATA2	IOMUX_PAD(0x690, 0x290, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_14__USBH1_DATA3	IOMUX_PAD(0x694, 0x294, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_15__USBH1_DATA4	IOMUX_PAD(0x698, 0x298, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_16__USBH1_DATA5	IOMUX_PAD(0x69C, 0x29C, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_17__USBH1_DATA6	IOMUX_PAD(0x6A0, 0x2A0, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_18__USBH1_DATA7	IOMUX_PAD(0x6A4, 0x2A4, 2, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_0__DI1_PIN11	IOMUX_PAD(0x6A8, 0x2A8, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_1__DI1_PIN12	IOMUX_PAD(0x6AC, 0x2AC, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_2__DI1_PIN13	IOMUX_PAD(0x6B0, 0x2B0, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_3__DI1_D0_CS	IOMUX_PAD(0x6B4, 0x2B4, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_4__DI1_D1_CS	IOMUX_PAD(0x6B8, 0x2B8, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_5__DISPB2_SER_DIN	IOMUX_PAD(0x6BC, 0x2BC, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_6__DISPB2_SER_DIO	IOMUX_PAD(0x6C0, 0x2C0, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_7__DISPB2_SER_CLK	IOMUX_PAD(0x6C4, 0x2C4, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_3_8__DISPB2_SER_RS	IOMUX_PAD(0x6C8, 0x2C8, 4, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT0__DISP1_DAT0	IOMUX_PAD(0x6CC, 0x2CC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT1__DISP1_DAT1	IOMUX_PAD(0x6D0, 0x2D0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT2__DISP1_DAT2	IOMUX_PAD(0x6D4, 0x2D4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT3__DISP1_DAT3	IOMUX_PAD(0x6D8, 0x2D8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT4__DISP1_DAT4	IOMUX_PAD(0x6DC, 0x2DC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT5__DISP1_DAT5	IOMUX_PAD(0x6E0, 0x2E0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT6__DISP1_DAT6	IOMUX_PAD(0x6E4, 0x2E4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT7__DISP1_DAT7	IOMUX_PAD(0x6E8, 0x2E8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT8__DISP1_DAT8	IOMUX_PAD(0x6EC, 0x2EC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT9__DISP1_DAT9	IOMUX_PAD(0x6F0, 0x2F0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT10__DISP1_DAT10	IOMUX_PAD(0x6F4, 0x2F4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT11__DISP1_DAT11	IOMUX_PAD(0x6F8, 0x2F8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT12__DISP1_DAT12	IOMUX_PAD(0x6FC, 0x2FC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT13__DISP1_DAT13	IOMUX_PAD(0x700, 0x300, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT14__DISP1_DAT14	IOMUX_PAD(0x704, 0x304, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT15__DISP1_DAT15	IOMUX_PAD(0x708, 0x308, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT16__DISP1_DAT16	IOMUX_PAD(0x70C, 0x30C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT17__DISP1_DAT17	IOMUX_PAD(0x710, 0x310, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT18__DISP1_DAT18	IOMUX_PAD(0x714, 0x314, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT19__DISP1_DAT19	IOMUX_PAD(0x718, 0x318, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT20__DISP1_DAT20	IOMUX_PAD(0x71C, 0x31C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT21__DISP1_DAT21	IOMUX_PAD(0x720, 0x320, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT22__DISP1_DAT22	IOMUX_PAD(0x724, 0x324, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP1_DAT23__DISP1_DAT23	IOMUX_PAD(0x728, 0x328, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI1_PIN3__DI1_PIN3	IOMUX_PAD(0x72C, 0x32C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI1_PIN2__DI1_PIN2	IOMUX_PAD(0x734, 0x330, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI_GP1__DI_GP1	IOMUX_PAD(0x73C, 0x334, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI_GP2__DI_GP2	IOMUX_PAD(0x740, 0x338, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI_GP3__DI_GP3	IOMUX_PAD(0x744, 0x33C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI2_PIN4__DI2_PIN4	IOMUX_PAD(0x748, 0x340, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI2_PIN2__DI2_PIN2	IOMUX_PAD(0x74C, 0x344, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI2_PIN3__DI2_PIN3	IOMUX_PAD(0x750, 0x348, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI2_DISP_CLK__DI2_DISP_CLK	IOMUX_PAD(0x754, 0x34C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DI_GP4__DI_GP4	IOMUX_PAD(0x758, 0x350, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT0__DISP2_DAT0	IOMUX_PAD(0x75C, 0x354, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT1__DISP2_DAT1	IOMUX_PAD(0x760, 0x358, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT2__DISP2_DAT2	IOMUX_PAD(0x764, 0x35C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT3__DISP2_DAT3	IOMUX_PAD(0x768, 0x360, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT4__DISP2_DAT4	IOMUX_PAD(0x76C, 0x364, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT5__DISP2_DAT5	IOMUX_PAD(0x770, 0x368, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_19__DISP2_DAT6	IOMUX_PAD(0x774, 0x36C, 5, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_29__DISP2_DAT7	IOMUX_PAD(0x778, 0x370, 5, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_30__DISP2_DAT8	IOMUX_PAD(0x77C, 0x374, 5, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_31__DISP2_DAT9	IOMUX_PAD(0x780, 0x378, 5, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT10__DISP2_DAT10	IOMUX_PAD(0x784, 0x37C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT11__DISP2_DAT11	IOMUX_PAD(0x788, 0x380, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT12__DISP2_DAT12	IOMUX_PAD(0x78C, 0x384, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT13__DISP2_DAT13	IOMUX_PAD(0x790, 0x388, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT14__DISP2_DAT14	IOMUX_PAD(0x794, 0x38C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_DISP2_DAT15__DISP2_DAT15	IOMUX_PAD(0x798, 0x390, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_CMD__SD1_CMD	IOMUX_PAD(0x79C, 0x394, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_CLK__SD1_CLK	IOMUX_PAD(0x7A0, 0x398, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_DATA0__SD1_DATA0	IOMUX_PAD(0x7A4, 0x39C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_DATA1__SD1_DATA1	IOMUX_PAD(0x7A8, 0x3A0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_DATA2__SD1_DATA2	IOMUX_PAD(0x7AC, 0x3A4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD1_DATA3__SD1_DATA3	IOMUX_PAD(0x7B0, 0x3A8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_0__GPIO1_0	IOMUX_PAD(0x7B4, 0x3AC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_1__GPIO1_1	IOMUX_PAD(0x7B8, 0x3B0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_CMD__SD2_CMD	IOMUX_PAD(0x7BC, 0x3B4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_CLK__SD2_CLK	IOMUX_PAD(0x7C0, 0x3B8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_DATA0__SD2_DATA0	IOMUX_PAD(0x7C4, 0x3BC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_DATA1__SD2_DATA1	IOMUX_PAD(0x7C8, 0x3C0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_DATA2__SD2_DATA2	IOMUX_PAD(0x7CC, 0x3C4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_SD2_DATA3__SD2_DATA3	IOMUX_PAD(0x7D0, 0x3C8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_2__GPIO1_2	IOMUX_PAD(0x7D4, 0x3CC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_3__GPIO1_3	IOMUX_PAD(0x7D8, 0x3D0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_PMIC_INT_REQ__PMIC_INT_REQ	IOMUX_PAD(0x7FC, 0x3D4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_4__GPIO1_4	IOMUX_PAD(0x804, 0x3D8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_5__GPIO1_5	IOMUX_PAD(0x808, 0x3DC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_6__GPIO1_6	IOMUX_PAD(0x80C, 0x3E0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_7__GPIO1_7	IOMUX_PAD(0x810, 0x3E4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_9__GPIO1_9	IOMUX_PAD(0x818, 0x3EC, 0, 0x0, 0, NO_PAD_CTRL)
> +
> +#endif /* __MACH_IOMUX_MX51_H__ */
> diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-mxc/include/mach/mx51.h
> new file mode 100644
> index 0000000..54b43fb
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/mx51.h
> @@ -0,0 +1,481 @@
> +#ifndef __ASM_ARCH_MXC_MX51_H__
> +#define __ASM_ARCH_MXC_MX51_H__
> +
> +/*
> + * MX51 memory map:
> + *
> + *
> + * Virt		Phys		Size	What
> + * ---------------------------------------------------------------------------
> + * FA3E0000	1FFE0000	128K	IRAM (SCCv2 RAM)
> + *         	30000000	256M	GPU
> + *         	40000000	512M	IPU
> + * FA200000	60000000	1M	DEBUG
> + * FB100000	70000000	1M	SPBA 0
> + * FB000000	73F00000	1M	AIPS 1
> + * FB200000	83F00000	1M	AIPS 2
> + * FA100000	8FFFC000	16K	TZIC (interrupt controller)
> + *         	90000000	256M	CSD0 SDRAM/DDR
> + *         	A0000000	256M	CSD1 SDRAM/DDR
> + *         	B0000000	128M	CS0 Flash
> + *         	B8000000	128M	CS1 Flash
> + *         	C0000000	128M	CS2 Flash
> + *         	C8000000	64M	CS3 Flash
> + *         	CC000000	32M	CS4 SRAM
> + *         	CE000000	32M	CS5 SRAM
> + * F9000000	CFFF0000	64K	NFC (NAND Flash AXI)
> + *
> + */
> +
> +/*
> + * IRAM
> + */
> +#define IRAM_BASE_ADDR		0x1FFE0000	/* internal ram */
> +#define IRAM_BASE_ADDR_VIRT	0xFA3E0000
> +#define IRAM_PARTITIONS		16
> +#define IRAM_PARTITIONS_TO1	12
> +#define IRAM_SIZE		(IRAM_PARTITIONS*SZ_8K)	/* 128KB */

Please prefix all these macros with MX51_. Having them without prefix is
a pain and we are about to remove them.

> +
> +#if defined(CONFIG_MXC_SECURITY_SCC2) \
> +    || defined(CONFIG_MXC_SECURITY_SCC2_MODULE)
> +#define SCC_IRAM_SIZE SZ_16K
> +#else
> +#define SCC_IRAM_SIZE 0
> +#endif
> +
> +#ifdef CONFIG_SDMA_IRAM
> +#define SDMA_IRAM_SIZE CONFIG_SDMA_IRAM_SIZE
> +#else
> +#define SDMA_IRAM_SIZE 0
> +#endif
> +
> +#ifdef CONFIG_SND_MXC_SOC_IRAM
> +#define SND_RAM_SIZE 0x6000
> +#else
> +#define SND_RAM_SIZE 0
> +#endif
> +
> +#ifdef CONFIG_MXC_VPU_IRAM
> +#define VPU_IRAM_SIZE 0x7000
> +#else
> +#define VPU_IRAM_SIZE 0
> +#endif
> +
> +#if (IRAM_SIZE < (SDMA_IRAM_SIZE + SND_RAM_SIZE + VPU_IRAM_SIZE + \
> +	SCC_IRAM_SIZE))
> +#error "IRAM size exceeded"
> +#endif
> +
> +#define SCC_IRAM_BASE_ADDR	(IRAM_BASE_ADDR + IRAM_SIZE - SCC_IRAM_SIZE)
> +#define VPU_IRAM_BASE_ADDR	(SCC_IRAM_BASE_ADDR - VPU_IRAM_SIZE)
> +#define SND_RAM_BASE_ADDR	(VPU_IRAM_BASE_ADDR - SND_RAM_SIZE)
> +#define SDMA_IRAM_BASE_ADDR	(SND_RAM_BASE_ADDR - SDMA_IRAM_SIZE)
> +#define IDLE_IRAM_BASE_ADDR	(SDMA_IRAM_BASE_ADDR - SZ_4K)

Can we remove this IRAM stuff until someone actually uses it?
I could imagine that we want to have a more dynamic approach for the
IRAM

> +
> +/*
> + * NFC
> + */
> +#define NFC_BASE_ADDR_AXI	0xCFFF0000	/* NAND flash AXI */
> +#define NFC_BASE_ADDR_AXI_VIRT	0xF9000000
> +#define NFC_AXI_SIZE		SZ_64K
> +
> +/*
> + * Graphics Memory of GPU
> + */
> +#define GPU_BASE_ADDR		0x20000000
> +#define GPU2D_BASE_ADDR		0xD0000000
> +
> +#define TZIC_BASE_ADDR		0x8FFFC000
> +#define TZIC_BASE_ADDR_VIRT	0xFA100000
> +#define TZIC_SIZE		SZ_16K
> +
> +#define DEBUG_BASE_ADDR		0x60000000
> +#define DEBUG_BASE_ADDR_VIRT	0xFA200000
> +#define DEBUG_SIZE		SZ_1M
> +#define ETB_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00001000)
> +#define ETM_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00002000)
> +#define TPIU_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00003000)
> +#define CTI0_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00004000)
> +#define CTI1_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00005000)
> +#define CTI2_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00006000)
> +#define CTI3_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00007000)
> +#define CORTEX_DBG_BASE_ADDR	(DEBUG_BASE_ADDR + 0x00008000)
> +
> +/*
> + * SPBA global module enabled #0
> + */
> +#define SPBA0_BASE_ADDR 	0x70000000
> +#define SPBA0_BASE_ADDR_VIRT	0xFB100000
> +#define SPBA0_SIZE		SZ_1M
> +
> +#define MMC_SDHC1_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00004000)
> +#define MMC_SDHC2_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00008000)
> +#define UART3_BASE_ADDR 	(SPBA0_BASE_ADDR + 0x0000C000)
> +#define CSPI1_BASE_ADDR 	(SPBA0_BASE_ADDR + 0x00010000)
> +#define SSI2_BASE_ADDR		(SPBA0_BASE_ADDR + 0x00014000)
> +#define MMC_SDHC3_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00020000)
> +#define MMC_SDHC4_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00024000)
> +#define SPDIF_BASE_ADDR		(SPBA0_BASE_ADDR + 0x00028000)
> +#define ATA_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00030000)
> +#define SLIM_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00034000)
> +#define HSI2C_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00038000)
> +#define SPBA_CTRL_BASE_ADDR	(SPBA0_BASE_ADDR + 0x0003C000)
> +
> +/*
> + * defines for SPBA modules
> + */
> +#define SPBA_SDHC1	0x04
> +#define SPBA_SDHC2	0x08
> +#define SPBA_UART3	0x0C
> +#define SPBA_CSPI1	0x10
> +#define SPBA_SSI2	0x14
> +#define SPBA_SDHC3	0x20
> +#define SPBA_SDHC4	0x24
> +#define SPBA_SPDIF	0x28
> +#define SPBA_ATA	0x30
> +#define SPBA_SLIM	0x34
> +#define SPBA_HSI2C	0x38
> +#define SPBA_CTRL	0x3C
> +
> +/*
> + * AIPS 1
> + */
> +#define AIPS1_BASE_ADDR 	0x73F00000
> +#define AIPS1_BASE_ADDR_VIRT	0xFB000000
> +#define AIPS1_SIZE		SZ_1M
> +
> +#define OTG_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00080000)
> +#define GPIO1_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00084000)
> +#define GPIO2_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00088000)
> +#define GPIO3_BASE_ADDR	(AIPS1_BASE_ADDR + 0x0008C000)
> +#define GPIO4_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00090000)
> +#define KPP_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00094000)
> +#define WDOG_BASE_ADDR	(AIPS1_BASE_ADDR + 0x00098000)
> +#define WDOG2_BASE_ADDR	(AIPS1_BASE_ADDR + 0x0009C000)
> +#define GPT1_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000A0000)
> +#define SRTC_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000A4000)
> +#define IOMUXC_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000A8000)
> +#define EPIT1_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000AC000)
> +#define EPIT2_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000B0000)
> +#define PWM1_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000B4000)
> +#define PWM2_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000B8000)
> +#define UART1_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000BC000)
> +#define UART2_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000C0000)
> +#define SRC_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000D0000)
> +#define CCM_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000D4000)
> +#define GPC_BASE_ADDR	(AIPS1_BASE_ADDR + 0x000D8000)
> +
> +/*
> + * Defines for modules using static and dynamic DMA channels
> + */
> +#define MXC_DMA_CHANNEL_IRAM	30
> +#define MXC_DMA_CHANNEL_SPDIF_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART1_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART1_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART2_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART2_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART3_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_UART3_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_MMC1		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_MMC2		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_SSI1_RX		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_SSI1_TX		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_SSI2_RX		MXC_DMA_DYNAMIC_CHANNEL
> +#ifdef CONFIG_SDMA_IRAM
> +#define MXC_DMA_CHANNEL_SSI2_TX  (MXC_DMA_CHANNEL_IRAM + 1)
> +#else				/*CONFIG_SDMA_IRAM */
> +#define MXC_DMA_CHANNEL_SSI2_TX		MXC_DMA_DYNAMIC_CHANNEL
> +#endif				/*CONFIG_SDMA_IRAM */
> +#define MXC_DMA_CHANNEL_CSPI1_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_CSPI1_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_CSPI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_CSPI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_CSPI3_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_CSPI3_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_ATA_RX		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_ATA_TX		MXC_DMA_DYNAMIC_CHANNEL
> +#define MXC_DMA_CHANNEL_MEMORY		MXC_DMA_DYNAMIC_CHANNEL
> +
> +/*
> + * AIPS 2
> + */
> +#define AIPS2_BASE_ADDR		0x83F00000
> +#define AIPS2_BASE_ADDR_VIRT	0xFB200000
> +#define AIPS2_SIZE		SZ_1M
> +
> +#define PLL1_BASE_ADDR	(AIPS2_BASE_ADDR + 0x00080000)
> +#define PLL2_BASE_ADDR	(AIPS2_BASE_ADDR + 0x00084000)
> +#define PLL3_BASE_ADDR	(AIPS2_BASE_ADDR + 0x00088000)
> +#define AHBMAX_BASE_ADDR	(AIPS2_BASE_ADDR + 0x00094000)
> +#define IIM_BASE_ADDR	(AIPS2_BASE_ADDR + 0x00098000)
> +#define CSU_BASE_ADDR	(AIPS2_BASE_ADDR + 0x0009C000)
> +#define ARM_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000A0000)
> +#define OWIRE_BASE_ADDR (AIPS2_BASE_ADDR + 0x000A4000)
> +#define FIRI_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000A8000)
> +#define CSPI2_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000AC000)
> +#define SDMA_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000B0000)
> +#define SCC_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000B4000)
> +#define ROMCP_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000B8000)
> +#define RTIC_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000BC000)
> +#define CSPI3_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000C0000)
> +#define I2C2_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000C4000)
> +#define I2C1_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000C8000)
> +#define SSI1_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000CC000)
> +#define AUDMUX_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000D0000)
> +#define M4IF_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000D8000)
> +#define ESDCTL_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000D9000)
> +#define WEIM_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000DA000)
> +#define NFC_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000DB000)
> +#define EMI_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000DBF00)
> +#define MIPI_HSC_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000DC000)
> +#define ATA_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000E0000)
> +#define SIM_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000E4000)
> +#define SSI3BASE_ADDR	(AIPS2_BASE_ADDR + 0x000E8000)
> +#define MXC_FEC_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000EC000)
> +#define TVE_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000F0000)
> +#define VPU_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000F4000)
> +#define SAHARA_BASE_ADDR	(AIPS2_BASE_ADDR + 0x000F8000)
> +
> +/*
> + * Memory regions and CS
> + */
> +#define GPU_CTRL_BASE_ADDR	0x30000000
> +#define IPU_CTRL_BASE_ADDR	0x40000000
> +#define CSD0_BASE_ADDR		0x90000000
> +#define CSD1_BASE_ADDR		0xA0000000
> +#define CS0_BASE_ADDR		0xB0000000
> +#define CS1_BASE_ADDR		0xB8000000
> +#define CS2_BASE_ADDR		0xC0000000
> +#define CS3_BASE_ADDR		0xC8000000
> +#define CS4_BASE_ADDR		0xCC000000
> +#define CS5_BASE_ADDR		0xCE000000
> +
> +/*
> + * This macro defines the physical to virtual address mapping for all the
> + * peripheral modules. It is used by passing in the physical address as x
> + * and returning the virtual address. If the physical address is not mapped,
> + * it returns 0xDEADBEEF
> + */
> +
> +#define IO_ADDRESS(x)	\
> +	(void __force __iomem *) \
> +	(((x >= IRAM_BASE_ADDR) && (x < (IRAM_BASE_ADDR + IRAM_SIZE))) ? IRAM_IO_ADDRESS(x):\
> +	((x >= TZIC_BASE_ADDR) && (x < (TZIC_BASE_ADDR + TZIC_SIZE))) ? TZIC_IO_ADDRESS(x):\
> +	((x >= DEBUG_BASE_ADDR) && (x < (DEBUG_BASE_ADDR + DEBUG_SIZE))) ? DEBUG_IO_ADDRESS(x):\
> +	((x >= SPBA0_BASE_ADDR) && (x < (SPBA0_BASE_ADDR + SPBA0_SIZE))) ? SPBA0_IO_ADDRESS(x):\
> +	((x >= AIPS1_BASE_ADDR) && (x < (AIPS1_BASE_ADDR + AIPS1_SIZE))) ? AIPS1_IO_ADDRESS(x):\
> +	((x >= AIPS2_BASE_ADDR) && (x < (AIPS2_BASE_ADDR + AIPS2_SIZE))) ? AIPS2_IO_ADDRESS(x):\
> +	((x >= NFC_BASE_ADDR_AXI) && (x < (NFC_BASE_ADDR_AXI + NFC_AXI_SIZE))) ? NFC_BASE_ADDR_AXI_IO_ADDRESS(x):\
> +	0xDEADBEEF)
> +/*
> + * define the address mapping macros: in physical address order
> + */
> +#define IRAM_IO_ADDRESS(x)  \
> +	(((x) - IRAM_BASE_ADDR) + IRAM_BASE_ADDR_VIRT)
> +
> +#define TZIC_IO_ADDRESS(x)  \
> +	(((x) - TZIC_BASE_ADDR) + TZIC_BASE_ADDR_VIRT)
> +
> +#define DEBUG_IO_ADDRESS(x)  \
> +	(((x) - DEBUG_BASE_ADDR) + DEBUG_BASE_ADDR_VIRT)
> +
> +#define SPBA0_IO_ADDRESS(x)  \
> +	(((x) - SPBA0_BASE_ADDR) + SPBA0_BASE_ADDR_VIRT)
> +
> +#define AIPS1_IO_ADDRESS(x)  \
> +	(((x) - AIPS1_BASE_ADDR) + AIPS1_BASE_ADDR_VIRT)
> +
> +#define AIPS2_IO_ADDRESS(x)  \
> +	(((x) - AIPS2_BASE_ADDR) + AIPS2_BASE_ADDR_VIRT)
> +
> +#define NFC_BASE_ADDR_AXI_IO_ADDRESS(x) \
> +	(((x) - NFC_BASE_ADDR_AXI) + NFC_BASE_ADDR_AXI_VIRT)
> +
> +#define IS_MEM_DEVICE_NONSHARED(x)		0
> +
> +/*
> + * DMA request assignments
> + */
> +#define DMA_REQ_SSI3_TX1	47
> +#define DMA_REQ_SSI3_RX1	46
> +#define DMA_REQ_SPDIF		45
> +#define DMA_REQ_UART3_TX	44
> +#define DMA_REQ_UART3_RX	43
> +#define DMA_REQ_SLIM_B_TX	42
> +#define DMA_REQ_SDHC4		41
> +#define DMA_REQ_SDHC3		40
> +#define DMA_REQ_CSPI_TX		39
> +#define DMA_REQ_CSPI_RX		38
> +#define DMA_REQ_SSI3_TX2	37
> +#define DMA_REQ_IPU		36
> +#define DMA_REQ_SSI3_RX2	35
> +#define DMA_REQ_EPIT2		34
> +#define DMA_REQ_CTI2_1		33
> +#define DMA_REQ_EMI_WR		32
> +#define DMA_REQ_CTI2_0		31
> +#define DMA_REQ_EMI_RD		30
> +#define DMA_REQ_SSI1_TX1	29
> +#define DMA_REQ_SSI1_RX1	28
> +#define DMA_REQ_SSI1_TX2	27
> +#define DMA_REQ_SSI1_RX2	26
> +#define DMA_REQ_SSI2_TX1	25
> +#define DMA_REQ_SSI2_RX1	24
> +#define DMA_REQ_SSI2_TX2	23
> +#define DMA_REQ_SSI2_RX2	22
> +#define DMA_REQ_SDHC2		21
> +#define DMA_REQ_SDHC1		20
> +#define DMA_REQ_UART1_TX	19
> +#define DMA_REQ_UART1_RX	18
> +#define DMA_REQ_UART2_TX	17
> +#define DMA_REQ_UART2_RX	16
> +#define DMA_REQ_GPU		15
> +#define DMA_REQ_EXTREQ1		14
> +#define DMA_REQ_FIRI_TX		13
> +#define DMA_REQ_FIRI_RX		12
> +#define DMA_REQ_HS_I2C_RX	11
> +#define DMA_REQ_HS_I2C_TX	10
> +#define DMA_REQ_CSPI2_TX	9
> +#define DMA_REQ_CSPI2_RX	8
> +#define DMA_REQ_CSPI1_TX	7
> +#define DMA_REQ_CSPI1_RX	6
> +#define DMA_REQ_SLIM_B		5
> +#define DMA_REQ_ATA_TX_END	4
> +#define DMA_REQ_ATA_TX		3
> +#define DMA_REQ_ATA_RX		2
> +#define DMA_REQ_GPC		1
> +#define DMA_REQ_VPU		0
> +
> +/*
> + * Interrupt numbers
> + */
> +#define MXC_INT_BASE		0
> +#define MXC_INT_RESV0		0
> +#define MXC_INT_MMC_SDHC1	1
> +#define MXC_INT_MMC_SDHC2	2
> +#define MXC_INT_MMC_SDHC3	3
> +#define MXC_INT_MMC_SDHC4	4
> +#define MXC_INT_RESV5		5
> +#define MXC_INT_SDMA		6
> +#define MXC_INT_IOMUX		7
> +#define MXC_INT_NFC		8
> +#define MXC_INT_VPU		9
> +#define MXC_INT_IPU_ERR		10
> +#define MXC_INT_IPU_SYN		11
> +#define MXC_INT_GPU		12
> +#define MXC_INT_RESV13		13
> +#define MXC_INT_USB_H1		14
> +#define MXC_INT_EMI		15
> +#define MXC_INT_USB_H2		16
> +#define MXC_INT_USB_H3		17
> +#define MXC_INT_USB_OTG		18
> +#define MXC_INT_SAHARA_H0	19
> +#define MXC_INT_SAHARA_H1	20
> +#define MXC_INT_SCC_SMN		21
> +#define MXC_INT_SCC_STZ		22
> +#define MXC_INT_SCC_SCM		23
> +#define MXC_INT_SRTC_NTZ	24
> +#define MXC_INT_SRTC_TZ		25
> +#define MXC_INT_RTIC		26
> +#define MXC_INT_CSU		27
> +#define MXC_INT_SLIM_B		28
> +#define MXC_INT_SSI1		29
> +#define MXC_INT_SSI2		30
> +#define MXC_INT_UART1		31
> +#define MXC_INT_UART2		32
> +#define MXC_INT_UART3		33
> +#define MXC_INT_RESV34		34
> +#define MXC_INT_RESV35		35
> +#define MXC_INT_CSPI1		36
> +#define MXC_INT_CSPI2		37
> +#define MXC_INT_CSPI		38
> +#define MXC_INT_GPT		39
> +#define MXC_INT_EPIT1		40
> +#define MXC_INT_EPIT2		41
> +#define MXC_INT_GPIO1_INT7	42
> +#define MXC_INT_GPIO1_INT6	43
> +#define MXC_INT_GPIO1_INT5	44
> +#define MXC_INT_GPIO1_INT4	45
> +#define MXC_INT_GPIO1_INT3	46
> +#define MXC_INT_GPIO1_INT2	47
> +#define MXC_INT_GPIO1_INT1	48
> +#define MXC_INT_GPIO1_INT0	49
> +#define MXC_INT_GPIO1_LOW	50
> +#define MXC_INT_GPIO1_HIGH	51
> +#define MXC_INT_GPIO2_LOW	52
> +#define MXC_INT_GPIO2_HIGH	53
> +#define MXC_INT_GPIO3_LOW	54
> +#define MXC_INT_GPIO3_HIGH	55
> +#define MXC_INT_GPIO4_LOW	56
> +#define MXC_INT_GPIO4_HIGH	57
> +#define MXC_INT_WDOG1		58
> +#define MXC_INT_WDOG2		59
> +#define MXC_INT_KPP		60
> +#define MXC_INT_PWM1		61
> +#define MXC_INT_I2C1		62
> +#define MXC_INT_I2C2		63
> +#define MXC_INT_HS_I2C		64
> +#define MXC_INT_RESV65		65
> +#define MXC_INT_RESV66		66
> +#define MXC_INT_SIM_IPB		67
> +#define MXC_INT_SIM_DAT		68
> +#define MXC_INT_IIM		69
> +#define MXC_INT_ATA		70
> +#define MXC_INT_CCM1		71
> +#define MXC_INT_CCM2		72
> +#define MXC_INT_GPC1		73
> +#define MXC_INT_GPC2		74
> +#define MXC_INT_SRC		75
> +#define MXC_INT_NM		76
> +#define MXC_INT_PMU		77
> +#define MXC_INT_CTI_IRQ		78
> +#define MXC_INT_CTI1_TG0	79
> +#define MXC_INT_CTI1_TG1	80
> +#define MXC_INT_MCG_ERR		81
> +#define MXC_INT_MCG_TMR		82
> +#define MXC_INT_MCG_FUNC	83
> +#define MXC_INT_GPU2_IRQ	84
> +#define MXC_INT_GPU2_BUSY	85
> +#define MXC_INT_RESV86		86
> +#define MXC_INT_FEC		87
> +#define MXC_INT_OWIRE		88
> +#define MXC_INT_CTI1_TG2	89
> +#define MXC_INT_SJC		90
> +#define MXC_INT_SPDIF		91
> +#define MXC_INT_TVE		92
> +#define MXC_INT_FIRI		93
> +#define MXC_INT_PWM2		94
> +#define MXC_INT_SLIM_EXP	95
> +#define MXC_INT_SSI3		96
> +#define MXC_INT_EMI_BOOT	97
> +#define MXC_INT_CTI1_TG3	98
> +#define MXC_INT_SMC_RX		99
> +#define MXC_INT_VPU_IDLE	100
> +#define MXC_INT_EMI_NFC		101
> +#define MXC_INT_GPU_IDLE	102
> +
> +/* silicon revisions specific to i.MX51 */
> +#define CHIP_REV_1_0          0x10
> +#define CHIP_REV_1_1          0x11
> +#define CHIP_REV_1_2          0x12
> +#define CHIP_REV_1_3          0x13
> +#define CHIP_REV_2_0          0x20
> +#define CHIP_REV_2_1          0x21
> +#define CHIP_REV_2_2          0x22
> +#define CHIP_REV_2_3          0x23
> +#define CHIP_REV_3_0          0x30
> +#define CHIP_REV_3_1          0x31
> +#define CHIP_REV_3_2          0x32
> +
> +/* Mandatory defines used globally */
> +
> +#if !defined(__ASSEMBLY__) && !defined(__MXC_BOOT_UNCOMPRESS)

Is __MXC_BOOT_UNCOMPRESS used anywhere? If not, please remove.

> +
> +extern unsigned int system_rev;
> +
> +static inline int mx51_revision(void)
> +{
> +	return system_rev;
> +}
> +#endif
> +
> +#endif	/*  __ASM_ARCH_MXC_MX51_H__ */
> -- 
> 1.6.3.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
