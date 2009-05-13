Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZEMEzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZEMEzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZEMEzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:55:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52112 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZEMEzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:55:22 -0400
Message-ID: <4A0A5284.1000705@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:54:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards, v2
References: <20090508131333.GV8112@parisc-linux.org>
In-Reply-To: <20090508131333.GV8112@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Please ignore previous version, and could you review & test following
v2 instead?

Thanks,
H.Seto


The NIU device refuses to allow accesses to MSI-X registers before MSI-X
is enabled.  This patch fixes the problem by moving the read & write the
mask register (for preserved bits) to after MSI-X is enabled.

Reported-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..7b3cf4a 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -455,9 +455,7 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->mask_base = base;
-		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
-					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
-		msix_mask_irq(entry, 1);
+		entry->masked = 1;
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
@@ -493,6 +491,23 @@ static int msix_capability_init(struct pci_dev *dev,
 	msix_set_enable(dev, 1);
 	dev->msix_enabled = 1;
 
+	/*
+	 * The states of Reserved bits[31::01] of Vector Control for MSI-X
+	 * Table Entries must be 0.  However, for potential future use,
+	 * software must preserve the value of these reserved bits.
+	 * Refer PCI spec 3.0, 6.8.2.9.
+	 *
+	 * Note that there are some device that refuses access to MSI-X
+	 * Table Entries before MSI-X is enabled.  Therefore we do it here.
+	 */
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int vector = entry->msi_attrib.entry_nr;
+		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+		/* Make sure it is masked */
+		msix_mask_irq(entry, 1);
+	}
+
 	return 0;
 }
 
-- 
1.6.3


