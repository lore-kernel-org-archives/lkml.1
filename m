Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633Ab0AVJDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0AVJDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570Ab0AVJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:03:09 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45860 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0AVJDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:03:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:02:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/9] pci: don't shrink bridge resources
In-reply-to: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264150948-9052-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when we are clearing leaf bridge resource and try to get big one, we could
shrink the bridge if there is no resource under it.

let check with old resource size and make sure we are trying to get big one.

-v2: keep disable window print out, still could happen on non pci hotplug system

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7e87ea8..f560814 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -382,7 +382,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0;
+	unsigned long size = 0, size1 = 0, old_size;
 
 	if (!b_res)
  		return;
@@ -407,12 +407,17 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 	}
 	if (size < min_size)
 		size = min_size;
+	old_size = resource_size(b_res);
+	if (old_size == 1)
+		old_size = 0;
 /* To be fixed in 2.5: we should have sort of HAVE_ISA
    flag in the struct pci_bus. */
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
 	size = ALIGN(size + size1, 4096);
+	if (size < old_size)
+		size = old_size;
 	if (!size) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
@@ -433,7 +438,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 unsigned long type, resource_size_t min_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size;
+	resource_size_t min_align, align, size, old_size;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -483,6 +488,11 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	}
 	if (size < min_size)
 		size = min_size;
+	old_size = resource_size(b_res);
+	if (old_size == 1)
+		old_size = 0;
+	if (size < old_size)
+		size = old_size;
 
 	align = 0;
 	min_align = 0;
-- 
1.6.4.2

