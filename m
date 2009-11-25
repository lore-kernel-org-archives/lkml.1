Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbZKYRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbZKYRRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbZKYRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:06 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33678 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227AbZKYRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WhgzXXCy2/Yh2nAnxgyXijQO3kqZ9xWhksgM8g5DbDbudTE6xF1lUNYbUysEIxOBb4
         nHzQZRuicX1nJOkxyGt3KtoQ2LMCbXi2bRZlJDKpl0K0qeFxVUpxwGruPDdgFXdxBzeH
         9BaXaFq/yIaRAEUJRoEBg/H3e7UHYyEcypxOE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:24 +0100
Message-Id: <20091125171024.5446.80108.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 67/86] pata_rz1000: Power Management fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_rz1000: Power Management fix

Fix ->resume method to re-enable & re-init PCI device properly
before doing chipset specific setup.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_rz1000.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_rz1000.c
===================================================================
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -107,11 +107,20 @@ static int rz1000_init_one (struct pci_d
 #ifdef CONFIG_PM
 static int rz1000_reinit_one(struct pci_dev *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
 	/* If this fails on resume (which is a "cant happen" case), we
 	   must stop as any progress risks data loss */
 	if (rz1000_fifo_disable(pdev))
 		panic("rz1000 fifo");
-	return ata_pci_device_resume(pdev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
