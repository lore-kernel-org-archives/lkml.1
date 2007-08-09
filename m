Return-Path: <linux-kernel-owner+w=401wt.eu-S939380AbXHIMnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939380AbXHIMnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939636AbXHIMle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:50881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939626AbXHIMlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:31 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: bernarde@br.ibm.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/12] x86_64: Calgary - Fix mis-handled PCI topology
Message-Id: <20070809124129.9471514F3A@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Murillo Fernandes Bernardes <bernarde@br.ibm.com>
Subject: x86-64: Calgary - Fix mis-handled PCI topology

Current code assumed that devices were directly connected to a Calgary
bridge, as it tried to get the iommu table directly from the parent bus 
controller.

When we have another bridge between the Calgary/CalIOC2 bridge and the 
device we should look upwards until we get to the top (Calgary/CalIOC2 
bridge), where the iommu table resides.

Signed-off-by: Murillo Fernandes Bernardes <mfb@br.ibm.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/pci-calgary.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/kernel/pci-calgary.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-calgary.c
+++ linux/arch/x86_64/kernel/pci-calgary.c
@@ -367,16 +367,15 @@ static inline struct iommu_table *find_i
 
 	pdev = to_pci_dev(dev);
 
-	/* is the device behind a bridge? */
-	if (unlikely(pdev->bus->parent))
-		pbus = pdev->bus->parent;
-	else
-		pbus = pdev->bus;
+	pbus = pdev->bus;
+
+	/* is the device behind a bridge? Look for the root bus */
+	while (pbus->parent)
+		pbus = pbus->parent;
 
 	tbl = pci_iommu(pbus);
 
-	BUG_ON(pdev->bus->parent &&
-	       (tbl->it_busno != pdev->bus->parent->number));
+	BUG_ON(tbl && (tbl->it_busno != pbus->number));
 
 	return tbl;
 }
