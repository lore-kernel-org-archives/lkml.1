Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0CIUBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:01:39 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:41808 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0CIUBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:01:35 -0500
Date: Tue, 9 Mar 2010 13:01:35 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] TPM: Provide a tpm_tis OF driver
Message-ID: <20100309200135.GF30462@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides an open firwmare driver binding for tpm_tis. OF
is useful on arches where PNP is not used.

Allow the tpm_tis driver to be selected if PNP or OF are compiled in.

Tested on a PPC405 with a winbond LPC TPM.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/Kconfig   |    2 +-
 drivers/char/tpm/tpm_tis.c |   75 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 69 insertions(+), 8 deletions(-)

I had previously sent a patch to make the platform device more useful,
but this one is better for PPC...

Thanks

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f5fc64f..e4ab74f 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -24,7 +24,7 @@ if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on PNP
+	depends on PNP || OF
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2405f17..37e45f1 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -24,6 +24,7 @@
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/of_platform.h>
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
@@ -439,7 +440,7 @@ module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+			resource_size_t len, int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
@@ -515,9 +516,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts)
+	if (!interrupts)
+		irq = -1;
+	if (irq != -1)
 		chip->vendor.irq = irq;
-	if (interrupts && !chip->vendor.irq) {
+	if (irq == 0) {
 		chip->vendor.irq =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -598,11 +601,12 @@ out_err:
 	return rc;
 }
 
+#ifdef CONFIG_PNP
 static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
 {
 	resource_size_t start, len;
-	unsigned int irq = 0;
+	int irq = 0;
 
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
@@ -610,7 +614,7 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	if (pnp_irq_valid(pnp_dev, 0))
 		irq = pnp_irq(pnp_dev, 0);
 	else
-		interrupts = 0;
+		irq = -1;
 
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
@@ -662,6 +666,7 @@ static struct pnp_driver tis_pnp_driver = {
 module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
+#endif
 
 static int tpm_tis_suspend(struct platform_device *dev, pm_message_t msg)
 {
@@ -683,6 +688,45 @@ static struct platform_driver tis_drv = {
 
 static struct platform_device *pdev;
 
+#ifdef CONFIG_OF
+static int __devinit tis_of_init_one(struct of_device *ofdev,
+				     const struct of_device_id *match)
+{
+	struct resource res;
+	int ret;
+	int irq;
+
+	ret = of_address_to_resource(ofdev->node, 0, &res);
+	if (ret)
+		return ret;
+
+	irq = irq_of_parse_and_map(ofdev->node, 0);
+	if (irq == NO_IRQ)
+		irq = -1;
+	return tpm_tis_init(&ofdev->dev, res.start, res.end - res.start + 1, irq);
+}
+
+static int __devexit tis_of_remove_one(struct of_device *odev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(&odev->dev);
+	tpm_dev_vendor_release(chip);
+	kfree(chip);
+	return 0;
+}
+
+static struct of_device_id tis_of_platform_match[] = {
+	{.compatible = "tcg,tpm_tis"},
+	{},
+};
+static struct of_platform_driver tis_of_driver = {
+	.name = "tpm_tis",
+	.match_table = tis_of_platform_match,
+	.probe = tis_of_init_one,
+	.remove = __devexit_p(tis_of_remove_one)
+};
+
+#endif
+
 static int force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
@@ -703,7 +747,17 @@ static int __init init_tis(void)
 		return rc;
 	}
 
-	return pnp_register_driver(&tis_pnp_driver);
+#ifdef CONFIG_OF
+	rc = of_register_platform_driver(&tis_of_driver);
+	if (rc)
+		return rc;
+#endif
+#ifdef CONFIG_PNP
+	rc = pnp_register_driver(&tis_pnp_driver);
+	if (rc)
+		return rc;
+#endif
+	return 0;
 }
 
 static void __exit cleanup_tis(void)
@@ -728,11 +782,18 @@ static void __exit cleanup_tis(void)
 	}
 	spin_unlock(&tis_lock);
 
+#ifdef CONFIG_OF
+	of_unregister_platform_driver(&tis_of_driver);
+#endif
+
 	if (force) {
 		platform_device_unregister(pdev);
 		platform_driver_unregister(&tis_drv);
-	} else
+	} else {
+#ifdef CONFIG_PNP
 		pnp_unregister_driver(&tis_pnp_driver);
+#endif
+	}
 }
 
 module_init(init_tis);
-- 
1.5.4.2

