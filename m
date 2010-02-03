Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0BCOU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:20:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43751 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0BCOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:20:25 -0500
Date: Wed, 3 Feb 2010 06:20:15 -0800
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 05/11] mxc: Core support for i.MX5 series of
 processors from Freescale
Message-ID: <20100203142015.GE5252@k2>
Mail-Followup-To: Eric Miao <eric.y.miao@gmail.com>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
	s.hauer@pengutronix.de, grant.likely@secretlab.ca,
	r.herring@freescale.com, linux-arm-kernel@lists.infradead.org,
	daniel@caiaq.de, bryan.wu@canonical.com, valentin.longchamp@epfl.ch
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
 <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
 <cover.1265173480.git.amit.kucheria@canonical.com>
 <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
 <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
 <f17812d71002022303m2fb0ba5cmb6cdac6bccbadde6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d71002022303m2fb0ba5cmb6cdac6bccbadde6@mail.gmail.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Feb 02, Eric Miao wrote:
> On Tue, Feb 2, 2010 at 9:16 PM, Amit Kucheria
> <amit.kucheria@canonical.com> wrote:
> > From: Amit Kucheria <amit.kucheria@verdurent.com>
> >
> > Add basic clock support, cpu identification, I/O mapping and serial port.
> >
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/mach-mx5/clock.c                    |  848 ++++++++++++++++++++++++++
> >  arch/arm/mach-mx5/cpu.c                      |   45 ++
> >  arch/arm/mach-mx5/crm_regs.h                 |  583 ++++++++++++++++++
> >  arch/arm/mach-mx5/devices.c                  |   96 +++
> >  arch/arm/mach-mx5/devices.h                  |    4 +
> >  arch/arm/mach-mx5/mm.c                       |   88 +++
> >  arch/arm/plat-mxc/include/mach/common.h      |    1 +
> >  arch/arm/plat-mxc/include/mach/debug-macro.S |    4 +-
> >  arch/arm/plat-mxc/include/mach/iomux-mx51.h  |  340 +++++++++++
> >  arch/arm/plat-mxc/include/mach/mx51.h        |  454 ++++++++++++++
> >  10 files changed, 2461 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm/mach-mx5/clock.c
> >  create mode 100644 arch/arm/mach-mx5/cpu.c
> >  create mode 100644 arch/arm/mach-mx5/crm_regs.h
> >  create mode 100644 arch/arm/mach-mx5/devices.c
> >  create mode 100644 arch/arm/mach-mx5/devices.h
> >  create mode 100644 arch/arm/mach-mx5/mm.c
> >  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx51.h
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx51.h
> >
> > diff --git a/arch/arm/mach-mx5/clock.c b/arch/arm/mach-mx5/clock.c
> > new file mode 100644
> > index 0000000..595f966
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/clock.c
> > @@ -0,0 +1,848 @@
> > +/*
> > + * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
> > + * Copyright (C) 2009-2010 Amit Kucheria <amit.kucheria@canonical.com>
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> > +#include <linux/mm.h>
> > +#include <linux/delay.h>
> > +#include <linux/clk.h>
> > +#include <linux/io.h>
> > +
> > +#include <asm/clkdev.h>
> > +
> > +#include <mach/hardware.h>
> > +#include <mach/common.h>
> > +#include <mach/clock.h>
> > +
> > +#include "crm_regs.h"
> > +
> > +static void __iomem *pll_base[] = {
> > +       MX51_DPLL1_BASE,
> > +       MX51_DPLL2_BASE,
> > +       MX51_DPLL3_BASE,
> > +};
> > +
> > +/* External clock values passed-in by the board code */
> > +static unsigned long external_high_reference, external_low_reference;
> > +static unsigned long oscillator_reference, ckih2_reference;
> > +
> > +static struct clk osc_clk;
> > +static struct clk pll1_main_clk;
> > +static struct clk pll1_sw_clk;
> > +static struct clk pll2_sw_clk;
> > +static struct clk pll3_sw_clk;
> > +static struct clk lp_apm_clk;
> > +static struct clk periph_apm_clk;
> > +static struct clk ahb_clk;
> > +static struct clk ipg_clk;
> > +
> > +#define MAX_DPLL_WAIT_TRIES    1000 /* 1000 * udelay(1) = 1ms */
> > +
> > +static int _clk_ccgr_enable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(clk->enable_reg);
> > +       reg |= MXC_CCM_CCGRx_MOD_ON << clk->enable_shift;
> > +       __raw_writel(reg, clk->enable_reg);
> > +
> > +       return 0;
> > +}
> > +
> > +static void _clk_ccgr_disable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +       reg = __raw_readl(clk->enable_reg);
> > +       reg &= ~(MXC_CCM_CCGRx_MOD_OFF << clk->enable_shift);
> > +       __raw_writel(reg, clk->enable_reg);
> > +
> > +}
> > +
> > +static void _clk_ccgr_disable_inwait(struct clk *clk)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(clk->enable_reg);
> > +       reg &= ~(MXC_CCM_CCGRx_CG_MASK << clk->enable_shift);
> > +       reg |= MXC_CCM_CCGRx_MOD_IDLE << clk->enable_shift;
> > +       __raw_writel(reg, clk->enable_reg);
> > +}
> > +
> > +/*
> > + * For the 4-to-1 muxed input clock
> > + */
> > +static inline u32 _get_mux(struct clk *parent, struct clk *m0,
> > +                          struct clk *m1, struct clk *m2, struct clk *m3)
> > +{
> > +       if (parent == m0)
> > +               return 0;
> > +       else if (parent == m1)
> > +               return 1;
> > +       else if (parent == m2)
> > +               return 2;
> > +       else if (parent == m3)
> > +               return 3;
> > +       else
> > +               BUG();
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static inline void __iomem *_get_pll_base(struct clk *pll)
> > +{
> > +       if (pll == &pll1_main_clk)
> > +               return pll_base[0];
> > +       else if (pll == &pll2_sw_clk)
> > +               return pll_base[1];
> > +       else if (pll == &pll3_sw_clk)
> > +               return pll_base[2];
> > +       else
> > +               BUG();
> > +
> > +       return NULL;
> > +}
> > +
> > +static unsigned long clk_pll_get_rate(struct clk *clk)
> > +{
> > +       long mfi, mfn, mfd, pdf, ref_clk, mfn_abs;
> > +       unsigned long dp_op, dp_mfd, dp_mfn, dp_ctl, pll_hfsm, dbl;
> > +       void __iomem *pllbase;
> > +       s64 temp;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       pllbase = _get_pll_base(clk);
> > +
> > +       dp_ctl = __raw_readl(pllbase + MXC_PLL_DP_CTL);
> > +       pll_hfsm = dp_ctl & MXC_PLL_DP_CTL_HFSM;
> > +       dbl = dp_ctl & MXC_PLL_DP_CTL_DPDCK0_2_EN;
> > +
> > +       if (pll_hfsm == 0) {
> > +               dp_op = __raw_readl(pllbase + MXC_PLL_DP_OP);
> > +               dp_mfd = __raw_readl(pllbase + MXC_PLL_DP_MFD);
> > +               dp_mfn = __raw_readl(pllbase + MXC_PLL_DP_MFN);
> > +       } else {
> > +               dp_op = __raw_readl(pllbase + MXC_PLL_DP_HFS_OP);
> > +               dp_mfd = __raw_readl(pllbase + MXC_PLL_DP_HFS_MFD);
> > +               dp_mfn = __raw_readl(pllbase + MXC_PLL_DP_HFS_MFN);
> > +       }
> > +       pdf = dp_op & MXC_PLL_DP_OP_PDF_MASK;
> > +       mfi = (dp_op & MXC_PLL_DP_OP_MFI_MASK) >> MXC_PLL_DP_OP_MFI_OFFSET;
> > +       mfi = (mfi <= 5) ? 5 : mfi;
> > +       mfd = dp_mfd & MXC_PLL_DP_MFD_MASK;
> > +       mfn = mfn_abs = dp_mfn & MXC_PLL_DP_MFN_MASK;
> > +       /* Sign extend to 32-bits */
> > +       if (mfn >= 0x04000000) {
> > +               mfn |= 0xFC000000;
> > +               mfn_abs = -mfn;
> > +       }
> > +
> > +       ref_clk = 2 * parent_rate;
> > +       if (dbl != 0)
> > +               ref_clk *= 2;
> > +
> > +       ref_clk /= (pdf + 1);
> > +       temp = (u64) ref_clk * mfn_abs;
> > +       do_div(temp, mfd + 1);
> > +       if (mfn < 0)
> > +               temp = -temp;
> > +       temp = (ref_clk * mfi) + temp;
> > +
> > +       return temp;
> > +}
> > +
> > +static int _clk_pll_set_rate(struct clk *clk, unsigned long rate)
> > +{
> > +       u32 reg;
> > +       void __iomem *pllbase;
> > +
> > +       long mfi, pdf, mfn, mfd = 999999;
> > +       s64 temp64;
> > +       unsigned long quad_parent_rate;
> > +       unsigned long pll_hfsm, dp_ctl;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       pllbase = _get_pll_base(clk);
> > +
> > +       quad_parent_rate = 4 * parent_rate;
> > +       pdf = mfi = -1;
> > +       while (++pdf < 16 && mfi < 5)
> > +               mfi = rate * (pdf+1) / quad_parent_rate;
> > +       if (mfi > 15)
> > +               return -1;
> > +       pdf--;
> > +
> > +       temp64 = rate * (pdf+1) - quad_parent_rate * mfi;
> > +       do_div(temp64, quad_parent_rate/1000000);
> > +       mfn = (long)temp64;
> > +
> > +       dp_ctl = __raw_readl(pllbase + MXC_PLL_DP_CTL);
> > +       /* use dpdck0_2 */
> > +       __raw_writel(dp_ctl | 0x1000L, pllbase + MXC_PLL_DP_CTL);
> > +       pll_hfsm = dp_ctl & MXC_PLL_DP_CTL_HFSM;
> > +       if (pll_hfsm == 0) {
> > +               reg = mfi << 4 | pdf;
> > +               __raw_writel(reg, pllbase + MXC_PLL_DP_OP);
> > +               __raw_writel(mfd, pllbase + MXC_PLL_DP_MFD);
> > +               __raw_writel(mfn, pllbase + MXC_PLL_DP_MFN);
> > +       } else {
> > +               reg = mfi << 4 | pdf;
> > +               __raw_writel(reg, pllbase + MXC_PLL_DP_HFS_OP);
> > +               __raw_writel(mfd, pllbase + MXC_PLL_DP_HFS_MFD);
> > +               __raw_writel(mfn, pllbase + MXC_PLL_DP_HFS_MFN);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int _clk_pll_enable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +       void __iomem *pllbase;
> > +       int i = 0;
> > +
> > +       pllbase = _get_pll_base(clk);
> > +       reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) | MXC_PLL_DP_CTL_UPEN;
> > +       __raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> > +
> > +       /* Wait for lock */
> > +       while ((!(__raw_readl(pllbase + MXC_PLL_DP_CTL) & MXC_PLL_DP_CTL_LRF))
> > +               && i < MAX_DPLL_WAIT_TRIES) {
> > +               i++;
> > +               udelay(1);
> > +       }
> 
> 
> Mmm... this really hurts my eyes:
> 
> 	
> 	do {
> 		v = __raw_readl(pllbase + MXC_PLL_DP_CTL)
> 		if (v & MXC_PLL_DP_CTL_LRF)
> 			break;
> 		
> 		udelay(1);
> 	} while (++i < MAX_DPLL_WAIT_TRIES);

(Shrug) I picked it up from OMAP code. But your style is better.

> > +
> > +       if (i == MAX_DPLL_WAIT_TRIES) {
> > +               printk(KERN_ERR "MX5: pll locking failed\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void _clk_pll_disable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +       void __iomem *pllbase;
> > +
> > +       pllbase = _get_pll_base(clk);
> > +       reg = __raw_readl(pllbase + MXC_PLL_DP_CTL) & ~MXC_PLL_DP_CTL_UPEN;
> > +       __raw_writel(reg, pllbase + MXC_PLL_DP_CTL);
> > +}
> > +
> > +static int _clk_pll1_sw_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(MXC_CCM_CCSR);
> > +
> > +       /* When switching from pll_main_clk to a bypass clock, first select a
> > +          multiplexed clock in 'step_sel', then shift the glitchless mux
> > +          'pll1_sw_clk_sel'.
> > +          When switching back, do it in reverse order
> > +       */
> 
> comment style ... not sure if this leaks apw's checkscripts, heh :)

The patch was checkpatch approved ;)
But will fix.

> > +       if (parent == &pll1_main_clk) {
> > +               /* Switch to pll1_main_clk */
> > +               reg &= ~MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> > +               __raw_writel(reg, MXC_CCM_CCSR);
> > +               /* step_clk mux switched to lp_apm, to save power. */
> > +               reg = __raw_readl(MXC_CCM_CCSR);
> > +               reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> > +                       (MXC_CCM_CCSR_STEP_SEL_LP_APM <<
> > +                               MXC_CCM_CCSR_STEP_SEL_OFFSET);
> > +       } else {
> > +               if (parent == &lp_apm_clk) {
> > +                       reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> > +                               (MXC_CCM_CCSR_STEP_SEL_LP_APM <<
> > +                                       MXC_CCM_CCSR_STEP_SEL_OFFSET);
> > +               } else  if (parent == &pll2_sw_clk) {
> > +                       reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> > +                               (MXC_CCM_CCSR_STEP_SEL_PLL2_DIVIDED <<
> > +                                       MXC_CCM_CCSR_STEP_SEL_OFFSET);
> > +               } else  if (parent == &pll3_sw_clk) {
> > +                       reg = (reg & ~MXC_CCM_CCSR_STEP_SEL_MASK) |
> > +                               (MXC_CCM_CCSR_STEP_SEL_PLL3_DIVIDED <<
> > +                                       MXC_CCM_CCSR_STEP_SEL_OFFSET);
> > +               } else
> > +                       return -EINVAL;
> 
> Again, hurts my eyes:
> 
> 		if (...)
> 			step = MXC_CCM_CCSR_STEP_SEL_LP_APM;
> 		else if (...)
> 			step = MXC_CCM_CCSR_STEP_SEL_PLL2_DIVIDED;
> 		else if (...)
> 			step = ...
> 
> 		reg &= ~MXC_CCM_CCSR_STEP_SEL_MASK;
> 		reg |= step << MXC_CCM_CCSR_STEP_SEL_OFFSET;
> 		...

Fixed.

> > +
> > +               __raw_writel(reg, MXC_CCM_CCSR);
> > +               /* Switch to step_clk */
> > +               reg = __raw_readl(MXC_CCM_CCSR);
> > +               reg |= MXC_CCM_CCSR_PLL1_SW_CLK_SEL;
> > +       }
> > +       __raw_writel(reg, MXC_CCM_CCSR);
> > +       return 0;
> > +}
> > +
> > +static unsigned long clk_pll1_sw_get_rate(struct clk *clk)
> > +{
> > +       u32 reg, div;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       div = 1;
> > +       reg = __raw_readl(MXC_CCM_CCSR);
> > +
> > +       if (clk->parent == &pll2_sw_clk) {
> > +               div = ((reg & MXC_CCM_CCSR_PLL2_PODF_MASK) >>
> > +                      MXC_CCM_CCSR_PLL2_PODF_OFFSET) + 1;
> > +       } else if (clk->parent == &pll3_sw_clk) {
> > +               div = ((reg & MXC_CCM_CCSR_PLL3_PODF_MASK) >>
> > +                      MXC_CCM_CCSR_PLL3_PODF_OFFSET) + 1;
> > +       }
> > +       return parent_rate / div;
> > +}
> > +
> > +static int _clk_pll2_sw_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(MXC_CCM_CCSR);
> > +
> > +       if (parent == &pll2_sw_clk)
> > +               reg &= ~MXC_CCM_CCSR_PLL2_SW_CLK_SEL;
> > +       else
> > +               reg |= MXC_CCM_CCSR_PLL2_SW_CLK_SEL;
> > +
> > +       __raw_writel(reg, MXC_CCM_CCSR);
> > +       return 0;
> > +}
> > +
> > +static int _clk_lp_apm_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg;
> > +
> > +       if (parent == &osc_clk)
> > +               reg = __raw_readl(MXC_CCM_CCSR) & ~MXC_CCM_CCSR_LP_APM_SEL;
> > +       else
> > +               return -EINVAL;
> > +
> > +       __raw_writel(reg, MXC_CCM_CCSR);
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long clk_arm_get_rate(struct clk *clk)
> > +{
> > +       u32 cacrr, div;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +       cacrr = __raw_readl(MXC_CCM_CACRR);
> > +       div = (cacrr & MXC_CCM_CACRR_ARM_PODF_MASK) + 1;
> > +
> > +       return parent_rate / div;
> > +}
> > +
> > +static int _clk_periph_apm_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg, mux;
> > +       int i = 0;
> > +
> > +       mux = _get_mux(parent, &pll1_sw_clk, &pll3_sw_clk, &lp_apm_clk, NULL);
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCMR) & ~MXC_CCM_CBCMR_PERIPH_CLK_SEL_MASK;
> > +       reg |= mux << MXC_CCM_CBCMR_PERIPH_CLK_SEL_OFFSET;
> > +       __raw_writel(reg, MXC_CCM_CBCMR);
> > +
> > +       /* Wait for lock */
> > +       while ((__raw_readl(MXC_CCM_CDHIPR) & MXC_CCM_CDHIPR_PERIPH_CLK_SEL_BUSY)
> > +               && i < MAX_DPLL_WAIT_TRIES) {
> > +               i++;
> > +               udelay(1);
> > +       }
> > +
> > +       if (i == MAX_DPLL_WAIT_TRIES) {
> > +               printk(KERN_ERR "MX5: Set parent for periph_apm clock failed\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long clk_main_bus_get_rate(struct clk *clk)
> > +{
> > +       return clk_get_rate(clk->parent);
> > +}
> > +
> > +static int _clk_main_bus_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCDR);
> > +
> > +       if (parent == &pll2_sw_clk)
> > +               reg &= ~MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> > +       else if (parent == &periph_apm_clk)
> > +               reg |= MXC_CCM_CBCDR_PERIPH_CLK_SEL;
> > +       else
> > +               return -EINVAL;
> > +
> > +       __raw_writel(reg, MXC_CCM_CBCDR);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct clk main_bus_clk = {
> > +       .parent = &pll2_sw_clk,
> > +       .set_parent = _clk_main_bus_set_parent,
> > +       .get_rate = clk_main_bus_get_rate,
> > +};
> > +
> > +static unsigned long clk_ahb_get_rate(struct clk *clk)
> > +{
> > +       u32 reg, div;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCDR);
> > +       div = ((reg & MXC_CCM_CBCDR_AHB_PODF_MASK) >>
> > +              MXC_CCM_CBCDR_AHB_PODF_OFFSET) + 1;
> > +       return parent_rate / div;
> > +}
> > +
> > +
> > +static int _clk_ahb_set_rate(struct clk *clk, unsigned long rate)
> > +{
> > +       u32 reg, div;
> > +       unsigned long parent_rate;
> > +       int i = 0;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       div = parent_rate / rate;
> > +       if (div > 8 || div < 1 || ((parent_rate / div) != rate))
> > +               return -EINVAL;
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCDR);
> > +       reg &= ~MXC_CCM_CBCDR_AHB_PODF_MASK;
> > +       reg |= (div - 1) << MXC_CCM_CBCDR_AHB_PODF_OFFSET;
> > +       __raw_writel(reg, MXC_CCM_CBCDR);
> > +
> > +       /* Wait for lock */
> > +       while ((__raw_readl(MXC_CCM_CDHIPR) & MXC_CCM_CDHIPR_AHB_PODF_BUSY)
> > +               && i < MAX_DPLL_WAIT_TRIES) {
> > +               i++;
> > +               udelay(1);
> > +       }
> 
> Provided this loop sequence appears so many times here, maybe we can just
> invent a static inline function for this, e.g. dpll_wait_flags(register, flags)

Will investigate.

> > +
> > +       if (i == MAX_DPLL_WAIT_TRIES) {
> > +               printk(KERN_ERR "MX5: clk_ahb_set_rate failed\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long _clk_ahb_round_rate(struct clk *clk,
> > +                                               unsigned long rate)
> > +{
> > +       u32 div;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       div = parent_rate / rate;
> > +       if (div > 8)
> > +               div = 8;
> > +       else if (div == 0)
> > +               div++;
> > +       return parent_rate / div;
> > +}
> > +
> > +
> > +static int _clk_max_enable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +
> > +       _clk_ccgr_enable(clk);
> > +
> > +       /* Handshake with MAX when LPM is entered. */
> > +       reg = __raw_readl(MXC_CCM_CLPCR);
> > +       reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> > +       __raw_writel(reg, MXC_CCM_CLPCR);
> > +
> > +       return 0;
> > +}
> > +
> > +static void _clk_max_disable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +
> > +       _clk_ccgr_disable_inwait(clk);
> > +
> > +       /* No Handshake with MAX when LPM is entered as its disabled. */
> > +       reg = __raw_readl(MXC_CCM_CLPCR);
> > +       reg |= MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> > +       __raw_writel(reg, MXC_CCM_CLPCR);
> > +}
> > +
> > +static unsigned long clk_ipg_get_rate(struct clk *clk)
> > +{
> > +       u32 reg, div;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCDR);
> > +       div = ((reg & MXC_CCM_CBCDR_IPG_PODF_MASK) >>
> > +              MXC_CCM_CBCDR_IPG_PODF_OFFSET) + 1;
> > +
> > +       return parent_rate / div;
> > +}
> > +
> > +static unsigned long clk_ipg_per_get_rate(struct clk *clk)
> > +{
> > +       u32 reg, prediv1, prediv2, podf;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       if (clk->parent == &main_bus_clk || clk->parent == &lp_apm_clk) {
> > +               /* the main_bus_clk is the one before the DVFS engine */
> > +               reg = __raw_readl(MXC_CCM_CBCDR);
> > +               prediv1 = ((reg & MXC_CCM_CBCDR_PERCLK_PRED1_MASK) >>
> > +                          MXC_CCM_CBCDR_PERCLK_PRED1_OFFSET) + 1;
> > +               prediv2 = ((reg & MXC_CCM_CBCDR_PERCLK_PRED2_MASK) >>
> > +                          MXC_CCM_CBCDR_PERCLK_PRED2_OFFSET) + 1;
> > +               podf = ((reg & MXC_CCM_CBCDR_PERCLK_PODF_MASK) >>
> > +                       MXC_CCM_CBCDR_PERCLK_PODF_OFFSET) + 1;
> > +               return parent_rate / (prediv1 * prediv2 * podf);
> > +       } else if (clk->parent == &ipg_clk) {
> > +               return parent_rate;
> 
> unnecessary braces
> 
> > +       } else {
> > +               BUG();
> 
> ditto
> 
> > +       }
> > +}
> > +
> > +static int _clk_ipg_per_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg;
> > +
> > +       reg = __raw_readl(MXC_CCM_CBCMR);
> > +
> > +       reg &= ~MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
> > +       reg &= ~MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;
> > +
> > +       if (parent == &ipg_clk)
> > +               reg |= MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL;
> > +       else if (parent == &lp_apm_clk)
> > +               reg |= MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL;
> > +       else if (parent != &main_bus_clk)
> > +               return -EINVAL;
> > +
> > +       __raw_writel(reg, MXC_CCM_CBCMR);
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long clk_uart_get_rate(struct clk *clk)
> > +{
> > +       u32 reg, prediv, podf;
> > +       unsigned long parent_rate;
> > +
> > +       parent_rate = clk_get_rate(clk->parent);
> > +
> > +       reg = __raw_readl(MXC_CCM_CSCDR1);
> > +       prediv = ((reg & MXC_CCM_CSCDR1_UART_CLK_PRED_MASK) >>
> > +                 MXC_CCM_CSCDR1_UART_CLK_PRED_OFFSET) + 1;
> > +       podf = ((reg & MXC_CCM_CSCDR1_UART_CLK_PODF_MASK) >>
> > +               MXC_CCM_CSCDR1_UART_CLK_PODF_OFFSET) + 1;
> > +
> > +       return parent_rate / (prediv * podf);
> > +}
> > +
> > +static int _clk_uart_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +       u32 reg, mux;
> > +
> > +       mux = _get_mux(parent, &pll1_sw_clk, &pll2_sw_clk, &pll3_sw_clk,
> > +                      &lp_apm_clk);
> > +       reg = __raw_readl(MXC_CCM_CSCMR1) & ~MXC_CCM_CSCMR1_UART_CLK_SEL_MASK;
> > +       reg |= mux << MXC_CCM_CSCMR1_UART_CLK_SEL_OFFSET;
> > +       __raw_writel(reg, MXC_CCM_CSCMR1);
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long get_high_reference_clock_rate(struct clk *clk)
> > +{
> > +       return external_high_reference;
> > +}
> > +
> > +static unsigned long get_low_reference_clock_rate(struct clk *clk)
> > +{
> > +       return external_low_reference;
> > +}
> > +
> > +static unsigned long get_oscillator_reference_clock_rate(struct clk *clk)
> > +{
> > +       return oscillator_reference;
> > +}
> > +
> > +static unsigned long get_ckih2_reference_clock_rate(struct clk *clk)
> > +{
> > +       return ckih2_reference;
> > +}
> > +
> > +/* External high frequency clock */
> > +static struct clk ckih_clk = {
> > +       .get_rate = get_high_reference_clock_rate,
> > +};
> > +
> > +static struct clk ckih2_clk = {
> > +       .get_rate = get_ckih2_reference_clock_rate,
> > +};
> > +
> > +static struct clk osc_clk = {
> > +       .get_rate = get_oscillator_reference_clock_rate,
> > +};
> > +
> > +/* External low frequency (32kHz) clock */
> > +static struct clk ckil_clk = {
> > +       .get_rate = get_low_reference_clock_rate,
> > +};
> 
> That's why Jerremy is coming up with a clk_fixed, to address exactly such
> awkward situations :)
 
Heh, yes :)

> > +
> > +static struct clk pll1_main_clk = {
> > +       .parent = &osc_clk,
> > +       .get_rate = clk_pll_get_rate,
> > +       .enable = _clk_pll_enable,
> > +       .disable = _clk_pll_disable,
> > +};
> > +
> > +/* Clock tree block diagram (WIP):
> > + *     CCM: Clock Controller Module
> > + *
> > + * PLL output -> |
> > + *               | CCM Switcher -> CCM_CLK_ROOT_GEN ->
> > + * PLL bypass -> |
> > + *
> > + */
> > +
> > +/* PLL1 SW supplies to ARM core */
> > +static struct clk pll1_sw_clk = {
> > +       .parent = &pll1_main_clk,
> > +       .set_parent = _clk_pll1_sw_set_parent,
> > +       .get_rate = clk_pll1_sw_get_rate,
> > +};
> > +
> > +/* PLL2 SW supplies to AXI/AHB/IP buses */
> > +static struct clk pll2_sw_clk = {
> > +       .parent = &osc_clk,
> > +       .get_rate = clk_pll_get_rate,
> > +       .set_rate = _clk_pll_set_rate,
> > +       .set_parent = _clk_pll2_sw_set_parent,
> > +       .enable = _clk_pll_enable,
> > +       .disable = _clk_pll_disable,
> > +};
> > +
> > +/* PLL3 SW supplies to serial clocks like USB, SSI, etc. */
> > +static struct clk pll3_sw_clk = {
> > +       .parent = &osc_clk,
> > +       .set_rate = _clk_pll_set_rate,
> > +       .get_rate = clk_pll_get_rate,
> > +       .enable = _clk_pll_enable,
> > +       .disable = _clk_pll_disable,
> > +};
> > +
> > +/* Low-power Audio Playback Mode clock */
> > +static struct clk lp_apm_clk = {
> > +       .parent = &osc_clk,
> > +       .set_parent = _clk_lp_apm_set_parent,
> > +};
> > +
> > +static struct clk periph_apm_clk = {
> > +       .parent = &pll1_sw_clk,
> > +       .set_parent = _clk_periph_apm_set_parent,
> > +};
> > +
> > +static struct clk cpu_clk = {
> > +       .parent = &pll1_sw_clk,
> > +       .get_rate = clk_arm_get_rate,
> > +};
> > +
> > +static struct clk ahb_clk = {
> > +       .parent = &main_bus_clk,
> > +       .get_rate = clk_ahb_get_rate,
> > +       .set_rate = _clk_ahb_set_rate,
> > +       .round_rate = _clk_ahb_round_rate,
> > +};
> > +
> > +/* Main IP interface clock for access to registers */
> > +static struct clk ipg_clk = {
> > +       .parent = &ahb_clk,
> > +       .get_rate = clk_ipg_get_rate,
> > +};
> > +
> > +static struct clk ipg_perclk = {
> > +       .parent = &lp_apm_clk,
> > +       .get_rate = clk_ipg_per_get_rate,
> > +       .set_parent = _clk_ipg_per_set_parent,
> > +};
> > +
> > +static struct clk uart_root_clk = {
> > +       .parent = &pll2_sw_clk,
> > +       .get_rate = clk_uart_get_rate,
> > +       .set_parent = _clk_uart_set_parent,
> > +};
> > +
> > +static struct clk ahb_max_clk = {
> > +       .parent = &ahb_clk,
> > +       .enable_reg = MXC_CCM_CCGR0,
> > +       .enable_shift = MXC_CCM_CCGRx_CG14_OFFSET,
> > +       .enable = _clk_max_enable,
> > +       .disable = _clk_max_disable,
> > +};
> > +
> > +static struct clk aips_tz1_clk = {
> > +       .parent = &ahb_clk,
> > +       .secondary = &ahb_max_clk,
> > +       .enable_reg = MXC_CCM_CCGR0,
> > +       .enable_shift = MXC_CCM_CCGRx_CG12_OFFSET,
> > +       .enable = _clk_ccgr_enable,
> > +       .disable = _clk_ccgr_disable_inwait,
> > +};
> > +
> > +static struct clk aips_tz2_clk = {
> > +       .parent = &ahb_clk,
> > +       .secondary = &ahb_max_clk,
> > +       .enable_reg = MXC_CCM_CCGR0,
> > +       .enable_shift = MXC_CCM_CCGRx_CG13_OFFSET,
> > +       .enable = _clk_ccgr_enable,
> > +       .disable = _clk_ccgr_disable_inwait,
> > +};
> > +
> > +static struct clk gpt_32k_clk = {
> > +       .id = 0,
> > +       .parent = &ckil_clk,
> > +};
> > +
> > +#define DEFINE_CLOCK(name, i, er, es, gr, sr, p, s)    \
> > +       static struct clk name = {                      \
> > +               .id             = i,                    \
> > +               .enable_reg     = er,                   \
> > +               .enable_shift   = es,                   \
> > +               .get_rate       = gr,                   \
> > +               .set_rate       = sr,                   \
> > +               .enable         = _clk_ccgr_enable,     \
> > +               .disable        = _clk_ccgr_disable,    \
> > +               .parent         = p,                    \
> > +               .secondary      = s,                    \
> > +       }
> > +
> > +/* DEFINE_CLOCK(name, id, enable_reg, enable_shift,
> > +   get_rate, set_rate, parent, secondary); */
> > +
> > +/* Shared peripheral bus arbiter */
> > +DEFINE_CLOCK(spba_clk, 0, MXC_CCM_CCGR5, MXC_CCM_CCGRx_CG0_OFFSET,
> > +       NULL,  NULL, &ipg_clk, NULL);
> > +
> > +/* UART */
> > +DEFINE_CLOCK(uart1_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG4_OFFSET,
> > +       NULL,  NULL, &uart_root_clk, NULL);
> > +DEFINE_CLOCK(uart2_clk, 1, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG6_OFFSET,
> > +       NULL,  NULL, &uart_root_clk, NULL);
> > +DEFINE_CLOCK(uart3_clk, 2, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG8_OFFSET,
> > +       NULL,  NULL, &uart_root_clk, NULL);
> > +DEFINE_CLOCK(uart1_ipg_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG3_OFFSET,
> > +       NULL,  NULL, &ipg_clk, &aips_tz1_clk);
> > +DEFINE_CLOCK(uart2_ipg_clk, 1, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG5_OFFSET,
> > +       NULL,  NULL, &ipg_clk, &aips_tz1_clk);
> > +DEFINE_CLOCK(uart3_ipg_clk, 2, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG7_OFFSET,
> > +       NULL,  NULL, &ipg_clk, &spba_clk);
> > +
> > +/* GPT */
> > +DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG9_OFFSET,
> > +       NULL,  NULL, &ipg_perclk, NULL);
> > +DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
> > +       NULL,  NULL, &ipg_clk, NULL);
> > +
> > +/* FEC */
> > +DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
> > +       NULL,  NULL, &ipg_clk, NULL);
> > +
> > +#define _REGISTER_CLOCK(d, n, c) \
> > +       { \
> > +               .dev_id = d, \
> > +               .con_id = n, \
> > +               .clk = &c,   \
> > +       },
> > +
> > +static struct clk_lookup lookups[] __initdata = {
> > +       _REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
> > +       _REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
> > +       _REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> > +       _REGISTER_CLOCK(NULL, "gpt", gpt_clk)
> > +       _REGISTER_CLOCK("fec.0", NULL, fec_clk)
> > +};
> > +
> > +static void clk_tree_init(void)
> > +{
> > +       u32 reg;
> > +
> > +       ipg_perclk.set_parent(&ipg_perclk, &lp_apm_clk);
> > +
> > +       /*
> > +        * Initialise the IPG PER CLK dividers to 3. IPG_PER_CLK should be at
> > +        * 8MHz, its derived from lp_apm.
> > +        * FIXME: Verify if true for all boards
> > +        */
> > +       reg = __raw_readl(MXC_CCM_CBCDR);
> > +       reg &= ~MXC_CCM_CBCDR_PERCLK_PRED1_MASK;
> > +       reg &= ~MXC_CCM_CBCDR_PERCLK_PRED2_MASK;
> > +       reg &= ~MXC_CCM_CBCDR_PERCLK_PODF_MASK;
> > +       reg |= (2 << MXC_CCM_CBCDR_PERCLK_PRED1_OFFSET);
> > +       __raw_writel(reg, MXC_CCM_CBCDR);
> > +
> > +       /* set parent for pll1, pll2 and pll3 */
> > +       pll1_main_clk.parent = &osc_clk;
> > +       pll2_sw_clk.parent = &osc_clk;
> > +       pll3_sw_clk.parent = &osc_clk;
> > +
> > +       /* set ipg_perclk parent */
> > +       ipg_perclk.parent = &lp_apm_clk;
> > +       reg = __raw_readl(MXC_CCM_CBCMR);
> > +       if ((reg & MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL) != 0) {
> > +               ipg_perclk.parent = &ipg_clk;
> > +       } else {
> > +               if ((reg & MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL) == 0)
> > +                       ipg_perclk.parent = &main_bus_clk;
> > +       }
> > +}
> > +
> > +int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
> > +                       unsigned long ckih1, unsigned long ckih2)
> > +{
> > +       int i;
> > +
> > +       external_low_reference = ckil;
> > +       external_high_reference = ckih1;
> > +       ckih2_reference = ckih2;
> > +       oscillator_reference = osc;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(lookups); i++)
> > +               clkdev_add(&lookups[i]);
> > +
> > +       clk_tree_init();
> > +
> > +       clk_enable(&cpu_clk);
> > +       clk_enable(&main_bus_clk);
> > +
> > +       /* System timer */
> > +       mxc_timer_init(&gpt_clk, MX51_IO_ADDRESS(MX51_GPT1_BASE_ADDR),
> > +               MX51_MXC_INT_GPT);
> > +       return 0;
> > +}
> > diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
> > new file mode 100644
> > index 0000000..93f1d5a
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/cpu.c
> > @@ -0,0 +1,45 @@
> > +/*
> > + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + *
> > + * This file contains the CPU initialization code.
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <mach/hardware.h>
> > +#include <asm/io.h>
> > +
> > +static int __init post_cpu_init(void)
> > +{
> > +       unsigned int reg;
> > +       void __iomem *base;
> > +
> > +       if (cpu_is_mx51()) {
> > +               base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> > +               __raw_writel(0x0, base + 0x40);
> > +               __raw_writel(0x0, base + 0x44);
> > +               __raw_writel(0x0, base + 0x48);
> > +               __raw_writel(0x0, base + 0x4C);
> > +               reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> > +               __raw_writel(reg, base + 0x50);
> > +
> > +               base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> > +               __raw_writel(0x0, base + 0x40);
> > +               __raw_writel(0x0, base + 0x44);
> > +               __raw_writel(0x0, base + 0x48);
> > +               __raw_writel(0x0, base + 0x4C);
> > +               reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> > +               __raw_writel(reg, base + 0x50);
> > +       }
> > +       return 0;
> > +}
> > +
> > +postcore_initcall(post_cpu_init);
> > diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
> > new file mode 100644
> > index 0000000..c776b9a
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/crm_regs.h
> > @@ -0,0 +1,583 @@
> > +/*
> > + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +#ifndef __ARCH_ARM_MACH_MX51_CRM_REGS_H__
> > +#define __ARCH_ARM_MACH_MX51_CRM_REGS_H__
> > +
> > +#define MX51_CCM_BASE          MX51_IO_ADDRESS(MX51_CCM_BASE_ADDR)
> > +#define MX51_DPLL1_BASE                MX51_IO_ADDRESS(MX51_PLL1_BASE_ADDR)
> > +#define MX51_DPLL2_BASE                MX51_IO_ADDRESS(MX51_PLL2_BASE_ADDR)
> 
> .... skipping register definitions ....
> 
> > +#define MXC_SRPGC_EMI_PUPSCR   (MXC_SRPGC_EMI_BASE + 0x4)
> > +#define MXC_SRPGC_EMI_PDNSCR   (MXC_SRPGC_EMI_BASE + 0x8)
> > +
> > +#endif                         /* __ARCH_ARM_MACH_MX51_CRM_REGS_H__ */
> > diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> > new file mode 100644
> > index 0000000..55eb089
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/devices.c
> > @@ -0,0 +1,96 @@
> > +/*
> > + * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <mach/hardware.h>
> > +#include <mach/imx-uart.h>
> > +
> > +static struct resource uart0[] = {
> > +       {
> > +               .start = MX51_UART1_BASE_ADDR,
> > +               .end = MX51_UART1_BASE_ADDR + 0x0B5,
> > +               .flags = IORESOURCE_MEM,
> > +       }, {
> > +               .start = MX51_MXC_INT_UART1,
> > +               .end = MX51_MXC_INT_UART1,
> > +               .flags = IORESOURCE_IRQ,
> > +       },
> > +};
> > +
> > +struct platform_device mxc_uart_device0 = {
> > +       .name = "imx-uart",
> > +       .id = 0,
> > +       .resource = uart0,
> > +       .num_resources = ARRAY_SIZE(uart0),
> > +};
> > +
> > +static struct resource uart1[] = {
> > +       {
> > +               .start = MX51_UART2_BASE_ADDR,
> > +               .end = MX51_UART2_BASE_ADDR + 0x0B5,
> > +               .flags = IORESOURCE_MEM,
> > +       }, {
> > +               .start = MX51_MXC_INT_UART2,
> > +               .end = MX51_MXC_INT_UART2,
> > +               .flags = IORESOURCE_IRQ,
> > +       },
> > +};
> > +
> > +struct platform_device mxc_uart_device1 = {
> > +       .name = "imx-uart",
> > +       .id = 1,
> > +       .resource = uart1,
> > +       .num_resources = ARRAY_SIZE(uart1),
> > +};
> > +
> > +static struct resource uart2[] = {
> > +       {
> > +               .start = MX51_UART3_BASE_ADDR,
> > +               .end = MX51_UART3_BASE_ADDR + 0x0B5,
> > +               .flags = IORESOURCE_MEM,
> > +       }, {
> > +               .start = MX51_MXC_INT_UART3,
> > +               .end = MX51_MXC_INT_UART3,
> > +               .flags = IORESOURCE_IRQ,
> > +       },
> > +};
> > +
> > +struct platform_device mxc_uart_device2 = {
> > +       .name = "imx-uart",
> > +       .id = 2,
> > +       .resource = uart2,
> > +       .num_resources = ARRAY_SIZE(uart2),
> > +};
> > +
> > +static struct resource mxc_fec_resources[] = {
> > +       {
> > +               .start  = MX51_MXC_FEC_BASE_ADDR,
> > +               .end    = MX51_MXC_FEC_BASE_ADDR + 0xfff,
> > +               .flags  = IORESOURCE_MEM,
> > +       }, {
> > +               .start  = MX51_MXC_INT_FEC,
> > +               .end    = MX51_MXC_INT_FEC,
> > +               .flags  = IORESOURCE_IRQ,
> > +       },
> > +};
> > +
> > +struct platform_device mxc_fec_device = {
> > +       .name = "fec",
> > +       .id = 0,
> > +       .num_resources = ARRAY_SIZE(mxc_fec_resources),
> > +       .resource = mxc_fec_resources,
> > +};
> > +
> > +/* Dummy definition to allow compiling in AVIC and TZIC simultaneously */
> > +int __init mxc_register_gpios(void)
> > +{
> > +       return 0;
> > +}
> > diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> > new file mode 100644
> > index 0000000..f339ab8
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/devices.h
> > @@ -0,0 +1,4 @@
> > +extern struct platform_device mxc_uart_device0;
> > +extern struct platform_device mxc_uart_device1;
> > +extern struct platform_device mxc_uart_device2;
> > +extern struct platform_device mxc_fec_device;
> > diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
> > new file mode 100644
> > index 0000000..d66c31a
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/mm.c
> > @@ -0,0 +1,88 @@
> > +/*
> > + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License.  You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + *
> > + * Create static mapping between physical to virtual memory.
> > + */
> > +
> > +#include <linux/mm.h>
> > +#include <linux/init.h>
> > +
> > +#include <asm/mach/map.h>
> > +
> > +#include <mach/hardware.h>
> > +#include <mach/common.h>
> > +#include <mach/iomux-v3.h>
> > +
> > +/*
> > + * Define the MX51 memory map.
> > + */
> > +static struct map_desc mxc_io_desc[] __initdata = {
> > +       {
> > +        .virtual = MX51_IRAM_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_IRAM_BASE_ADDR),
> > +        .length = MX51_IRAM_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_DEBUG_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_DEBUG_BASE_ADDR),
> > +        .length = MX51_DEBUG_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_TZIC_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_TZIC_BASE_ADDR),
> > +        .length = MX51_TZIC_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_AIPS1_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_AIPS1_BASE_ADDR),
> > +        .length = MX51_AIPS1_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_SPBA0_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_SPBA0_BASE_ADDR),
> > +        .length = MX51_SPBA0_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_AIPS2_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_AIPS2_BASE_ADDR),
> > +        .length = MX51_AIPS2_SIZE,
> > +        .type = MT_DEVICE},
> > +       {
> > +        .virtual = MX51_NFC_AXI_BASE_ADDR_VIRT,
> > +        .pfn = __phys_to_pfn(MX51_NFC_AXI_BASE_ADDR),
> > +        .length = MX51_NFC_AXI_SIZE,
> > +        .type = MT_DEVICE},
> 
> Weird alignment, guess due to leading white spaces?

Fixed.

> 
> .... skipping the rest ....

Thanks for the review.

/Amit
-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------
