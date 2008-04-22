Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYDVVlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYDVVlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbYDVVk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:40:57 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:58011 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYDVVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:40:56 -0400
Date: Wed, 23 Apr 2008 01:40:50 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
Message-ID: <20080422214050.GA1166@jurassic.park.msu.ru>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com> <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:25:34AM -0700, Linus Torvalds wrote:
> On Wed, 23 Apr 2008, Jeff Chua wrote:
> > yenta_cardbus 0000:15:00.0: device not available because of BAR 7 [100:1ff] collisions
> > yenta_cardbus: probe of 0000:15:00.0 failed with error -16
> 
> I suspect there wasn't a _real_ collision there, but the allocation failed 
> because of the alignment bits not being set up right for cardbus bridges, 
> but I'm not seeing the bug right now.
> 
> Ivan?

Yes, exactly. My fault - I somehow missed the cardbus stuff...

The patch below should fix that.

Ivan.

---
PCI: make resource_alignment() work for cardbus bridges

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 drivers/pci/setup-bus.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f9b7bdd..dbd80db 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -418,11 +418,11 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 */
 	b_res[0].start = pci_cardbus_io_size;
 	b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
-	b_res[0].flags |= IORESOURCE_IO;
+	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
 
 	b_res[1].start = pci_cardbus_io_size;
 	b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
-	b_res[1].flags |= IORESOURCE_IO;
+	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
 
 	/*
 	 * Check whether prefetchable memory is supported
@@ -443,15 +443,16 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
 		b_res[2].start = pci_cardbus_mem_size;
 		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH |
+				  IORESOURCE_STARTALIGN;
 
 		b_res[3].start = pci_cardbus_mem_size;
 		b_res[3].end = b_res[3].start + pci_cardbus_mem_size - 1;
-		b_res[3].flags |= IORESOURCE_MEM;
+		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_STARTALIGN;
 	} else {
 		b_res[3].start = pci_cardbus_mem_size * 2;
 		b_res[3].end = b_res[3].start + pci_cardbus_mem_size * 2 - 1;
-		b_res[3].flags |= IORESOURCE_MEM;
+		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_STARTALIGN;
 	}
 }
 
