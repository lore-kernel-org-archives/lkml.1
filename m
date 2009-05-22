Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZEVMWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZEVMWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbZEVMVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:21:52 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55273 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbZEVMVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:21:50 -0400
X-BigFish: VPS10(zz19c1l19c2kzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1P01-04-A1U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/12] amd-iommu: remove amd_iommu_size kernel parameter
Date: Fri, 22 May 2009 14:21:30 +0200
Message-ID: <1242994893-28902-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0080 (UTC) FILETIME=[D7D73980:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: parameter not longer necessary when aperture increases dynamically ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    5 -----
 arch/x86/kernel/amd_iommu.c         |   18 ++++--------------
 arch/x86/kernel/amd_iommu_init.c    |   15 ---------------
 3 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..5b776c6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -329,11 +329,6 @@ and is between 256 and 4096 characters. It is defined in the file
 				    flushed before they will be reused, which
 				    is a lot of faster
 
-	amd_iommu_size= [HW,X86-64]
-			Define the size of the aperture for the AMD IOMMU
-			driver. Possible values are:
-			'32M', '64M' (default), '128M', '256M', '512M', '1G'
-
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d129d8f..31d56c3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -939,17 +939,10 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
  * It also intializes the page table and the address allocator data
  * structures required for the dma_ops interface
  */
-static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
-						   unsigned order)
+static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 {
 	struct dma_ops_domain *dma_dom;
 
-	/*
-	 * Currently the DMA aperture must be between 32 MB and 1GB in size
-	 */
-	if ((order < 25) || (order > 30))
-		return NULL;
-
 	dma_dom = kzalloc(sizeof(struct dma_ops_domain), GFP_KERNEL);
 	if (!dma_dom)
 		return NULL;
@@ -1087,7 +1080,6 @@ static int device_change_notifier(struct notifier_block *nb,
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	unsigned long flags;
 
 	if (devid > amd_iommu_last_bdf)
@@ -1126,7 +1118,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		dma_domain = find_protection_domain(devid);
 		if (dma_domain)
 			goto out;
-		dma_domain = dma_ops_domain_alloc(iommu, order);
+		dma_domain = dma_ops_domain_alloc(iommu);
 		if (!dma_domain)
 			goto out;
 		dma_domain->target_dev = devid;
@@ -1826,7 +1818,6 @@ static void prealloc_protection_domains(void)
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	u16 devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
@@ -1839,7 +1830,7 @@ static void prealloc_protection_domains(void)
 		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
-		dma_dom = dma_ops_domain_alloc(iommu, order);
+		dma_dom = dma_ops_domain_alloc(iommu);
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
@@ -1865,7 +1856,6 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	int ret;
 
 	/*
@@ -1874,7 +1864,7 @@ int __init amd_iommu_init_dma_ops(void)
 	 * protection domain will be assigned to the default one.
 	 */
 	list_for_each_entry(iommu, &amd_iommu_list, list) {
-		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
+		iommu->default_dom = dma_ops_domain_alloc(iommu);
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
 		iommu->default_dom->domain.flags |= PD_DEFAULT_MASK;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..762a4ee 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -121,7 +121,6 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
-unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
 bool amd_iommu_isolate = true;		/* if true, device isolation is
 					   enabled */
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
@@ -1137,9 +1136,6 @@ int __init amd_iommu_init(void)
 
 	enable_iommus();
 
-	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
-			(1 << (amd_iommu_aperture_order-20)));
-
 	printk(KERN_INFO "AMD IOMMU: device isolation ");
 	if (amd_iommu_isolate)
 		printk("enabled\n");
@@ -1225,15 +1221,4 @@ static int __init parse_amd_iommu_options(char *str)
 	return 1;
 }
 
-static int __init parse_amd_iommu_size_options(char *str)
-{
-	unsigned order = PAGE_SHIFT + get_order(memparse(str, &str));
-
-	if ((order > 24) && (order < 31))
-		amd_iommu_aperture_order = order;
-
-	return 1;
-}
-
 __setup("amd_iommu=", parse_amd_iommu_options);
-__setup("amd_iommu_size=", parse_amd_iommu_size_options);
-- 
1.6.3.1


