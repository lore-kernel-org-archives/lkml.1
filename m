Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZHCJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZHCJa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZHCJa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:30:57 -0400
Received: from smtp-out114.alice.it ([85.37.17.114]:1154 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZHCJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:30:56 -0400
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel Ribeiro <wyrm@gmail.com>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       Daniel Ribeiro <drwyrm@gmail.com>, Ilya Petrov <ilya.muromec@gmail.com>,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH v2] input: PCAP2 misc input driver
Date: Mon,  3 Aug 2009 11:29:19 +0200
Message-Id: <1249291759-15264-1-git-send-email-drwyrm@gmail.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 03 Aug 2009 09:29:51.0354 (UTC) FILETIME=[F3B055A0:01CA141C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Ribeiro <wyrm@gmail.com>

This is a driver for misc input events for the PCAP2 PMIC, it handles
the Power key and the Headphone button.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Ilya Petrov <ilya.muromec@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

---

Please note that the driver depends on some changes from the for-next branch
in Samuel Ortiz's mfd tree:
http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=shortlog;h=for-next

should this be queued by Samuel or the input people will you take care
to send this mainline only after Samuel's tree has been merged?

Changes from v1:
 * Using __set_bit now
 * Moved to drivers/input/misc and fixed Kconfig
 * Removed Jack/Mic insertion handling,
   we will use the jack insertion api for these
 * Added a MODULE_ALIAS

v1 is in http://lkml.org/lkml/2009/6/27/113


 drivers/input/misc/Kconfig     |   11 +++
 drivers/input/misc/Makefile    |    1 +
 drivers/input/misc/pcap_keys.c |  144 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 1acfa3a..b9cbb5e 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -269,4 +269,15 @@ config INPUT_DM355EVM
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dm355evm_keys.
+
+config INPUT_PCAP
+	tristate "Motorola EZX PCAP misc input events"
+	depends on EZX_PCAP
+	help
+	  Say Y here if you want to use Power key and Headphone button
+	  on Motorola EZX phones.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pcap_keys.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 0d979fd..679bae3 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
+obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
new file mode 100644
index 0000000..0eb2604
--- /dev/null
+++ b/drivers/input/misc/pcap_keys.c
@@ -0,0 +1,144 @@
+/*
+ *  Input driver for PCAP events:
+ *   * Power key
+ *   * Headphone button
+ *
+ *  Copyright (c) 2008,2009 Ilya Petrov <ilya.muromec@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/ezx-pcap.h>
+
+struct pcap_keys {
+	struct pcap_chip *pcap;
+	struct input_dev *input;
+};
+
+/* PCAP2 interrupts us on keypress */
+static irqreturn_t pcap_keys_handler(int irq, void *_pcap_keys)
+{
+	struct pcap_keys *pcap_keys = _pcap_keys;
+	int pirq = irq_to_pcap(pcap_keys->pcap, irq);
+	u32 pstat;
+
+	ezx_pcap_read(pcap_keys->pcap, PCAP_REG_PSTAT, &pstat);
+	pstat &= 1 << pirq;
+
+	switch (pirq) {
+	case PCAP_IRQ_ONOFF:
+		input_report_key(pcap_keys->input, KEY_POWER, !pstat);
+		break;
+	case PCAP_IRQ_MIC:
+		input_report_key(pcap_keys->input, KEY_HP, !pstat);
+		break;
+	}
+
+	input_sync(pcap_keys->input);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit pcap_keys_probe(struct platform_device *pdev)
+{
+	int err = -ENOMEM;
+	struct pcap_keys *pcap_keys;
+	struct input_dev *input_dev;
+
+	pcap_keys = kmalloc(sizeof(struct pcap_keys), GFP_KERNEL);
+	if (!pcap_keys)
+		return err;
+
+	pcap_keys->pcap = platform_get_drvdata(pdev);
+
+	input_dev = input_allocate_device();
+	if (!input_dev)
+		goto fail;
+
+	pcap_keys->input = input_dev;
+
+	platform_set_drvdata(pdev, pcap_keys);
+	input_dev->name = pdev->name;
+	input_dev->phys = "pcap-keys/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->dev.parent = &pdev->dev;
+
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(KEY_POWER, input_dev->keybit);
+	__set_bit(KEY_HP, input_dev->keybit);
+
+	err = input_register_device(input_dev);
+	if (err)
+		goto fail_allocate;
+
+	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
+			pcap_keys_handler, 0, "Power key", pcap_keys);
+	if (err)
+		goto fail_register;
+
+	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
+			pcap_keys_handler, 0, "Headphone button", pcap_keys);
+	if (err)
+		goto fail_pwrkey;
+
+	return 0;
+
+fail_pwrkey:
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
+fail_register:
+	input_unregister_device(input_dev);
+	goto fail;
+fail_allocate:
+	input_free_device(input_dev);
+fail:
+	kfree(pcap_keys);
+	return err;
+}
+
+static int __devexit pcap_keys_remove(struct platform_device *pdev)
+{
+	struct pcap_keys *pcap_keys = platform_get_drvdata(pdev);
+
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
+	free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
+
+	input_unregister_device(pcap_keys->input);
+	kfree(pcap_keys);
+
+	return 0;
+}
+
+static struct platform_driver pcap_keys_device_driver = {
+	.probe		= pcap_keys_probe,
+	.remove		= __devexit_p(pcap_keys_remove),
+	.driver		= {
+		.name	= "pcap-keys",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init pcap_keys_init(void)
+{
+	return platform_driver_register(&pcap_keys_device_driver);
+};
+
+static void __exit pcap_keys_exit(void)
+{
+	platform_driver_unregister(&pcap_keys_device_driver);
+};
+
+module_init(pcap_keys_init);
+module_exit(pcap_keys_exit);
+
+MODULE_DESCRIPTION("Motorola PCAP2 input events driver");
+MODULE_AUTHOR("Ilya Petrov <ilya.muromec@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcap_keys");
-- 
tg: (08582db..) ezx/pcap_keys (depends on: ezx/local/pcap)
