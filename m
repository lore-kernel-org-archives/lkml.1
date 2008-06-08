Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYFHJWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYFHJWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbYFHJWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:22:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:12303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbYFHJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nb2af8IWFhHiyspDp7TvfxXjuxvd06b0M9LP/KYElsPAItjWiAKJrnwOuZmIWILRUu
         ykrXO2XDy9TAihIZSTTsOKH6VsQuTUMYzSM/wWixWSRaOgtWjy/w+7YqzNb5t361ygni
         gy1kV4yyijycg2RYsq5kubpKcoTCezGW4M1v8=
Date: Sun, 8 Jun 2008 13:22:08 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC][PATCH 2/3] Clocklib: refactor SA-1100 to use clocklib
Message-ID: <20080608092208.GA11487@doriath.ww600.siemens.net>
References: <20080608091954.GA11200@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608091954.GA11200@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-sa1100/clock.c |  117 ++++++++----------------------------------
 2 files changed, 22 insertions(+), 96 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..9d93017 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -424,6 +424,7 @@ config ARCH_SA1100
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select HAVE_GPIO_LIB
+	select CLOCKLIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
diff --git a/arch/arm/mach-sa1100/clock.c b/arch/arm/mach-sa1100/clock.c
index fc97fe5..862d384 100644
--- a/arch/arm/mach-sa1100/clock.c
+++ b/arch/arm/mach-sa1100/clock.c
@@ -3,88 +3,13 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/string.h>
 #include <linux/clk.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
+#include <linux/clocklib.h>
 
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
+static int clk_gpio27_enable(struct clk *clk)
 {
 	/*
 	 * First, set up the 3.6864MHz clock on GPIO 27 for the SA-1111:
@@ -93,42 +18,42 @@ static void clk_gpio27_enable(void)
 	GAFR |= GPIO_32_768kHz;
 	GPDR |= GPIO_32_768kHz;
 	TUCR = TUCR_3_6864MHz;
+
+	return 0;
 }
 
-static void clk_gpio27_disable(void)
+static void clk_gpio27_disable(struct clk *clk)
 {
 	TUCR = 0;
 	GPDR &= ~GPIO_32_768kHz;
 	GAFR &= ~GPIO_32_768kHz;
 }
 
-static struct clk clk_gpio27 = {
-	.name		= "GPIO27_CLK",
-	.rate		= 3686400,
+static unsigned long clk_gpio27_get_rate(struct clk *clk)
+{
+	return 3686400;
+}
+
+static const struct clk_ops clk_gpio27_ops = {
 	.enable		= clk_gpio27_enable,
 	.disable	= clk_gpio27_disable,
+	.get_rate	= clk_gpio27_get_rate,
 };
 
-int clk_register(struct clk *clk)
+static void clk_static_release(struct clk *clk)
 {
-	mutex_lock(&clocks_mutex);
-	list_add(&clk->node, &clocks);
-	mutex_unlock(&clocks_mutex);
-	return 0;
+	printk(KERN_ERR "Can't release static clock: %s!!!\n", clk->name);
+	BUG();
 }
-EXPORT_SYMBOL(clk_register);
 
-void clk_unregister(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_del(&clk->node);
-	mutex_unlock(&clocks_mutex);
-}
-EXPORT_SYMBOL(clk_unregister);
+static struct clk clk_gpio27 = {
+	.name = "GPIO27_CLK",
+	.ops = &clk_gpio27_ops,
+	.release = clk_static_release,
+};
 
 static int __init clk_init(void)
 {
-	clk_register(&clk_gpio27);
-	return 0;
+	return clk_add(NULL, &clk_gpio27);
 }
 arch_initcall(clk_init);
-- 
1.5.5.1


-- 
With best wishes
Dmitry

