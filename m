Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbZHDPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbZHDPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbZHDPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:36 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14378 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932823AbZHDPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIvxd0pR9dJI/2dsb2JhbADVLgmCIwaBZgWBSg
Date: Tue, 4 Aug 2009 17:33:31 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Rapoport <mike@compulab.co.il>,
       Denis Turischev <denis@compulab.co.il>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrey Panin <pazke@centrinvest.ru>, akpm@linux-foundation.org
Subject: Re: [PATCH v2] add SBC-FITPC2 watchdog driver
Message-ID: <20090804153331.GA30892@infomag.iguana.be>
References: <4A6594C9.4010403@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <4A6594C9.4010403@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mike, Denis,

> > From: Denis Turischev <denis@compulab.co.il>
> 
> This patch adds support for watchdog found on SBC-FITPC2 board.
> 
> --
> v2 changes:
> - reorder fitpc2_wdt_write to reduce the indent
> - change printk levels
> - use pr_fmt
> - add release_region in the _init error path
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Some remarks:
1) If you dou request_regions in the init section then you need to do release_regions also in the exit section.
2) we prefer:
 static long wdt_ioctl(parameters
			rest_of_parameters)
instead of
 static long
 wdt_ioctl(parameters)
3) misc_deregister can return with an error. If it does you need to do the release_regions also.
4) as Andrew allready pointed out spinlock needs to be initialized.
5) if you don't use the reboot_notifier then you don't need to include linux/notifier.h and linux/reboot.h .

I adapted the code.
Can you test the attached diff?

Thanks in advance,
Wim.


--f2QGlHpHGjS2mn6Y
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="sbc-fitpc2.diff"

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b1ccc04..1940a08 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -369,6 +369,28 @@ config SC520_WDT
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called sc520_wdt.
 
+config SBC_FITPC2_WATCHDOG
+	tristate "Compulab SBC-FITPC2 watchdog"
+	depends on X86
+	---help---
+	  This is the driver for the built-in watchdog timer on the fit-PC2
+	  Single-board computer made by Compulab.
+
+	  It`s possible to enable watchdog timer either from BIOS (F2) or from booted Linux.
+	  When "Watchdog Timer Value" enabled one can set 31-255 s operational range.
+
+	  Entering BIOS setup temporary disables watchdog operation regardless to current state,
+	  so system will not be restarted while user in BIOS setup.
+
+	  Once watchdog was enabled the system will be restarted every
+	  "Watchdog Timer Value" period, so to prevent it user can restart or
+	  disable the watchdog.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc_fitpc2_wdt.
+
+	  Most people will say N.
+
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 3d77429..6c58e7c 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
+obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
diff -Nru /dev/null b/drivers/watchdog/sbc_fitpc2_wdt.c
--- /dev/null
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c	2009-08-04 09:38:02.670583765 +0000
@@ -0,0 +1,267 @@
+/*
+ * Watchdog driver for SBC-FITPC2 board
+ *
+ * Author: Denis Turischev <denis@compulab.co.il>
+ *
+ * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/system.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int margin = 60;	/* (secs) Default is 1 minute */
+static unsigned long wdt_status;
+static DEFINE_SPINLOCK(wdt_lock);
+
+#define WDT_IN_USE		0
+#define WDT_OK_TO_CLOSE		1
+
+#define COMMAND_PORT		0x4c
+#define DATA_PORT		0x48
+
+#define IFACE_ON_COMMAND	1
+#define REBOOT_COMMAND		2
+
+#define WATCHDOG_NAME 		"SBC-FITPC2 Watchdog"
+
+static void wdt_send_data(unsigned char command, unsigned char data)
+{
+	outb(command, COMMAND_PORT);
+	mdelay(100);
+	outb(data, DATA_PORT);
+	mdelay(200);
+}
+
+static void wdt_enable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 1);
+	wdt_send_data(REBOOT_COMMAND, margin);
+	spin_unlock(&wdt_lock);
+}
+
+static void wdt_disable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 0);
+	wdt_send_data(REBOOT_COMMAND, 0);
+	spin_unlock(&wdt_lock);
+}
+
+static int fitpc2_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t fitpc2_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
+{
+	size_t i;
+
+	if (!len)
+		return 0;
+
+	if (nowayout) {
+		len = 0;
+		goto out;
+	}
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	for (i = 0; i != len; i++) {
+		char c;
+
+		if (get_user(c, data + i))
+			return -EFAULT;
+
+		if (c == 'V')
+			set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	}
+
+out:
+	wdt_enable();
+
+	return len;
+}
+
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING,
+	.identity	= WATCHDOG_NAME,
+};
+
+
+static long fitpc2_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, (int *)arg);
+		if (ret)
+			break;
+
+		if (time < 31 || time > 255) {
+			ret = -EINVAL;
+			break;
+		}
+
+		margin = time;
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(margin, (int *)arg);
+		break;
+	}
+
+	return ret;
+}
+
+static int fitpc2_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+		wdt_disable();
+		pr_info("Device disabled\n");
+	} else {
+		pr_warning("Device closed unexpectedly -"
+			" timer will not stop\n");
+		wdt_enable();
+	}
+
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+
+static const struct file_operations fitpc2_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= fitpc2_wdt_write,
+	.unlocked_ioctl	= fitpc2_wdt_ioctl,
+	.open		= fitpc2_wdt_open,
+	.release	= fitpc2_wdt_release,
+};
+
+static struct miscdevice fitpc2_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &fitpc2_wdt_fops,
+};
+
+static int __init fitpc2_wdt_init(void)
+{
+	int err;
+
+	if (strcmp("SBC-FITPC2", dmi_get_system_info(DMI_BOARD_NAME))) {
+		pr_info("board name is: %s. Should be SBC-FITPC2\n",
+			dmi_get_system_info(DMI_BOARD_NAME));
+		return -ENODEV;
+	}
+
+	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
+		return -EIO;
+	}
+
+	if (!request_region(DATA_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", DATA_PORT);
+		err = -EIO;
+		goto err_data_port;
+	}
+
+	if (margin < 31 || margin > 255) {
+		pr_err("margin must be in range 31 - 255"
+		       " seconds, you tried to set %d\n", margin);
+		err = -EINVAL;
+		goto err_margin;
+	}
+
+	err = misc_register(&fitpc2_wdt_miscdev);
+	if (!err) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, err);
+		goto err_margin;
+	}
+
+	return 0;
+
+err_margin:
+	release_region(DATA_PORT, 1);
+err_data_port:
+	release_region(COMMAND_PORT, 1);
+
+	return err;
+}
+
+static void __exit fitpc2_wdt_exit(void)
+{
+	misc_deregister(&fitpc2_wdt_miscdev);
+	release_region(DATA_PORT, 1);
+	release_region(COMMAND_PORT, 1);
+}
+
+module_init(fitpc2_wdt_init);
+module_exit(fitpc2_wdt_exit);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("SBC-FITPC2 Watchdog");
+
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+

--f2QGlHpHGjS2mn6Y--
