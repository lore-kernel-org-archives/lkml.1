Return-Path: <linux-kernel-owner+w=401wt.eu-S934817AbZKYRND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817AbZKYRND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbZKYRM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934810AbZKYRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ec2mhkI1IQceirdWHtUzWQImgp1hDWTpzqRmfwSSzIZqsueOUot2nELGc07I0PMw3W
         TZbZC+2S8uSIlK/iCq4gmBDqR7wpARxigdIaH1vO/m+eHkgf6TPndcwW8Bh9c0ZK+5jb
         vI8TLH/4DIbmFvgXF3eIkvZfQ8BI7StfPXPeU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:18 +0100
Message-Id: <20091125171218.5446.41962.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO and MWDMA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 
