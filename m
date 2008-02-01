Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYBAJz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYBAJz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbYBAJxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:25 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58372 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbYBAJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:24 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/12] GBPAGES: Switch pci-gart over to using cpa instead of clear_kernel_mapping
Message-Id: <20080201095322.551CF1B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:22 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:04.0843 (UTC) FILETIME=[66E97DB0:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pci-gart needs to unmap the IOMMU aperture to prevent cache corruptions.

Switch this over to using cpa instead of clear_kernel_mapping()

Drawback right now is that cpa will split everything down to 4k
pages, and this costs 4K for each 2MB of aperture; 128KB for a typical
64MB aperture.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/pci-gart_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux.orig/arch/x86/kernel/pci-gart_64.c
+++ linux/arch/x86/kernel/pci-gart_64.c
@@ -731,7 +731,8 @@ void __init gart_iommu_init(void)
 	 * the backing memory. The GART address is only used by PCI
 	 * devices.
 	 */
-	clear_kernel_mapping((unsigned long)__va(iommu_bus_base), iommu_size);
+	set_memory_np((unsigned long)__va(iommu_bus_base),
+				iommu_size >> PAGE_SHIFT);
 
 	/*
 	 * Try to workaround a bug (thanks to BenH)
