Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbZHENVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbZHENVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbZHENVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:21:08 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:50888 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbZHENVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MajOutcGUa0H34hzvMb4+vjpwrVi+XSY7PgeNZ8Qd0ZeqbW+fd30cClG+iH7kq8ZDj
         eNJaK9dvH0EPW5uVE9l4+q0TQxb+dq45lzet+4gxvOhhs2H321At4H7bVMsHA1iAQO3Z
         dLD1Q83COpVOpheUTQBEQlgO+Sk8NdJXxLvn8=
Message-ID: <4A79873A.5010504@gmail.com>
Date: Wed, 05 Aug 2009 21:20:58 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add watchdog driver for w90p910
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com> <20090805070822.GC30892@infomag.iguana.be> <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com> <20090805103127.GF30892@infomag.iguana.be>
In-Reply-To: <20090805103127.GF30892@infomag.iguana.be>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wim,

Maybe I did not know well regarding linux watchdog driver before, but, now Via your help 
and researching further the timer used in watchdog driver,I rewrite my wdt driver, Now, I
can set any time interval in userspace rather than setting the time level. :)


Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/watchdog/Kconfig       |    9 +
 drivers/watchdog/Makefile      |    1 +
 drivers/watchdog/w90p910_wdt.c |  330 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/w90p910_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b1ccc04..fba4b91 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -266,6 +266,15 @@ config STMP3XXX_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called stmp3xxx_wdt.
 
+config W90P910_WATCHDOG
+	tristate "Nuvoton W90P910 watchdog"
+	depends on ARCH_W90X900
+	help
+	  Say Y here if to include support for the watchdog timer
+	  for the Nuvoton W90P910 SoC.
+	  To compile this driver as a module, choose M here: the
+	  module will be called w90p910_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 3d77429..ecc05b4 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
+obj-$(CONFIG_W90P910_WATCHDOG) += w90p910_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/w90p910_wdt.c b/drivers/watchdog/w90p910_wdt.c
new file mode 100644
index 0000000..4e954c3
--- /dev/null
+++ b/drivers/watchdog/w90p910_wdt.c
@@ -0,0 +1,330 @@
+/*
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+
+#define REG_WTCR		0x1c
+#define WTCLK			(0x01 << 10)
+#define WTE			(0x01 << 7)	/*wdt enable*/
+#define WTISBIT			(0x04)
+#define WTIS			(0x03 << 4)
+#define WTIF			(0x01 << 3)
+#define WTRF			(0x01 << 2)
+#define WTRE			(0x01 << 1)
+#define WTR			0x01
+#define WDT_TIMEOUT		(HZ/2)
+#define WDT_HEARTBEAT		15
+#define WDT_HW_TIMEOUT		0x02 /* 4 seconds */
+
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
+	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct w90p910_wdt {
+	struct resource  *res;
+	struct clk	 *wdt_clock;
+	struct platform_device *pdev;
+	void __iomem	 *wdt_base;
+	char		 expect_close;
+	struct timer_list timer;
+	spinlock_t       wdt_lock;
+	unsigned long next_heartbeat;
+};
+
+static unsigned long w90p910wdt_busy;
+struct w90p910_wdt *w90p910_wdt;
+
+static inline void w90p910_wdt_keepalive(void)
+{
+	unsigned int val;
+
+	spin_lock(&w90p910_wdt->wdt_lock);
+
+	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
+	val |= (WTR | WTIF);
+	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&w90p910_wdt->wdt_lock);
+}
+
+static inline void w90p910_wdt_start(void)
+{
+	unsigned int val;
+
+	spin_lock(&w90p910_wdt->wdt_lock);
+
+	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
+	val |= (WTRE | WTE | WTR | WTCLK | WTIF);
+	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&w90p910_wdt->wdt_lock);
+}
+
+static int w90p910_wdt_settimeout(unsigned int timeout)
+{
+	unsigned int val;
+	spin_lock(&w90p910_wdt->wdt_lock);
+
+	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
+	val &= ~WTIS;
+	val |= (timeout << 0x04);
+	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&w90p910_wdt->wdt_lock);
+
+	return 0;
+}
+
+static int w90p910_wdt_open(struct inode *inode, struct file *file)
+{
+
+	if (test_and_set_bit(0, &w90p910wdt_busy))
+		return -EBUSY;
+
+	w90p910_wdt_start();
+	w90p910_wdt_settimeout(WDT_HW_TIMEOUT);
+
+	w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+	mod_timer(&w90p910_wdt->timer, jiffies + WDT_TIMEOUT);
+
+	return nonseekable_open(inode, file);
+}
+
+static int w90p910_wdt_close(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &w90p910wdt_busy);
+
+	if (!w90p910_wdt->expect_close)
+		del_timer(&w90p910_wdt->timer);
+
+	w90p910_wdt->expect_close = 0;
+	return 0;
+}
+
+static struct watchdog_info w90p910_wdt_info = {
+	.identity	= "w90p910 watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
+};
+
+static long w90p910_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &w90p910_wdt_info,
+				sizeof(w90p910_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		heartbeat = new_value;
+		w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+
+		return put_user(new_value, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static ssize_t w90p910_wdt_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	/* Scan for magic character */
+	if (!nowayout) {
+		size_t i;
+
+		w90p910_wdt->expect_close = 0;
+
+		for (i = 0; i < len; i++) {
+			char c;
+			if (get_user(c, data + i))
+				return -EFAULT;
+			if (c == 'V') {
+				w90p910_wdt->expect_close = 42;
+				break;
+			}
+		}
+	}
+
+	w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+	return len;
+}
+
+static void w90p910_ping(unsigned long data)
+{
+	if (time_before(jiffies, w90p910_wdt->next_heartbeat) ||
+			(!nowayout && !w90p910wdt_busy)) {
+		w90p910_wdt_keepalive();
+		mod_timer(&w90p910_wdt->timer, jiffies + WDT_TIMEOUT);
+	} else
+		dev_warn(&w90p910_wdt->pdev->dev, "Will reset the machine !\n");
+}
+
+static const struct file_operations w90p910wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= w90p910_wdt_ioctl,
+	.open		= w90p910_wdt_open,
+	.release	= w90p910_wdt_close,
+	.write		= w90p910_wdt_write,
+};
+
+static struct miscdevice w90p910wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &w90p910wdt_fops,
+};
+
+static int __devinit w90p910wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	w90p910_wdt = kzalloc(sizeof(struct w90p910_wdt), GFP_KERNEL);
+	if (!w90p910_wdt)
+		return -ENOMEM;
+
+	w90p910_wdt->pdev = pdev;
+
+	spin_lock_init(&w90p910_wdt->wdt_lock);
+
+	w90p910_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (w90p910_wdt->res == NULL) {
+		dev_err(&pdev->dev, "no memory resource specified\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	if (!request_mem_region(w90p910_wdt->res->start,
+				resource_size(w90p910_wdt->res), pdev->name)) {
+		dev_err(&pdev->dev, "failed to get memory region\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	w90p910_wdt->wdt_base = ioremap(w90p910_wdt->res->start,
+					resource_size(w90p910_wdt->res));
+	if (w90p910_wdt->wdt_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap() region\n");
+		ret = -EINVAL;
+		goto err_req;
+	}
+
+	w90p910_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(w90p910_wdt->wdt_clock)) {
+		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
+		ret = PTR_ERR(w90p910_wdt->wdt_clock);
+		goto err_map;
+	}
+
+	clk_enable(w90p910_wdt->wdt_clock);
+
+	if (misc_register(&w90p910wdt_miscdev)) {
+		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto err_clk;
+	}
+
+	setup_timer(&w90p910_wdt->timer, w90p910_ping, 0);
+
+	return 0;
+
+err_clk:
+	clk_disable(w90p910_wdt->wdt_clock);
+	clk_put(w90p910_wdt->wdt_clock);
+err_map:
+	iounmap(w90p910_wdt->wdt_base);
+err_req:
+	release_mem_region(w90p910_wdt->res->start,
+					resource_size(w90p910_wdt->res));
+err_get:
+	kfree(w90p910_wdt);
+	return ret;
+}
+
+static int __devexit w90p910wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&w90p910wdt_miscdev);
+
+	clk_disable(w90p910_wdt->wdt_clock);
+	clk_put(w90p910_wdt->wdt_clock);
+
+	iounmap(w90p910_wdt->wdt_base);
+
+	release_mem_region(w90p910_wdt->res->start,
+					resource_size(w90p910_wdt->res));
+
+	kfree(w90p910_wdt);
+
+	return 0;
+}
+
+static struct platform_driver w90p910wdt_driver = {
+	.probe		= w90p910wdt_probe,
+	.remove		= __devexit_p(w90p910wdt_remove),
+	.driver		= {
+		.name	= "w90p910-wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init w90p910_wdt_init(void)
+{
+	return platform_driver_register(&w90p910wdt_driver);
+}
+
+static void __exit w90p910_wdt_exit(void)
+{
+	platform_driver_unregister(&w90p910wdt_driver);
+}
+
+module_init(w90p910_wdt_init);
+module_exit(w90p910_wdt_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("Watchdog driver for W90P910");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:w90p910-wdt");
-- 
1.5.6.3
 

