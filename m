Return-Path: <linux-kernel-owner+w=401wt.eu-S934906AbZKYR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906AbZKYR7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934889AbZKYR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:59:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37953 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822AbZKYR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=q7hrNQlkUaI5c0VJFQaCntlu3+3+pGUfbYTziltbjRUe46HW4hco0lsVFrlKW3qN7T
         JxHnnLUS3A/FNV0dHT9QJYiHMTX95ArdLc+TZSTTEPtX6mOkpqyvhr6Ugx1O/mTuU/CQ
         n2IKwjMdOicLBlR6GV3TpRvJaYYA6rJq1TDqE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO and MWDMA
Date: Wed, 25 Nov 2009 18:58:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171218.5446.41962.sendpatchset@localhost> <20091125175257.796afeb3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125175257.796afeb3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251858.38491.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:52:57 pm Alan Cox wrote:
> >  	/* Set UDMA unless device is not UDMA capable */
> > -	if (udma_type && t.udma) {
> > -		u8 cable80_status;
> > +	if (udma_type) {
> > +		u8 udma_etc;
> 
> This seems odd the original test is that we are a udma controller and
> have a udma timing specified. Otherwise there is no point doing any work.

The patch is based on the data sheet and is needed.

We may not hit the problem with the current chipset tuning model but things
are not set in the stone and one day we may pay a price for embedding such
undocumented assumptions into our drivers.

> The rest seems to be gratuitious register renaming and makes the patches
> hard to review. Please split this sort of stuff up.

The name now matches documentation.

Do you really find such tidy patch hard to review?

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: clear UDMA transfer mode bit for PIO and MWDMA

Fix register naming while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -296,14 +296,21 @@ static void via_do_set_mode(struct ata_p
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type && t.udma) {
-		u8 cable80_status;
+	if (udma_type) {
+		u8 udma_etc;
 
-		/* Get 80-wire cable detection bit */
-		pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
-		cable80_status &= 0x10;
+		pci_read_config_byte(pdev, 0x50 + offset, &udma_etc);
 
-		pci_write_config_byte(pdev, 0x50 + offset, ut | cable80_status);
+		/* clear transfer mode bit */
+		udma_etc &= ~0x20;
+
+		if (t.udma) {
+			/* preserve 80-wire cable detection bit */
+			udma_etc &= 0x10;
+			udma_etc |= ut;
+		}
+
+		pci_write_config_byte(pdev, 0x50 + offset, udma_etc);
 	}
 }
 


--
Bartlomiej Zolnierkiewicz
