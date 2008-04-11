Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYDKEcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYDKEcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYDKEcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:32:10 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:27956 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750945AbYDKEcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:32:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R2XlV5MevJLtlJQJSP0ILfVVaLDV+zgZjseQn/u0R0MYaBQTooC5+QCKV21k/T3TCBXyU4+5jzCfat5VT230wH9+6ja2rNggHX+92IXu8/4KEu3BjNTCP7mcUCl952bOzfBswbr36zN7t6xTm1OCwz+VpMMcVpoGXOP3ID7dFZM=  ;
X-YMail-OSG: nolsAGsVM1mAdailCjaL.NdxpUlrotNfH80r0envqUopdJmsr2w2rQi4gY0Y6cxsnvRxQziKxQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc8] omap_rng minor updates
Date: Thu, 10 Apr 2008 21:32:03 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804102132.03907.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanups to the OMAP RNG:

 - Comment update re RNG status:
     * yes, it works on 16xx; "rngtest" is quite happy
     * it's fast enough that polling vs IRQ is a non-issue
 - Get rid of BUG_ON
 - Help GCC not be stupid about inlining (object code shrink)
 - Remove "sparse" warning
 - Cope with new hotplug rule requiring "platform:" modalias

And make the file header match kernel conventions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/hw_random/omap-rng.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

--- osk2.orig/drivers/char/hw_random/omap-rng.c	2008-04-10 20:23:31.000000000 -0700
+++ osk2/drivers/char/hw_random/omap-rng.c	2008-04-10 20:38:49.000000000 -0700
@@ -1,7 +1,5 @@
 /*
- * drivers/char/hw_random/omap-rng.c
- *
- * RNG driver for TI OMAP CPU family
+ * omap-rng.c - RNG driver for TI OMAP CPU family
  *
  * Author: Deepak Saxena <dsaxena@plexity.net>
  *
@@ -15,11 +13,6 @@
  * This file is licensed under  the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
- *
- * TODO:
- *
- * - Make status updated be interrupt driven so we don't poll
- *
  */
 
 #include <linux/module.h>
@@ -55,17 +48,16 @@ static void __iomem *rng_base;
 static struct clk *rng_ick;
 static struct platform_device *rng_dev;
 
-static u32 omap_rng_read_reg(int reg)
+static inline u32 omap_rng_read_reg(int reg)
 {
 	return __raw_readl(rng_base + reg);
 }
 
-static void omap_rng_write_reg(int reg, u32 val)
+static inline void omap_rng_write_reg(int reg, u32 val)
 {
 	__raw_writel(val, rng_base + reg);
 }
 
-/* REVISIT: Does the status bit really work on 16xx? */
 static int omap_rng_data_present(struct hwrng *rng, int wait)
 {
 	int data, i;
@@ -74,6 +66,11 @@ static int omap_rng_data_present(struct 
 		data = omap_rng_read_reg(RNG_STAT_REG) ? 0 : 1;
 		if (data || !wait)
 			break;
+		/* RNG produces data fast enough (2+ MBit/sec, even
+		 * during "rngtest" loads, that these delays don't
+		 * seem to trigger.  We *could* use the RNG IRQ, but
+		 * that'd be higher overhead ... so why bother?
+		 */
 		udelay(10);
 	}
 	return data;
@@ -101,7 +98,8 @@ static int __init omap_rng_probe(struct 
 	 * A bit ugly, and it will never actually happen but there can
 	 * be only one RNG and this catches any bork
 	 */
-	BUG_ON(rng_dev);
+	if (rng_dev)
+		return -EBUSY;
 
 	if (cpu_is_omap24xx()) {
 		rng_ick = clk_get(NULL, "rng_ick");
@@ -124,7 +122,7 @@ static int __init omap_rng_probe(struct 
 		return -EBUSY;
 
 	dev_set_drvdata(&pdev->dev, mem);
-	rng_base = (u32 __iomem *)io_p2v(res->start);
+	rng_base = (u32 __force __iomem *)io_p2v(res->start);
 
 	ret = hwrng_register(&omap_rng_ops);
 	if (ret) {
@@ -182,6 +180,8 @@ static int omap_rng_resume(struct platfo
 
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:omap_rng");
 
 static struct platform_driver omap_rng_driver = {
 	.driver = {
