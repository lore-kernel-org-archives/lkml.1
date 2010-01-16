Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0APLMa (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990Ab0APLM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:12:26 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38788 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0APLIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:50 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/11] pci: reject mmio range start from 0 on pci_bridge read
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only need to set the value to resource.
also could keep the old setting in resource for prevent shrink bridge
resources.

-v2: change to "bar reading" to "reg reading"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 11824d7..8cd4fb3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -316,13 +316,17 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		limit |= (io_limit_hi << 16);
 	}
 
-	if (base <= limit) {
+	if (base && base <= limit) {
 		res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
 		if (!res->start)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+			 "  bridge window [io  %04lx - %04lx] reg reading\n",
+				 base, limit);
 	}
 
 	res = child->resource[1];
@@ -330,11 +334,15 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = (mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
 	limit = (mem_limit_lo & PCI_MEMORY_RANGE_MASK) << 16;
-	if (base <= limit) {
+	if (base && base <= limit) {
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+			"  bridge window [mem 0x%08lx - 0x%08lx] reg reading\n",
+					 base, limit + 0xfffff);
 	}
 
 	res = child->resource[2];
@@ -366,7 +374,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 #endif
 		}
 	}
-	if (base <= limit) {
+	if (base && base <= limit) {
 		res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
 					 IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		if (res->flags & PCI_PREF_RANGE_TYPE_64)
@@ -374,6 +382,10 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+		     "  bridge window [mem 0x%08lx - %08lx pref] reg reading\n",
+					 base, limit + 0xfffff);
 	}
 }
 
-- 
1.6.4.2

