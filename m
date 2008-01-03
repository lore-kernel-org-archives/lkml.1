Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYACRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYACRI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYACRIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:08:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55494 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbYACRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:08:20 -0500
Date: Thu, 3 Jan 2008 17:06:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, wim@iguana.be
Subject: [PATCH] wdt: Fix locking
Message-ID: <20080103170643.2fb89f1a@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit of _p usage shows various drivers assume inb_p is somehow
atomic. Of course it isn't and the delay can be split from the I/O cycle
causing a timing violation on chips that matter (eg this one)

With the proposed use of udelay() for some _p delays this will cease to
be a mostly theoretical bug (as the delay stall is unsplittable) and
wants fixing.

Lots of other drivers need fixing this way too.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/watchdog/wdt.c linux-2.6.24-rc6-mm1/drivers/watchdog/wdt.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/watchdog/wdt.c	2008-01-02 16:04:06.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/watchdog/wdt.c	2008-01-02 20:28:26.000000000 +0000
@@ -70,6 +70,8 @@
 static int io=0x240;
 static int irq=11;
 
+static DEFINE_SPINLOCK(wdt_lock);
+
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
 module_param(irq, int, 0);
@@ -109,6 +111,8 @@
 
 static int wdt_start(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3: Square Wave Generator */
 	wdt_ctr_mode(1,2);		/* Program CTR1 for Mode 2: Rate Generator */
@@ -117,6 +121,7 @@
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	wdt_ctr_load(2,65535);		/* Length of reset pulse */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -128,9 +133,12 @@
 
 static int wdt_stop (void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Turn the card off */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_load(2,0);		/* 0 length reset pulses now */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -143,11 +151,14 @@
 
 static int wdt_ping(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Write a watchdog value */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2: Rate Generator */
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -182,7 +193,12 @@
 
 static int wdt_get_status(int *status)
 {
-	unsigned char new_status=inb_p(WDT_SR);
+	unsigned char new_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);	
+	new_status = inb_p(WDT_SR);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 
 	*status=0;
 	if (new_status & WDC_SR_ISOI0)
@@ -214,8 +230,12 @@
 
 static int wdt_get_temperature(int *temperature)
 {
-	unsigned short c=inb_p(WDT_RT);
+	unsigned short c;
+	unsigned long flags;
 
+	spin_lock_irqsave(&wdt_lock, flags);	
+	c=inb_p(WDT_RT);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	*temperature = (c * 11 / 15) + 7;
 	return 0;
 }
@@ -237,7 +257,10 @@
 	 *	Read the status register see what is up and
 	 *	then printk it.
 	 */
-	unsigned char status=inb_p(WDT_SR);
+	unsigned char status;
+	
+	spin_lock(&wdt_lock);
+	status = inb_p(WDT_SR);
 
 	printk(KERN_CRIT "WDT status %d\n", status);
 
@@ -265,6 +288,7 @@
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
 	}
+	spin_unlock(&wdt_lock);
 	return IRQ_HANDLED;
 }
 
