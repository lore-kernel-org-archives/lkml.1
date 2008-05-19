Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbYESN3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbYESN3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760868AbYESNT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760859AbYESNT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 36/57] sa1100_wdt: Switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:05 +0100
Message-ID: <20080519130805.31722.23241.stgit@core>
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

 drivers/watchdog/sa1100_wdt.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)


diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 34a2b3b..869d538 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -26,13 +26,13 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_ARCH_PXA
 #include <asm/arch/pxa-regs.h>
 #endif
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define OSCR_FREQ		CLOCK_TICK_RATE
 
@@ -45,7 +45,7 @@ static int boot_status;
  */
 static int sa1100dog_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1,&sa1100wdt_users))
+	if (test_and_set_bit(1, &sa1100wdt_users))
 		return -EBUSY;
 
 	/* Activate SA1100 Watchdog timer */
@@ -66,28 +66,27 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
 	printk(KERN_CRIT "WATCHDOG: Device closed - timer will not stop\n");
-
 	clear_bit(1, &sa1100wdt_users);
-
 	return 0;
 }
 
-static ssize_t sa1100dog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t sa1100dog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	if (len)
 		/* Refresh OSMR3 timer. */
 		OSMR3 = OSCR + pre_margin;
-
 	return len;
 }
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT
+				| WDIOF_KEEPALIVEPING,
 	.identity	= "SA1100/PXA255 Watchdog",
 };
 
-static int sa1100dog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -134,18 +133,16 @@ static int sa1100dog_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
-static const struct file_operations sa1100dog_fops =
-{
+static const struct file_operations sa1100dog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sa1100dog_write,
-	.ioctl		= sa1100dog_ioctl,
+	.unlocked_ioctl	= sa1100dog_ioctl,
 	.open		= sa1100dog_open,
 	.release	= sa1100dog_release,
 };
 
-static struct miscdevice sa1100dog_miscdev =
-{
+static struct miscdevice sa1100dog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sa1100dog_fops,
@@ -167,8 +164,9 @@ static int __init sa1100dog_init(void)
 
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
-		printk("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
-		       margin);
+		printk(KERN_INFO
+			"SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
+						margin);
 	return ret;
 }
 

