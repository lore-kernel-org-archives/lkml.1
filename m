Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbXLTIkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbXLTIkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXLTIkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:40:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40658
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbXLTIkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:40:41 -0500
Date: Thu, 20 Dec 2007 00:40:33 -0800 (PST)
Message-Id: <20071220.004033.75315225.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       krh@bitplanet.net, linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: David Miller <davem@davemloft.net>
In-Reply-To: <476947C1.2010405@s5r6.in-berlin.de>
References: <4767A323.7090205@s5r6.in-berlin.de>
	<20071218.142956.26529678.davem@davemloft.net>
	<476947C1.2010405@s5r6.in-berlin.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Wed, 19 Dec 2007 17:33:05 +0100

> Does arch/sparc64/kernel/pci.c fill them in incorrectly or too late?

The problem is that I created indirection that was totally unused, the
operation vectors members for these cases thus didn't get filled in,
and we OOPS trying to call NULL pointers as functions :-)

This should fix the crash:

diff --git a/include/asm-sparc64/dma-mapping.h b/include/asm-sparc64/dma-mapping.h
index 1fc6554..38cbec7 100644
--- a/include/asm-sparc64/dma-mapping.h
+++ b/include/asm-sparc64/dma-mapping.h
@@ -25,15 +25,9 @@ struct dma_ops {
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction direction);
-	void (*sync_single_for_device)(struct device *dev,
-				       dma_addr_t dma_handle, size_t size,
-				       enum dma_data_direction direction);
 	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
 				int nelems,
 				enum dma_data_direction direction);
-	void (*sync_sg_for_device)(struct device *dev, struct scatterlist *sg,
-				   int nelems,
-				   enum dma_data_direction direction);
 };
 extern const struct dma_ops *dma_ops;
 
@@ -105,7 +99,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					      size_t size,
 					      enum dma_data_direction direction)
 {
-	dma_ops->sync_single_for_device(dev, dma_handle, size, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
@@ -123,7 +117,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 						    size_t size,
 						    enum dma_data_direction direction)
 {
-	dma_sync_single_for_device(dev, dma_handle+offset, size, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 
@@ -138,7 +132,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 					  struct scatterlist *sg, int nelems,
 					  enum dma_data_direction direction)
 {
-	dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+	/* No flushing needed to sync cpu writes to the device.  */
 }
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
