Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYGEIVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYGEIVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYGEIVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:21:36 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:40324 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYGEIVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cUdow+X/hGxl0eVejr+zxJgdykdsQMCkm2oRyLhr80m2TqVHJYMJ85aryfLZIHG0gF
         z8qAq8owyO97z5zRUnfA3Gi2CXmpGwS6v71GcKbmLNb7nJrhHyfCHInZ01yVTOmraXPc
         0W9PZl/oe3wfBaMnkJM7ihAF80NSjc+V5Blh0=
Message-ID: <74d0deb30807050121n38c44dfaoa843fe8a0b581d01@mail.gmail.com>
Date: Sat, 5 Jul 2008 10:21:31 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Marek Vasut" <marek.vasut@gmail.com>
Subject: Re: [PATCH] fix misalignment in pxamci
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
In-Reply-To: <200807050219.52218.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807050219.52218.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 2:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Hi,
> Philipp Zabel finally made the pxamci issue clear. It turned out, that pxamci
> needs the DMA destination address to be aligned to 8 bytes. In some cases it
> happened, that the address was aligned to 4 bytes causing controller to
> incorrectly transfer data (and resulting into error like "mmc0: unrecognised
> SCR structure version 1"). The following patch allows to debug this issue and
> moreover fixes it by moving one 4 byte entry of mmc_card structure, aligning
> the DMA destination back to 8 bytes.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

We can enable byte aligned transfers on the DMA controller. This is
what I came up with yesterday:
(sorry for wrapped lines - the proper patch should probably be a
combination of both
warning/DALGN handling and and moving something in mmc_card around).

regards
Philipp

---
Subject: [PATCH] pxamci: fix byte aligned DMA transfers

The pxa27x DMA controller defaults to 64-bit alignment. This caused
the SCR reads to fail (and, depending on card type, error out) when
card->raw_scr was not aligned on a 8-byte boundary.

I think for performance reasons all scatter-gather addresses passed
to pxamci_request should be aligned on 8-byte boundaries, but right
now enabling byte aligned DMA transfers in the controller fixes those
problems.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mmc/host/pxamci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 65210fc..ba580d3 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -114,6 +114,7 @@ static void pxamci_setup_data(struct pxamci_host
*host, struct mmc_data *data)
 	unsigned int nob = data->blocks;
 	unsigned long long clks;
 	unsigned int timeout;
+	bool dalgn = 0;
 	u32 dcmd;
 	int i;

@@ -152,6 +153,8 @@ static void pxamci_setup_data(struct pxamci_host
*host, struct mmc_data *data)
 		host->sg_cpu[i].dcmd = dcmd | length;
 		if (length & 31 && !(data->flags & MMC_DATA_READ))
 			host->sg_cpu[i].dcmd |= DCMD_ENDIRQEN;
+		if (sg_dma_address(&data->sg[i]) & 0x7)
+			dalgn = 1;
 		if (data->flags & MMC_DATA_READ) {
 			host->sg_cpu[i].dsadr = host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr = sg_dma_address(&data->sg[i]);
@@ -165,6 +168,11 @@ static void pxamci_setup_data(struct pxamci_host
*host, struct mmc_data *data)
 	host->sg_cpu[host->dma_len - 1].ddadr = DDADR_STOP;
 	wmb();

+	if (dalgn) {
+		pr_warning("PXAMCI: byte aligned DMA transfer\n");
+		DALGN |= (1 << host->dma);
+	} else
+		DALGN &= (1 << host->dma);
 	DDADR(host->dma) = host->sg_dma;
 	DCSR(host->dma) = DCSR_RUN;
 }
-- 
1.5.6
