Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYESNer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYESNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbYESNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761341AbYESNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 50/57] w83697hf_wdt: cleanup,
	coding style and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:23 +0100
Message-ID: <20080519130923.31722.82931.stgit@core>
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

 drivers/watchdog/w83697hf_wdt.c |  141 +++++++++++++++++++--------------------
 1 files changed, 69 insertions(+), 72 deletions(-)


diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index c622a0e..cb14644 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -36,9 +36,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
@@ -52,33 +52,37 @@ static DEFINE_SPINLOCK(io_lock);
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2e;
 module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)");
+MODULE_PARM_DESC(wdt_io,
+		"w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=255, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
  */
 
-#define W83697HF_EFER (wdt_io+0)	/* Extended Function Enable Register */
-#define W83697HF_EFIR (wdt_io+0)	/* Extended Function Index Register (same as EFER) */
-#define W83697HF_EFDR (wdt_io+1)	/* Extended Function Data Register */
+#define W83697HF_EFER (wdt_io + 0)  /* Extended Function Enable Register */
+#define W83697HF_EFIR (wdt_io + 0)  /* Extended Function Index Register
+							(same as EFER) */
+#define W83697HF_EFDR (wdt_io + 1)  /* Extended Function Data Register */
 
-static inline void
-w83697hf_unlock(void)
+static inline void w83697hf_unlock(void)
 {
 	outb_p(0x87, W83697HF_EFER);	/* Enter extended function mode */
 	outb_p(0x87, W83697HF_EFER);	/* Again according to manual */
 }
 
-static inline void
-w83697hf_lock(void)
+static inline void w83697hf_lock(void)
 {
 	outb_p(0xAA, W83697HF_EFER);	/* Leave extended function mode */
 }
@@ -88,41 +92,36 @@ w83697hf_lock(void)
  *	w83697hf_write_timeout() must be called with the device unlocked.
  */
 
-static unsigned char
-w83697hf_get_reg(unsigned char reg)
+static unsigned char w83697hf_get_reg(unsigned char reg)
 {
 	outb_p(reg, W83697HF_EFIR);
 	return inb_p(W83697HF_EFDR);
 }
 
-static void
-w83697hf_set_reg(unsigned char reg, unsigned char data)
+static void w83697hf_set_reg(unsigned char reg, unsigned char data)
 {
 	outb_p(reg, W83697HF_EFIR);
 	outb_p(data, W83697HF_EFDR);
 }
 
-static void
-w83697hf_write_timeout(int timeout)
+static void w83697hf_write_timeout(int timeout)
 {
-	w83697hf_set_reg(0xF4, timeout);	/* Write Timeout counter to CRF4 */
+	/* Write Timeout counter to CRF4 */
+	w83697hf_set_reg(0xF4, timeout);
 }
 
-static void
-w83697hf_select_wdt(void)
+static void w83697hf_select_wdt(void)
 {
 	w83697hf_unlock();
 	w83697hf_set_reg(0x07, 0x08);	/* Switch to logic device 8 (GPIO2) */
 }
 
-static inline void
-w83697hf_deselect_wdt(void)
+static inline void w83697hf_deselect_wdt(void)
 {
 	w83697hf_lock();
 }
 
-static void
-w83697hf_init(void)
+static void w83697hf_init(void)
 {
 	unsigned char bbuf;
 
@@ -131,7 +130,9 @@ w83697hf_init(void)
 	bbuf = w83697hf_get_reg(0x29);
 	bbuf &= ~0x60;
 	bbuf |= 0x20;
-	w83697hf_set_reg(0x29, bbuf);	/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+
+	/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+	w83697hf_set_reg(0x29, bbuf);
 
 	bbuf = w83697hf_get_reg(0xF3);
 	bbuf &= ~0x04;
@@ -140,8 +141,7 @@ w83697hf_init(void)
 	w83697hf_deselect_wdt();
 }
 
-static int
-wdt_ping(void)
+static int wdt_ping(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -153,8 +153,7 @@ wdt_ping(void)
 	return 0;
 }
 
-static int
-wdt_enable(void)
+static int wdt_enable(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -167,8 +166,7 @@ wdt_enable(void)
 	return 0;
 }
 
-static int
-wdt_disable(void)
+static int wdt_disable(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -181,18 +179,17 @@ wdt_disable(void)
 	return 0;
 }
 
-static int
-wdt_set_heartbeat(int t)
+static int wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 255))
+	if (t < 1 || t > 255)
 		return -EINVAL;
 
 	timeout = t;
 	return 0;
 }
 
-static ssize_t
-wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -213,15 +210,14 @@ wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	return count;
 }
 
-static int
-wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83697HF WDT",
 	};
@@ -277,8 +273,7 @@ wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return 0;
 }
 
-static int
-wdt_open(struct inode *inode, struct file *file)
+static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -290,13 +285,13 @@ wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-wdt_close(struct inode *inode, struct file *file)
+static int wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wdt_disable();
-	} else {
-		printk (KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -308,8 +303,7 @@ wdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int
-wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT) {
@@ -327,7 +321,7 @@ static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_close,
 };
@@ -347,36 +341,38 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
-static int
-w83697hf_check_wdt(void)
+static int w83697hf_check_wdt(void)
 {
 	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%x already in use\n", wdt_io);
+		printk(KERN_ERR PFX
+			"I/O address 0x%x already in use\n", wdt_io);
 		return -EIO;
 	}
 
-	printk (KERN_DEBUG PFX "Looking for watchdog at address 0x%x\n", wdt_io);
+	printk(KERN_DEBUG PFX
+			"Looking for watchdog at address 0x%x\n", wdt_io);
 	w83697hf_unlock();
 	if (w83697hf_get_reg(0x20) == 0x60) {
-		printk (KERN_INFO PFX "watchdog found at address 0x%x\n", wdt_io);
+		printk(KERN_INFO PFX
+			"watchdog found at address 0x%x\n", wdt_io);
 		w83697hf_lock();
 		return 0;
 	}
-	w83697hf_lock();	/* Reprotect in case it was a compatible device */
+	/* Reprotect in case it was a compatible device */
+	w83697hf_lock();
 
-	printk (KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
+	printk(KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
 	release_region(wdt_io, 2);
 	return -EIO;
 }
 
 static int w83697hf_ioports[] = { 0x2e, 0x4e, 0x00 };
 
-static int __init
-wdt_init(void)
+static int __init wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	printk (KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
+	printk(KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
 		/* we will autodetect the W83697HF/HG watchdog */
@@ -391,7 +387,7 @@ wdt_init(void)
 	}
 
 	if (!found) {
-		printk (KERN_ERR PFX "No W83697HF/HG could be found\n");
+		printk(KERN_ERR PFX "No W83697HF/HG could be found\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -401,25 +397,27 @@ wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=255, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		     "timeout value must be 1 <= timeout <= 255, using %d\n",
+							WATCHDOG_TIMEOUT);
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
@@ -431,8 +429,7 @@ unreg_regions:
 	goto out;
 }
 
-static void __exit
-wdt_exit(void)
+static void __exit wdt_exit(void)
 {
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);

