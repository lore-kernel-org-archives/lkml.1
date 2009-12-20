Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZLTTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZLTTlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZLTTlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:41:51 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59874 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756175AbZLTTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:41:50 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-scsi@vger.kernel.org
Subject: [PATCH 3/3] g_NCR5380: fix missing pnp_device_detach and scsi_unregister on rmmod
Date: Sun, 20 Dec 2009 20:41:42 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912202041.44198.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing pnp_device_detach() and scsi_unregister() at rmmod time.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.h	2009-12-20 20:32:25.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.h	2009-12-20 20:32:39.000000000 +0100
@@ -82,10 +82,11 @@ static const char* generic_NCR5380_info(
 #define NCR5380_write(reg, value) (outb((value), (NCR5380_map_name + (reg))))
 
 #define NCR5380_implementation_fields \
-    NCR5380_map_type NCR5380_map_name
+    NCR5380_map_type NCR5380_map_name; \
+    struct pnp_dev *pnpdev;
 
 #define NCR5380_local_declare() \
-    register NCR5380_implementation_fields
+    NCR5380_map_type NCR5380_map_name
 
 #define NCR5380_setup(instance) \
     NCR5380_map_name = (NCR5380_map_type)((instance)->NCR5380_instance_name)
--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.c	2009-12-20 20:32:25.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.c	2009-12-20 20:32:39.000000000 +0100
@@ -290,6 +290,7 @@ int __init generic_NCR5380_detect(struct
 #ifndef SCSI_G_NCR5380_MEM
 	int i;
 	unsigned long region_size = 16;
+	struct pnp_dev *pnpdevs[NO_OVERRIDES];
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
@@ -337,6 +338,7 @@ int __init generic_NCR5380_detect(struct
 				pnp_device_detach(dev);
 				continue;
 			}
+			pnpdevs[count] = dev;
 			if (pnp_irq_valid(dev, 0))
 				overrides[count].irq = pnp_irq(dev, 0);
 			else
@@ -449,6 +451,7 @@ int __init generic_NCR5380_detect(struct
 		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
 #ifndef SCSI_G_NCR5380_MEM
 		instance->n_io_port = region_size;
+		((struct NCR5380_hostdata *)instance->hostdata)->pnpdev = pnpdevs[current_override];
 #else
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
@@ -520,12 +523,14 @@ int generic_NCR5380_release_resources(st
 
 #ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->NCR5380_instance_name, instance->n_io_port);
+	if (((struct NCR5380_hostdata *)instance->hostdata)->pnpdev)
+		pnp_device_detach(((struct NCR5380_hostdata *)instance->hostdata)->pnpdev);
 #else
 	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
 	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
 #endif
 
-
+	scsi_unregister(instance);
 	return 0;
 }
 

-- 
Ondrej Zary
