Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbXJJGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbXJJGl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXJJGlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:41:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52095 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbXJJGlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:mime-version:content-type:content-transfer-encoding:x-mailer:message-id;
        b=O5YOpfQXGVRrE1N6+NjgXhTJG3SOBgZCusjhSDkhnAobSbl3ZNnzz9VGAO9Z5egevt3zCCHdpd2v3dv+D6O+FDkNweoq6V5SlseW83rFRmvK1hX6G0/FznzeDikO0CcLsYjR3/WQBG/ydpN9cR9y/VQHlar82oBC3lQGA5Ckmdc=
From: "sugaken.r3@gmail.com" <sugaken.r3@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softdog - panic instead of reboot, kernel 2.6.22.9
Date: Wed, 10 Oct 2007 15:42:32 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 4.69 (WinNT,501)
Message-Id: <7DC80B08BC13EBsugaken.r3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Ken Sugawara <sugaken.r3@gmail.com>

Description: Add an option to softdog to panic upon timer expiration 
instead of reboot.

Signed-off-by: Ken Sugawara <sugaken.r3@gmail.com>
---
This patch is intended to help increase the chance of postmortem 
analysis in the event of silent system hang where it is impossible to 
initiate crash dump manually (e.g. no console or network response).  
We've had occasions where some of our customers had silent system hang 
problems in which they were unable to obtain vmcore for root cause 
analysis.  Provided that timer interrupts are not blocked, this patch 
might enable them to get a crash dump in such a situation by activating 
softdog.

--- linux-2.6.22.9/drivers/char/watchdog/softdog.c.orig	2007-09-27 03:03:01.000000000 +0900
+++ linux-2.6.22.9/drivers/char/watchdog/softdog.c	2007-10-04 12:06:28.000000000 +0900
@@ -49,6 +49,7 @@
 #include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
+#include <linux/kernel.h>
 
 #define PFX "SoftDog: "
 
@@ -70,6 +71,11 @@ static int soft_noboot = 0;
 module_param(soft_noboot, int, 0);
 MODULE_PARM_DESC(soft_noboot, "Softdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
 
+static int panic_instead = 0;
+
+module_param(panic_instead, int, 0);
+MODULE_PARM_DESC(panic_instead, "Softdog action, set to 1 to panic instead of reboot, 0 to reboot (default 0)");
+
 /*
  *	Our timer
  */
@@ -93,8 +99,11 @@ static void watchdog_fire(unsigned long 
 
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
-	else
-	{
+	else if (panic_instead) {
+		printk(KERN_CRIT PFX "Initiating panic.\n");
+		panic("Watchdog timer expired.");
+		printk(KERN_CRIT PFX "Panic didn't ?????\n");
+	} else {
 		printk(KERN_CRIT PFX "Initiating system reboot.\n");
 		emergency_restart();
 		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
@@ -262,7 +271,7 @@ static struct notifier_block softdog_not
 	.notifier_call	= softdog_notify_sys,
 };
 
-static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
+static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec panic_instead=%d (nowayout= %d)\n";
 
 static int __init watchdog_init(void)
 {
@@ -290,7 +299,7 @@ static int __init watchdog_init(void)
 		return ret;
 	}
 
-	printk(banner, soft_noboot, soft_margin, nowayout);
+	printk(banner, soft_noboot, soft_margin, panic_instead, nowayout);
 
 	return 0;
 }
