Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbZLQBmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbZLQBmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZLQBl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:41:56 -0500
Received: from kroah.org ([198.145.64.141]:47847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763604AbZLQBUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:01 2009
Message-Id: <20091217011601.522223439@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [28/90] x86/amd-iommu: attach devices to pre-allocated domains early
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit be831297716036de5b24308447ecb69f1706a846 upstream.

For some devices the ACPI table may define unity map
requirements which must me met when the IOMMU is enabled. So
we need to attach devices to their domains as early as
possible so that these mappings are in place when needed.
This patch assigns the domains right after they are
allocated. Otherwise this can result in I/O page faults
before a driver binds to a device and BIOS is still using
it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1873,10 +1873,10 @@ static void prealloc_protection_domains(
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	u16 devid;
+	u16 devid, __devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		devid = calc_devid(dev->bus->number, dev->devfn);
+		__devid = devid = calc_devid(dev->bus->number, dev->devfn);
 		if (devid > amd_iommu_last_bdf)
 			continue;
 		devid = amd_iommu_alias_table[devid];
@@ -1891,6 +1891,10 @@ static void prealloc_protection_domains(
 		init_unity_mappings_for_device(dma_dom, devid);
 		dma_dom->target_dev = devid;
 
+		attach_device(iommu, &dma_dom->domain, devid);
+		if (__devid != devid)
+			attach_device(iommu, &dma_dom->domain, __devid);
+
 		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }


