Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYLNLfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYLNLfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYLNLfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:24 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34163 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYLNLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:23 -0500
X-Greylist: delayed 1996 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 06:35:22 EST
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 6/7] input: PCF50633 input driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sun, 14 Dec 2008 16:33:41 +0530
Message-ID: <20081214110341.3307.12766.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/Kconfig          |    6 ++
 drivers/input/misc/Makefile         |    1 
 drivers/input/misc/pcf50633-input.c |  119 +++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/pcf50633-input.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 199055d..3bc7c93 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -220,4 +220,10 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config INPUT_PCF50633_PMU
+	tristate "PCF50633 PMU events"
+	depends on MFD_PCF50633
+	help
+	 Say Y to include support for input events on NXP PCF50633.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index d7db2ae..bb62e6e 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
+obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
new file mode 100644
index 0000000..36ea8b2
--- /dev/null
+++ b/drivers/input/misc/pcf50633-input.c
@@ -0,0 +1,119 @@
+/* NXP PCF50633 Input Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/input.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/input.h>
+
+static void
+pcf50633_input_irq(struct pcf50633 *pcf, int irq, void *unused)
+{
+	struct input_dev *input_dev = pcf->input.input_dev;
+	int onkey_released;
+
+	/* We report only one event depending on the key press status */
+	onkey_released = pcf50633_reg_read(pcf, PCF50633_REG_OOCSTAT)
+						& PCF50633_OOCSTAT_ONKEY;
+
+	if (irq == PCF50633_IRQ_ONKEYF && !onkey_released)
+		input_report_key(input_dev, KEY_POWER, 1);
+	else if (irq == PCF50633_IRQ_ONKEYR && onkey_released)
+		input_report_key(input_dev, KEY_POWER, 0);
+
+	input_sync(input_dev);
+}
+
+int __init pcf50633_input_probe(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf;
+	struct input_dev *input_dev;
+	int ret;
+
+	pcf = platform_get_drvdata(pdev);
+
+	input_dev = input_allocate_device();
+	if (!input_dev)
+		return -ENOMEM;
+
+	input_dev->name = "PCF50633 PMU events";
+	input_dev->id.bustype = BUS_I2C;
+
+	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_PWR);
+	set_bit(KEY_POWER, input_dev->keybit);
+
+	ret = input_register_device(input_dev);
+	if (ret)
+		goto out;
+
+	pcf->input.input_dev = input_dev;
+
+	/* Set up interrupt handlers */
+	pcf->irq_handler[PCF50633_IRQ_ONKEYR].handler = pcf50633_input_irq;
+	pcf->irq_handler[PCF50633_IRQ_ONKEYF].handler = pcf50633_input_irq;
+
+	return 0;
+
+out:
+	input_free_device(input_dev);
+	return ret;
+}
+
+static int __devexit pcf50633_input_remove(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf;
+
+	pcf = platform_get_drvdata(pdev);
+
+	input_unregister_device(pcf->input.input_dev);
+	input_free_device(pcf->input.input_dev);
+
+	return 0;
+}
+
+struct platform_driver pcf50633_input_driver = {
+	.driver = {
+		.name = "pcf50633-input",
+	},
+	.probe = pcf50633_input_probe,
+	.remove = __devexit_p(pcf50633_input_remove),
+};
+
+static int __init pcf50633_input_init(void)
+{
+		return platform_driver_register(&pcf50633_input_driver);
+}
+module_init(pcf50633_input_init);
+
+static void __exit pcf50633_input_exit(void)
+{
+		platform_driver_unregister(&pcf50633_input_driver);
+}
+module_exit(pcf50633_input_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 input driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-input");

