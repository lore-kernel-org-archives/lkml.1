Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZLVXFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZLVXFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZLVXFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:05:31 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61964 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZLVXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/14] pci: reject mmio range start from 0 on pci_bridge read
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that is wrong.

exposed by that patch that doesn's shrink pci bridge res.

-v2: change to "bar reading" to "reg reading"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 98ffb2d..4b9f56f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -316,13 +316,17 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		limit |= (io_limit_hi << 16);
 	}
 
-	if (base <= limit) {
+	if (base <= limit && base) {
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
+	if (base <= limit && base) {
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+		        "  bridge window [mem 0x%08lx - 0x%08lx] reg reading\n",
+					 base, limit + 0xfffff);
 	}
 
 	res = child->resource[2];
@@ -366,7 +374,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 #endif
 		}
 	}
-	if (base <= limit) {
+	if (base <= limit && base) {
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
1.6.0.2

