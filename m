Return-Path: <linux-kernel-owner+w=401wt.eu-S935861AbXLQQUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935861AbXLQQUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXLQQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:20:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932750AbXLQQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:20:27 -0500
Date: Mon, 17 Dec 2007 16:12:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217161243.05c32df4@the-village.bc.nu>
In-Reply-To: <20071217143900.GA16604@elte.hu>
References: <476462BE.3030701@gmail.com>
	<4764687D.6080609@zytor.com>
	<476524DB.7020806@gmail.com>
	<20071216152250.GA21245@elte.hu>
	<4765D43E.1010800@gmail.com>
	<20071217105744.GA14315@elte.hu>
	<4766684D.40202@gmail.com>
	<20071217130933.GB27992@elte.hu>
	<47667812.8050708@gmail.com>
	<47667A85.3080100@reed.com>
	<20071217143900.GA16604@elte.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think we should be offering udelay based delays at this point.
There are a lot of drivers to fix first. This is just one trivial example

...

--- drivers/watchdog/wdt.c~	2007-12-17 15:58:49.000000000 +0000
+++ drivers/watchdog/wdt.c	2007-12-17 15:58:49.000000000 +0000
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
 	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3:
Square Wave Generator */ wdt_ctr_mode(1,2);		/* Program
CTR1 for Mode 2: Rate Generator */ @@ -117,6 +121,7 @@
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
 	wdt_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2:
Rate Generator */ wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
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
+	spinlock_irqsave(&wdt_lock, flags);	
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
 
+	spinlock_irqsave(&wdt_lock, flags);	
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
 
