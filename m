Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0CKHA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:00:58 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48653 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0CKHA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EPhzkvw9pIDNPqsnB9gmpuzBSpZRNXF9OXhtIorWwUnouJq4uhKriDbc7A0SjcyIi+
         qNE2rLLaKCnBaXRWIyQdC5IsNSIxLEfi1XXzCheG9uTnhktRLkmVJtX1n6lpMGmFDHox
         PiNcJ4tMxGQBNl24aZGh1Kk2fEicqP05SH1go=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
Date: Thu, 11 Mar 2010 08:00:54 +0100
Message-ID: <63386a3d1003102300q23ea536bje956f8d5c7e333a2@mail.gmail.com>
Subject: Re: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr platform 
	and machines
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:

> Clock framework for SPEAr is based upon clkdev framework for ARM
> (... clock tree definition looks OK to me ...)

> diff --git a/arch/arm/plat-spear/clock.c b/arch/arm/plat-spear/clock.c
> new file mode 100755
> index 0000000..bdcae0c
> --- /dev/null
> +++ b/arch/arm/plat-spear/clock.c
> @@ -0,0 +1,433 @@
> +/*
> + * arch/arm/plat-spear/clock.c
> + *
> + * Clock framework for SPEAr platform
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <mach/misc_regs.h>
> +#include <plat/clock.h>
> +
> +static DEFINE_SPINLOCK(clocks_lock);
> +static LIST_HEAD(root_clks);
> +
> +static void propagate_rate(struct list_head *);
> +
> +static int generic_clk_enable(struct clk *clk)
> +{
> +       unsigned int val;
> +
> +       if (!clk->en_reg)
> +               return -EFAULT;
> +
> +       val = readl(clk->en_reg);
> +       if (unlikely(clk->flags & RESET_TO_ENABLE))
> +               val &= ~(1 << clk->en_reg_bit);
> +       else
> +               val |= 1 << clk->en_reg_bit;
> +       writel(val, clk->en_reg);

I don't understand one bit of this. What happens if the RESET_TO_ENABLE
flag is set for the clock? The exact same bit is &-masked and then
immediately |:ed to 1 again. Then it is written to the register. Practical
effect: absolutely none.

Is there a writel(val, clk->en_reg); missing from the unlikely() execution
path?

> +
> +       return 0;
> +}
> +
> +static void generic_clk_disable(struct clk *clk)
> +{
> +       unsigned int val;
> +
> +       if (!clk->en_reg)
> +               return;
> +
> +       val = readl(clk->en_reg);
> +       if (unlikely(clk->flags & RESET_TO_ENABLE))
> +               val |= 1 << clk->en_reg_bit;
> +       else
> +               val &= ~(1 << clk->en_reg_bit);

Same issue here...

> +
> +       writel(val, clk->en_reg);
> +}
> +
> +/* generic clk ops */
> +static struct clkops generic_clkops = {
> +       .enable = generic_clk_enable,
> +       .disable = generic_clk_disable,
> +};
> +
> +/*
> + * clk_enable - inform the system when the clock source should be running.
> + * @clk: clock source
> + *
> + * If the clock can not be enabled/disabled, this should return success.
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_enable(struct clk *clk)
> +{
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       if (!clk || IS_ERR(clk))
> +               return -EFAULT;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       if (clk->usage_count++ == 0) {

Isnt if (++clk.>usage_count == 1) easier to understand, or is it just me?
BTW doing this:
clk->usage_count++;
if (clk->usage_count == 1)
will not use more memory, the compiler optimize this, so choose the
version you think is most readable. If you think this is very readable, by
all means keep it.

> +               if (clk->ops && clk->ops->enable)
> +                       ret = clk->ops->enable(clk);
> +       }
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(clk_enable);
> +
> +/*
> + * clk_disable - inform the system when the clock source is no longer required.
> + * @clk: clock source
> + *
> + * Inform the system that a clock source is no longer required by
> + * a driver and may be shut down.
> + *
> + * Implementation detail: if the clock source is shared between
> + * multiple drivers, clk_enable() calls must be balanced by the
> + * same number of clk_disable() calls for the clock source to be
> + * disabled.
> + */
> +void clk_disable(struct clk *clk)
> +{
> +       unsigned long flags;
> +
> +       if (!clk || IS_ERR(clk))
> +               return;
> +
> +       WARN_ON(clk->usage_count == 0);
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       if (--clk->usage_count == 0) {

Same readability issue here.

> +               if (clk->ops && clk->ops->disable)
> +                       clk->ops->disable(clk);
> +       }
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +EXPORT_SYMBOL(clk_disable);
> +
> +/**
> + * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
> + *              This is only valid once the clock source has been enabled.
> + * @clk: clock source
> + */
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +       unsigned long flags, rate;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       rate = clk->rate;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +       return rate;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +
> +/**
> + * clk_set_parent - set the parent clock source for this clock
> + * @clk: clock source
> + * @parent: parent clock source
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +       int i, found = 0, val = 0;
> +       unsigned long flags;
> +
> +       if (!clk || IS_ERR(clk) || !parent || IS_ERR(parent))
> +               return -EFAULT;
> +       if (clk->usage_count == 0)
> +               return -EBUSY;

Why will the clk_set_parent() call fail if there are *no* users of the clock?
Should it not be the other way around? Or what am I misunderstanding here?

> +       if (!clk->pclk_sel)
> +               return -EPERM;
> +       if (clk->pclk == parent)
> +               return 0;
> +
> +       for (i = 0; i < clk->pclk_sel->pclk_count; i++) {
> +               if (clk->pclk_sel->pclk_info[i].pclk == parent) {
> +                       found = 1;
> +                       break;
> +               }
> +       }
> +
> +       if (!found)
> +               return -EPERM;

What about -ENODEV or so? (I don't know what people typically
use for clocks that don't exist.)

> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       /* reflect parent change in hardware */
> +       val = readl(clk->pclk_sel->pclk_sel_reg);
> +       val &= ~(clk->pclk_sel->pclk_sel_mask << clk->pclk_sel_shift);
> +       val |= clk->pclk_sel->pclk_info[i].pclk_mask << clk->pclk_sel_shift;
> +       writel(val, clk->pclk_sel->pclk_sel_reg);
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +       /* reflect parent change in software */
> +       clk->recalc(clk);
> +       propagate_rate(&clk->children);
> +       return 0;
> +}
> +EXPORT_SYMBOL(clk_set_parent);
> +
> +/* registers clock in platform clock framework */
> +void clk_register(struct clk_lookup *cl)
> +{
> +       struct clk *clk = cl->clk;
> +       unsigned long flags;
> +
> +       if (!clk || IS_ERR(clk))
> +               return;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +
> +       INIT_LIST_HEAD(&clk->children);
> +       if (clk->flags & ALWAYS_ENABLED)
> +               clk->ops = NULL;
> +       else if (!clk->ops)
> +               clk->ops = &generic_clkops;
> +
> +       /* root clock don't have any parents */
> +       if (!clk->pclk && !clk->pclk_sel) {
> +               list_add(&clk->sibling, &root_clks);
> +               /* add clocks with only one parent to parent's children list */
> +       } else if (clk->pclk && !clk->pclk_sel) {
> +               list_add(&clk->sibling, &clk->pclk->children);
> +       } else {
> +               /* add clocks with > 1 parent to 1st parent's children list */
> +               list_add(&clk->sibling,
> +                        &clk->pclk_sel->pclk_info[0].pclk->children);
> +       }
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +       /* add clock to arm clockdev framework */
> +       clkdev_add(cl);
> +}
> +
> +/**
> + * propagate_rate - recalculate and propagate all clocks in list head
> + *
> + * Recalculates all root clocks in list head, which if the clock's .recalc is
> + * set correctly, should also propagate their rates.
> + */
> +static void propagate_rate(struct list_head *lhead)
> +{
> +       struct clk *clkp, *_temp;
> +
> +       list_for_each_entry_safe(clkp, _temp, lhead, sibling) {
> +               if (clkp->recalc)
> +                       clkp->recalc(clkp);
> +               propagate_rate(&clkp->children);
> +       }
> +}
> +
> +/* returns current programmed clocks clock info structure */
> +static struct pclk_info *pclk_info_get(struct clk *clk)
> +{
> +       unsigned int mask, i;
> +       unsigned long flags;
> +       struct pclk_info *info;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       mask = (readl(clk->pclk_sel->pclk_sel_reg) >> clk->pclk_sel_shift)
> +                       & clk->pclk_sel->pclk_sel_mask;
> +
> +       for (i = 0; i < clk->pclk_sel->pclk_count; i++) {
> +               if (clk->pclk_sel->pclk_info[i].pclk_mask == mask)
> +                       info = &clk->pclk_sel->pclk_info[i];
> +       }
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +       return info;
> +}
> +
> +/*
> + * Set pclk as cclk's parent and add clock sibling node to current parents
> + * children list
> + */
> +static void change_parent(struct clk *cclk, struct clk *pclk)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       list_del(&cclk->sibling);
> +       list_add(&cclk->sibling, &pclk->children);
> +
> +       cclk->pclk = pclk;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/*
> + * calculates current programmed rate of pll1
> + *
> + * In normal mode
> + * rate = (2 * M[15:8] * Fin)/(N * 2^P)
> + *
> + * In Dithered mode
> + * rate = (2 * M[15:0] * Fin)/(256 * N * 2^P)
> + */
> +void pll1_clk_recalc(struct clk *clk)
> +{
> +       struct pll_clk_config *config = clk->private_data;
> +       unsigned int num = 2, den = 0, val, mode = 0;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       mode = (readl(config->mode_reg) >> PLL_MODE_SHIFT) &
> +               PLL_MODE_MASK;
> +
> +       val = readl(config->cfg_reg);
> +       /* calculate denominator */
> +       den = (val >> PLL_DIV_P_SHIFT) & PLL_DIV_P_MASK;
> +       den = 1 << den;
> +       den *= (val >> PLL_DIV_N_SHIFT) & PLL_DIV_N_MASK;
> +
> +       /* calculate numerator & denominator */
> +       if (!mode) {
> +               /* Normal mode */
> +               num *= (val >> PLL_NORM_FDBK_M_SHIFT) & PLL_NORM_FDBK_M_MASK;
> +       } else {
> +               /* Dithered mode */
> +               num *= (val >> PLL_DITH_FDBK_M_SHIFT) & PLL_DITH_FDBK_M_MASK;
> +               den *= 256;
> +       }
> +
> +       clk->rate = (((clk->pclk->rate/10000) * num) / den) * 10000;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/* calculates current programmed rate of ahb or apb bus */
> +void bus_clk_recalc(struct clk *clk)
> +{
> +       struct bus_clk_config *config = clk->private_data;
> +       unsigned int div;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       div = ((readl(config->reg) >> config->shift) & config->mask) + 1;
> +       clk->rate = (unsigned long)clk->pclk->rate / div;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/*
> + * calculates current programmed rate of auxiliary synthesizers
> + * used by: UART, FIRDA
> + *
> + * Fout from synthesizer can be given from two equations:
> + * Fout1 = (Fin * X/Y)/2
> + * Fout2 = Fin * X/Y
> + *
> + * Selection of eqn 1 or 2 is programmed in register
> + */
> +void aux_clk_recalc(struct clk *clk)
> +{
> +       struct aux_clk_config *config = clk->private_data;
> +       struct pclk_info *pclk_info = NULL;
> +       unsigned int num = 1, den = 1, val, eqn;
> +       unsigned long flags;
> +
> +       /* get current programmed parent */
> +       pclk_info = pclk_info_get(clk);
> +       if (!pclk_info) {
> +               spin_lock_irqsave(&clocks_lock, flags);
> +               clk->pclk = NULL;
> +               clk->rate = 0;
> +               spin_unlock_irqrestore(&clocks_lock, flags);
> +               return;
> +       }
> +
> +       change_parent(clk, pclk_info->pclk);
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       if (pclk_info->scalable) {
> +               val = readl(config->synth_reg);
> +
> +               eqn = (val >> AUX_EQ_SEL_SHIFT) & AUX_EQ_SEL_MASK;
> +               if (eqn == AUX_EQ1_SEL)
> +                       den *= 2;
> +
> +               /* calculate numerator */
> +               num = (val >> AUX_XSCALE_SHIFT) & AUX_XSCALE_MASK;
> +
> +               /* calculate denominator */
> +               den *= (val >> AUX_YSCALE_SHIFT) & AUX_YSCALE_MASK;
> +               val = (((clk->pclk->rate/10000) * num) / den) * 10000;
> +       } else
> +               val = clk->pclk->rate;
> +
> +       clk->rate = val;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/*
> + * calculates current programmed rate of gpt synthesizers
> + * Fout from synthesizer can be given from below equations:
> + * Fout= Fin/((2 ^ (N+1)) * (M+1))
> + */
> +void gpt_clk_recalc(struct clk *clk)
> +{
> +       struct aux_clk_config *config = clk->private_data;
> +       struct pclk_info *pclk_info = NULL;
> +       unsigned int div = 1, val;
> +       unsigned long flags;
> +
> +       pclk_info = pclk_info_get(clk);
> +       if (!pclk_info) {
> +               spin_lock_irqsave(&clocks_lock, flags);
> +               clk->pclk = NULL;
> +               clk->rate = 0;
> +               spin_unlock_irqrestore(&clocks_lock, flags);
> +               return;
> +       }
> +
> +       change_parent(clk, pclk_info->pclk);
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       if (pclk_info->scalable) {
> +               val = readl(config->synth_reg);
> +               div += (val >> GPT_MSCALE_SHIFT) & GPT_MSCALE_MASK;
> +               div *= 1 << (((val >> GPT_NSCALE_SHIFT) & GPT_NSCALE_MASK) + 1);
> +       }
> +
> +       clk->rate = (unsigned long)clk->pclk->rate / div;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/*
> + * Used for clocks that always have same value as the parent clock divided by a
> + * fixed divisor
> + */
> +void follow_parent(struct clk *clk)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&clocks_lock, flags);
> +       clk->rate = clk->pclk->rate;
> +       spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +
> +/**
> + * recalc_root_clocks - recalculate and propagate all root clocks
> + *
> + * Recalculates all root clocks (clocks with no parent), which if the
> + * clock's .recalc is set correctly, should also propagate their rates.
> + */
> +void recalc_root_clocks(void)
> +{
> +       propagate_rate(&root_clks);
> +}

I understand (I think) how speed change can propagate through the clocks.
However I think it will be hard to notify users that the clock rate has changed,
because there is nothing in the clk framework that supports that. If you have
drivers with dynamic clocks, do you have any plans on how you will
notify drivers?

OMAP uses CPUfreq but that is really about the CPU. As it happens, all
their clk:s always change frequency at the same operating points as the
CPU. So they can have pre/post calls from CPUfreq in their code, but
this will not work with things like PrimeCells where other users of the cell
may not have operating points correlated with CPU operating points.

(I'm not requesting you to solve this problem, more to be aware of it.)

> diff --git a/arch/arm/plat-spear/include/plat/clkdev.h b/arch/arm/plat-spear/include/plat/clkdev.h
> new file mode 100644
> index 0000000..9b1cd54
> --- /dev/null
> +++ b/arch/arm/plat-spear/include/plat/clkdev.h
> @@ -0,0 +1,20 @@
> +/*
> + * arch/arm/plat-spear/include/plat/clkdev.h
> + *
> + * Clock Dev framework definitions for SPEAr platform
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_PLAT_CLKDEV_H
> +#define __ASM_PLAT_CLKDEV_H
> +
> +#define __clk_get(clk) ({ 1; })
> +#define __clk_put(clk) do { } while (0)
> +
> +#endif /* __ASM_PLAT_CLKDEV_H */
> diff --git a/arch/arm/plat-spear/include/plat/clock.h b/arch/arm/plat-spear/include/plat/clock.h
> new file mode 100755
> index 0000000..c220274
> --- /dev/null
> +++ b/arch/arm/plat-spear/include/plat/clock.h
> @@ -0,0 +1,130 @@
> +/*
> + * arch/arm/plat-spear/include/plat/clock.h
> + *
> + * Clock framework definitions for SPEAr platform
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_PLAT_CLOCK_H
> +#define __ASM_PLAT_CLOCK_H
> +
> +#include <linux/list.h>
> +#include <asm/clkdev.h>
> +#include <linux/types.h>
> +
> +/* clk values */
> +#define KHZ                    (1000)
> +#define MHZ                    (1000000)

This looks far to generic to be hidden in some weird special architecture.
And I *think* the preferred way to encode frequencies in the kernel is raw
Hertz measure with all the extra zeroes.

Doing
.foo = MHZ *48;

Is a bit awkward, don't you think it's better to do:
#define MHZ(f)  f * 1000000
.foo = MHZ(48);

If you absolutely want to do this, I would suggest to add the KHZ and MHZ
macros to some global kernel file but I honestly cannot say which one.
Perhaps inlcude/linux/clk.h?

> +
> +/* clk structure flags */
> +#define        ALWAYS_ENABLED          (1 << 0) /* clock always enabled */
> +#define        RESET_TO_ENABLE         (1 << 1) /* reset register bit to enable clk */
> +
> +/**
> + * struct clkops - clock operations
> + * @enable: pointer to clock enable function
> + * @disable: pointer to clock disable function
> + */
> +struct clkops {
> +       int (*enable) (struct clk *);
> +       void (*disable) (struct clk *);
> +};
> +
> +/**
> + * struct pclk_info - parents info
> + * @pclk: pointer to parent clk
> + * @pclk_mask: value to be written for selecting this parent
> + * @scalable: Is parent scalable (1 - YES, 0 - NO)
> + */
> +struct pclk_info {
> +       struct clk *pclk;
> +       u8 pclk_mask;
> +       u8 scalable;
> +};
> +
> +/**
> + * struct pclk_sel - parents selection configuration
> + * @pclk_info: pointer to array of parent clock info
> + * @pclk_count: number of parents
> + * @pclk_sel_reg: register for selecting a parent
> + * @pclk_sel_mask: mask for selecting parent (can be used to clear bits also)
> + */
> +struct pclk_sel {
> +       struct pclk_info *pclk_info;
> +       u8 pclk_count;
> +       unsigned int *pclk_sel_reg;
> +       unsigned int pclk_sel_mask;
> +};
> +
> +/**
> + * struct clk - clock structure
> + * @usage_count: num of users who enabled this clock
> + * @flags: flags for clock properties
> + * @rate: programmed clock rate in Hz
> + * @en_reg: clk enable/disable reg
> + * @en_reg_bit: clk enable/disable bit
> + * @ops: clk enable/disable ops - generic_clkops selected if NULL
> + * @recalc: pointer to clock rate recalculate function
> + * @pclk: current parent clk
> + * @pclk_sel: pointer to parent selection structure
> + * @pclk_sel_shift: register shift for selecting parent of this clock
> + * @children: list for childrens or this clock
> + * @sibling: node for list of clocks having same parents
> + * @private_data: clock specific private data
> + */
> +struct clk {
> +       unsigned int usage_count;
> +       unsigned int flags;
> +       unsigned long rate;
> +       unsigned int *en_reg;
> +       u8 en_reg_bit;
> +       const struct clkops *ops;
> +       void (*recalc) (struct clk *);
> +
> +       struct clk *pclk;
> +       struct pclk_sel *pclk_sel;
> +       unsigned int pclk_sel_shift;
> +
> +       struct list_head children;
> +       struct list_head sibling;
> +       void *private_data;
> +};
> +
> +/* pll configuration structure */
> +struct pll_clk_config {
> +       unsigned int *mode_reg;
> +       unsigned int *cfg_reg;
> +};
> +
> +/* ahb and apb bus configuration structure */
> +struct bus_clk_config {
> +       unsigned int *reg;
> +       unsigned int mask;
> +       unsigned int shift;
> +};
> +
> +/*
> + * Aux clk configuration structure: applicable to GPT, UART and FIRDA
> + */
> +struct aux_clk_config {
> +       unsigned int *synth_reg;
> +};
> +
> +/* platform specific clock functions */
> +void clk_register(struct clk_lookup *cl);
> +void recalc_root_clocks(void);
> +
> +/* clock recalc functions */
> +void follow_parent(struct clk *clk);
> +void pll1_clk_recalc(struct clk *clk);
> +void bus_clk_recalc(struct clk *clk);
> +void gpt_clk_recalc(struct clk *clk);
> +void aux_clk_recalc(struct clk *clk);
> +
> +#endif /* __ASM_PLAT_CLOCK_H */
> --
> 1.6.0.2

Yours,
Linus Walleij
