Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750Ab0AFJvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0AFJvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729Ab0AFJvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:51:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52547 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0AFJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:51:20 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Chaithrika U S <chaithrika@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v2 4/4] i2c: davinci: Add cpufreq support
Date: Wed,  6 Jan 2010 14:55:00 +0530
Message-Id: <1262769900-2710-5-git-send-email-chaithrika@ti.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1262769900-2710-4-git-send-email-chaithrika@ti.com>
References: <1262769900-2710-1-git-send-email-chaithrika@ti.com>
 <1262769900-2710-2-git-send-email-chaithrika@ti.com>
 <1262769900-2710-3-git-send-email-chaithrika@ti.com>
 <1262769900-2710-4-git-send-email-chaithrika@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpufreq support for DaVinci I2C driver.
Tested on DA850/OMAP-L138 EVM. For the purpose of testing, the patches
which add cpufreq support [1] for this SoC are needed.

[1]http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
2009-September/016118.html

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   63 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index d2a4844..773cce5 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include <mach/hardware.h>
 #include <mach/i2c.h>
@@ -105,6 +106,10 @@ struct davinci_i2c_dev {
 	int			irq;
 	u8			terminate;
 	struct i2c_adapter	adapter;
+#ifdef CONFIG_CPU_FREQ
+	struct completion	xfr_complete;
+	struct notifier_block	freq_transition;
+#endif
 };
 
 /* default platform data to use if not supplied in the platform_device */
@@ -375,6 +380,11 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 		if (ret < 0)
 			return ret;
 	}
+
+#ifdef CONFIG_CPU_FREQ
+	complete(&dev->xfr_complete);
+#endif
+
 	return num;
 }
 
@@ -499,6 +509,48 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 	return count ? IRQ_HANDLED : IRQ_NONE;
 }
 
+#ifdef CONFIG_CPU_FREQ
+static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct davinci_i2c_dev *dev;
+
+	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
+	if (val == CPUFREQ_PRECHANGE) {
+		wait_for_completion(&dev->xfr_complete);
+		davinci_i2c_reset_ctrl(dev, 0);
+	} else if (val == CPUFREQ_POSTCHANGE) {
+		i2c_davinci_calc_clk_dividers(dev);
+		davinci_i2c_reset_ctrl(dev, 1);
+	}
+
+	return 0;
+}
+
+static inline int i2c_davinci_cpufreq_register(struct davinci_i2c_dev *dev)
+{
+	dev->freq_transition.notifier_call = i2c_davinci_cpufreq_transition;
+
+	return cpufreq_register_notifier(&dev->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void i2c_davinci_cpufreq_deregister(struct davinci_i2c_dev *dev)
+{
+	cpufreq_unregister_notifier(&dev->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#else
+static inline int i2c_davinci_cpufreq_register(struct davinci_i2c_dev *dev)
+{
+	return 0;
+}
+
+static inline void i2c_davinci_cpufreq_deregister(struct davinci_i2c_dev *dev)
+{
+}
+#endif
+
 static struct i2c_algorithm i2c_davinci_algo = {
 	.master_xfer	= i2c_davinci_xfer,
 	.functionality	= i2c_davinci_func,
@@ -538,6 +590,9 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	}
 
 	init_completion(&dev->cmd_complete);
+#ifdef CONFIG_CPU_FREQ
+	init_completion(&dev->xfr_complete);
+#endif
 	dev->dev = get_device(&pdev->dev);
 	dev->irq = irq->start;
 	platform_set_drvdata(pdev, dev);
@@ -563,6 +618,12 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
+	r = i2c_davinci_cpufreq_register(dev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register cpufreq\n");
+		goto err_free_irq;
+	}
+
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
@@ -604,6 +665,8 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
 	struct resource *mem;
 
+	i2c_davinci_cpufreq_deregister(dev);
+
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
-- 
1.5.6

