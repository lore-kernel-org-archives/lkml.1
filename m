Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415Ab0AZX5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0AZX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436Ab0AZXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:37 -0500
Received: from kroah.org ([198.145.64.141]:35276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0AZXnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.150969376@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Reed <mdr@sgi.com>, James Smart <James.Smart@Emulex.Com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [40/98] [SCSI] lpfc: fix hang on SGI ia64 platform
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Reed <mdr@sgi.com>

commit 8e68597d087977d3e4fd3e735d290ab45fd0b5ea upstream.

In testing 2.6.31 on one of our ia64 platforms I've encountered a hang
due to the driver using hardware ATEs which are a limited resource.
This is because the driver does not set the dma consistent mask to
64 bits.

Signed-off-by: Michael Reed <mdr@sgi.com>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/lpfc/lpfc_init.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4384,9 +4384,13 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *
 		pdev = phba->pcidev;
 
 	/* Set the device DMA mask size */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0
+	 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(64)) != 0) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0
+		 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(32)) != 0) {
 			return error;
+		}
+	}
 
 	/* Get the bus address of Bar0 and Bar2 and the number of bytes
 	 * required by each mapping.
@@ -5940,9 +5944,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 		pdev = phba->pcidev;
 
 	/* Set the device DMA mask size */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0
+	 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(64)) != 0) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0
+		 || pci_set_consistent_dma_mask(pdev,DMA_BIT_MASK(32)) != 0) {
 			return error;
+		}
+	}
 
 	/* Get the bus address of SLI4 device Bar0, Bar1, and Bar2 and the
 	 * number of bytes required by each mapping. They are actually


