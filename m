Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYDWS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYDWS5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYDWS46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:56:58 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:44717 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYDWS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:56:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Date: Wed, 23 Apr 2008 20:55:12 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: vojtech@suse.cz, muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de,
       mingo@redhat.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804232055.13102.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This untested patch is supposed to fix DMAing on some VIA boards.
Currently the DMA subsystem returns an error, if the driver does
tell that it supports a 64bit DMA mask. So the driver probing
would fail in that case. This happens for some b43 cards with
64bit DMA engines on VIA boards.
Instead of failing the dma_supported() check, simply strip off the
high 32bits.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This is not tested, due to the lack of hardware.


Index: wireless-testing/arch/x86/kernel/pci-dma_64.c
===================================================================
--- wireless-testing.orig/arch/x86/kernel/pci-dma_64.c	2008-04-01 15:53:17.000000000 +0200
+++ wireless-testing/arch/x86/kernel/pci-dma_64.c	2008-04-23 20:49:42.000000000 +0200
@@ -173,11 +173,8 @@ int dma_supported(struct device *dev, u6
 {
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
-
-
-
 		printk(KERN_INFO "PCI: Disallowing DAC for device %s\n", dev->bus_id);
-		return 0;
+		/* We strip off the high 32 bits in dma_set_mask() */
 	}
 #endif
 
@@ -215,6 +212,10 @@ int dma_set_mask(struct device *dev, u64
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
+
+	if (forbid_dac > 0)
+		mask &= 0xffffffff;
+
 	*dev->dma_mask = mask;
 	return 0;
 }
Index: wireless-testing/include/asm-x86/dma-mapping_32.h
===================================================================
--- wireless-testing.orig/include/asm-x86/dma-mapping_32.h	2008-02-16 19:08:15.000000000 +0100
+++ wireless-testing/include/asm-x86/dma-mapping_32.h	2008-04-23 20:46:12.000000000 +0200
@@ -137,10 +137,6 @@ dma_supported(struct device *dev, u64 ma
         if(mask < 0x00ffffff)
                 return 0;
 
-	/* Work around chipset bugs */
-	if (forbid_dac > 0 && mask > 0xffffffffULL)
-		return 0;
-
 	return 1;
 }
 
@@ -150,6 +146,10 @@ dma_set_mask(struct device *dev, u64 mas
 	if(!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
 
+	/* Work around chipset bugs */
+	if (forbid_dac > 0)
+		mask &= 0xffffffffULL;
+
 	*dev->dma_mask = mask;
 
 	return 0;

-- 
Greetings Michael.
