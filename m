Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbXKNScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbXKNScS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbXKNScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:32:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:50043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXKNScG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:32:06 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] drivers/firmware/dcdbas: rework to get uevents
Date: Wed, 14 Nov 2007 19:32:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matt Domsch <Matt_Domsch@dell.com>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Doug Warzecha <Douglas_Warzecha@dell.com>,
       Dmitry Torokhov <dtor_core@ameritech.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141932.03190.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a small trivial rework of the dcdbas driver so
HAL can get uevents when platform devices are added or removed.

Its tested and seems to work without problem, but please bear in mind
this is the work of a beginner.

Any feedback is very welcome.

Thanks,
Frank
---
Trivial small rework to use of new platform platform_register_device to
also get uevents on loading and unloading the driver.

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 drivers/firmware/dcdbas.c |   57 +++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 26 deletions(-)

--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -40,16 +40,17 @@
 #include "dcdbas.h"
 
 #define DRIVER_NAME		"dcdbas"
-#define DRIVER_VERSION		"5.6.0-3.2"
+#define DRIVER_VERSION		"5.6.0-3.3"
 #define DRIVER_DESCRIPTION	"Dell Systems Management Base Driver"
 
-static struct platform_device *dcdbas_pdev;
+static struct platform_device dcdbas_pdev;
 
 static u8 *smi_data_buf;
 static dma_addr_t smi_data_buf_handle;
 static unsigned long smi_data_buf_size;
 static u32 smi_data_buf_phys_addr;
 static DEFINE_MUTEX(smi_data_lock);
+static char driver_name[] = DRIVER_NAME;
 
 static unsigned int host_control_action;
 static unsigned int host_control_smi_type;
@@ -63,10 +64,10 @@ static void smi_data_buf_free(void)
 	if (!smi_data_buf)
 		return;
 
-	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
+	dev_dbg(&dcdbas_pdev.dev, "%s: phys: %x size: %lu\n",
 		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
 
-	dma_free_coherent(&dcdbas_pdev->dev, smi_data_buf_size, smi_data_buf,
+	dma_free_coherent(&dcdbas_pdev.dev, smi_data_buf_size, smi_data_buf,
 			  smi_data_buf_handle);
 	smi_data_buf = NULL;
 	smi_data_buf_handle = 0;
@@ -89,9 +90,9 @@ static int smi_data_buf_realloc(unsigned
 		return -EINVAL;
 
 	/* new buffer is needed */
-	buf = dma_alloc_coherent(&dcdbas_pdev->dev, size, &handle, GFP_KERNEL);
+	buf = dma_alloc_coherent(&dcdbas_pdev.dev, size, &handle, GFP_KERNEL);
 	if (!buf) {
-		dev_dbg(&dcdbas_pdev->dev,
+		dev_dbg(&dcdbas_pdev.dev,
 			"%s: failed to allocate memory size %lu\n",
 			__FUNCTION__, size);
 		return -ENOMEM;
@@ -110,7 +111,7 @@ static int smi_data_buf_realloc(unsigned
 	smi_data_buf_phys_addr = (u32) virt_to_phys(buf);
 	smi_data_buf_size = size;
 
-	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
+	dev_dbg(&dcdbas_pdev.dev, "%s: phys: %x size: %lu\n",
 		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
 
 	return 0;
@@ -256,7 +257,7 @@ static int smi_request(struct smi_cmd *s
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
-		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
+		dev_info(&dcdbas_pdev.dev, "%s: invalid magic value\n",
 			 __FUNCTION__);
 		return -EBADR;
 	}
@@ -265,7 +266,7 @@ static int smi_request(struct smi_cmd *s
 	old_mask = current->cpus_allowed;
 	set_cpus_allowed(current, cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
+		dev_dbg(&dcdbas_pdev.dev, "%s: failed to get CPU 0\n",
 			__FUNCTION__);
 		ret = -EBUSY;
 		goto out;
@@ -426,7 +427,7 @@ static int host_control_smi(void)
 		break;
 
 	default:
-		dev_dbg(&dcdbas_pdev->dev, "%s: invalid SMI type %u\n",
+		dev_dbg(&dcdbas_pdev.dev, "%s: invalid SMI type %u\n",
 			__FUNCTION__, host_control_smi_type);
 		return -ENOSYS;
 	}
@@ -455,12 +456,12 @@ static void dcdbas_host_control(void)
 	host_control_action = HC_ACTION_NONE;
 
 	if (!smi_data_buf) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __FUNCTION__);
+		dev_dbg(&dcdbas_pdev.dev, "%s: no SMI buffer\n", __FUNCTION__);
 		return;
 	}
 
 	if (smi_data_buf_size < sizeof(struct apm_cmd)) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: SMI buffer too small\n",
+		dev_dbg(&dcdbas_pdev.dev, "%s: SMI buffer too small\n",
 			__FUNCTION__);
 		return;
 	}
@@ -548,8 +549,8 @@ static int __devinit dcdbas_probe(struct
 	 * BIOS SMI calls require buffer addresses be in 32-bit address space.
 	 * This is done by setting the DMA mask below.
 	 */
-	dcdbas_pdev->dev.coherent_dma_mask = DMA_32BIT_MASK;
-	dcdbas_pdev->dev.dma_mask = &dcdbas_pdev->dev.coherent_dma_mask;
+	dcdbas_pdev.dev.coherent_dma_mask = DMA_32BIT_MASK;
+	dcdbas_pdev.dev.dma_mask = &dcdbas_pdev.dev.coherent_dma_mask;
 
 	error = sysfs_create_group(&dev->dev.kobj, &dcdbas_attr_group);
 	if (error)
@@ -596,6 +597,15 @@ static struct platform_driver dcdbas_dri
 	.remove		= __devexit_p(dcdbas_remove),
 };
 
+static void __devexit dcdbas_release(struct device *dev)
+{
+	struct platform_device *pd =
+			container_of(dev, struct platform_device, dev);
+
+	kfree(dev->platform_data);
+	kfree(pd->resource);
+}
+
 /**
  * dcdbas_init: initialize driver
  */
@@ -607,21 +617,16 @@ static int __init dcdbas_init(void)
 	if (error)
 		return error;
 
-	dcdbas_pdev = platform_device_alloc(DRIVER_NAME, -1);
-	if (!dcdbas_pdev) {
-		error = -ENOMEM;
-		goto err_unregister_driver;
-	}
-
-	error = platform_device_add(dcdbas_pdev);
+	dcdbas_pdev.name = driver_name;
+	dcdbas_pdev.id = -1;
+	dcdbas_pdev.dev.release = dcdbas_release;
+	error = platform_device_register(&dcdbas_pdev);
 	if (error)
-		goto err_free_device;
+		goto err_unregister_driver;
 
 	return 0;
 
- err_free_device:
-	platform_device_put(dcdbas_pdev);
- err_unregister_driver:
+err_unregister_driver:
 	platform_driver_unregister(&dcdbas_driver);
 	return error;
 }
@@ -637,7 +642,7 @@ static void __exit dcdbas_exit(void)
 	 */
 	unregister_reboot_notifier(&dcdbas_reboot_nb);
 	smi_data_buf_free();
-	platform_device_unregister(dcdbas_pdev);
+	platform_device_unregister(&dcdbas_pdev);
 	platform_driver_unregister(&dcdbas_driver);
 
 	/*
