Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbZGABXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbZGABXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765498AbZGABEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:25 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:34983 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765522AbZGABET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:19 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 5/6] tpm_tis: convert from pnp_driver to acpi_driver
Date: Tue, 30 Jun 2009 18:04:14 -0700
Message-Id: <1246410255-6839-6-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all TIS-compatible TPM chips have a _HID method in their ACPI entry,
and the TPM spec says that the _CID method should be used to enumerate
the TPM chip.

Convert to acpi_driver so that we can access the _CID entry.

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/Kconfig   |    2 +-
 drivers/char/tpm/tpm_tis.c |  157 +++++++++++++++++++++++++++++++++----------
 2 files changed, 121 insertions(+), 38 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f5fc64f..204b69f 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -24,7 +24,7 @@ if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on PNP
+	depends on ACPI
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 50c2a8a..7f0cb6c 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -21,9 +21,12 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/pnp.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
@@ -77,6 +80,13 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
+struct tpm_data {
+	unsigned long tpm_phys_address;
+	void __iomem *tpm_address;
+	int tpm_size;
+	int tpm_irq;
+};
+
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
@@ -590,34 +600,114 @@ out_err:
 	return rc;
 }
 
-static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
-				      const struct pnp_device_id *pnp_id)
+static acpi_status tpm_resources(struct acpi_resource *res, void *data)
+{
+	struct acpi_device *device = data;
+	struct device *dev = &device->dev;
+	struct tpm_data *tpm = device->driver_data;
+	acpi_status status;
+	struct acpi_resource_address64 addr;
+
+	status = acpi_resource_to_address64(res, &addr);
+
+	if (ACPI_SUCCESS(status)) {
+		dev_info(dev, "found 0x%llx(0x%llx)\n",
+				(long long)addr.minimum,
+				(long long)addr.address_length);
+		tpm->tpm_phys_address = addr.minimum;
+		tpm->tpm_address = ioremap(addr.minimum, addr.address_length);
+		tpm->tpm_size = addr.address_length;
+	} else if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32;
+
+		fixmem32 = &res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_NO_MEMORY;
+
+		dev_info(dev, "found 0x%llx(0x%llx)\n",
+				(long long)fixmem32->address,
+				(long long)TIS_MEM_LEN);
+		tpm->tpm_phys_address = fixmem32->address;
+		tpm->tpm_address = ioremap(fixmem32->address, TIS_MEM_LEN);
+		tpm->tpm_size = fixmem32->address_length;
+	} else if (res->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+
+		irq = &res->data.extended_irq;
+		if (irq->interrupt_count > 0 && irq->interrupts[0] > 0) {
+			dev_info(dev, "IRQ %d (%d, %d)\n",
+					irq->interrupts[0],
+					irq->triggering, irq->polarity);
+			tpm->tpm_irq = irq->interrupts[0];
+		}
+	}
+
+	return AE_OK;
+}
+
+static int tpm_tis_acpi_add(struct acpi_device *device)
 {
-	resource_size_t start, len;
-	unsigned int irq = 0;
+	acpi_status result;
+	struct tpm_data *tpm = kzalloc(sizeof(*tpm), GFP_KERNEL);
+	int rc = -ENOMEM;
+
+	if (!tpm)
+		goto out;
 
-	start = pnp_mem_start(pnp_dev, 0);
-	len = pnp_mem_len(pnp_dev, 0);
+	device->driver_data = tpm;
+
+	result = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+			tpm_resources, device);
+
+	rc = -ENODEV;
+	if (ACPI_FAILURE(result))
+		goto out_free;
+
+	if (!tpm->tpm_address) {
+		dev_err(&device->dev, "no address found in _CRS\n");
+		goto out_free;
+	}
 
-	if (pnp_irq_valid(pnp_dev, 0))
-		irq = pnp_irq(pnp_dev, 0);
-	else
+	if (!tpm->tpm_irq) {
+		dev_err(&device->dev, "no IRQ found in _CRS, polling mode\n");
 		interrupts = 0;
+	}
 
-	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
+	return tpm_tis_init(&device->dev, tpm->tpm_phys_address, tpm->tpm_size,
+			tpm->tpm_irq);
+out_free:
+	kfree(tpm);
+out:
+	return rc;
 }
 
-static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
+static int tpm_tis_acpi_remove(struct acpi_device *device, int type)
 {
-	return tpm_pm_suspend(&dev->dev, msg);
+	struct tpm_chip *chip = dev_get_drvdata(&device->dev);
+	tpm_remove_hardware(&device->dev);
+	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(chip->vendor.iobase +
+				TPM_INT_ENABLE(chip->vendor.locality)),
+		  chip->vendor.iobase +
+		  TPM_INT_ENABLE(chip->vendor.locality));
+	release_locality(chip, chip->vendor.locality, 1);
+	if (chip->vendor.irq)
+		free_irq(chip->vendor.irq, chip);
+	iounmap(chip->vendor.iobase);
+	kfree(device->driver_data);
+	return 0;
 }
 
-static int tpm_tis_pnp_resume(struct pnp_dev *dev)
+static int tpm_tis_acpi_suspend(struct acpi_device *dev, pm_message_t state)
+{
+	return tpm_pm_suspend(&dev->dev, state);
+}
+
+static int tpm_tis_acpi_resume(struct acpi_device *dev)
 {
 	return tpm_pm_resume(&dev->dev);
 }
 
-static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
+static struct acpi_device_id tpm_tis_acpi_tbl[] __devinitdata = {
 	{"PNP0C31", 0},		/* TPM */
 	{"ATM1200", 0},		/* Atmel */
 	{"IFX0102", 0},		/* Infineon */
@@ -625,34 +715,27 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"BCM0102", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
 	{"ICO0102", 0},		/* Intel */
+	{"INTC0102", 0},	/* TPM spec says to look for this in _CID */
 	/* Add new here */
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
 };
-MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
-
-static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
-{
-	struct tpm_chip *chip = pnp_get_drvdata(dev);
-
-	tpm_dev_vendor_release(chip);
-
-	kfree(chip);
-}
-
+MODULE_DEVICE_TABLE(acpi, tpm_tis_acpi_tbl);
 
-static struct pnp_driver tis_pnp_driver = {
+static struct acpi_driver tis_acpi_driver = {
 	.name = "tpm_tis",
-	.id_table = tpm_pnp_tbl,
-	.probe = tpm_tis_pnp_init,
-	.suspend = tpm_tis_pnp_suspend,
-	.resume = tpm_tis_pnp_resume,
-	.remove = tpm_tis_pnp_remove,
+	.ids = tpm_tis_acpi_tbl,
+	.ops = {
+		.add = tpm_tis_acpi_add,
+		.remove = tpm_tis_acpi_remove,
+		.suspend = tpm_tis_acpi_suspend,
+		.resume = tpm_tis_acpi_resume,
+	},
 };
 
-#define TIS_HID_USR_IDX (ARRAY_SIZE(tpm_pnp_tbl) - 2)
-module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
-		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
+#define TIS_HID_USR_IDX (ARRAY_SIZE(tpm_tis_acpi_tbl) - 2)
+module_param_string(hid, tpm_tis_acpi_tbl[TIS_HID_USR_IDX].id,
+		    sizeof(tpm_tis_acpi_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
 static struct device_driver tis_drv = {
@@ -685,7 +768,7 @@ static int __init init_tis(void)
 		return rc;
 	}
 
-	return pnp_register_driver(&tis_pnp_driver);
+	return acpi_bus_register_driver(&tis_acpi_driver);
 }
 
 static void __exit cleanup_tis(void)
@@ -714,7 +797,7 @@ static void __exit cleanup_tis(void)
 		platform_device_unregister(pdev);
 		driver_unregister(&tis_drv);
 	} else
-		pnp_unregister_driver(&tis_pnp_driver);
+		acpi_bus_unregister_driver(&tis_acpi_driver);
 }
 
 module_init(init_tis);
-- 
1.6.3.1

