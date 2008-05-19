Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbYESXqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbYESXqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763067AbYESXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:45:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115AbYESXpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:45:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Date: Tue, 20 May 2008 01:14:23 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
References: <13762.1211142411@vena.lwn.net> <200805200107.51659.arnd@arndb.de> <200805200111.47275.arnd@arndb.de>
In-Reply-To: <200805200111.47275.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805200114.24819.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+0D1RF2uZCV5aA1E5AJA91s351AHu3Cmimvuw
 F80xR08/QMMxTXNyZedRb1lDzuTFQct9jUy7LIokTZB0vVCLgJ
 3agSy17/Tb2usqYnSDikQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Big Kernel Lock has been pushed down from chardev_open
to misc_open, this change moves it to the individual watchdog
driver open functions.

As before, the change was purely mechanical, most drivers
should actually not need the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-2.6/drivers/watchdog/acquirewdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/acquirewdt.c
+++ linux-2.6/drivers/watchdog/acquirewdt.c
@@ -64,6 +64,7 @@
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/init.h>			/* For __init/__exit/... */
+#include <linux/smp_lock.h>		/* For lock_kernel() */
 
 #include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
 #include <asm/io.h>			/* For inb/outb/... */
@@ -195,14 +196,18 @@ static int acq_ioctl(struct inode *inode
 
 static int acq_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &acq_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &acq_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Activate */
 	acq_keepalive();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/advantechwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/advantechwdt.c
+++ linux-2.6/drivers/watchdog/advantechwdt.c
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -198,13 +199,17 @@ advwdt_ioctl(struct inode *inode, struct
 static int
 advwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &advwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &advwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	/*
 	 *	Activate
 	 */
 
 	advwdt_ping();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/alim1535_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/alim1535_wdt.c
+++ linux-2.6/drivers/watchdog/alim1535_wdt.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -252,11 +253,15 @@ static int ali_ioctl(struct inode *inode
 static int ali_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &ali_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &ali_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Activate */
 	ali_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/alim7101_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/alim7101_wdt.c
+++ linux-2.6/drivers/watchdog/alim7101_wdt.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
@@ -198,10 +199,14 @@ static ssize_t fop_write(struct file * f
 static int fop_open(struct inode * inode, struct file * file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if(test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	/* Good, fire up the show */
 	wdt_startup();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/ar7_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ar7_wdt.c
+++ linux-2.6/drivers/watchdog/ar7_wdt.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
@@ -179,11 +180,15 @@ static void ar7_wdt_disable_wdt(void)
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	lock_kernel();
+	if (down_trylock(&open_semaphore)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
 
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/at32ap700x_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/at32ap700x_wdt.c
+++ linux-2.6/drivers/watchdog/at32ap700x_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 
 #define TIMEOUT_MIN		1
 #define TIMEOUT_MAX		2
@@ -131,10 +132,14 @@ static inline void at32_wdt_pat(void)
  */
 static int at32_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1, &wdt->users))
+	lock_kernel();
+	if (test_and_set_bit(1, &wdt->users)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	at32_wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/at91rm9200_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/at91rm9200_wdt.c
+++ linux-2.6/drivers/watchdog/at91rm9200_wdt.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <asm/uaccess.h>
@@ -75,10 +76,14 @@ static void inline at91_wdt_reload(void)
  */
 static int at91_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &at91wdt_busy))
+	lock_kernel();
+	if (test_and_set_bit(0, &at91wdt_busy)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	at91_wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/bfin_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/bfin_wdt.c
+++ linux-2.6/drivers/watchdog/bfin_wdt.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
@@ -165,10 +166,13 @@ static int bfin_wdt_set_timeout(unsigned
  */
 static int bfin_wdt_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	stampit();
 
-	if (test_and_set_bit(0, &open_check))
+	if (test_and_set_bit(0, &open_check)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -176,6 +180,7 @@ static int bfin_wdt_open(struct inode *i
 	bfin_wdt_keepalive();
 	bfin_wdt_start();
 
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/booke_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/booke_wdt.c
+++ linux-2.6/drivers/watchdog/booke_wdt.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 
 #include <asm/reg_booke.h>
@@ -137,12 +138,14 @@ static int booke_wdt_ioctl (struct inode
  */
 static int booke_wdt_open (struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		booke_wdt_enable();
 		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 	}
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/cpu5wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/cpu5wdt.c
+++ linux-2.6/drivers/watchdog/cpu5wdt.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -130,9 +131,13 @@ static int cpu5wdt_stop(void)
 
 static int cpu5wdt_open(struct inode *inode, struct file *file)
 {
-	if ( test_and_set_bit(0, &cpu5wdt_device.inuse) )
+	lock_kernel();
+	if ( test_and_set_bit(0, &cpu5wdt_device.inuse) ) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/davinci_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/davinci_wdt.c
+++ linux-2.6/drivers/watchdog/davinci_wdt.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -120,10 +121,14 @@ static void wdt_enable(void)
 
 static int davinci_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/ep93xx_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ep93xx_wdt.c
+++ linux-2.6/drivers/watchdog/ep93xx_wdt.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
 
@@ -93,13 +94,17 @@ static void wdt_keepalive(void)
 
 static int ep93xx_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
 	wdt_startup();
 
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/eurotechwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/eurotechwdt.c
+++ linux-2.6/drivers/watchdog/eurotechwdt.c
@@ -48,6 +48,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -300,11 +301,15 @@ static int eurwdt_ioctl(struct inode *in
 
 static int eurwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &eurwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &eurwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	eurwdt_timeout = WDT_TIMEOUT;	/* initial timeout */
 	/* Activate the WDT */
 	eurwdt_activate_timer();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/hpwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/hpwdt.c
+++ linux-2.6/drivers/watchdog/hpwdt.c
@@ -30,6 +30,7 @@
 #include <linux/pci_ids.h>
 #include <linux/reboot.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
@@ -486,12 +487,16 @@ static int hpwdt_change_timer(int new_ma
 static int hpwdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &hpwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &hpwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Start the watchdog */
 	hpwdt_start();
 	hpwdt_ping();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/i6300esb.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/i6300esb.c
+++ linux-2.6/drivers/watchdog/i6300esb.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -198,12 +199,16 @@ static int esb_timer_read (void)
 static int esb_open (struct inode *inode, struct file *file)
 {
         /* /dev/watchdog can only be opened once */
-        if (test_and_set_bit(0, &timer_alive))
+	lock_kernel();
+        if (test_and_set_bit(0, &timer_alive)) {
+		unlock_kernel();
                 return -EBUSY;
+	}
 
         /* Reload and activate timer */
         esb_timer_keepalive ();
         esb_timer_start ();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/iTCO_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/iTCO_wdt.c
+++ linux-2.6/drivers/watchdog/iTCO_wdt.c
@@ -62,6 +62,7 @@
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
+#include <linux/smp_lock.h>		/* For lock_kernel */
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
@@ -453,14 +454,18 @@ static int iTCO_wdt_get_timeleft (int *t
 static int iTCO_wdt_open (struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &is_active))
+	lock_kernel();
+	if (test_and_set_bit(0, &is_active)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/*
 	 *      Reload and activate timer
 	 */
 	iTCO_wdt_keepalive();
 	iTCO_wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/ib700wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ib700wdt.c
+++ linux-2.6/drivers/watchdog/ib700wdt.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -256,7 +257,9 @@ ibwdt_ioctl(struct inode *inode, struct 
 static int
 ibwdt_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	if (test_and_set_bit(0, &ibwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
 	}
 	if (nowayout)
@@ -264,6 +267,7 @@ ibwdt_open(struct inode *inode, struct f
 
 	/* Activate */
 	ibwdt_ping();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/ibmasr.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ibmasr.c
+++ linux-2.6/drivers/watchdog/ibmasr.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/timer.h>
@@ -300,11 +301,15 @@ static int asr_ioctl(struct inode *inode
 
 static int asr_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &asr_is_open))
+	lock_kernel();
+	if(test_and_set_bit(0, &asr_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	asr_toggle();
 	asr_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/indydog.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/indydog.c
+++ linux-2.6/drivers/watchdog/indydog.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -62,8 +63,11 @@ static void indydog_ping(void)
  */
 static int indydog_open(struct inode *inode, struct file *file)
 {
-	if (indydog_alive)
+	lock_kernel();
+	if (indydog_alive) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -74,6 +78,7 @@ static int indydog_open(struct inode *in
 
 	indydog_alive = 1;
 	printk(KERN_INFO "Started watchdog timer.\n");
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/iop_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/iop_wdt.c
+++ linux-2.6/drivers/watchdog/iop_wdt.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
 #include <asm/hardware.h>
@@ -88,14 +89,18 @@ static int wdt_disable(void)
 
 static int iop_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
 	wdt_enable();
 
 	set_bit(WDT_ENABLED, &wdt_status);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/it8712f_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/it8712f_wdt.c
+++ linux-2.6/drivers/watchdog/it8712f_wdt.c
@@ -30,6 +30,7 @@
 #include <linux/fs.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -305,10 +306,14 @@ it8712f_wdt_ioctl(struct inode *inode, s
 static int
 it8712f_wdt_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	/* only allow one at a time */
-	if (down_trylock(&it8712f_wdt_sem))
+	if (down_trylock(&it8712f_wdt_sem)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	it8712f_wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/ixp2000_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ixp2000_wdt.c
+++ linux-2.6/drivers/watchdog/ixp2000_wdt.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -62,12 +63,16 @@ wdt_keepalive(void)
 static int
 ixp2000_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
 	wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/ixp4xx_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ixp4xx_wdt.c
+++ linux-2.6/drivers/watchdog/ixp4xx_wdt.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -57,12 +58,16 @@ wdt_disable(void)
 static int
 ixp4xx_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
 	wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/ks8695_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/ks8695_wdt.c
+++ linux-2.6/drivers/watchdog/ks8695_wdt.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <asm/io.h>
@@ -114,10 +115,14 @@ static int ks8695_wdt_settimeout(int new
  */
 static int ks8695_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &ks8695wdt_busy))
+	lock_kernel();
+	if (test_and_set_bit(0, &ks8695wdt_busy)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	ks8695_wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/machzwd.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/machzwd.c
+++ linux-2.6/drivers/watchdog/machzwd.c
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
@@ -337,9 +338,11 @@ static int zf_ioctl(struct inode *inode,
 
 static int zf_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock(&zf_lock);
 	if(test_and_set_bit(0, &zf_is_open)) {
 		spin_unlock(&zf_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -349,6 +352,7 @@ static int zf_open(struct inode *inode, 
 	spin_unlock(&zf_lock);
 
 	zf_timer_on();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/mixcomwd.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mixcomwd.c
+++ linux-2.6/drivers/watchdog/mixcomwd.c
@@ -44,6 +44,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/ioport.h>
@@ -129,7 +130,9 @@ static void mixcomwd_timerfun(unsigned l
 
 static int mixcomwd_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	if(test_and_set_bit(0,&mixcomwd_opened)) {
+		unlock_kernel();
 		return -EBUSY;
 	}
 	mixcomwd_ping();
@@ -147,6 +150,7 @@ static int mixcomwd_open(struct inode *i
 			mixcomwd_timer_alive=0;
 		}
 	}
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/mpc5200_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mpc5200_wdt.c
+++ linux-2.6/drivers/watchdog/mpc5200_wdt.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
@@ -137,14 +138,18 @@ static int mpc5200_wdt_ioctl(struct inod
 }
 static int mpc5200_wdt_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &is_active))
+	if (test_and_set_bit(0, &is_active)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Set and activate the watchdog */
 	mpc5200_wdt_set_timeout(wdt_global, 30);
 	mpc5200_wdt_start(wdt_global);
 	file->private_data = wdt_global;
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 static int mpc5200_wdt_release(struct inode *inode, struct file *file)
Index: linux-2.6/drivers/watchdog/mpc83xx_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mpc83xx_wdt.c
+++ linux-2.6/drivers/watchdog/mpc83xx_wdt.c
@@ -21,6 +21,7 @@
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -78,8 +79,11 @@ static ssize_t mpc83xx_wdt_write(struct 
 static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
 {
 	u32 tmp = SWCRR_SWEN;
-	if (test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Once we start the watchdog we can't stop it */
 	__module_get(THIS_MODULE);
@@ -93,6 +97,7 @@ static int mpc83xx_wdt_open(struct inode
 	tmp |= timeout << 16;
 
 	out_be32(&wd_base->swcrr, tmp);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/mpc8xx_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mpc8xx_wdt.c
+++ linux-2.6/drivers/watchdog/mpc8xx_wdt.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <asm/8xx_immap.h>
 #include <asm/uaccess.h>
@@ -51,11 +52,15 @@ static void mpc8xx_wdt_handler_enable(vo
 
 static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &wdt_opened))
+	lock_kernel();
+	if (test_and_set_bit(0, &wdt_opened)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	m8xx_wdt_reset();
 	mpc8xx_wdt_handler_disable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/mpcore_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mpcore_wdt.c
+++ linux-2.6/drivers/watchdog/mpcore_wdt.c
@@ -21,6 +21,7 @@
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -140,8 +141,11 @@ static int mpcore_wdt_open(struct inode 
 {
 	struct mpcore_wdt *wdt = platform_get_drvdata(mpcore_wdt_dev);
 
-	if (test_and_set_bit(0, &wdt->timer_alive))
+	lock_kernel();
+	if (test_and_set_bit(0, &wdt->timer_alive)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -152,6 +156,7 @@ static int mpcore_wdt_open(struct inode 
 	 *	Activate timer
 	 */
 	mpcore_wdt_start(wdt);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/mtx-1_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mtx-1_wdt.c
+++ linux-2.6/drivers/watchdog/mtx-1_wdt.c
@@ -35,6 +35,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -120,8 +121,12 @@ static int mtx1_wdt_stop(void)
 
 static int mtx1_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &mtx1_wdt_device.inuse))
+	lock_kernel();
+	if (test_and_set_bit(0, &mtx1_wdt_device.inuse)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mv64x60_wdt.c
+++ linux-2.6/drivers/watchdog/mv64x60_wdt.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
 
@@ -122,13 +123,17 @@ static void mv64x60_wdt_set_timeout(unsi
 
 static int mv64x60_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
+	lock_kernel();
+	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	mv64x60_wdt_handler_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/omap_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/omap_wdt.c
+++ linux-2.6/drivers/watchdog/omap_wdt.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -122,8 +123,11 @@ static void omap_wdt_set_timeout(void)
 
 static int omap_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1, (unsigned long *)&omap_wdt_users))
+	lock_kernel();
+	if (test_and_set_bit(1, (unsigned long *)&omap_wdt_users)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (cpu_is_omap16xx())
 		clk_enable(armwdt_ck);	/* Enable the clock */
@@ -142,6 +146,7 @@ static int omap_wdt_open(struct inode *i
 
 	omap_wdt_set_timeout();
 	omap_wdt_enable();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/pc87413_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/pc87413_wdt.c
+++ linux-2.6/drivers/watchdog/pc87413_wdt.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -305,8 +306,11 @@ static int pc87413_open(struct inode *in
 {
 	/* /dev/watchdog can only be opened once */
 
-	if (test_and_set_bit(0, &timer_enabled))
+	lock_kernel();
+	if (test_and_set_bit(0, &timer_enabled)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -316,6 +320,7 @@ static int pc87413_open(struct inode *in
 
 	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to"
 	                         " %d minute(s).\n", timeout);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/pcwd.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/pcwd.c
+++ linux-2.6/drivers/watchdog/pcwd.c
@@ -51,6 +51,7 @@
 
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
+#include <linux/smp_lock.h>	/* For lock_kernel */
 #include <linux/types.h>	/* For standard types (like size_t) */
 #include <linux/errno.h>	/* For the -ENODEV/... values */
 #include <linux/kernel.h>	/* For printk/panic/... */
@@ -682,10 +683,12 @@ static ssize_t pcwd_write(struct file *f
 
 static int pcwd_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	if (!atomic_dec_and_test(&open_allowed) ) {
 		if (debug >= VERBOSE)
 			printk(KERN_ERR PFX "Attempt to open already opened device.\n");
 		atomic_inc( &open_allowed );
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -695,6 +698,7 @@ static int pcwd_open(struct inode *inode
 	/* Activate */
 	pcwd_start();
 	pcwd_keepalive();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/pcwd_pci.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/pcwd_pci.c
+++ linux-2.6/drivers/watchdog/pcwd_pci.c
@@ -33,6 +33,7 @@
 
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
+#include <linux/smp_lock.h>	/* For lock_kernel */
 #include <linux/types.h>	/* For standard types (like size_t) */
 #include <linux/errno.h>	/* For the -ENODEV/... values */
 #include <linux/kernel.h>	/* For printk/panic/... */
@@ -563,15 +564,18 @@ static int pcipcwd_ioctl(struct inode *i
 static int pcipcwd_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
+	lock_kernel();
 	if (test_and_set_bit(0, &is_active)) {
 		if (debug >= VERBOSE)
 			printk(KERN_ERR PFX "Attempt to open already opened device.\n");
+		unlock_kernel();
 		return -EBUSY;
 	}
 
 	/* Activate */
 	pcipcwd_start();
 	pcipcwd_keepalive();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/pcwd_usb.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/pcwd_usb.c
+++ linux-2.6/drivers/watchdog/pcwd_usb.c
@@ -26,6 +26,7 @@
 
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
+#include <linux/smp_lock.h>	/* For lock_kernel */
 #include <linux/types.h>	/* For standard types (like size_t) */
 #include <linux/errno.h>	/* For the -ENODEV/... values */
 #include <linux/kernel.h>	/* For printk/panic/... */
@@ -460,12 +461,16 @@ static int usb_pcwd_ioctl(struct inode *
 static int usb_pcwd_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &is_active))
+	lock_kernel();
+	if (test_and_set_bit(0, &is_active)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Activate */
 	usb_pcwd_start(usb_pcwd_device);
 	usb_pcwd_keepalive(usb_pcwd_device);
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/pnx4008_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/pnx4008_wdt.c
+++ linux-2.6/drivers/watchdog/pnx4008_wdt.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -134,12 +135,16 @@ static void wdt_disable(void)
 
 static int pnx4008_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
 	wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/rm9k_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/rm9k_wdt.c
+++ linux-2.6/drivers/watchdog/rm9k_wdt.c
@@ -28,6 +28,7 @@
 #include <linux/reboot.h>
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
@@ -182,8 +183,11 @@ static int wdt_gpi_open(struct inode *in
 {
 	int res;
 
-	if (unlikely(atomic_dec_if_positive(&opencnt) < 0))
+	lock_kernel();
+	if (unlikely(atomic_dec_if_positive(&opencnt) < 0)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	expect_close = 0;
 	if (locked) {
@@ -194,14 +198,17 @@ static int wdt_gpi_open(struct inode *in
 
 	res = request_irq(wd_irq, wdt_gpi_irqhdl, IRQF_SHARED | IRQF_DISABLED,
 			  wdt_gpi_name, &miscdev);
-	if (unlikely(res))
+	if (unlikely(res)) {
+		unlock_kernel();
 		return res;
+	}
 
 	wdt_gpi_set_timeout(timeout);
 	wdt_gpi_start();
 
 	printk(KERN_INFO "%s: watchdog started, timeout = %u seconds\n",
 		wdt_gpi_name, timeout);
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/s3c2410_wdt.c
+++ linux-2.6/drivers/watchdog/s3c2410_wdt.c
@@ -37,6 +37,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
@@ -211,8 +212,11 @@ static int s3c2410wdt_set_heartbeat(int 
 
 static int s3c2410wdt_open(struct inode *inode, struct file *file)
 {
-	if(down_trylock(&open_lock))
+	lock_kernel();
+	if(down_trylock(&open_lock)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -221,6 +225,7 @@ static int s3c2410wdt_open(struct inode 
 
 	/* start the timer */
 	s3c2410wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/sa1100_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sa1100_wdt.c
+++ linux-2.6/drivers/watchdog/sa1100_wdt.c
@@ -19,6 +19,7 @@
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -45,14 +46,18 @@ static int boot_status;
  */
 static int sa1100dog_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1,&sa1100wdt_users))
+	lock_kernel();
+	if (test_and_set_bit(1,&sa1100wdt_users)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Activate SA1100 Watchdog timer */
 	OSMR3 = OSCR + pre_margin;
 	OSSR = OSSR_M3;
 	OWER = OWER_WME;
 	OIER |= OIER_E3;
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/sb_wdog.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sb_wdog.c
+++ linux-2.6/drivers/watchdog/sb_wdog.c
@@ -45,6 +45,7 @@
  */
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/reboot.h>
@@ -96,8 +97,10 @@ static struct watchdog_info ident = {
  */
 static int sbwdog_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	nonseekable_open(inode, file);
 	if (test_and_set_bit(0, &sbwdog_gate)) {
+		unlock_kernel();
 		return -EBUSY;
 	}
 	__module_get(THIS_MODULE);
@@ -107,6 +110,7 @@ static int sbwdog_open(struct inode *ino
 	 */
 	sbwdog_set(user_dog, timeout);
 	__raw_writeb(1, user_dog);
+	unlock_kernel();
 
 	return 0;
 }
Index: linux-2.6/drivers/watchdog/sbc60xxwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sbc60xxwdt.c
+++ linux-2.6/drivers/watchdog/sbc60xxwdt.c
@@ -46,6 +46,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
@@ -191,15 +192,19 @@ static ssize_t fop_write(struct file * f
 
 static int fop_open(struct inode * inode, struct file * file)
 {
+	lock_kernel();
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if(test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Good, fire up the show */
 	wdt_startup();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/sbc7240_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sbc7240_wdt.c
+++ linux-2.6/drivers/watchdog/sbc7240_wdt.c
@@ -25,6 +25,7 @@
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <asm/atomic.h>
@@ -136,10 +137,14 @@ static ssize_t fop_write(struct file *fi
 
 static int fop_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status))
+	lock_kernel();
+	if (test_and_set_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/sbc8360.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sbc8360.c
+++ linux-2.6/drivers/watchdog/sbc8360.c
@@ -37,6 +37,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -257,9 +258,11 @@ static ssize_t sbc8360_write(struct file
 
 static int sbc8360_open(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	spin_lock(&sbc8360_lock);
 	if (test_and_set_bit(0, &sbc8360_is_open)) {
 		spin_unlock(&sbc8360_lock);
+		unlock_kernel();
 		return -EBUSY;
 	}
 	if (nowayout)
@@ -269,6 +272,7 @@ static int sbc8360_open(struct inode *in
 	spin_unlock(&sbc8360_lock);
 	sbc8360_activate();
 	sbc8360_ping();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/sbc_epx_c3.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sbc_epx_c3.c
+++ linux-2.6/drivers/watchdog/sbc_epx_c3.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -63,8 +64,11 @@ static void epx_c3_pet(void)
  */
 static int epx_c3_open(struct inode *inode, struct file *file)
 {
-	if (epx_c3_alive)
+	lock_kernel();
+	if (epx_c3_alive) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -75,6 +79,7 @@ static int epx_c3_open(struct inode *ino
 
 	epx_c3_alive = 1;
 	printk(KERN_INFO "Started watchdog timer.\n");
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/sc1200wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sc1200wdt.c
+++ linux-2.6/drivers/watchdog/sc1200wdt.c
@@ -33,6 +33,7 @@
 #include <linux/watchdog.h>
 #include <linux/ioport.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -151,14 +152,18 @@ static inline int sc1200wdt_status(void)
 static int sc1200wdt_open(struct inode *inode, struct file *file)
 {
 	/* allow one at a time */
-	if (down_trylock(&open_sem))
+	lock_kernel();
+	if (down_trylock(&open_sem)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (timeout > MAX_TIMEOUT)
 		timeout = MAX_TIMEOUT;
 
 	sc1200wdt_start();
 	printk(KERN_INFO PFX "Watchdog enabled, timeout = %d min(s)", timeout);
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/sc520_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sc520_wdt.c
+++ linux-2.6/drivers/watchdog/sc520_wdt.c
@@ -55,6 +55,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
+#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -249,13 +250,17 @@ static ssize_t fop_write(struct file * f
 static int fop_open(struct inode * inode, struct file * file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if(test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Good, fire up the show */
 	wdt_startup();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/scx200_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/scx200_wdt.c
+++ linux-2.6/drivers/watchdog/scx200_wdt.c
@@ -21,6 +21,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
@@ -92,9 +93,13 @@ static void scx200_wdt_disable(void)
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	lock_kernel();
+	if (down_trylock(&open_semaphore)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	scx200_wdt_enable();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/shwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/shwdt.c
+++ linux-2.6/drivers/watchdog/shwdt.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
@@ -194,12 +195,16 @@ static void sh_wdt_ping(unsigned long da
  */
 static int sh_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &shwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &shwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	sh_wdt_start();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/smsc37b787_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/smsc37b787_wdt.c
+++ linux-2.6/drivers/watchdog/smsc37b787_wdt.c
@@ -45,6 +45,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -346,8 +347,11 @@ static int wb_smsc_wdt_open(struct inode
 {
 	/* /dev/watchdog can only be opened once */
 
-	if (test_and_set_bit(0, &timer_enabled))
+	lock_kernel();
+	if (test_and_set_bit(0, &timer_enabled)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -356,6 +360,7 @@ static int wb_smsc_wdt_open(struct inode
 	wb_smsc_wdt_enable();
 
 	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to %d %s.\n", timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/softdog.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/softdog.c
+++ linux-2.6/drivers/watchdog/softdog.c
@@ -38,6 +38,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
@@ -132,14 +133,18 @@ static int softdog_set_heartbeat(int t)
 
 static int softdog_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &driver_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &driver_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	if (!test_and_clear_bit(0, &orphan_timer))
 		__module_get(THIS_MODULE);
 	/*
 	 *	Activate timer
 	 */
 	softdog_keepalive();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/txx9wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/txx9wdt.c
+++ linux-2.6/drivers/watchdog/txx9wdt.c
@@ -9,6 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -70,8 +71,11 @@ static void txx9wdt_stop(void)
 
 static int txx9wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &txx9wdt_alive))
+	lock_kernel();
+	if (test_and_set_bit(0, &txx9wdt_alive)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (__raw_readl(&txx9wdt_reg->tcr) & TXx9_TMTCR_TCE) {
 		clear_bit(0, &txx9wdt_alive);
@@ -82,6 +86,7 @@ static int txx9wdt_open(struct inode *in
 		__module_get(THIS_MODULE);
 
 	txx9wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/w83627hf_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/w83627hf_wdt.c
+++ linux-2.6/drivers/watchdog/w83627hf_wdt.c
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -256,13 +257,17 @@ wdt_ioctl(struct inode *inode, struct fi
 static int
 wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	/*
 	 *	Activate
 	 */
 
 	wdt_ping();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/w83697hf_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/w83697hf_wdt.c
+++ linux-2.6/drivers/watchdog/w83697hf_wdt.c
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -280,13 +281,17 @@ wdt_ioctl(struct inode *inode, struct fi
 static int
 wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	/*
 	 *	Activate
 	 */
 
 	wdt_enable();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/w83877f_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/w83877f_wdt.c
+++ linux-2.6/drivers/watchdog/w83877f_wdt.c
@@ -41,6 +41,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
@@ -214,11 +215,15 @@ static ssize_t fop_write(struct file * f
 static int fop_open(struct inode * inode, struct file * file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if(test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/* Good, fire up the show */
 	wdt_startup();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/w83977f_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/w83977f_wdt.c
+++ linux-2.6/drivers/watchdog/w83977f_wdt.c
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -290,13 +291,17 @@ static int wdt_get_status(int *status)
 static int wdt_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0, &timer_alive) )
+	lock_kernel();
+	if( test_and_set_bit(0, &timer_alive) ) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/wafer5823wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wafer5823wdt.c
+++ linux-2.6/drivers/watchdog/wafer5823wdt.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
 #include <linux/ioport.h>
@@ -181,13 +182,17 @@ static int wafwdt_ioctl(struct inode *in
 
 static int wafwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &wafwdt_is_open))
+	lock_kernel();
+	if (test_and_set_bit(0, &wafwdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	/*
 	 *      Activate
 	 */
 	wafwdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/wdrtas.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdrtas.c
+++ linux-2.6/drivers/watchdog/wdrtas.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
@@ -403,13 +404,16 @@ static int
 wdrtas_open(struct inode *inode, struct file *file)
 {
 	/* only open once */
+	lock_kernel();
 	if (atomic_inc_return(&wdrtas_miscdev_open) > 1) {
 		atomic_dec(&wdrtas_miscdev_open);
+		unlock_kernel();
 		return -EBUSY;
 	}
 
 	wdrtas_timer_start();
 	wdrtas_timer_keepalive();
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
Index: linux-2.6/drivers/watchdog/wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt.c
+++ linux-2.6/drivers/watchdog/wdt.c
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -405,12 +406,16 @@ static int wdt_ioctl(struct inode *inode
 
 static int wdt_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &wdt_is_open))
+	lock_kernel();
+	if(test_and_set_bit(0, &wdt_is_open)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 	/*
 	 *	Activate
 	 */
 	wdt_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/wdt285.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt285.c
+++ linux-2.6/drivers/watchdog/wdt285.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
+#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -69,11 +70,16 @@ static int watchdog_open(struct inode *i
 {
 	int ret;
 
-	if (*CSR_SA110_CNTL & (1 << 13))
+	lock_kernel();
+	if (*CSR_SA110_CNTL & (1 << 13)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
-	if (test_and_set_bit(1, &timer_alive))
+	if (test_and_set_bit(1, &timer_alive)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	reload = soft_margin * (mem_fclk_21285 / 256);
 
@@ -98,6 +104,7 @@ static int watchdog_open(struct inode *i
 	ret = 0;
 #endif
 	nonseekable_open(inode, file);
+	unlock_kernel();
 	return ret;
 }
 
Index: linux-2.6/drivers/watchdog/wdt977.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt977.c
+++ linux-2.6/drivers/watchdog/wdt977.c
@@ -24,6 +24,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -258,13 +259,17 @@ static int wdt977_get_status(int *status
 static int wdt977_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0,&timer_alive) )
+	lock_kernel();
+	if (test_and_set_bit(0,&timer_alive)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	wdt977_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 
Index: linux-2.6/drivers/watchdog/wdt_pci.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt_pci.c
+++ linux-2.6/drivers/watchdog/wdt_pci.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
@@ -426,8 +427,11 @@ static int wdtpci_ioctl(struct inode *in
 
 static int wdtpci_open(struct inode *inode, struct file *file)
 {
-	if (down_trylock(&open_sem))
+	lock_kernel();
+	if (down_trylock(&open_sem)) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (nowayout) {
 		__module_get(THIS_MODULE);
@@ -436,6 +440,7 @@ static int wdtpci_open(struct inode *ino
 	 *	Activate
 	 */
 	wdtpci_start();
+	unlock_kernel();
 	return nonseekable_open(inode, file);
 }
 

