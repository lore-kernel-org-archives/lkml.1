Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbYESNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbYESNeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbYESNVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760517AbYESNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 42/57] sc1200_wdt: clean up, fix locking and use unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:38 +0100
Message-ID: <20080519130838.31722.49024.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/sc1200wdt.c |  203 ++++++++++++++++++++++++------------------
 1 files changed, 114 insertions(+), 89 deletions(-)


diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 35cddff..7e5c9cc 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -15,14 +15,18 @@
  *
  *	Changelog:
  *	20020220 Zwane Mwaikambo	Code based on datasheet, no hardware.
- *	20020221 Zwane Mwaikambo	Cleanups as suggested by Jeff Garzik and Alan Cox.
+ *	20020221 Zwane Mwaikambo	Cleanups as suggested by Jeff Garzik
+ *					and Alan Cox.
  *	20020222 Zwane Mwaikambo	Added probing.
  *	20020225 Zwane Mwaikambo	Added ISAPNP support.
  *	20020412 Rob Radez		Broke out start/stop functions
- *		 <rob@osinvestor.com>	Return proper status instead of temperature warning
- *					Add WDIOC_GETBOOTSTATUS and WDIOC_SETOPTIONS ioctls
+ *		 <rob@osinvestor.com>	Return proper status instead of
+ *					temperature warning
+ *					Add WDIOC_GETBOOTSTATUS and
+ *					WDIOC_SETOPTIONS ioctls
  *					Fix CONFIG_WATCHDOG_NOWAYOUT
- *	20020530 Joel Becker		Add Matt Domsch's nowayout module option
+ *	20020530 Joel Becker		Add Matt Domsch's nowayout module
+ *					option
  *	20030116 Adam Belay		Updated to the latest pnp code
  *
  */
@@ -39,9 +43,8 @@
 #include <linux/pnp.h>
 #include <linux/fs.h>
 #include <linux/semaphore.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #define SC1200_MODULE_VER	"build 20020303"
 #define SC1200_MODULE_NAME	"sc1200wdt"
@@ -72,7 +75,7 @@ static char banner[] __initdata = KERN_INFO PFX SC1200_MODULE_VER;
 static int timeout = 1;
 static int io = -1;
 static int io_len = 2;		/* for non plug and play */
-static struct semaphore open_sem;
+static unsigned long open_flag;
 static char expect_close;
 static DEFINE_SPINLOCK(sc1200wdt_lock);	/* io port access serialisation */
 
@@ -81,7 +84,8 @@ static int isapnp = 1;
 static struct pnp_dev *wdt_dev;
 
 module_param(isapnp, int, 0);
-MODULE_PARM_DESC(isapnp, "When set to 0 driver ISA PnP support will be disabled");
+MODULE_PARM_DESC(isapnp,
+	"When set to 0 driver ISA PnP support will be disabled");
 #endif
 
 module_param(io, int, 0);
@@ -91,26 +95,40 @@ MODULE_PARM_DESC(timeout, "range is 0-255 minutes, default is 1");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 
 /* Read from Data Register */
-static inline void sc1200wdt_read_data(unsigned char index, unsigned char *data)
+static inline void __sc1200wdt_read_data(unsigned char index,
+						unsigned char *data)
 {
-	spin_lock(&sc1200wdt_lock);
 	outb_p(index, PMIR);
 	*data = inb(PMDR);
-	spin_unlock(&sc1200wdt_lock);
 }
 
+static void sc1200wdt_read_data(unsigned char index, unsigned char *data)
+{
+	spin_lock(&sc1200wdt_lock);
+	__sc1200wdt_read_data(index, data);
+	spin_unlock(&sc1200wdt_lock);
+}
 
 /* Write to Data Register */
-static inline void sc1200wdt_write_data(unsigned char index, unsigned char data)
+static inline void __sc1200wdt_write_data(unsigned char index,
+						unsigned char data)
 {
-	spin_lock(&sc1200wdt_lock);
 	outb_p(index, PMIR);
 	outb(data, PMDR);
+}
+
+static inline void sc1200wdt_write_data(unsigned char index,
+						unsigned char data)
+{
+	spin_lock(&sc1200wdt_lock);
+	__sc1200wdt_write_data(index, data);
 	spin_unlock(&sc1200wdt_lock);
 }
 
@@ -118,13 +136,16 @@ static inline void sc1200wdt_write_data(unsigned char index, unsigned char data)
 static void sc1200wdt_start(void)
 {
 	unsigned char reg;
+	spin_lock(&sc1200wdt_lock);
 
-	sc1200wdt_read_data(WDCF, &reg);
+	__sc1200wdt_read_data(WDCF, &reg);
 	/* assert WDO when any of the following interrupts are triggered too */
 	reg |= (KBC_IRQ | MSE_IRQ | UART1_IRQ | UART2_IRQ);
-	sc1200wdt_write_data(WDCF, reg);
+	__sc1200wdt_write_data(WDCF, reg);
 	/* set the timeout and get the ball rolling */
-	sc1200wdt_write_data(WDTO, timeout);
+	__sc1200wdt_write_data(WDTO, timeout);
+
+	spin_unlock(&sc1200wdt_lock);
 }
 
 
@@ -144,14 +165,15 @@ static inline int sc1200wdt_status(void)
 	 * KEEPALIVEPING which is a bit of a kludge because there's nothing
 	 * else for enabled/disabled status
 	 */
-	return (ret & 0x01) ? 0 : WDIOF_KEEPALIVEPING;	/* bits 1 - 7 are undefined */
+	return (ret & 0x01) ? 0 : WDIOF_KEEPALIVEPING;
+	/* bits 1 - 7 are undefined */
 }
 
 
 static int sc1200wdt_open(struct inode *inode, struct file *file)
 {
 	/* allow one at a time */
-	if (down_trylock(&open_sem))
+	if (test_and_set_bit(0, &open_flag))
 		return -EBUSY;
 
 	if (timeout > MAX_TIMEOUT)
@@ -164,71 +186,71 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 }
 
 
-static int sc1200wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 0,
 		.identity = "PC87307/PC97307",
 	};
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &ident, sizeof ident))
-				return -EFAULT;
-			return 0;
 
-		case WDIOC_GETSTATUS:
-			return put_user(sc1200wdt_status(), p);
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof ident))
+			return -EFAULT;
+		return 0;
 
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
+	case WDIOC_GETSTATUS:
+		return put_user(sc1200wdt_status(), p);
 
-		case WDIOC_KEEPALIVE:
-			sc1200wdt_write_data(WDTO, timeout);
-			return 0;
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
 
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			/* the API states this is given in secs */
-			new_timeout /= 60;
-			if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-				return -EINVAL;
-
-			timeout = new_timeout;
-			sc1200wdt_write_data(WDTO, timeout);
-			/* fall through and return the new timeout */
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout * 60, p);
+	case WDIOC_KEEPALIVE:
+		sc1200wdt_write_data(WDTO, timeout);
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		sc1200wdt_write_data(WDTO, timeout);
+		/* fall through and return the new timeout */
 
-		case WDIOC_SETOPTIONS:
-		{
-			int options, retval = -EINVAL;
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout * 60, p);
 
-			if (get_user(options, p))
-				return -EFAULT;
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
 
-			if (options & WDIOS_DISABLECARD) {
-				sc1200wdt_stop();
-				retval = 0;
-			}
+		if (get_user(options, p))
+			return -EFAULT;
 
-			if (options & WDIOS_ENABLECARD) {
-				sc1200wdt_start();
-				retval = 0;
-			}
+		if (options & WDIOS_DISABLECARD) {
+			sc1200wdt_stop();
+			retval = 0;
+		}
 
-			return retval;
+		if (options & WDIOS_ENABLECARD) {
+			sc1200wdt_start();
+			retval = 0;
 		}
+
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -240,16 +262,18 @@ static int sc1200wdt_release(struct inode *inode, struct file *file)
 		printk(KERN_INFO PFX "Watchdog disabled\n");
 	} else {
 		sc1200wdt_write_data(WDTO, timeout);
-		printk(KERN_CRIT PFX "Unexpected close!, timeout = %d min(s)\n", timeout);
+		printk(KERN_CRIT PFX
+			"Unexpected close!, timeout = %d min(s)\n", timeout);
 	}
-	up(&open_sem);
+	clear_bit(0, &open_flag);
 	expect_close = 0;
 
 	return 0;
 }
 
 
-static ssize_t sc1200wdt_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t sc1200wdt_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -275,7 +299,8 @@ static ssize_t sc1200wdt_write(struct file *file, const char __user *data, size_
 }
 
 
-static int sc1200wdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int sc1200wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		sc1200wdt_stop();
@@ -284,23 +309,20 @@ static int sc1200wdt_notify_sys(struct notifier_block *this, unsigned long code,
 }
 
 
-static struct notifier_block sc1200wdt_notifier =
-{
+static struct notifier_block sc1200wdt_notifier = {
 	.notifier_call =	sc1200wdt_notify_sys,
 };
 
-static const struct file_operations sc1200wdt_fops =
-{
+static const struct file_operations sc1200wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sc1200wdt_write,
-	.ioctl		= sc1200wdt_ioctl,
+	.unlocked_ioctl = sc1200wdt_ioctl,
 	.open		= sc1200wdt_open,
 	.release	= sc1200wdt_release,
 };
 
-static struct miscdevice sc1200wdt_miscdev =
-{
+static struct miscdevice sc1200wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sc1200wdt_fops,
@@ -312,14 +334,14 @@ static int __init sc1200wdt_probe(void)
 	/* The probe works by reading the PMC3 register's default value of 0x0e
 	 * there is one caveat, if the device disables the parallel port or any
 	 * of the UARTs we won't be able to detect it.
-	 * Nb. This could be done with accuracy by reading the SID registers, but
-	 * we don't have access to those io regions.
+	 * NB. This could be done with accuracy by reading the SID registers,
+	 * but we don't have access to those io regions.
 	 */
 
 	unsigned char reg;
 
 	sc1200wdt_read_data(PMC3, &reg);
-	reg &= 0x0f;				/* we don't want the UART busy bits */
+	reg &= 0x0f;		/* we don't want the UART busy bits */
 	return (reg == 0x0e) ? 0 : -ENODEV;
 }
 
@@ -332,7 +354,8 @@ static struct pnp_device_id scl200wdt_pnp_devices[] = {
 	{.id = ""},
 };
 
-static int scl200wdt_pnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id)
+static int scl200wdt_pnp_probe(struct pnp_dev *dev,
+					const struct pnp_device_id *dev_id)
 {
 	/* this driver only supports one card at a time */
 	if (wdt_dev || !isapnp)
@@ -347,13 +370,14 @@ static int scl200wdt_pnp_probe(struct pnp_dev * dev, const struct pnp_device_id
 		return -EBUSY;
 	}
 
-	printk(KERN_INFO "scl200wdt: PnP device found at io port %#x/%d\n", io, io_len);
+	printk(KERN_INFO "scl200wdt: PnP device found at io port %#x/%d\n",
+								io, io_len);
 	return 0;
 }
 
-static void scl200wdt_pnp_remove(struct pnp_dev * dev)
+static void scl200wdt_pnp_remove(struct pnp_dev *dev)
 {
-	if (wdt_dev){
+	if (wdt_dev) {
 		release_region(io, io_len);
 		wdt_dev = NULL;
 	}
@@ -375,8 +399,6 @@ static int __init sc1200wdt_init(void)
 
 	printk("%s\n", banner);
 
-	sema_init(&open_sem, 1);
-
 #if defined CONFIG_PNP
 	if (isapnp) {
 		ret = pnp_register_driver(&scl200wdt_pnp_driver);
@@ -410,13 +432,16 @@ static int __init sc1200wdt_init(void)
 
 	ret = register_reboot_notifier(&sc1200wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "Unable to register reboot notifier err = %d\n", ret);
+		printk(KERN_ERR PFX
+			"Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&sc1200wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "Unable to register miscdev on minor %d\n", WATCHDOG_MINOR);
+		printk(KERN_ERR PFX
+			"Unable to register miscdev on minor %d\n",
+							WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
@@ -446,7 +471,7 @@ static void __exit sc1200wdt_exit(void)
 	unregister_reboot_notifier(&sc1200wdt_notifier);
 
 #if defined CONFIG_PNP
-	if(isapnp)
+	if (isapnp)
 		pnp_unregister_driver(&scl200wdt_pnp_driver);
 	else
 #endif

