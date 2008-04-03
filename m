Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbYDCNYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbYDCNYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYDCNX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:23:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbYDCNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UxOUHPDc7ggRMSgq7e5dh0ka9+/d2Nqq5tSTFhxWPgRmI4nvM7LA3knlJjfbEzUL9t8YGLWlL7t/k7WQEqgcNMvxRq29su0k+Tdf0eWsSjuM8mttQFJqUzMb8ewfQ1Elb1y3IOjMRerGs27IqFFldyn29EOiZTqkT+pzwQDAEv8=
Date: Thu, 3 Apr 2008 17:23:45 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 3/6] Clocklib: support sa1100 sub-arch.
Message-ID: <20080403132345.GA26990@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403132142.GA26882@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-sa1100/clock.c |  131 ++++++++++-------------------------------
 2 files changed, 33 insertions(+), 99 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4039a13..6d78a27 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -426,6 +426,7 @@ config ARCH_SA1100
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select HAVE_IDE
+	select HAVE_CLOCK_LIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
diff --git a/arch/arm/mach-sa1100/clock.c b/arch/arm/mach-sa1100/clock.c
index fc97fe5..8f9b777 100644
--- a/arch/arm/mach-sa1100/clock.c
+++ b/arch/arm/mach-sa1100/clock.c
@@ -8,127 +8,60 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/clk.h>
+#include <linux/clklib.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 
 #include <asm/hardware.h>
 
-/*
- * Very simple clock implementation - we only have one clock to
- * deal with at the moment, so we only match using the "name".
- */
-struct clk {
-	struct list_head	node;
-	unsigned long		rate;
-	const char		*name;
-	unsigned int		enabled;
-	void			(*enable)(void);
-	void			(*disable)(void);
-};
-
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
-
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	struct clk *p, *clk = ERR_PTR(-ENOENT);
-
-	mutex_lock(&clocks_mutex);
-	list_for_each_entry(p, &clocks, node) {
-		if (strcmp(id, p->name) == 0) {
-			clk = p;
-			break;
-		}
-	}
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
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocks_lock, flags);
-	if (clk->enabled++ == 0)
-		clk->enable();
-	spin_unlock_irqrestore(&clocks_lock, flags);
-	return 0;
-}
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
-		clk->disable();
-	spin_unlock_irqrestore(&clocks_lock, flags);
-}
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-
-static void clk_gpio27_enable(void)
+static int clk_gpio27_set_enable(struct clk *clk, bool enable)
 {
 	/*
 	 * First, set up the 3.6864MHz clock on GPIO 27 for the SA-1111:
 	 * (SA-1110 Developer's Manual, section 9.1.2.1)
 	 */
-	GAFR |= GPIO_32_768kHz;
-	GPDR |= GPIO_32_768kHz;
-	TUCR = TUCR_3_6864MHz;
+	if (enable) {
+		GAFR |= GPIO_32_768kHz;
+		GPDR |= GPIO_32_768kHz;
+		TUCR = TUCR_3_6864MHz;
+	} else {
+		TUCR = 0;
+		GPDR &= ~GPIO_32_768kHz;
+		GAFR &= ~GPIO_32_768kHz;
+	}
+
+	return 0;
 }
 
-static void clk_gpio27_disable(void)
+static unsigned long clk_gpio27_get_rate(struct clk *clk)
 {
-	TUCR = 0;
-	GPDR &= ~GPIO_32_768kHz;
-	GAFR &= ~GPIO_32_768kHz;
+	return 3686400;
 }
 
+static struct clk_ops clk_gpio27_ops = {
+	.get_rate	= clk_gpio27_get_rate,
+	.set_mode	= clk_gpio27_set_enable,
+};
+
 static struct clk clk_gpio27 = {
 	.name		= "GPIO27_CLK",
-	.rate		= 3686400,
-	.enable		= clk_gpio27_enable,
-	.disable	= clk_gpio27_disable,
+	.ops		= &clk_gpio27_ops,
+	.owner		= THIS_MODULE,
 };
 
-int clk_register(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_add(&clk->node, &clocks);
-	mutex_unlock(&clocks_mutex);
-	return 0;
-}
-EXPORT_SYMBOL(clk_register);
+static struct clk clk_3_6MHz= {
+	.name		= "3_6MHz_CLK",
+	.parent		= &clk_gpio27,
+	.owner		= THIS_MODULE,
+};
 
-void clk_unregister(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_del(&clk->node);
-	mutex_unlock(&clocks_mutex);
-}
-EXPORT_SYMBOL(clk_unregister);
+static struct clk* clks[] = {
+	&clk_gpio27,
+	&clk_3_6MHz,
+};
 
 static int __init clk_init(void)
 {
-	clk_register(&clk_gpio27);
-	return 0;
+	return clks_register(clks, ARRAY_SIZE(clks));
 }
 arch_initcall(clk_init);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

