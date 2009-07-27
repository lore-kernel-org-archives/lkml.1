Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZG0Nrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZG0Nrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZG0Nrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:47:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59135 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754777AbZG0Nqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Subject: [PATCH 13/22] Input: Add support for the WM831x ON pin
Date: Mon, 27 Jul 2009 14:46:03 +0100
Message-Id: <1248702372-29534-13-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of PMICs support control of initial power on
through the ON pin on the device with soft control of the pin
at other times. Represent this to userspace as KEY_POWER.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@vger.kernel.org
---
 drivers/input/misc/Kconfig      |   10 +++
 drivers/input/misc/Makefile     |    1 +
 drivers/input/misc/wm831x-on.c  |  163 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h |   19 +++++
 4 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/wm831x-on.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index cbe21bc..852941d 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -279,4 +279,14 @@ config INPUT_BFIN_ROTARY
 	  To compile this driver as a module, choose M here: the
 	  module will be called bfin-rotary.
 
+config INPUT_WM831X_ON
+	tristate "WM831X ON pin"
+	depends on MFD_WM831X
+	help
+	  Support the ON pin of WM831X PMICs as an input device
+	  reporting power button status.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called wm831x_on.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 79c1e9a..c97533f 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -26,4 +26,5 @@ obj-$(CONFIG_INPUT_SPARCSPKR)		+= sparcspkr.o
 obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
+obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
diff --git a/drivers/input/misc/wm831x-on.c b/drivers/input/misc/wm831x-on.c
new file mode 100644
index 0000000..4c3941c
--- /dev/null
+++ b/drivers/input/misc/wm831x-on.c
@@ -0,0 +1,163 @@
+/**
+ * wm831x-on.c - WM831X ON pind river
+ *
+ * Copyright (C) 2009 Wolfson Microelectronics plc
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
+#include <linux/workqueue.h>
+#include <linux/mfd/wm831x/core.h>
+
+struct wm831x_on {
+	struct input_dev *dev;
+	struct delayed_work work;
+	struct wm831x *wm831x;
+};
+
+/*
+ * The chip gives us an interrupt when the ON pin is asserted but we
+ * then need to poll to see when the pin is deasserted.
+ */
+static void wm831x_poll_on(struct work_struct *work)
+{
+	struct wm831x_on *wm831x_on = container_of(work, struct wm831x_on,
+						   work.work);
+	struct wm831x *wm831x = wm831x_on->wm831x;
+	int poll, ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_ON_PIN_CONTROL);
+	if (ret >= 0) {
+		poll = !(ret & WM831X_ON_PIN_STS);
+
+		input_report_key(wm831x_on->dev, KEY_POWER, poll);
+		input_sync(wm831x_on->dev);
+	} else {
+		dev_err(wm831x->dev, "Failed to read ON status: %d\n", ret);
+		poll = 1;
+	}
+
+	if (poll)
+		schedule_delayed_work(&wm831x_on->work, 100);
+}
+
+static irqreturn_t wm831x_on_irq(int irq, void *data)
+{
+	struct wm831x_on *wm831x_on = data;
+
+	schedule_work(&wm831x_on->work.work);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit wm831x_on_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_on *wm831x_on;
+	int irq = platform_get_irq(pdev, 0);
+	int ret;
+
+	wm831x_on = kzalloc(sizeof(struct wm831x_on), GFP_KERNEL);
+	if (!wm831x_on) {
+		dev_err(&pdev->dev, "Can't allocate data\n");
+		return -ENOMEM;
+	}
+
+	wm831x_on->wm831x = wm831x;
+	INIT_DELAYED_WORK(&wm831x_on->work, wm831x_poll_on);
+
+	wm831x_on->dev = input_allocate_device();
+	if (!wm831x_on->dev) {
+		dev_err(&pdev->dev, "Can't allocate input dev\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	wm831x_on->dev->evbit[0] = BIT_MASK(EV_KEY);
+	wm831x_on->dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	wm831x_on->dev->name = "wm831x_on";
+	wm831x_on->dev->phys = "wm831x_on/input0";
+	wm831x_on->dev->dev.parent = &pdev->dev;
+
+	ret = wm831x_request_irq(wm831x, irq, wm831x_on_irq,
+				 IRQF_TRIGGER_RISING, "wm831x_on", wm831x_on);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Unable to request IRQ: %d\n", ret);
+		goto err_input_dev;
+	}
+	ret = input_register_device(wm831x_on->dev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "Can't register input device: %d\n", ret);
+		goto err_irq;
+	}
+
+	platform_set_drvdata(pdev, wm831x_on);
+
+	return 0;
+
+err_irq:
+	wm831x_free_irq(wm831x, irq, NULL);
+err_input_dev:
+	input_free_device(wm831x_on->dev);
+err:
+	kfree(wm831x_on);
+	return ret;
+}
+
+static int __devexit wm831x_on_remove(struct platform_device *pdev)
+{
+	struct wm831x_on *wm831x_on = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	wm831x_free_irq(wm831x_on->wm831x, irq, wm831x_on);
+	cancel_delayed_work_sync(&wm831x_on->work);
+	input_unregister_device(wm831x_on->dev);
+	kfree(wm831x_on);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_on_driver = {
+	.probe		= wm831x_on_probe,
+	.remove		= __devexit_p(wm831x_on_remove),
+	.driver		= {
+		.name	= "wm831x-on",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init wm831x_on_init(void)
+{
+	return platform_driver_register(&wm831x_on_driver);
+}
+module_init(wm831x_on_init);
+
+static void __exit wm831x_on_exit(void)
+{
+	platform_driver_unregister(&wm831x_on_driver);
+}
+module_exit(wm831x_on_exit);
+
+MODULE_ALIAS("platform:wm831x-on");
+MODULE_DESCRIPTION("WM831x ON pin");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index d7134df..91eb493 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -216,6 +216,25 @@
 #define WM831X_PARENT_ID_SHIFT                       0  /* PARENT_ID - [15:0] */
 #define WM831X_PARENT_ID_WIDTH                      16  /* PARENT_ID - [15:0] */
 
+/*
+ * R16389 (0x4005) - ON Pin Control
+ */
+#define WM831X_ON_PIN_SECACT_MASK               0x0300  /* ON_PIN_SECACT - [9:8] */
+#define WM831X_ON_PIN_SECACT_SHIFT                   8  /* ON_PIN_SECACT - [9:8] */
+#define WM831X_ON_PIN_SECACT_WIDTH                   2  /* ON_PIN_SECACT - [9:8] */
+#define WM831X_ON_PIN_PRIMACT_MASK              0x0030  /* ON_PIN_PRIMACT - [5:4] */
+#define WM831X_ON_PIN_PRIMACT_SHIFT                  4  /* ON_PIN_PRIMACT - [5:4] */
+#define WM831X_ON_PIN_PRIMACT_WIDTH                  2  /* ON_PIN_PRIMACT - [5:4] */
+#define WM831X_ON_PIN_STS                       0x0008  /* ON_PIN_STS */
+#define WM831X_ON_PIN_STS_MASK                  0x0008  /* ON_PIN_STS */
+#define WM831X_ON_PIN_STS_SHIFT                      3  /* ON_PIN_STS */
+#define WM831X_ON_PIN_STS_WIDTH                      1  /* ON_PIN_STS */
+#define WM831X_ON_PIN_TO_MASK                   0x0003  /* ON_PIN_TO - [1:0] */
+#define WM831X_ON_PIN_TO_SHIFT                       0  /* ON_PIN_TO - [1:0] */
+#define WM831X_ON_PIN_TO_WIDTH                       2  /* ON_PIN_TO - [1:0] */
+
+struct regulator_dev;
+
 struct wm831x {
 	struct mutex io_lock;
 
-- 
1.6.3.3

