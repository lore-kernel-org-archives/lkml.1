Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYJXU7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYJXU7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYJXU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:59:10 -0400
Received: from gw.goop.org ([64.81.55.164]:34168 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYJXU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:59:08 -0400
Message-ID: <4902371A.5050303@goop.org>
Date: Fri, 24 Oct 2008 13:59:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bio common code no longer uses BIO_VMERGE_BOUNDARY, so replace it
with BIOVEC_PHYS_MERGEABLE.  Also make iommu_bio_merge a boolean
rather than a size, as befits its use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/include/asm/io.h    |    8 +++++++-
 arch/x86/include/asm/io_64.h |    2 --
 arch/x86/kernel/pci-dma.c    |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -33,7 +33,7 @@
 
 /* This tells the BIO block layer to assume merging. Default to off
    because we cannot guarantee merging later. */
-int iommu_bio_merge __read_mostly = 0;
+bool iommu_bio_merge __read_mostly = false;
 EXPORT_SYMBOL(iommu_bio_merge);
 
 dma_addr_t bad_dma_address __read_mostly = 0;
@@ -189,7 +189,7 @@
 		}
 
 		if (!strncmp(p, "biomerge", 8)) {
-			iommu_bio_merge = 4096;
+			iommu_bio_merge = true;
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
===================================================================
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 #define ARCH_HAS_IOREMAP_WC
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -59,12 +60,17 @@
 #define writeq writeq
 #endif
 
-extern int iommu_bio_merge;
+extern bool iommu_bio_merge;
 
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
 # include "io_64.h"
+#endif
+
+#ifdef CONFIG_X86_64
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(iommu_bio_merge && __BIOVEC_PHYS_MERGEABLE(vec1, vec2))
 #endif
 
 extern void *xlate_dev_mem_ptr(unsigned long phys);
===================================================================
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -232,8 +232,6 @@
 
 #define flush_write_buffers()
 
-#define BIO_VMERGE_BOUNDARY iommu_bio_merge
-
 /*
  * Convert a virtual cached pointer to an uncached pointer
  */


