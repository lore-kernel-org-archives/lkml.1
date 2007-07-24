Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbXGXSRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbXGXSRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXGXSRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:17:25 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3169 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754712AbXGXSRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:17:25 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:17:23 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] mv64x60_wdt: Add a module parameter to change nowayout setting
Message-ID: <20070724181723.GH27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also, use the WATCHDOG_NOWAYOUT macro, rather than #ifdefs,
and use __module_get to prevent module unloading if WATCHDOG_NOWAYOUT
is set.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-19 22:11:42.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-19 22:34:01.000000000 +0000
@@ -45,6 +45,10 @@ static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
 static unsigned int bus_clk;
 
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
 static void mv64x60_wdt_reg_write(u32 val)
 {
 	/* Allow write only to CTL1 / CTL2 fields, retaining values in
@@ -99,6 +103,9 @@ static int mv64x60_wdt_open(struct inode
 	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
 		return -EBUSY;
 
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
 	mv64x60_wdt_service();
 	mv64x60_wdt_handler_enable();
 
@@ -109,9 +116,8 @@ static int mv64x60_wdt_release(struct in
 {
 	mv64x60_wdt_service();
 
-#if !defined(CONFIG_WATCHDOG_NOWAYOUT)
-	mv64x60_wdt_handler_disable();
-#endif
+	if (!nowayout)
+		mv64x60_wdt_handler_disable();
 
 	clear_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags);
 

