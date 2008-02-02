Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbYBBXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbYBBXCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934723AbYBBXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:01:03 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:62514 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbYBBXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eWqcEvVHberkic8uL/CTh2kR4GKdI6MWpB+FHC+9X52mCouuAleInK3z2Unxfici6Sq8A9CjzT6eCQKOglwfosMS81/3cfdQTtuYA7Z+RGpc04rEf2JWQKitlSjaZKnifhsAk+hHrrXu4jZIlJOf88t6rQyosV2XSHCAtbMCnA0=
Date: Sun, 3 Feb 2008 02:00:53 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Use clocklib for sa1100 sub-arch.
Message-ID: <20080202230053.GA16906@doriath.ww600.siemens.net>
References: <20080202225433.GA14685@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202225433.GA14685@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-sa1100/clock.c |   95 ++---------------------------------------
 2 files changed, 6 insertions(+), 90 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 45c1790..cd8f792 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -385,6 +385,7 @@ config ARCH_SA1100
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
 	select GENERIC_TIME
+	select HAVE_CLOCK_LIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
diff --git a/arch/arm/mach-sa1100/clock.c b/arch/arm/mach-sa1100/clock.c
index fc97fe5..6b3cc51 100644
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
@@ -109,23 +41,6 @@ static struct clk clk_gpio27 = {
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
 	clk_register(&clk_gpio27);
-- 
1.5.3.8


-- 
With best wishes
Dmitry

