Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbZGAAll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbZGAAll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760937AbZGAAcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:47 -0400
Received: from kroah.org ([198.145.64.141]:59790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760922AbZGAAcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:50 2009
Message-Id: <20090701001550.312076882@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Karsten Keil <keil@b1-systems.de>
Subject: [patch 13/35] ISDN: Fix DMA alloc for hfcpci
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=isdn-fix-dma-alloc-for-hfcpci.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Karsten Keil <keil@b1-systems.de>

commit 8a745b9d91962991ce87a649a4dc3af3206c2c8b upstream.

Replace wrong code with correct DMA API functions.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hisax/hfc_pci.c |   41 ++++++++++++++++++++++++++++++-----------
 drivers/isdn/hisax/hisax.h   |    2 +-
 2 files changed, 31 insertions(+), 12 deletions(-)

--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -82,8 +82,9 @@ release_io_hfcpci(struct IsdnCardState *
 	Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
 	pci_write_config_word(cs->hw.hfcpci.dev, PCI_COMMAND, 0);	/* disable memory mapped ports + busmaster */
 	del_timer(&cs->hw.hfcpci.timer);
-	kfree(cs->hw.hfcpci.share_start);
-	cs->hw.hfcpci.share_start = NULL;
+	pci_free_consistent(cs->hw.hfcpci.dev, 0x8000,
+		cs->hw.hfcpci.fifos, cs->hw.hfcpci.dma);
+	cs->hw.hfcpci.fifos = NULL;
 	iounmap((void *)cs->hw.hfcpci.pci_io);
 }
 
@@ -1663,8 +1664,19 @@ setup_hfcpci(struct IsdnCard *card)
 					     dev_hfcpci);
 		i++;
 		if (tmp_hfcpci) {
+			dma_addr_t	dma_mask = DMA_BIT_MASK(32) & ~0x7fffUL;
 			if (pci_enable_device(tmp_hfcpci))
 				continue;
+			if (pci_set_dma_mask(tmp_hfcpci, dma_mask)) {
+				printk(KERN_WARNING
+					"HiSax hfc_pci: No suitable DMA available.\n");
+				continue;
+			}
+			if (pci_set_consistent_dma_mask(tmp_hfcpci, dma_mask)) {
+				printk(KERN_WARNING
+					"HiSax hfc_pci: No suitable consistent DMA available.\n");
+				continue;
+			}
 			pci_set_master(tmp_hfcpci);
 			if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
 				continue;
@@ -1693,22 +1705,29 @@ setup_hfcpci(struct IsdnCard *card)
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
 		return (0);
 	}
+
 	/* Allocate memory for FIFOS */
-	/* Because the HFC-PCI needs a 32K physical alignment, we */
-	/* need to allocate the double mem and align the address */
-	if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
-		printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
+	cs->hw.hfcpci.fifos = pci_alloc_consistent(cs->hw.hfcpci.dev,
+					0x8000, &cs->hw.hfcpci.dma);
+	if (!cs->hw.hfcpci.fifos) {
+		printk(KERN_WARNING "HFC-PCI: Error allocating FIFO memory!\n");
+		return 0;
+	}
+	if (cs->hw.hfcpci.dma & 0x7fff) {
+		printk(KERN_WARNING
+		    "HFC-PCI: Error DMA memory not on 32K boundary (%lx)\n",
+		    (u_long)cs->hw.hfcpci.dma);
+		pci_free_consistent(cs->hw.hfcpci.dev, 0x8000,
+			cs->hw.hfcpci.fifos, cs->hw.hfcpci.dma);
 		return 0;
 	}
-	cs->hw.hfcpci.fifos = (void *)
-	    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
-	pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
+	pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u32)cs->hw.hfcpci.dma);
 	cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
 	printk(KERN_INFO
-	       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
+	       "HFC-PCI: defined at mem %p fifo %p(%lx) IRQ %d HZ %d\n",
 	       cs->hw.hfcpci.pci_io,
 	       cs->hw.hfcpci.fifos,
-	       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
+	       (u_long)cs->hw.hfcpci.dma,
 	       cs->irq, HZ);
 
 	spin_lock_irqsave(&cs->lock, flags);
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -694,7 +694,7 @@ struct hfcPCI_hw {
         int nt_timer;
         struct pci_dev *dev;
         unsigned char *pci_io; /* start of PCI IO memory */
-        void *share_start; /* shared memory for Fifos start */
+	dma_addr_t dma; /* dma handle for Fifos */
         void *fifos; /* FIFO memory */ 
         int last_bfifo_cnt[2]; /* marker saving last b-fifo frame count */
 	struct timer_list timer;


