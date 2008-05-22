Return-Path: <linux-kernel-owner+w=401wt.eu-S1764448AbYEVVXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764448AbYEVVXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979AbYEVVWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:22:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:45431 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbYEVVWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h+yRCUjV6OL54PhSPV5wtD113sLF8fldvEgcj5ttbcYabKdCdi/SLOwfVoAQ0RBl1pHRGwZbVdlnZ1oRNxNTt3S02Iv83RxFeOShymz5zQeoDqI6olDVYnlxs6JBwtPBr1D3nnpIiAGgBKPZgUHWJadjOhI7nird6X+kqDlEyYY=
Date: Fri, 23 May 2008 01:21:53 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [RFC][PATCH 2/2] Clocklib: Refactor PXA arm arch to use clocklib.
Message-ID: <20080522212153.GA11859@doriath.ww600.siemens.net>
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522211942.GA11271@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make PXA use clocklib for clocks support.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig           |    1 +
 arch/arm/mach-pxa/clock.c  |  132 ++++++++------------------------------
 arch/arm/mach-pxa/clock.h  |   48 +++++++-------
 arch/arm/mach-pxa/pxa25x.c |   60 ++++++++++--------
 arch/arm/mach-pxa/pxa27x.c |   81 +++++++++++++-----------
 arch/arm/mach-pxa/pxa3xx.c |  153 +++++++++++++++++++++++++-------------------
 6 files changed, 214 insertions(+), 261 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..04c3eef 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -397,6 +397,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select CLOCKLIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
index e97dc59..b4dbce4 100644
--- a/arch/arm/mach-pxa/clock.c
+++ b/arch/arm/mach-pxa/clock.c
@@ -8,6 +8,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/clk.h>
+#include <linux/clocklib.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
@@ -20,135 +21,56 @@
 #include "generic.h"
 #include "clock.h"
 
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
-
-static struct clk *clk_lookup(struct device *dev, const char *id)
-{
-	struct clk *p;
-
-	list_for_each_entry(p, &clocks, node)
-		if (strcmp(id, p->name) == 0 && p->dev == dev)
-			return p;
-
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
-}
-EXPORT_SYMBOL(clk_get);
-
-void clk_put(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_put);
-
-int clk_enable(struct clk *clk)
+static int clk_gpio11_set_mode(struct clk *clk, void *data, bool enable)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (clk->enabled++ == 0)
-		clk->ops->enable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-
-	if (clk->delay)
-		udelay(clk->delay);
+	if (enable)
+		pxa_gpio_mode(GPIO11_3_6MHz_MD);
 
 	return 0;
 }
-EXPORT_SYMBOL(clk_enable);
 
-void clk_disable(struct clk *clk)
+static unsigned long clk_gpio11_get_rate(struct clk *clk, void *data)
 {
-	unsigned long flags;
+	return 3686400;
+}
 
-	WARN_ON(clk->enabled == 0);
+static const struct clk_ops clk_gpio11_ops = {
+	.set_mode =	clk_gpio11_set_mode,
+	.get_rate =	clk_gpio11_get_rate,
+};
 
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (--clk->enabled == 0)
-		clk->ops->disable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-}
-EXPORT_SYMBOL(clk_disable);
 
-unsigned long clk_get_rate(struct clk *clk)
+int clk_cken_set_mode(struct clk *clk, void *data, bool enable)
 {
-	unsigned long rate;
-
-	rate = clk->rate;
-	if (clk->ops->getrate)
-		rate = clk->ops->getrate(clk);
+	struct clk_cken_priv *priv = data;
 
-	return rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
+	if (enable)
+		CKEN |= 1 << priv->cken;
+	else
+		CKEN &= ~(1 << priv->cken);
 
+	if (priv->delay)
+		udelay(priv->delay);
 
-static void clk_gpio27_enable(struct clk *clk)
-{
-	pxa_gpio_mode(GPIO11_3_6MHz_MD);
+	return 0;
 }
 
-static void clk_gpio27_disable(struct clk *clk)
+unsigned long clk_cken_get_rate(struct clk *clk, void *data)
 {
-}
-
-static const struct clkops clk_gpio27_ops = {
-	.enable		= clk_gpio27_enable,
-	.disable	= clk_gpio27_disable,
-};
-
+	struct clk_cken_priv *priv = data;
 
-void clk_cken_enable(struct clk *clk)
-{
-	CKEN |= 1 << clk->cken;
-}
+	return priv->rate;
 
-void clk_cken_disable(struct clk *clk)
-{
-	CKEN &= ~(1 << clk->cken);
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
+const struct clk_ops clk_cken_ops = {
+	.set_mode	= clk_cken_set_mode,
+	.get_rate	= clk_cken_get_rate,
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
+	clk_alloc(NULL, &clk_gpio11_ops, NULL, "GPIO27_CLK");
 	return 0;
 }
 arch_initcall(clk_init);
diff --git a/arch/arm/mach-pxa/clock.h b/arch/arm/mach-pxa/clock.h
index bc6b77e..407a80f 100644
--- a/arch/arm/mach-pxa/clock.h
+++ b/arch/arm/mach-pxa/clock.h
@@ -1,43 +1,41 @@
-struct clk;
+#include <linux/clk.h>
+#include <linux/clocklib.h>
 
-struct clkops {
-	void			(*enable)(struct clk *);
-	void			(*disable)(struct clk *);
-	unsigned long		(*getrate)(struct clk *);
-};
-
-struct clk {
-	struct list_head	node;
-	const char		*name;
-	struct device		*dev;
-	const struct clkops	*ops;
+struct clk_cken_priv {
 	unsigned long		rate;
 	unsigned int		cken;
 	unsigned int		delay;
-	unsigned int		enabled;
 };
 
-#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)	\
+#define INIT_CKEN(_name, _cken, _rate, _delay)		\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
 		.ops	= &clk_cken_ops,		\
-		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
-		.delay	= _delay,			\
+		.data	= &(struct clk_cken_priv) {	\
+			.cken	= CKEN_##_cken,		\
+			.rate	= _rate,		\
+			.delay	= _delay,		\
+		},					\
 	}
 
-#define INIT_CK(_name, _cken, _ops, _dev)		\
+#define INIT_CK(_name, _cken, _ops)			\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
 		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
+		.data	= &(struct clk_cken_priv) {	\
+			.cken	= CKEN_##_cken,		\
+		},					\
 	}
 
-extern const struct clkops clk_cken_ops;
+#define INIT_SUBCK(_parent_name, _name, _dev)		\
+	{						\
+		.parent_name	= _parent_name,		\
+		.name		= _name,		\
+		.ops		= &clk_dev_ops,		\
+		.data		= _dev,			\
+	}
 
-void clk_cken_enable(struct clk *clk);
-void clk_cken_disable(struct clk *clk);
+extern const struct clk_ops clk_cken_ops;
 
-void clks_register(struct clk *clks, size_t num);
+int clk_cken_set_mode(struct clk *clk, void *data, bool enable);
+unsigned long clk_cken_get_rate(struct clk *clk, void *data);
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index e5b417d..3410ce7 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -97,15 +97,14 @@ unsigned int pxa25x_get_memclk_frequency_10khz(void)
 	return L_clk_mult[(CCCR >> 0) & 0x1f] * BASE_CLK / 10000;
 }
 
-static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk)
+static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk, void *data)
 {
 	return pxa25x_get_memclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa25x_lcd_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa25x_lcd_getrate,
+static const struct clk_ops clk_pxa25x_lcd_ops = {
+	.set_mode	= clk_cken_set_mode,
+	.get_rate	= clk_pxa25x_lcd_getrate,
 };
 
 /*
@@ -113,31 +112,38 @@ static const struct clkops clk_pxa25x_lcd_ops = {
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
+static struct clk_table pxa25x_hwuart_clk[] = {
+	INIT_CKEN("HWUARTCLK", HWUART, 14745600, 1),
+	INIT_SUBCK("HWUARTCLK", "UARTCLK", &pxa_device_hwuart.dev),
+};
 
-	INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
+static struct clk_table pxa25x_clks[] = {
+	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_ops), /* &pxa_device_fb.dev */
+	INIT_CKEN("FFUARTCLK", FFUART, 14745600, 1),
+	INIT_SUBCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
+	INIT_CKEN("BTUARTCLK", BTUART, 14745600, 1),
+	INIT_SUBCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
+	INIT_CKEN("STUARTCLK", STUART, 14745600, 1),
+	INIT_SUBCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
+	INIT_CKEN("UDCCLK", USB, 47923000, 5), /* &pxa_device_udc.dev */
+	INIT_CKEN("MMCCLK", MMC, 19169000, 0), /* &pxa_device_mci.dev */
+	INIT_CKEN("I2CCLK", I2C, 31949000, 0), /* &pxa_device_i2c.dev */
+
+	INIT_CKEN("SSP_CLK",  SSP, 3686400, 0),
+	INIT_SUBCK("SSP_CLK", "SSPCLK", &pxa25x_device_ssp.dev),
+	INIT_CKEN("NSSPCLK", NSSP, 3686400, 0),
+	INIT_SUBCK("NSSPCLK", "SSPCLK", &pxa25x_device_nssp.dev),
+	INIT_CKEN("ASSPCLK", ASSP, 3686400, 0),
+	INIT_SUBCK("ASSPCLK", "SSPCLK", &pxa25x_device_assp.dev),
+
+	INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
 
 	/*
-	INIT_CKEN("PWMCLK",  PWM0, 3686400,  0, NULL),
-	INIT_CKEN("PWMCLK",  PWM0, 3686400,  0, NULL),
-	INIT_CKEN("I2SCLK",  I2S,  14745600, 0, NULL),
+	INIT_CKEN("PWMCLK",  PWM0, 3686400,  0),
+	INIT_CKEN("PWMCLK",  PWM0, 3686400,  0),
+	INIT_CKEN("I2SCLK",  I2S,  14745600, 0),
 	*/
-	INIT_CKEN("FICPCLK", FICP, 47923000, 0, NULL),
+	INIT_CKEN("FICPCLK", FICP, 47923000, 0),
 };
 
 #ifdef CONFIG_PM
@@ -285,7 +291,7 @@ static int __init pxa25x_init(void)
 
 	/* Only add HWUART for PXA255/26x; PXA210/250/27x do not have it. */
 	if (cpu_is_pxa25x())
-		clks_register(&pxa25x_hwuart_clk, 1);
+		clks_register(pxa25x_hwuart_clk, ARRAY_SIZE(pxa25x_hwuart_clk));
 
 	if (cpu_is_pxa21x() || cpu_is_pxa25x()) {
 		clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 7e94583..ec13349 100644
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
@@ -125,49 +125,56 @@ static unsigned int pxa27x_get_lcdclk_frequency_10khz(void)
 	return (K / 10000);
 }
 
-static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
+static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk, void *data)
 {
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
-
-	INIT_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	INIT_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	INIT_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
-
-	INIT_CKEN("I2SCLK",  I2S,  14682000, 0, &pxa_device_i2s.dev),
-	INIT_CKEN("I2CCLK",  I2C,  32842000, 0, &pxa_device_i2c.dev),
-	INIT_CKEN("UDCCLK",  USB,  48000000, 5, &pxa_device_udc.dev),
-	INIT_CKEN("MMCCLK",  MMC,  19500000, 0, &pxa_device_mci.dev),
-	INIT_CKEN("FICPCLK", FICP, 48000000, 0, &pxa_device_ficp.dev),
-
-	INIT_CKEN("USBCLK", USBHOST, 48000000, 0, &pxa27x_device_ohci.dev),
-	INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0, &pxa27x_device_i2c_power.dev),
-	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0, &pxa27x_device_keypad.dev),
-
-	INIT_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	INIT_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	INIT_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-
-	INIT_CKEN("AC97CLK",     AC97,     24576000, 0, NULL),
-	INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0, NULL),
+static struct clk_table pxa27x_clks[] = {
+	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops), /* &pxa_device_fb.dev */
+	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops),
+
+	INIT_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	INIT_SUBCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
+	INIT_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	INIT_SUBCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
+	INIT_CKEN("STUARTCLK", STUART, 14857000, 1),
+	INIT_SUBCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
+
+	INIT_CKEN("I2SCLK",  I2S,  14682000, 0), /* &pxa_device_i2s.dev */
+	INIT_CKEN("I2C_CLK",  I2C,  32842000, 0),
+	INIT_SUBCK("I2C_CLK", "I2CCLK", &pxa_device_i2c.dev),
+	INIT_CKEN("UDCCLK",  USB,  48000000, 5), /* &pxa_device_udc.dev */
+	INIT_CKEN("MMCCLK",  MMC,  19500000, 0), /* &pxa_device_mci.dev */
+	INIT_CKEN("FICPCLK", FICP, 48000000, 0), /* &pxa_device_ficp.dev */
+
+	INIT_CKEN("USBCLK", USBHOST, 48000000, 0), /* &pxa27x_device_ohci.dev */
+	INIT_CKEN("PWRI2CCLK", PWRI2C, 13000000, 0),
+	INIT_SUBCK("PWRI2CCLK", "I2CCLK", &pxa27x_device_i2c_power.dev),
+	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0), /* &pxa27x_device_keypad.dev */
+
+	INIT_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_SUBCK("SSP1CLK", "SSPCLK", &pxa27x_device_ssp1.dev),
+	INIT_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	INIT_SUBCK("SSP2CLK", "SSPCLK", &pxa27x_device_ssp2.dev),
+	INIT_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	INIT_SUBCK("SSP3CLK", "SSPCLK", &pxa27x_device_ssp3.dev),
+
+	INIT_CKEN("AC97CLK",     AC97,     24576000, 0),
+	INIT_CKEN("AC97CONFCLK", AC97CONF, 24576000, 0),
 
 	/*
-	INIT_CKEN("PWMCLK",  PWM0, 13000000, 0, NULL),
-	INIT_CKEN("MSLCLK",  MSL,  48000000, 0, NULL),
-	INIT_CKEN("USIMCLK", USIM, 48000000, 0, NULL),
-	INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0, NULL),
-	INIT_CKEN("IMCLK",   IM,   0, 0, NULL),
-	INIT_CKEN("MEMCLK",  MEMC, 0, 0, NULL),
+	INIT_CKEN("PWMCLK",  PWM0, 13000000, 0),
+	INIT_CKEN("MSLCLK",  MSL,  48000000, 0),
+	INIT_CKEN("USIMCLK", USIM, 48000000, 0),
+	INIT_CKEN("MSTKCLK", MEMSTK, 19500000, 0),
+	INIT_CKEN("IMCLK",   IM,   0, 0),
+	INIT_CKEN("MEMCLK",  MEMC, 0, 0),
 	*/
 };
 
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 644550b..e394a1a 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/sysdev.h>
+#include <linux/delay.h>
 
 #include <asm/hardware.h>
 #include <asm/arch/pxa3xx-regs.h>
@@ -112,7 +113,7 @@ unsigned int pxa3xx_get_memclk_frequency_10khz(void)
 /*
  * Return the current AC97 clock frequency.
  */
-static unsigned long clk_pxa3xx_ac97_getrate(struct clk *clk)
+static unsigned long clk_pxa3xx_ac97_getrate(struct clk *clk, void *data)
 {
 	unsigned long rate = 312000000;
 	unsigned long ac97_div;
@@ -131,7 +132,7 @@ static unsigned long clk_pxa3xx_ac97_getrate(struct clk *clk)
 /*
  * Return the current HSIO bus clock frequency
  */
-static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
+static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk, void *data)
 {
 	unsigned long acsr;
 	unsigned int hss, hsio_clk;
@@ -144,105 +145,123 @@ static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
 	return hsio_clk;
 }
 
-static void clk_pxa3xx_cken_enable(struct clk *clk)
+static int clk_pxa3xx_cken_set_mode(struct clk *clk, void *data, bool enable)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
-
-	if (clk->cken < 32)
-		CKENA |= mask;
-	else
-		CKENB |= mask;
-}
+	struct clk_cken_priv *priv = data;
+	unsigned long mask = 1ul << (priv->cken & 0x1f);
+
+	if (enable) {
+		if (priv->cken < 32)
+			CKENA |= mask;
+		else
+			CKENB |= mask;
+	} else {
+		if (priv->cken < 32)
+			CKENA &= ~mask;
+		else
+			CKENB &= ~mask;
+	}
 
-static void clk_pxa3xx_cken_disable(struct clk *clk)
-{
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
+	if (priv->delay)
+		udelay(priv->delay);
 
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
+static int clk_pout_set_mode(struct clk *clk, void *data, bool enable)
 {
-	OSCC |= OSCC_PEN;
+	if (enable)
+		OSCC |= OSCC_PEN;
+	else
+		OSCC &= ~OSCC_PEN;
+
+	udelay(70);
+
+	return 0;
 }
 
-static void clk_pout_disable(struct clk *clk)
+static unsigned long clk_pout_get_rate(struct clk *clk, void *data)
 {
-	OSCC &= ~OSCC_PEN;
+	return 13000000;
 }
 
-static const struct clkops clk_pout_ops = {
-	.enable		= clk_pout_enable,
-	.disable	= clk_pout_disable,
+static const struct clk_ops clk_pout_ops = {
+	.set_mode	= clk_pout_set_mode,
+	.get_rate	= clk_pout_get_rate,
 };
 
-#define PXA3xx_CKEN(_name, _cken, _rate, _delay, _dev)	\
+#define PXA3xx_CKEN(_name, _cken, _rate, _delay)	\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
 		.ops	= &clk_pxa3xx_cken_ops,		\
-		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
-		.delay	= _delay,			\
+		.data	= &(struct clk_cken_priv) {	\
+			.cken	= CKEN_##_cken,		\
+			.rate	= _rate,		\
+			.delay	= _delay,		\
+		},					\
 	}
 
-#define PXA3xx_CK(_name, _cken, _ops, _dev)		\
+#define PXA3xx_CK(_name, _cken, _ops)			\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
 		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
+		.data	= &(struct clk_cken_priv) {	\
+			.cken	= CKEN_##_cken,		\
+		},					\
 	}
 
-static struct clk pxa3xx_clks[] = {
+static struct clk_table pxa3xx_clks[] = {
 	{
 		.name           = "CLK_POUT",
 		.ops            = &clk_pout_ops,
-		.rate           = 13000000,
-		.delay          = 70,
 	},
 
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
-
-	PXA3xx_CKEN("MMCCLK", MMC1, 19500000, 0, &pxa_device_mci.dev),
-	PXA3xx_CKEN("MMCCLK", MMC2, 19500000, 0, &pxa3xx_device_mci2.dev),
-	PXA3xx_CKEN("MMCCLK", MMC3, 19500000, 0, &pxa3xx_device_mci3.dev),
+	PXA3xx_CK("LCDCLK",  LCD,    &clk_pxa3xx_hsio_ops), /* &pxa_device_fb.dev */
+	PXA3xx_CK("CAMCLK",  CAMERA, &clk_pxa3xx_hsio_ops),
+	PXA3xx_CK("AC97CLK", AC97,   &clk_pxa3xx_ac97_ops),
+
+	PXA3xx_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	INIT_SUBCK("FFUARTCLK", "UARTCLK", &pxa_device_ffuart.dev),
+	PXA3xx_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	INIT_SUBCK("BTUARTCLK", "UARTCLK", &pxa_device_btuart.dev),
+	PXA3xx_CKEN("STUARTCLK", STUART, 14857000, 1),
+	INIT_SUBCK("STUARTCLK", "UARTCLK", &pxa_device_stuart.dev),
+
+	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0), /* &pxa_device_i2c.dev */
+	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5), /* &pxa_device_udc.dev */
+	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0), /* &pxa27x_device_ohci.dev */
+	PXA3xx_CKEN("KBDCLK", KEYPAD,  32768, 0), /* &pxa27x_device_keypad.dev */
+
+	PXA3xx_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_SUBCK("SSP1CLK", "SSPCLK", &pxa27x_device_ssp1.dev),
+	PXA3xx_CKEN("SSP2CLK", SSP2, 13000000, 0), /* &pxa27x_device_ssp2.dev */
+	INIT_SUBCK("SSP2CLK", "SSPCLK", &pxa27x_device_ssp2.dev),
+	PXA3xx_CKEN("SSP3CLK", SSP3, 13000000, 0), /* &pxa27x_device_ssp3.dev */
+	INIT_SUBCK("SSP3CLK", "SSPCLK", &pxa27x_device_ssp3.dev),
+	PXA3xx_CKEN("SSP4CLK", SSP4, 13000000, 0), /* &pxa3xx_device_ssp4.dev */
+	INIT_SUBCK("SSP4CLK", "SSPCLK", &pxa3xx_device_ssp4.dev),
+
+	PXA3xx_CKEN("MMC1CLK", MMC1, 19500000, 0),
+	INIT_SUBCK("MMC2CLK", "MMCCLK", &pxa_device_mci.dev),
+	PXA3xx_CKEN("MMC2CLK", MMC2, 19500000, 0),
+	INIT_SUBCK("MMC2CLK", "MMCCLK", &pxa3xx_device_mci2.dev),
+	PXA3xx_CKEN("MMC3CLK", MMC3, 19500000, 0),
+	INIT_SUBCK("MMC3CLK", "MMCCLK", &pxa3xx_device_mci3.dev),
 };
 
 #ifdef CONFIG_PM
-- 
1.5.5.1


-- 
With best wishes
Dmitry

