Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYKVRgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYKVRgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbYKVRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355AbYKVRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:55 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 10/32] advansys fix on ISA-less configs
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wNi-0006Q3-JG@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


        if (shost->dma_channel != NO_ISA_DMA)
                free_dma(shost->dma_channel);

in there is triggerable only if we have CONFIG_ISA (we only set ->dma_channel to
something other than NO_ISA_DMA under #ifdef CONFIG_ISA).  OTOH, free_dma() is
not guaranteed to be there in absense of CONFIG_ISA.  IOW, driver runs into
undefined symbols on PCI-but-not-ISA configs (e.g. on frv) and it's a false
positive.

Fix: put the entire if () under #ifdef CONFIG_ISA; behaviour doesn't change and
dependency on free_dma() disappears for !CONFIG_ISA.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/advansys.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -13872,8 +13872,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	advansys_wide_free_mem(boardp);
 	free_irq(boardp->irq, shost);
  err_free_dma:
+#ifdef CONFIG_ISA
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
+#endif
  err_free_proc:
 	kfree(boardp->prtbuf);
  err_unmap:
@@ -13894,10 +13896,12 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(board->irq, shost);
+#ifdef CONFIG_ISA
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
+#endif
 	if (ASC_NARROW_BOARD(board)) {
 		dma_unmap_single(board->dev,
 					board->dvc_var.asc_dvc_var.overrun_dma,
