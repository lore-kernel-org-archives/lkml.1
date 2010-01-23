Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982Ab0AWVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0AWVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755Ab0AWVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:16:28 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:34623 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0AWVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:16:28 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if iommu=allowed in kernel command line
Date: Sat, 23 Jan 2010 23:14:55 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc5; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001232314.55425.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If I start the kernel without command line parameters (4GB RAM)
iommu-swiotlb is used due to quirk in VIA K8T800Pro Host Bridge.
In that case all is OK.

If I put in the kernel command line: iommu=allowed (+other parameters)
I have iommu-gart used but no AGP. dmesg output:

[drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19

For debugging I patched the kernel (mostly prink(), shown at the end)
producing the output in the dmesg:

no command line
MDM: agp_amd64_init entered
MDM: agp_off: false
MDM: agp_bridges_found: 0
MDM: gart_iommu_aperture: 0
MDM: agp_amd64_probe entered

command line: iommu=allowed:
MDM: gart_iommu_init
MDM: before: no_agp = 0
MDM: 	agp_amd64_init entered
MDM: 	agp_off: false
MDM: 	agp_bridges_found: 0
MDM: after: no_agp = 1
MDM: agp_amd64_init() < 0: 1
MDM: agp_copy_info() < 0: -1
MDM: 	agp_amd64_init entered
MDM: 	agp_off: false
MDM: 	agp_bridges_found: 0

One see in the last case ( iommu=allowed) agp_amd64_init()
is executed twice, but agp_amd64_probe() is not executed at all
(agp_bridges_found is incremented only in agp_amd64_probe())

Is this expected behavior?

Thanks,

Marin Mitov

The testing patch:
--- ./drivers/char/agp/amd64-agp.c.orig	2010-01-23 18:46:46.000000000 +0200
+++ ./drivers/char/agp/amd64-agp.c	2010-01-23 22:09:44.000000000 +0200
@@ -498,7 +498,7 @@
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
 	int err;
-
+	printk(KERN_DEBUG "MDM: agp_amd64_probe entered\n");
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
@@ -725,13 +725,14 @@
 int __init agp_amd64_init(void)
 {
 	int err = 0;
-
+	printk(KERN_DEBUG "MDM: agp_amd64_init entered\n");
 	if (agp_off)
 		return -EINVAL;
-
+	printk(KERN_DEBUG "MDM: agp_off: false\n");
+	printk(KERN_DEBUG "MDM: agp_bridges_found: %d\n", agp_bridges_found);
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
-
+	printk(KERN_DEBUG "MDM: gart_iommu_aperture: %d\n", gart_iommu_aperture);
 	err = pci_register_driver(&agp_amd64_pci_driver);
 	if (err < 0)
 		return err;
--- ./arch/x86/kernel/pci-gart_64.c.orig	2010-01-23 17:07:42.000000000 +0200
+++ ./arch/x86/kernel/pci-gart_64.c	2010-01-23 17:47:22.000000000 +0200
@@ -734,20 +734,25 @@
 	unsigned long start_pfn, end_pfn;
 	unsigned long scratch;
 	long i;
+	int tmp1 = -1, tmp2 = -1;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
 		return 0;
 
+	printk(KERN_DEBUG "MDM: gart_iommu_init\n");
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
 #else
 	/* Makefile puts PCI initialization via subsys_initcall first. */
 	/* Add other K8 AGP bridge drivers here */
+	printk(KERN_DEBUG "MDM: before: no_agp = %d\n", no_agp);
 	no_agp = no_agp ||
-		(agp_amd64_init() < 0) ||
-		(agp_copy_info(agp_bridge, &info) < 0);
+		(tmp1 = (agp_amd64_init() < 0)) ||
+		(tmp2 = (agp_copy_info(agp_bridge, &info) < 0));
 #endif
-
+	printk(KERN_DEBUG "MDM: after: no_agp = %d\n", no_agp);
+	printk(KERN_DEBUG "MDM: agp_amd64_init() < 0: %d\n", tmp1);
+	printk(KERN_DEBUG "MDM: agp_copy_info() < 0: %d\n", tmp2); 
 	if (no_iommu ||
 	    (!force_iommu && max_pfn <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||


