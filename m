Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYGXKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYGXKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYGXKkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:40:15 -0400
Received: from mail0.scram.de ([78.47.204.202]:53465 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYGXKkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:40:13 -0400
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 06:40:12 EDT
X-Spam-Score: -4.127
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <488857CD.6080007@scram.de>
Date: Thu, 24 Jul 2008 12:22:05 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: wim@iguana.be
CC: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: delete unused driver mpc8xx_wdt.c
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog driver mpc8xx_wdt.c was a device interface to
arch/ppc/syslib/m8xx_wdt.c for MPC8xx hardware. Now that ARCH=ppc is
gone, this driver is of no more use. For ARCH=powerpc, MPC8xx hardware
is supported by mpc8xxx_wdt.c.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/watchdog/Kconfig      |    4 -
 drivers/watchdog/Makefile     |    1 -
 drivers/watchdog/mpc8xx_wdt.c |  169 -----------------------------------------
 3 files changed, 0 insertions(+), 174 deletions(-)
 delete mode 100644 drivers/watchdog/mpc8xx_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index a7a8285..ac54ad5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -691,10 +691,6 @@ config MPC5200_WDT
 	tristate "MPC5200 Watchdog Timer"
 	depends on PPC_MPC52xx

-config 8xx_WDT
-	tristate "MPC8xx Watchdog Timer"
-	depends on 8xx
-
 config 8xxx_WDT
 	tristate "MPC8xxx Platform Watchdog Timer"
 	depends on PPC_8xx || PPC_83xx || PPC_86xx
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 73fd301..11defe0 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -101,7 +101,6 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 # PARISC Architecture

 # POWERPC Architecture
-obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
diff --git a/drivers/watchdog/mpc8xx_wdt.c b/drivers/watchdog/mpc8xx_wdt.c
deleted file mode 100644
index 85b5734..0000000
--- a/drivers/watchdog/mpc8xx_wdt.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * mpc8xx_wdt.c - MPC8xx watchdog userspace interface
- *
- * Author: Florian Schirmer <jolt@tuxbox.org>
- *
- * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/watchdog.h>
-#include <asm/8xx_immap.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-#include <syslib/m8xx_wdt.h>
-
-static unsigned long wdt_opened;
-static int wdt_status;
-
-static void mpc8xx_wdt_handler_disable(void)
-{
-	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
-
-	if (!m8xx_has_internal_rtc)
-		m8xx_wdt_stop_timer();
-	else
-		out_be32(piscr, in_be32(piscr) & ~(PISCR_PIE | PISCR_PTE));
-
-	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler deactivated\n");
-}
-
-static void mpc8xx_wdt_handler_enable(void)
-{
-	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
-
-	if (!m8xx_has_internal_rtc)
-		m8xx_wdt_install_timer();
-	else
-		out_be32(piscr, in_be32(piscr) | PISCR_PIE | PISCR_PTE);
-
-	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler activated\n");
-}
-
-static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_opened))
-		return -EBUSY;
-
-	m8xx_wdt_reset();
-	mpc8xx_wdt_handler_disable();
-
-	return nonseekable_open(inode, file);
-}
-
-static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
-{
-	m8xx_wdt_reset();
-
-#if !defined(CONFIG_WATCHDOG_NOWAYOUT)
-	mpc8xx_wdt_handler_enable();
-#endif
-
-	clear_bit(0, &wdt_opened);
-
-	return 0;
-}
-
-static ssize_t mpc8xx_wdt_write(struct file *file, const char *data, size_t len,
-				loff_t * ppos)
-{
-	if (len)
-		m8xx_wdt_reset();
-
-	return len;
-}
-
-static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
-{
-	int timeout;
-	static struct watchdog_info info = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 0,
-		.identity = "MPC8xx watchdog",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user((void *)arg, &info, sizeof(info)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		if (put_user(wdt_status, (int *)arg))
-			return -EFAULT;
-		wdt_status &= ~WDIOF_KEEPALIVEPING;
-		break;
-
-	case WDIOC_GETTEMP:
-		return -EOPNOTSUPP;
-
-	case WDIOC_SETOPTIONS:
-		return -EOPNOTSUPP;
-
-	case WDIOC_KEEPALIVE:
-		m8xx_wdt_reset();
-		wdt_status |= WDIOF_KEEPALIVEPING;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		return -EOPNOTSUPP;
-
-	case WDIOC_GETTIMEOUT:
-		timeout = m8xx_wdt_get_timeout();
-		if (put_user(timeout, (int *)arg))
-			return -EFAULT;
-		break;
-
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-static const struct file_operations mpc8xx_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = mpc8xx_wdt_write,
-	.ioctl = mpc8xx_wdt_ioctl,
-	.open = mpc8xx_wdt_open,
-	.release = mpc8xx_wdt_release,
-};
-
-static struct miscdevice mpc8xx_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &mpc8xx_wdt_fops,
-};
-
-static int __init mpc8xx_wdt_init(void)
-{
-	return misc_register(&mpc8xx_wdt_miscdev);
-}
-
-static void __exit mpc8xx_wdt_exit(void)
-{
-	misc_deregister(&mpc8xx_wdt_miscdev);
-
-	m8xx_wdt_reset();
-	mpc8xx_wdt_handler_enable();
-}
-
-module_init(mpc8xx_wdt_init);
-module_exit(mpc8xx_wdt_exit);
-
-MODULE_AUTHOR("Florian Schirmer <jolt@tuxbox.org>");
-MODULE_DESCRIPTION("MPC8xx watchdog driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.5.6.3

