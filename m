Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZEHNNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZEHNNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZEHNNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:13:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59104 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZEHNNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:13:33 -0400
Date: Fri, 8 May 2009 07:13:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix MSI-X with NIU cards
Message-ID: <20090508131333.GV8112@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The NIU device refuses to allow accesses to MSI-X registers before MSI-X
is enabled.  This patch fixes the problem by moving the read of the mask
register to after MSI-X is enabled.

Reported-by: David S. Miller <davem@davemloft.net>
Tested-by: David S. Miller <davem@davemloft.net>
Reviewed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..3627732 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -455,8 +455,6 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->mask_base = base;
-		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
-					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
 		msix_mask_irq(entry, 1);
 
 		list_add_tail(&entry->list, &dev->msi_list);
@@ -493,6 +491,12 @@ static int msix_capability_init(struct pci_dev *dev,
 	msix_set_enable(dev, 1);
 	dev->msix_enabled = 1;
 
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int vector = entry->msi_attrib.entry_nr;
+		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+	}
+
 	return 0;
 }
 

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
