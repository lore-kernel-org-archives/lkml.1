Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbXGXSUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbXGXSUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXGXSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:20:38 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:2432 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751274AbXGXSUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:20:37 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:20:36 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] mv64x60_wdt_cleanup_low_level_wdt_code.patch
Message-ID: <20070724182035.GK27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the timeout config register modification into a single
function.  Also, use the enabled flag in the config register to
determine whether the timer is enabled instead of a separately
maintained flag, MV64x60_WDOG_FLAG_ENABLED.

Add spinlock protection around enabling/disabling the watchdog timer.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   85 +++++++++++++++-----------
 1 file changed, 51 insertions(+), 34 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 20:05:04.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-21 12:51:59.000000000 +0000
@@ -26,78 +26,97 @@
 #include <linux/mv643xx.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <linux/delay.h>
 
 #define MV64x60_WDT_WDC_OFFSET	0
 
-/* MV64x60 WDC (config) register access definitions */
-#define MV64x60_WDC_CTL1_MASK	(3 << 24)
-#define MV64x60_WDC_CTL1(val)	((val & 3) << 24)
-#define MV64x60_WDC_CTL2_MASK	(3 << 26)
-#define MV64x60_WDC_CTL2(val)	((val & 3) << 26)
+/*
+ * The watchdog configuration register contains a pair of 2-bit fields,
+ *   1.  a reload field, bits 27-26, which triggers a reload of
+ *       the countdown register, and
+ *   2.  an enable field, bits 25-24, which toggles between
+ *       enabling and disabling the watchdog timer.
+ * Bit 31 is a read-only field which indicates whether the
+ * watchdog timer is currently enabled.
+ *
+ * The low 24 bits contain the timer reload value.
+ */
+#define MV64x60_WDC_ENABLE_SHIFT	24
+#define MV64x60_WDC_LOAD_SHIFT		26
+#define MV64x60_WDC_ENABLED_SHIFT	31
 
 /* Flags bits */
 #define MV64x60_WDOG_FLAG_OPENED	0
-#define MV64x60_WDOG_FLAG_ENABLED	1
 
 static unsigned long wdt_flags;
 static int wdt_status;
 static void __iomem *mv64x60_wdt_regs;
 static int mv64x60_wdt_timeout;
+static int mv64x60_wdt_count;
 static unsigned int bus_clk;
 static char expect_close;
+static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static void mv64x60_wdt_reg_write(u32 val)
+static void mv64x60_wdt_update_wdc(int field_shift)
 {
-	/* Allow write only to CTL1 / CTL2 fields, retaining values in
-	 * other fields.
-	 */
-	u32 data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
-	data &= ~(MV64x60_WDC_CTL1_MASK | MV64x60_WDC_CTL2_MASK);
-	data |= val;
+	u32 data;
+
+	/* We write a 1, then a 2 -- to the appropriate field */
+	data = (1 << field_shift) | mv64x60_wdt_count;
+	writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+
+	data = (2 << field_shift) | mv64x60_wdt_count;
 	writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
 }
 
 static void mv64x60_wdt_service(void)
 {
-	/* Write 01 followed by 10 to CTL2 */
-	mv64x60_wdt_reg_write(MV64x60_WDC_CTL2(0x01));
-	mv64x60_wdt_reg_write(MV64x60_WDC_CTL2(0x02));
+	spin_lock(&mv64x60_wdt_spinlock);
+	mv64x60_wdt_update_wdc(MV64x60_WDC_LOAD_SHIFT);
+	spin_unlock(&mv64x60_wdt_spinlock);
 }
 
-static void mv64x60_wdt_handler_disable(void)
+static void mv64x60_wdt_handler_enable(void)
 {
-	if (test_and_clear_bit(MV64x60_WDOG_FLAG_ENABLED, &wdt_flags)) {
-		/* Write 01 followed by 10 to CTL1 */
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x01));
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x02));
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog deactivated\n");
+	u32 data;
+
+	spin_lock(&mv64x60_wdt_spinlock);
+	data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+
+	if (!(data & (1 << MV64x60_WDC_ENABLED_SHIFT))) {
+		mv64x60_wdt_update_wdc(MV64x60_WDC_ENABLE_SHIFT);
+		mv64x60_wdt_service();
+		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
 	}
+	spin_unlock(&mv64x60_wdt_spinlock);
 }
 
-static void mv64x60_wdt_handler_enable(void)
+static void mv64x60_wdt_handler_disable(void)
 {
-	if (!test_and_set_bit(MV64x60_WDOG_FLAG_ENABLED, &wdt_flags)) {
-		/* Write 01 followed by 10 to CTL1 */
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x01));
-		mv64x60_wdt_reg_write(MV64x60_WDC_CTL1(0x02));
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
+	u32 data;
+
+	spin_lock(&mv64x60_wdt_spinlock);
+	data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
+
+	if (data & (1 << MV64x60_WDC_ENABLED_SHIFT)) {
+		mv64x60_wdt_update_wdc(MV64x60_WDC_ENABLE_SHIFT);
+		printk(KERN_NOTICE "mv64x60_wdt: watchdog deactivated\n");
 	}
+	spin_unlock(&mv64x60_wdt_spinlock);
 }
 
-static void mv64x60_wdt_set_timeout(int timeout)
+static void mv64x60_wdt_set_timeout(unsigned int timeout)
 {
 	/* maximum bus cycle count is 0xFFFFFFFF */
 	if (timeout > 0xFFFFFFFF / bus_clk)
 		timeout = 0xFFFFFFFF / bus_clk;
 
+	mv64x60_wdt_count = timeout * bus_clk >> 8;
 	mv64x60_wdt_timeout = timeout;
-	writel((timeout * bus_clk) >> 8,
-	       mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
-	mv64x60_wdt_service();
 }
 
 static int mv64x60_wdt_open(struct inode *inode, struct file *file)
@@ -108,7 +127,6 @@ static int mv64x60_wdt_open(struct inode
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	mv64x60_wdt_service();
 	mv64x60_wdt_handler_enable();
 
 	return nonseekable_open(inode, file);
@@ -270,7 +288,6 @@ static int __devexit mv64x60_wdt_remove(
 {
 	misc_deregister(&mv64x60_wdt_miscdev);
 
-	mv64x60_wdt_service();
 	mv64x60_wdt_handler_disable();
 
 	iounmap(mv64x60_wdt_regs);

