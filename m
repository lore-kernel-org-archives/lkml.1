Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0CLEUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:20:20 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59896 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab0CLEUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:20:18 -0500
Message-ID: <4B99C0BB.7080900@st.com>
Date: Fri, 12 Mar 2010 09:49:07 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr platform
 	and machines
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com> <63386a3d1003102300q23ea536bje956f8d5c7e333a2@mail.gmail.com>
In-Reply-To: <63386a3d1003102300q23ea536bje956f8d5c7e333a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 12:30 PM, Linus Walleij wrote:
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> 
>> +{
>> +       unsigned int val;
>> +
>> +       if (!clk->en_reg)
>> +               return -EFAULT;
>> +
>> +       val = readl(clk->en_reg);
>> +       if (unlikely(clk->flags & RESET_TO_ENABLE))
>> +               val &= ~(1 << clk->en_reg_bit);
>> +       else
>> +               val |= 1 << clk->en_reg_bit;
>> +       writel(val, clk->en_reg);
> 
> I don't understand one bit of this. What happens if the RESET_TO_ENABLE
> flag is set for the clock? The exact same bit is &-masked and then
> immediately |:ed to 1 again. Then it is written to the register. Practical
> effect: absolutely none.
> 
> Is there a writel(val, clk->en_reg); missing from the unlikely() execution
> path?

Already explained by shiraz.

> 
>> +
>> +       return 0;
>> +}
>> +
>> +static void generic_clk_disable(struct clk *clk)
>> +{
>> +       unsigned int val;
>> +
>> +       if (!clk->en_reg)
>> +               return;
>> +
>> +       val = readl(clk->en_reg);
>> +       if (unlikely(clk->flags & RESET_TO_ENABLE))
>> +               val |= 1 << clk->en_reg_bit;
>> +       else
>> +               val &= ~(1 << clk->en_reg_bit);
> 
> Same issue here...
> 
>> +
>> +       writel(val, clk->en_reg);
>> +}
>> +
>> +/* generic clk ops */
>> +static struct clkops generic_clkops = {
>> +       .enable = generic_clk_enable,
>> +       .disable = generic_clk_disable,
>> +};
>> +
>> +/*
>> + * clk_enable - inform the system when the clock source should be running.
>> + * @clk: clock source
>> + *
>> + * If the clock can not be enabled/disabled, this should return success.
>> + *
>> + * Returns success (0) or negative errno.
>> + */
>> +int clk_enable(struct clk *clk)
>> +{
>> +       unsigned long flags;
>> +       int ret = 0;
>> +
>> +       if (!clk || IS_ERR(clk))
>> +               return -EFAULT;
>> +
>> +       spin_lock_irqsave(&clocks_lock, flags);
>> +       if (clk->usage_count++ == 0) {
> 
> Isnt if (++clk.>usage_count == 1) easier to understand, or is it just me?
> BTW doing this:
> clk->usage_count++;
> if (clk->usage_count == 1)
> will not use more memory, the compiler optimize this, so choose the
> version you think is most readable. If you think this is very readable, by
> all means keep it.
> 

I will simplify it, to make it more readable.

>> +               if (clk->ops && clk->ops->enable)
>> +                       ret = clk->ops->enable(clk);
>> +       }
>> +       spin_unlock_irqrestore(&clocks_lock, flags);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(clk_enable);
>> +
>> +/*
>> + * clk_disable - inform the system when the clock source is no longer required.
>> + * @clk: clock source
>> + *
>> + * Inform the system that a clock source is no longer required by
>> + * a driver and may be shut down.
>> + *
>> + * Implementation detail: if the clock source is shared between
>> + * multiple drivers, clk_enable() calls must be balanced by the
>> + * same number of clk_disable() calls for the clock source to be
>> + * disabled.
>> + */
>> +void clk_disable(struct clk *clk)
>> +{
>> +       unsigned long flags;
>> +
>> +       if (!clk || IS_ERR(clk))
>> +               return;
>> +
>> +       WARN_ON(clk->usage_count == 0);
>> +
>> +       spin_lock_irqsave(&clocks_lock, flags);
>> +       if (--clk->usage_count == 0) {
> 
> Same readability issue here.

I will simplify it, to make it more readable.

> 
>> +       if (!clk || IS_ERR(clk) || !parent || IS_ERR(parent))
>> +               return -EFAULT;
>> +       if (clk->usage_count == 0)
>> +               return -EBUSY;
> 
> Why will the clk_set_parent() call fail if there are *no* users of the clock?
> Should it not be the other way around? Or what am I misunderstanding here?
> 

My mistake. should be !=.

>> +       if (!clk->pclk_sel)
>> +               return -EPERM;
>> +       if (clk->pclk == parent)
>> +               return 0;
>> +
>> +       for (i = 0; i < clk->pclk_sel->pclk_count; i++) {
>> +               if (clk->pclk_sel->pclk_info[i].pclk == parent) {
>> +                       found = 1;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (!found)
>> +               return -EPERM;
> 
> What about -ENODEV or so? (I don't know what people typically
> use for clocks that don't exist.)

Will correct it to return correct error.

> 
>> + */
>> +void recalc_root_clocks(void)
>> +{
>> +       propagate_rate(&root_clks);
>> +}
> 
> I understand (I think) how speed change can propagate through the clocks.
> However I think it will be hard to notify users that the clock rate has changed,
> because there is nothing in the clk framework that supports that. If you have
> drivers with dynamic clocks, do you have any plans on how you will
> notify drivers?
> 
> OMAP uses CPUfreq but that is really about the CPU. As it happens, all
> their clk:s always change frequency at the same operating points as the
> CPU. So they can have pre/post calls from CPUfreq in their code, but
> this will not work with things like PrimeCells where other users of the cell
> may not have operating points correlated with CPU operating points.
> 
> (I'm not requesting you to solve this problem, more to be aware of it.)
> 

already answered by shiraz.

>> diff --git a/arch/arm/plat-spear/include/plat/clkdev.h b/arch/arm/plat-spear/include/plat/clkdev.h
>> +/* clk values */
>> +#define KHZ                    (1000)
>> +#define MHZ                    (1000000)
> 
> This looks far to generic to be hidden in some weird special architecture.
> And I *think* the preferred way to encode frequencies in the kernel is raw
> Hertz measure with all the extra zeroes.
> 
> Doing
> .foo = MHZ *48;
> 
> Is a bit awkward, don't you think it's better to do:
> #define MHZ(f)  f * 1000000
> .foo = MHZ(48);
> 
> If you absolutely want to do this, I would suggest to add the KHZ and MHZ
> macros to some global kernel file but I honestly cannot say which one.
> Perhaps inlcude/linux/clk.h?
> 

I will better remove them.


regards,
viresh kumar.
