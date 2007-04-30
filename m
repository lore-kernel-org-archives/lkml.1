Return-Path: <linux-kernel-owner+w=401wt.eu-S1946394AbXD3Q50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946394AbXD3Q50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946392AbXD3Q5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:57:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:30757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946394AbXD3Q5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:57:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,471,1170662400"; 
   d="scan'208";a="221724961"
Subject: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and
	iop13xx
From: Dan Williams <dan.j.williams@intel.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: "Curt E. Bruns" <curt.e.bruns@intel.com>,
       Peter Milne <peter.milne@d-tacq.com>,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 30 Apr 2007 09:57:20 -0700
Message-Id: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Wim,

Here is a new watchdog driver for your review.  It supports two flavors
of the iop watchdog timer.  The iop13xx watchdog can be stopped while
the iop3xx version cannot.

Thanks,
Dan

---
iop: combined watchdog timer driver for iop3xx and iop13xx

From: Dan Williams <dan.j.williams@intel.com>

Heartbeat derived from the tick rate supplied to arch/arm/plat-iop/time.c

Cc: Curt Bruns <curt.e.bruns@intel.com>
Cc: Peter Milne <peter.milne@d-tacq.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/plat-iop/time.c               |    8 +
 drivers/char/watchdog/Kconfig          |   16 ++
 drivers/char/watchdog/Makefile         |    1 
 drivers/char/watchdog/iop_wdt.c        |  251 ++++++++++++++++++++++++++++++++
 include/asm-arm/arch-iop13xx/iop13xx.h |   44 ++++++
 include/asm-arm/arch-iop13xx/system.h  |   34 ----
 include/asm-arm/hardware/iop3xx.h      |   15 ++
 7 files changed, 337 insertions(+), 32 deletions(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 0cc26da..3452e6e 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -78,6 +78,13 @@ static struct irqaction iop_timer_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
+static unsigned long iop_tick_rate;
+unsigned long get_iop_tick_rate(void)
+{
+	return iop_tick_rate;
+}
+EXPORT_SYMBOL(get_iop_tick_rate);
+
 void __init iop_init_time(unsigned long tick_rate)
 {
 	u32 timer_ctl;
@@ -85,6 +92,7 @@ void __init iop_init_time(unsigned long tick_rate)
 	ticks_per_jiffy = (tick_rate + HZ/2) / HZ;
 	ticks_per_usec = tick_rate / 1000000;
 	next_jiffy_time = 0xffffffff;
+	iop_tick_rate = tick_rate;
 
 	timer_ctl = IOP_TMR_EN | IOP_TMR_PRIVILEGED |
 			IOP_TMR_RELOAD | IOP_TMR_RATIO_1_1;
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index e812aa1..a112a17 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -183,6 +183,22 @@ config PNX4008_WATCHDOG
 
 	  Say N if you are unsure.
 
+config IOP_WATCHDOG
+	tristate "IOP Watchdog"
+	depends on WATCHDOG && PLAT_IOP
+	select WATCHDOG_NOWAYOUT if (ARCH_IOP32X || ARCH_IOP33X)
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the Intel IOP3XX & IOP13XX I/O Processors.  This driver can
+	  be built as a module by choosing M. The module will
+	  be called iop_wdt.
+
+	  Note: The IOP13XX watchdog does an Internal Bus Reset which will
+	  affect both cores and the peripherals of the IOP.  The ATU-X
+	  and/or ATUe configuration registers will remain intact, but if 
+	  operating as an Root Complex and/or Central Resource, the PCI-X
+	  and/or PCIe busses will also be reset.  THIS IS A VERY BIG HAMMER.
+
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 2cd8ff8..bc46876 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SA1100_WATCHDOG) += sa1100_wdt.o
 obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
+obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
diff --git a/drivers/char/watchdog/iop_wdt.c b/drivers/char/watchdog/iop_wdt.c
new file mode 100644
index 0000000..8ab10ba
--- /dev/null
+++ b/drivers/char/watchdog/iop_wdt.c
@@ -0,0 +1,251 @@
+/*
+ * drivers/char/watchdog/iop_wdt.c
+ *
+ * WDT driver for Intel I/O Processors
+ * Copyright (C) 2005, Intel Corporation.
+ *
+ * Based on ixp4xx driver, Copyright 2004 (c) MontaVista, Software, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ *	Curt E Bruns <curt.e.bruns@intel.com> 
+ *	Peter Milne <peter.milne@d-tacq.com>
+ *	Dan Williams <dan.j.williams@intel.com> 
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <asm/uaccess.h>
+#include <asm/hardware.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned long wdt_status;
+static unsigned long boot_status;
+extern unsigned long get_iop_tick_rate(void);
+
+#define WDT_IN_USE		0
+#define WDT_OK_TO_CLOSE		1
+#define WDT_ENABLED		2
+
+static unsigned long iop_watchdog_timeout(void)
+{
+	return (0xffffffffUL / get_iop_tick_rate());
+}
+
+static void wdt_enable(void)
+{
+	/* Arm and enable the Timer to starting counting down from 0xFFFF.FFFF
+	 * Takes approx. 10.7s to timeout
+	 */
+	write_wdtcr(IOP_WDTCR_EN_ARM);
+	write_wdtcr(IOP_WDTCR_EN);
+}
+
+/* returns 0 if the timer was successfully disabled */
+static int wdt_disable(void)
+{
+	#ifdef CONFIG_ARCH_IOP13XX
+	/* Stop Counting */
+	write_wdtcr(IOP13XX_WDTCR_DIS_ARM);
+	write_wdtcr(IOP13XX_WDTCR_DIS);
+	clear_bit(WDT_ENABLED, &wdt_status);
+	printk(KERN_INFO "WATCHDOG: Disabled\n");
+	return 0;
+	#else
+	return 1;
+	#endif
+}
+
+static int iop_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	wdt_enable();
+
+	set_bit(WDT_ENABLED, &wdt_status);
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t
+iop_wdt_write(struct file *file, const char *data, size_t len,
+		  loff_t * ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			}
+		}
+		wdt_enable();
+	}
+
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+	.identity = "iop watchdog",
+};
+
+static int
+iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		  unsigned long arg)
+{
+	int options;
+	int ret = -ENOTTY;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user
+		    ((struct watchdog_info *)arg, &ident, sizeof ident))
+			ret = -EFAULT;
+		else
+			ret = 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(boot_status, (int *)arg);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(iop_watchdog_timeout(), (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			if (!nowayout) {
+				if (wdt_disable() == 0) {
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+					ret = 0;
+				} else
+					ret = -ENXIO;
+			} else
+				ret = 0;
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			wdt_enable();
+			ret = 0;
+		}
+		break;
+	}
+
+	return ret;
+}
+
+static int iop_wdt_release(struct inode *inode, struct file *file)
+{
+	int state = 1;
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
+		if (test_bit(WDT_ENABLED, &wdt_status))
+			state = wdt_disable();
+
+	/* if the timer is not disbaled reload and notify that we are still
+	 * going down
+	 */
+	if (state != 0) {
+		wdt_enable();
+		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+		       "reset in %lu seconds\n", iop_watchdog_timeout());
+	}
+
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+static const struct file_operations iop_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = iop_wdt_write,
+	.ioctl = iop_wdt_ioctl,
+	.open = iop_wdt_open,
+	.release = iop_wdt_release,
+};
+
+static struct miscdevice iop_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &iop_wdt_fops,
+};
+
+static int __init iop_wdt_init(void)
+{
+	int ret;
+
+	ret = misc_register(&iop_wdt_miscdev);
+	if (ret == 0)
+		printk("iop watchdog timer: timeout %lu sec\n",
+		       iop_watchdog_timeout());
+
+	#ifdef CONFIG_ARCH_IOP13XX
+	boot_status = (read_rcsr() & IOP13XX_RCSR_WDT) ? WDIOF_CARDRESET : 0;
+
+	/* Configure Watchdog Timeout to cause an Internal Bus (IB) Reset
+	 * NOTE: An IB Reset will Reset both cores in the IOP342
+	 */
+	write_wdtsr(IOP13XX_WDTCR_IB_RESET);
+	#else
+	boot_status = 0;
+	#endif
+
+	return ret;
+}
+
+static void __exit iop_wdt_exit(void)
+{
+	misc_deregister(&iop_wdt_miscdev);
+}
+
+module_init(iop_wdt_init);
+module_exit(iop_wdt_exit);
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_AUTHOR("Curt E Bruns <curt.e.bruns@intel.com>");
+MODULE_DESCRIPTION("iop watchdog timer driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/include/asm-arm/arch-iop13xx/iop13xx.h b/include/asm-arm/arch-iop13xx/iop13xx.h
index 6239e1e..679e917 100644
--- a/include/asm-arm/arch-iop13xx/iop13xx.h
+++ b/include/asm-arm/arch-iop13xx/iop13xx.h
@@ -19,6 +19,37 @@ static inline int iop13xx_cpu_id(void)
 	return id;
 }
 
+/* WDTCR CP6 R7 Page 9 */
+static inline u32 read_wdtcr(void)
+{
+	u32 val;
+	asm volatile("mrc p6, 0, %0, c7, c9, 0":"=r" (val));
+	return val;
+}
+static inline void write_wdtcr(u32 val)
+{
+	asm volatile("mcr p6, 0, %0, c7, c9, 0"::"r" (val));
+}
+
+/* WDTSR CP6 R8 Page 9 */
+static inline u32 read_wdtsr(void)
+{
+	u32 val;
+	asm volatile("mrc p6, 0, %0, c8, c9, 0":"=r" (val));
+	return val;
+}
+static inline void write_wdtsr(u32 val)
+{
+	asm volatile("mcr p6, 0, %0, c8, c9, 0"::"r" (val));
+}
+
+/* RCSR - Reset Cause Status Register  */
+static inline u32 read_rcsr(void)
+{
+	u32 val;
+	asm volatile("mrc p6, 0, %0, c0, c1, 0":"=r" (val));
+	return val;
+}
 #endif
 
 /*
@@ -486,4 +517,17 @@ static inline int iop13xx_cpu_id(void)
 #define IOP13XX_PBI_LR1       		IOP13XX_PBI_OFFSET(0x14)
 
 #define IOP13XX_PROCESSOR_FREQ		IOP13XX_REG_ADDR32(0x2180)
+
+/* Watchdog timer definitions */
+#define IOP_WDTCR_EN_ARM  	0x1e1e1e1e 
+#define IOP_WDTCR_EN      	0xe1e1e1e1 
+#define IOP13XX_WDTCR_DIS_ARM 	0x1f1f1f1f 
+#define IOP13XX_WDTCR_DIS     	0xf1f1f1f1 
+#define IOP13XX_WDTSR_WRITE_EN	(1 << 31) 
+#define IOP13XX_WDTCR_IB_RESET	(1 << 0) 
+
+/* Reset cause */
+#define IOP13XX_RCSR_WDT        (1 << 5) 
+#define IOP13XX_RCSR_COREID_MASK (0xF << 0)
+
 #endif /* _IOP13XX_HW_H_ */
diff --git a/include/asm-arm/arch-iop13xx/system.h b/include/asm-arm/arch-iop13xx/system.h
index 1278270..8575af8 100644
--- a/include/asm-arm/arch-iop13xx/system.h
+++ b/include/asm-arm/arch-iop13xx/system.h
@@ -13,43 +13,13 @@ static inline void arch_idle(void)
 	cpu_do_idle();
 }
 
-/* WDTCR CP6 R7 Page 9 */
-static inline u32 read_wdtcr(void)
-{
-	u32 val;
-	asm volatile("mrc p6, 0, %0, c7, c9, 0":"=r" (val));
-	return val;
-}
-static inline void write_wdtcr(u32 val)
-{
-	asm volatile("mcr p6, 0, %0, c7, c9, 0"::"r" (val));
-}
-
-/* WDTSR CP6 R8 Page 9 */
-static inline u32 read_wdtsr(void)
-{
-	u32 val;
-	asm volatile("mrc p6, 0, %0, c8, c9, 0":"=r" (val));
-	return val;
-}
-static inline void write_wdtsr(u32 val)
-{
-	asm volatile("mcr p6, 0, %0, c8, c9, 0"::"r" (val));
-}
-
-#define IOP13XX_WDTCR_EN_ARM	0x1e1e1e1e
-#define IOP13XX_WDTCR_EN	0xe1e1e1e1
-#define IOP13XX_WDTCR_DIS_ARM	0x1f1f1f1f
-#define IOP13XX_WDTCR_DIS	0xf1f1f1f1
-#define IOP13XX_WDTSR_WRITE_EN	(1 << 31)
-#define IOP13XX_WDTCR_IB_RESET	(1 << 0)
 static inline void arch_reset(char mode)
 {
 	/*
 	 * Reset the internal bus (warning both cores are reset)
 	 */
-	write_wdtcr(IOP13XX_WDTCR_EN_ARM);
-	write_wdtcr(IOP13XX_WDTCR_EN);
+	write_wdtcr(IOP_WDTCR_EN_ARM);
+	write_wdtcr(IOP_WDTCR_EN);
 	write_wdtsr(IOP13XX_WDTSR_WRITE_EN | IOP13XX_WDTCR_IB_RESET);
 	write_wdtcr(0x1000);
 
diff --git a/include/asm-arm/hardware/iop3xx.h b/include/asm-arm/hardware/iop3xx.h
index 15141a9..4d94e5b 100644
--- a/include/asm-arm/hardware/iop3xx.h
+++ b/include/asm-arm/hardware/iop3xx.h
@@ -193,6 +193,10 @@ extern void gpio_line_set(int line, int value);
 #define IOP_TMR_PRIVILEGED 0x08
 #define IOP_TMR_RATIO_1_1  0x00
 
+/* Watchdog timer definitions */ 
+#define IOP_WDTCR_EN_ARM        0x1e1e1e1e 
+#define IOP_WDTCR_EN            0xe1e1e1e1 
+
 /* Application accelerator unit  */
 #define IOP3XX_AAU_ACR		(volatile u32 *)IOP3XX_REG_ADDR(0x0800)
 #define IOP3XX_AAU_ASR		(volatile u32 *)IOP3XX_REG_ADDR(0x0804)
@@ -315,6 +319,17 @@ static inline void write_tisr(u32 val)
 	asm volatile("mcr p6, 0, %0, c6, c1, 0" : : "r" (val));
 }
 
+static inline u32 read_wdtcr(void)
+{
+	u32 val;
+	asm volatile("mrc p6, 0, %0, c7, c1, 0":"=r" (val));
+	return val;
+}
+static inline void write_wdtcr(u32 val)
+{
+	asm volatile("mcr p6, 0, %0, c7, c1, 0"::"r" (val));
+}
+
 extern struct platform_device iop3xx_i2c0_device;
 extern struct platform_device iop3xx_i2c1_device;
 
