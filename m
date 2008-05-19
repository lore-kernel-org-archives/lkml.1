Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbYESNXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbYESNXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbYESNSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760161AbYESNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/57] it8712f: unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:19 +0100
Message-ID: <20080519130619.31722.82312.stgit@core>
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

 drivers/watchdog/it8712f_wdt.c |   77 ++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 50 deletions(-)


diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 445b7e8..51bfd57 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -30,9 +30,8 @@
 #include <linux/fs.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define NAME "it8712f_wdt"
 
@@ -50,7 +49,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
-static struct semaphore it8712f_wdt_sem;
+static unsigned long wdt_open;
 static unsigned expect_close;
 static spinlock_t io_lock;
 static unsigned char revision;
@@ -86,22 +85,19 @@ static unsigned short address;
 #define WDT_OUT_PWROK	0x10
 #define WDT_OUT_KRST	0x40
 
-static int
-superio_inb(int reg)
+static int superio_inb(int reg)
 {
 	outb(reg, REG);
 	return inb(VAL);
 }
 
-static void
-superio_outb(int val, int reg)
+static void superio_outb(int val, int reg)
 {
 	outb(reg, REG);
 	outb(val, VAL);
 }
 
-static int
-superio_inw(int reg)
+static int superio_inw(int reg)
 {
 	int val;
 	outb(reg++, REG);
@@ -111,15 +107,13 @@ superio_inw(int reg)
 	return val;
 }
 
-static inline void
-superio_select(int ldn)
+static inline void superio_select(int ldn)
 {
 	outb(LDN, REG);
 	outb(ldn, VAL);
 }
 
-static inline void
-superio_enter(void)
+static inline void superio_enter(void)
 {
 	spin_lock(&io_lock);
 	outb(0x87, REG);
@@ -128,22 +122,19 @@ superio_enter(void)
 	outb(0x55, REG);
 }
 
-static inline void
-superio_exit(void)
+static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
 	spin_unlock(&io_lock);
 }
 
-static inline void
-it8712f_wdt_ping(void)
+static inline void it8712f_wdt_ping(void)
 {
 	inb(address);
 }
 
-static void
-it8712f_wdt_update_margin(void)
+static void it8712f_wdt_update_margin(void)
 {
 	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
 	int units = margin;
@@ -165,8 +156,7 @@ it8712f_wdt_update_margin(void)
 	superio_outb(units, WDT_TIMEOUT);
 }
 
-static int
-it8712f_wdt_get_status(void)
+static int it8712f_wdt_get_status(void)
 {
 	if (superio_inb(WDT_CONTROL) & 0x01)
 		return WDIOF_CARDRESET;
@@ -174,8 +164,7 @@ it8712f_wdt_get_status(void)
 		return 0;
 }
 
-static void
-it8712f_wdt_enable(void)
+static void it8712f_wdt_enable(void)
 {
 	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
 	superio_enter();
@@ -190,8 +179,7 @@ it8712f_wdt_enable(void)
 	it8712f_wdt_ping();
 }
 
-static void
-it8712f_wdt_disable(void)
+static void it8712f_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
@@ -207,8 +195,7 @@ it8712f_wdt_disable(void)
 	superio_exit();
 }
 
-static int
-it8712f_wdt_notify(struct notifier_block *this,
+static int it8712f_wdt_notify(struct notifier_block *this,
 		    unsigned long code, void *unused)
 {
 	if (code == SYS_HALT || code == SYS_POWER_OFF)
@@ -222,9 +209,8 @@ static struct notifier_block it8712f_wdt_notifier = {
 	.notifier_call = it8712f_wdt_notify,
 };
 
-static ssize_t
-it8712f_wdt_write(struct file *file, const char __user *data,
-	size_t len, loff_t *ppos)
+static ssize_t it8712f_wdt_write(struct file *file, const char __user *data,
+					size_t len, loff_t *ppos)
 {
 	/* check for a magic close character */
 	if (len) {
@@ -245,9 +231,8 @@ it8712f_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int
-it8712f_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -302,19 +287,16 @@ it8712f_wdt_ioctl(struct inode *inode, struct file *file,
 	}
 }
 
-static int
-it8712f_wdt_open(struct inode *inode, struct file *file)
+static int it8712f_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&it8712f_wdt_sem))
+	if (test_and_set_bit(0, &wdt_open))
 		return -EBUSY;
 	it8712f_wdt_enable();
-
 	return nonseekable_open(inode, file);
 }
 
-static int
-it8712f_wdt_release(struct inode *inode, struct file *file)
+static int it8712f_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42) {
 		printk(KERN_WARNING NAME
@@ -324,7 +306,7 @@ it8712f_wdt_release(struct inode *inode, struct file *file)
 		it8712f_wdt_disable();
 	}
 	expect_close = 0;
-	up(&it8712f_wdt_sem);
+	clear_bit(0, &wdt_open);
 
 	return 0;
 }
@@ -333,7 +315,7 @@ static const struct file_operations it8712f_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = it8712f_wdt_write,
-	.ioctl = it8712f_wdt_ioctl,
+	.unlocked_ioctl = it8712f_wdt_ioctl,
 	.open = it8712f_wdt_open,
 	.release = it8712f_wdt_release,
 };
@@ -344,8 +326,7 @@ static struct miscdevice it8712f_wdt_miscdev = {
 	.fops = &it8712f_wdt_fops,
 };
 
-static int __init
-it8712f_wdt_find(unsigned short *address)
+static int __init it8712f_wdt_find(unsigned short *address)
 {
 	int err = -ENODEV;
 	int chip_type;
@@ -387,8 +368,7 @@ exit:
 	return err;
 }
 
-static int __init
-it8712f_wdt_init(void)
+static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
@@ -404,8 +384,6 @@ it8712f_wdt_init(void)
 
 	it8712f_wdt_disable();
 
-	sema_init(&it8712f_wdt_sem, 1);
-
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
@@ -430,8 +408,7 @@ out:
 	return err;
 }
 
-static void __exit
-it8712f_wdt_exit(void)
+static void __exit it8712f_wdt_exit(void)
 {
 	misc_deregister(&it8712f_wdt_miscdev);
 	unregister_reboot_notifier(&it8712f_wdt_notifier);

