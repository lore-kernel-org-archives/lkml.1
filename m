Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZGOP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZGOP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZGOP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:27:20 -0400
Received: from compulab.site5.com ([67.18.134.219]:49500 "EHLO compulab.co.il"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbZGOP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:27:09 -0400
Message-ID: <4A5DF54A.7000403@compulab.co.il>
Date: Wed, 15 Jul 2009 18:27:06 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: SBC-FITPC2 watchdog support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to watchdog timer on SBC-FITPC2 board by Compulab

Signed-off by Denis Turischev <denis@compulab.co.il>


diff -Nru linux-2.6.30.orig/MAINTAINERS linux-2.6.30/MAINTAINERS
--- linux-2.6.30.orig/MAINTAINERS       2009-06-15 15:34:46.000000000 +0300
+++ linux-2.6.30/MAINTAINERS    2009-07-15 18:03:35.000000000 +0300
@@ -4888,6 +4888,12 @@
 S:     Maintained
 F:     drivers/watchdog/sc1200wdt.c

+SBC-FITPC2 WDT DRIVER
+P:     Denis Turischev
+M:     denis@compulab.co.il
+S:     Maintained
+F:     drivers/watchdog/sbc_fitpc2_wdt.c
+
 SCHEDULER
 P:     Ingo Molnar
 M:     mingo@elte.hu
diff -Nru linux-2.6.30.orig/drivers/watchdog/Kconfig
linux-2.6.30/drivers/watchdog/Kconfig
--- linux-2.6.30.orig/drivers/watchdog/Kconfig  2009-06-15
15:35:04.000000000 +0300
+++ linux-2.6.30/drivers/watchdog/Kconfig       2009-07-15
18:00:56.000000000 +0300
@@ -695,6 +695,26 @@
          To compile this driver as a module, choose M here: the
          module will be called sbc_epx_c3.

+config SBC_FITPC2_WATCHDOG
+       tristate "Compulab SBC-FITPC2 watchdog"
+       depends on X86
+       ---help---
+         This is the driver for the built-in watchdog timer on the fit-PC2
+         Single-board computer made by Compulab.
+
+         To enable or disable the watchdog one should enter BIOS (F2)
and go
+         to "Advanced" menu , changing  "Watchdog Timer" option to
On/Off accordingly.
+         While this option is disabled user can't change "Watchdog
Timer Value",
+         when enabled one can set 31-255 s operational range. Entering
setup
+         temporary disables watchdog operation regardless to current state.
+
+         Once watchdog was enabled the system will be restarted every
+         "Watchdog Timer Value" period, so to prevent it user can
restart or
+         disable the watchdog
+
+         To compile this driver as a module, choose M here: the
+         module will be called sbc_fitpc2_wdt.
+
 # M32R Architecture

 # M68K Architecture
diff -Nru linux-2.6.30.orig/drivers/watchdog/Makefile
linux-2.6.30/drivers/watchdog/Makefile
--- linux-2.6.30.orig/drivers/watchdog/Makefile 2009-06-15
15:35:04.000000000 +0300
+++ linux-2.6.30/drivers/watchdog/Makefile      2009-07-15
17:59:38.000000000 +0300
@@ -90,6 +90,7 @@
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
+obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o

 # M32R Architecture

diff -Nru linux-2.6.30.orig/drivers/watchdog/sbc_fitpc2_wdt.c
linux-2.6.30/drivers/watchdog/sbc_fitpc2_wdt.c
--- linux-2.6.30.orig/drivers/watchdog/sbc_fitpc2_wdt.c 1970-01-01
02:00:00.000000000 +0200
+++ linux-2.6.30/drivers/watchdog/sbc_fitpc2_wdt.c      2009-07-15
17:45:34.000000000 +0300
@@ -0,0 +1,153 @@
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/notifier.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int margin = 60;       /* (secs) Default is 1 minute */
+static unsigned long wdt_status;
+
+#define        WDT_IN_USE              0
+#define        WDT_OK_TO_CLOSE         1
+
+static void wdt_send_data( unsigned char command ,unsigned char data )
+{
+       outb(command, 0x4c);
+        mdelay(100);
+       outb(data, 0x48);
+       mdelay(200);
+}
+
+static void wdt_enable(void)
+{
+        wdt_send_data(1,1);
+        wdt_send_data(2,margin);
+}
+
+static void wdt_disable(void)
+{
+        wdt_send_data(1,0);
+        wdt_send_data(2,0);
+}
+
+static int fitpc2_wdt_open(struct inode *inode, struct file *file)
+{
+       if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+               return -EBUSY;
+
+       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+       wdt_enable();
+
+       return nonseekable_open(inode, file);
+}
+
+static ssize_t fitpc2_wdt_write(struct file *file, const char *data,
size_t len, loff_t *ppos)
+{
+       if (len) {
+               if (!nowayout) {
+                       size_t i;
+
+                       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+                       for (i = 0; i != len; i++) {
+                               char c;
+
+                               if (get_user(c, data + i))
+                                       return -EFAULT;
+
+                               if (c == 'V')
+                                       set_bit(WDT_OK_TO_CLOSE,
&wdt_status);
+                       }
+               }
+               wdt_enable();
+       }
+
+       return len;
+}
+
+static int fitpc2_wdt_release(struct inode *inode, struct file *file)
+{
+       if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+               wdt_disable();
+       } else {
+               printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+                                       "timer will not stop\n");
+       }
+
+       clear_bit(WDT_IN_USE, &wdt_status);
+       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+       return 0;
+}
+
+
+static const struct file_operations fitpc2_wdt_fops =
+{
+       .owner          = THIS_MODULE,
+       .llseek         = no_llseek,
+       .write          = fitpc2_wdt_write,
+       .open           = fitpc2_wdt_open,
+       .release        = fitpc2_wdt_release,
+};
+
+static struct miscdevice fitpc2_wdt_miscdev =
+{
+       .minor          = WATCHDOG_MINOR,
+       .name           = "watchdog",
+       .fops           = &fitpc2_wdt_fops,
+};
+
+static int __init fitpc2_wdt_init(void)
+{
+       if (margin < 31 || margin > 255) {
+               printk(KERN_CRIT "WATCHDOG: margin must be in range 31 -
255 seconds, you tried to set %d\n", margin);
+               return -EINVAL;
+       }
+       return misc_register(&fitpc2_wdt_miscdev);
+}
+
+static void __exit fitpc2_wdt_exit(void)
+{
+       misc_deregister(&fitpc2_wdt_miscdev);
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
