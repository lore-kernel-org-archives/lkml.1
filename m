Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYFQUpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYFQUpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYFQUpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:45:03 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:5032 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbYFQUpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pyOOC6s5bV62hSCt4QYIA5JGhbKEtavRrDMOci+TGDissNDBQHk6opMn1sAh2+I6Rn
         ZoOmZM9YY7f6N0Ma/0XAbYAFTLtL3HSuUvuXPIpIqeE7fAMfWkpl50GBRZIENfSl+ria
         XyqqljsxqpfVYWT8H3b1Z+AC/DKMYrfXDf0Rk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 3/4] ide-pmac: add ->init_dev method (take 2)
Date: Tue, 17 Jun 2008 22:43:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200806162124.48029.bzolnier@gmail.com> <20080617104546.3b4535c9.sfr@canb.auug.org.au>
In-Reply-To: <20080617104546.3b4535c9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806172243.32854.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008, Stephen Rothwell wrote:
> Hi Bart,
> 
> On Mon, 16 Jun 2008 21:24:47 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > +static void pmac_ide_init_dev(ide_drive_t *drive)
> > +{
> > +	ide_hwif_t *hwif = drive->hwif;
> > +	pmac_ide_hwif_t *pmif =
> > +		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
> > +
> > +	if (pmif->mediabay) {
> > +#ifdef CONFIG_PMAC_MEDIABAY
> > +		if (check_media_bay(np->parent, MB_CD) == -ENODEV)
>                                     ^^
> "np" doesn't exist here.

uh, it should be pmif->node there... take 3...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: add ->init_dev method (take 3)

v2/3:
* Build fixes from Stephen Rothwell.

There should be no functional changes caused by this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

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
@@ -1065,15 +1083,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
 	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
 
-	if (pmif->mediabay) {
-#ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay(np->parent, MB_CD) == -ENODEV)
-			break;
-#endif
-		hwif->drives[0].noprobe = 1;
-		hwif->drives[1].noprobe = 1;
-	}
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
