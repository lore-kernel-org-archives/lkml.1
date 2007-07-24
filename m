Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbXGXSPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbXGXSPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbXGXSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:15:29 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3128 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758905AbXGXSP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:15:28 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:15:26 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] mv64x60_wdt: Support for WDIOC_SETTIMEOUT ioctl
Message-ID: <20070724181526.GF27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to modify the watchdog timer timeout interval.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   38 +++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 7 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:32:08.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:42:01.000000000 +0000
@@ -43,6 +43,7 @@ static unsigned long wdt_flags;
 static int wdt_status;
 static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
+static unsigned int bus_clk;
 
 static void mv64x60_wdt_reg_write(u32 val)
 {
@@ -82,6 +83,18 @@ static void mv64x60_wdt_handler_enable(v
 	}
 }
 
+static void mv64x60_wdt_set_timeout(int timeout)
+{
+	/* maximum bus cycle count is 0xFFFFFFFF */
+	if (timeout > 0xFFFFFFFF / bus_clk)
+		timeout = 0xFFFFFFFF / bus_clk;
+
+	mv64x60_wdt_timeout = timeout;
+	writel((timeout * bus_clk) >> 8,
+	       mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+	mv64x60_wdt_service();
+}
+
 static int mv64x60_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
@@ -118,9 +131,11 @@ static ssize_t mv64x60_wdt_write(struct 
 static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
+	int timeout;
 	void __user *argp = (void __user *)arg;
 	static struct watchdog_info info = {
-		.options = WDIOF_KEEPALIVEPING,
+		.options =	WDIOF_SETTIMEOUT	|
+				WDIOF_KEEPALIVEPING,
 		.firmware_version = 0,
 		.identity = "MV64x60 watchdog",
 	};
@@ -150,7 +165,10 @@ static int mv64x60_wdt_ioctl(struct inod
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		return -EOPNOTSUPP;
+		if (get_user(timeout, (int __user *)argp))
+			return -EFAULT;
+		mv64x60_wdt_set_timeout(timeout);
+		/* Fall through */
 
 	case WDIOC_GETTIMEOUT:
 		if (put_user(mv64x60_wdt_timeout, (int __user *)argp))
@@ -182,15 +200,22 @@ static struct miscdevice mv64x60_wdt_mis
 static int __devinit mv64x60_wdt_probe(struct platform_device *dev)
 {
 	struct mv64x60_wdt_pdata *pdata = dev->dev.platform_data;
-	int bus_clk = 133;
 	struct resource *r;
+	int timeout = 10;
 
-	mv64x60_wdt_timeout = 10;
+	bus_clk = 133;			/* in MHz */
 	if (pdata) {
-		mv64x60_wdt_timeout = pdata->timeout;
+		timeout = pdata->timeout;
 		bus_clk = pdata->bus_clk;
 	}
 
+	/* Since bus_clk is truncated MHz, actual frequency could be
+	 * up to 1MHz higher.  Round up, since it's better to time out
+	 * too late than too soon.
+	 */
+	bus_clk++;
+	bus_clk *= 1000000;		/* convert to Hz */
+
 	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
@@ -199,8 +224,7 @@ static int __devinit mv64x60_wdt_probe(s
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
 
-	writel((mv64x60_wdt_timeout * (bus_clk * 1000000)) >> 8,
-	       mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+	mv64x60_wdt_set_timeout(timeout);
 
 	return misc_register(&mv64x60_wdt_miscdev);
 }

