Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbZCNB2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbZCNB2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZCNBUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:14 -0400
Received: from kroah.org ([198.145.64.141]:34959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751028AbZCNBUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:35 2009
Message-Id: <20090314011034.945641959@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Phil Sutter <n0-1@freewrt.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [patch 024/114] WATCHDOG: rc32434_wdt: fix watchdog driver
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=watchdog-rc32434_wdt-fix-watchdog-driver.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Sutter <n0-1@freewrt.org>

commit 0af98d37e85e6958eb84987b1f60da3b54008317 upstream.

The existing driver code wasn't working. Neither the timeout was set
correctly, nor system reset was being triggered, as the driver seemed
to keep the WDT alive himself. There was also some unnecessary code.

Signed-off-by: Phil Sutter <n0-1@freewrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/rc32434_wdt.c |  158 ++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 94 deletions(-)

--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -34,104 +34,89 @@
 #include <asm/time.h>
 #include <asm/mach-rc32434/integ.h>
 
-#define MAX_TIMEOUT			20
-#define RC32434_WDT_INTERVAL		(15 * HZ)
-
-#define VERSION "0.2"
+#define VERSION "0.3"
 
 static struct {
-	struct completion stop;
-	int running;
-	struct timer_list timer;
-	int queue;
-	int default_ticks;
 	unsigned long inuse;
 } rc32434_wdt_device;
 
 static struct integ __iomem *wdt_reg;
-static int ticks = 100 * HZ;
 
 static int expect_close;
-static int timeout;
+
+/* Board internal clock speed in Hz,
+ * the watchdog timer ticks at. */
+extern unsigned int idt_cpu_freq;
+
+/* translate wtcompare value to seconds and vice versa */
+#define WTCOMP2SEC(x)	(x / idt_cpu_freq)
+#define SEC2WTCOMP(x)	(x * idt_cpu_freq)
+
+/* Use a default timeout of 20s. This should be
+ * safe for CPU clock speeds up to 400MHz, as
+ * ((2 ^ 32) - 1) / (400MHz / 2) = 21s.  */
+#define WATCHDOG_TIMEOUT 20
+
+static int timeout = WATCHDOG_TIMEOUT;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+/* apply or and nand masks to data read from addr and write back */
+#define SET_BITS(addr, or, nand) \
+	writel((readl(&addr) | or) & ~nand, &addr)
 
 static void rc32434_wdt_start(void)
 {
-	u32 val;
+	u32 or, nand;
 
-	if (!rc32434_wdt_device.inuse) {
-		writel(0, &wdt_reg->wtcount);
+	/* zero the counter before enabling */
+	writel(0, &wdt_reg->wtcount);
 
-		val = RC32434_ERR_WRE;
-		writel(readl(&wdt_reg->errcs) | val, &wdt_reg->errcs);
+	/* don't generate a non-maskable interrupt,
+	 * do a warm reset instead */
+	nand = 1 << RC32434_ERR_WNE;
+	or = 1 << RC32434_ERR_WRE;
 
-		val = RC32434_WTC_EN;
-		writel(readl(&wdt_reg->wtc) | val, &wdt_reg->wtc);
-	}
-	rc32434_wdt_device.running++;
-}
+	/* reset the ERRCS timeout bit in case it's set */
+	nand |= 1 << RC32434_ERR_WTO;
 
-static void rc32434_wdt_stop(void)
-{
-	u32 val;
-
-	if (rc32434_wdt_device.running) {
+	SET_BITS(wdt_reg->errcs, or, nand);
 
-		val = ~RC32434_WTC_EN;
-		writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
+	/* reset WTC timeout bit and enable WDT */
+	nand = 1 << RC32434_WTC_TO;
+	or = 1 << RC32434_WTC_EN;
 
-		val = ~RC32434_ERR_WRE;
-		writel(readl(&wdt_reg->errcs) & val, &wdt_reg->errcs);
+	SET_BITS(wdt_reg->wtc, or, nand);
+}
 
-		rc32434_wdt_device.running = 0;
-	}
+static void rc32434_wdt_stop(void)
+{
+	/* Disable WDT */
+	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
 }
 
-static void rc32434_wdt_set(int new_timeout)
+static int rc32434_wdt_set(int new_timeout)
 {
-	u32 cmp = new_timeout * HZ;
-	u32 state, val;
+	int max_to = WTCOMP2SEC((u32)-1);
 
+	if (new_timeout < 0 || new_timeout > max_to) {
+		printk(KERN_ERR KBUILD_MODNAME
+			": timeout value must be between 0 and %d",
+			max_to);
+		return -EINVAL;
+	}
 	timeout = new_timeout;
-	/*
-	 * store and disable WTC
-	 */
-	state = (u32)(readl(&wdt_reg->wtc) & RC32434_WTC_EN);
-	val = ~RC32434_WTC_EN;
-	writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
-
-	writel(0, &wdt_reg->wtcount);
-	writel(cmp, &wdt_reg->wtcompare);
-
-	/*
-	 * restore WTC
-	 */
+	writel(SEC2WTCOMP(timeout), &wdt_reg->wtcompare);
 
-	writel(readl(&wdt_reg->wtc) | state, &wdt_reg);
-}
-
-static void rc32434_wdt_reset(void)
-{
-	ticks = rc32434_wdt_device.default_ticks;
+	return 0;
 }
 
-static void rc32434_wdt_update(unsigned long unused)
+static void rc32434_wdt_ping(void)
 {
-	if (rc32434_wdt_device.running)
-		ticks--;
-
 	writel(0, &wdt_reg->wtcount);
-
-	if (rc32434_wdt_device.queue && ticks)
-		mod_timer(&rc32434_wdt_device.timer,
-			jiffies + RC32434_WDT_INTERVAL);
-	else
-		complete(&rc32434_wdt_device.stop);
 }
 
 static int rc32434_wdt_open(struct inode *inode, struct file *file)
@@ -142,19 +127,23 @@ static int rc32434_wdt_open(struct inode
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
+	rc32434_wdt_start();
+	rc32434_wdt_ping();
+
 	return nonseekable_open(inode, file);
 }
 
 static int rc32434_wdt_release(struct inode *inode, struct file *file)
 {
-	if (expect_close && nowayout == 0) {
+	if (expect_close == 42) {
 		rc32434_wdt_stop();
 		printk(KERN_INFO KBUILD_MODNAME ": disabling watchdog timer\n");
 		module_put(THIS_MODULE);
-	} else
+	} else {
 		printk(KERN_CRIT KBUILD_MODNAME
 			": device closed unexpectedly. WDT will not stop !\n");
-
+		rc32434_wdt_ping();
+	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
 	return 0;
 }
@@ -174,10 +163,10 @@ static ssize_t rc32434_wdt_write(struct 
 				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
-					expect_close = 1;
+					expect_close = 42;
 			}
 		}
-		rc32434_wdt_update(0);
+		rc32434_wdt_ping();
 		return len;
 	}
 	return 0;
@@ -197,11 +186,11 @@ static long rc32434_wdt_ioctl(struct fil
 	};
 	switch (cmd) {
 	case WDIOC_KEEPALIVE:
-		rc32434_wdt_reset();
+		rc32434_wdt_ping();
 		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		value = readl(&wdt_reg->wtcount);
+		value = 0;
 		if (copy_to_user(argp, &value, sizeof(int)))
 			return -EFAULT;
 		break;
@@ -218,6 +207,7 @@ static long rc32434_wdt_ioctl(struct fil
 			break;
 		case WDIOS_DISABLECARD:
 			rc32434_wdt_stop();
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -225,11 +215,9 @@ static long rc32434_wdt_ioctl(struct fil
 	case WDIOC_SETTIMEOUT:
 		if (copy_from_user(&new_timeout, argp, sizeof(int)))
 			return -EFAULT;
-		if (new_timeout < 1)
+		if (rc32434_wdt_set(new_timeout))
 			return -EINVAL;
-		if (new_timeout > MAX_TIMEOUT)
-			return -EINVAL;
-		rc32434_wdt_set(new_timeout);
+		/* Fall through */
 	case WDIOC_GETTIMEOUT:
 		return copy_to_user(argp, &timeout, sizeof(int));
 	default:
@@ -262,7 +250,7 @@ static int rc32434_wdt_probe(struct plat
 	int ret;
 	struct resource *r;
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb500_wdt_res");
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
 		printk(KERN_ERR KBUILD_MODNAME
 			"failed to retrieve resources\n");
@@ -277,24 +265,12 @@ static int rc32434_wdt_probe(struct plat
 	}
 
 	ret = misc_register(&rc32434_wdt_miscdev);
-
 	if (ret < 0) {
 		printk(KERN_ERR KBUILD_MODNAME
 			"failed to register watchdog device\n");
 		goto unmap;
 	}
 
-	init_completion(&rc32434_wdt_device.stop);
-	rc32434_wdt_device.queue = 0;
-
-	clear_bit(0, &rc32434_wdt_device.inuse);
-
-	setup_timer(&rc32434_wdt_device.timer, rc32434_wdt_update, 0L);
-
-	rc32434_wdt_device.default_ticks = ticks;
-
-	rc32434_wdt_start();
-
 	printk(banner, timeout);
 
 	return 0;
@@ -306,14 +282,8 @@ unmap:
 
 static int rc32434_wdt_remove(struct platform_device *pdev)
 {
-	if (rc32434_wdt_device.queue) {
-		rc32434_wdt_device.queue = 0;
-		wait_for_completion(&rc32434_wdt_device.stop);
-	}
 	misc_deregister(&rc32434_wdt_miscdev);
-
 	iounmap(wdt_reg);
-
 	return 0;
 }
 


