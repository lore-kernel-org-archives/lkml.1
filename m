Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYFXSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYFXSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYFXSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:53:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:59880 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYFXSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cu9zQnxWrfyhafjx1mE/GfVoFmVU0TY6iOVh9Jfk84UDx549bx9c7jG6iodgY7LLef
         FQfK5D13j1TwJ2FIRfYHDXeCBMfpqDngI3fiFrjBZykOIkE2laM6x5PyhSruAnox7bcx
         AnkjEc9CwN3RAvex3y4nacPCr4hdY16E9xyT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Tue, 24 Jun 2008 20:55:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <1214303693.8011.345.camel@pasglop> <200806242051.22207.bzolnier@gmail.com>
In-Reply-To: <200806242051.22207.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242055.12042.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 24 June 2008, Benjamin Herrenschmidt wrote:
> > 
> > > Build error and/or your build fix would be useful here.
> > 
> > Sorry. Fix was a quick hack. There is a check_media_bay() followed by a
> > break; outside of a break-able construct in there (off memory, I'm not
> > in front of the dev box right now).
> 
> Thanks, 'take 3' follows.
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-pmac: media-bay support fixes (take 3)

[...]

and patch #2/4 required a trivial fix for a reject

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: add ->init_dev method (take 3)

v2/3:
* Build fixes from Stephen Rothwell.

There should be no functional changes caused by this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -941,7 +941,23 @@ static u8 pmac_ide_cable_detect(ide_hwif
 	return ATA_CBL_PATA40;
 }
 
+static void pmac_ide_init_dev(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
+
+	if (pmif->mediabay) {
+#ifdef CONFIG_PMAC_MEDIABAY
+		if (check_media_bay(pmif->node->parent, MB_CD) == -ENODEV)
+			return;
+#endif
+		drive->noprobe = 1;
+	}
+}
+
 static const struct ide_port_ops pmac_ide_ata6_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_kauai_selectproc,
@@ -949,6 +965,7 @@ static const struct ide_port_ops pmac_id
 };
 
 static const struct ide_port_ops pmac_ide_ata4_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_selectproc,
@@ -956,6 +973,7 @@ static const struct ide_port_ops pmac_id
 };
 
 static const struct ide_port_ops pmac_ide_port_ops = {
+	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_selectproc,
@@ -1065,17 +1083,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
 	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
 
-	if (pmif->mediabay) {
-#ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay(np->parent, MB_CD) != -ENODEV) {
-#else
-		if (1) {
-#endif
-			hwif->drives[0].noprobe = 1;
-			hwif->drives[1].noprobe = 1;
-		}
-	}
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
