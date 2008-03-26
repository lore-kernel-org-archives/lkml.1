Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYCZPxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYCZPxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYCZPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:53:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:55328 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391AbYCZPxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zlvd5K9CEt/eCLu2jEgPF/oK2BnfTyFDt5jYZRsClZKqwpoUo4wRYJEriWmJhMd+vtwA+4JhqKX3dO8zZWAL5Y8KahaWjkigIEJIH9Go3WDuyuzMWBEhuS73c0hqwH8B9ix3a9w/vupYkMPkZSvwW2FqKjRpJh5+0VjJXtGbIkw=
Date: Wed, 26 Mar 2008 18:53:28 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hskinnemoen@atmel.com, domen.puncer@telargo.com,
       lethal@linux-sh.org, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: [PATCH 3/3] Clocklib: support sa1100 sub-arch.
Message-ID: <20080326155328.GA15427@doriath.ww600.siemens.net>
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
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-sa1100/clock.c |   98 +++---------------------------------------
 2 files changed, 7 insertions(+), 92 deletions(-)

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
index fc97fe5..e5c4e9f 100644
--- a/arch/arm/mach-sa1100/clock.c
+++ b/arch/arm/mach-sa1100/clock.c
@@ -8,83 +8,13 @@
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
+static int clk_gpio27_enable(struct clk *clk)
 {
 	/*
 	 * First, set up the 3.6864MHz clock on GPIO 27 for the SA-1111:
@@ -93,9 +23,11 @@ static void clk_gpio27_enable(void)
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
@@ -109,26 +41,8 @@ static struct clk clk_gpio27 = {
 	.disable	= clk_gpio27_disable,
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
-
 static int __init clk_init(void)
 {
-	clk_register(&clk_gpio27);
-	return 0;
+	return clk_register(&clk_gpio27);
 }
 arch_initcall(clk_init);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

