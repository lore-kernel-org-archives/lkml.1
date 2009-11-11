Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZKKQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZKKQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZKKQtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:49:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47132 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbZKKQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:49:37 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/17] hpsa: Factor out some pci_unmap code
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:51:04 -0600
Message-ID: <20091111165104.17754.42113.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Factor out some pci_unmap code.  There are a few places
where the same, or nearly the same code is used to pci_unmap
data buffers of driver initiated commands.  Factor these out
into a separate function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   45 ++++++++++++++-------------------------------
 1 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81fbbff..74c054a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -928,17 +928,18 @@ static int hpsa_scsi_detect(struct ctlr_info *h)
 	return -1;
 }
 
-static void hpsa_unmap_one(struct pci_dev *pdev,
-		struct CommandList *cp,
-		size_t buflen,
-		int data_direction)
+static void hpsa_pci_unmap(struct pci_dev *pdev,
+	struct CommandList *c, int sg_used, int data_direction)
 {
+	int i;
 	union u64bit addr64;
 
-	addr64.val32.lower = cp->SG[0].Addr.lower;
-	addr64.val32.upper = cp->SG[0].Addr.upper;
-	pci_unmap_single(pdev, (dma_addr_t) addr64.val,
-		buflen, data_direction);
+	for (i = 0; i < sg_used; i++) {
+		addr64.val32.lower = c->SG[i].Addr.lower;
+		addr64.val32.upper = c->SG[i].Addr.upper;
+		pci_unmap_single(pdev, (dma_addr_t) addr64.val, c->SG[i].Len,
+			data_direction);
+	}
 }
 
 static void hpsa_map_one(struct pci_dev *pdev,
@@ -1055,7 +1056,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		TYPE_CMD);
 	if (rc == 0) {
 		hpsa_scsi_do_simple_cmd_core(h, c);
-		hpsa_unmap_one(h->pdev, c, bufsize, PCI_DMA_FROMDEVICE);
+		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
 
 		ei = c->err_info;
 		if (ei->CommandStatus != 0 &&
@@ -1162,7 +1163,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_unmap_one(h->pdev, c, bufsize, PCI_DMA_FROMDEVICE);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -2144,12 +2145,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Ext = 0; /* we are not chaining*/
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
-
-	/* unlock the buffers from DMA */
-	temp64.val32.lower = c->SG[0].Addr.lower;
-	temp64.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(h->pdev, (dma_addr_t) temp64.val, iocommand.buf_size,
-			 PCI_DMA_BIDIRECTIONAL);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 
 	/* Copy the error information out */
 	memcpy(&iocommand.error_info, c->err_info,
@@ -2277,14 +2273,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
-	/* unlock the buffers from DMA */
-	for (i = 0; i < sg_used; i++) {
-		temp64.val32.lower = c->SG[i].Addr.lower;
-		temp64.val32.upper = c->SG[i].Addr.upper;
-		pci_unmap_single(h->pdev,
-			(dma_addr_t) temp64.val, buff_size[i],
-			PCI_DMA_BIDIRECTIONAL);
-	}
+	hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2501,7 +2490,6 @@ static int sendcmd_core(struct ctlr_info *h, struct CommandList *c)
 	int i;
 	unsigned long complete;
 	int status = IO_ERROR;
-	union u64bit buff_dma_handle;
 
 resend_cmd1:
 	/*
@@ -2596,12 +2584,7 @@ resend_cmd1:
 	} while (1);
 
 cleanup1:
-
-	/* unlock the data buffer from DMA */
-	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
-	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
-			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 	return status;
 }
 

