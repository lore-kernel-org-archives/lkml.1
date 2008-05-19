Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbYESNWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbYESNWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYESNSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760046AbYESNR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/57] ibmasr: coding style, locking verify
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:03 +0100
Message-ID: <20080519130603.31722.28573.stgit@core>
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

There is a new #if 0 section here which is a suggested fix for the horrible
PCI hack in the existing code. Would be good if someone with a box that uses
this device could test it.
---

 drivers/watchdog/ibmasr.c |  149 ++++++++++++++++++++++++++-------------------
 1 files changed, 87 insertions(+), 62 deletions(-)


diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 94155f6..6824bf8 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -19,9 +19,8 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 
 enum {
@@ -70,10 +69,13 @@ static char asr_expect_close;
 static unsigned int asr_type, asr_base, asr_length;
 static unsigned int asr_read_addr, asr_write_addr;
 static unsigned char asr_toggle_mask, asr_disable_mask;
+static spinlock_t asr_lock;
 
-static void asr_toggle(void)
+static void __asr_toggle(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	reg = inb(asr_read_addr);
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
@@ -83,12 +85,21 @@ static void asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
+}
+
+static void asr_toggle(void)
+{
+	spin_lock(&asr_lock);
+	__asr_toggle();
+	spin_unlock(&asr_lock);
 }
 
 static void asr_enable(void)
 {
 	unsigned char reg;
 
+	spin_lock(&asr_lock);
 	if (asr_type == ASMTYPE_TOPAZ) {
 		/* asr_write_addr == asr_read_addr */
 		reg = inb(asr_read_addr);
@@ -99,17 +110,21 @@ static void asr_enable(void)
 		 * First make sure the hardware timer is reset by toggling
 		 * ASR hardware timer line.
 		 */
-		asr_toggle();
+		__asr_toggle();
 
 		reg = inb(asr_read_addr);
 		outb(reg & ~asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static void asr_disable(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	spin_lock(&asr_lock);
+	reg = inb(asr_read_addr);
 
 	if (asr_type == ASMTYPE_TOPAZ)
 		/* asr_write_addr == asr_read_addr */
@@ -122,6 +137,7 @@ static void asr_disable(void)
 		outb(reg | asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static int __init asr_get_base_address(void)
@@ -133,7 +149,8 @@ static int __init asr_get_base_address(void)
 
 	switch (asr_type) {
 	case ASMTYPE_TOPAZ:
-		/* SELECT SuperIO CHIP FOR QUERYING (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
+		/* SELECT SuperIO CHIP FOR QUERYING
+		   (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
 		outb(0x07, 0x2e);
 		outb(0x07, 0x2f);
 
@@ -154,14 +171,26 @@ static int __init asr_get_base_address(void)
 
 	case ASMTYPE_JASPER:
 		type = "Jaspers ";
-
-		/* FIXME: need to use pci_config_lock here, but it's not exported */
+#if 0
+		u32 r;
+		/* Suggested fix */
+		pdev = pci_get_bus_and_slot(0, DEVFN(0x1f, 0));
+		if (pdev == NULL)
+			return -ENODEV;
+		pci_read_config_dword(pdev, 0x58, &r);
+		asr_base = r & 0xFFFE;
+		pci_dev_put(pdev);
+#else
+		/* FIXME: need to use pci_config_lock here,
+		   but it's not exported */
 
 /*		spin_lock_irqsave(&pci_config_lock, flags);*/
 
 		/* Select the SuperIO chip in the PCI I/O port register */
 		outl(0x8000f858, 0xcf8);
 
+		/* BUS 0, Slot 1F, fnc 0, offset 58 */
+
 		/*
 		 * Read the base address for the SuperIO chip.
 		 * Only the lower 16 bits are valid, but the address is word
@@ -170,7 +199,7 @@ static int __init asr_get_base_address(void)
 		asr_base = inl(0xcfc) & 0xfffe;
 
 /*		spin_unlock_irqrestore(&pci_config_lock, flags);*/
-
+#endif
 		asr_read_addr = asr_write_addr =
 			asr_base + JASPER_ASR_REG_OFFSET;
 		asr_toggle_mask = JASPER_ASR_TOGGLE_MASK;
@@ -241,11 +270,10 @@ static ssize_t asr_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int asr_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	static const struct watchdog_info ident = {
-		.options =	WDIOF_KEEPALIVEPING | 
+		.options =	WDIOF_KEEPALIVEPING |
 				WDIOF_MAGICCLOSE,
 		.identity =	"IBM ASR"
 	};
@@ -254,53 +282,45 @@ static int asr_ioctl(struct inode *inode, struct file *file,
 	int heartbeat;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident)) ?
-				-EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		asr_toggle();
+		return 0;
+	/*
+	 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
+	 * and WDIOC_GETTIMEOUT always returns 256.
+	 */
+	case WDIOC_GETTIMEOUT:
+		heartbeat = 256;
+		return put_user(heartbeat, p);
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			asr_disable();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			asr_enable();
 			asr_toggle();
-			return 0;
-
-		/*
-		 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
-		 * and WDIOC_GETTIMEOUT always returns 256.
-		 */
-		case WDIOC_GETTIMEOUT:
-			heartbeat = 256;
-			return put_user(heartbeat, p);
-
-		case WDIOC_SETOPTIONS: {
-			int new_options, retval = -EINVAL;
-
-			if (get_user(new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				asr_disable();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				asr_enable();
-				asr_toggle();
-				retval = 0;
-			}
-
-			return retval;
+			retval = 0;
 		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
-
-	return -ENOTTY;
 }
 
 static int asr_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &asr_is_open))
+	if (test_and_set_bit(0, &asr_is_open))
 		return -EBUSY;
 
 	asr_toggle();
@@ -314,7 +334,8 @@ static int asr_release(struct inode *inode, struct file *file)
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
 	clear_bit(0, &asr_is_open);
@@ -323,12 +344,12 @@ static int asr_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations asr_fops = {
-	.owner =	THIS_MODULE,
-	.llseek	=	no_llseek,
-	.write =	asr_write,
-	.ioctl =	asr_ioctl,
-	.open =		asr_open,
-	.release =	asr_release,
+	.owner =		THIS_MODULE,
+	.llseek	=		no_llseek,
+	.write =		asr_write,
+	.unlocked_ioctl =	asr_ioctl,
+	.open =			asr_open,
+	.release =		asr_release,
 };
 
 static struct miscdevice asr_miscdev = {
@@ -367,6 +388,8 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	spin_lock_init(&asr_lock);
+
 	rc = asr_get_base_address();
 	if (rc)
 		return rc;
@@ -395,7 +418,9 @@ module_init(ibmasr_init);
 module_exit(ibmasr_exit);
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
 MODULE_AUTHOR("Andrey Panin");

