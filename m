Return-Path: <linux-kernel-owner+w=401wt.eu-S1946235AbXBPTMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946235AbXBPTMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946237AbXBPTMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:12:34 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4747 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946236AbXBPTMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:12:32 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 14:12:31 EST
X-Server-Uuid: 05DA3F36-9AA8-4766-A7E5-53B43A7C42E6
Subject: [PATCH] dma-mapping.h
From: "Gary Zambrano" <zambrano@broadcom.com>
To: jgarzik@pobox.com
cc: linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
Date: Fri, 16 Feb 2007 10:50:58 -0800
Message-ID: <1171651858.16919.14.camel@dhcp-10-7-81-58.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5)
X-WSS-ID: 69C8DFF228C2182435-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added dma_sync_single_range_for_cpu/device to dma-mapping.h in asm-arm &
asm-avr32 to call dma_sync_single_for_cpu/device. This patch enables b44
to compile on systems with these cpus.
This patch was created with the assumption that another method of
dma_sync_single_range_for_cpu/device does not exist on these
architectures.


Signed-off by: Gary Zambrano <zambrano@broadcom.com>

diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
index 9bc46b4..7d01450 100644
--- a/include/asm-arm/dma-mapping.h
+++ b/include/asm-arm/dma-mapping.h
@@ -294,6 +294,24 @@ dma_unmap_sg(struct device *dev, struct 
 extern void dma_unmap_sg(struct device *, struct scatterlist *, int, enum dma_data_direction);
 #endif
 
+#ifndef CONFIG_DMABOUNCE
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
+}
 
 /**
  * dma_sync_single_for_cpu
@@ -312,7 +330,6 @@ extern void dma_unmap_sg(struct device *
  * must first the perform a dma_sync_for_device, and then the
  * device again owns the buffer.
  */
-#ifndef CONFIG_DMABOUNCE
 static inline void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle, size_t size,
 			enum dma_data_direction dir)
@@ -329,6 +346,8 @@ dma_sync_single_for_device(struct device
 		consistent_sync((void *)dma_to_virt(dev, handle), size, dir);
 }
 #else
+extern void dma_sync_single_range_for_cpu(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
+extern void dma_sync_single_range_for_device(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
 extern void dma_sync_single_for_cpu(struct device*, dma_addr_t, size_t, enum dma_data_direction);
 extern void dma_sync_single_for_device(struct device*, dma_addr_t, size_t, enum dma_data_direction);
 #endif
diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index 115813e..dfd1fb3 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -242,6 +242,24 @@ dma_unmap_sg(struct device *dev, struct 
 {
 
 }
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
+}
+
 
 /**
  * dma_sync_single_for_cpu


