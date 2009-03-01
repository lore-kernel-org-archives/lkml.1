Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZCAAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZCAAbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZCAAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:30:50 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:35276 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZCAAat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:30:49 -0500
Date: Sun, 1 Mar 2009 02:30:18 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090301003014.GA22673@frodo>
Reply-To: me@felipebalbi.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090228141725.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228141725.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 02:23:03PM -0800, Dmitry Torokhov wrote:
> Hi Felipe,
> 
> On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> > From: Felipe Balbi <felipe.balbi@nokia.com>
> > 
> > This is part of the twl4030 multifunction device driver.
> > 
> > With this driver we add support for reporting KEY_POWER
> > events via the input layer.
> 
> ...

thanks for reviewing, how about the version below:

========== cut here ==========

>From 60c4980bc13b08c73aa5b647cda6ef540ac94939 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Fri, 27 Feb 2009 21:18:15 +0200
Subject: [PATCH] input: misc: add twl4030-pwrbutton driver

This is part of the twl4030 multifunction device driver.

With this driver we add support for reporting KEY_POWER
events via the input layer.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/input/misc/Kconfig             |    4 +
 drivers/input/misc/Makefile            |    1 +
 drivers/input/misc/twl4030-pwrbutton.c |  147 ++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/twl4030-pwrbutton.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 67e5553..9667b50 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -193,6 +193,10 @@ config INPUT_CM109
 	  To compile this driver as a module, choose M here: the module will be
 	  called cm109.
 
+config INPUT_TWL4030_PWRBUTTON
+	tristate "TWL4030 Power button Driver"
+	depends on TWL4030_CORE
+
 config INPUT_UINPUT
 	tristate "User level driver support"
 	help
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index bb62e6e..2fabcdb 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
new file mode 100644
index 0000000..cf55583
--- /dev/null
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -0,0 +1,147 @@
+/**
+ * twl4030-pwrbutton.c - TWL4030 Power Button Input Driver
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Written by Peter De Schrijver <peter.de-schrijver@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+
+#define PWR_PWRON_IRQ (1 << 0)
+
+#define STS_HW_CONDITIONS 0xf
+
+static struct input_dev *powerbutton_dev;
+static struct device *dbg_dev;
+
+static irqreturn_t powerbutton_irq(int irq, void *dev_id)
+{
+	int err;
+	u8 value;
+
+#ifdef CONFIG_LOCKDEP
+	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
+	 * we don't want and can't tolerate.  Although it might be
+	 * friendlier not to borrow this thread context...
+	 */
+	local_irq_enable();
+#endif
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
+				  STS_HW_CONDITIONS);
+	if (!err)  {
+		input_report_key(powerbutton_dev, KEY_POWER,
+				 value & PWR_PWRON_IRQ);
+		input_sync(powerbutton_dev);
+	} else {
+		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
+			" PM_MASTER STS_HW_CONDITIONS register\n", err);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
+{
+	int err = 0;
+	int irq = platform_get_irq(pdev, 0);
+
+	dbg_dev = &pdev->dev;
+
+	powerbutton_dev = input_allocate_device();
+	if (!powerbutton_dev) {
+		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = request_irq(irq, powerbutton_irq,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"twl4030-pwrbutton", NULL);
+	if (err < 0) {
+		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
+		goto free_input_dev;
+	}
+
+	powerbutton_dev->evbit[0] = BIT_MASK(EV_KEY);
+	powerbutton_dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	powerbutton_dev->name = "triton2-pwrbutton";
+	powerbutton_dev->phys = "twl4030_pwrbutton/input0";
+	powerbutton_dev->dev.parent = &pdev->dev;
+
+	err = input_register_device(powerbutton_dev);
+	if (err) {
+		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
+		goto free_irq_and_out;
+	}
+
+	dev_info(&pdev->dev, "triton2 power button driver initialized\n");
+
+	return 0;
+
+
+free_irq_and_out:
+	free_irq(irq, NULL);
+free_input_dev:
+	input_free_device(powerbutton_dev);
+out:
+	return err;
+}
+
+static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
+{
+	int irq = platform_get_irq(pdev, 0);
+
+	free_irq(irq, NULL);
+	input_unregister_device(powerbutton_dev);
+
+	return 0;
+}
+
+struct platform_driver twl4030_pwrbutton_driver = {
+	.probe		= twl4030_pwrbutton_probe,
+	.remove		= __devexit_p(twl4030_pwrbutton_remove),
+	.driver		= {
+		.name	= "twl4030_pwrbutton",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init twl4030_pwrbutton_init(void)
+{
+	return platform_driver_register(&twl4030_pwrbutton_driver);
+}
+module_init(twl4030_pwrbutton_init);
+
+static void __exit twl4030_pwrbutton_exit(void)
+{
+	platform_driver_unregister(&twl4030_pwrbutton_driver);
+}
+module_exit(twl4030_pwrbutton_exit);
+
+MODULE_ALIAS("platform:twl4030_pwrbutton");
+MODULE_DESCRIPTION("Triton2 Power Button");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter De Schrijver");
+
-- 
1.6.2.rc0.61.g5cd12


-- 
balbi
