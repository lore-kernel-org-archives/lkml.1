Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYDMOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYDMOo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbYDMOnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:43:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:50119 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbYDMOno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZJAq6dXRf0XTdCta0h/XyCPv/Y0TZ3xb9TAVteDdFP/6cfwVNY1ml9Tu4kOeWtNeEQNP8Oue1FH9WZ7G1SeS9p5LSorkj6oBNYSRsMAYriVB6cY+l5y5NwMEKmUMlH4R01yDjENCnL9iROHbfoChAGh9z6Vzjr2Th0kiJ0HJrDw=
Date: Sun, 13 Apr 2008 18:43:33 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 4/5] Clocklib: support ARM pxa sub-arch.
Message-ID: <20080413144333.GA1985@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413144138.GA31665@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig           |    1 +
 arch/arm/mach-pxa/clock.c  |  147 ++++++++++++------------------------
 arch/arm/mach-pxa/clock.h  |   63 +++++++---------
 arch/arm/mach-pxa/pxa25x.c |   79 ++++++++++++-------
 arch/arm/mach-pxa/pxa27x.c |   74 ++++++++++--------
 arch/arm/mach-pxa/pxa3xx.c |  182 ++++++++++++++++++++++++-------------------
 6 files changed, 271 insertions(+), 275 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 113ead3..7ade486 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -404,6 +404,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select HAVE_CLOCK_LIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
index e97dc59..8f7fcdd 100644
--- a/arch/arm/mach-pxa/clock.c
+++ b/arch/arm/mach-pxa/clock.c
@@ -8,6 +8,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/clk.h>
+#include <linux/clklib.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
@@ -20,135 +21,83 @@
 #include "generic.h"
 #include "clock.h"
 
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
-
-static struct clk *clk_lookup(struct device *dev, const char *id)
+static int clk_gpio11_set_mode(struct clk *clk, bool enable)
 {
-	struct clk *p;
-
-	list_for_each_entry(p, &clocks, node)
-		if (strcmp(id, p->name) == 0 && p->dev == dev)
-			return p;
+	if (enable)
+		pxa_gpio_mode(GPIO11_3_6MHz_MD);
 
-	return NULL;
-}
-
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	struct clk *p, *clk = ERR_PTR(-ENOENT);
-
-	mutex_lock(&clocks_mutex);
-	p = clk_lookup(dev, id);
-	if (!p)
-		p = clk_lookup(NULL, id);
-	if (p)
-		clk = p;
-	mutex_unlock(&clocks_mutex);
-
-	return clk;
+	return 0;
 }
-EXPORT_SYMBOL(clk_get);
 
-void clk_put(struct clk *clk)
+static unsigned long clk_gpio11_get_rate(struct clk *clk)
 {
+	return 3686400;
 }
-EXPORT_SYMBOL(clk_put);
 
-int clk_enable(struct clk *clk)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (clk->enabled++ == 0)
-		clk->ops->enable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-
-	if (clk->delay)
-		udelay(clk->delay);
+static const struct clk_ops clk_gpio11_ops = {
+	.get_rate	= clk_gpio11_get_rate,
+	.set_mode	= clk_gpio11_set_mode,
+};
 
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
+static struct clk clk_gpio11 = {
+	/* For backwards compatibility untill sa1111 and boards are fixed */
+	.name		= "GPIO27_CLK",
+	.ops		= &clk_gpio11_ops,
+	.owner		= THIS_MODULE,
+};
 
-void clk_disable(struct clk *clk)
+int clk_cken_set_mode(struct clk *clk, bool enable)
 {
-	unsigned long flags;
+	struct clk_cken *cclk = container_of(clk, struct clk_cken, clk);
+	int cken = cclk->cken;
 
-	WARN_ON(clk->enabled == 0);
+	if (enable) {
+		CKEN |= 1 << cken;
+		if (cclk->delay)
+			udelay(cclk->delay);
+	} else
+		CKEN &= ~(1 << cken);
 
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (--clk->enabled == 0)
-		clk->ops->disable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	return 0;
 }
-EXPORT_SYMBOL(clk_disable);
 
-unsigned long clk_get_rate(struct clk *clk)
+unsigned long clk_cken_get_rate(struct clk *clk)
 {
-	unsigned long rate;
-
-	rate = clk->rate;
-	if (clk->ops->getrate)
-		rate = clk->ops->getrate(clk);
+	struct clk_cken *cclk = container_of(clk, struct clk_cken, clk);
 
-	return rate;
+	return cclk->rate;
 }
-EXPORT_SYMBOL(clk_get_rate);
 
+const struct clk_ops clk_cken_ops = {
+	.set_mode = clk_cken_set_mode,
+	.get_rate = clk_cken_get_rate,
+};
 
-static void clk_gpio27_enable(struct clk *clk)
+static int clk_dev_can_get(struct clk *clk, struct device *dev)
 {
-	pxa_gpio_mode(GPIO11_3_6MHz_MD);
-}
+	struct clk_function *cfunc = container_of(clk, struct clk_function, clk);
 
-static void clk_gpio27_disable(struct clk *clk)
-{
+	return (dev == cfunc->priv);
 }
 
-static const struct clkops clk_gpio27_ops = {
-	.enable		= clk_gpio27_enable,
-	.disable	= clk_gpio27_disable,
-};
-
-
-void clk_cken_enable(struct clk *clk)
+static int clk_dev_format(struct clk *clk, struct seq_file *s)
 {
-	CKEN |= 1 << clk->cken;
-}
+	struct clk_function *cfunc = container_of(clk, struct clk_function, clk);
 
-void clk_cken_disable(struct clk *clk)
-{
-	CKEN &= ~(1 << clk->cken);
-}
+	BUG_ON(!cfunc->priv);
 
-const struct clkops clk_cken_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-};
+	seq_puts(s, " for device ");
+	seq_puts(s, ((struct device *)cfunc->priv)->bus_id);
+	return 0;
+}
 
-static struct clk common_clks[] = {
-	{
-		.name		= "GPIO27_CLK",
-		.ops		= &clk_gpio27_ops,
-		.rate		= 3686400,
-	},
+const struct clk_ops clk_dev_ops = {
+	.can_get = clk_dev_can_get,
+	.format = clk_dev_format,
 };
 
-void clks_register(struct clk *clks, size_t num)
-{
-	int i;
-
-	mutex_lock(&clocks_mutex);
-	for (i = 0; i < num; i++)
-		list_add(&clks[i].node, &clocks);
-	mutex_unlock(&clocks_mutex);
-}
-
 static int __init clk_init(void)
 {
-	clks_register(common_clks, ARRAY_SIZE(common_clks));
-	return 0;
+	return clk_register(clk_gpio11);
 }
 arch_initcall(clk_init);
diff --git a/arch/arm/mach-pxa/clock.h b/arch/arm/mach-pxa/clock.h
index bc6b77e..db645d8 100644
--- a/arch/arm/mach-pxa/clock.h
+++ b/arch/arm/mach-pxa/clock.h
@@ -1,43 +1,36 @@
-struct clk;
+#include <linux/clk.h>
+#include <linux/clklib.h>
+#include <linux/seq_file.h>
 
-struct clkops {
-	void			(*enable)(struct clk *);
-	void			(*disable)(struct clk *);
-	unsigned long		(*getrate)(struct clk *);
-};
+extern int clk_cken_set_mode(struct clk *clk, bool enable);
+extern unsigned long clk_cken_get_rate(struct clk *clk);
+extern const struct clk_ops clk_cken_ops;
 
-struct clk {
-	struct list_head	node;
-	const char		*name;
-	struct device		*dev;
-	const struct clkops	*ops;
-	unsigned long		rate;
-	unsigned int		cken;
-	unsigned int		delay;
-	unsigned int		enabled;
+struct clk_cken {
+	unsigned int	cken;
+	unsigned long	rate;
+	int		delay;
+	struct clk	clk;
 };
 
-#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)	\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_cken_ops,		\
+#define INIT_CKEN(_name, _cken, _rate, _delay)		\
+	&(&(struct clk_cken) {				\
+		.cken = CKEN_##_cken,			\
 		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
 		.delay	= _delay,			\
-	}
-
-#define INIT_CK(_name, _cken, _ops, _dev)		\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
-	}
-
-extern const struct clkops clk_cken_ops;
+		.clk = {				\
+			.name	= _name,		\
+			.ops	= &clk_cken_ops,	\
+		},					\
+	})->clk
 
-void clk_cken_enable(struct clk *clk);
-void clk_cken_disable(struct clk *clk);
+#define INIT_CK(_name, _cken, _ops)			\
+	&(&(struct clk_cken) {				\
+		.cken = CKEN_##_cken,			\
+		.clk = {				\
+			.name	= _name,		\
+			.ops	= _ops,			\
+		},					\
+	})->clk
 
-void clks_register(struct clk *clks, size_t num);
+extern const struct clk_ops clk_dev_ops;
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index e802c79..9f25ca3 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -102,10 +102,9 @@ static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk)
 	return pxa25x_get_memclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa25x_lcd_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa25x_lcd_getrate,
+static const struct clk_ops clk_pxa25x_lcd_ops = {
+	.set_mode = clk_cken_set_mode,
+	.get_rate = clk_pxa25x_lcd_getrate,
 };
 
 /*
@@ -113,31 +112,46 @@ static const struct clkops clk_pxa25x_lcd_ops = {
  * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
  * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
  */
-static struct clk pxa25x_hwuart_clk =
-	INIT_CKEN("UARTCLK", HWUART, 14745600, 1, &pxa_device_hwuart.dev)
-;
-
-static struct clk pxa25x_clks[] = {
-	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops, &pxa_device_fb.dev),
-	INIT_CKEN("UARTCLK", FFUART, 14745600, 1, &pxa_device_ffuart.dev),
-	INIT_CKEN("UARTCLK", BTUART, 14745600, 1, &pxa_device_btuart.dev),
-	INIT_CKEN("UARTCLK", STUART, 14745600, 1, NULL),
-	INIT_CKEN("UDCCLK", USB, 47923000, 5, &pxa_device_udc.dev),
-	INIT_CKEN("MMCCLK", MMC, 19169000, 0, &pxa_device_mci.dev),
-	INIT_CKEN("I2CCLK", I2C, 31949000, 0, &pxa_device_i2c.dev),
-
-	INIT_CKEN("SSPCLK",  SSP, 3686400, 0, &pxa25x_device_ssp.dev),
-	INIT_CKEN("SSPCLK", NSSP, 3686400, 0, &pxa25x_device_nssp.dev),
-	INIT_CKEN("SSPCLK", ASSP, 3686400, 0, &pxa25x_device_assp.dev),
-	INIT_CKEN("PWMCLK", PWM0, 3686400, 0, &pxa25x_device_pwm0.dev),
-	INIT_CKEN("PWMCLK", PWM1, 3686400, 0, &pxa25x_device_pwm1.dev),
-
-	INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
+static struct clk *pxa25x_hwuart_cken_clk =
+	INIT_CKEN("HWUARTCLK", HWUART, 14745600, 1);
+
+static struct clk_function pxa25x_hwuart_func =
+	CLK_FUNC("HWUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_hwuart.dev);
+
+
+static struct clk *pxa25x_clks[] = {
+	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops),
+	INIT_CKEN("FFUARTCLK", FFUART, 14745600, 1),
+	INIT_CKEN("BTUARTCLK", BTUART, 14745600, 1),
+	INIT_CKEN("STUARTCLK", STUART, 14745600, 1),
+	INIT_CKEN("UDCCLK", USB, 47923000, 5),
+	INIT_CKEN("PXAMMCCLK", MMC, 19169000, 0),
+	INIT_CKEN("I2CCLK", I2C, 31949000, 0),
+
+	INIT_CKEN("SSP_CLK",  SSP, 3686400, 0),
+	INIT_CKEN("NSSPCLK", NSSP, 3686400, 0),
+	INIT_CKEN("ASSPCLK", ASSP, 3686400, 0),
+	INIT_CKEN("PWM0CLK", PWM0, 3686400, 0),
+	INIT_CKEN("PWM1CLK", PWM1, 3686400, 0),
+
+	INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
 
 	/*
-	INIT_CKEN("I2SCLK",  I2S,  14745600, 0, NULL),
+	INIT_CKEN("I2SCLK",  I2S,  14745600, 0),
 	*/
-	INIT_CKEN("FICPCLK", FICP, 47923000, 0, NULL),
+	INIT_CKEN("FICPCLK", FICP, 47923000, 0),
+};
+
+static struct clk_function pxa25x_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_ffuart.dev),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_btuart.dev),
+	CLK_FUNC("STUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_stuart.dev),
+	CLK_FUNC("PXAMMCCLK", "MMCCLK", &clk_dev_ops, &pxa_device_mci.dev),
+	CLK_FUNC("SSP_CLK", "SSPCLK", &clk_dev_ops, &pxa25x_device_ssp.dev),
+	CLK_FUNC("NSSPCLK", "SSPCLK", &clk_dev_ops, &pxa25x_device_nssp.dev),
+	CLK_FUNC("ASSPCLK", "SSPCLK", &clk_dev_ops, &pxa25x_device_assp.dev),
+	CLK_FUNC("PWM0CLK", "PWMCLK", &clk_dev_ops, &pxa25x_device_pwm0.dev),
+	CLK_FUNC("PWM1CLK", "PWMCLK", &clk_dev_ops, &pxa25x_device_pwm1.dev),
 };
 
 #ifdef CONFIG_PM
@@ -279,17 +293,22 @@ static struct sys_device pxa25x_sysdev[] = {
 		.cls	= &pxa_gpio_sysclass,
 	},
 };
-
 static int __init pxa25x_init(void)
 {
 	int i, ret = 0;
 
 	/* Only add HWUART for PXA255/26x; PXA210/250/27x do not have it. */
-	if (cpu_is_pxa25x())
-		clks_register(&pxa25x_hwuart_clk, 1);
+	if (cpu_is_pxa25x()) {
+		ret = clk_register(pxa25x_hwuart_cken_clk);
+		if (!ret)
+			ret = clk_alloc_function(
+					pxa25x_hwuart_func.parent,
+					&pxa25x_hwuart_func.clk);
+	}
 
 	if (cpu_is_pxa21x() || cpu_is_pxa25x()) {
-		clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
+		ret = clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
+		ret = clk_alloc_functions(pxa25x_clk_funcs, ARRAY_SIZE(pxa25x_clk_funcs));
 
 		if ((ret = pxa_init_dma(16)))
 			return ret;
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 3291d6f..ecfe887 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -130,48 +130,59 @@ static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
 	return pxa27x_get_lcdclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa27x_lcd_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa27x_lcd_getrate,
+static const struct clk_ops clk_pxa27x_lcd_ops = {
+	.set_mode	= clk_cken_set_mode,
+	.get_rate	= clk_pxa27x_lcd_getrate,
 };
 
-static struct clk pxa27x_clks[] = {
-	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops, &pxa_device_fb.dev),
-	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops, NULL),
+static struct clk *pxa27x_clks[] = {
+	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops),
+	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops),
 
-	INIT_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	INIT_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	INIT_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
+	INIT_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	INIT_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	INIT_CKEN("STUARTCLK", STUART, 14857000, 1),
 
-	INIT_CKEN("I2SCLK",  I2S,  14682000, 0, &pxa_device_i2s.dev),
-	INIT_CKEN("I2CCLK",  I2C,  32842000, 0, &pxa_device_i2c.dev),
-	INIT_CKEN("UDCCLK",  USB,  48000000, 5, &pxa_device_udc.dev),
-	INIT_CKEN("MMCCLK",  MMC,  19500000, 0, &pxa_device_mci.dev),
-	INIT_CKEN("FICPCLK", FICP, 48000000, 0, &pxa_device_ficp.dev),
+	INIT_CKEN("I2SCLK",  I2S,  14682000, 0),
+	INIT_CKEN("I2CCLK",  I2C,  32842000, 0),
+	INIT_CKEN("UDCCLK",  USB,  48000000, 5),
+	INIT_CKEN("PXAMMCCLK",  MMC,  19500000, 0),
+	INIT_CKEN("FICPCLK", FICP, 48000000, 0),
 
-	INIT_CKEN("USBCLK", USBHOST, 48000000, 0, &pxa27x_device_ohci.dev),
-	INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0, &pxa27x_device_i2c_power.dev),
-	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0, &pxa27x_device_keypad.dev),
+	INIT_CKEN("USBCLK", USBHOST, 48000000, 0),
+	INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0),
+	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0),
 
-	INIT_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	INIT_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	INIT_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-	INIT_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
-	INIT_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
+	INIT_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	INIT_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	INIT_CKEN("PWM0CLK", PWM0, 13000000, 0),
+	INIT_CKEN("PWM1CLK", PWM1, 13000000, 0),
 
-	INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
-	INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0, NULL),
+	INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
+	INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0),
 
 	/*
-	INIT_CKEN("MSLCLK",  MSL,  48000000, 0, NULL),
-	INIT_CKEN("USIMCLK", USIM, 48000000, 0, NULL),
-	INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0, NULL),
-	INIT_CKEN("IMCLK",   IM,   0, 0, NULL),
-	INIT_CKEN("MEMCLK",  MEMC, 0, 0, NULL),
+	INIT_CKEN("MSLCLK",  MSL,  48000000, 0),
+	INIT_CKEN("USIMCLK", USIM, 48000000, 0),
+	INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0),
+	INIT_CKEN("IMCLK",   IM,   0, 0),
+	INIT_CKEN("MEMCLK",  MEMC, 0, 0),
 	*/
 };
 
+static struct clk_function pxa27x_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_ffuart.dev),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_btuart.dev),
+	CLK_FUNC("STUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_stuart.dev),
+	CLK_FUNC("PXAMMCCLK", "MMCCLK", &clk_dev_ops, &pxa_device_mci.dev),
+	CLK_FUNC("SSP1CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp1.dev),
+	CLK_FUNC("SSP2CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp2.dev),
+	CLK_FUNC("SSP3CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp3.dev),
+	CLK_FUNC("PWM0CLK", "PWMCLK", &clk_dev_ops, &pxa27x_device_pwm0.dev),
+	CLK_FUNC("PWM1CLK", "PWMCLK", &clk_dev_ops, &pxa27x_device_pwm1.dev),
+};
+
 #ifdef CONFIG_PM
 
 #define SAVE(x)		sleep_save[SLEEP_SAVE_##x] = x
@@ -380,7 +391,8 @@ static int __init pxa27x_init(void)
 	int i, ret = 0;
 
 	if (cpu_is_pxa27x()) {
-		clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
+		ret = clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
+		ret = clk_alloc_functions(pxa27x_clk_funcs, ARRAY_SIZE(pxa27x_clk_funcs));
 
 		if ((ret = pxa_init_dma(32)))
 			return ret;
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 7c061af..3568c31 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
@@ -144,107 +145,127 @@ static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
 	return hsio_clk;
 }
 
-static void clk_pxa3xx_cken_enable(struct clk *clk)
+static int clk_pxa3xx_cken_set_mode(struct clk *clk, bool enable)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
-
-	if (clk->cken < 32)
-		CKENA |= mask;
+	struct clk_cken *cclk = container_of(clk, struct clk_cken, clk);
+	int cken = cclk->cken;
+	unsigned long mask = 1ul << (cken & 0x1f);
+
+	if (cken < 32)
+		if (enable)
+			CKENA |= mask;
+		else
+			CKENA &= ~mask;
 	else
-		CKENB |= mask;
-}
+		if (enable)
+			CKENB |= mask;
+		else
+			CKENB &= ~mask;
 
-static void clk_pxa3xx_cken_disable(struct clk *clk)
-{
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
-
-	if (clk->cken < 32)
-		CKENA &= ~mask;
-	else
-		CKENB &= ~mask;
+	return 0;
 }
 
-static const struct clkops clk_pxa3xx_cken_ops = {
-	.enable		= clk_pxa3xx_cken_enable,
-	.disable	= clk_pxa3xx_cken_disable,
+static const struct clk_ops clk_pxa3xx_cken_ops = {
+	.set_mode	= clk_pxa3xx_cken_set_mode,
+	.get_rate	= clk_cken_get_rate,
 };
 
-static const struct clkops clk_pxa3xx_hsio_ops = {
-	.enable		= clk_pxa3xx_cken_enable,
-	.disable	= clk_pxa3xx_cken_disable,
-	.getrate	= clk_pxa3xx_hsio_getrate,
+static const struct clk_ops clk_pxa3xx_hsio_ops = {
+	.set_mode	= clk_pxa3xx_cken_set_mode,
+	.get_rate	= clk_pxa3xx_hsio_getrate,
 };
 
-static const struct clkops clk_pxa3xx_ac97_ops = {
-	.enable		= clk_pxa3xx_cken_enable,
-	.disable	= clk_pxa3xx_cken_disable,
-	.getrate	= clk_pxa3xx_ac97_getrate,
+static const struct clk_ops clk_pxa3xx_ac97_ops = {
+	.set_mode	= clk_pxa3xx_cken_set_mode,
+	.get_rate	= clk_pxa3xx_ac97_getrate,
 };
 
-static void clk_pout_enable(struct clk *clk)
+static int clk_pout_set_mode(struct clk *clk, bool enable)
 {
-	OSCC |= OSCC_PEN;
-}
+	struct clk_cken *cclk = container_of(clk, struct clk_cken, clk);
+	if (enable) {
+		OSCC |= OSCC_PEN;
+		if (cclk->delay)
+			udelay(cclk->delay);
+	} else
+		OSCC &= ~OSCC_PEN;
 
-static void clk_pout_disable(struct clk *clk)
-{
-	OSCC &= ~OSCC_PEN;
+	return 0;
 }
 
-static const struct clkops clk_pout_ops = {
-	.enable		= clk_pout_enable,
-	.disable	= clk_pout_disable,
+static const struct clk_ops clk_pout_ops = {
+	.set_mode	= clk_pout_set_mode,
+	.get_rate	= clk_cken_get_rate,
 };
 
-#define PXA3xx_CKEN(_name, _cken, _rate, _delay, _dev)	\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_pxa3xx_cken_ops,		\
+#define PXA3xx_CKEN(_name, _cken, _rate, _delay)	\
+	&(&(struct clk_cken) {				\
+		.clk	= {				\
+			.name	= _name,		\
+			.ops	= &clk_pxa3xx_cken_ops,	\
+		},					\
 		.rate	= _rate,			\
 		.cken	= CKEN_##_cken,			\
 		.delay	= _delay,			\
-	}
-
-#define PXA3xx_CK(_name, _cken, _ops, _dev)		\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
-	}
-
-static struct clk pxa3xx_clks[] = {
-	{
-		.name           = "CLK_POUT",
-		.ops            = &clk_pout_ops,
+	})->clk
+
+#define PXA3xx_CK(_name, _cken, _ops)			\
+	&(&(struct clk_cken) {				\
+		.cken = CKEN_##_cken,			\
+		.clk = {				\
+			.name	= _name,		\
+			.ops	= _ops,			\
+		},					\
+	})->clk
+
+static struct clk *pxa3xx_clks[] = {
+	&(&(struct clk_cken) {
+		.clk	= {
+			.name	= "CLK_POUT",
+			.ops	= &clk_pout_ops,
+		},
 		.rate           = 13000000,
-		.delay          = 70,
-	},
+		.delay		= 70,
+	})->clk,
+
+	PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops),
+	PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops),
+	PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops),
+
+	PXA3xx_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	PXA3xx_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	PXA3xx_CKEN("STUARTCLK", STUART, 14857000, 1),
+
+	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0),
+	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5),
+	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0),
+	PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0),
+
+	PXA3xx_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	PXA3xx_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	PXA3xx_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	PXA3xx_CKEN("SSP4CLK", SSP4, 13000000, 0),
+	PXA3xx_CKEN("PWM0CLK", PWM0, 13000000, 0),
+	PXA3xx_CKEN("PWM1CLK", PWM1, 13000000, 0),
+
+	PXA3xx_CKEN("MMC1CLK", MMC1, 19500000, 0),
+	PXA3xx_CKEN("MMC2CLK", MMC2, 19500000, 0),
+	PXA3xx_CKEN("MMC3CLK", MMC3, 19500000, 0),
+};
 
-	PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops, &pxa_device_fb.dev),
-	PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops, NULL),
-	PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops, NULL),
-
-	PXA3xx_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	PXA3xx_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	PXA3xx_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
-
-	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0, &pxa_device_i2c.dev),
-	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5, &pxa_device_udc.dev),
-	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0, &pxa27x_device_ohci.dev),
-	PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0, &pxa27x_device_keypad.dev),
-
-	PXA3xx_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	PXA3xx_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	PXA3xx_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-	PXA3xx_CKEN("SSPCLK", SSP4, 13000000, 0, &pxa3xx_device_ssp4.dev),
-	PXA3xx_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
-	PXA3xx_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
-
-	PXA3xx_CKEN("MMCCLK", MMC1, 19500000, 0, &pxa_device_mci.dev),
-	PXA3xx_CKEN("MMCCLK", MMC2, 19500000, 0, &pxa3xx_device_mci2.dev),
-	PXA3xx_CKEN("MMCCLK", MMC3, 19500000, 0, &pxa3xx_device_mci3.dev),
+static struct clk_function pxa3xx_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_ffuart.dev),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_btuart.dev),
+	CLK_FUNC("STUARTCLK", "UARTCLK", &clk_dev_ops, &pxa_device_stuart.dev),
+	CLK_FUNC("SSP1CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp1.dev),
+	CLK_FUNC("SSP2CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp2.dev),
+	CLK_FUNC("SSP3CLK", "SSPCLK", &clk_dev_ops, &pxa27x_device_ssp3.dev),
+	CLK_FUNC("SSP4CLK", "SSPCLK", &clk_dev_ops, &pxa3xx_device_ssp4.dev),
+	CLK_FUNC("MMC1CLK", "MMCCLK", &clk_dev_ops, &pxa_device_mci.dev),
+	CLK_FUNC("MMC2CLK", "MMCCLK", &clk_dev_ops, &pxa3xx_device_mci2.dev),
+	CLK_FUNC("MMC3CLK", "MMCCLK", &clk_dev_ops, &pxa3xx_device_mci3.dev),
+	CLK_FUNC("PWM0CLK", "PWMCLK", &clk_dev_ops, &pxa27x_device_pwm0.dev),
+	CLK_FUNC("PWM1CLK", "PWMCLK", &clk_dev_ops, &pxa27x_device_pwm1.dev),
 };
 
 #ifdef CONFIG_PM
@@ -556,7 +577,8 @@ static int __init pxa3xx_init(void)
 		 */
 		ASCR &= ~(ASCR_RDH | ASCR_D1S | ASCR_D2S | ASCR_D3S);
 
-		clks_register(pxa3xx_clks, ARRAY_SIZE(pxa3xx_clks));
+		ret = clks_register(pxa3xx_clks, ARRAY_SIZE(pxa3xx_clks));
+		ret = clk_alloc_functions(pxa3xx_clk_funcs, ARRAY_SIZE(pxa3xx_clk_funcs));
 
 		if ((ret = pxa_init_dma(32)))
 			return ret;
-- 
1.5.4.4


-- 
With best wishes
Dmitry

