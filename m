Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYFFVmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYFFVmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbYFFVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:40:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:8718 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbYFFVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=gU9ydb0zSxnWYSa105jj+62QDPf3FLJF2UXdMBKPJxId4JFL/CzqPM6/+cZRwDITSa
         vWpeE9yA43oaEoKUI+nmU/icOZE8TfPc6rNMd6RylTNsRvVri2ARyXXp/iBxrTLAUTld
         fuX1ouiR67i5ZPF79HPNfqT2tM5o38aRa8aNQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: tighten checks on PCI BARs in ide_hwif_configure()
Date: Fri, 6 Jun 2008 23:41:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806062341.26708.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan has fixed PCI layer handling of PCI IDE in Compatibility mode so
PCI BAR 0/1 (and/or 2/3) content reported by kernel should never be zero.

Tighten checks on PCI BARs and also fix printk() message while on it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -319,18 +319,18 @@ static ide_hwif_t *ide_hwif_configure(st
 
 		ctl  = pci_resource_start(dev, 2*port+1);
 		base = pci_resource_start(dev, 2*port);
-		if ((ctl && !base) || (base && !ctl)) {
-			printk(KERN_ERR "%s: inconsistent baseregs (BIOS) "
-				"for port %d, skipping\n", d->name, port);
-			return NULL;
-		}
-	}
-	if (!ctl) {
+	} else {
 		/* Use default values */
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
 	}
 
+	if (!base || !ctl) {
+		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
+				d->name, port);
+		return NULL;
+	}
+
 	hwif = ide_find_port_slot(d);
 	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
