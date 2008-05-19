Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbYESNcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbYESNcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761015AbYESNUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45972 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760999AbYESNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 44/57] scx200_wdt: clean up and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:49 +0100
Message-ID: <20080519130849.31722.38282.stgit@core>
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

 drivers/watchdog/sc520_wdt.c  |    4 +--
 drivers/watchdog/scx200_wdt.c |   59 +++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 31 deletions(-)


diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 525555a..01de239 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -279,7 +279,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -345,7 +345,7 @@ static const struct file_operations wdt_fops = {
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index d55882b..7c1de94 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -27,9 +27,8 @@
 #include <linux/fs.h>
 #include <linux/ioport.h>
 #include <linux/scx200.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define NAME "scx200_wdt"
 
@@ -47,8 +46,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static u16 wdto_restart;
-static struct semaphore open_semaphore;
 static char expect_close;
+static unsigned long open_lock;
+static DEFINE_SPINLOCK(scx_lock);
 
 /* Bits of the WDCNFG register */
 #define W_ENABLE 0x00fa		/* Enable watchdog */
@@ -59,7 +59,9 @@ static char expect_close;
 
 static void scx200_wdt_ping(void)
 {
+	spin_lock(&scx_lock);
 	outw(wdto_restart, scx200_cb_base + SCx200_WDT_WDTO);
+	spin_unlock(&scx_lock);
 }
 
 static void scx200_wdt_update_margin(void)
@@ -73,9 +75,11 @@ static void scx200_wdt_enable(void)
 	printk(KERN_DEBUG NAME ": enabling watchdog timer, wdto_restart = %d\n",
 	       wdto_restart);
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_ENABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 
 	scx200_wdt_ping();
 }
@@ -84,15 +88,17 @@ static void scx200_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_DISABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 }
 
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (test_and_set_bit(0, &open_lock))
 		return -EBUSY;
 	scx200_wdt_enable();
 
@@ -101,13 +107,12 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
-	if (expect_close != 42) {
+	if (expect_close != 42)
 		printk(KERN_WARNING NAME ": watchdog device closed unexpectedly, will not disable the watchdog timer\n");
-	} else if (!nowayout) {
+	else if (!nowayout)
 		scx200_wdt_disable();
-	}
 	expect_close = 0;
-	up(&open_semaphore);
+	clear_bit(0, &open_lock);
 
 	return 0;
 }
@@ -122,8 +127,7 @@ static int scx200_wdt_notify_sys(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block scx200_wdt_notifier =
-{
+static struct notifier_block scx200_wdt_notifier = {
 	.notifier_call = scx200_wdt_notify_sys,
 };
 
@@ -131,8 +135,7 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 				     size_t len, loff_t *ppos)
 {
 	/* check for a magic close character */
-	if (len)
-	{
+	if (len) {
 		size_t i;
 
 		scx200_wdt_ping();
@@ -152,15 +155,15 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
-static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "NatSemi SCx200 Watchdog",
 		.firmware_version = 1,
-		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING),
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	};
 	int new_margin;
 
@@ -168,7 +171,7 @@ static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
 	default:
 		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
-		if(copy_to_user(argp, &ident, sizeof(ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
@@ -195,18 +198,18 @@ static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
 }
 
 static const struct file_operations scx200_wdt_fops = {
-	.owner	 = THIS_MODULE,
-	.llseek	 = no_llseek,
-	.write   = scx200_wdt_write,
-	.ioctl   = scx200_wdt_ioctl,
-	.open    = scx200_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = scx200_wdt_write,
+	.unlocked_ioctl = scx200_wdt_ioctl,
+	.open = scx200_wdt_open,
 	.release = scx200_wdt_release,
 };
 
 static struct miscdevice scx200_wdt_miscdev = {
 	.minor = WATCHDOG_MINOR,
-	.name  = "watchdog",
-	.fops  = &scx200_wdt_fops,
+	.name = "watchdog",
+	.fops = &scx200_wdt_fops,
 };
 
 static int __init scx200_wdt_init(void)
@@ -229,8 +232,6 @@ static int __init scx200_wdt_init(void)
 	scx200_wdt_update_margin();
 	scx200_wdt_disable();
 
-	sema_init(&open_semaphore, 1);
-
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier");
@@ -263,7 +264,7 @@ module_exit(scx200_wdt_cleanup);
 
 /*
     Local variables:
-        compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
-        c-basic-offset: 8
+	compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
+	c-basic-offset: 8
     End:
 */

