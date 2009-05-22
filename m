Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZEVIFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZEVIFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZEVIFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:05:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:54009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240AbZEVIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:05:20 -0400
Subject: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Rudolf Marek <r.marek@assembler.cz>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 May 2009 13:34:44 +0530
Message-Id: <1242979484.8796.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/hwmon/k8temp.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 1fe9951..831cd84 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -1,5 +1,6 @@
 /*
  * k8temp.c - Linux kernel module for hardware monitoring
+ * 	      for AMD K8 and derivates
  *
  * Copyright (C) 2006 Rudolf Marek <r.marek@assembler.cz>
  *
@@ -33,7 +34,7 @@
 #include <linux/mutex.h>
 #include <asm/processor.h>
 
-#define TEMP_FROM_REG(val)	(((((val) >> 16) & 0xff) - 49) * 1000)
+#define REG_TCTL	0xa4
 #define REG_TEMP	0xe4
 #define SEL_PLACE	0x40
 #define SEL_CORE	0x04
@@ -52,6 +53,14 @@ struct k8temp_data {
 	u32 temp_offset;
 };
 
+static unsigned long temp_from_reg(unsigned long val)
+{
+	if (boot_cpu_data.x86 > 0xf)
+		return ((val) >> 21) * 125;
+	else
+		return ((((val) >> 16) & 0xff) - 49) * 1000;
+}
+
 static struct k8temp_data *k8temp_update_device(struct device *dev)
 {
 	struct k8temp_data *data = dev_get_drvdata(dev);
@@ -62,6 +71,11 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
 
 	if (!data->valid
 	    || time_after(jiffies, data->last_updated + HZ)) {
+		if (boot_cpu_data.x86 > 0xf) {
+			pci_read_config_dword(pdev, REG_TCTL,
+					      &data->temp[0][0]);
+			goto update_done;
+		}
 		pci_read_config_byte(pdev, REG_TEMP, &tmp);
 		tmp &= ~(SEL_PLACE | SEL_CORE);		/* Select sensor 0, core0 */
 		pci_write_config_byte(pdev, REG_TEMP, tmp);
@@ -89,6 +103,7 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
 			}
 		}
 
+update_done:
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -123,7 +138,7 @@ static ssize_t show_temp(struct device *dev,
 	if (data->swap_core_select)
 		core = core ? 0 : 1;
 
-	temp = TEMP_FROM_REG(data->temp[core][place]) + data->temp_offset;
+	temp = temp_from_reg(data->temp[core][place]) + data->temp_offset;
 
 	return sprintf(buf, "%d\n", temp);
 }
@@ -138,6 +153,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
 static struct pci_device_id k8temp_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{ 0 },
 };
 
@@ -157,6 +174,9 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 		goto exit;
 	}
 
+	if (boot_cpu_data.x86 > 0xf)
+		goto probe_done;
+
 	model = boot_cpu_data.x86_model;
 	stepping = boot_cpu_data.x86_mask;
 
@@ -226,6 +246,7 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 			data->sensorsp &= ~SEL_CORE;
 	}
 
+probe_done:
 	data->name = "k8temp";
 	mutex_init(&data->update_lock);
 	dev_set_drvdata(&pdev->dev, data);
-- 
1.6.0.6



