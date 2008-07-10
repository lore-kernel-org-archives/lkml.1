Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYGJSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYGJSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbYGJSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:65169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYGJSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061669"
Message-Id: <20080710182238.345436000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 17/26] x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
Content-Disposition: inline; filename=disable_dmar_if_intr_remapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt-remapping enables queued invalidation. And once queued invalidation
is enabled, IOTLB invalidation also needs to use the queued invalidation
mechanism and the register based IOTLB invalidation doesn't work.

For now, Support for IOTLB invalidation using queued invalidation is
missing. Meanwhile, disable DMA-remapping, if Interrupt-remapping
support is detected.

For the meanwhile, if someone wants to really enable DMA-remapping, they
can use nox2apic, which will disable interrupt-remapping and as such
doesn't enable queued invalidation.

And given that none of the release platforms support intr-remapping yet,
we should be ok for this temporary hack.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:52:03.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:52:19.000000000 -0700
@@ -457,6 +457,31 @@
 
 #ifdef CONFIG_DMAR
 	{
+		struct acpi_table_dmar *dmar;
+		/*
+		 * for now we will disable dma-remapping when interrupt
+		 * remapping is enabled.
+		 * When support for queued invalidation for IOTLB invalidation
+		 * is added, we will not need this any more.
+		 */
+		dmar = (struct acpi_table_dmar *) dmar_tbl;
+		if (ret && cpu_has_x2apic && dmar->flags & 0x1) {
+			printk(KERN_INFO
+			       "Queued invalidation will be enabled to support "
+			       "x2apic and Intr-remapping.\n");
+			printk(KERN_INFO
+			       "Disabling IOMMU detection, because of missing "
+			       "queued invalidation support for IOTLB "
+			       "invalidation\n");
+			printk(KERN_INFO
+			       "Use \"nox2apic\", if you want to use Intel "
+			       " IOMMU for DMA-remapping and don't care about "
+			       " x2apic support\n");
+
+			dmar_disabled = 1;
+			return;
+		}
+
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 		    !dmar_disabled)
 			iommu_detected = 1;

-- 

