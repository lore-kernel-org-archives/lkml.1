Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYKCUGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYKCUGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbYKCUFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:05:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:11135 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYKCUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=P+oVqEST+g63+9qg4sSmEfNkiPvpG+UHLir4ZMyy98QgPLqtjxdwLL5qzPWX7fmPov
         4KFYr4vEOKJbxZQT1RZwii/1tOUmsu6GPlRI1JgWl65URNZVU0cst9tAFzJ6poli6cHH
         Hwu0NlsgTeijQVsVCh8zsqwmKMptVxjDWQgFE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 03 Nov 2008 21:03:13 +0100
Message-Id: <20081103200313.5098.63642.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/6] trm290: add IDE_HFLAG_TRM290 host flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] trm290: add IDE_HFLAG_TRM290 host flag

* Add IDE_HFLAG_TRM290 host flag and use it in ide_build_dmatable().

* Remove no longer needed ide_trm290 chipset type.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma-sff.c |    2 +-
 drivers/ide/ide-proc.c    |    1 -
 drivers/ide/trm290.c      |    4 ++--
 include/linux/ide.h       |    4 +++-
 4 files changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -98,10 +98,10 @@ int ide_build_dmatable(ide_drive_t *driv
 {
 	ide_hwif_t *hwif = drive->hwif;
 	__le32 *table = (__le32 *)hwif->dmatable_cpu;
-	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
 	unsigned int count = 0;
 	int i;
 	struct scatterlist *sg;
+	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
 	hwif->sg_nents = ide_build_sglist(drive, rq);
 	if (hwif->sg_nents == 0)
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -46,7 +46,6 @@ static int proc_ide_read_imodel
 	case ide_qd65xx:	name = "qd65xx";	break;
 	case ide_umc8672:	name = "umc8672";	break;
 	case ide_ht6560b:	name = "ht6560b";	break;
-	case ide_trm290:	name = "trm290";	break;
 	case ide_cy82c693:	name = "cy82c693";	break;
 	case ide_4drives:	name = "4drives";	break;
 	case ide_pmac:		name = "mac-io";	break;
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -328,10 +328,10 @@ static struct ide_dma_ops trm290_dma_ops
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
-	.chipset	= ide_trm290,
 	.port_ops	= &trm290_port_ops,
 	.dma_ops	= &trm290_dma_ops,
-	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
+	.host_flags	= IDE_HFLAG_TRM290 |
+			  IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 #endif
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -163,7 +163,7 @@ typedef int (ide_ack_intr_t)(struct hwif
 enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_cmd640,	ide_dtc2278,	ide_ali14xx,
 		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
-		ide_trm290,	ide_cy82c693,	ide_4drives,
+		ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_acorn,
 		ide_au1xxx,	ide_palm3710
 };
@@ -1364,6 +1364,8 @@ enum {
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
+	/* host is TRM290 */
+	IDE_HFLAG_TRM290		= (1 << 26),
 	/* serialize ports if DMA is possible (for sl82c105) */
 	IDE_HFLAG_SERIALIZE_DMA		= (1 << 27),
 	/* force host out of "simplex" mode */
