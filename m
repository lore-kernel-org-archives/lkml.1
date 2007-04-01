Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXDAOPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXDAOPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDAOPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:15:49 -0400
Received: from mail.musicgenome.com ([212.150.69.147]:43664 "EHLO
	mail.musicgenome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXDAOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:15:48 -0400
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 10:15:47 EDT
Date: Sun, 1 Apr 2007 16:55:58 +0300
From: Tal Kelrich <tal@musicgenome.com>
To: linux-kernel@vger.kernel.org
Subject: [2.4] Watchdog wdt977 (Winbond W83977EF) driver
Message-ID: <20070401165558.3b63c47e@shodan.orpak.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.6.10; i686-redhat-linux-gnu)
X-Habeas-SWE-1: winter into spring
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_R=WPXR7xs0.n_+h3xqFZ.xc"
X-Musicgenome-MailScanner-Information: Please contact the ISP for more information
X-Musicgenome-MailScanner: Found to be clean
X-Musicgenome-MailScanner-SpamCheck: not spam, SpamAssassin (score=-5.899,
	required 6, autolearn=not spam, ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-Musicgenome-MailScanner-From: tal@musicgenome.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_R=WPXR7xs0.n_+h3xqFZ.xc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

This is my first submitted kernel patch, please be gentle.

Tested and working on AAEON GENE-6310B Subcompact Board
(also configured for same by default, should work elsewhere)
patch is against kernel 2.4.34.2

Changes/Features:

Added ioctl support
Disables watchdog on driver load
Supports timeout in seconds
Timeout defaults to 2 minutes
No longer under NetWinder arch
Configurable output GP (defaults to GP16)
Configurable base IO address
Non standard read only proc interface for status (/proc/watchdog)

Caveats:

No idea if this breaks netwinder, although it really shouldn't
Only tested with GP16
Utterly ignores inability to get its IO port, mostly because it's
already taken. I didn't know a way around that.
release_region is called regardless of having acquired the region, this
might be trouble.

-- 
Tal Kelrich
PGP fingerprint: 3EDF FCC5 60BB 4729 AB2F  CAE6 FEC1 9AAC 12B9 AA69
Key Available at: http://www.hasturkun.com/pub.txt
----
To err is human, to forgive is against company policy.
----


--MP_R=WPXR7xs0.n_+h3xqFZ.xc
Content-Type: text/x-patch; name=linux-2.4.34.2-wdt977.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=linux-2.4.34.2-wdt977.patch

diff -udr linux-2.4.34.2/drivers/char/Config.in linux-2.4.34.2-wdt977/drivers/char/Config.in
--- linux-2.4.34.2/drivers/char/Config.in	Sat Mar 24 08:44:54 2007
+++ linux-2.4.34.2-wdt977/drivers/char/Config.in	Wed Mar 28 10:49:02 2007
@@ -247,10 +247,8 @@
    tristate '  Berkshire Products PC Watchdog' CONFIG_PCWATCHDOG
    if [ "$CONFIG_FOOTBRIDGE" = "y" ]; then
       tristate '  DC21285 watchdog' CONFIG_21285_WATCHDOG
-      if [ "$CONFIG_ARCH_NETWINDER" = "y" ]; then
-         tristate '  NetWinder WB83C977 watchdog' CONFIG_977_WATCHDOG
-      fi
    fi
+   tristate '  Winbond W83977EF Watchdog Timer' CONFIG_977_WATCHDOG
    tristate '  Eurotech CPU-1220/1410 Watchdog Timer' CONFIG_EUROTECH_WDT
    tristate '  IB700 SBC Watchdog Timer' CONFIG_IB700_WDT
    tristate '  ICP ELectronics Wafer 5823 Watchdog' CONFIG_WAFER_WDT
--- linux-2.4.34.2/drivers/char/wdt977.c	Sat Mar 24 08:44:54 2007
+++ linux-2.4.34.2-wdt977/drivers/char/wdt977.c	Wed Mar 28 10:52:23 2007
@@ -1,5 +1,7 @@
 /*
- *	Wdt977	0.02:	A Watchdog Device for Netwinder W83977AF chip
+ *	Wdt83977 0.03:	A Watchdog Device for Winbond W83977EF chip
+ *	(c) Copyright 2007 Orpak Systems Ltd. (Tal Kelrich <tal@orpak.com>)
+ *	based on wdt977 driver by Woody Suwalski <woody@netwinder.org>
  *
  *	(c) Copyright 1998 Rebel.com (Woody Suwalski <woody@netwinder.org>)
  *
@@ -9,10 +11,6 @@
  *	modify it under the terms of the GNU General Public License
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
- *
- *			-----------------------
- *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
- *           Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
  */
  
 #include <linux/module.h>
@@ -23,17 +21,25 @@
 #include <linux/miscdevice.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
+#include <linux/ioport.h>
+#include <linux/spinlock.h>
+#include <linux/watchdog.h>
+#include <linux/proc_fs.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/mach-types.h>
+#include <asm/uaccess.h>
+#include <asm/page.h>
 
 #define WATCHDOG_MINOR	130
 
-static	int timeout = 3;
+static	int timeout = 120;
 static	int timer_alive;
-static	int testmode;
 static	int expect_close = 0;
+static spinlock_t wdt_lock;
+
+/* port is either 0X370 or 0x3F0. there's probably no way to detect this */
+static int wdt_io = 0x370;
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 static int nowayout = 1;
@@ -41,14 +47,77 @@
 static int nowayout = 0;
 #endif
 
+static int whichgp = 16;
+
+MODULE_PARM(wdt_io,"i");
+MODULE_PARM_DESC(wdt_io,"WDT io port base (0x370/0x3F0)");
+
+MODULE_PARM(whichgp,"i");
+MODULE_PARM_DESC(whichgp,"which gp? (12/13/16)");
+
+MODULE_PARM(timeout,"i");
+
 MODULE_PARM(nowayout,"i");
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
 
+#define WDT_EFER (wdt_io+0)   /* Extended Function Enable Registers */
+#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register (same as EFER) */
+#define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
+
+#define WDT_OUT(reg,data) {outb_p(reg,WDT_EFIR);outb_p(data,WDT_EFDR);}
+#define WDT_IN(reg,out) {outb_p(reg,WDT_EFIR);out=inb_p(WDT_EFDR);}
+#define WDT_DEV(device) {WDT_OUT(0x07,device);}
+#define WDT_ENABLE	{outb_p(0x87,WDT_EFER);outb_p(0x87,WDT_EFER);}
+#define WDT_DISABLE	{outb_p(0xAA,WDT_EFER);}
+
+static int wdt977_readproc(char *page, char **start, off_t off, int count,
+		int *eof, void *data)
+{
+	int len;
+	unsigned char remaining;
+	unsigned char fired;
+	spin_lock(&wdt_lock);
+	WDT_ENABLE;
+	WDT_DEV(0x08);
+	WDT_IN(0xF2,remaining); /* get remaining time */
+	WDT_IN(0xF4,fired); /* and some nice status bits */
+	/* and clear the bit we care about */
+	WDT_OUT(0xF4,fired&(~0x01));
+	WDT_DISABLE;
+	spin_unlock(&wdt_lock);
+	fired=fired & 0x01;
+	len=snprintf(page,PAGE_SIZE,
+			"W83977EF device\n"
+			"active=%d\n"
+			"iobase=%0X\n"
+			"gp=%d\n"
+			"nowayout=%d\n"
+			"timeout=%d\n"
+			"remaining=%d\n"
+			"fired=%d\n",
+			timer_alive,wdt_io,whichgp,nowayout,timeout,remaining,fired);
+	*eof=1;
+	return len;
+}
+
+static void wdt977_ctrl(int timeout)
+{
+	unsigned char status;
+	spin_lock(&wdt_lock);
+	WDT_ENABLE;
+	WDT_DEV(0x08);
+	WDT_OUT(0x30,0x01); /* enable */
+	WDT_OUT(0xF2,timeout);
+	WDT_IN(0xF4, status); /* so we don't set bit 0 */
+	WDT_OUT(0xF4,(status&0x01)|0x40); /* and seconds! */
+	WDT_DISABLE;
+	spin_unlock(&wdt_lock);
+}
 
 /*
  *	Allow only one person to hold it open
  */
- 
+
 static int wdt977_open(struct inode *inode, struct file *file)
 {
 	if(timer_alive)
@@ -59,42 +128,12 @@
 	timer_alive++;
 
 	//max timeout value = 255 minutes (0xFF). Write 0 to disable WatchDog.
-	if (timeout>255)
+	if (timeout>255 || timeout <1)
 	    timeout = 255;
 
 	printk(KERN_INFO "Watchdog: active, current timeout %d min.\n",timeout);
 
-	// unlock the SuperIO chip
-	outb(0x87,0x370); 
-	outb(0x87,0x370); 
-	
-	//select device Aux2 (device=8) and set watchdog regs F2, F3 and F4
-	//F2 has the timeout in minutes
-	//F3 could be set to the POWER LED blink (with GP17 set to PowerLed)
-	//   at timeout, and to reset timer on kbd/mouse activity (not now)
-	//F4 is used to just clear the TIMEOUT'ed state (bit 0)
-	
-	outb(0x07,0x370);
-	outb(0x08,0x371);
-	outb(0xF2,0x370);
-	outb(timeout,0x371);
-	outb(0xF3,0x370);
-	outb(0x00,0x371);	//another setting is 0E for kbd/mouse/LED
-	outb(0xF4,0x370);
-	outb(0x00,0x371);
-	
-	//at last select device Aux1 (dev=7) and set GP16 as a watchdog output
-	if (!testmode)
-	{
-		outb(0x07,0x370);
-		outb(0x07,0x371);
-		outb(0xE6,0x370);
-		outb(0x08,0x371);
-	}
-		
-	// lock the SuperIO chip
-	outb(0xAA,0x370); 
-
+	wdt977_ctrl(timeout);
 	return 0;
 }
 
@@ -104,50 +143,23 @@
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	lock_kernel();
 	if (expect_close) {
-
-		// unlock the SuperIO chip
-		outb(0x87,0x370); 
-		outb(0x87,0x370); 
-	
-		//select device Aux2 (device=8) and set watchdog regs F2,F3 and F4
-		//F3 is reset to its default state
-		//F4 can clear the TIMEOUT'ed state (bit 0) - back to default
-		//We can not use GP17 as a PowerLed, as we use its usage as a RedLed
-	
-		outb(0x07,0x370);
-		outb(0x08,0x371);
-		outb(0xF2,0x370);
-		outb(0xFF,0x371);
-		outb(0xF3,0x370);
-		outb(0x00,0x371);
-		outb(0xF4,0x370);
-		outb(0x00,0x371);
-		outb(0xF2,0x370);
-		outb(0x00,0x371);
-	
-		//at last select device Aux1 (dev=7) and set GP16 as a watchdog output
-		outb(0x07,0x370);
-		outb(0x07,0x371);
-		outb(0xE6,0x370);
-		outb(0x08,0x371);
-	
-		// lock the SuperIO chip
-		outb(0xAA,0x370);
+		wdt977_ctrl(0); /* disable timer */
 		printk(KERN_INFO "Watchdog: shutdown.\n");
 	} else {
 		printk(KERN_CRIT "WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
 
 	timer_alive=0;
-	unlock_kernel();
 
 	return 0;
 }
 
 static ssize_t wdt977_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 {
+	/*  Can't seek (pwrite) on this device  */
+	if (ppos != &file->f_pos)
+		return -ESPIPE;
 	if (!nowayout) {
 		size_t i;
 
@@ -170,36 +182,79 @@
 	/*
 	 *	Refresh the timer.
 	 */
-		
-	//we have a hw bug somewhere, so each 977 minute is actually only 30sec
-	//as such limit the max timeout to half of max of 255 minutes...
-//	if (timeout>126)
-//	    timeout = 126;
-	
-	// unlock the SuperIO chip
-	outb(0x87,0x370); 
-	outb(0x87,0x370); 
-	
-	//select device Aux2 (device=8) and kicks watchdog reg F2
-	//F2 has the timeout in minutes
-	
-	outb(0x07,0x370);
-	outb(0x08,0x371);
-	outb(0xF2,0x370);
-	outb(timeout,0x371);
-	
-	// lock the SuperIO chip
-	outb(0xAA,0x370); 
+
+	wdt977_ctrl(timeout);	
 	
 	return 1;
 }
 
+static int wdt977_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	int new_timeout;
+	static struct watchdog_info ident = {
+		.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+		.firmware_version = 1,
+		.identity = "WDT83977 WDT",
+	};
+	void *argp = (void *)arg;
+	int *p = argp;
+	switch (cmd)
+	{
+		case WDIOC_GETSUPPORT:
+			if(copy_to_user(argp, &ident, sizeof(ident)))
+				return -EFAULT;
+			break;
+
+		case WDIOC_GETSTATUS:
+			return put_user(timer_alive, p);
+
+		case WDIOC_KEEPALIVE:
+			wdt977_ctrl(timeout);
+			
+		case WDIOC_SETTIMEOUT:
+			if(get_user(new_timeout, p))
+				return -EFAULT;
+			if(new_timeout>255 || new_timeout < 1)
+				return -EINVAL;
+			timeout=new_timeout;
+			wdt977_ctrl(timeout);
+			/* FALLTHROUGH */
+			
+		case WDIOC_GETTIMEOUT:
+			return put_user(timeout,p);
+
+		case WDIOC_SETOPTIONS:
+			{
+				int options, retval = -EINVAL;
+				if(get_user(options, p))
+					return -EFAULT;
+
+				if(options & WDIOS_DISABLECARD)
+				{
+					wdt977_ctrl(0);
+					retval = 0;
+				}
+				if(options & WDIOS_ENABLECARD)
+				{
+					wdt977_ctrl(timeout);
+					retval = 0;
+				}
+				return retval;
+			}
+		default:
+			return -ENOTTY;
+	}
+	return 0;
+}
+
 static struct file_operations wdt977_fops=
 {
 	owner:		THIS_MODULE,
 	write:		wdt977_write,
 	open:		wdt977_open,
 	release:	wdt977_release,
+	ioctl:		wdt977_ioctl,
 };
 
 static struct miscdevice wdt977_miscdev=
@@ -211,17 +266,80 @@
 
 static int __init nwwatchdog_init(void)
 {
-	if (!machine_is_netwinder())
-		return -ENODEV;
-
-	misc_register(&wdt977_miscdev);
-	printk(KERN_INFO "NetWinder Watchdog sleeping.\n");
+	unsigned char status;
+	int ret;
+	spin_lock_init(&wdt_lock);
+	ret = misc_register(&wdt977_miscdev);
+	if(ret != 0)
+		goto out;
+	if(!request_region(wdt_io, 1, "W83977EF"))
+	{
+		/* Failure to get region is because on the board I was working on, wdt_io is
+		 * consistently in use. there's probably a better solution to this */
+		printk(KERN_WARNING "W83977EF: IO address %04X already in use, continuing anyway\n",wdt_io);
+	}
+	if(!create_proc_read_entry("watchdog",0,NULL,&wdt977_readproc,NULL))
+		goto unreg_misc;
+	WDT_ENABLE;
+	/* select dev 7 */
+	WDT_DEV(0x07);
+	/* activate it */
+	WDT_OUT(0x30,0x01);
+	switch(whichgp)
+	{
+		case 12:
+			ret=0xE2;
+			break;
+		case 13:
+			ret=0xE3;
+			break;
+		default:
+			whichgp=16;
+		case 16:
+			ret=0xE6;
+			break;
+	}
+	WDT_OUT(ret,0x0A);
+	/* select dev 8 */
+	WDT_DEV(0x08);
+	/* enable it */
+	WDT_OUT(0x30,0x01);
+	/* power led cycle on wdog timeout */
+	WDT_OUT(0xF3,0x08);
+	switch(whichgp)
+	{
+		case 12:
+			WDT_IN(0x2A,ret); /* sets ret */
+			WDT_OUT(0x2A,ret|0x80); /* sets GP12 on */
+			break;
+		case 13:
+			WDT_IN(0x2B,ret);
+			WDT_OUT(0x2B,ret|0x01);
+			break;
+		case 16:
+			WDT_IN(0x2C,ret);
+			WDT_OUT(0x2C,ret|0x10);
+			break;
+	}
+	/* set timer to 0 initially */
+	WDT_OUT(0xF2,0);
+	WDT_IN(0xF4, status); /* so we don't set bit 0 by accident */
+	WDT_OUT(0xF4,(status&0x01)|0x40); /* bit 6 for seconds! */
+	WDT_DISABLE;
+	printk(KERN_INFO "W83977EF: initialized, using port %x, GP%d. timeout=%d nowayout=%d\n",wdt_io,whichgp,timeout,nowayout);
 	return 0;
+unreg_misc:
+	misc_deregister(&wdt977_miscdev);
+out:
+	return ret;
 }	
 
 static void __exit nwwatchdog_exit(void)
 {
+	remove_proc_entry("watchdog",NULL);
 	misc_deregister(&wdt977_miscdev);
+	release_region(wdt_io,2);
+	/* we might not have gotten it... is this safe? */
 }
 
 EXPORT_NO_SYMBOLS;

--MP_R=WPXR7xs0.n_+h3xqFZ.xc--
