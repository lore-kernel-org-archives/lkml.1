Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbZKYRG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbZKYRG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZKYRGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:55 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42882 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbZKYRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=As2HIdXu+qow/uI92rQZ3m0T9VLxRBjokM8zKgB3Z+T6G6WHU5ODwo3xAW+T+vhB5e
         T/Li/1CZoRvoW4CyU9EQs786e3ZItkoGTEFriBOOvsajAG3LrWJGlD6q/GHuJTitpiQn
         JBtE2YILbxi6C7egfImv8C7MrmfkNpDnZJwew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:14 +0100
Message-Id: <20091125170614.5446.69651.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 33/86] pata_hpt3x3: Power Management fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_hpt3x3: Power Management fix

Fix ->resume method to re-enable & re-init PCI device properly
before doing chipset specific setup.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt3x3.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_hpt3x3.c
===================================================================
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -255,8 +255,17 @@ static int hpt3x3_init_one(struct pci_de
 #ifdef CONFIG_PM
 static int hpt3x3_reinit_one(struct pci_dev *dev)
 {
+	struct ata_host *host = dev_get_drvdata(&dev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(dev);
+	if (rc)
+		return rc;
+
 	hpt3x3_init_chipset(dev);
-	return ata_pci_device_resume(dev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
