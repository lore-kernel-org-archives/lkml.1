Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZEMELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZEMELY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZEMELN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:11:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51590 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZEMELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:11:13 -0400
Message-ID: <4A0A4829.8080709@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:10:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, "David S. Miller" <davem@davemloft.net>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards
References: <20090508131333.GV8112@parisc-linux.org>
In-Reply-To: <20090508131333.GV8112@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Could you review & test following patch for your issue?

Thanks,
H.Seto


The NIU device refuses to allow accesses to MSI-X registers before MSI-X
is enabled.  This patch fixes the problem by removing the read & write of
the mask register in msix_capability_init().  It will be safe since PCI
spac says the maskbit's state after reset is always 1 (= masked).

Reported-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..b680a5b 100644
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
-- 
1.6.3


