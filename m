Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZHTVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZHTVLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZHTVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:11:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:41078 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZHTVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:11:53 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: ralf@linux-mips.org, mpm@selenic.com, herbert@gondor.apana.org.au
Cc: linux-mips@linux-mips.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 2/2] hw_random: Add hardware RNG for Octeon SOCs.
Date: Thu, 20 Aug 2009 14:10:23 -0700
Message-Id: <1250802623-6526-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4A8DBB17.5020301@caviumnetworks.com>
References: <4A8DBB17.5020301@caviumnetworks.com>
X-OriginalArrivalTime: 20 Aug 2009 21:10:28.0850 (UTC) FILETIME=[A502ED20:01CA21DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/char/hw_random/Kconfig      |   13 +++
 drivers/char/hw_random/Makefile     |    1 +
 drivers/char/hw_random/octeon-rng.c |  147 +++++++++++++++++++++++++++++++++++
 3 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/octeon-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index ce66a70..121b782 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -126,6 +126,19 @@ config HW_RANDOM_OMAP
 
  	  If unsure, say Y.
 
+config HW_RANDOM_OCTEON
+	tristate "Octeon Random Number Generator support"
+	depends on HW_RANDOM && CPU_CAVIUM_OCTEON
+	default HW_RANDOM
+ 	---help---
+ 	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Octeon processors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called octeon-rng.
+
+ 	  If unsure, say Y.
+
 config HW_RANDOM_PASEMI
 	tristate "PA Semi HW Random Number Generator support"
 	depends on HW_RANDOM && PPC_PASEMI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 676828b..5eeb130 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
+obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
new file mode 100644
index 0000000..54b0d9b
--- /dev/null
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -0,0 +1,147 @@
+/*
+ * Hardware Random Number Generator support for Cavium Networks
+ * Octeon processor family.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Cavium Networks
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+
+#include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-rnm-defs.h>
+
+struct octeon_rng {
+	struct hwrng ops;
+	void __iomem *control_status;
+	void __iomem *result;
+};
+
+static int octeon_rng_init(struct hwrng *rng)
+{
+	union cvmx_rnm_ctl_status ctl;
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	ctl.u64 = 0;
+	ctl.s.ent_en = 1; /* Enable the entropy source.  */
+	ctl.s.rng_en = 1; /* Enable the RNG hardware.  */
+	cvmx_write_csr((u64)p->control_status, ctl.u64);
+	return 0;
+}
+
+static void octeon_rng_cleanup(struct hwrng *rng)
+{
+	union cvmx_rnm_ctl_status ctl;
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	ctl.u64 = 0;
+	/* Disable everything.  */
+	cvmx_write_csr((u64)p->control_status, ctl.u64);
+}
+
+static int octeon_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	*data = cvmx_read64_uint32((u64)p->result);
+	return sizeof(u32);
+}
+
+static int __devinit octeon_rng_probe(struct platform_device *pdev)
+{
+	struct resource *res_ports;
+	struct resource *res_result;
+	struct octeon_rng *rng;
+	int ret;
+	struct hwrng ops = {
+		.name = "octeon",
+		.init = octeon_rng_init,
+		.cleanup = octeon_rng_cleanup,
+		.data_read = octeon_rng_data_read
+	};
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	res_ports = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_ports)
+		goto err_ports;
+
+	res_result = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res_result)
+		goto err_ports;
+
+
+	rng->control_status = devm_ioremap_nocache(&pdev->dev,
+						   res_ports->start,
+						   sizeof(u64));
+	if (!rng->control_status)
+		goto err_ports;
+
+	rng->result = devm_ioremap_nocache(&pdev->dev,
+					   res_result->start,
+					   sizeof(u64));
+	if (!rng->result)
+		goto err_r;
+
+	rng->ops = ops;
+
+	dev_set_drvdata(&pdev->dev, &rng->ops);
+	ret = hwrng_register(&rng->ops);
+	if (ret)
+		goto err;
+
+	dev_info(&pdev->dev, "Octeon Random Number Generator\n");
+
+	return 0;
+err:
+	devm_iounmap(&pdev->dev, rng->control_status);
+err_r:
+	devm_iounmap(&pdev->dev, rng->result);
+err_ports:
+	devm_kfree(&pdev->dev, rng);
+	return -ENOENT;
+}
+
+static int __exit octeon_rng_remove(struct platform_device *pdev)
+{
+	struct hwrng *rng = dev_get_drvdata(&pdev->dev);
+
+	hwrng_unregister(rng);
+
+	return 0;
+}
+
+static struct platform_driver octeon_rng_driver = {
+	.driver = {
+		.name		= "octeon_rng",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= octeon_rng_probe,
+	.remove		= __exit_p(octeon_rng_remove),
+};
+
+static int __init octeon_rng_mod_init(void)
+{
+	return platform_driver_register(&octeon_rng_driver);
+}
+
+static void __exit octeon_rng_mod_exit(void)
+{
+	platform_driver_unregister(&octeon_rng_driver);
+}
+
+module_init(octeon_rng_mod_init);
+module_exit(octeon_rng_mod_exit);
+
+MODULE_AUTHOR("David Daney");
+MODULE_LICENSE("GPL");
-- 
1.6.0.6

