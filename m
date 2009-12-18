Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbZLRU4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbZLRU4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932855AbZLRU43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:56:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:52655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826AbZLRU4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:22 -0500
Message-ID: <4B2BEC35.4010502@kernel.org>
Date: Fri, 18 Dec 2009 12:55:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 6/12] pci: don't shrink bridge resources
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when we are clearing leaf bridge resource and try to get big one, we could shrink the bridge if
there is no resource under it.

let check with old resource size and make sure we are trying to get big one.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -390,7 +390,7 @@ static void pbus_size_io(struct pci_bus
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0;
+	unsigned long size = 0, size1 = 0, old_size;
 
 	if (!b_res)
  		return;
@@ -415,17 +415,18 @@ static void pbus_size_io(struct pci_bus
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
-		if (b_res->start || b_res->end)
-			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
 		b_res->flags = 0;
 		return;
 	}
@@ -441,7 +442,7 @@ static int pbus_size_mem(struct pci_bus
 			 unsigned long type, resource_size_t min_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size;
+	resource_size_t min_align, align, size, old_size;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -491,6 +492,11 @@ static int pbus_size_mem(struct pci_bus
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
@@ -507,10 +513,6 @@ static int pbus_size_mem(struct pci_bus
 	}
 	size = ALIGN(size, min_align);
 	if (!size) {
-		if (b_res->start || b_res->end)
-			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
 		b_res->flags = 0;
 		return 1;
 	}


