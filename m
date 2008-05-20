Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbYETSpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbYETSpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbYETSpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:45:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42676 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756555AbYETSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:45:06 -0400
Date: Tue, 20 May 2008 19:31:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Message-ID: <20080520193135.432acc90@core>
In-Reply-To: <20080520154711.GD2724@infomag.infomag.iguana.be>
References: <13762.1211142411@vena.lwn.net>
	<200805200114.24819.arnd@arndb.de>
	<20080520062056.GA5292@infradead.org>
	<200805201030.14092.arnd@arndb.de>
	<20080520154711.GD2724@infomag.infomag.iguana.be>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int register_watchdogdevice(struct watchdog_device *dev, struct device *parent)
> +{
> +	int ret;
> +
> +	if (dev == NULL ||
> +	    dev->watchdog_ops == NULL)
> +		return -ENODATA;
> +
> +	if (dev->watchdog_ops->start == NULL ||
> +	    dev->watchdog_ops->stop == NULL ||
> +	    dev->watchdog_ops->keepalive == NULL)

Some watchdogs have no stop method so you need to allow for that (it
means your device is always going to close 'nowayout' style).

> +	if (dev->watchdog_ops->set_heartbeat) {
> +		dev->options |= WDIOF_SETTIMEOUT;
> +	} else {
> +		dev->options &= ~WDIOF_SETTIMEOUT;
> +	}

Should have been done by the driver anyway - so this is a WARN check
really for debug.

> +static int watchdog_ioctl(struct inode *inode, struct file *file,
> +				unsigned int cmd, unsigned long arg)
> +{

This ioctl code is racy


> +		if (new_options & WDIOS_DISABLECARD) {
> +			/* only try to stop the watchdog if it's allready running */
> +			if (watchdogdev->watchdog_state == WATCHDOG_STARTED) {
> +				err =  watchdogdev->watchdog_ops->stop(watchdogdev);
> +				if (err == 0) {
> +					watchdogdev->watchdog_state = WATCHDOG_STOPPED;
> +				} else {
> +					printk(KERN_CRIT PFX "WDIOS_DISABLECARD not successfull! (err=%d)",
> +						err);
> +					return -EFAULT;
> +				}
> +			}
> +		}
> +

Consider two of these happening at once

> +	/* only open if we have a valid watchdog device */
> +	if (!watchdogdev ||
> +	    !watchdogdev->watchdog_ops ||
> +	    !watchdogdev->watchdog_ops->start ||
> +	    !watchdogdev->watchdog_ops->stop ||
> +	    !watchdogdev->watchdog_ops->keepalive)
> +		return -EBUSY;

Races register - plus you don't need to check these cases

Also there is a problem with module locking as you don't lock down the
driver module as your fops are owned by the watchdog_dev.

I'd actually been thinking along the same lines but not paid attention
to your tree (was a bit busy without poking watchdog). 

The patch below is actually quite similar in parts to yours except 

- It handles the temperature device
- You pass it the ident and other structs
- It handles stop not being supported (and stop/start fails)
- It does all the reboot, nowayout and module locking and housekeeping
- I've used static objects for most things so they can be initialised
  by the compiler making more of the code "table filling".

The API is actually pretty similar so I think we agree on most parts but
it might be worth working out which are the best bits of each
implementation and putting together something nicer still:

Current patch (& example conversions) below. I'm still debating whether
the watchdog core should implement its own mutex locking for the drivers
so that only special case users (eg those with IRQ handlers) need to do
their own private locking. That would further reduce mistakes by authors.


 drivers/watchdog/Kconfig        |   15 -
 drivers/watchdog/Makefile       |    8 -
 drivers/watchdog/alim1535_wdt.c |  289 ++++---------------------
 drivers/watchdog/alim7101_wdt.c |  218 +++----------------
 drivers/watchdog/softdog.c      |  211 ++++--------------
 drivers/watchdog/watchdog.c     |  296 ++++++++++++++++++++++++++
 drivers/watchdog/watchdog.h     |   35 +++
 drivers/watchdog/wdt.c          |  447 ++++++++-------------------------------
 8 files changed, 556 insertions(+), 963 deletions(-)
 create mode 100644 drivers/watchdog/watchdog.c
 create mode 100644 drivers/watchdog/watchdog.h


diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 254d115..b592ede 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -828,21 +828,6 @@ config WDT
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
index f3fb170..1a9f2b7 100644
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
@@ -57,8 +57,8 @@ obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
-obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
-obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
+obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o softdog.o
+obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o softdog.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
@@ -123,4 +123,4 @@ obj-$(CONFIG_SH_WDT) += shwdt.o
 # XTENSA Architecture
 
 # Architecture Independant
-obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o watchdog.o
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 88760cb..b5bab8b 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -22,13 +22,13 @@
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
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(nowayout,
  *	configuration set.
  */
 
-static void ali_start(void)
+static int ali_start(struct watchdog *w)
 {
 	u32 val;
 
@@ -61,10 +61,16 @@ static void ali_start(void)
 
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
@@ -73,7 +79,7 @@ static void ali_start(void)
  *	Stop the ALi watchdog countdown
  */
 
-static void ali_stop(void)
+static int ali_stop(struct watchdog *w)
 {
 	u32 val;
 
@@ -81,21 +87,11 @@ static void ali_stop(void)
 
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
@@ -105,193 +101,45 @@ static void ali_keepalive(void)
  *	Computes the timeout values needed
  */
 
-static int ali_settimer(int t)
+static int ali_settimer(struct watchdog *w, int t)
 {
 	if (t < 0)
 		return -EINVAL;
 	else if (t < 60)
-		ali_timeout_bits = t|(1<<6);
+		ali_timeout_bits = t|(1 << 6);
 	else if (t < 3600)
-		ali_timeout_bits = (t/60)|(1<<7);
+		ali_timeout_bits = (t/60)|(1 << 7);
 	else if (t < 18000)
-		ali_timeout_bits = (t/300)|(1<<6)|(1<<7);
+		ali_timeout_bits = (t/300)|(1 << 6)|(1 << 7);
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
-				if (get_user(c, data+i))
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
-	case WDIOC_KEEPALIVE:
-		ali_keepalive();
-		return 0;
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
@@ -349,9 +197,9 @@ static int __init ali_find_watchdog(void)
 	/* Timer bits */
 	wdog &= ~0x3F;
 	/* Issued events */
-	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));
+	wdog &= ~((1 << 27)|(1 << 26)|(1 << 25)|(1 << 24));
 	/* No monitor bits */
-	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));
+	wdog &= ~((1 << 16)|(1 << 13)|(1 << 12)|(1 << 11)|(1 << 10)|(1 << 9));
 
 	pci_write_config_dword(pdev, 0xCC, wdog);
 
@@ -359,29 +207,6 @@ static int __init ali_find_watchdog(void)
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
@@ -406,31 +231,16 @@ static int __init watchdog_init(void)
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
@@ -441,12 +251,7 @@ unreg_reboot:
 
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
index c495f36..a8259ac 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -36,6 +36,8 @@
 #include <linux/uaccess.h>
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
@@ -163,185 +163,60 @@ static void wdt_startup(void)
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
-				if (get_user(c, buf+ofs))
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
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		return 0;
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
 
-static struct miscdevice wdt_miscdev = {
-	.minor	=	WATCHDOG_MINOR,
-	.name	=	"watchdog",
-	.fops	=	&wdt_fops,
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+						| WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "ALiM7101",
 };
 
+static struct watchdog aliwd = {
+	.name = "ALiM7101",
+	.info = &ident,
+	.ops = &wdt_ops,
+	.owner = THIS_MODULE,
+};
 /*
  *	Notifier for system down
  */
 
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
-};
-
 static void __exit alim7101_wdt_unload(void)
 {
-	wdt_turnoff();
-	/* Deregister */
-	misc_deregister(&wdt_miscdev);
-	unregister_reboot_notifier(&wdt_notifier);
+	watchdog_unregister(&aliwd);
 	pci_dev_put(alim7101_pmu);
 }
 
@@ -389,30 +264,15 @@ static int __init alim7101_wdt_init(void)
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
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index bb3c75e..d1113a3 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -49,6 +49,8 @@
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
 
+#include "watchdog.h"
+
 #define PFX "SoftDog: "
 
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
@@ -64,14 +66,11 @@ MODULE_PARM_DESC(nowayout,
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
@@ -81,9 +80,6 @@ static void watchdog_fire(unsigned long);
 
 static struct timer_list watchdog_ticktock =
 		TIMER_INITIALIZER(watchdog_fire, 0, 0);
-static unsigned long driver_open, orphan_timer;
-static char expect_close;
-
 
 /*
  *	If the timer expires..
@@ -91,7 +87,7 @@ static char expect_close;
 
 static void watchdog_fire(unsigned long data)
 {
-	if (test_and_clear_bit(0, &orphan_timer))
+	if (test_and_clear_bit(WDOG_ORPHAN, &softdog.status))
 		module_put(THIS_MODULE);
 
 	if (soft_noboot)
@@ -107,161 +103,52 @@ static void watchdog_fire(unsigned long data)
  *	Softdog operations
  */
 
-static int softdog_keepalive(void)
+static void softdog_keepalive(struct watchdog *w)
 {
-	mod_timer(&watchdog_ticktock, jiffies+(soft_margin*HZ));
-	return 0;
+	mod_timer(&watchdog_ticktock, jiffies + (w->timeout*HZ));
 }
 
-static int softdog_stop(void)
+static int softdog_start(struct watchdog *w)
 {
-	del_timer(&watchdog_ticktock);
+	mod_timer(&watchdog_ticktock, jiffies + (w->timeout*HZ));
 	return 0;
 }
 
-static int softdog_set_heartbeat(int t)
+static int softdog_stop(struct watchdog *w)
 {
-	if ((t < 0x0001) || (t > 0xFFFF))
-		return -EINVAL;
-
-	soft_margin = t;
+	del_timer(&watchdog_ticktock);
 	return 0;
 }
 
-/*
- *	/dev/watchdog handling
- */
-
-static int softdog_open(struct inode *inode, struct file *file)
+static int softdog_set_heartbeat(struct watchdog *w, int t)
 {
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
+	if (t < 0x0001 || t > 0xFFFF)
+		return -EINVAL;
 
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
+	w->timeout = t;
 	return 0;
 }
 
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
-	default:
-		return -ENOTTY;
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
+	.ping	=	softdog_keepalive,
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
@@ -272,38 +159,22 @@ static int __init watchdog_init(void)
 
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
diff --git a/drivers/watchdog/watchdog.c b/drivers/watchdog/watchdog.c
new file mode 100644
index 0000000..4f89396
--- /dev/null
+++ b/drivers/watchdog/watchdog.c
@@ -0,0 +1,296 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include "watchdog.h"
+
+/* For now we track a single watchdog */
+static struct watchdog *watchdog;
+static unsigned long watchdog_busy;
+
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	struct watchdog *w = file->private_data;
+	int val = 0;
+	int r;
+
+	if (w->ops->ioctl) {
+		r = w->ops->ioctl(w, cmd, arg);
+		if (r != -ENOIOCTLCMD)
+			return r;
+	}
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, w->info,
+					sizeof(struct watchdog_info));
+	case WDIOC_GETSTATUS:
+		if (w->ops->status)
+			val = w->ops->status(w);		
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(w->boot_status, p);
+	case WDIOC_KEEPALIVE:
+		w->ops->ping(w);
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (w->ops->set_timeout == NULL)
+			return -EOPNOTSUPP;
+		if (get_user(val, p))
+			return -EFAULT;
+		r = w->ops->set_timeout(w, val);
+		if (r < 0)
+			return r;
+		w->timeout = val;
+		w->ops->ping(w);
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		if (w->timeout)
+			return put_user(w->timeout, p);
+		return -EOPNOTSUPP;
+	case WDIOC_SETOPTIONS:
+		if (get_user(val, p))
+			return -EFAULT;
+		if (val & WDIOS_DISABLECARD) {
+			if (w->ops->stop == NULL)
+				return -EOPNOTSUPP;
+			r = w->ops->stop(w);
+			if (r < 0)
+				return r;
+		}
+		if (val & WDIOS_ENABLECARD) {
+			r = w->ops->start(w);
+			if (r < 0)
+				return r;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int r = -EBUSY;
+	/* We will need to rework this when we support multiple dogs */
+	struct watchdog *w = watchdog;
+
+	if (!try_module_get(w->owner))
+		return r;
+	if (test_and_set_bit(WDOG_OPEN, &w->status))
+		goto out;
+	file->private_data = w;
+	
+	r = w->ops->start(w);
+	if (r < 0)
+		goto out_bit;
+
+	clear_bit(WDOG_EXPECT_RELEASE, &w->status);
+	r = nonseekable_open(inode, file);
+	if (r == 0) {
+		/* We leaked a reference to lock the module in on close
+		   now we can reclaim it as we re-opened before triggering */
+		if (test_and_clear_bit(WDOG_ORPHAN, &w->status))
+			module_put(w->owner);
+		return 0;
+	}
+	if (w->ops->stop)
+		w->ops->stop(w);
+out_bit:
+	clear_bit(WDOG_OPEN, &w->status);
+out:
+	module_put(watchdog->owner);
+	return r;
+}
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	struct watchdog *w = file->private_data;
+	if (test_bit(WDOG_EXPECT_RELEASE, &w->status) &&
+	    !test_bit(WDOG_NO_WAY_OUT, &w->status) &&
+						w->ops->stop != NULL) {
+		if (w->ops->stop(w) == 0) {
+			module_put(watchdog->owner);
+			return 0;
+		}
+	}
+	printk(KERN_CRIT "%s: not stopping watchdog.\n", w->name);
+	set_bit(WDOG_ORPHAN, &w->status);
+	/* Deliberately leak a module reference in this case */
+	return 0;
+}
+
+static int watchdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	struct watchdog *w = file->private_data;
+	size_t i;
+	if (len == 0)	/* Can we see this even ? */
+		return 0;
+
+	clear_bit(WDOG_EXPECT_RELEASE, &w->status);
+	/* scan to see whether or not we got the magic character */
+	for (i = 0; i != len; i++) {
+		char c;
+		if (get_user(c, data+i))
+			return -EFAULT;
+		if (c == 'V')
+			set_bit(WDOG_EXPECT_RELEASE, &w->status);
+	}
+	/* And fire the ping timer */
+	w->ops->ping(w);
+	return len;
+}
+
+static ssize_t watchdog_temp_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ptr)
+{
+	struct watchdog *w = file->private_data;
+	u8 temperature = w->ops->temperature(w);
+	if (copy_to_user(buf, &temperature, 1))
+		return -EFAULT;
+	return 1;
+}
+
+static int watchdog_temp_open(struct inode *inode, struct file *file)
+{
+	int r;
+	file->private_data = watchdog;
+	if (!try_module_get(watchdog->owner))
+		return -EBUSY;
+	r = nonseekable_open(inode, file);
+	if (r < 0)
+		module_put(watchdog->owner);
+	return r;
+}
+
+static int watchdog_temp_release(struct inode *inode, struct file *file)
+{
+	struct watchdog *w = file->private_data;
+	module_put(w->owner);
+	return 0;
+}
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+};
+
+static struct miscdevice watchdog_misc = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &watchdog_fops,
+};
+
+static const struct file_operations temperature_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= watchdog_temp_read,
+	.open		= watchdog_temp_open,
+	.release	= watchdog_temp_release,
+};
+
+static struct miscdevice temperature_misc = {
+	.minor = TEMP_MINOR,
+	.name = "temperature",
+	.fops = &temperature_fops,
+};
+
+int watchdog_register(struct watchdog *w, int nwo)
+{
+	int r;
+
+	if (test_and_set_bit(0, &watchdog_busy)) {
+		printk(KERN_ERR "watchdog: only one watchdog at a time currently supported.\n");
+		return -EBUSY;
+	}
+	
+	watchdog = w;
+	
+	w->status = 0;
+	if (nwo)
+		set_bit(WDOG_NO_WAY_OUT, &w->status);
+
+	if (w->ops->temperature) {
+		r = misc_register(&temperature_misc);
+		if (r < 0) {
+			printk(KERN_ERR
+			 "%s: cannot register miscdev on minor=%d (err=%d)\n",
+						w->name, TEMP_MINOR, r);
+			goto out_clear;
+		}
+	}
+	r = misc_register(&watchdog_misc);
+	if (r == 0)
+		return 0;
+	printk(KERN_ERR	"%s: cannot register miscdev on minor=%d (err=%d)\n",
+						w->name, WATCHDOG_MINOR, r);
+	if (w->ops->temperature)
+		misc_deregister(&temperature_misc);
+out_clear:
+	watchdog = NULL;
+	clear_bit(0, &watchdog_busy);
+	return r;
+}
+EXPORT_SYMBOL_GPL(watchdog_register);
+
+void watchdog_unregister(struct watchdog *w)
+{
+	watchdog = NULL;
+	misc_deregister(&watchdog_misc);
+	if (w->ops->temperature)
+		misc_deregister(&temperature_misc);
+	clear_bit(0, &watchdog_busy);
+}
+EXPORT_SYMBOL_GPL(watchdog_unregister);
+
+/* The notifier will need to change for multiple dogs, but at that point
+   hopefully we have a class and class based power methods anyway */
+
+static int watchdog_notify(struct notifier_block *this, unsigned long code,
+	void *dog)
+{
+	if (watchdog && (code == SYS_DOWN || code == SYS_HALT)) {
+		if (watchdog->ops->reboot)
+			watchdog->ops->reboot(watchdog);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block watchdog_notifier = {
+	.notifier_call = watchdog_notify,
+};
+
+static int __init watchdog_init(void)
+{
+	int r = register_reboot_notifier(&watchdog_notifier);
+	if (r < 0)
+		printk(KERN_ERR "watchdog: unable to register notifier.\n");
+	return r;
+}
+
+static void __devexit watchdog_exit(void)
+{
+	unregister_reboot_notifier(&watchdog_notifier);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
diff --git a/drivers/watchdog/watchdog.h b/drivers/watchdog/watchdog.h
new file mode 100644
index 0000000..0d22eaa
--- /dev/null
+++ b/drivers/watchdog/watchdog.h
@@ -0,0 +1,35 @@
+struct watchdog;
+
+struct watchdog_ops
+{
+	int (*start)(struct watchdog *w);
+	int (*stop)(struct watchdog *w);
+	void (*ping)(struct watchdog *w);
+	int (*status)(struct watchdog *w);
+	int (*temperature)(struct watchdog *w);
+	int (*set_timeout)(struct watchdog *w, int t);
+	int (*reboot)(struct watchdog *w);
+	long (*ioctl)(struct watchdog *w, unsigned int cmd, unsigned long arg);
+};
+
+struct watchdog
+{
+	char *name;
+	const struct watchdog_info *info;
+	const struct watchdog_ops *ops;
+	int timeout;
+	int boot_status;
+	long status;
+#define WDOG_OPEN		0
+#define WDOG_EXPECT_RELEASE	1
+#define WDOG_ORPHAN		2
+#define WDOG_NO_WAY_OUT		3
+	struct module *owner;
+};
+
+
+extern void watchdog_unregister(struct watchdog *w);
+extern int watchdog_register(struct watchdog *w, int nwo);
+
+
+
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 53a6b18..af947b5 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -1,5 +1,5 @@
 /*
- *	Industrial Computer Source WDT500/501 driver
+ *	Industrial Computer Source WDT501 driver
  *
  *	(c) Copyright 1996-1997 Alan Cox <alan@redhat.com>, All Rights Reserved.
  *				http://www.redhat.com
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
@@ -303,267 +306,31 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-
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
-	default:
-		return -ENOTTY;
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
@@ -576,12 +343,8 @@ static struct notifier_block wdt_notifier = {
 
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
 
@@ -597,14 +360,24 @@ static int __init wdt_init(void)
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
@@ -612,59 +385,27 @@ static int __init wdt_init(void)
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

