Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbYESN0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbYESN0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbYESNTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45886 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760398AbYESNTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/57] mpc watchdog: clean up and locking
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:09 +0100
Message-ID: <20080519130709.31722.49379.stgit@core>
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

 drivers/watchdog/mpc5200_wdt.c |   20 ++++++++++++--------
 drivers/watchdog/mpc83xx_wdt.c |   19 ++++++++++---------
 drivers/watchdog/mpc8xx_wdt.c  |   37 +++++++++++++++++++------------------
 3 files changed, 41 insertions(+), 35 deletions(-)


diff --git a/drivers/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
index 80a91d4..ce1811d 100644
--- a/drivers/watchdog/mpc5200_wdt.c
+++ b/drivers/watchdog/mpc5200_wdt.c
@@ -4,8 +4,8 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <asm/of_platform.h>
-#include <asm/uaccess.h>
+#include <linux/of_platform.h>
+#include <linux/uaccess.h>
 #include <asm/mpc52xx.h>
 
 
@@ -57,7 +57,8 @@ static int mpc5200_wdt_start(struct mpc5200_wdt *wdt)
 	/* set timeout, with maximum prescaler */
 	out_be32(&wdt->regs->count, 0x0 | wdt->count);
 	/* enable watchdog */
-	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT | GPT_MODE_MS_TIMER);
+	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT |
+						GPT_MODE_MS_TIMER);
 	spin_unlock(&wdt->io_lock);
 
 	return 0;
@@ -66,7 +67,8 @@ static int mpc5200_wdt_ping(struct mpc5200_wdt *wdt)
 {
 	spin_lock(&wdt->io_lock);
 	/* writing A5 to OCPW resets the watchdog */
-	out_be32(&wdt->regs->mode, 0xA5000000 | (0xffffff & in_be32(&wdt->regs->mode)));
+	out_be32(&wdt->regs->mode, 0xA5000000 |
+				(0xffffff & in_be32(&wdt->regs->mode)));
 	spin_unlock(&wdt->io_lock);
 	return 0;
 }
@@ -92,8 +94,8 @@ static struct watchdog_info mpc5200_wdt_info = {
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "mpc5200 watchdog on GPT0",
 };
-static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long mpc5200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpc5200_wdt *wdt = file->private_data;
 	int __user *data = (int __user *)arg;
@@ -103,7 +105,7 @@ static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = copy_to_user(data, &mpc5200_wdt_info,
-			sizeof(mpc5200_wdt_info));
+						sizeof(mpc5200_wdt_info));
 		if (ret)
 			ret = -EFAULT;
 		break;
@@ -135,6 +137,7 @@ static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
 	}
 	return ret;
 }
+
 static int mpc5200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
@@ -167,7 +170,8 @@ static const struct file_operations mpc5200_wdt_fops = {
 };
 
 /* module operations */
-static int mpc5200_wdt_probe(struct of_device *op, const struct of_device_id *match)
+static int mpc5200_wdt_probe(struct of_device *op,
+					const struct of_device_id *match)
 {
 	struct mpc5200_wdt *wdt;
 	int err;
diff --git a/drivers/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
index b16c5cd..109eea0 100644
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ b/drivers/watchdog/mpc83xx_wdt.c
@@ -22,8 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 struct mpc83xx_wdt {
 	__be32 res0;
@@ -42,11 +42,13 @@ static struct mpc83xx_wdt __iomem *wd_base;
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
 
 static int reset = 1;
 module_param(reset, bool, 0);
-MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
+MODULE_PARM_DESC(reset,
+	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
 
 /*
  * We always prescale, but if someone really doesn't want to they can set this
@@ -105,8 +107,8 @@ static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long mpc83xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -136,7 +138,7 @@ static const struct file_operations mpc83xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mpc83xx_wdt_write,
-	.ioctl		= mpc83xx_wdt_ioctl,
+	.unlocked_ioctl	= mpc83xx_wdt_ioctl,
 	.open		= mpc83xx_wdt_open,
 	.release	= mpc83xx_wdt_release,
 };
@@ -161,8 +163,7 @@ static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
 		goto err_out;
 	}
 
-	wd_base = ioremap(r->start, sizeof (struct mpc83xx_wdt));
-
+	wd_base = ioremap(r->start, sizeof(struct mpc83xx_wdt));
 	if (wd_base == NULL) {
 		ret = -ENOMEM;
 		goto err_out;
diff --git a/drivers/watchdog/mpc8xx_wdt.c b/drivers/watchdog/mpc8xx_wdt.c
index 85b5734..1336425 100644
--- a/drivers/watchdog/mpc8xx_wdt.c
+++ b/drivers/watchdog/mpc8xx_wdt.c
@@ -16,36 +16,35 @@
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <asm/8xx_immap.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <syslib/m8xx_wdt.h>
 
 static unsigned long wdt_opened;
 static int wdt_status;
+static spinlock_t wdt_lock;
 
 static void mpc8xx_wdt_handler_disable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_stop_timer();
 	else
 		out_be32(piscr, in_be32(piscr) & ~(PISCR_PIE | PISCR_PTE));
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler deactivated\n");
 }
 
 static void mpc8xx_wdt_handler_enable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_install_timer();
 	else
 		out_be32(piscr, in_be32(piscr) | PISCR_PIE | PISCR_PTE);
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler activated\n");
 }
 
@@ -53,37 +52,34 @@ static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_opened))
 		return -EBUSY;
-
 	m8xx_wdt_reset();
 	mpc8xx_wdt_handler_disable();
-
 	return nonseekable_open(inode, file);
 }
 
 static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
 {
 	m8xx_wdt_reset();
-
 #if !defined(CONFIG_WATCHDOG_NOWAYOUT)
 	mpc8xx_wdt_handler_enable();
 #endif
-
 	clear_bit(0, &wdt_opened);
-
 	return 0;
 }
 
-static ssize_t mpc8xx_wdt_write(struct file *file, const char *data, size_t len,
-				loff_t * ppos)
+static ssize_t mpc8xx_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
-
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long mpc8xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	static struct watchdog_info info = {
@@ -112,15 +108,19 @@ static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
 		return -EOPNOTSUPP;
 
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
 		wdt_status |= WDIOF_KEEPALIVEPING;
+		spin_unlock(&wdt_lock);
 		break;
 
 	case WDIOC_SETTIMEOUT:
 		return -EOPNOTSUPP;
 
 	case WDIOC_GETTIMEOUT:
+		spin_lock(&wdt_lock);
 		timeout = m8xx_wdt_get_timeout();
+		spin_unlock(&wdt_lock);
 		if (put_user(timeout, (int *)arg))
 			return -EFAULT;
 		break;
@@ -136,7 +136,7 @@ static const struct file_operations mpc8xx_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mpc8xx_wdt_write,
-	.ioctl = mpc8xx_wdt_ioctl,
+	.unlocked_ioctl = mpc8xx_wdt_ioctl,
 	.open = mpc8xx_wdt_open,
 	.release = mpc8xx_wdt_release,
 };
@@ -149,6 +149,7 @@ static struct miscdevice mpc8xx_wdt_miscdev = {
 
 static int __init mpc8xx_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return misc_register(&mpc8xx_wdt_miscdev);
 }
 

