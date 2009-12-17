Return-Path: <linux-kernel-owner+w=401wt.eu-S1763847AbZLQED6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763847AbZLQED6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761781AbZLQEDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:47 -0500
Received: from kroah.org ([198.145.64.141]:55281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762993AbZLQEDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:45 2009
Message-Id: <20091217035645.040589929@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [016/151] x86/amd-iommu: attach devices to pre-allocated domains early
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2047,10 +2047,10 @@ static void prealloc_protection_domains(
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
@@ -2065,6 +2065,10 @@ static void prealloc_protection_domains(
 		init_unity_mappings_for_device(dma_dom, devid);
 		dma_dom->target_dev = devid;
 
+		attach_device(iommu, &dma_dom->domain, devid);
+		if (__devid != devid)
+			attach_device(iommu, &dma_dom->domain, __devid);
+
 		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }


