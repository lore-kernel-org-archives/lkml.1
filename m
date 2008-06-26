Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYFZPDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYFZPDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYFZPCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:02:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:16385 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYFZPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vpwmXjStis/ygj3t42q1RMOtB5FgkrW1M7a8sKwCmytX3WToF8jT1Fd1Y2JzyiNNn0
         XJW+zOqIlLEDX3tSQJkdv1jC8DSDgZlGfGh/HvhZ5X/S5e1DnFpZ8Vga/JvyifrTjf5/
         Uxm0uvJiI8oOFq6wdpyUYUNR0wF7KpZnpdTik=
Message-ID: <74d0deb30806260802g14b52394pc6cb763fde642578@mail.gmail.com>
Date: Thu, 26 Jun 2008 17:02:48 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Dmitry Baryshkov" <dbaryshkov@gmail.com>
Subject: Re: [PATCH 2/3] Clocklib: Refactor PXA arm arch to use clocklib.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Pavel Machek" <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       "David Brownell" <david-b@pacbell.net>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
In-Reply-To: <20080626125153.GA12424@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080626125033.GA7093@doriath.ww600.siemens.net>
	 <20080626125153.GA12424@doriath.ww600.siemens.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 2:51 PM, Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> Make PXA use clocklib for clocks support.
>
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  arch/arm/Kconfig           |    1 +
>  arch/arm/mach-pxa/clock.c  |  157 ++++++++++++++++++--------------------------
>  arch/arm/mach-pxa/clock.h  |   89 ++++++++++++++++---------
>  arch/arm/mach-pxa/pxa25x.c |   69 ++++++++++++-------
>  arch/arm/mach-pxa/pxa27x.c |   78 +++++++++++++---------
>  arch/arm/mach-pxa/pxa3xx.c |  154 ++++++++++++++++++++++++++----------------
>  6 files changed, 307 insertions(+), 241 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fe1455e..e7d0343 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -393,6 +393,7 @@ config ARCH_PXA
>        select GENERIC_TIME
>        select GENERIC_CLOCKEVENTS
>        select TICK_ONESHOT
> +       select HAVE_CLOCKLIB
>        help
>          Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
>
> diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
> index 180c8bb..f326b80 100644
> --- a/arch/arm/mach-pxa/clock.c
> +++ b/arch/arm/mach-pxa/clock.c
> @@ -3,152 +3,121 @@
>  */
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> -#include <linux/list.h>
> -#include <linux/errno.h>
> -#include <linux/err.h>
> -#include <linux/string.h>
>  #include <linux/clk.h>
> -#include <linux/spinlock.h>
> -#include <linux/platform_device.h>
> +#include <linux/clocklib.h>
>  #include <linux/delay.h>
>
>  #include <asm/arch/pxa2xx-regs.h>
>  #include <asm/arch/pxa2xx-gpio.h>
>  #include <asm/hardware.h>
>
> -#include "devices.h"
> -#include "generic.h"
> +//#include "devices.h"
> +//#include "generic.h"

And again.

>  #include "clock.h"
>
> -static LIST_HEAD(clocks);
> -static DEFINE_MUTEX(clocks_mutex);
> -static DEFINE_SPINLOCK(clocks_lock);
> -
> -static struct clk *clk_lookup(struct device *dev, const char *id)
> +static int clk_gpio11_enable(struct clk *clk)
>  {
> -       struct clk *p;
> -
> -       list_for_each_entry(p, &clocks, node)
> -               if (strcmp(id, p->name) == 0 && p->dev == dev)
> -                       return p;
> -
> -       return NULL;
> +       pxa_gpio_mode(GPIO11_3_6MHz_MD);
> +       return 0;
>  }
>
> -struct clk *clk_get(struct device *dev, const char *id)
> +static void clk_gpio11_disable(struct clk *clk)
>  {
> -       struct clk *p, *clk = ERR_PTR(-ENOENT);
> -
> -       mutex_lock(&clocks_mutex);
> -       p = clk_lookup(dev, id);
> -       if (!p)
> -               p = clk_lookup(NULL, id);
> -       if (p)
> -               clk = p;
> -       mutex_unlock(&clocks_mutex);
> -
> -       return clk;
> +       /* do nothing */
>  }
> -EXPORT_SYMBOL(clk_get);
>
> -void clk_put(struct clk *clk)
> +static unsigned long clk_gpio11_get_rate(struct clk *clk)
>  {
> +       return 3686400;
>  }
> -EXPORT_SYMBOL(clk_put);
>
> -int clk_enable(struct clk *clk)
> +static struct clk_ops clk_gpio11_ops = {
> +       .enable =       clk_gpio11_enable,
> +       .disable =      clk_gpio11_disable,
> +       .get_rate =     clk_gpio11_get_rate,
> +};
> +
> +static struct clk clk_gpio11 = {
> +       .name = "GPIO27_CLK",
> +       .ops = &clk_gpio11_ops,
> +       .release = clk_static_release,
> +};
> +
> +int clk_cken_enable(struct clk *clk)
>  {
> -       unsigned long flags;
> +       struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
>
> -       spin_lock_irqsave(&clocks_lock, flags);
> -       if (clk->enabled++ == 0)
> -               clk->ops->enable(clk);
> -       spin_unlock_irqrestore(&clocks_lock, flags);
> +       CKEN |= 1 << priv->cken;
>
> -       if (clk->delay)
> -               udelay(clk->delay);
> +       if (priv->delay)
> +               udelay(priv->delay);
>
>        return 0;
>  }
> -EXPORT_SYMBOL(clk_enable);
>
> -void clk_disable(struct clk *clk)
> +void clk_cken_disable(struct clk *clk)
>  {
> -       unsigned long flags;
> +       struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
>
> -       WARN_ON(clk->enabled == 0);
> -
> -       spin_lock_irqsave(&clocks_lock, flags);
> -       if (--clk->enabled == 0)
> -               clk->ops->disable(clk);
> -       spin_unlock_irqrestore(&clocks_lock, flags);
> +       CKEN &= ~(1 << priv->cken);
>  }
> -EXPORT_SYMBOL(clk_disable);
>
> -unsigned long clk_get_rate(struct clk *clk)
> +unsigned long clk_cken_get_rate(struct clk *clk)
>  {
> -       unsigned long rate;
> +       struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
>
> -       rate = clk->rate;
> -       if (clk->ops->getrate)
> -               rate = clk->ops->getrate(clk);
> +       return priv->rate;
>
> -       return rate;
>  }
> -EXPORT_SYMBOL(clk_get_rate);
>
> +struct clk_ops clk_cken_ops = {
> +       .enable         = clk_cken_enable,
> +       .disable        = clk_cken_disable,
> +       .get_rate       = clk_cken_get_rate,
> +};
>
> -static void clk_gpio27_enable(struct clk *clk)
> +static inline int clk_enable_parent(struct clk *clk)
>  {
> -       pxa_gpio_mode(GPIO11_3_6MHz_MD);
> +       BUG_ON(!clk->parent);
> +       return clk_enable(clk->parent);
>  }
>
> -static void clk_gpio27_disable(struct clk *clk)
> +static inline void clk_disable_parent(struct clk *clk)
>  {
> +       BUG_ON(!clk->parent);
> +       clk_disable(clk->parent);
>  }
>
> -static const struct clkops clk_gpio27_ops = {
> -       .enable         = clk_gpio27_enable,
> -       .disable        = clk_gpio27_disable,
> -};
> -
> -
> -void clk_cken_enable(struct clk *clk)
> +static inline unsigned long clk_get_rate_parent(struct clk *clk)
>  {
> -       CKEN |= 1 << clk->cken;
> +       BUG_ON(!clk->parent);
> +       return clk_get_rate(clk->parent);
>  }
>
> -void clk_cken_disable(struct clk *clk)
> +static inline long clk_round_rate_parent(struct clk *clk, unsigned long hz, bool apply)
>  {
> -       CKEN &= ~(1 << clk->cken);
> +       BUG_ON(!clk->parent);
> +       return apply ? clk_set_rate(clk->parent, hz) :
> +               clk_round_rate(clk->parent, hz);
>  }
>
> -const struct clkops clk_cken_ops = {
> -       .enable         = clk_cken_enable,
> -       .disable        = clk_cken_disable,
> -};
> -
> -static struct clk common_clks[] = {
> -       {
> -               .name           = "GPIO27_CLK",
> -               .ops            = &clk_gpio27_ops,
> -               .rate           = 3686400,
> -       },
> -};
> -
> -void clks_register(struct clk *clks, size_t num)
> +static inline int clk_devck_can_get(struct clk *clk, struct device *dev)
>  {
> -       int i;
> +       struct clk_devck *dc = container_of(clk, struct clk_devck, clk);
>
> -       mutex_lock(&clocks_mutex);
> -       for (i = 0; i < num; i++)
> -               list_add(&clks[i].node, &clocks);
> -       mutex_unlock(&clocks_mutex);
> +       return dc->dev == dev;
>  }
>
> +struct clk_ops clk_devck_ops = {
> +       .can_get = clk_devck_can_get,
> +       .enable = clk_enable_parent,
> +       .disable = clk_disable_parent,
> +       .get_rate = clk_get_rate_parent,
> +       .round_rate = clk_round_rate_parent,
> +};
> +
>  static int __init clk_init(void)
>  {
> -       clks_register(common_clks, ARRAY_SIZE(common_clks));
> -       return 0;
> +       return clk_register(&clk_gpio11);
>  }
>  arch_initcall(clk_init);
> diff --git a/arch/arm/mach-pxa/clock.h b/arch/arm/mach-pxa/clock.h
> index bc6b77e..b787bbe 100644
> --- a/arch/arm/mach-pxa/clock.h
> +++ b/arch/arm/mach-pxa/clock.h
> @@ -1,43 +1,70 @@
> -struct clk;
> +#include <linux/clk.h>
> +#include <linux/clocklib.h>
>
> -struct clkops {
> -       void                    (*enable)(struct clk *);
> -       void                    (*disable)(struct clk *);
> -       unsigned long           (*getrate)(struct clk *);
> +struct clk_devck {
> +       struct clk              clk;
> +       const char              *parent;
> +       struct device           *dev;
>  };
>
> -struct clk {
> -       struct list_head        node;
> -       const char              *name;
> -       struct device           *dev;
> -       const struct clkops     *ops;
> +extern struct clk_ops clk_devck_ops;
> +
> +struct clk_cken {
> +       struct clk              clk;
>        unsigned long           rate;
>        unsigned int            cken;
>        unsigned int            delay;
> -       unsigned int            enabled;
>  };
>
> -#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)   \
> -       {                                               \
> -               .name   = _name,                        \
> -               .dev    = _dev,                         \
> -               .ops    = &clk_cken_ops,                \
> -               .rate   = _rate,                        \
> -               .cken   = CKEN_##_cken,                 \
> -               .delay  = _delay,                       \
> -       }
> +int clk_cken_enable(struct clk *clk);
> +void clk_cken_disable(struct clk *clk);
> +unsigned long clk_cken_get_rate(struct clk *clk);
>
> -#define INIT_CK(_name, _cken, _ops, _dev)              \
> -       {                                               \
> -               .name   = _name,                        \
> -               .dev    = _dev,                         \
> -               .ops    = _ops,                         \
> -               .cken   = CKEN_##_cken,                 \
> -       }
> +extern struct clk_ops clk_cken_ops;
>
> -extern const struct clkops clk_cken_ops;
> +static inline void clk_static_release(struct clk *clk)
> +{
> +       printk(KERN_ERR "Can't release static clock: %s!!!\n", clk->name);
> +       BUG();
> +}
>
> -void clk_cken_enable(struct clk *clk);
> -void clk_cken_disable(struct clk *clk);
> +#define INIT_CKEN(_name, _cken, _rate, _delay)         \
> +       &(struct clk_cken) {                            \
> +               .clk.name       = _name,                \
> +               .clk.ops        = &clk_cken_ops,        \
> +               .clk.release    = clk_static_release,   \
> +               .cken           = CKEN_##_cken,         \
> +               .rate           = _rate,                \
> +               .delay          = _delay,               \
> +       } .clk
>
> -void clks_register(struct clk *clks, size_t num);
> +#define INIT_CK(_name, _cken, _ops)                    \
> +       &(struct clk_cken) {                            \
> +               .clk.name       = _name,                \
> +               .clk.ops        = _ops,                 \
> +               .clk.release    = clk_static_release,   \
> +               .cken           = CKEN_##_cken,         \
> +       } .clk
> +
> +#define INIT_DEVCK(_parent_name, _name, _dev)          \
> +       {                                               \
> +               .clk.name       = _name,                \
> +               .clk.ops        = &clk_devck_ops,       \
> +               .clk.release    = clk_static_release,   \
> +               .parent         = _parent_name,         \
> +               .dev            = _dev,                 \
> +       }
> +
> +static inline void clks_devck_register(struct clk_devck *clks, int size)
> +{
> +       int i;
> +       for (i = 0; i < size; i++) {
> +               struct clk *parent = clk_get(NULL, clks[i].parent);
> +               WARN_ON(!parent);
> +               clks[i].clk.parent = parent;
> +               if (parent) {
> +                       clk_register(&clks[i].clk);
> +                       clk_put(parent);
> +               }
> +       }
> +}
> diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
> index 3920d15..de7f0b0 100644
> --- a/arch/arm/mach-pxa/pxa25x.c
> +++ b/arch/arm/mach-pxa/pxa25x.c
> @@ -103,10 +103,10 @@ static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk)
>        return pxa25x_get_memclk_frequency_10khz() * 10000;
>  }
>
> -static const struct clkops clk_pxa25x_lcd_ops = {
> +static struct clk_ops clk_pxa25x_lcd_ops = {
>        .enable         = clk_cken_enable,
>        .disable        = clk_cken_disable,
> -       .getrate        = clk_pxa25x_lcd_getrate,
> +       .get_rate       = clk_pxa25x_lcd_getrate,
>  };
>
>  /*
> @@ -114,31 +114,44 @@ static const struct clkops clk_pxa25x_lcd_ops = {
>  * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
>  * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
>  */
> -static struct clk pxa25x_hwuart_clk =
> -       INIT_CKEN("UARTCLK", HWUART, 14745600, 1, &pxa_device_hwuart.dev)
> -;
> -
> -static struct clk pxa25x_clks[] = {
> -       INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops, &pxa_device_fb.dev),
> -       INIT_CKEN("UARTCLK", FFUART, 14745600, 1, &pxa_device_ffuart.dev),
> -       INIT_CKEN("UARTCLK", BTUART, 14745600, 1, &pxa_device_btuart.dev),
> -       INIT_CKEN("UARTCLK", STUART, 14745600, 1, NULL),
> -       INIT_CKEN("UDCCLK", USB, 47923000, 5, &pxa_device_udc.dev),
> -       INIT_CKEN("MMCCLK", MMC, 19169000, 0, &pxa_device_mci.dev),
> -       INIT_CKEN("I2CCLK", I2C, 31949000, 0, &pxa_device_i2c.dev),
> -
> -       INIT_CKEN("SSPCLK",  SSP, 3686400, 0, &pxa25x_device_ssp.dev),
> -       INIT_CKEN("SSPCLK", NSSP, 3686400, 0, &pxa25x_device_nssp.dev),
> -       INIT_CKEN("SSPCLK", ASSP, 3686400, 0, &pxa25x_device_assp.dev),
> -       INIT_CKEN("PWMCLK", PWM0, 3686400, 0, &pxa25x_device_pwm0.dev),
> -       INIT_CKEN("PWMCLK", PWM1, 3686400, 0, &pxa25x_device_pwm1.dev),
> -
> -       INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
> +static struct clk *pxa25x_hwuart_clk =
> +       INIT_CKEN("HWUARTCLK", HWUART, 14745600, 1);
> +static struct clk_devck pxa25x_hwuart_devclk =
> +       INIT_DEVCK("HWUARTCLK", "UARTCLK", &pxa_device_hwuart.dev);
> +
> +static struct clk *pxa25x_clks[] = {
> +       INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops), /* &pxa_device_fb.dev */
> +       INIT_CKEN("FFUARTCLK", FFUART, 14745600, 1),
> +       INIT_CKEN("BTUARTCLK", BTUART, 14745600, 1),
> +       INIT_CKEN("STUARTCLK", STUART, 14745600, 1),
> +       INIT_CKEN("UDCCLK", USB, 47923000, 5), /* &pxa_device_udc.dev */
> +       INIT_CKEN("MMCCLK", MMC, 19169000, 0), /* &pxa_device_mci.dev */
> +       INIT_CKEN("I2CCLK", I2C, 31949000, 0), /* &pxa_device_i2c.dev */
> +
> +       INIT_CKEN("SSP_CLK",  SSP, 3686400, 0),
> +       INIT_CKEN("NSSPCLK", NSSP, 3686400, 0),
> +       INIT_CKEN("ASSPCLK", ASSP, 3686400, 0),
> +       INIT_CKEN("PWM0CLK",  PWM0, 3686400,  0),
> +       INIT_CKEN("PWM1CLK",  PWM1, 3686400,  0),
> +
> +       INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
>
>        /*
> -       INIT_CKEN("I2SCLK",  I2S,  14745600, 0, NULL),
> +       INIT_CKEN("I2SCLK",  I2S,  14745600, 0),
>        */
> -       INIT_CKEN("FICPCLK", FICP, 47923000, 0, NULL),
> +       INIT_CKEN("FICPCLK", FICP, 47923000, 0),
> +};
> +
> +static struct clk_devck clk_children[] = {
> +       INIT_DEVCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
> +       INIT_DEVCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
> +       INIT_DEVCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
> +
> +       INIT_DEVCK("SSP_CLK", "SSPCLK", &pxa25x_device_ssp.dev),
> +       INIT_DEVCK("NSSPCLK", "SSPCLK", &pxa25x_device_nssp.dev),
> +       INIT_DEVCK("ASSPCLK", "SSPCLK", &pxa25x_device_assp.dev),
> +       INIT_DEVCK("PWM0CLK", "PWMCLK", &pxa25x_device_pwm0.dev),
> +       INIT_DEVCK("PWM1CLK", "PWMCLK", &pxa25x_device_pwm1.dev),
>  };
>
>  #ifdef CONFIG_PM
> @@ -287,11 +300,15 @@ static int __init pxa25x_init(void)
>        int i, ret = 0;
>
>        /* Only add HWUART for PXA255/26x; PXA210/250/27x do not have it. */
> -       if (cpu_is_pxa25x())
> -               clks_register(&pxa25x_hwuart_clk, 1);
> +       if (cpu_is_pxa25x()) {
> +               clk_register(pxa25x_hwuart_clk);
> +               pxa25x_hwuart_devclk.clk.parent = pxa25x_hwuart_clk;
> +               clk_register(&pxa25x_hwuart_devclk.clk);
> +       }
>
>        if (cpu_is_pxa21x() || cpu_is_pxa25x()) {
>                clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
> +               clks_devck_register(ARRAY_AND_SIZE(clk_children));
>
>                if ((ret = pxa_init_dma(16)))
>                        return ret;
> diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
> index 4d7afae..a88be7a 100644
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@ -45,7 +45,7 @@ unsigned int pxa27x_get_clk_frequency_khz(int info)
>  {
>        unsigned long ccsr, clkcfg;
>        unsigned int l, L, m, M, n2, N, S;
> -               int cccr_a, t, ht, b;
> +       int cccr_a, t, ht, b;
>
>        ccsr = CCSR;
>        cccr_a = CCCR & (1 << 25);
> @@ -88,7 +88,7 @@ unsigned int pxa27x_get_memclk_frequency_10khz(void)
>  {
>        unsigned long ccsr, clkcfg;
>        unsigned int l, L, m, M;
> -               int cccr_a, b;
> +       int cccr_a, b;
>
>        ccsr = CCSR;
>        cccr_a = CCCR & (1 << 25);
> @@ -130,48 +130,63 @@ static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
>        return pxa27x_get_lcdclk_frequency_10khz() * 10000;
>  }
>
> -static const struct clkops clk_pxa27x_lcd_ops = {
> +static struct clk_ops clk_pxa27x_lcd_ops = {
>        .enable         = clk_cken_enable,
>        .disable        = clk_cken_disable,
> -       .getrate        = clk_pxa27x_lcd_getrate,
> +       .get_rate       = clk_pxa27x_lcd_getrate,
>  };
>
> -static struct clk pxa27x_clks[] = {
> -       INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops, &pxa_device_fb.dev),
> -       INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops, NULL),
> +static struct clk *pxa27x_clks[] = {
> +       INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops), /* &pxa_device_fb.dev */
> +       INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops),
>
> -       INIT_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
> -       INIT_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
> -       INIT_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
> +       INIT_CKEN("FFUARTCLK", FFUART, 14857000, 1),
> +       INIT_CKEN("BTUARTCLK", BTUART, 14857000, 1),
> +       INIT_CKEN("STUARTCLK", STUART, 14857000, 1),
>
> -       INIT_CKEN("I2SCLK",  I2S,  14682000, 0, &pxa_device_i2s.dev),
> -       INIT_CKEN("I2CCLK",  I2C,  32842000, 0, &pxa_device_i2c.dev),
> -       INIT_CKEN("UDCCLK",  USB,  48000000, 5, &pxa_device_udc.dev),
> -       INIT_CKEN("MMCCLK",  MMC,  19500000, 0, &pxa_device_mci.dev),
> -       INIT_CKEN("FICPCLK", FICP, 48000000, 0, &pxa_device_ficp.dev),
> +       INIT_CKEN("I2SCLK",  I2S,  14682000, 0), /* &pxa_device_i2s.dev */
> +       INIT_CKEN("I2C_CLK",  I2C,  32842000, 0),
> +       INIT_CKEN("UDCCLK",  USB,  48000000, 5), /* &pxa_device_udc.dev */
> +       INIT_CKEN("MMCCLK",  MMC,  19500000, 0), /* &pxa_device_mci.dev */
> +       INIT_CKEN("FICPCLK", FICP, 48000000, 0), /* &pxa_device_ficp.dev */
>
> -       INIT_CKEN("USBCLK", USBHOST, 48000000, 0, &pxa27x_device_ohci.dev),
> -       INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0, &pxa27x_device_i2c_power.dev),
> -       INIT_CKEN("KBDCLK", KEYPAD, 32768, 0, &pxa27x_device_keypad.dev),
> +       INIT_CKEN("USBCLK", USBHOST, 48000000, 0), /* &pxa27x_device_ohci.dev */
> +       INIT_CKEN("PWRI2CCLK", PWRI2C, 13000000, 0),
> +       INIT_CKEN("KBDCLK", KEYPAD, 32768, 0), /* &pxa27x_device_keypad.dev */
>
> -       INIT_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
> -       INIT_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
> -       INIT_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
> -       INIT_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
> -       INIT_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
> +       INIT_CKEN("SSP1CLK", SSP1, 13000000, 0),
> +       INIT_CKEN("SSP2CLK", SSP2, 13000000, 0),
> +       INIT_CKEN("SSP3CLK", SSP3, 13000000, 0),
> +       INIT_CKEN("PWM0CLK", PWM0, 13000000, 0),
> +       INIT_CKEN("PWM1CLK", PWM1, 13000000, 0),
>
> -       INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
> -       INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0, NULL),
> +       INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
> +       INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0),
>
>        /*
> -       INIT_CKEN("MSLCLK",  MSL,  48000000, 0, NULL),
> -       INIT_CKEN("USIMCLK", USIM, 48000000, 0, NULL),
> -       INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0, NULL),
> -       INIT_CKEN("IMCLK",   IM,   0, 0, NULL),
> -       INIT_CKEN("MEMCLK",  MEMC, 0, 0, NULL),
> +       INIT_CKEN("MSLCLK",  MSL,  48000000, 0),
> +       INIT_CKEN("USIMCLK", USIM, 48000000, 0),
> +       INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0),
> +       INIT_CKEN("IMCLK",   IM,   0, 0),
> +       INIT_CKEN("MEMCLK",  MEMC, 0, 0),
>        */
>  };
>
> +static struct clk_devck clk_children[] = {
> +       INIT_DEVCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
> +       INIT_DEVCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
> +       INIT_DEVCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
> +
> +       INIT_DEVCK("I2C_CLK", "I2CCLK", &pxa_device_i2c.dev),
> +       INIT_DEVCK("PWRI2CCLK", "I2CCLK", &pxa27x_device_i2c_power.dev),
> +
> +       INIT_DEVCK("SSP1CLK", "SSPCLK", &pxa27x_device_ssp1.dev),
> +       INIT_DEVCK("SSP2CLK", "SSPCLK", &pxa27x_device_ssp2.dev),
> +       INIT_DEVCK("SSP3CLK", "SSPCLK", &pxa27x_device_ssp3.dev),
> +       INIT_DEVCK("PWM0CLK", "PWMCLK", &pxa27x_device_pwm0.dev),
> +       INIT_DEVCK("PWM1CLK", "PWMCLK", &pxa27x_device_pwm1.dev),
> +};
> +
>  #ifdef CONFIG_PM
>
>  #define SAVE(x)                sleep_save[SLEEP_SAVE_##x] = x
> @@ -384,7 +399,8 @@ static int __init pxa27x_init(void)
>        int i, ret = 0;
>
>        if (cpu_is_pxa27x()) {
> -               clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
> +               clks_register(ARRAY_AND_SIZE(pxa27x_clks));
> +               clks_devck_register(ARRAY_AND_SIZE(clk_children));
>
>                if ((ret = pxa_init_dma(32)))
>                        return ret;
> diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
> index d26a9b0..ad78a05 100644
> --- a/arch/arm/mach-pxa/pxa3xx.c
> +++ b/arch/arm/mach-pxa/pxa3xx.c
> @@ -21,6 +21,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/sysdev.h>
> +#include <linux/delay.h>
>
>  #include <asm/hardware.h>
>  #include <asm/arch/pxa3xx-regs.h>
> @@ -144,46 +145,58 @@ static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
>        return hsio_clk;
>  }
>
> -static void clk_pxa3xx_cken_enable(struct clk *clk)
> +static int clk_pxa3xx_cken_enable(struct clk *clk)
>  {
> -       unsigned long mask = 1ul << (clk->cken & 0x1f);
> +       struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
> +       unsigned long mask = 1ul << (priv->cken & 0x1f);
>
> -       if (clk->cken < 32)
> +       if (priv->cken < 32)
>                CKENA |= mask;
>        else
>                CKENB |= mask;
> +
> +       if (priv->delay)
> +               udelay(priv->delay);
> +
> +       return 0;
>  }
>
>  static void clk_pxa3xx_cken_disable(struct clk *clk)
>  {
> -       unsigned long mask = 1ul << (clk->cken & 0x1f);
> +       struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
> +       unsigned long mask = 1ul << (priv->cken & 0x1f);
>
> -       if (clk->cken < 32)
> +       if (priv->cken < 32)
>                CKENA &= ~mask;
>        else
>                CKENB &= ~mask;
>  }
>
> -static const struct clkops clk_pxa3xx_cken_ops = {
> +static struct clk_ops clk_pxa3xx_cken_ops = {
>        .enable         = clk_pxa3xx_cken_enable,
>        .disable        = clk_pxa3xx_cken_disable,
> +       .get_rate       = clk_cken_get_rate,
>  };
>
> -static const struct clkops clk_pxa3xx_hsio_ops = {
> +static struct clk_ops clk_pxa3xx_hsio_ops = {
>        .enable         = clk_pxa3xx_cken_enable,
>        .disable        = clk_pxa3xx_cken_disable,
> -       .getrate        = clk_pxa3xx_hsio_getrate,
> +       .get_rate       = clk_pxa3xx_hsio_getrate,
>  };
>
> -static const struct clkops clk_pxa3xx_ac97_ops = {
> +static struct clk_ops clk_pxa3xx_ac97_ops = {
>        .enable         = clk_pxa3xx_cken_enable,
>        .disable        = clk_pxa3xx_cken_disable,
> -       .getrate        = clk_pxa3xx_ac97_getrate,
> +       .get_rate       = clk_pxa3xx_ac97_getrate,
>  };
>
> -static void clk_pout_enable(struct clk *clk)
> +static int clk_pout_enable(struct clk *clk)
>  {
> -       OSCC |= OSCC_PEN;
> +       OSCC &= ~OSCC_PEN;
> +
> +       udelay(70);
> +
> +       return 0;
>  }
>
>  static void clk_pout_disable(struct clk *clk)
> @@ -191,60 +204,82 @@ static void clk_pout_disable(struct clk *clk)
>        OSCC &= ~OSCC_PEN;
>  }
>
> -static const struct clkops clk_pout_ops = {
> +static unsigned long clk_pout_get_rate(struct clk *clk)
> +{
> +       return 13000000;
> +}
> +
> +static struct clk_ops clk_pout_ops = {
>        .enable         = clk_pout_enable,
>        .disable        = clk_pout_disable,
> +       .get_rate       = clk_pout_get_rate,
>  };
>
> -#define PXA3xx_CKEN(_name, _cken, _rate, _delay, _dev) \
> -       {                                               \
> -               .name   = _name,                        \
> -               .dev    = _dev,                         \
> -               .ops    = &clk_pxa3xx_cken_ops,         \
> -               .rate   = _rate,                        \
> -               .cken   = CKEN_##_cken,                 \
> -               .delay  = _delay,                       \
> -       }
> -
> -#define PXA3xx_CK(_name, _cken, _ops, _dev)            \
> -       {                                               \
> -               .name   = _name,                        \
> -               .dev    = _dev,                         \
> -               .ops    = _ops,                         \
> -               .cken   = CKEN_##_cken,                 \
> -       }
> -
> -static struct clk pxa3xx_clks[] = {
> -       {
> +#define PXA3xx_CKEN(_name, _cken, _rate, _delay)       \
> +       &(struct clk_cken) {                            \
> +               .clk.name       = _name,                \
> +               .clk.ops        = &clk_pxa3xx_cken_ops, \
> +               .clk.release    = clk_static_release,   \
> +               .cken           = CKEN_##_cken,         \
> +               .rate           = _rate,                \
> +               .delay          = _delay,               \
> +       }.clk
> +
> +#define PXA3xx_CK(_name, _cken, _ops)                  \
> +       &(struct clk_cken) {                            \
> +               .clk.name       = _name,                \
> +               .clk.ops        = _ops,                 \
> +               .clk.release    = clk_static_release,   \
> +               .cken           = CKEN_##_cken,         \
> +       }.clk
> +
> +static struct clk *pxa3xx_clks[] = {
> +       &(struct clk) {
>                .name           = "CLK_POUT",
>                .ops            = &clk_pout_ops,
> -               .rate           = 13000000,
> -               .delay          = 70,
> +               .release        = clk_static_release,
>        },
>
> -       PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops, &pxa_device_fb.dev),
> -       PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops, NULL),
> -       PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops, NULL),
> -
> -       PXA3xx_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
> -       PXA3xx_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
> -       PXA3xx_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
> -
> -       PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0, &pxa_device_i2c.dev),
> -       PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5, &pxa_device_udc.dev),
> -       PXA3xx_CKEN("USBCLK", USBH, 48000000, 0, &pxa27x_device_ohci.dev),
> -       PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0, &pxa27x_device_keypad.dev),
> -
> -       PXA3xx_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
> -       PXA3xx_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
> -       PXA3xx_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
> -       PXA3xx_CKEN("SSPCLK", SSP4, 13000000, 0, &pxa3xx_device_ssp4.dev),
> -       PXA3xx_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
> -       PXA3xx_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
> -
> -       PXA3xx_CKEN("MMCCLK", MMC1, 19500000, 0, &pxa_device_mci.dev),
> -       PXA3xx_CKEN("MMCCLK", MMC2, 19500000, 0, &pxa3xx_device_mci2.dev),
> -       PXA3xx_CKEN("MMCCLK", MMC3, 19500000, 0, &pxa3xx_device_mci3.dev),
> +       PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops), /* &pxa_device_fb.dev */
> +       PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops),
> +       PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops),
> +
> +       PXA3xx_CKEN("FFUARTCLK", FFUART, 14857000, 1),
> +       PXA3xx_CKEN("BTUARTCLK", BTUART, 14857000, 1),
> +       PXA3xx_CKEN("STUARTCLK", STUART, 14857000, 1),
> +
> +       PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0), /* &pxa_device_i2c.dev */
> +       PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5), /* &pxa_device_udc.dev */
> +       PXA3xx_CKEN("USBCLK", USBH, 48000000, 0), /* &pxa27x_device_ohci.dev */
> +       PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0), /* &pxa27x_device_keypad.dev */
> +
> +       PXA3xx_CKEN("SSP1CLK", SSP1, 13000000, 0),
> +       PXA3xx_CKEN("SSP2CLK", SSP2, 13000000, 0),
> +       PXA3xx_CKEN("SSP3CLK", SSP3, 13000000, 0),
> +       PXA3xx_CKEN("SSP4CLK", SSP4, 13000000, 0),
> +       PXA3xx_CKEN("PWM0CLK", PWM0, 13000000, 0),
> +       PXA3xx_CKEN("PWM1CLK", PWM1, 13000000, 0),
> +
> +       PXA3xx_CKEN("MMC1CLK", MMC1, 19500000, 0),
> +       PXA3xx_CKEN("MMC2CLK", MMC2, 19500000, 0),
> +       PXA3xx_CKEN("MMC3CLK", MMC3, 19500000, 0),
> +};
> +
> +static struct clk_devck clk_children[] = {
> +       INIT_DEVCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
> +       INIT_DEVCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
> +       INIT_DEVCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
> +
> +       INIT_DEVCK("SSP1CLK", "SSPCLK", &pxa27x_device_ssp1.dev),
> +       INIT_DEVCK("SSP2CLK", "SSPCLK", &pxa27x_device_ssp2.dev),
> +       INIT_DEVCK("SSP3CLK", "SSPCLK", &pxa27x_device_ssp3.dev),
> +       INIT_DEVCK("SSP4CLK", "SSPCLK", &pxa3xx_device_ssp4.dev),
> +       INIT_DEVCK("PWM0CLK", "PWMCLK", &pxa27x_device_pwm0.dev),
> +       INIT_DEVCK("PWM1CLK", "PWMCLK", &pxa27x_device_pwm1.dev),
> +
> +       INIT_DEVCK("MMC1CLK", "MMCCLK", &pxa_device_mci.dev),
> +       INIT_DEVCK("MMC2CLK", "MMCCLK", &pxa3xx_device_mci2.dev),
> +       INIT_DEVCK("MMC3CLK", "MMCCLK", &pxa3xx_device_mci3.dev),
>  };
>
>  #ifdef CONFIG_PM
> @@ -559,7 +594,8 @@ static int __init pxa3xx_init(void)
>                 */
>                ASCR &= ~(ASCR_RDH | ASCR_D1S | ASCR_D2S | ASCR_D3S);
>
> -               clks_register(pxa3xx_clks, ARRAY_SIZE(pxa3xx_clks));
> +               clks_register(ARRAY_AND_SIZE(pxa3xx_clks));
> +               clks_devck_register(ARRAY_AND_SIZE(clk_children));
>
>                if ((ret = pxa_init_dma(32)))
>                        return ret;
> --
> 1.5.5.4
>
>
> --
> With best wishes
> Dmitry
>
>

regards
Philipp
