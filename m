Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYGHNo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYGHNo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYGHNoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:44:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:42193 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYGHNoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jOSSyQE4Z5sEnXw4hw9Hg35b4gRJAf0o7DEo1to8mTFiJeDCR8qyhf7vwPkoPiYPxQ
         umJ6ciwyPgzJ2QfsESO/NlpSL8fexVhPGBzGkq7TrcGj9j1mItryGaEzOZXEu7otykcv
         Q864VeVuPsNI8GcwETNbAptA/fAB4GmWSpY7M=
Date: Tue, 8 Jul 2008 17:43:56 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: [PATCH 2/3] Refactor arm/pxa to use generic clocks support
Message-ID: <20080708134356.GA6257@doriath.ww600.siemens.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708134242.GA6176@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/arm/Kconfig           |    1 +
 arch/arm/mach-pxa/clock.c  |  163 ++++++++++++++++++--------------------------
 arch/arm/mach-pxa/clock.h  |  120 ++++++++++++++++----------------
 arch/arm/mach-pxa/pxa25x.c |   80 ++++++++++++---------
 arch/arm/mach-pxa/pxa27x.c |   80 +++++++++++++--------
 arch/arm/mach-pxa/pxa300.c |   10 ++-
 arch/arm/mach-pxa/pxa320.c |    4 +-
 arch/arm/mach-pxa/pxa3xx.c |  113 ++++++++++++++++++++----------
 8 files changed, 305 insertions(+), 266 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ba5d8df..bf0dd41 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -431,6 +431,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select HAVE_GENERIC_CLOCKS
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
index b2e847a..9831c58 100644
--- a/arch/arm/mach-pxa/clock.c
+++ b/arch/arm/mach-pxa/clock.c
@@ -3,155 +3,124 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/string.h>
 #include <linux/clk.h>
-#include <linux/spinlock.h>
-#include <linux/platform_device.h>
+#include <linux/generic_clk.h>
 #include <linux/delay.h>
 
 #include <asm/arch/pxa2xx-regs.h>
 #include <asm/arch/pxa2xx-gpio.h>
 #include <asm/hardware.h>
 
-#include "devices.h"
-#include "generic.h"
+//#include "devices.h"
+//#include "generic.h"
 #include "clock.h"
 
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
-
-static struct clk *clk_lookup(struct device *dev, const char *id)
+static int clk_gpio11_enable(struct clk *clk)
 {
-	struct clk *p;
-
-	list_for_each_entry(p, &clocks, node)
-		if (strcmp(id, p->name) == 0 && p->dev == dev)
-			return p;
-
-	return NULL;
+	pxa_gpio_mode(GPIO11_3_6MHz_MD);
+	return 0;
 }
 
-struct clk *clk_get(struct device *dev, const char *id)
+static void clk_gpio11_disable(struct clk *clk)
 {
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
-	if (clk && clk->ops == NULL)
-		clk = clk->other;
-
-	return clk;
+	/* do nothing */
 }
-EXPORT_SYMBOL(clk_get);
 
-void clk_put(struct clk *clk)
+static unsigned long clk_gpio11_get_rate(struct clk *clk)
 {
+	return 3686400;
 }
-EXPORT_SYMBOL(clk_put);
 
-int clk_enable(struct clk *clk)
+static struct clk_ops clk_gpio11_ops = {
+	.enable =	clk_gpio11_enable,
+	.disable =	clk_gpio11_disable,
+	.get_rate =	clk_gpio11_get_rate,
+};
+
+static struct clk clk_gpio11 = {
+	.name = "GPIO27_CLK",
+	.ops = &clk_gpio11_ops,
+	.release = clk_static_release,
+};
+
+int clk_cken_enable(struct clk *clk)
 {
-	unsigned long flags;
+	struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
 
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (clk->enabled++ == 0)
-		clk->ops->enable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	CKEN |= 1 << priv->cken;
 
-	if (clk->delay)
-		udelay(clk->delay);
+	if (priv->delay)
+		udelay(priv->delay);
 
 	return 0;
 }
-EXPORT_SYMBOL(clk_enable);
 
-void clk_disable(struct clk *clk)
+void clk_cken_disable(struct clk *clk)
 {
-	unsigned long flags;
-
-	WARN_ON(clk->enabled == 0);
+	struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
 
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (--clk->enabled == 0)
-		clk->ops->disable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	CKEN &= ~(1 << priv->cken);
 }
-EXPORT_SYMBOL(clk_disable);
 
-unsigned long clk_get_rate(struct clk *clk)
+unsigned long clk_cken_get_rate(struct clk *clk)
 {
-	unsigned long rate;
+	struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
 
-	rate = clk->rate;
-	if (clk->ops->getrate)
-		rate = clk->ops->getrate(clk);
+	return priv->rate;
 
-	return rate;
 }
-EXPORT_SYMBOL(clk_get_rate);
 
+struct clk_ops clk_cken_ops = {
+	.enable		= clk_cken_enable,
+	.disable	= clk_cken_disable,
+	.get_rate	= clk_cken_get_rate,
+};
 
-static void clk_gpio27_enable(struct clk *clk)
+static inline int clk_enable_parent(struct clk *clk)
 {
-	pxa_gpio_mode(GPIO11_3_6MHz_MD);
+	BUG_ON(!clk->parent);
+	return clk_enable(clk->parent);
 }
 
-static void clk_gpio27_disable(struct clk *clk)
+static inline void clk_disable_parent(struct clk *clk)
 {
+	BUG_ON(!clk->parent);
+	clk_disable(clk->parent);
 }
 
-static const struct clkops clk_gpio27_ops = {
-	.enable		= clk_gpio27_enable,
-	.disable	= clk_gpio27_disable,
-};
-
-
-void clk_cken_enable(struct clk *clk)
+static inline unsigned long clk_get_rate_parent(struct clk *clk)
 {
-	CKEN |= 1 << clk->cken;
+	BUG_ON(!clk->parent);
+	return clk_get_rate(clk->parent);
 }
 
-void clk_cken_disable(struct clk *clk)
+static inline long clk_round_rate_parent(struct clk *clk, unsigned long hz, bool apply)
 {
-	CKEN &= ~(1 << clk->cken);
+	BUG_ON(!clk->parent);
+	return apply ? clk_set_rate(clk->parent, hz) :
+		clk_round_rate(clk->parent, hz);
 }
 
-const struct clkops clk_cken_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-};
-
-static struct clk common_clks[] = {
-	{
-		.name		= "GPIO27_CLK",
-		.ops		= &clk_gpio27_ops,
-		.rate		= 3686400,
-	},
-};
-
-void clks_register(struct clk *clks, size_t num)
+static inline int clk_devck_can_get(struct clk *clk, struct device *dev)
 {
-	int i;
+	struct clk_devck *dc = container_of(clk, struct clk_devck, clk);
 
-	mutex_lock(&clocks_mutex);
-	for (i = 0; i < num; i++)
-		list_add(&clks[i].node, &clocks);
-	mutex_unlock(&clocks_mutex);
+	if (dc->dev == NULL)
+		return 1;
+
+	return dc->dev == dev;
 }
 
+struct clk_ops clk_devck_ops = {
+	.can_get = clk_devck_can_get,
+	.enable = clk_enable_parent,
+	.disable = clk_disable_parent,
+	.get_rate = clk_get_rate_parent,
+	.round_rate = clk_round_rate_parent,
+};
+
 static int __init clk_init(void)
 {
-	clks_register(common_clks, ARRAY_SIZE(common_clks));
-	return 0;
+	return clk_register(&clk_gpio11);
 }
 arch_initcall(clk_init);
diff --git a/arch/arm/mach-pxa/clock.h b/arch/arm/mach-pxa/clock.h
index 7bd1bbb..7637903 100644
--- a/arch/arm/mach-pxa/clock.h
+++ b/arch/arm/mach-pxa/clock.h
@@ -1,79 +1,79 @@
-struct clk;
+#include <linux/clk.h>
+#include <linux/generic_clk.h>
 
-struct clkops {
-	void			(*enable)(struct clk *);
-	void			(*disable)(struct clk *);
-	unsigned long		(*getrate)(struct clk *);
+struct clk_devck {
+	struct clk		clk;
+	struct device		*dev;
 };
 
-struct clk {
-	struct list_head	node;
-	const char		*name;
-	struct device		*dev;
-	const struct clkops	*ops;
+extern struct clk_ops clk_devck_ops;
+
+struct clk_cken {
+	struct clk		clk;
 	unsigned long		rate;
 	unsigned int		cken;
 	unsigned int		delay;
-	unsigned int		enabled;
-	struct clk		*other;
 };
 
-#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)	\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_cken_ops,		\
-		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
-		.delay	= _delay,			\
-	}
+int clk_cken_enable(struct clk *clk);
+void clk_cken_disable(struct clk *clk);
+unsigned long clk_cken_get_rate(struct clk *clk);
 
-#define INIT_CK(_name, _cken, _ops, _dev)		\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
-	}
+extern struct clk_ops clk_cken_ops;
 
-/*
- * This is a placeholder to alias one clock device+name pair
- * to another struct clk.
- */
-#define INIT_CKOTHER(_name, _other, _dev)		\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.other	= _other,			\
-	}
+static inline void clk_static_release(struct clk *clk)
+{
+	printk(KERN_ERR "Can't release static clock: %s!!!\n", clk->name);
+	BUG();
+}
 
-extern const struct clkops clk_cken_ops;
+#define INIT_CKEN(_name, _cken, _rate, _delay)		\
+	&(struct clk_cken) {				\
+		.clk.name	= _name,		\
+		.clk.ops	= &clk_cken_ops,	\
+		.clk.release	= clk_static_release,	\
+		.cken		= CKEN_##_cken,		\
+		.rate		= _rate,		\
+		.delay		= _delay,		\
+	} .clk
 
-void clk_cken_enable(struct clk *clk);
-void clk_cken_disable(struct clk *clk);
+#define INIT_CK(_name, _cken, _ops)			\
+	&(struct clk_cken) {				\
+		.clk.name	= _name,		\
+		.clk.ops	= _ops,			\
+		.clk.release	= clk_static_release,	\
+		.cken		= CKEN_##_cken,		\
+	} .clk
+
+#define INIT_DEVCK(_name, _dev)		\
+	&(struct clk_devck) {				\
+		.clk.name	= _name,		\
+		.clk.ops	= &clk_devck_ops,	\
+		.clk.release	= clk_static_release,	\
+		.dev		= _dev,			\
+	} .clk
 
 #ifdef CONFIG_PXA3xx
-#define PXA3xx_CKEN(_name, _cken, _rate, _delay, _dev)	\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_pxa3xx_cken_ops,		\
-		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
-		.delay	= _delay,			\
-	}
+#define PXA3xx_CKEN(_name, _cken, _rate, _delay)	\
+	&(struct clk_cken) {				\
+		.clk.name	= _name,		\
+		.clk.ops	= &clk_pxa3xx_cken_ops,	\
+		.clk.release	= clk_static_release,	\
+		.cken		= CKEN_##_cken,		\
+		.rate		= _rate,		\
+		.delay		= _delay,		\
+	}.clk
 
-#define PXA3xx_CK(_name, _cken, _ops, _dev)		\
-	{						\
-		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
-	}
+#define PXA3xx_CK(_name, _cken, _ops)			\
+	&(struct clk_cken) {				\
+		.clk.name	= _name,		\
+		.clk.ops	= _ops,			\
+		.clk.release	= clk_static_release,	\
+		.cken		= CKEN_##_cken,		\
+	}.clk
 
-extern const struct clkops clk_pxa3xx_cken_ops;
-extern void clk_pxa3xx_cken_enable(struct clk *);
+extern struct clk_ops clk_pxa3xx_cken_ops;
+extern int clk_pxa3xx_cken_enable(struct clk *);
 extern void clk_pxa3xx_cken_disable(struct clk *);
 #endif
 
-void clks_register(struct clk *clks, size_t num);
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 4cd50e3..da32264 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -103,10 +103,10 @@ static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk)
 	return pxa25x_get_memclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa25x_lcd_ops = {
+static struct clk_ops clk_pxa25x_lcd_ops = {
 	.enable		= clk_cken_enable,
 	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa25x_lcd_getrate,
+	.get_rate	= clk_pxa25x_lcd_getrate,
 };
 
 /*
@@ -114,39 +114,47 @@ static const struct clkops clk_pxa25x_lcd_ops = {
  * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
  * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
  */
-static struct clk pxa25x_hwuart_clk =
-	INIT_CKEN("UARTCLK", HWUART, 14745600, 1, &pxa_device_hwuart.dev)
-;
+static struct clk *pxa25x_hwuart_clk[] = {
+	INIT_CKEN("HWUARTCLK", HWUART, 14745600, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_hwuart.dev),
+};
 
-/*
- * PXA 2xx clock declarations. Order is important (see aliases below)
- * Please be careful not to disrupt the ordering.
- */
-static struct clk pxa25x_clks[] = {
-	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops, &pxa_device_fb.dev),
-	INIT_CKEN("UARTCLK", FFUART, 14745600, 1, &pxa_device_ffuart.dev),
-	INIT_CKEN("UARTCLK", BTUART, 14745600, 1, &pxa_device_btuart.dev),
-	INIT_CKEN("UARTCLK", STUART, 14745600, 1, NULL),
-	INIT_CKEN("UDCCLK", USB, 47923000, 5, &pxa25x_device_udc.dev),
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
+	// FIXME: add GPIO7_CK eq. to USBCLK
+static struct clk *pxa25x_clks[] = {
+	INIT_CKEN("FFUARTCLK", FFUART, 14745600, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_ffuart.dev),
+	INIT_CKEN("BTUARTCLK", BTUART, 14745600, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_btuart.dev),
+	INIT_CKEN("STUARTCLK", STUART, 14745600, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_stuart.dev),
+
+	INIT_CKEN("UDCCLK", USB, 47923000, 5), /* &pxa25x_device_udc.dev */
+	INIT_DEVCK("GPIO7_CK", NULL),
+
+	INIT_CKEN("SSP_CLK",  SSP, 3686400, 0),
+	INIT_DEVCK("SSPCLK", &pxa25x_device_ssp.dev),
+	INIT_CKEN("NSSPCLK", NSSP, 3686400, 0),
+	INIT_DEVCK("SSPCLK", &pxa25x_device_nssp.dev),
+	INIT_CKEN("ASSPCLK", ASSP, 3686400, 0),
+	INIT_DEVCK("SSPCLK", &pxa25x_device_assp.dev),
+	INIT_CKEN("PWM0CLK",  PWM0, 3686400,  0),
+	INIT_DEVCK("PWMCLK", &pxa25x_device_pwm0.dev),
+	INIT_CKEN("PWM1CLK",  PWM1, 3686400,  0),
+	INIT_DEVCK("PWMCLK", &pxa25x_device_pwm1.dev),
+};
+
+static struct clk *pxa25x_clks_simple[] = {
+	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops), /* &pxa_device_fb.dev */
+	INIT_CKEN("MMCCLK", MMC, 19169000, 0), /* &pxa_device_mci.dev */
+	INIT_CKEN("I2CCLK", I2C, 31949000, 0), /* &pxa_device_i2c.dev */
+	INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
 
 	/*
-	INIT_CKEN("I2SCLK",  I2S,  14745600, 0, NULL),
+	INIT_CKEN("I2SCLK",  I2S,  14745600, 0),
 	*/
-	INIT_CKEN("FICPCLK", FICP, 47923000, 0, NULL),
+	INIT_CKEN("FICPCLK", FICP, 47923000, 0),
 };
 
-static struct clk gpio7_clk = INIT_CKOTHER("GPIO7_CK", &pxa25x_clks[4], NULL);
-
 #ifdef CONFIG_PM
 
 #define SAVE(x)		sleep_save[SLEEP_SAVE_##x] = x
@@ -293,11 +301,17 @@ static int __init pxa25x_init(void)
 	int i, ret = 0;
 
 	/* Only add HWUART for PXA255/26x; PXA210/250/27x do not have it. */
-	if (cpu_is_pxa25x())
-		clks_register(&pxa25x_hwuart_clk, 1);
+	if (cpu_is_pxa25x()) {
+		pxa25x_hwuart_clk[1]->parent = pxa25x_hwuart_clk[0];
+		clks_register(ARRAY_AND_SIZE(pxa25x_hwuart_clk));
+	}
 
 	if (cpu_is_pxa21x() || cpu_is_pxa25x()) {
-		clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
+		for (i = 0; i < ARRAY_SIZE(pxa25x_clks) / 2; i++)
+			pxa25x_clks[2 * i + 1]->parent = pxa25x_clks[2 * i];
+
+		clks_register(ARRAY_AND_SIZE(pxa25x_clks));
+		clks_register(ARRAY_AND_SIZE(pxa25x_clks_simple));
 
 		if ((ret = pxa_init_dma(16)))
 			return ret;
@@ -320,8 +334,6 @@ static int __init pxa25x_init(void)
 	if (cpu_is_pxa25x())
 		ret = platform_device_register(&pxa_device_hwuart);
 
-	clks_register(&gpio7_clk, 1);
-
 	return ret;
 }
 
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index d5d14ea..783fdf7 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -45,7 +45,7 @@ unsigned int pxa27x_get_clk_frequency_khz(int info)
 {
 	unsigned long ccsr, clkcfg;
 	unsigned int l, L, m, M, n2, N, S;
-       	int cccr_a, t, ht, b;
+	int cccr_a, t, ht, b;
 
 	ccsr = CCSR;
 	cccr_a = CCCR & (1 << 25);
@@ -88,7 +88,7 @@ unsigned int pxa27x_get_memclk_frequency_10khz(void)
 {
 	unsigned long ccsr, clkcfg;
 	unsigned int l, L, m, M;
-       	int cccr_a, b;
+	int cccr_a, b;
 
 	ccsr = CCSR;
 	cccr_a = CCCR & (1 << 25);
@@ -130,45 +130,59 @@ static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
 	return pxa27x_get_lcdclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa27x_lcd_ops = {
+static struct clk_ops clk_pxa27x_lcd_ops = {
 	.enable		= clk_cken_enable,
 	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa27x_lcd_getrate,
+	.get_rate	= clk_pxa27x_lcd_getrate,
 };
 
-static struct clk pxa27x_clks[] = {
-	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops, &pxa_device_fb.dev),
-	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops, NULL),
+static struct clk *pxa27x_clks[] = {
+	INIT_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_ffuart.dev),
+	INIT_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_btuart.dev),
+	INIT_CKEN("STUARTCLK", STUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_stuart.dev),
+
+	INIT_CKEN("I2C_CLK",  I2C,  32842000, 0),
+	INIT_DEVCK("I2CCLK", &pxa_device_i2c.dev),
+	INIT_CKEN("PWRI2CCLK", PWRI2C, 13000000, 0),
+	INIT_DEVCK("I2CCLK", &pxa27x_device_i2c_power.dev),
+
+	INIT_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp1.dev),
+	INIT_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp2.dev),
+	INIT_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp3.dev),
+	INIT_CKEN("PWM0CLK", PWM0, 13000000, 0),
+	INIT_DEVCK("PWMCLK", &pxa27x_device_pwm0.dev),
+	INIT_CKEN("PWM1CLK", PWM1, 13000000, 0),
+	INIT_DEVCK("PWMCLK", &pxa27x_device_pwm1.dev),
 
-	INIT_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	INIT_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	INIT_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
+};
 
-	INIT_CKEN("I2SCLK",  I2S,  14682000, 0, &pxa_device_i2s.dev),
-	INIT_CKEN("I2CCLK",  I2C,  32842000, 0, &pxa_device_i2c.dev),
-	INIT_CKEN("UDCCLK",  USB,  48000000, 5, &pxa27x_device_udc.dev),
-	INIT_CKEN("MMCCLK",  MMC,  19500000, 0, &pxa_device_mci.dev),
-	INIT_CKEN("FICPCLK", FICP, 48000000, 0, &pxa_device_ficp.dev),
+static struct clk *pxa27x_clks_simple[] = {
+	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops), /* &pxa_device_fb.dev */
+	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops),
+	INIT_CKEN("I2SCLK",  I2S,  14682000, 0), /* &pxa_device_i2s.dev */
 
-	INIT_CKEN("USBCLK", USBHOST, 48000000, 0, &pxa27x_device_ohci.dev),
-	INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0, &pxa27x_device_i2c_power.dev),
-	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0, &pxa27x_device_keypad.dev),
+	INIT_CKEN("UDCCLK",  USB,  48000000, 5), /* &pxa27x_device_udc.dev */
+	INIT_CKEN("MMCCLK",  MMC,  19500000, 0), /* &pxa_device_mci.dev */
+	INIT_CKEN("FICPCLK", FICP, 48000000, 0), /* &pxa_device_ficp.dev */
 
-	INIT_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	INIT_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	INIT_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-	INIT_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
-	INIT_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
+	INIT_CKEN("USBCLK", USBHOST, 48000000, 0), /* &pxa27x_device_ohci.dev */
+	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0), /* &pxa27x_device_keypad.dev */
 
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
 
@@ -384,7 +398,11 @@ static int __init pxa27x_init(void)
 	int i, ret = 0;
 
 	if (cpu_is_pxa27x()) {
-		clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
+		for (i = 0; i < ARRAY_SIZE(pxa27x_clks) / 2; i++)
+			pxa27x_clks[2 * i + 1]->parent = pxa27x_clks[2 * i];
+
+		clks_register(ARRAY_AND_SIZE(pxa27x_clks));
+		clks_register(ARRAY_AND_SIZE(pxa27x_clks_simple));
 
 		if ((ret = pxa_init_dma(32)))
 			return ret;
diff --git a/arch/arm/mach-pxa/pxa300.c b/arch/arm/mach-pxa/pxa300.c
index da92e97..7790733 100644
--- a/arch/arm/mach-pxa/pxa300.c
+++ b/arch/arm/mach-pxa/pxa300.c
@@ -85,12 +85,13 @@ static struct pxa3xx_mfp_addr_map pxa310_mfp_addr_map[] __initdata = {
 	MFP_ADDR_END,
 };
 
-static struct clk common_clks[] = {
-	PXA3xx_CKEN("NANDCLK", NAND, 156000000, 0, &pxa3xx_device_nand.dev),
+static struct clk *common_clks[] = {
+	PXA3xx_CKEN("NANDCLK", NAND, 156000000, 0), /* &pxa3xx_device_nand.dev */
 };
 
-static struct clk pxa310_clks[] = {
-	PXA3xx_CKEN("MMCCLK", MMC3, 19500000, 0, &pxa3xx_device_mci3.dev),
+static struct clk *pxa310_clks[] = {
+	PXA3xx_CKEN("MMC3CLK", MMC3, 19500000, 0),
+	INIT_DEVCK("MMCCLK", &pxa3xx_device_mci3.dev),
 };
 
 static int __init pxa300_init(void)
@@ -103,6 +104,7 @@ static int __init pxa300_init(void)
 
 	if (cpu_is_pxa310()) {
 		pxa3xx_mfp_init_addr(pxa310_mfp_addr_map);
+		pxa310_clks[1]->parent = pxa310_clks[0];
 		clks_register(ARRAY_AND_SIZE(pxa310_clks));
 	}
 
diff --git a/arch/arm/mach-pxa/pxa320.c b/arch/arm/mach-pxa/pxa320.c
index c557c23..4da15e8 100644
--- a/arch/arm/mach-pxa/pxa320.c
+++ b/arch/arm/mach-pxa/pxa320.c
@@ -80,8 +80,8 @@ static struct pxa3xx_mfp_addr_map pxa320_mfp_addr_map[] __initdata = {
 	MFP_ADDR_END,
 };
 
-static struct clk pxa320_clks[] = {
-	PXA3xx_CKEN("NANDCLK", NAND, 104000000, 0, &pxa3xx_device_nand.dev),
+static struct clk *pxa320_clks[] = {
+	PXA3xx_CKEN("NANDCLK", NAND, 104000000, 0), /* &pxa3xx_device_nand.dev */
 };
 
 static int __init pxa320_init(void)
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index f491025..9f38231 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/sysdev.h>
+#include <linux/delay.h>
 
 #include <asm/hardware.h>
 #include <asm/arch/pxa3xx-regs.h>
@@ -144,46 +145,58 @@ static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
 	return hsio_clk;
 }
 
-void clk_pxa3xx_cken_enable(struct clk *clk)
+int clk_pxa3xx_cken_enable(struct clk *clk)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
+	struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
+	unsigned long mask = 1ul << (priv->cken & 0x1f);
 
-	if (clk->cken < 32)
+	if (priv->cken < 32)
 		CKENA |= mask;
 	else
 		CKENB |= mask;
+
+	if (priv->delay)
+		udelay(priv->delay);
+
+	return 0;
 }
 
 void clk_pxa3xx_cken_disable(struct clk *clk)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
+	struct clk_cken *priv = container_of(clk, struct clk_cken, clk);
+	unsigned long mask = 1ul << (priv->cken & 0x1f);
 
-	if (clk->cken < 32)
+	if (priv->cken < 32)
 		CKENA &= ~mask;
 	else
 		CKENB &= ~mask;
 }
 
-const struct clkops clk_pxa3xx_cken_ops = {
+struct clk_ops clk_pxa3xx_cken_ops = {
 	.enable		= clk_pxa3xx_cken_enable,
 	.disable	= clk_pxa3xx_cken_disable,
+	.get_rate	= clk_cken_get_rate,
 };
 
-static const struct clkops clk_pxa3xx_hsio_ops = {
+static struct clk_ops clk_pxa3xx_hsio_ops = {
 	.enable		= clk_pxa3xx_cken_enable,
 	.disable	= clk_pxa3xx_cken_disable,
-	.getrate	= clk_pxa3xx_hsio_getrate,
+	.get_rate	= clk_pxa3xx_hsio_getrate,
 };
 
-static const struct clkops clk_pxa3xx_ac97_ops = {
+static struct clk_ops clk_pxa3xx_ac97_ops = {
 	.enable		= clk_pxa3xx_cken_enable,
 	.disable	= clk_pxa3xx_cken_disable,
-	.getrate	= clk_pxa3xx_ac97_getrate,
+	.get_rate	= clk_pxa3xx_ac97_getrate,
 };
 
-static void clk_pout_enable(struct clk *clk)
+static int clk_pout_enable(struct clk *clk)
 {
-	OSCC |= OSCC_PEN;
+	OSCC &= ~OSCC_PEN;
+
+	udelay(70);
+
+	return 0;
 }
 
 static void clk_pout_disable(struct clk *clk)
@@ -191,41 +204,61 @@ static void clk_pout_disable(struct clk *clk)
 	OSCC &= ~OSCC_PEN;
 }
 
-static const struct clkops clk_pout_ops = {
+static unsigned long clk_pout_get_rate(struct clk *clk)
+{
+	return 13000000;
+}
+
+static struct clk_ops clk_pout_ops = {
 	.enable		= clk_pout_enable,
 	.disable	= clk_pout_disable,
+	.get_rate	= clk_pout_get_rate,
 };
 
-static struct clk pxa3xx_clks[] = {
-	{
+
+static struct clk *pxa3xx_clks[] = {
+	PXA3xx_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_ffuart.dev),
+	PXA3xx_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_btuart.dev),
+	PXA3xx_CKEN("STUARTCLK", STUART, 14857000, 1),
+	INIT_DEVCK("UARTCLK", &pxa_device_stuart.dev),
+
+	PXA3xx_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp1.dev),
+	PXA3xx_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp2.dev),
+	PXA3xx_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa27x_device_ssp3.dev),
+	PXA3xx_CKEN("SSP4CLK", SSP4, 13000000, 0),
+	INIT_DEVCK("SSPCLK", &pxa3xx_device_ssp4.dev),
+	PXA3xx_CKEN("PWM0CLK", PWM0, 13000000, 0),
+	INIT_DEVCK("PWMCLK", &pxa27x_device_pwm0.dev),
+	PXA3xx_CKEN("PWM1CLK", PWM1, 13000000, 0),
+	INIT_DEVCK("PWMCLK", &pxa27x_device_pwm1.dev),
+
+	PXA3xx_CKEN("MMC1CLK", MMC1, 19500000, 0),
+	INIT_DEVCK("MMCCLK", &pxa_device_mci.dev),
+	PXA3xx_CKEN("MMC2CLK", MMC2, 19500000, 0),
+	INIT_DEVCK("MMCCLK", &pxa3xx_device_mci2.dev),
+};
+
+static struct clk *pxa3xx_clks_simple[] = {
+	&(struct clk) {
 		.name           = "CLK_POUT",
 		.ops            = &clk_pout_ops,
-		.rate           = 13000000,
-		.delay          = 70,
+		.release	= clk_static_release,
 	},
 
-	PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops, &pxa_device_fb.dev),
-	PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops, NULL),
-	PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops, NULL),
-
-	PXA3xx_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	PXA3xx_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	PXA3xx_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
+	PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops), /* &pxa_device_fb.dev */
+	PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops),
+	PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops),
 
-	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0, &pxa_device_i2c.dev),
-	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5, &pxa27x_device_udc.dev),
-	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0, &pxa27x_device_ohci.dev),
-	PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0, &pxa27x_device_keypad.dev),
+	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0), /* &pxa_device_i2c.dev */
+	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5), /* &pxa27x_device_udc.dev */
+	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0), /* &pxa27x_device_ohci.dev */
+	PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0), /* &pxa27x_device_keypad.dev */
 
-	PXA3xx_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	PXA3xx_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	PXA3xx_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-	PXA3xx_CKEN("SSPCLK", SSP4, 13000000, 0, &pxa3xx_device_ssp4.dev),
-	PXA3xx_CKEN("PWMCLK", PWM0, 13000000, 0, &pxa27x_device_pwm0.dev),
-	PXA3xx_CKEN("PWMCLK", PWM1, 13000000, 0, &pxa27x_device_pwm1.dev),
-
-	PXA3xx_CKEN("MMCCLK", MMC1, 19500000, 0, &pxa_device_mci.dev),
-	PXA3xx_CKEN("MMCCLK", MMC2, 19500000, 0, &pxa3xx_device_mci2.dev),
 };
 
 #ifdef CONFIG_PM
@@ -540,7 +573,11 @@ static int __init pxa3xx_init(void)
 		 */
 		ASCR &= ~(ASCR_RDH | ASCR_D1S | ASCR_D2S | ASCR_D3S);
 
-		clks_register(pxa3xx_clks, ARRAY_SIZE(pxa3xx_clks));
+		for (i = 0; i < ARRAY_SIZE(pxa3xx_clks) / 2; i++)
+			pxa3xx_clks[2 * i + 1]->parent = pxa3xx_clks[2 * i];
+
+		clks_register(ARRAY_AND_SIZE(pxa3xx_clks));
+		clks_register(ARRAY_AND_SIZE(pxa3xx_clks_simple));
 
 		if ((ret = pxa_init_dma(32)))
 			return ret;
-- 
1.5.6


-- 
With best wishes
Dmitry

