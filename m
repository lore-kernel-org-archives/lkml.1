Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0BCLEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:04:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36676 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0BCLEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:04:12 -0500
Date: Wed, 3 Feb 2010 12:04:08 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCHv2 05/11] mxc: Core support for i.MX5 series of
	processors from Freescale
Message-ID: <20100203110408.GO6130@pengutronix.de>
References: <cover.1265173480.git.amit.kucheria@canonical.com> <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 11:04:59 up 113 days, 22:54, 56 users,  load average: 1.02, 1.13,
	1.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:16:27PM -0800, Amit Kucheria wrote:
> From: Amit Kucheria <amit.kucheria@verdurent.com>
> 
> Add basic clock support, cpu identification, I/O mapping and serial port.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/clock.c                    |  848 ++++++++++++++++++++++++++
>  arch/arm/mach-mx5/cpu.c                      |   45 ++
>  arch/arm/mach-mx5/crm_regs.h                 |  583 ++++++++++++++++++
>  arch/arm/mach-mx5/devices.c                  |   96 +++
>  arch/arm/mach-mx5/devices.h                  |    4 +
>  arch/arm/mach-mx5/mm.c                       |   88 +++
>  arch/arm/plat-mxc/include/mach/common.h      |    1 +
>  arch/arm/plat-mxc/include/mach/debug-macro.S |    4 +-
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h  |  340 +++++++++++
>  arch/arm/plat-mxc/include/mach/mx51.h        |  454 ++++++++++++++
>  10 files changed, 2461 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/clock.c
>  create mode 100644 arch/arm/mach-mx5/cpu.c
>  create mode 100644 arch/arm/mach-mx5/crm_regs.h
>  create mode 100644 arch/arm/mach-mx5/devices.c
>  create mode 100644 arch/arm/mach-mx5/devices.h
>  create mode 100644 arch/arm/mach-mx5/mm.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx51.h
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx51.h
> 
> diff --git a/arch/arm/mach-mx5/clock.c b/arch/arm/mach-mx5/clock.c

Can we rename this file to clock-mx51.c? We made this mistake on other
i.MX platforms and ended with a clock.c and a clock-mx35.c in the same
directory.

> new file mode 100644
> index 0000000..595f966
> --- /dev/null
> +++ b/arch/arm/mach-mx5/clock.c
> @@ -0,0 +1,848 @@
> +/*
> + * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright (C) 2009-2010 Amit Kucheria <amit.kucheria@canonical.com>
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
> +static void __iomem *pll_base[] = {
> +	MX51_DPLL1_BASE,
> +	MX51_DPLL2_BASE,
> +	MX51_DPLL3_BASE,
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
> +#define MAX_DPLL_WAIT_TRIES	1000 /* 1000 * udelay(1) = 1ms */
> +
> +static int _clk_ccgr_enable(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(clk->enable_reg);
> +	reg |= MXC_CCM_CCGRx_MOD_ON << clk->enable_shift;
> +	__raw_writel(reg, clk->enable_reg);
> +
> +	return 0;
> +}
> +
> +static void _clk_ccgr_disable(struct clk *clk)
> +{
> +	u32 reg;
> +	reg = __raw_readl(clk->enable_reg);
> +	reg &= ~(MXC_CCM_CCGRx_MOD_OFF << clk->enable_shift);
> +	__raw_writel(reg, clk->enable_reg);
> +
> +}
> +
> +static void _clk_ccgr_disable_inwait(struct clk *clk)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(clk->enable_reg);
> +	reg &= ~(MXC_CCM_CCGRx_CG_MASK << clk->enable_shift);
> +	reg |= MXC_CCM_CCGRx_MOD_IDLE << clk->enable_shift;
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
> +	return -EINVAL;
> +}
> +
> +static inline void __iomem *_get_pll_base(struct clk *pll)
> +{
> +	if (pll == &pll1_main_clk)
> +		return pll_base[0];
> +	else if (pll == &pll2_sw_clk)
> +		return pll_base[1];
> +	else if (pll == &pll3_sw_clk)
> +		return pll_base[2];
> +	else

I see no purpose for the pll_base[] array. It is used only here and you
can return the values directly.

> +		BUG();
> +
> +	return NULL;
> +}
> +
> +static unsigned long clk_pll_get_rate(struct clk *clk)
> +{
> +	long mfi, mfn, mfd, pdf, ref_clk, mfn_abs;
> +	unsigned long dp_op, dp_mfd, dp_mfn, dp_ctl, pll_hfsm, dbl;
> +	void __iomem *pllbase;
> +	s64 temp;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	pllbase = _get_pll_base(clk);
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
> +	void __iomem *pllbase;
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
> +	temp64 = rate * (pdf+1) - quad_parent_rate * mfi;
> +	do_div(temp64, quad_parent_rate/1000000);
> +	mfn = (long)temp64;
> +
> +	dp_ctl = __raw_readl(pllbase + MXC_PLL_DP_CTL);
> +	/* use dpdck0_2 */
> +	__raw_writel(dp_ctl | 0x1000L, pllbase + MXC_PLL_DP_CTL);
> +	pll_hfsm = dp_ctl & MXC_PLL_DP_CTL_HFSM;
> +	if (pll_hfsm == 0) {
> +		reg = mfi << 4 | pdf;
> +		__raw_writel(reg, pllbase + MXC_PLL_DP_OP);
> +		__raw_writel(mfd, pllbase + MXC_PLL_DP_MFD);
> +		__raw_writel(mfn, pllbase + MXC_PLL_DP_MFN);
> +	} else {
> +		reg = mfi << 4 | pdf;
> +		__raw_writel(reg, pllbase + MXC_PLL_DP_HFS_OP);
> +		__raw_writel(mfd, pllbase + MXC_PLL_DP_HFS_MFD);
> +		__raw_writel(mfn, pllbase + MXC_PLL_DP_HFS_MFN);
> +	}
> +
> +	return 0;
> +}
> +
> +static int _clk_pll_enable(struct clk *clk)
> +{
> +	u32 reg;
> +	void __iomem *pllbase;
> +	int i = 0;
> +
> +	pllbase = _get_pll_base(clk);
> +	reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) | MXC_PLL_DP_CTL_UPEN;
> +	__raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> +
> +	/* Wait for lock */
> +	while ((!(__raw_readl(pllbase + MXC_PLL_DP_CTL) & MXC_PLL_DP_CTL_LRF))
> +		&& i < MAX_DPLL_WAIT_TRIES) {
> +		i++;
> +		udelay(1);
> +	}
> +
> +	if (i == MAX_DPLL_WAIT_TRIES) {
> +		printk(KERN_ERR "MX5: pll locking failed\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void _clk_pll_disable(struct clk *clk)
> +{
> +	u32 reg;
> +	void __iomem *pllbase;
> +
> +	pllbase = _get_pll_base(clk);
> +	reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) & ~MXC_PLL_DP_CTL_UPEN;
> +	__raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> +}
> +
> +static int _clk_pll1_sw_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(MXC_CCM_CCSR);
> +
> +	/* When switching from pll_main_clk to a bypass clock, first select a
> +	   multiplexed clock in 'step_sel', then shift the glitchless mux
> +	   'pll1_sw_clk_sel'.
> +	   When switching back, do it in reverse order
> +	*/
> +	if (parent == &pll1_main_clk) {
> +		/* Switch to pll1_main_clk */
> +		reg &= ~MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> +		__raw_writel(reg, MXC_CCM_CCSR);
> +		/* step_clk mux switched to lp_apm, to save power. */
> +		reg = __raw_readl(MXC_CCM_CCSR);
> +		reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +			(MXC_CCM_CCSR_STEP_SEL_LP_APM <<
> +				MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +	} else {
> +		if (parent == &lp_apm_clk) {
> +			reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +				(MXC_CCM_CCSR_STEP_SEL_LP_APM <<
> +					MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +		} else  if (parent == &pll2_sw_clk) {
> +			reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +				(MXC_CCM_CCSR_STEP_SEL_PLL2_DIVIDED <<
> +					MXC_CCM_CCSR_STEP_SEL_OFFSET);
> +		} else  if (parent == &pll3_sw_clk) {
> +			reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> +				(MXC_CCM_CCSR_STEP_SEL_PLL3_DIVIDED <<
> +					MXC_CCM_CCSR_STEP_SEL_OFFSET);

Can we write this as

			reg &= ~MXC_CCM_CCSR_STEP_SEL_MASK;
			reg |= MXC_CCM_CCSR_STEP_SEL_PLL3_DIVIDED <<
					MXC_CCM_CCSR_STEP_SEL_OFFSET;

At least for me this is much easier to read. Also, the &= part can be
outside the if clause.

> +		} else
> +			return -EINVAL;
> +
> +		__raw_writel(reg, MXC_CCM_CCSR);
> +		/* Switch to step_clk */
> +		reg = __raw_readl(MXC_CCM_CCSR);
> +		reg |= MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> +	}
> +	__raw_writel(reg, MXC_CCM_CCSR);
> +	return 0;
> +}
> +
> +static unsigned long clk_pll1_sw_get_rate(struct clk *clk)
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

This will return parent rate if the parent is not pll2_sw_clk and not
pll3_sw_clk. Is this intended? If yes, you could write

	} else
		div = 1;

to emphasize this is not an accident.


> +}
> +
> +static int _clk_pll2_sw_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(MXC_CCM_CCSR);
> +
> +	if (parent == &pll2_sw_clk)
> +		reg &= ~MXC_CCM_CCSR_PLL2_SW_CLK_SEL;
> +	else
> +		reg |= MXC_CCM_CCSR_PLL2_SW_CLK_SEL;

What's the other clock in the else part? I think there is a check
missing.

> +
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
> +static unsigned long clk_arm_get_rate(struct clk *clk)
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
> +	int i = 0;
> +
> +	mux = _get_mux(parent, &pll1_sw_clk, &pll3_sw_clk, &lp_apm_clk, NULL);
> +
> +	reg = __raw_readl(MXC_CCM_CBCMR) & ~MXC_CCM_CBCMR_PERIPH_CLK_SEL_MASK;
> +	reg |= mux << MXC_CCM_CBCMR_PERIPH_CLK_SEL_OFFSET;
> +	__raw_writel(reg, MXC_CCM_CBCMR);
> +
> +	/* Wait for lock */
> +	while ((__raw_readl(MXC_CCM_CDHIPR) & MXC_CCM_CDHIPR_PERIPH_CLK_SEL_BUSY)
> +		&& i < MAX_DPLL_WAIT_TRIES) {
> +		i++;
> +		udelay(1);
> +	}
> +
> +	if (i == MAX_DPLL_WAIT_TRIES) {
> +		printk(KERN_ERR "MX5: Set parent for periph_apm clock failed\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long clk_main_bus_get_rate(struct clk *clk)
> +{
> +	return clk_get_rate(clk->parent);
> +}

The generic code will automatically return the parent rate if the
get_rate field is set to NULL.

> +
> +static int _clk_main_bus_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(MXC_CCM_CBCDR);
> +
> +	if (parent == &pll2_sw_clk)
> +		reg &= ~MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> +	else if (parent == &periph_apm_clk)
> +		reg |= MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> +	else
> +		return -EINVAL;
> +
> +	__raw_writel(reg, MXC_CCM_CBCDR);
> +
> +	return 0;
> +}
> +

[snip]

> +
> +static void clk_tree_init(void)
> +{
> +	u32 reg;
> +
> +	ipg_perclk.set_parent(&ipg_perclk, &lp_apm_clk);

Something is wrong here. Here you set the ipg_perclk parent.
_clk_ipg_per_set_parent will then set the MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL
and MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL bits accordingly...

> +
> +	/*
> +	 * Initialise the IPG PER CLK dividers to 3. IPG_PER_CLK should be at
> +	 * 8MHz, its derived from lp_apm.
> +	 * FIXME: Verify if true for all boards
> +	 */
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

...And here you set the parent according to the register bits. What's
the intention here? Do you want to keep the bootloader settings or
do you want to overwrite them with a known value?

> +}
> +
> +int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
> +			unsigned long ckih1, unsigned long ckih2)
> +{
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
> +	mxc_timer_init(&gpt_clk, MX51_IO_ADDRESS(MX51_GPT1_BASE_ADDR),
> +		MX51_MXC_INT_GPT);
> +	return 0;
> +}
> diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
> new file mode 100644
> index 0000000..93f1d5a
> --- /dev/null
> +++ b/arch/arm/mach-mx5/cpu.c
> @@ -0,0 +1,45 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
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
> +	if (cpu_is_mx51()) {

	if (!cpu_is_mx51())
		return 0;

please. This way we have one indention level more in case this function
gets more complicated.


> +		base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> +		__raw_writel(0x0, base + 0x40);
> +		__raw_writel(0x0, base + 0x44);
> +		__raw_writel(0x0, base + 0x48);
> +		__raw_writel(0x0, base + 0x4C);
> +		reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +		__raw_writel(reg, base + 0x50);
> +
> +		base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> +		__raw_writel(0x0, base + 0x40);
> +		__raw_writel(0x0, base + 0x44);
> +		__raw_writel(0x0, base + 0x48);
> +		__raw_writel(0x0, base + 0x4C);
> +		reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +		__raw_writel(reg, base + 0x50);
> +	}
> +	return 0;
> +}
> +
> +postcore_initcall(post_cpu_init);
> diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
> new file mode 100644
> index 0000000..c776b9a
> --- /dev/null
> +++ b/arch/arm/mach-mx5/crm_regs.h

[snip]

> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> new file mode 100644
> index 0000000..55eb089
> --- /dev/null
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -0,0 +1,96 @@
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
> +		.start = MX51_UART1_BASE_ADDR,
> +		.end = MX51_UART1_BASE_ADDR + 0x0B5,

You can safely write MX51_UART1_BASE_ADDR + 0xfff here because that's
the register space this device actually has. The last register in the
datasheet is 0xb4 anyway and with 32bit register accesses the correct
value here would be 0xb7.

> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MX51_MXC_INT_UART1,
> +		.end = MX51_MXC_INT_UART1,
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
> +		.start = MX51_UART2_BASE_ADDR,
> +		.end = MX51_UART2_BASE_ADDR + 0x0B5,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MX51_MXC_INT_UART2,
> +		.end = MX51_MXC_INT_UART2,
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
> +		.start = MX51_UART3_BASE_ADDR,
> +		.end = MX51_UART3_BASE_ADDR + 0x0B5,
> +		.flags = IORESOURCE_MEM,
> +	}, {
> +		.start = MX51_MXC_INT_UART3,
> +		.end = MX51_MXC_INT_UART3,
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
> +		.start	= MX51_MXC_FEC_BASE_ADDR,
> +		.end	= MX51_MXC_FEC_BASE_ADDR + 0xfff,
> +		.flags	= IORESOURCE_MEM,
> +	}, {
> +		.start	= MX51_MXC_INT_FEC,
> +		.end	= MX51_MXC_INT_FEC,
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
> +
> +/* Dummy definition to allow compiling in AVIC and TZIC simultaneously */
> +int __init mxc_register_gpios(void)
> +{
> +	return 0;
> +}
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
> index 0000000..d66c31a
> --- /dev/null
> +++ b/arch/arm/mach-mx5/mm.c
> @@ -0,0 +1,88 @@
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
> +
> +#include <asm/mach/map.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/common.h>
> +#include <mach/iomux-v3.h>
> +
> +/*
> + * Define the MX51 memory map.
> + */
> +static struct map_desc mxc_io_desc[] __initdata = {
> +	{
> +	 .virtual = MX51_IRAM_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_IRAM_BASE_ADDR),
> +	 .length = MX51_IRAM_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_DEBUG_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_DEBUG_BASE_ADDR),
> +	 .length = MX51_DEBUG_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_TZIC_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_TZIC_BASE_ADDR),
> +	 .length = MX51_TZIC_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_AIPS1_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_AIPS1_BASE_ADDR),
> +	 .length = MX51_AIPS1_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_SPBA0_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_SPBA0_BASE_ADDR),
> +	 .length = MX51_SPBA0_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_AIPS2_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_AIPS2_BASE_ADDR),
> +	 .length = MX51_AIPS2_SIZE,
> +	 .type = MT_DEVICE},
> +	{
> +	 .virtual = MX51_NFC_AXI_BASE_ADDR_VIRT,
> +	 .pfn = __phys_to_pfn(MX51_NFC_AXI_BASE_ADDR),
> +	 .length = MX51_NFC_AXI_SIZE,
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
> +
> +	if (mx51_revision() < MX51_CHIP_REV_2_0)
> +		tzic_addr = 0x8FFFC000;
> +	else
> +		tzic_addr = 0xE0003000;
> +	mxc_io_desc[2].pfn =  __phys_to_pfn(tzic_addr);
> +
> +	mxc_set_cpu_type(MXC_CPU_MX51);
> +	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
> +	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG_BASE_ADDR));
> +	iotable_init(mxc_io_desc, ARRAY_SIZE(mxc_io_desc));
> +}
> +
> +void __init mx51_init_irq(void)
> +{
> +	tzic_init_irq(MX51_IO_ADDRESS(MX51_TZIC_BASE_ADDR));
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
> index 5250a3f..0a25576 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -30,6 +30,7 @@ extern void mx25_init_irq(void);
>  extern void mx27_init_irq(void);
>  extern void mx31_init_irq(void);
>  extern void mx35_init_irq(void);
> +extern void mx51_init_irq(void);
>  extern void mxc91231_init_irq(void);
>  extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
>  extern int mx1_clocks_init(unsigned long fref);
> diff --git a/arch/arm/plat-mxc/include/mach/debug-macro.S b/arch/arm/plat-mxc/include/mach/debug-macro.S
> index 9fe7300..9d41bfd 100644
> --- a/arch/arm/plat-mxc/include/mach/debug-macro.S
> +++ b/arch/arm/plat-mxc/include/mach/debug-macro.S
> @@ -49,8 +49,8 @@
>  #error "CONFIG_DEBUG_LL is incompatible with multiple archs"
>  #endif
>  #include <mach/mx51.h>
> -#define UART_PADDR	UART1_BASE_ADDR
> -#define UART_VADDR	AIPS1_IO_ADDRESS(UART1_BASE_ADDR)
> +#define UART_PADDR	MX51_UART1_BASE_ADDR
> +#define UART_VADDR	MX51_AIPS1_IO_ADDRESS(MX51_UART1_BASE_ADDR)
>  #endif
>  
>  #ifdef CONFIG_ARCH_MXC91231
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> new file mode 100644
> index 0000000..14df0f5
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -0,0 +1,340 @@
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
> +/* Pad control groupings */
> +#define MX51_UART1_PAD_CTRL	(PAD_CTL_HYS | PAD_CTL_PKE | PAD_CTL_PUE | \
> +				PAD_CTL_DSE_HIGH)
> +#define MX51_UART2_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_PUE | PAD_CTL_DSE_HIGH | \
> +				PAD_CTL_SRE_FAST)
> +#define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | \
> +				PAD_CTL_SRE_FAST)
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
> +
> +/* UART1 */
> +#define MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD	\
> +	IOMUX_PAD(0x618, 0x228,	IOMUX_CONFIG_ALT0, 0x9e4, 0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
> +#define MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD	\
> +	IOMUX_PAD(0x61C, 0x22C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
> +#define MX51_BABBAGE_PAD_UART1_RTS__UART1_RTS	\
> +	IOMUX_PAD(0x620, 0x230, IOMUX_CONFIG_ALT0, 0x9e0, 0, MX51_UART1_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_UART1_CTS__UART1_CTS	\
> +	IOMUX_PAD(0x624, 0x234, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_UART1_PAD_CTRL)

I remember last time I said that you should move these macros here. I
think the situation is like this:

1) These are either known good values for the uart pins and therefore
   shouldn't have BABBAGE in their name.
2) There is something babbage specific in them, in this case they should
   be in the board specific file.

I vote for 1) here.

> +
> +/* UART2 */
> +#define MX51_BABBAGE_PAD_UART2_RXD__UART2_RXD	IOMUX_PAD(0x628, 0x238, IOMUX_CONFIG_ALT0, 0x9ec, 2, MX51_UART2_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_UART2_TXD__UART2_TXD	IOMUX_PAD(0x62C, 0x23C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_UART2_PAD_CTRL)
> +
> +/* UART3 */
> +#define MX51_BABBAGE_PAD_EIM_D25__UART3_RXD	IOMUX_PAD(0x414, 0x080, IOMUX_CONFIG_ALT3, 0x9f4, 0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D26__UART3_TXD	IOMUX_PAD(0x418, 0x084, IOMUX_CONFIG_ALT3, 0x0, 0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D27__UART3_RTS	IOMUX_PAD(0x41c, 0x088, IOMUX_CONFIG_ALT3, 0x9f0, 0, MX51_UART3_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_D24__UART3_CTS	IOMUX_PAD(0x410, 0x07c, IOMUX_CONFIG_ALT3, 0x0, 0, MX51_UART3_PAD_CTRL)
> +
> +#define MX51_BABBAGE_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 1, (PAD_CTL_SRE_SLOW | PAD_CTL_DSE_MED | PAD_CTL_PUS_100K_UP |  PAD_CTL_HYS))
> +

ditto

 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
