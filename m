Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYCZQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYCZQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbYCZQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:17:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYCZQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FP1u+DU3Qm+rgmLaCF4ZD/2tDxC1F4TJN0qr10de20KzPr6M7ptzsaQ4rj0S6qM+PwdDrU6Rhwl2aZhrCRIUXNLdKZssHcQI6JtLEpW2ZrWVAs7j/t1I37lmAIFijrAg9ePPVfyxKJtU64L8sILi/crUMZ2VHMzi+4YWRcHpe10=
Date: Wed, 26 Mar 2008 19:17:21 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hskinnemoen@atmel.com, domen.puncer@telargo.com,
       lethal@linux-sh.org, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: [PATCH 4/4] Clocklib: support ARM pxa sub-arch.
Message-ID: <20080326161721.GA15887@doriath.ww600.siemens.net>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326154913.GA15326@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig           |    1 +
 arch/arm/mach-pxa/clock.c  |  119 +++++--------------------------------------
 arch/arm/mach-pxa/clock.h  |   58 +++++++++++----------
 arch/arm/mach-pxa/pxa25x.c |   67 +++++++++++++++----------
 arch/arm/mach-pxa/pxa27x.c |   64 +++++++++++++-----------
 arch/arm/mach-pxa/pxa3xx.c |   93 +++++++++++++++++++---------------
 6 files changed, 173 insertions(+), 229 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6d78a27..ce2ffe0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -402,6 +402,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select HAVE_CLOCK_LIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
index df5ae27..b050e64 100644
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
@@ -19,135 +20,43 @@
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
+static int clk_gpio27_enable(struct clk *clk)
 {
-}
-EXPORT_SYMBOL(clk_put);
-
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
+	pxa_gpio_mode(GPIO11_3_6MHz_MD);
 
 	return 0;
 }
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-	unsigned long flags;
-
-	WARN_ON(clk->enabled == 0);
-
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (--clk->enabled == 0)
-		clk->ops->disable(clk);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-}
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	unsigned long rate;
-
-	rate = clk->rate;
-	if (clk->ops->getrate)
-		rate = clk->ops->getrate(clk);
-
-	return rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-
-static void clk_gpio27_enable(struct clk *clk)
-{
-	pxa_gpio_mode(GPIO11_3_6MHz_MD);
-}
 
 static void clk_gpio27_disable(struct clk *clk)
 {
 }
 
-static const struct clkops clk_gpio27_ops = {
-	.enable		= clk_gpio27_enable,
-	.disable	= clk_gpio27_disable,
-};
-
-
-void clk_cken_enable(struct clk *clk)
+int clk_cken_enable(struct clk *clk)
 {
-	CKEN |= 1 << clk->cken;
+	int cken = ((struct clk_cken_priv *)clk->priv)->cken;
+	CKEN |= 1 << cken;
+
+	return 0;
 }
 
 void clk_cken_disable(struct clk *clk)
 {
-	CKEN &= ~(1 << clk->cken);
+	int cken = ((struct clk_cken_priv *)clk->priv)->cken;
+	CKEN &= ~(1 << cken);
 }
 
-const struct clkops clk_cken_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-};
-
 static struct clk common_clks[] = {
 	{
 		.name		= "GPIO27_CLK",
-		.ops		= &clk_gpio27_ops,
 		.rate		= 3686400,
+		.owner		= THIS_MODULE,
+		.enable		= clk_gpio27_enable,
+		.disable	= clk_gpio27_disable,
 	},
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
+	return clks_register(common_clks, ARRAY_SIZE(common_clks));
 }
 arch_initcall(clk_init);
diff --git a/arch/arm/mach-pxa/clock.h b/arch/arm/mach-pxa/clock.h
index bc6b77e..5ad603a 100644
--- a/arch/arm/mach-pxa/clock.h
+++ b/arch/arm/mach-pxa/clock.h
@@ -1,43 +1,45 @@
-struct clk;
+#include <linux/clklib.h>
+#include <linux/seq_file.h>
 
-struct clkops {
-	void			(*enable)(struct clk *);
-	void			(*disable)(struct clk *);
-	unsigned long		(*getrate)(struct clk *);
+struct clk_cken_priv {
+	unsigned int	cken;
 };
 
-struct clk {
-	struct list_head	node;
-	const char		*name;
-	struct device		*dev;
-	const struct clkops	*ops;
-	unsigned long		rate;
-	unsigned int		cken;
-	unsigned int		delay;
-	unsigned int		enabled;
-};
-
-#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)	\
+#define INIT_CKEN(_name, _cken, _rate, _delay)		\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_cken_ops,		\
+		.enable = clk_cken_enable,		\
+		.disable = clk_cken_disable,		\
 		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
 		.delay	= _delay,			\
+		.priv	= &(struct clk_cken_priv) {	\
+			.cken = CKEN_##_cken,		\
+		},					\
 	}
 
-#define INIT_CK(_name, _cken, _ops, _dev)		\
+#define INIT_CK(_name, _cken, _getrate)			\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
+		.enable = clk_cken_enable,		\
+		.disable = clk_cken_disable,		\
+		.getrate = _getrate,			\
+		.priv	= &(struct clk_cken_priv) {	\
+			.cken = CKEN_##_cken,		\
+		},					\
 	}
 
-extern const struct clkops clk_cken_ops;
-
-void clk_cken_enable(struct clk *clk);
+int clk_cken_enable(struct clk *clk);
 void clk_cken_disable(struct clk *clk);
 
-void clks_register(struct clk *clks, size_t num);
+static int __maybe_unused clk_dev_can_get(struct clk *clk, struct device *dev)
+{
+	return (dev == clk->priv);
+}
+
+static int __maybe_unused clk_dev_format(struct clk *clk, struct seq_file *s)
+{
+	BUG_ON(!clk->priv);
+	seq_puts(s, " for device ");
+	seq_puts(s, ((struct device *)clk->priv)->bus_id);
+	return 0;
+}
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 599e53f..1d363d3 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -101,40 +101,51 @@ static unsigned long clk_pxa25x_lcd_getrate(struct clk *clk)
 	return pxa25x_get_memclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa25x_lcd_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa25x_lcd_getrate,
-};
-
 /*
  * 3.6864MHz -> OST, GPIO, SSP, PWM, PLLs (95.842MHz, 147.456MHz)
  * 95.842MHz -> MMC 19.169MHz, I2C 31.949MHz, FICP 47.923MHz, USB 47.923MHz
  * 147.456MHz -> UART 14.7456MHz, AC97 12.288MHz, I2S 5.672MHz (allegedly)
  */
-static struct clk pxa25x_hwuart_clk =
-	INIT_CKEN("UARTCLK", HWUART, 14745600, 1, &pxa_device_hwuart.dev)
-;
+static struct clk pxa25x_hwuart_clk[] = {
+	INIT_CKEN("HWUARTCLK", HWUART, 14745600, 1),
+	{
+		.parent =	&pxa25x_hwuart_clk[0],
+		.name	=	"UARTCLK",
+		.can_get =	clk_dev_can_get,
+		.priv	=	&pxa_device_hwuart.dev,
+	},
+};
 
 static struct clk pxa25x_clks[] = {
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
+	INIT_CK("LCDCLK", LCD, &clk_pxa25x_lcd_getrate),
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
+};
+
+static struct clk_function __initdata pxa25x_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_ffuart.dev, clk_dev_format),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_btuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_stuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "SIRCLK", NULL, NULL, NULL),
+	CLK_FUNC("PXAMMCCLK", "MMCCLK", clk_dev_can_get, &pxa_device_mci.dev, clk_dev_format),
+	CLK_FUNC("SSP_CLK", "SSPCLK", clk_dev_can_get, &pxa25x_device_ssp.dev, clk_dev_format),
+	CLK_FUNC("NSSPCLK", "SSPCLK", clk_dev_can_get, &pxa25x_device_nssp.dev, clk_dev_format),
+	CLK_FUNC("ASSPCLK", "SSPCLK", clk_dev_can_get, &pxa25x_device_assp.dev, clk_dev_format),
 };
 
 #ifdef CONFIG_PM
@@ -295,11 +306,13 @@ static int __init pxa25x_init(void)
 	int i, ret = 0;
 
 	/* Only add HWUART for PXA255/26x; PXA210/250/27x do not have it. */
-	if (cpu_is_pxa25x())
-		clks_register(&pxa25x_hwuart_clk, 1);
+	if (cpu_is_pxa25x()) {
+		ret = clks_register(pxa25x_hwuart_clk, ARRAY_SIZE(pxa25x_hwuart_clk));
+	}
 
 	if (cpu_is_pxa21x() || cpu_is_pxa25x()) {
-		clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
+		ret = clks_register(pxa25x_clks, ARRAY_SIZE(pxa25x_clks));
+		ret = clk_alloc_functions(pxa25x_clk_funcs, ARRAY_SIZE(pxa25x_clk_funcs));
 
 		if ((ret = pxa_init_dma(16)))
 			return ret;
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 46a951c..304445c 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -129,44 +129,49 @@ static unsigned long clk_pxa27x_lcd_getrate(struct clk *clk)
 	return pxa27x_get_lcdclk_frequency_10khz() * 10000;
 }
 
-static const struct clkops clk_pxa27x_lcd_ops = {
-	.enable		= clk_cken_enable,
-	.disable	= clk_cken_disable,
-	.getrate	= clk_pxa27x_lcd_getrate,
-};
-
 static struct clk pxa27x_clks[] = {
-	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_ops, &pxa_device_fb.dev),
-	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_ops, NULL),
+	INIT_CK("LCDCLK", LCD,    &clk_pxa27x_lcd_getrate),
+	INIT_CK("CAMCLK", CAMERA, &clk_pxa27x_lcd_getrate),
 
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
-	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0, NULL),
+	INIT_CKEN("USBCLK", USBHOST, 48000000, 0),
+	INIT_CKEN("I2CCLK", PWRI2C, 13000000, 0),
+	INIT_CKEN("KBDCLK", KEYPAD, 32768, 0),
 
-	INIT_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	INIT_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	INIT_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
+	INIT_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	INIT_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	INIT_CKEN("SSP3CLK", SSP3, 13000000, 0),
 
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
 
+static struct clk_function __initdata pxa27x_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_ffuart.dev, clk_dev_format),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_btuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_stuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "SIRCLK", NULL, NULL, NULL),
+	CLK_FUNC("PXAMMCCLK", "MMCCLK", clk_dev_can_get, &pxa_device_mci.dev, clk_dev_format),
+	CLK_FUNC("SSP1CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp1.dev, clk_dev_format),
+	CLK_FUNC("SSP2CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp2.dev, clk_dev_format),
+	CLK_FUNC("SSP3CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp3.dev, clk_dev_format),
+};
+
 #ifdef CONFIG_PM
 
 #define SAVE(x)		sleep_save[SLEEP_SAVE_##x] = x
@@ -401,7 +406,8 @@ static int __init pxa27x_init(void)
 	int i, ret = 0;
 
 	if (cpu_is_pxa27x()) {
-		clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
+		ret = clks_register(pxa27x_clks, ARRAY_SIZE(pxa27x_clks));
+		ret = clk_alloc_functions(pxa27x_clk_funcs, ARRAY_SIZE(pxa27x_clk_funcs));
 
 		if ((ret = pxa_init_dma(32)))
 			return ret;
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 35f25fd..8b0b80e 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -125,75 +125,87 @@ static unsigned long clk_pxa3xx_hsio_getrate(struct clk *clk)
 	return hsio_clk;
 }
 
-static void clk_pxa3xx_cken_enable(struct clk *clk)
+static int clk_pxa3xx_cken_enable(struct clk *clk)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
+	int cken = ((struct clk_cken_priv *)clk->priv)->cken;
+	unsigned long mask = 1ul << (cken & 0x1f);
 
-	if (clk->cken < 32)
+	if (cken < 32)
 		CKENA |= mask;
 	else
 		CKENB |= mask;
+
+	return 0;
 }
 
 static void clk_pxa3xx_cken_disable(struct clk *clk)
 {
-	unsigned long mask = 1ul << (clk->cken & 0x1f);
+	int cken = ((struct clk_cken_priv *)clk->priv)->cken;
+	unsigned long mask = 1ul << (cken & 0x1f);
 
-	if (clk->cken < 32)
+	if (cken < 32)
 		CKENA &= ~mask;
 	else
 		CKENB &= ~mask;
 }
 
-static const struct clkops clk_pxa3xx_cken_ops = {
-	.enable		= clk_pxa3xx_cken_enable,
-	.disable	= clk_pxa3xx_cken_disable,
-};
-
-static const struct clkops clk_pxa3xx_hsio_ops = {
-	.enable		= clk_pxa3xx_cken_enable,
-	.disable	= clk_pxa3xx_cken_disable,
-	.getrate	= clk_pxa3xx_hsio_getrate,
-};
-
-#define PXA3xx_CKEN(_name, _cken, _rate, _delay, _dev)	\
+#define PXA3xx_CKEN(_name, _cken, _rate, _delay)	\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= &clk_pxa3xx_cken_ops,		\
+		.enable = clk_pxa3xx_cken_enable,	\
+		.disable = clk_pxa3xx_cken_disable,	\
 		.rate	= _rate,			\
-		.cken	= CKEN_##_cken,			\
 		.delay	= _delay,			\
+		.priv	= &(struct clk_cken_priv) {	\
+			.cken = CKEN_##_cken,		\
+		},					\
 	}
 
-#define PXA3xx_CK(_name, _cken, _ops, _dev)		\
+#define PXA3xx_CK(_name, _cken, _getrate)		\
 	{						\
 		.name	= _name,			\
-		.dev	= _dev,				\
-		.ops	= _ops,				\
-		.cken	= CKEN_##_cken,			\
+		.enable = clk_pxa3xx_cken_enable,	\
+		.disable = clk_pxa3xx_cken_disable,	\
+		.getrate = _getrate,			\
+		.priv	= &(struct clk_cken_priv) {	\
+			.cken = CKEN_##_cken,		\
+		},					\
 	}
 
 static struct clk pxa3xx_clks[] = {
-	PXA3xx_CK("LCDCLK", LCD,    &clk_pxa3xx_hsio_ops, &pxa_device_fb.dev),
-	PXA3xx_CK("CAMCLK", CAMERA, &clk_pxa3xx_hsio_ops, NULL),
+	PXA3xx_CK("LCDCLK", LCD,    &clk_pxa3xx_hsio_getrate),
+	PXA3xx_CK("CAMCLK", CAMERA, &clk_pxa3xx_hsio_getrate),
 
-	PXA3xx_CKEN("UARTCLK", FFUART, 14857000, 1, &pxa_device_ffuart.dev),
-	PXA3xx_CKEN("UARTCLK", BTUART, 14857000, 1, &pxa_device_btuart.dev),
-	PXA3xx_CKEN("UARTCLK", STUART, 14857000, 1, NULL),
+	PXA3xx_CKEN("FFUARTCLK", FFUART, 14857000, 1),
+	PXA3xx_CKEN("BTUARTCLK", BTUART, 14857000, 1),
+	PXA3xx_CKEN("STUARTCLK", STUART, 14857000, 1),
 
-	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0, &pxa_device_i2c.dev),
-	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5, &pxa_device_udc.dev),
-	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0, &pxa27x_device_ohci.dev),
+	PXA3xx_CKEN("I2CCLK", I2C,  32842000, 0),
+	PXA3xx_CKEN("UDCCLK", UDC,  48000000, 5),
+	PXA3xx_CKEN("USBCLK", USBH, 48000000, 0),
 
-	PXA3xx_CKEN("SSPCLK", SSP1, 13000000, 0, &pxa27x_device_ssp1.dev),
-	PXA3xx_CKEN("SSPCLK", SSP2, 13000000, 0, &pxa27x_device_ssp2.dev),
-	PXA3xx_CKEN("SSPCLK", SSP3, 13000000, 0, &pxa27x_device_ssp3.dev),
-	PXA3xx_CKEN("SSPCLK", SSP4, 13000000, 0, &pxa3xx_device_ssp4.dev),
+	PXA3xx_CKEN("SSP1CLK", SSP1, 13000000, 0),
+	PXA3xx_CKEN("SSP2CLK", SSP2, 13000000, 0),
+	PXA3xx_CKEN("SSP3CLK", SSP3, 13000000, 0),
+	PXA3xx_CKEN("SSP4CLK", SSP4, 13000000, 0),
+
+	PXA3xx_CKEN("MMC1CLK", MMC1, 19500000, 0),
+	PXA3xx_CKEN("MMC2CLK", MMC2, 19500000, 0),
+	PXA3xx_CKEN("MMC3CLK", MMC3, 19500000, 0),
+};
 
-	PXA3xx_CKEN("MMCCLK", MMC1, 19500000, 0, &pxa_device_mci.dev),
-	PXA3xx_CKEN("MMCCLK", MMC2, 19500000, 0, &pxa3xx_device_mci2.dev),
-	PXA3xx_CKEN("MMCCLK", MMC3, 19500000, 0, &pxa3xx_device_mci3.dev),
+static struct clk_function __initdata pxa3xx_clk_funcs[] = {
+	CLK_FUNC("FFUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_ffuart.dev, clk_dev_format),
+	CLK_FUNC("BTUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_btuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "UARTCLK", clk_dev_can_get, &pxa_device_stuart.dev, clk_dev_format),
+	CLK_FUNC("STUARTCLK", "SIRCLK", NULL, NULL, NULL),
+	CLK_FUNC("SSP1CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp1.dev, clk_dev_format),
+	CLK_FUNC("SSP2CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp2.dev, clk_dev_format),
+	CLK_FUNC("SSP3CLK", "SSPCLK", clk_dev_can_get, &pxa27x_device_ssp3.dev, clk_dev_format),
+	CLK_FUNC("SSP4CLK", "SSPCLK", clk_dev_can_get, &pxa3xx_device_ssp4.dev, clk_dev_format),
+	CLK_FUNC("MMC1CLK", "MMCCLK", clk_dev_can_get, &pxa_device_mci.dev, clk_dev_format),
+	CLK_FUNC("MMC2CLK", "MMCCLK", clk_dev_can_get, &pxa3xx_device_mci2.dev, clk_dev_format),
+	CLK_FUNC("MMC3CLK", "MMCCLK", clk_dev_can_get, &pxa3xx_device_mci3.dev, clk_dev_format),
 };
 
 #ifdef CONFIG_PM
@@ -513,7 +525,8 @@ static int __init pxa3xx_init(void)
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

