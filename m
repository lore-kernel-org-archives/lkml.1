Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZF3Mek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZF3Mek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZF3Mec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:34:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZF3Mec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:34:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Tue, 30 Jun 2009 14:34:26 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906291845.16335.arnd@arndb.de> <20090629181603.079f32f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090629181603.079f32f1@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906301434.26815.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18oRgg8wiSnsLVBd92eyARJF0yqYhfIyetFU/3
 sQ4w5QtoierrgA9tW+QPwjsYe/HF5+QG7GDIMp85Tox4xYp0wP
 LPjXocKdcL4DeEP36NaRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Cox wrote:
> > Of course that raises the question of whether smp_wmb() is too weak in case of
> > !SMP or X86_PPRO_FENCE, but with the described scenario, I don't think
> > it does.
> 
> I'm pretty sure it is for the Winchip -but we don't care as there are no
> SMP ones. OTOH with DMA we do care

Ok. The Winchip also does not have an IOMMU or the need for SWIOTLB, so
I guess it would be ok to move the flush_write_buffers() out of the common
code into the x86 pci-nommu implementation. That one is also the only
place that calls flush_write_buffers() in dma_map_().

This would need to get revisited if we want to implement OOSTORE for
VIA Nano, which could then need it in swiotlb.
---
[PATCH] asm-generic: remove calling flush_write_buffers() in dma_sync_*

Flushing the write buffers is only needed on x86 processors using OOSTORE
(currently only pre-VIA Centaur processors) when giving a buffer to the
device, but not for handing it back. 

Based on an earlier patch from Ming Lei <tom.leiming@gmail.com>

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -79,12 +79,29 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static void nommu_sync_single_for_device(struct device *dev,
+			dma_addr_t addr, size_t size,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
+
+static void nommu_sync_sg_for_device(struct device *dev,
+			struct scatterlist *sg, int nelems,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent	= dma_generic_alloc_coherent,
-	.free_coherent	= nommu_free_coherent,
-	.map_sg		= nommu_map_sg,
-	.map_page	= nommu_map_page,
-	.is_phys	= 1,
+	.alloc_coherent		= dma_generic_alloc_coherent,
+	.free_coherent		= nommu_free_coherent,
+	.map_sg			= nommu_map_sg,
+	.map_page		= nommu_map_page,
+	.sync_single_for_device = nommu_sync_single_for_device,
+	.sync_sg_for_device	= nommu_sync_sg_for_device,
+	.is_phys		= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 5406a60..e694263 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -103,7 +103,6 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_for_device(struct device *dev,
@@ -116,7 +115,6 @@ static inline void dma_sync_single_for_device(struct device *dev,
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
 	debug_dma_sync_single_for_device(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
@@ -132,7 +130,6 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -150,7 +147,6 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_device(dev, addr, size, dir);
 }
@@ -165,7 +161,6 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-	flush_write_buffers();
 }
 
 static inline void
@@ -179,7 +174,6 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
 
-	flush_write_buffers();
 }
 
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
