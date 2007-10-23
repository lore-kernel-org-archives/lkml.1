Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXJWUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXJWUqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXJWUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:46:17 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:5624 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbXJWUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:46:16 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 23 Oct 2007 22:52:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.24 Watchdog Device Drivers patches - part 2
Message-ID: <20071023205224.GA3100@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/src/watchdog-simple.c |   18 +
 drivers/watchdog/Kconfig                     |   13 -
 drivers/watchdog/Makefile                    |    1 
 drivers/watchdog/ar7_wdt.c                   |  349 +++++++++++++++++++++++++++
 4 files changed, 374 insertions(+), 7 deletions(-)

with these Changes:

Author: WANG Cong <xiyou.wangcong@gmail.com>
Date:   Sat Oct 6 11:17:13 2007 +0800

    [WATCHDOG] Documentation/watchdog/src/watchdog-simple.c: improve this code
    
    Make some improvements for Documentation/watchdog/src/watchdog-simple.c.
    
    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Matteo Croce <technoboy85@gmail.com>
Date:   Thu Sep 20 18:06:41 2007 +0200

    [WATCHDOG] AR7: watchdog timer
    
    Driver for the watchdog timer. Still doesn't reboots the machine
    on some boards, but we have improved and cleaned it
    
    Signed-off-by: Matteo Croce <technoboy85@gmail.com>
    Signed-off-by: Nicolas Thill <nico@openwrt.org>
    Signed-off-by: Enrik Berkhan <Enrik.Berkhan@akk.org>
    Signed-off-by: Christer Weinigel <wingel@nano-system.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Veljkovic Srdjan <sveljko@gvs.co.yu>
Date:   Wed Sep 12 15:22:26 2007 +0200

    [WATCHDOG] Linux kernel IPC SBC Watchdog Timer driver
    
    ICP's Wafer 5823 SBC has, as far as I can tell, the same WDT as many,
    if not all ICP's SBC's (that do have a WDT). I have tested it with
    several boards, including Rocky 4783, Rocky 3703 and Rocky 3782.
    
    I propose a rename of the  Wafer 5823 watchdog timer driver
    to something like "IPC (SBC) Watchdog Timer", to reflect that it
    works with other IPC boards (maybe even all of them).
    
    Signed-off-by: Veljkovic Srdjan <sveljko@gvs.co.yu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/src/watchdog-simple.c b/Documentation/watchdog/src/watchdog-simple.c
index 47801bc..4cf72f3 100644
--- a/Documentation/watchdog/src/watchdog-simple.c
+++ b/Documentation/watchdog/src/watchdog-simple.c
@@ -3,15 +3,25 @@
 #include <unistd.h>
 #include <fcntl.h>
 
-int main(int argc, const char *argv[]) {
+int main(void)
+{
 	int fd = open("/dev/watchdog", O_WRONLY);
+	int ret = 0;
 	if (fd == -1) {
 		perror("watchdog");
-		exit(1);
+		exit(EXIT_FAILURE);
 	}
 	while (1) {
-		write(fd, "\0", 1);
-		fsync(fd);
+		ret = write(fd, "\0", 1);
+		if (ret != 1) {
+			ret = -1;
+			break;
+		}
+		ret = fsync(fd);
+		if (ret)
+			break;
 		sleep(10);
 	}
+	close(fd);
+	return ret;
 }
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 37bddc1..81db48f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -343,11 +343,12 @@ config IBMASR
 	  module will be called ibmasr.
 
 config WAFER_WDT
-	tristate "ICP Wafer 5823 Single Board Computer Watchdog"
+	tristate "ICP Single Board Computer Watchdog Timer"
 	depends on X86
 	help
-	  This is a driver for the hardware watchdog on the ICP Wafer 5823
-	  Single Board Computer (and probably other similar models).
+	  This is a driver for the hardware watchdog on the ICP Single
+	  Board Computer. This driver is working on (at least) the following
+	  IPC SBC's: Wafer 5823, Rocky 4783, Rocky 3703 and Rocky 3782.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called wafer5823wdt.
@@ -609,6 +610,12 @@ config WDT_RM9K_GPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called rm9k_wdt.
 
+config AR7_WDT
+	tristate "TI AR7 Watchdog Timer"
+	depends on AR7
+	help
+	  Hardware driver for the TI AR7 Watchdog Timer.
+
 # PARISC Architecture
 
 # POWERPC Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 389f8b1..7d9e573 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
+obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
 
 # PARISC Architecture
 
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
new file mode 100644
index 0000000..cdaab8c
--- /dev/null
+++ b/drivers/watchdog/ar7_wdt.c
@@ -0,0 +1,349 @@
+/*
+ * drivers/watchdog/ar7_wdt.c
+ *
+ * Copyright (C) 2007 Nicolas Thill <nico@openwrt.org>
+ * Copyright (c) 2005 Enrik Berkhan <Enrik.Berkhan@akk.org>
+ *
+ * Some code taken from:
+ * National Semiconductor SCx200 Watchdog support
+ * Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/fs.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/addrspace.h>
+#include <asm/ar7/ar7.h>
+
+#define DRVNAME "ar7_wdt"
+#define LONGNAME "TI AR7 Watchdog Timer"
+
+MODULE_AUTHOR("Nicolas Thill <nico@openwrt.org>");
+MODULE_DESCRIPTION(LONGNAME);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+static int margin = 60;
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+#define READ_REG(x) readl((void __iomem *)&(x))
+#define WRITE_REG(x, v) writel((v), (void __iomem *)&(x))
+
+struct ar7_wdt {
+	u32 kick_lock;
+	u32 kick;
+	u32 change_lock;
+	u32 change;
+	u32 disable_lock;
+	u32 disable;
+	u32 prescale_lock;
+	u32 prescale;
+};
+
+static struct semaphore open_semaphore;
+static unsigned expect_close;
+
+/* XXX currently fixed, allows max margin ~68.72 secs */
+#define prescale_value 0xffff
+
+/* Offset of the WDT registers */
+static unsigned long ar7_regs_wdt;
+/* Pointer to the remapped WDT IO space */
+static struct ar7_wdt *ar7_wdt;
+static void ar7_wdt_get_regs(void)
+{
+	u16 chip_id = ar7_chip_id();
+	switch (chip_id) {
+	case AR7_CHIP_7100:
+	case AR7_CHIP_7200:
+		ar7_regs_wdt = AR7_REGS_WDT;
+		break;
+	default:
+		ar7_regs_wdt = UR8_REGS_WDT;
+		break;
+	}
+}
+
+
+static void ar7_wdt_kick(u32 value)
+{
+	WRITE_REG(ar7_wdt->kick_lock, 0x5555);
+	if ((READ_REG(ar7_wdt->kick_lock) & 3) == 1) {
+		WRITE_REG(ar7_wdt->kick_lock, 0xaaaa);
+		if ((READ_REG(ar7_wdt->kick_lock) & 3) == 3) {
+			WRITE_REG(ar7_wdt->kick, value);
+			return;
+		}
+	}
+	printk(KERN_ERR DRVNAME ": failed to unlock WDT kick reg\n");
+}
+
+static void ar7_wdt_prescale(u32 value)
+{
+	WRITE_REG(ar7_wdt->prescale_lock, 0x5a5a);
+	if ((READ_REG(ar7_wdt->prescale_lock) & 3) == 1) {
+		WRITE_REG(ar7_wdt->prescale_lock, 0xa5a5);
+		if ((READ_REG(ar7_wdt->prescale_lock) & 3) == 3) {
+			WRITE_REG(ar7_wdt->prescale, value);
+			return;
+		}
+	}
+	printk(KERN_ERR DRVNAME ": failed to unlock WDT prescale reg\n");
+}
+
+static void ar7_wdt_change(u32 value)
+{
+	WRITE_REG(ar7_wdt->change_lock, 0x6666);
+	if ((READ_REG(ar7_wdt->change_lock) & 3) == 1) {
+		WRITE_REG(ar7_wdt->change_lock, 0xbbbb);
+		if ((READ_REG(ar7_wdt->change_lock) & 3) == 3) {
+			WRITE_REG(ar7_wdt->change, value);
+			return;
+		}
+	}
+	printk(KERN_ERR DRVNAME ": failed to unlock WDT change reg\n");
+}
+
+static void ar7_wdt_disable(u32 value)
+{
+	WRITE_REG(ar7_wdt->disable_lock, 0x7777);
+	if ((READ_REG(ar7_wdt->disable_lock) & 3) == 1) {
+		WRITE_REG(ar7_wdt->disable_lock, 0xcccc);
+		if ((READ_REG(ar7_wdt->disable_lock) & 3) == 2) {
+			WRITE_REG(ar7_wdt->disable_lock, 0xdddd);
+			if ((READ_REG(ar7_wdt->disable_lock) & 3) == 3) {
+				WRITE_REG(ar7_wdt->disable, value);
+				return;
+			}
+		}
+	}
+	printk(KERN_ERR DRVNAME ": failed to unlock WDT disable reg\n");
+}
+
+static void ar7_wdt_update_margin(int new_margin)
+{
+	u32 change;
+
+	change = new_margin * (ar7_vbus_freq() / prescale_value);
+	if (change < 1) change = 1;
+	if (change > 0xffff) change = 0xffff;
+	ar7_wdt_change(change);
+	margin = change * prescale_value / ar7_vbus_freq();
+	printk(KERN_INFO DRVNAME
+	       ": timer margin %d seconds (prescale %d, change %d, freq %d)\n",
+	       margin, prescale_value, change, ar7_vbus_freq());
+}
+
+static void ar7_wdt_enable_wdt(void)
+{
+	printk(KERN_DEBUG DRVNAME ": enabling watchdog timer\n");
+	ar7_wdt_disable(1);
+	ar7_wdt_kick(1);
+}
+
+static void ar7_wdt_disable_wdt(void)
+{
+	printk(KERN_DEBUG DRVNAME ": disabling watchdog timer\n");
+	ar7_wdt_disable(0);
+}
+
+static int ar7_wdt_open(struct inode *inode, struct file *file)
+{
+	/* only allow one at a time */
+	if (down_trylock(&open_semaphore))
+		return -EBUSY;
+	ar7_wdt_enable_wdt();
+	expect_close = 0;
+
+	return nonseekable_open(inode, file);
+}
+
+static int ar7_wdt_release(struct inode *inode, struct file *file)
+{
+	if (!expect_close)
+		printk(KERN_WARNING DRVNAME
+		": watchdog device closed unexpectedly,"
+		"will not disable the watchdog timer\n");
+	else if (!nowayout)
+		ar7_wdt_disable_wdt();
+
+	up(&open_semaphore);
+
+	return 0;
+}
+
+static int ar7_wdt_notify_sys(struct notifier_block *this,
+			      unsigned long code, void *unused)
+{
+	if (code == SYS_HALT || code == SYS_POWER_OFF)
+		if (!nowayout)
+			ar7_wdt_disable_wdt();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ar7_wdt_notifier = {
+	.notifier_call = ar7_wdt_notify_sys
+};
+
+static ssize_t ar7_wdt_write(struct file *file, const char *data,
+			     size_t len, loff_t *ppos)
+{
+	/* check for a magic close character */
+	if (len) {
+		size_t i;
+
+		ar7_wdt_kick(1);
+
+		expect_close = 0;
+		for (i = 0; i < len; ++i) {
+			char c;
+			if (get_user(c, data+i))
+				return -EFAULT;
+			if (c == 'V')
+				expect_close = 1;
+		}
+
+	}
+	return len;
+}
+
+static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
+			 unsigned int cmd, unsigned long arg)
+{
+	static struct watchdog_info ident = {
+		.identity = LONGNAME,
+		.firmware_version = 1,
+		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING),
+	};
+	int new_margin;
+
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((struct watchdog_info *)arg, &ident,
+				sizeof(ident)))
+			return -EFAULT;
+		return 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		if (put_user(0, (int *)arg))
+			return -EFAULT;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		ar7_wdt_kick(1);
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, (int *)arg))
+			return -EFAULT;
+		if (new_margin < 1)
+			return -EINVAL;
+
+		ar7_wdt_update_margin(new_margin);
+		ar7_wdt_kick(1);
+
+	case WDIOC_GETTIMEOUT:
+		if (put_user(margin, (int *)arg))
+			return -EFAULT;
+		return 0;
+	}
+}
+
+static struct file_operations ar7_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ar7_wdt_write,
+	.ioctl		= ar7_wdt_ioctl,
+	.open		= ar7_wdt_open,
+	.release	= ar7_wdt_release,
+};
+
+static struct miscdevice ar7_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &ar7_wdt_fops,
+};
+
+static int __init ar7_wdt_init(void)
+{
+	int rc;
+
+	ar7_wdt_get_regs();
+
+	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
+							LONGNAME)) {
+		printk(KERN_WARNING DRVNAME ": watchdog I/O region busy\n");
+		return -EBUSY;
+	}
+
+	ar7_wdt = (struct ar7_wdt *)
+			ioremap(ar7_regs_wdt, sizeof(struct ar7_wdt));
+
+	ar7_wdt_disable_wdt();
+	ar7_wdt_prescale(prescale_value);
+	ar7_wdt_update_margin(margin);
+
+	sema_init(&open_semaphore, 1);
+
+	rc = register_reboot_notifier(&ar7_wdt_notifier);
+	if (rc) {
+		printk(KERN_ERR DRVNAME
+			": unable to register reboot notifier\n");
+		goto out_alloc;
+	}
+
+	rc = misc_register(&ar7_wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR DRVNAME ": unable to register misc device\n");
+		goto out_register;
+	}
+	goto out;
+
+out_register:
+	unregister_reboot_notifier(&ar7_wdt_notifier);
+out_alloc:
+	iounmap(ar7_wdt);
+	release_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt));
+out:
+	return rc;
+}
+
+static void __exit ar7_wdt_cleanup(void)
+{
+	misc_deregister(&ar7_wdt_miscdev);
+	unregister_reboot_notifier(&ar7_wdt_notifier);
+	iounmap(ar7_wdt);
+	release_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt));
+}
+
+module_init(ar7_wdt_init);
+module_exit(ar7_wdt_cleanup);
