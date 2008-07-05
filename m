Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYGEUAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYGEUAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYGEUAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 16:00:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:64107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYGEUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 16:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IxemFSNvYAhPHTKWYkUyyEI1diVGmTiVF8zMsl6C/bBw3b7tiaThwFQfYAhhBuX0sS
         qoSJKGZ+XzPTYo8ViI5w+qDajrSQOifh24f6RORv4m4OzQMybOlC00OjK7X/s2Ejh5+8
         NOBRJzPkrjtOfTPMB1yxsqIrwV1VEPqG/OdUQ=
Subject: [PATCH] pxamci: fix byte aligned DMA transfers
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain
Date: Sat, 05 Jul 2008 22:00:18 +0200
Message-Id: <1215288018.23398.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pxa27x DMA controller defaults to 64-bit alignment. This caused
the SCR reads to fail (and, depending on card type, error out) when
card->raw_scr was not aligned on a 8-byte boundary.

For performance reasons all scatter-gather addresses passed to
pxamci_request should be aligned on 8-byte boundaries, but if
this can't be guaranteed, byte aligned DMA transfers in the
have to be enabled in the controller to get correct behaviour.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mmc/host/pxamci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 65210fc..d89475d 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -114,6 +114,7 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
 	unsigned int nob = data->blocks;
 	unsigned long long clks;
 	unsigned int timeout;
+	bool dalgn = 0;
 	u32 dcmd;
 	int i;
 
@@ -152,6 +153,9 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
 		host->sg_cpu[i].dcmd = dcmd | length;
 		if (length & 31 && !(data->flags & MMC_DATA_READ))
 			host->sg_cpu[i].dcmd |= DCMD_ENDIRQEN;
+		/* Not aligned to 8-byte boundary? */
+		if (sg_dma_address(&data->sg[i]) & 0x7)
+			dalgn = 1;
 		if (data->flags & MMC_DATA_READ) {
 			host->sg_cpu[i].dsadr = host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr = sg_dma_address(&data->sg[i]);
@@ -165,6 +169,15 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
 	host->sg_cpu[host->dma_len - 1].ddadr = DDADR_STOP;
 	wmb();
 
+	/*
+	 * The PXA27x DMA controller encounters overhead when working with
+	 * unaligned (to 8-byte boundaries) data, so switch on byte alignment
+	 * mode only if we have unaligned data.
+	 */
+	if (dalgn)
+		DALGN |= (1 << host->dma);
+	else
+		DALGN &= (1 << host->dma);
 	DDADR(host->dma) = host->sg_dma;
 	DCSR(host->dma) = DCSR_RUN;
 }
-- 
1.5.6


