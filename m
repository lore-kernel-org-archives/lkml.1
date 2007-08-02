Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbXHBNkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbXHBNkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXHBNjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:39:52 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:13292 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXHBNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:39:51 -0400
Date: Thu, 2 Aug 2007 16:39:26 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@suse.de>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>,
       Murillo Fernandes Bernardes <bernarde@br.ibm.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH x86-64] Calgary - Fix mis-handled PCI topology
Message-ID: <20070802133926.GI25771@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you please push this Calgary bug-fix to 2.6.23 in your
next merge? it fixes a showstopper bug in the recently merged CalIOC2
support that hits machines with multiple levels of PCI-to-PCI bridges.

Thanks,
Muli
---
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

--
diff -ruN linux-2.6.23-rc1.orig/arch/x86_64/kernel/pci-calgary.c linux-2.6.23-rc1/arch/x86_64/kernel/pci-calgary.c
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/pci-calgary.c	2007-08-01 15:37:04.000000000 -0300
+++ linux-2.6.23-rc1/arch/x86_64/kernel/pci-calgary.c	2007-08-01 15:48:55.000000000 -0300
@@ -367,16 +367,15 @@
 
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





