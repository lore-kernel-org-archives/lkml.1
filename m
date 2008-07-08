Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYGHNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYGHNoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYGHNoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:44:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:42193 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYGHNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vbv8jf2YrX95U1KcYjXqAsUp4C50sllcQikL1vW3eu5hfqeWPSnG9afd6IMMmZ2enO
         1WQqYaO5ah2Y/LCVSrWXZw8JNHk6zZNMl2Ee0+v/qss7xhVbBbmtUWSpSTgg5lLijx/g
         wLUlkuVZx3U3KJ4xmvrnzHKAnO4Wptd6qOvnY=
Date: Tue, 8 Jul 2008 17:44:18 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: [PATCH 3/3] Clocklib: refactor SA-1100 to use clocklib
Message-ID: <20080708134418.GA6266@doriath.ww600.siemens.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708134242.GA6176@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make SA-1100 use clocklib for clocks support.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-sa1100/clock.c |  114 ++++++------------------------------------
 2 files changed, 17 insertions(+), 98 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index bf0dd41..d86ad6a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -460,6 +460,7 @@ config ARCH_SA1100
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select HAVE_GPIO_LIB
+	select HAVE_GENERIC_CLOCKS
 	help
 	  Support for StrongARM 11x0 based boards.
 
diff --git a/arch/arm/mach-sa1100/clock.c b/arch/arm/mach-sa1100/clock.c
index fc97fe5..472eec1 100644
--- a/arch/arm/mach-sa1100/clock.c
+++ b/arch/arm/mach-sa1100/clock.c
@@ -3,88 +3,12 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/string.h>
 #include <linux/clk.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
+#include <linux/generic_clk.h>
 
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
@@ -93,38 +17,32 @@ static void clk_gpio27_enable(void)
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
+static struct clk_ops clk_gpio27_ops = {
 	.enable		= clk_gpio27_enable,
 	.disable	= clk_gpio27_disable,
+	.get_rate	= clk_gpio27_get_rate,
 };
 
-int clk_register(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_add(&clk->node, &clocks);
-	mutex_unlock(&clocks_mutex);
-	return 0;
-}
-EXPORT_SYMBOL(clk_register);
-
-void clk_unregister(struct clk *clk)
-{
-	mutex_lock(&clocks_mutex);
-	list_del(&clk->node);
-	mutex_unlock(&clocks_mutex);
-}
-EXPORT_SYMBOL(clk_unregister);
+static struct clk clk_gpio27 = {
+	.name		= "GPIO27_CLK",
+	.ops		= &clk_gpio27_ops,
+};
 
 static int __init clk_init(void)
 {
-- 
1.5.6


-- 
With best wishes
Dmitry

