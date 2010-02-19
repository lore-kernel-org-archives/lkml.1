Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0BSRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:07:14 -0500
Received: from kroah.org ([198.145.64.141]:57751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab0BSRBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:03 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:50 2010
Message-Id: <20100219163250.419135614@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [71/93] x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit f5325094379158e6b876ea0010c807bf7890ec8f upstream

This patch moves the initialization of the iommu-api out of
the dma-ops initialization code. This ensures that the
iommu-api is initialized even with iommu=pt.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |    7 +++++--
 arch/x86/kernel/amd_iommu_init.c |    3 +++
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -32,6 +32,7 @@ extern void amd_iommu_flush_all_domains(
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_shutdown(void);
 extern void amd_iommu_apply_erratum_63(u16 devid);
+extern void amd_iommu_init_api(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2083,6 +2083,11 @@ static struct dma_map_ops amd_iommu_dma_
 	.dma_supported = amd_iommu_dma_supported,
 };
 
+void __init amd_iommu_init_api(void)
+{
+	register_iommu(&amd_iommu_ops);
+}
+
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
@@ -2124,8 +2129,6 @@ int __init amd_iommu_init_dma_ops(void)
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
-	register_iommu(&amd_iommu_ops);
-
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
 	amd_iommu_stats_init();
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1288,9 +1288,12 @@ int __init amd_iommu_init(void)
 		ret = amd_iommu_init_passthrough();
 	else
 		ret = amd_iommu_init_dma_ops();
+
 	if (ret)
 		goto free;
 
+	amd_iommu_init_api();
+
 	enable_iommus();
 
 	if (iommu_pass_through)


