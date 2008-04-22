Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYDVWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYDVWA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbYDVWAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:00:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920AbYDVWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:00:14 -0400
Date: Tue, 22 Apr 2008 14:59:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
In-Reply-To: <20080422214050.GA1166@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com> <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org> <20080422214050.GA1166@jurassic.park.msu.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Ivan Kokshaysky wrote:
> 
> Yes, exactly. My fault - I somehow missed the cardbus stuff...

Ok, this patch looks sane, but ...

Don't cardbus bus resources work the same way as _normal_ IO resources, ie 
the alignment is the same as the size?

So I think we could clean this up a bit, and just use IORESOURCE_SIZEALIGN 
for Cardbus bridges, which leads to much more obvious code (ie just keep 
the base at zero)?

(In fact, I think cardbus bridges have a much more flexible alignment than 
that size thing, and can be aligned at finer granularity, but I forget the 
exact details, and since we didn't add a special "alignment" field, we 
can't take advantage of it anyway).

Patch entirely UNTESTED!

		Linus

---
 drivers/pci/setup-bus.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f9b7bdd..8ddb918 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -416,13 +416,13 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 * Reserve some resources for CardBus.  We reserve
 	 * a fixed amount of bus space for CardBus bridges.
 	 */
-	b_res[0].start = pci_cardbus_io_size;
-	b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
-	b_res[0].flags |= IORESOURCE_IO;
+	b_res[0].start = 0;
+	b_res[0].end = pci_cardbus_io_size - 1;
+	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
 
-	b_res[1].start = pci_cardbus_io_size;
-	b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
-	b_res[1].flags |= IORESOURCE_IO;
+	b_res[1].start = 0;
+	b_res[1].end = pci_cardbus_io_size - 1;
+	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
 
 	/*
 	 * Check whether prefetchable memory is supported
@@ -441,17 +441,17 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 * twice the size.
 	 */
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
-		b_res[2].start = pci_cardbus_mem_size;
-		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		b_res[2].start = 0;
+		b_res[2].end = pci_cardbus_mem_size - 1;
+		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
 
-		b_res[3].start = pci_cardbus_mem_size;
-		b_res[3].end = b_res[3].start + pci_cardbus_mem_size - 1;
-		b_res[3].flags |= IORESOURCE_MEM;
+		b_res[3].start = 0;
+		b_res[3].end = pci_cardbus_mem_size - 1;
+		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
 	} else {
-		b_res[3].start = pci_cardbus_mem_size * 2;
-		b_res[3].end = b_res[3].start + pci_cardbus_mem_size * 2 - 1;
-		b_res[3].flags |= IORESOURCE_MEM;
+		b_res[3].start = 0;
+		b_res[3].end = pci_cardbus_mem_size * 2 - 1;
+		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
 	}
 }
 
