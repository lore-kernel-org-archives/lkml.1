Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbXGXSSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbXGXSSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXGXSSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:18:16 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:2404 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754483AbXGXSSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:18:15 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:18:14 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] mv64x60_wdt: Support the WDIOF_MAGICCLOSE feature
Message-ID: <20070724181813.GI27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disallow disabling of the watchdog timer unless a particular
character ('V') was recently written to the watchdog device.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   28 ++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:32:41.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:33:30.000000000 +0000
@@ -44,6 +44,7 @@ static int wdt_status;
 static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
 static unsigned int bus_clk;
+static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -115,10 +116,14 @@ static int mv64x60_wdt_open(struct inode
 
 static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 {
-	mv64x60_wdt_service();
-
-	if (!nowayout)
+	if (expect_close == 42)
 		mv64x60_wdt_handler_disable();
+	else {
+		printk(KERN_CRIT
+		       "mv64x60_wdt: unexpected close, not stopping timer!\n");
+		mv64x60_wdt_service();
+	}
+	expect_close = 0;
 
 	clear_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags);
 
@@ -128,8 +133,22 @@ static int mv64x60_wdt_release(struct in
 static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 				 size_t len, loff_t * ppos)
 {
-	if (len)
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if(get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
 		mv64x60_wdt_service();
+	}
 
 	return len;
 }
@@ -142,6 +161,7 @@ static int mv64x60_wdt_ioctl(struct inod
 	void __user *argp = (void __user *)arg;
 	static struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT	|
+				WDIOF_MAGICCLOSE	|
 				WDIOF_KEEPALIVEPING,
 		.firmware_version = 0,
 		.identity = "MV64x60 watchdog",

