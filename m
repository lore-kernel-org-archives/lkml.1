Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYLDPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYLDPom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759126AbYLDPoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:44:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51650 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758593AbYLDPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:44:16 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] watchdog: Introduce a midlayer/helper library
To: linux-kernel@vger.kernel.org, wim@iguana.be
Date: Thu, 04 Dec 2008 15:44:21 +0000
Message-ID: <20081204154208.28043.56257.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I first posted this last May when Wim was somewhat busy, hopefully this can
now be progressed for further discussion.

- Handles the temperature device
- You pass it the ident and other structs
- It handles stop not being supported (and stop/start fails)
- It does all the reboot, nowayout and module locking and housekeeping
- I've used static objects for most things so they can be initialised
  by the compiler making more of the code "table filling".
- We get to delete vast amounts of repeated (usually incorrectly) code.

Current patch (& example conversions) below. I'm still debating whether
the watchdog core should implement its own mutex locking for the drivers
so that only special case users (eg those with IRQ handlers) need to do
their own private locking. That would further reduce mistakes by authors.

(Note that you can mix old and new drivers quite happily so we don't have to
 do a complete conversion in one patch set)

Signed-off-by: Alan Cox <alan@redhat.com>

---

 drivers/watchdog/Kconfig        |   15 -
 drivers/watchdog/Makefile       |   12 +
 drivers/watchdog/alim1535_wdt.c |  284 ++++---------------------
 drivers/watchdog/alim7101_wdt.c |  223 +++-----------------
 drivers/watchdog/i6300esb.c     |  262 ++++-------------------
 drivers/watchdog/sbc_epx_c3.c   |  167 +++------------
 drivers/watchdog/sc1200wdt.c    |  221 +++----------------
 drivers/watchdog/softdog.c      |  211 +++---------------
 drivers/watchdog/wdt.c          |  446 ++++++++-------------------------------
 9 files changed, 336 insertions(+), 1505 deletions(-)


diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4fd3fa5..a674d21 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -907,21 +907,6 @@ config WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called wdt.
 
-config WDT_501
-	bool "WDT501 features"
-	depends on WDT
-	help
-	  Saying Y here and creating a character special file /dev/temperature
-	  with major number 10 and minor number 131 ("man mknod") will give
-	  you a thermometer inside your computer: reading from
-	  /dev/temperature yields one byte, the temperature in degrees
-	  Fahrenheit. This works only if you have a WDT501P watchdog board
-	  installed.
-
-	  If you want to enable the Fan Tachometer on the WDT501P, then you
-	  can do this via the tachometer parameter. Only do this if you have a
-	  fan tachometer actually set up.
-
 #
 # PCI-based Watchdog Cards
 #
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e352bbb..cd3334f 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -13,7 +13,7 @@
 # ISA-based Watchdog Cards
 obj-$(CONFIG_PCWATCHDOG) += pcwd.o
 obj-$(CONFIG_MIXCOMWD) += mixcomwd.o
-obj-$(CONFIG_WDT) += wdt.o
+obj-$(CONFIG_WDT) += wdt.o watchdog.o
 
 # PCI-based Watchdog Cards
 obj-$(CONFIG_PCIPCWATCHDOG) += pcwd_pci.o
@@ -59,8 +59,8 @@ obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
-obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
-obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
+obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o watchdog.o
+obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o watchdog.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
@@ -75,7 +75,7 @@ endif
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_IT87_WDT) += it87_wdt.o
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
-obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
+obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o watchdog.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
 obj-$(CONFIG_RDC321X_WDT) += rdc321x_wdt.o
@@ -90,7 +90,7 @@ obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
 obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
-obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
+obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o watchdog.o
 
 # M32R Architecture
 
@@ -133,4 +133,4 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 # XTENSA Architecture
 
 # Architecture Independant
-obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o watchdog.o
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2a7690e..afe0d13 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -21,13 +21,13 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
+#include "watchdog.h"
+
 #define WATCHDOG_NAME "ALi_M1535"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60	/* 60 sec default timeout */
 
 /* internal variables */
-static unsigned long ali_is_open;
-static char ali_expect_release;
 static struct pci_dev *ali_pci;
 static u32 ali_timeout_bits;		/* stores the computed timeout */
 static DEFINE_SPINLOCK(ali_lock);	/* Guards the hardware */
@@ -52,7 +52,7 @@ MODULE_PARM_DESC(nowayout,
  *	configuration set.
  */
 
-static void ali_start(void)
+static int ali_start(struct watchdog *w)
 {
 	u32 val;
 
@@ -60,10 +60,16 @@ static void ali_start(void)
 
 	pci_read_config_dword(ali_pci, 0xCC, &val);
 	val &= ~0x3F;	/* Mask count */
-	val |= (1<<25) | ali_timeout_bits;
+	val |= (1 << 25) | ali_timeout_bits;
 	pci_write_config_dword(ali_pci, 0xCC, val);
 
 	spin_unlock(&ali_lock);
+	return 0;
+}
+
+static void ali_ping(struct watchdog *w)
+{
+	ali_start(w);
 }
 
 /*
@@ -72,7 +78,7 @@ static void ali_start(void)
  *	Stop the ALi watchdog countdown
  */
 
-static void ali_stop(void)
+static int ali_stop(struct watchdog *w)
 {
 	u32 val;
 
@@ -80,31 +86,22 @@ static void ali_stop(void)
 
 	pci_read_config_dword(ali_pci, 0xCC, &val);
 	val &= ~0x3F;	/* Mask count to zero (disabled) */
-	val &= ~(1<<25);/* and for safety mask the reset enable */
+	val &= ~(1 << 25);/* and for safety mask the reset enable */
 	pci_write_config_dword(ali_pci, 0xCC, val);
 
 	spin_unlock(&ali_lock);
-}
-
-/*
- *	ali_keepalive	-	send a keepalive to the watchdog
- *
- *      Send a keepalive to the timer (actually we restart the timer).
- */
-
-static void ali_keepalive(void)
-{
-	ali_start();
+	return 0;
 }
 
 /*
  *	ali_settimer	-	compute the timer reload value
+ *	@w: watchdog
  *	@t: time in seconds
  *
  *	Computes the timeout values needed
  */
 
-static int ali_settimer(int t)
+static int ali_settimer(struct watchdog *w, int t)
 {
 	if (t < 0)
 		return -EINVAL;
@@ -117,180 +114,32 @@ static int ali_settimer(int t)
 	else
 		return -EINVAL;
 
-	timeout = t;
-	return 0;
-}
-
-/*
- *	/dev/watchdog handling
- */
-
-/*
- *	ali_write	-	writes to ALi watchdog
- *	@file: file from VFS
- *	@data: user address of data
- *	@len: length of data
- *	@ppos: pointer to the file offset
- *
- *	Handle a write to the ALi watchdog. Writing to the file pings
- *	the watchdog and resets it. Writing the magic 'V' sequence allows
- *	the next close to turn off the watchdog.
- */
-
-static ssize_t ali_write(struct file *file, const char __user *data,
-			      size_t len, loff_t *ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the
-			   magic character five months ago... */
-			ali_expect_release = 0;
-
-			/* scan to see whether or not we got
-			   the magic character */
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					ali_expect_release = 42;
-			}
-		}
-
-		/* someone wrote to us, we should reload the timer */
-		ali_start();
-	}
-	return len;
-}
-
-/*
- *	ali_ioctl	-	handle watchdog ioctls
- *	@file: VFS file pointer
- *	@cmd: ioctl number
- *	@arg: arguments to the ioctl
- *
- *	Handle the watchdog ioctls supported by the ALi driver. Really
- *	we want an extension to enable irq ack monitoring and the like
- */
-
-static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"ALi M1535 WatchDog Timer",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_SETOPTIONS:
-	{
-		int new_options, retval = -EINVAL;
-
-		if (get_user(new_options, p))
-			return -EFAULT;
-		if (new_options & WDIOS_DISABLECARD) {
-			ali_stop();
-			retval = 0;
-		}
-		if (new_options & WDIOS_ENABLECARD) {
-			ali_start();
-			retval = 0;
-		}
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		ali_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-	{
-		int new_timeout;
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if (ali_settimer(new_timeout))
-			return -EINVAL;
-		ali_keepalive();
-		/* Fall */
-	}
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/*
- *	ali_open	-	handle open of ali watchdog
- *	@inode: inode from VFS
- *	@file: file from VFS
- *
- *	Open the ALi watchdog device. Ensure only one person opens it
- *	at a time. Also start the watchdog running.
- */
-
-static int ali_open(struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &ali_is_open))
-		return -EBUSY;
-
-	/* Activate */
-	ali_start();
-	return nonseekable_open(inode, file);
-}
-
-/*
- *	ali_release	-	close an ALi watchdog
- *	@inode: inode from VFS
- *	@file: file from VFS
- *
- *	Close the ALi watchdog device. Actual shutdown of the timer
- *	only occurs if the magic sequence has been set.
- */
-
-static int ali_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *      Shut off the timer.
-	 */
-	if (ali_expect_release == 42)
-		ali_stop();
-	else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
-		ali_keepalive();
-	}
-	clear_bit(0, &ali_is_open);
-	ali_expect_release = 0;
+	w->timeout = t;
 	return 0;
 }
 
-/*
- *	ali_notify_sys	-	System down notifier
- *
- *	Notifier for system down
- */
+static const struct watchdog_ops wdt_ops = {
+	.start	=	ali_start,
+	.stop	=	ali_stop,
+	.reboot	=	ali_stop,
+	.ping	=	ali_ping,
+	.set_timeout =  ali_settimer,
+};
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_KEEPALIVEPING |
+				WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		"ALi M1535 WatchDog Timer",
+};
 
-static int ali_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		ali_stop();		/* Turn the WDT off */
-	return NOTIFY_DONE;
-}
+static struct watchdog aliwd = {
+	.name = "ALiM1535",
+	.info = &ident,
+	.ops = &wdt_ops,
+	.owner = THIS_MODULE,
+};
 
 /*
  *	Data for PCI driver interface
@@ -348,9 +197,9 @@ static int __init ali_find_watchdog(void)
 	/* Timer bits */
 	wdog &= ~0x3F;
 	/* Issued events */
-	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));
+	wdog &= ~((1 << 27)|(1 << 26)|(1 << 25)|(1 << 24));
 	/* No monitor bits */
-	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));
+	wdog &= ~((1 << 16)|(1 << 13)|(1 << 12)|(1 << 11)|(1 << 10)|(1 << 9));
 
 	pci_write_config_dword(pdev, 0xCC, wdog);
 
@@ -358,29 +207,6 @@ static int __init ali_find_watchdog(void)
 }
 
 /*
- *	Kernel Interfaces
- */
-
-static const struct file_operations ali_fops = {
-	.owner 		=	THIS_MODULE,
-	.llseek 	=	no_llseek,
-	.write		=	ali_write,
-	.unlocked_ioctl =	ali_ioctl,
-	.open 		=	ali_open,
-	.release 	=	ali_release,
-};
-
-static struct miscdevice ali_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&ali_fops,
-};
-
-static struct notifier_block ali_notifier = {
-	.notifier_call =	ali_notify_sys,
-};
-
-/*
  *	watchdog_init	-	module initialiser
  *
  *	Scan for a suitable watchdog and if so initialize it. Return an error
@@ -405,31 +231,16 @@ static int __init watchdog_init(void)
 	}
 
 	/* Calculate the watchdog's timeout */
-	ali_settimer(timeout);
-
-	ret = register_reboot_notifier(&ali_notifier);
-	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		goto out;
-	}
+	ali_settimer(&aliwd, timeout);
 
-	ret = misc_register(&ali_miscdev);
-	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
-		goto unreg_reboot;
+	ret = watchdog_register(&aliwd, nowayout);
+	if (ret < 0) {
+		pci_dev_put(ali_pci);
+		return ret;
 	}
-
 	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
-
-out:
-	return ret;
-unreg_reboot:
-	unregister_reboot_notifier(&ali_notifier);
-	goto out;
+	return 0;
 }
 
 /*
@@ -440,12 +251,7 @@ unreg_reboot:
 
 static void __exit watchdog_exit(void)
 {
-	/* Stop the timer before we leave */
-	ali_stop();
-
-	/* Deregister */
-	misc_deregister(&ali_miscdev);
-	unregister_reboot_notifier(&ali_notifier);
+	watchdog_unregister(&aliwd);
 	pci_dev_put(ali_pci);
 }
 
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index a045ef8..6194ede 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -36,6 +36,8 @@
 
 #include <asm/system.h>
 
+#include "watchdog.h"
+
 #define OUR_NAME "alim7101_wdt"
 #define PFX OUR_NAME ": "
 
@@ -51,7 +53,7 @@
  * We're going to use a 1 second timeout.
  * If we reset the watchdog every ~250ms we should be safe.  */
 
-#define WDT_INTERVAL (HZ/4+1)
+#define WDT_INTERVAL (HZ / 4 + 1)
 
 /*
  * We must not require too good response from the userspace daemon.
@@ -75,8 +77,6 @@ MODULE_PARM_DESC(use_gpio,
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
 static unsigned long next_heartbeat;
-static unsigned long wdt_is_open;
-static char wdt_expect_close;
 static struct pci_dev *alim7101_pmu;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
@@ -150,9 +150,9 @@ static void wdt_change(int writeval)
 	}
 }
 
-static void wdt_startup(void)
+static int wdt_startup(struct watchdog *w)
 {
-	next_heartbeat = jiffies + (timeout * HZ);
+	next_heartbeat = jiffies + (w->timeout * HZ);
 
 	/* We must enable before we kick off the timer in case the timer
 	   occurs as we ping it */
@@ -163,185 +163,57 @@ static void wdt_startup(void)
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	return 0;
 }
 
-static void wdt_turnoff(void)
+static int wdt_turnoff(struct watchdog *w)
 {
 	/* Stop the timer */
 	del_timer_sync(&timer);
 	wdt_change(WDT_DISABLE);
 	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	return 0;
 }
 
-static void wdt_keepalive(void)
+static void wdt_keepalive(struct watchdog *w)
 {
 	/* user land ping */
 	next_heartbeat = jiffies + (timeout * HZ);
 }
 
-/*
- * /dev/watchdog handling
- */
-
-static ssize_t fop_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (count) {
-		if (!nowayout) {
-			size_t ofs;
-
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
-			wdt_expect_close = 0;
-
-			/* now scan */
-			for (ofs = 0; ofs != count; ofs++) {
-				char c;
-				if (get_user(c, buf + ofs))
-					return -EFAULT;
-				if (c == 'V')
-					wdt_expect_close = 42;
-			}
-		}
-		/* someone wrote to us, we should restart timer */
-		wdt_keepalive();
-	}
-	return count;
-}
-
-static int fop_open(struct inode *inode, struct file *file)
+static int wdt_set_timeout(struct watchdog *w, int t)
 {
-	/* Just in case we're already talking to someone... */
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-	/* Good, fire up the show */
-	wdt_startup();
-	return nonseekable_open(inode, file);
-}
-
-static int fop_close(struct inode *inode, struct file *file)
-{
-	if (wdt_expect_close == 42)
-		wdt_turnoff();
-	else {
-		/* wim: shouldn't there be a: del_timer(&timer); */
-		printk(KERN_CRIT PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
-	}
-	clear_bit(0, &wdt_is_open);
-	wdt_expect_close = 0;
+	if (t < 0 || t > 65535)
+		return -EINVAL;
+	w->timeout = t;
 	return 0;
 }
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "ALiM7101",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_SETOPTIONS:
-	{
-		int new_options, retval = -EINVAL;
-
-		if (get_user(new_options, p))
-			return -EFAULT;
-		if (new_options & WDIOS_DISABLECARD) {
-			wdt_turnoff();
-			retval = 0;
-		}
-		if (new_options & WDIOS_ENABLECARD) {
-			wdt_startup();
-			retval = 0;
-		}
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-	{
-		int new_timeout;
-
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		/* arbitrary upper limit */
-		if (new_timeout < 1 || new_timeout > 3600)
-			return -EINVAL;
-		timeout = new_timeout;
-		wdt_keepalive();
-		/* Fall through */
-	}
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static const struct file_operations wdt_fops = {
-	.owner		=	THIS_MODULE,
-	.llseek		=	no_llseek,
-	.write		=	fop_write,
-	.open		=	fop_open,
-	.release	=	fop_close,
-	.unlocked_ioctl	=	fop_ioctl,
+static struct watchdog_ops wdt_ops = {
+	.start	=	wdt_startup,
+	.stop	=	wdt_turnoff,
+	.ping	=	wdt_keepalive,
+	.reboot =	wdt_turnoff,
+	.set_timeout =  wdt_set_timeout,
 };
-
-static struct miscdevice wdt_miscdev = {
-	.minor	=	WATCHDOG_MINOR,
-	.name	=	"watchdog",
-	.fops	=	&wdt_fops,
+  
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "ALiM7101",
 };
-
-/*
- *	Notifier for system down
- */
-
-static int wdt_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_turnoff();
-
-	if (code == SYS_RESTART) {
-		/*
-		 * Cobalt devices have no way of rebooting themselves other
-		 * than getting the watchdog to pull reset, so we restart the
-		 * watchdog on reboot with no heartbeat
-		 */
-		wdt_change(WDT_ENABLE);
-		printk(KERN_INFO PFX "Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second.\n");
-	}
-	return NOTIFY_DONE;
-}
-
-/*
- *	The WDT needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
- */
-
-static struct notifier_block wdt_notifier = {
-	.notifier_call = wdt_notify_sys,
+  
+static struct watchdog aliwd = {
+ 	.name = "ALiM7101",
+	.info = &ident,
+	.ops = &wdt_ops,
+	.owner = THIS_MODULE,
 };
 
 static void __exit alim7101_wdt_unload(void)
 {
-	wdt_turnoff();
-	/* Deregister */
-	misc_deregister(&wdt_miscdev);
-	unregister_reboot_notifier(&wdt_notifier);
+	watchdog_unregister(&aliwd);
 	pci_dev_put(alim7101_pmu);
 }
 
@@ -389,30 +261,15 @@ static int __init alim7101_wdt_init(void)
 			"timeout value must be 1 <= x <= 3600, using %d\n",
 								timeout);
 	}
-
-	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
-		goto err_out;
-	}
-
-	rc = misc_register(&wdt_miscdev);
-	if (rc) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
-		goto err_out_reboot;
-	}
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+	aliwd.timeout = timeout;
+
+	rc = watchdog_register(&aliwd, nowayout);
+	if (rc < 0)
+		return rc;
+	printk(KERN_INFO PFX
+	"WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
+					timeout, nowayout);
 	return 0;
-
-err_out_reboot:
-	unregister_reboot_notifier(&wdt_notifier);
 err_out:
 	pci_dev_put(alim7101_pmu);
 	return rc;
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 74f951c..6ec8d66 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -41,6 +41,8 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
+#include "watchdog.h"
+
 /* Module and version information */
 #define ESB_VERSION "0.03"
 #define ESB_MODULE_NAME "i6300ESB timer"
@@ -77,10 +79,8 @@
 /* internal variables */
 static void __iomem *BASEADDR;
 static DEFINE_SPINLOCK(esb_lock); /* Guards the hardware */
-static unsigned long timer_alive;
 static struct pci_dev *esb_pci;
 static unsigned short triggered; /* The status of the watchdog upon boot */
-static char esb_expect_close;
 
 /* module parameters */
 /* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
@@ -114,16 +114,28 @@ static inline void esb_unlock_registers(void)
 	writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
 }
 
-static void esb_timer_start(void)
+static void esb_timer_keepalive(struct watchdog *w)
+{
+	spin_lock(&esb_lock);
+	esb_unlock_registers();
+	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
+	/* FIXME: Do we need to flush anything here? */
+	spin_unlock(&esb_lock);
+}
+
+static int esb_timer_start(struct watchdog *w)
 {
 	u8 val;
 
+	esb_unlock_registers();
+	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 	/* Enable or Enable + Lock? */
 	val = 0x02 | (nowayout ? 0x01 : 0x00);
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
+	return 0;
 }
 
-static int esb_timer_stop(void)
+static int esb_timer_stop(struct watchdog *w)
 {
 	u8 val;
 
@@ -140,16 +152,7 @@ static int esb_timer_stop(void)
 	return (val & 0x01);
 }
 
-static void esb_timer_keepalive(void)
-{
-	spin_lock(&esb_lock);
-	esb_unlock_registers();
-	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
-	/* FIXME: Do we need to flush anything here? */
-	spin_unlock(&esb_lock);
-}
-
-static int esb_timer_set_heartbeat(int time)
+static int esb_timer_set_heartbeat(struct watchdog *w, int time)
 {
 	u32 val;
 
@@ -177,181 +180,38 @@ static int esb_timer_set_heartbeat(int time)
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 
 	/* FIXME: Do we need to flush everything out? */
+	w->timeout = time;
 
 	/* Done */
-	heartbeat = time;
 	spin_unlock(&esb_lock);
 	return 0;
 }
 
-static int esb_timer_read(void)
-{
-	u32 count;
-
-	/* This isn't documented, and doesn't take into
-	 * acount which stage is running, but it looks
-	 * like a 20 bit count down, so we might as well report it.
-	 */
-	pci_read_config_dword(esb_pci, 0x64, &count);
-	return (int)count;
-}
-
-/*
- *	/dev/watchdog handling
- */
-
-static int esb_open(struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &timer_alive))
-		return -EBUSY;
-
-	/* Reload and activate timer */
-	esb_timer_keepalive();
-	esb_timer_start();
-
-	return nonseekable_open(inode, file);
-}
-
-static int esb_release(struct inode *inode, struct file *file)
-{
-	/* Shut off the timer. */
-	if (esb_expect_close == 42)
-		esb_timer_stop();
-	else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
-		esb_timer_keepalive();
-	}
-	clear_bit(0, &timer_alive);
-	esb_expect_close = 0;
-	return 0;
-}
-
-static ssize_t esb_write(struct file *file, const char __user *data,
-			  size_t len, loff_t *ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
-			esb_expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					esb_expect_close = 42;
-			}
-		}
-
-		/* someone wrote to us, we should reload the timer */
-		esb_timer_keepalive();
-	}
-	return len;
-}
-
-static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int new_options, retval = -EINVAL;
-	int new_heartbeat;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		ESB_MODULE_NAME,
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident,
-					sizeof(ident)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-		return put_user(esb_timer_read(), p);
-
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(triggered, p);
-
-	case WDIOC_SETOPTIONS:
-	{
-		if (get_user(new_options, p))
-			return -EFAULT;
-
-		if (new_options & WDIOS_DISABLECARD) {
-			esb_timer_stop();
-			retval = 0;
-		}
-
-		if (new_options & WDIOS_ENABLECARD) {
-			esb_timer_keepalive();
-			esb_timer_start();
-			retval = 0;
-		}
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		esb_timer_keepalive();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-	{
-		if (get_user(new_heartbeat, p))
-			return -EFAULT;
-		if (esb_timer_set_heartbeat(new_heartbeat))
-			return -EINVAL;
-		esb_timer_keepalive();
-		/* Fall */
-	}
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/*
- *      Notify system
- */
-
-static int esb_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		esb_timer_stop();	/* Turn the WDT off */
-
-	return NOTIFY_DONE;
-}
+static const struct watchdog_info ident = {
+	.options =              WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =     0,
+	.identity =             ESB_MODULE_NAME,
+};
 
 /*
  *      Kernel Interfaces
  */
 
-static const struct file_operations esb_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = esb_write,
-	.unlocked_ioctl = esb_ioctl,
-	.open = esb_open,
-	.release = esb_release,
-};
-
-static struct miscdevice esb_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &esb_fops,
+static struct watchdog_ops esb_ops = {
+	.start = esb_timer_start,
+	.stop = esb_timer_stop,
+	.ping = esb_timer_keepalive,
+	.reboot = esb_timer_stop,
+	.set_timeout = esb_timer_set_heartbeat,
 };
-
-static struct notifier_block esb_notifier = {
-	.notifier_call = esb_notify_sys,
+  
+static struct watchdog esb_watchdog = {
+	.name = "i6300esb",
+	.info = &ident,
+	.ops = &esb_ops,
+	.owner = THIS_MODULE,
 };
 
 /*
@@ -453,54 +313,32 @@ static int __init watchdog_init(void)
 
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-	if (esb_timer_set_heartbeat(heartbeat)) {
-		esb_timer_set_heartbeat(WATCHDOG_HEARTBEAT);
+	if (heartbeat < 0x1 || heartbeat > 2 * 0x03ff) {
+		heartbeat = WATCHDOG_HEARTBEAT;
 		printk(KERN_INFO PFX
 			"heartbeat value must be 1<heartbeat<2046, using %d\n",
 								heartbeat);
 	}
-	ret = register_reboot_notifier(&esb_notifier);
-	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		goto err_unmap;
-	}
-
-	ret = misc_register(&esb_miscdev);
-	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
-		goto err_notifier;
-	}
-	esb_timer_stop();
-	printk(KERN_INFO PFX
-		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+	ret = watchdog_register(&esb_watchdog, heartbeat);
+	if (ret == 0) {
+		esb_timer_stop(&esb_watchdog);
+		if (triggered)
+			esb_watchdog.boot_status |= WDIOF_CARDRESET;
+		printk(KERN_INFO PFX
+		    "initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
 						BASEADDR, heartbeat, nowayout);
-	return 0;
-
-err_notifier:
-	unregister_reboot_notifier(&esb_notifier);
-err_unmap:
+		return 0;
+	}
 	iounmap(BASEADDR);
-/* err_release: */
 	pci_release_region(esb_pci, 0);
-/* err_disable: */
-	pci_disable_device(esb_pci);
-/* err_devput: */
+  	pci_disable_device(esb_pci);
 	pci_dev_put(esb_pci);
 	return ret;
 }
 
 static void __exit watchdog_cleanup(void)
 {
-	/* Stop the timer before we leave */
-	if (!nowayout)
-		esb_timer_stop();
-
-	/* Deregister */
-	misc_deregister(&esb_miscdev);
-	unregister_reboot_notifier(&esb_notifier);
+	watchdog_unregister(&esb_watchdog);
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 06553de..f72c59d 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -28,8 +28,9 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
+#include "watchdog.h"
+
 #define PFX "epx_c3: "
-static int epx_c3_alive;
 
 #define WATCHDOG_TIMEOUT 1		/* 1 sec default timeout */
 
@@ -40,137 +41,44 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 #define EPXC3_WATCHDOG_CTL_REG 0x1ee /* write 1 to enable, 0 to disable */
 #define EPXC3_WATCHDOG_PET_REG 0x1ef /* write anything to pet once enabled */
 
-static void epx_c3_start(void)
+static int epx_c3_start(struct watchdog *w)
 {
 	outb(1, EPXC3_WATCHDOG_CTL_REG);
+	outb(1, EPXC3_WATCHDOG_PET_REG);
+	return 0;
 }
 
-static void epx_c3_stop(void)
+static int epx_c3_stop(struct watchdog *w)
 {
-
 	outb(0, EPXC3_WATCHDOG_CTL_REG);
-
 	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
-}
-
-static void epx_c3_pet(void)
-{
-	outb(1, EPXC3_WATCHDOG_PET_REG);
-}
-
-/*
- *	Allow only one person to hold it open
- */
-static int epx_c3_open(struct inode *inode, struct file *file)
-{
-	if (epx_c3_alive)
-		return -EBUSY;
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	/* Activate timer */
-	epx_c3_start();
-	epx_c3_pet();
-
-	epx_c3_alive = 1;
-	printk(KERN_INFO "Started watchdog timer.\n");
-
-	return nonseekable_open(inode, file);
-}
-
-static int epx_c3_release(struct inode *inode, struct file *file)
-{
-	/* Shut off the timer.
-	 * Lock it in if it's a module and we defined ...NOWAYOUT */
-	if (!nowayout)
-		epx_c3_stop();		/* Turn the WDT off */
-
-	epx_c3_alive = 0;
-
 	return 0;
 }
 
-static ssize_t epx_c3_write(struct file *file, const char __user *data,
-			size_t len, loff_t *ppos)
+static void epx_c3_pet(struct watchdog *w)
 {
-	/* Refresh the timer. */
-	if (len)
-		epx_c3_pet();
-	return len;
-}
-
-static long epx_c3_ioctl(struct file *file, unsigned int cmd,
-						unsigned long arg)
-{
-	int options, retval = -EINVAL;
-	int __user *argp = (void __user *)arg;
-	static const struct watchdog_info ident = {
-		.options		= WDIOF_KEEPALIVEPING |
-					  WDIOF_MAGICCLOSE,
-		.firmware_version	= 0,
-		.identity		= "Winsystems EPX-C3 H/W Watchdog",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		return 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, argp);
-	case WDIOC_SETOPTIONS:
-		if (get_user(options, argp))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD) {
-			epx_c3_stop();
-			retval = 0;
-		}
-
-		if (options & WDIOS_ENABLECARD) {
-			epx_c3_start();
-			retval = 0;
-		}
-
-		return retval;
-	case WDIOC_KEEPALIVE:
-		epx_c3_pet();
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(WATCHDOG_TIMEOUT, argp);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static int epx_c3_notify_sys(struct notifier_block *this, unsigned long code,
-				void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		epx_c3_stop();		/* Turn the WDT off */
-
-	return NOTIFY_DONE;
+	outb(1, EPXC3_WATCHDOG_PET_REG);
 }
 
-static const struct file_operations epx_c3_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= epx_c3_write,
-	.unlocked_ioctl	= epx_c3_ioctl,
-	.open		= epx_c3_open,
-	.release	= epx_c3_release,
+static const struct watchdog_info ident = {
+	.options		= WDIOF_KEEPALIVEPING |
+				  WDIOF_MAGICCLOSE,
+	.firmware_version	= 0,
+	.identity		= "Winsystems EPX-C3 H/W Watchdog",
 };
 
-static struct miscdevice epx_c3_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &epx_c3_fops,
+static struct watchdog_ops wd_ops = {
+	.start = epx_c3_start,
+	.stop = epx_c3_stop,
+	.ping = epx_c3_pet,
+	.reboot= epx_c3_stop,
 };
 
-static struct notifier_block epx_c3_notifier = {
-	.notifier_call = epx_c3_notify_sys,
+static struct watchdog watchdog_sbc = {
+	.name = "sbc_epx_c3",
+	.info = &ident,
+	.ops = &wd_ops,
+	.owner = THIS_MODULE
 };
 
 static const char banner[] __initdata =
@@ -183,34 +91,17 @@ static int __init watchdog_init(void)
 	if (!request_region(EPXC3_WATCHDOG_CTL_REG, 2, "epxc3_watchdog"))
 		return -EBUSY;
 
-	ret = register_reboot_notifier(&epx_c3_notifier);
-	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier "
-			"(err=%d)\n", ret);
-		goto out;
-	}
-
-	ret = misc_register(&epx_c3_miscdev);
-	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
-			"(err=%d)\n", WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&epx_c3_notifier);
-		goto out;
-	}
-
-	printk(banner);
-
-	return 0;
-
-out:
-	release_region(EPXC3_WATCHDOG_CTL_REG, 2);
+	ret = watchdog_register(&watchdog_sbc, WATCHDOG_TIMEOUT);
+	if (ret == 0)
+		printk(banner);
+	else
+		release_region(EPXC3_WATCHDOG_CTL_REG, 2);
 	return ret;
 }
 
 static void __exit watchdog_exit(void)
 {
-	misc_deregister(&epx_c3_miscdev);
-	unregister_reboot_notifier(&epx_c3_notifier);
+	watchdog_unregister(&watchdog_sbc);
 	release_region(EPXC3_WATCHDOG_CTL_REG, 2);
 }
 
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 23da3cc..62038c2 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -46,6 +46,8 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
+#include "watchdog.h"
+
 #define SC1200_MODULE_VER	"build 20020303"
 #define SC1200_MODULE_NAME	"sc1200wdt"
 #define PFX			SC1200_MODULE_NAME ": "
@@ -75,8 +77,6 @@ static char banner[] __initdata = KERN_INFO PFX SC1200_MODULE_VER;
 static int timeout = 1;
 static int io = -1;
 static int io_len = 2;		/* for non plug and play */
-static unsigned long open_flag;
-static char expect_close;
 static DEFINE_SPINLOCK(sc1200wdt_lock);	/* io port access serialisation */
 
 #if defined CONFIG_PNP
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(isapnp,
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, "io port");
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "range is 0-255 minutes, default is 1");
+MODULE_PARM_DESC(timeout, "range is 0-255 seconds, default is 60");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -133,7 +133,7 @@ static inline void sc1200wdt_write_data(unsigned char index,
 }
 
 
-static void sc1200wdt_start(void)
+static int sc1200wdt_start(struct watchdog *w)
 {
 	unsigned char reg;
 	spin_lock(&sc1200wdt_lock);
@@ -143,18 +143,20 @@ static void sc1200wdt_start(void)
 	reg |= (KBC_IRQ | MSE_IRQ | UART1_IRQ | UART2_IRQ);
 	__sc1200wdt_write_data(WDCF, reg);
 	/* set the timeout and get the ball rolling */
-	__sc1200wdt_write_data(WDTO, timeout);
+	__sc1200wdt_write_data(WDTO, w->timeout / 60);
 
 	spin_unlock(&sc1200wdt_lock);
+	return 0;
 }
 
-static void sc1200wdt_stop(void)
+static int sc1200wdt_stop(struct watchdog *w)
 {
 	sc1200wdt_write_data(WDTO, 0);
+	return 0;
 }
 
 /* This returns the status of the WDO signal, inactive high. */
-static inline int sc1200wdt_status(void)
+static int sc1200wdt_status(struct watchdog *w)
 {
 	unsigned char ret;
 
@@ -166,164 +168,39 @@ static inline int sc1200wdt_status(void)
 	return (ret & 0x01) ? 0 : WDIOF_KEEPALIVEPING;
 }
 
-static int sc1200wdt_open(struct inode *inode, struct file *file)
+static int sc1200wdt_set_timeout(struct watchdog *w, int t)
 {
-	/* allow one at a time */
-	if (test_and_set_bit(0, &open_flag))
-		return -EBUSY;
-
-	if (timeout > MAX_TIMEOUT)
-		timeout = MAX_TIMEOUT;
-
-	sc1200wdt_start();
-	printk(KERN_INFO PFX "Watchdog enabled, timeout = %d min(s)", timeout);
-
-	return nonseekable_open(inode, file);
-}
-
-
-static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
-						unsigned long arg)
-{
-	int new_timeout;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 0,
-		.identity = "PC87307/PC97307",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof ident))
-			return -EFAULT;
-		return 0;
-
-	case WDIOC_GETSTATUS:
-		return put_user(sc1200wdt_status(), p);
-
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_SETOPTIONS:
-	{
-		int options, retval = -EINVAL;
-
-		if (get_user(options, p))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD) {
-			sc1200wdt_stop();
-			retval = 0;
-		}
-
-		if (options & WDIOS_ENABLECARD) {
-			sc1200wdt_start();
-			retval = 0;
-		}
-
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		sc1200wdt_write_data(WDTO, timeout);
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		/* the API states this is given in secs */
-		new_timeout /= 60;
-		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-			return -EINVAL;
-		timeout = new_timeout;
-		sc1200wdt_write_data(WDTO, timeout);
-		/* fall through and return the new timeout */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout * 60, p);
-
-	default:
-		return -ENOTTY;
-	}
-}
-
-
-static int sc1200wdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42) {
-		sc1200wdt_stop();
-		printk(KERN_INFO PFX "Watchdog disabled\n");
-	} else {
-		sc1200wdt_write_data(WDTO, timeout);
-		printk(KERN_CRIT PFX
-			"Unexpected close!, timeout = %d min(s)\n", timeout);
-	}
-	clear_bit(0, &open_flag);
-	expect_close = 0;
-
-	return 0;
-}
-
-
-static ssize_t sc1200wdt_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-
-		sc1200wdt_write_data(WDTO, timeout);
-		return len;
-	}
-
+	/* the API states this is given in secs */
+	t /= 60;
+	if (t < 0 || t > MAX_TIMEOUT)
+		return -EINVAL;
+	w->timeout = t * 60;
 	return 0;
 }
 
-
-static int sc1200wdt_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		sc1200wdt_stop();
-
-	return NOTIFY_DONE;
-}
-
-
-static struct notifier_block sc1200wdt_notifier = {
-	.notifier_call =	sc1200wdt_notify_sys,
+static const struct watchdog_info sc1200_info = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		"PC87307/PC97307",
 };
 
-static const struct file_operations sc1200wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= sc1200wdt_write,
-	.unlocked_ioctl = sc1200wdt_ioctl,
-	.open		= sc1200wdt_open,
-	.release	= sc1200wdt_release,
+static struct watchdog_ops sc1200_ops = {
+	.start = sc1200wdt_start,
+	.stop = sc1200wdt_stop,
+	.reboot= sc1200wdt_stop,
+	.status = sc1200wdt_status,
+	.set_timeout = sc1200wdt_set_timeout,
 };
 
-static struct miscdevice sc1200wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &sc1200wdt_fops,
+static struct watchdog watchdog_sc1200 = {
+	.name = "sc1200",
+	.info = &sc1200_info,
+	.ops = &sc1200_ops,
+	.owner = THIS_MODULE
 };
 
-
 static int __init sc1200wdt_probe(void)
 {
 	/* The probe works by reading the PMC3 register's default value of 0x0e
@@ -398,7 +275,7 @@ static int __init sc1200wdt_init(void)
 	if (isapnp) {
 		ret = pnp_register_driver(&scl200wdt_pnp_driver);
 		if (ret)
-			goto out_clean;
+			return ret;
 	}
 #endif
 
@@ -424,47 +301,21 @@ static int __init sc1200wdt_init(void)
 	ret = sc1200wdt_probe();
 	if (ret)
 		goto out_io;
-
-	ret = register_reboot_notifier(&sc1200wdt_notifier);
-	if (ret) {
-		printk(KERN_ERR PFX
-			"Unable to register reboot notifier err = %d\n", ret);
-		goto out_io;
-	}
-
-	ret = misc_register(&sc1200wdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR PFX
-			"Unable to register miscdev on minor %d\n",
-							WATCHDOG_MINOR);
-		goto out_rbt;
-	}
-
-	/* ret = 0 */
-
-out_clean:
-	return ret;
-
-out_rbt:
-	unregister_reboot_notifier(&sc1200wdt_notifier);
-
+	return  watchdog_register(&watchdog_sc1200, timeout * 60);
 out_io:
 	release_region(io, io_len);
-
 out_pnp:
 #if defined CONFIG_PNP
 	if (isapnp)
 		pnp_unregister_driver(&scl200wdt_pnp_driver);
 #endif
-	goto out_clean;
+	return ret;
 }
 
 
 static void __exit sc1200wdt_exit(void)
 {
-	misc_deregister(&sc1200wdt_miscdev);
-	unregister_reboot_notifier(&sc1200wdt_notifier);
-
+	watchdog_unregister(&watchdog_sc1200);
 #if defined CONFIG_PNP
 	if (isapnp)
 		pnp_unregister_driver(&scl200wdt_pnp_driver);
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 7204f96..4776dc8 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -48,6 +48,8 @@
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
 
+#include "watchdog.h"
+
 #define PFX "SoftDog: "
 
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
@@ -63,14 +65,11 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-#ifdef ONLY_TESTING
-static int soft_noboot = 1;
-#else
-static int soft_noboot = 0;
-#endif  /* ONLY_TESTING */
-
+static int soft_noboot;
 module_param(soft_noboot, int, 0);
-MODULE_PARM_DESC(soft_noboot, "Softdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
+MODULE_PARM_DESC(soft_noboot, "Softdog action, set to 1 to ignore reboots, 0 to reboot (default 0)");
+
+static struct watchdog softdog;
 
 /*
  *	Our timer
@@ -80,9 +79,6 @@ static void watchdog_fire(unsigned long);
 
 static struct timer_list watchdog_ticktock =
 		TIMER_INITIALIZER(watchdog_fire, 0, 0);
-static unsigned long driver_open, orphan_timer;
-static char expect_close;
-
 
 /*
  *	If the timer expires..
@@ -90,7 +86,7 @@ static char expect_close;
 
 static void watchdog_fire(unsigned long data)
 {
-	if (test_and_clear_bit(0, &orphan_timer))
+	if (test_and_clear_bit(WDOG_ORPHAN, &softdog.status))
 		module_put(THIS_MODULE);
 
 	if (soft_noboot)
@@ -102,165 +98,46 @@ static void watchdog_fire(unsigned long data)
 	}
 }
 
-/*
- *	Softdog operations
- */
-
-static int softdog_keepalive(void)
+static int softdog_start(struct watchdog *w)
 {
-	mod_timer(&watchdog_ticktock, jiffies+(soft_margin*HZ));
+	mod_timer(&watchdog_ticktock, jiffies + (w->timeout*HZ));
 	return 0;
 }
 
-static int softdog_stop(void)
+static int softdog_stop(struct watchdog *w)
 {
 	del_timer(&watchdog_ticktock);
 	return 0;
 }
 
-static int softdog_set_heartbeat(int t)
+static int softdog_set_heartbeat(struct watchdog *w, int t)
 {
-	if ((t < 0x0001) || (t > 0xFFFF))
+	if (t < 0x0001 || t > 0xFFFF)
 		return -EINVAL;
 
-	soft_margin = t;
+	w->timeout = t;
 	return 0;
 }
 
-/*
- *	/dev/watchdog handling
- */
-
-static int softdog_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &driver_open))
-		return -EBUSY;
-	if (!test_and_clear_bit(0, &orphan_timer))
-		__module_get(THIS_MODULE);
-	/*
-	 *	Activate timer
-	 */
-	softdog_keepalive();
-	return nonseekable_open(inode, file);
-}
-
-static int softdog_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *	Shut off the timer.
-	 * 	Lock it in if it's a module and we set nowayout
-	 */
-	if (expect_close == 42) {
-		softdog_stop();
-		module_put(THIS_MODULE);
-	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
-		set_bit(0, &orphan_timer);
-		softdog_keepalive();
-	}
-	clear_bit(0, &driver_open);
-	expect_close = 0;
-	return 0;
-}
-
-static ssize_t softdog_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
-{
-	/*
-	 *	Refresh the timer.
-	 */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		softdog_keepalive();
-	}
-	return len;
-}
-
-static long softdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Software Watchdog",
-	};
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		softdog_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (softdog_set_heartbeat(new_margin))
-			return -EINVAL;
-		softdog_keepalive();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(soft_margin, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/*
- *	Notifier for system down
- */
-
-static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		/* Turn the WDT off */
-		softdog_stop();
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations softdog_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= softdog_write,
-	.unlocked_ioctl	= softdog_ioctl,
-	.open		= softdog_open,
-	.release	= softdog_release,
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		"Software Watchdog",
 };
 
-static struct miscdevice softdog_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &softdog_fops,
+static struct watchdog_ops wdt_ops = {
+	.start	=	softdog_start,
+	.stop	=	softdog_stop,
+	.set_timeout =  softdog_set_heartbeat
 };
 
-static struct notifier_block softdog_notifier = {
-	.notifier_call	= softdog_notify_sys,
+static struct watchdog softdog = {
+	.name = "softdog",
+	.info = &ident,
+	.ops = &wdt_ops,
+	.owner = THIS_MODULE,
 };
 
 static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
@@ -271,38 +148,22 @@ static int __init watchdog_init(void)
 
 	/* Check that the soft_margin value is within it's range;
 	   if not reset to the default */
-	if (softdog_set_heartbeat(soft_margin)) {
-		softdog_set_heartbeat(TIMER_MARGIN);
+	if (softdog_set_heartbeat(&softdog, soft_margin)) {
+		softdog_set_heartbeat(&softdog, TIMER_MARGIN);
 		printk(KERN_INFO PFX
 		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
-
-	ret = register_reboot_notifier(&softdog_notifier);
-	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		return ret;
-	}
-
-	ret = misc_register(&softdog_miscdev);
-	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&softdog_notifier);
-		return ret;
-	}
-
-	printk(banner, soft_noboot, soft_margin, nowayout);
-
-	return 0;
+	
+	ret = watchdog_register(&softdog, nowayout);
+	if (ret == 0)
+		printk(banner, soft_noboot, soft_margin, nowayout);
+	return ret;
 }
 
 static void __exit watchdog_exit(void)
 {
-	misc_deregister(&softdog_miscdev);
-	unregister_reboot_notifier(&softdog_notifier);
+	watchdog_unregister(&softdog);
 }
 
 module_init(watchdog_init);
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index eddb918..4a9853b 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -1,5 +1,5 @@
 /*
- *	Industrial Computer Source WDT500/501 driver
+ *	Industrial Computer Source WDT501 driver
  *
  *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *						All Rights Reserved.
@@ -49,8 +49,8 @@
 #include <asm/system.h>
 #include "wd501p.h"
 
-static unsigned long wdt_is_open;
-static char expect_close;
+#include "watchdog.h"
+
 
 /*
  *	Module parameters
@@ -82,14 +82,15 @@ MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
 module_param(irq, int, 0);
 MODULE_PARM_DESC(irq, "WDT irq (default=11)");
 
-#ifdef CONFIG_WDT_501
 /* Support for the Fan Tachometer on the WDT501-P */
 static int tachometer;
-
+static int type = 500;
 module_param(tachometer, int, 0);
 MODULE_PARM_DESC(tachometer,
 		"WDT501-P Fan Tachometer support (0=disable, default=0)");
-#endif /* CONFIG_WDT_501 */
+module_param(type, int, 0);
+MODULE_PARM_DESC(type,
+		"WDT501-P Card type (500 or 501 , default=500)");
 
 /*
  *	Programming support
@@ -115,7 +116,7 @@ static void wdt_ctr_load(int ctr, int val)
  *	Start the watchdog driver.
  */
 
-static int wdt_start(void)
+static int wdt_start(struct watchdog *w)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
@@ -140,7 +141,7 @@ static int wdt_start(void)
  *	Stop the watchdog driver.
  */
 
-static int wdt_stop(void)
+static int wdt_stop(struct watchdog *w)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
@@ -158,7 +159,7 @@ static int wdt_stop(void)
  *	reloading the cascade counter.
  */
 
-static int wdt_ping(void)
+static void wdt_ping(struct watchdog *w)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
@@ -169,7 +170,6 @@ static int wdt_ping(void)
 	wdt_ctr_load(1, wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
 	spin_unlock_irqrestore(&wdt_lock, flags);
-	return 0;
 }
 
 /**
@@ -181,12 +181,12 @@ static int wdt_ping(void)
  *	successful we return 0.
  */
 
-static int wdt_set_heartbeat(int t)
+static int wdt_set_heartbeat(struct watchdog *w, int t)
 {
 	if (t < 1 || t > 65535)
 		return -EINVAL;
 
-	heartbeat = t;
+	w->timeout = t;
 	wd_heartbeat = t * 100;
 	return 0;
 }
@@ -202,36 +202,36 @@ static int wdt_set_heartbeat(int t)
  *	we then map the bits onto the status ioctl flags.
  */
 
-static int wdt_get_status(int *status)
+static int wdt_get_status(struct watchdog *w)
 {
 	unsigned char new_status;
+	int status = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wdt_lock, flags);
 	new_status = inb_p(WDT_SR);
 	spin_unlock_irqrestore(&wdt_lock, flags);
 
-	*status = 0;
+	status = 0;
 	if (new_status & WDC_SR_ISOI0)
-		*status |= WDIOF_EXTERN1;
+		status |= WDIOF_EXTERN1;
 	if (new_status & WDC_SR_ISII1)
-		*status |= WDIOF_EXTERN2;
-#ifdef CONFIG_WDT_501
-	if (!(new_status & WDC_SR_TGOOD))
-		*status |= WDIOF_OVERHEAT;
-	if (!(new_status & WDC_SR_PSUOVER))
-		*status |= WDIOF_POWEROVER;
-	if (!(new_status & WDC_SR_PSUUNDR))
-		*status |= WDIOF_POWERUNDER;
-	if (tachometer) {
-		if (!(new_status & WDC_SR_FANGOOD))
-			*status |= WDIOF_FANFAULT;
+		status |= WDIOF_EXTERN2;
+	if (type == 501) {
+		if (!(new_status & WDC_SR_TGOOD))
+			status |= WDIOF_OVERHEAT;
+		if (!(new_status & WDC_SR_PSUOVER))
+			status |= WDIOF_POWEROVER;
+		if (!(new_status & WDC_SR_PSUUNDR))
+			status |= WDIOF_POWERUNDER;
+		if (tachometer) {
+			if (!(new_status & WDC_SR_FANGOOD))
+				status |= WDIOF_FANFAULT;
+		}
 	}
-#endif /* CONFIG_WDT_501 */
-	return 0;
+	return status;
 }
 
-#ifdef CONFIG_WDT_501
 /**
  *	wdt_get_temperature:
  *
@@ -239,7 +239,7 @@ static int wdt_get_status(int *status)
  *	farenheit. It was designed by an imperial measurement luddite.
  */
 
-static int wdt_get_temperature(int *temperature)
+static int wdt_get_temperature(struct watchdog *w)
 {
 	unsigned short c;
 	unsigned long flags;
@@ -247,10 +247,18 @@ static int wdt_get_temperature(int *temperature)
 	spin_lock_irqsave(&wdt_lock, flags);
 	c = inb_p(WDT_RT);
 	spin_unlock_irqrestore(&wdt_lock, flags);
-	*temperature = (c * 11 / 15) + 7;
-	return 0;
+	return (c * 11 / 15) + 7;
+}
+
+static void wdt_decode_501(int status)
+{
+	if (!(status & WDC_SR_TGOOD))
+		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
+	if (!(status & WDC_SR_PSUOVER))
+		printk(KERN_CRIT "PSU over voltage.\n");
+	if (!(status & WDC_SR_PSUUNDR))
+		printk(KERN_CRIT "PSU under voltage.\n");
 }
-#endif /* CONFIG_WDT_501 */
 
 /**
  *	wdt_interrupt:
@@ -275,18 +283,13 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 
 	printk(KERN_CRIT "WDT status %d\n", status);
 
-#ifdef CONFIG_WDT_501
-	if (!(status & WDC_SR_TGOOD))
-		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
-	if (!(status & WDC_SR_PSUOVER))
-		printk(KERN_CRIT "PSU over voltage.\n");
-	if (!(status & WDC_SR_PSUUNDR))
-		printk(KERN_CRIT "PSU under voltage.\n");
-	if (tachometer) {
-		if (!(status & WDC_SR_FANGOOD))
-			printk(KERN_CRIT "Possible fan fault.\n");
+	if (type == 501) {
+		wdt_decode_501(status);
+		if (tachometer) {
+			if (!(status & WDC_SR_FANGOOD))
+				printk(KERN_CRIT "Possible fan fault.\n");
+		}
 	}
-#endif /* CONFIG_WDT_501 */
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
@@ -304,266 +307,31 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 }
 
 
-/**
- *	wdt_write:
- *	@file: file handle to the watchdog
- *	@buf: buffer to write (unused as data does not matter here
- *	@count: count of bytes
- *	@ppos: pointer to the position to write. No seeks allowed
- *
- *	A write to a watchdog device is defined as a keepalive signal. Any
- *	write of data will do, as we we don't define content meaning.
- */
-
-static ssize_t wdt_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
-{
-	if (count) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		wdt_ping();
-	}
-	return count;
-}
-
-/**
- *	wdt_ioctl:
- *	@file: file handle to the device
- *	@cmd: watchdog command
- *	@arg: argument pointer
- *
- *	The watchdog API defines a common set of functions for all watchdogs
- *	according to their available features. We only actually usefully support
- *	querying capabilities and current status.
- */
-
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_heartbeat;
-	int status;
-
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT|
-					WDIOF_MAGICCLOSE|
-					WDIOF_KEEPALIVEPING,
-		.firmware_version =	1,
-		.identity =		"WDT500/501",
-	};
-
-	/* Add options according to the card we have */
-	ident.options |= (WDIOF_EXTERN1|WDIOF_EXTERN2);
-#ifdef CONFIG_WDT_501
-	ident.options |= (WDIOF_OVERHEAT|WDIOF_POWERUNDER|WDIOF_POWEROVER);
-	if (tachometer)
-		ident.options |= WDIOF_FANFAULT;
-#endif /* CONFIG_WDT_501 */
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-		wdt_get_status(&status);
-		return put_user(status, p);
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_heartbeat, p))
-			return -EFAULT;
-		if (wdt_set_heartbeat(new_heartbeat))
-			return -EINVAL;
-		wdt_ping();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/**
- *	wdt_open:
- *	@inode: inode of device
- *	@file: file handle to device
- *
- *	The watchdog device has been opened. The watchdog device is single
- *	open and on opening we load the counters. Counter zero is a 100Hz
- *	cascade, into counter 1 which downcounts to reboot. When the counter
- *	triggers counter 2 downcounts the length of the reset pulse which
- *	set set to be as long as possible.
- */
-
-static int wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-	/*
-	 *	Activate
-	 */
-	wdt_start();
-	return nonseekable_open(inode, file);
-}
-
-/**
- *	wdt_release:
- *	@inode: inode to board
- *	@file: file handle to board
- *
- *	The watchdog has a configurable API. There is a religious dispute
- *	between people who want their watchdog to be able to shut down and
- *	those who want to be sure if the watchdog manager dies the machine
- *	reboots. In the former case we disable the counters, in the latter
- *	case you have to open it again very soon.
- */
-
-static int wdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42) {
-		wdt_stop();
-		clear_bit(0, &wdt_is_open);
-	} else {
-		printk(KERN_CRIT
-		 "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
-		wdt_ping();
-	}
-	expect_close = 0;
-	return 0;
-}
-
-#ifdef CONFIG_WDT_501
-/**
- *	wdt_temp_read:
- *	@file: file handle to the watchdog board
- *	@buf: buffer to write 1 byte into
- *	@count: length of buffer
- *	@ptr: offset (no seek allowed)
- *
- *	Temp_read reports the temperature in degrees Fahrenheit. The API is in
- *	farenheit. It was designed by an imperial measurement luddite.
- */
-
-static ssize_t wdt_temp_read(struct file *file, char __user *buf,
-						size_t count, loff_t *ptr)
-{
-	int temperature;
-
-	if (wdt_get_temperature(&temperature))
-		return -EFAULT;
-
-	if (copy_to_user(buf, &temperature, 1))
-		return -EFAULT;
-
-	return 1;
-}
-
-/**
- *	wdt_temp_open:
- *	@inode: inode of device
- *	@file: file handle to device
- *
- *	The temperature device has been opened.
- */
-
-static int wdt_temp_open(struct inode *inode, struct file *file)
-{
-	return nonseekable_open(inode, file);
-}
-
-/**
- *	wdt_temp_release:
- *	@inode: inode to board
- *	@file: file handle to board
- *
- *	The temperature device has been closed.
- */
-
-static int wdt_temp_release(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-#endif /* CONFIG_WDT_501 */
-
-/**
- *	notify_sys:
- *	@this: our notifier block
- *	@code: the event being reported
- *	@unused: unused
- *
- *	Our notifier is called on system shutdowns. We want to turn the card
- *	off at reboot otherwise the machine will reboot again during memory
- *	test or worse yet during the following fsck. This would suck, in fact
- *	trust me - if it happens it does suck.
- */
-
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_stop();
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-
-static const struct file_operations wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= wdt_write,
-	.unlocked_ioctl	= wdt_ioctl,
-	.open		= wdt_open,
-	.release	= wdt_release,
-};
-
-static struct miscdevice wdt_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &wdt_fops,
-};
-
-#ifdef CONFIG_WDT_501
-static const struct file_operations wdt_temp_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.read		= wdt_temp_read,
-	.open		= wdt_temp_open,
-	.release	= wdt_temp_release,
+static struct watchdog_ops wdt_ops = {
+	.start	=	wdt_start,
+	.stop	=	wdt_stop,
+	.reboot =	wdt_stop,
+	.ping	=	wdt_ping,
+	.status = 	wdt_get_status,
+	.temperature =	wdt_get_temperature,
+	.set_timeout =  wdt_set_heartbeat
 };
 
-static struct miscdevice temp_miscdev = {
-	.minor	= TEMP_MINOR,
-	.name	= "temperature",
-	.fops	= &wdt_temp_fops,
+static struct watchdog_info wdt_ident = {
+	.options =		WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+				WDIOF_KEEPALIVEPING | WDIOF_EXTERN1 |
+					WDIOF_EXTERN2,
+	.firmware_version =	1,
+	.identity =		"WDT500/501",
 };
-#endif /* CONFIG_WDT_501 */
-
-/*
- *	The WDT card needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
- */
 
-static struct notifier_block wdt_notifier = {
-	.notifier_call = wdt_notify_sys,
+static struct watchdog wdt_dog = {
+	.name =		"wdt",
+	.ops =		&wdt_ops,
+	.info =		&wdt_ident,
+	.owner =	THIS_MODULE,
 };
-
+	
 /**
  *	cleanup_module:
  *
@@ -576,12 +344,8 @@ static struct notifier_block wdt_notifier = {
 
 static void __exit wdt_exit(void)
 {
-	misc_deregister(&wdt_miscdev);
-#ifdef CONFIG_WDT_501
-	misc_deregister(&temp_miscdev);
-#endif /* CONFIG_WDT_501 */
-	unregister_reboot_notifier(&wdt_notifier);
-	free_irq(irq, NULL);
+	watchdog_unregister(&wdt_dog);
+	free_irq(irq, &wdt_dog);
 	release_region(io, 8);
 }
 
@@ -597,14 +361,24 @@ static int __init wdt_init(void)
 {
 	int ret;
 
+	if (type != 500 && type != 501) {
+		printk(KERN_ERR "wdt: unknown card type '%d'.\n", type);
+		return -ENODEV;
+	}
+	if (type == 501)
+		wdt_ident.options |= (WDIOF_OVERHEAT | WDIOF_POWERUNDER
+						|WDIOF_POWEROVER);
+	else
+		wdt_ops.temperature = NULL;
+	if (tachometer)
+		wdt_ident.options |= WDIOF_FANFAULT;
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-	if (wdt_set_heartbeat(heartbeat)) {
-		wdt_set_heartbeat(WD_TIMO);
+	if (wdt_set_heartbeat(&wdt_dog, heartbeat)) {
+		wdt_set_heartbeat(&wdt_dog, WD_TIMO);
 		printk(KERN_INFO "wdt: heartbeat value must be 0 < heartbeat < 65536, using %d\n",
 			WD_TIMO);
 	}
-
 	if (!request_region(io, 8, "wdt501p")) {
 		printk(KERN_ERR
 			"wdt: I/O address 0x%04x already in use\n", io);
@@ -612,59 +386,27 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
+	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED,
+							"wdt501p", &wdt_dog);
 	if (ret) {
 		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
 	}
 
-	ret = register_reboot_notifier(&wdt_notifier);
-	if (ret) {
-		printk(KERN_ERR
-		      "wdt: cannot register reboot notifier (err=%d)\n", ret);
-		goto outirq;
-	}
-
-#ifdef CONFIG_WDT_501
-	ret = misc_register(&temp_miscdev);
-	if (ret) {
-		printk(KERN_ERR
-			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
-		goto outrbt;
-	}
-#endif /* CONFIG_WDT_501 */
-
-	ret = misc_register(&wdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR
-			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
-		goto outmisc;
+	ret = watchdog_register(&wdt_dog, nowayout);
+	
+	if (ret == 0) {
+		printk(KERN_INFO "WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
+			io, irq, heartbeat, nowayout);
+		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+					(tachometer ? "Enabled" : "Disabled"));
+		return 0;
 	}
-
-	ret = 0;
-	printk(KERN_INFO "WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
-		io, irq, heartbeat, nowayout);
-#ifdef CONFIG_WDT_501
-	printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
-				(tachometer ? "Enabled" : "Disabled"));
-#endif /* CONFIG_WDT_501 */
-
-out:
-	return ret;
-
-outmisc:
-#ifdef CONFIG_WDT_501
-	misc_deregister(&temp_miscdev);
-outrbt:
-#endif /* CONFIG_WDT_501 */
-	unregister_reboot_notifier(&wdt_notifier);
-outirq:
 	free_irq(irq, NULL);
 outreg:
 	release_region(io, 8);
-	goto out;
+out:
+	return ret;
 }
 
 module_init(wdt_init);

