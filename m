Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZEZMOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZEZMOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbZEZMOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:14:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbZEZMOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:14:23 -0400
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <4A182B61.5010503@assembler.cz>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <4A182B61.5010503@assembler.cz>
Content-Type: text/plain
Date: Tue, 26 May 2009 17:40:33 +0530
Message-Id: <1243339833.12303.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 18:59 +0200, Rudolf Marek wrote:
> Hi,
> 
> Yes it works for most CPUs, but for unlucky users we might get complains from 
> them - and false alarms.
> 
> I'm talking about:
> 
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
> 
> Errata #319
> 
> So far all CPUs have the issue.
> 
> Rudolf
> 

Here is the patch which will prepare the report for Inaccurate
Temperature Measurement to fix/suppress inaccurate Monitoring.

[PATCH] x86: hwmon/k8temp.c Add support for AMD 10H and 11H

Some AMD 10H cpus reports Inaccurate Temperature Measurement:
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
Errata #319

So Added report message to fix/suppress inaccurate Monitoring.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/hwmon/k8temp.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 1fe9951..1e9594a 100644
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
@@ -52,6 +53,20 @@ struct k8temp_data {
 	u32 temp_offset;
 };
 
+static const char report[] = "Please send below message to: "
+			     "LKML <linux-kernel@vger.kernel.org>, "
+			     "Rudolf Marek <r.marek@assembler.cz>, "
+			     "Jaswinder Singh Rajput <jaswinder@kernel.org>"
+			     "\n\"Invalid temperature:";
+
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
@@ -62,6 +77,11 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
 
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
@@ -89,6 +109,7 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
 			}
 		}
 
+update_done:
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -123,7 +144,14 @@ static ssize_t show_temp(struct device *dev,
 	if (data->swap_core_select)
 		core = core ? 0 : 1;
 
-	temp = TEMP_FROM_REG(data->temp[core][place]) + data->temp_offset;
+	temp = temp_from_reg(data->temp[core][place]) + data->temp_offset;
+
+	/* Some AMD 10H cpus reports Inaccurate Temperature Measurement */
+	if ((temp < 21000) || (temp > 90000))
+		WARN_ONCE(1, "%s reg 0x%x temp %d for %d:%d:%d:%d\"\n",
+			  report, data->temp[core][place], temp,
+			  boot_cpu_data.x86_vendor, boot_cpu_data.x86,
+			  boot_cpu_data.x86_model, boot_cpu_data.x86_mask);
 
 	return sprintf(buf, "%d\n", temp);
 }
@@ -138,6 +166,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
 static struct pci_device_id k8temp_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{ 0 },
 };
 
@@ -157,6 +187,9 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 		goto exit;
 	}
 
+	if (boot_cpu_data.x86 > 0xf)
+		goto probe_done;
+
 	model = boot_cpu_data.x86_model;
 	stepping = boot_cpu_data.x86_mask;
 
@@ -226,6 +259,7 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 			data->sensorsp &= ~SEL_CORE;
 	}
 
+probe_done:
 	data->name = "k8temp";
 	mutex_init(&data->update_lock);
 	dev_set_drvdata(&pdev->dev, data);
-- 
1.6.0.6



