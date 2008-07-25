Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYGYLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYGYLIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGYLI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:08:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54369 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYGYLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:08:26 -0400
X-BigFish: VPS14(z1857rzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K4K6XA-03-EIS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>, Wei Wang <wei.wang2@amd.com>
Subject: [PATCH] AMD IOMMU: include amd_iommu_last_bdf in device initialization
Date: Fri, 25 Jul 2008 13:07:50 +0200
Message-ID: <1216984070-8677-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 25 Jul 2008 11:07:51.0029 (UTC) FILETIME=[ADC10A50:01C8EE46]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the values read while searching for amd_iommu_last_bdf are defined as
inclusive. Let the code handle this value as such. Found by Wei Wang. Thanks
Wei.

Cc: Wei Wang <wei.wang2@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c      |    4 ++--
 arch/x86/kernel/amd_iommu_init.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c25210e..7469740 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -667,7 +667,7 @@ static int get_device_resources(struct device *dev,
 	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
 
 	/* device not translated by any IOMMU in the system? */
-	if (_bdf >= amd_iommu_last_bdf) {
+	if (_bdf > amd_iommu_last_bdf) {
 		*iommu = NULL;
 		*domain = NULL;
 		*bdf = 0xffff;
@@ -1085,7 +1085,7 @@ void prealloc_protection_domains(void)
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		devid = (dev->bus->number << 8) | dev->devfn;
-		if (devid >= amd_iommu_last_bdf)
+		if (devid > amd_iommu_last_bdf)
 			continue;
 		devid = amd_iommu_alias_table[devid];
 		if (domain_for_device(devid))
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c9d8ff2..d9a9da5 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -732,7 +732,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 		set_device_exclusion_range(m->devid, m);
 		break;
 	case ACPI_IVMD_TYPE_ALL:
-		for (i = 0; i < amd_iommu_last_bdf; ++i)
+		for (i = 0; i <= amd_iommu_last_bdf; ++i)
 			set_device_exclusion_range(i, m);
 		break;
 	case ACPI_IVMD_TYPE_RANGE:
@@ -934,7 +934,7 @@ int __init amd_iommu_init(void)
 	/*
 	 * let all alias entries point to itself
 	 */
-	for (i = 0; i < amd_iommu_last_bdf; ++i)
+	for (i = 0; i <= amd_iommu_last_bdf; ++i)
 		amd_iommu_alias_table[i] = i;
 
 	/*
-- 
1.5.3.7


