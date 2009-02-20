Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZBTPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZBTPrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZBTPq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:46:57 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35439 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753897AbZBTPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:46:54 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Kyle McMartin <kyle@mcmartin.ca>,
       David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 2/5] pa-risc: Rename rtc-parisc to rtc-generic
Date: Fri, 20 Feb 2009 16:46:46 +0100
Message-Id: <1235144809-32468-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235144809-32468-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235144809-32468-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-parisc driver is not PA-RISC specific at all, as it uses the existing
generic RTC infrastructure ([gs]et_rtc_time()).
Rename the driver from rtc-parisc to rtc-generic, and make it depend on the new
Kconfig symbol ARCH_HAS_GENERIC_RTC.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/parisc/Kconfig       |    6 ++-
 arch/parisc/kernel/time.c |    6 +-
 drivers/rtc/Kconfig       |   10 ++--
 drivers/rtc/Makefile      |    2 +-
 drivers/rtc/rtc-generic.c |  113 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-parisc.c  |  113 ---------------------------------------------
 6 files changed, 127 insertions(+), 123 deletions(-)
 create mode 100644 drivers/rtc/rtc-generic.c
 delete mode 100644 drivers/rtc/rtc-parisc.c

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index aacf11d..cacb3a1 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -10,7 +10,7 @@ config PARISC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select RTC_CLASS
-	select RTC_DRV_PARISC
+	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
@@ -43,6 +43,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_HAS_GENERIC_RTC
+	bool
+	default y
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 9d46c43..849f460 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -216,8 +216,8 @@ void __init start_cpu_itimer(void)
 	per_cpu(cpu_data, cpu).it_value = next_tick;
 }
 
-struct platform_device rtc_parisc_dev = {
-	.name = "rtc-parisc",
+static struct platform_device rtc_generic_dev = {
+	.name = "rtc-generic",
 	.id = -1,
 };
 
@@ -225,7 +225,7 @@ static int __init rtc_init(void)
 {
 	int ret;
 
-	ret = platform_device_register(&rtc_parisc_dev);
+	ret = platform_device_register(&rtc_generic_dev);
 	if (ret < 0)
 		printk(KERN_ERR "unable to register rtc device...\n");
 
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 81450fb..3e58182 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -677,12 +677,12 @@ config RTC_DRV_RS5C313
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
-config RTC_DRV_PARISC
-	tristate "PA-RISC firmware RTC support"
-	depends on PARISC
+config RTC_DRV_GENERIC
+	tristate "Generic RTC support"
+	depends on ARCH_HAS_GENERIC_RTC
 	help
-	  Say Y or M here to enable RTC support on PA-RISC systems using
-	  firmware calls. If you do not know what you are doing, you should
+	  Say Y or M here to enable RTC support on systems using the generic
+	  RTC abstraction. If you do not know what you are doing, you should
 	  just say Y.
 
 config RTC_DRV_PPC
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 0e697aa..9c18a01 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -55,7 +55,7 @@ obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
-obj-$(CONFIG_RTC_DRV_PARISC)	+= rtc-parisc.o
+obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
 obj-$(CONFIG_RTC_DRV_PPC)	+= rtc-ppc.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
diff --git a/drivers/rtc/rtc-generic.c b/drivers/rtc/rtc-generic.c
new file mode 100644
index 0000000..b744c7d
--- /dev/null
+++ b/drivers/rtc/rtc-generic.c
@@ -0,0 +1,113 @@
+/* rtc-generic: RTC driver using the generic RTC abstraction
+ *
+ * Copyright (C) 2008 Kyle McMartin <kyle@mcmartin.ca>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/platform_device.h>
+
+#include <asm/rtc.h>
+
+/* as simple as can be, and no simpler. */
+struct generic_rtc {
+	struct rtc_device *rtc;
+	spinlock_t lock;
+};
+
+static int generic_get_time(struct device *dev, struct rtc_time *tm)
+{
+	struct generic_rtc *p = dev_get_drvdata(dev);
+	unsigned long flags, ret;
+
+	spin_lock_irqsave(&p->lock, flags);
+	ret = get_rtc_time(tm);
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	if (ret & RTC_BATT_BAD)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int generic_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct generic_rtc *p = dev_get_drvdata(dev);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&p->lock, flags);
+	ret = set_rtc_time(tm);
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	if (ret < 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static const struct rtc_class_ops generic_rtc_ops = {
+	.read_time = generic_get_time,
+	.set_time = generic_set_time,
+};
+
+static int __devinit generic_rtc_probe(struct platform_device *dev)
+{
+	struct generic_rtc *p;
+
+	p = kzalloc(sizeof (*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	spin_lock_init(&p->lock);
+
+	p->rtc = rtc_device_register("rtc-generic", &dev->dev,
+				     &generic_rtc_ops, THIS_MODULE);
+	if (IS_ERR(p->rtc)) {
+		int err = PTR_ERR(p->rtc);
+		kfree(p);
+		return err;
+	}
+
+	platform_set_drvdata(dev, p);
+
+	return 0;
+}
+
+static int __devexit generic_rtc_remove(struct platform_device *dev)
+{
+	struct generic_rtc *p = platform_get_drvdata(dev);
+
+	rtc_device_unregister(p->rtc);
+	kfree(p);
+
+	return 0;
+}
+
+static struct platform_driver generic_rtc_driver = {
+	.driver = {
+		.name = "rtc-generic",
+		.owner = THIS_MODULE,
+	},
+	.probe = generic_rtc_probe,
+	.remove = __devexit_p(generic_rtc_remove),
+};
+
+static int __init generic_rtc_init(void)
+{
+	return platform_driver_register(&generic_rtc_driver);
+}
+
+static void __exit generic_rtc_fini(void)
+{
+	platform_driver_unregister(&generic_rtc_driver);
+}
+
+module_init(generic_rtc_init);
+module_exit(generic_rtc_fini);
+
+MODULE_AUTHOR("Kyle McMartin <kyle@mcmartin.ca>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic RTC driver");
+MODULE_ALIAS("platform:rtc-generic");
diff --git a/drivers/rtc/rtc-parisc.c b/drivers/rtc/rtc-parisc.c
deleted file mode 100644
index 28fb7d3..0000000
--- a/drivers/rtc/rtc-parisc.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/* rtc-parisc: RTC for HP PA-RISC firmware
- *
- * Copyright (C) 2008 Kyle McMartin <kyle@mcmartin.ca>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/time.h>
-#include <linux/platform_device.h>
-
-#include <asm/rtc.h>
-
-/* as simple as can be, and no simpler. */
-struct parisc_rtc {
-	struct rtc_device *rtc;
-	spinlock_t lock;
-};
-
-static int parisc_get_time(struct device *dev, struct rtc_time *tm)
-{
-	struct parisc_rtc *p = dev_get_drvdata(dev);
-	unsigned long flags, ret;
-
-	spin_lock_irqsave(&p->lock, flags);
-	ret = get_rtc_time(tm);
-	spin_unlock_irqrestore(&p->lock, flags);
-
-	if (ret & RTC_BATT_BAD)
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
-static int parisc_set_time(struct device *dev, struct rtc_time *tm)
-{
-	struct parisc_rtc *p = dev_get_drvdata(dev);
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&p->lock, flags);
-	ret = set_rtc_time(tm);
-	spin_unlock_irqrestore(&p->lock, flags);
-
-	if (ret < 0)
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
-static const struct rtc_class_ops parisc_rtc_ops = {
-	.read_time = parisc_get_time,
-	.set_time = parisc_set_time,
-};
-
-static int __devinit parisc_rtc_probe(struct platform_device *dev)
-{
-	struct parisc_rtc *p;
-
-	p = kzalloc(sizeof (*p), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	spin_lock_init(&p->lock);
-
-	p->rtc = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
-					THIS_MODULE);
-	if (IS_ERR(p->rtc)) {
-		int err = PTR_ERR(p->rtc);
-		kfree(p);
-		return err;
-	}
-
-	platform_set_drvdata(dev, p);
-
-	return 0;
-}
-
-static int __devexit parisc_rtc_remove(struct platform_device *dev)
-{
-	struct parisc_rtc *p = platform_get_drvdata(dev);
-
-	rtc_device_unregister(p->rtc);
-	kfree(p);
-
-	return 0;
-}
-
-static struct platform_driver parisc_rtc_driver = {
-	.driver = {
-		.name = "rtc-parisc",
-		.owner = THIS_MODULE,
-	},
-	.probe = parisc_rtc_probe,
-	.remove = __devexit_p(parisc_rtc_remove),
-};
-
-static int __init parisc_rtc_init(void)
-{
-	return platform_driver_register(&parisc_rtc_driver);
-}
-
-static void __exit parisc_rtc_fini(void)
-{
-	platform_driver_unregister(&parisc_rtc_driver);
-}
-
-module_init(parisc_rtc_init);
-module_exit(parisc_rtc_fini);
-
-MODULE_AUTHOR("Kyle McMartin <kyle@mcmartin.ca>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("HP PA-RISC RTC driver");
-MODULE_ALIAS("platform:rtc-parisc");
-- 
1.6.0.4

