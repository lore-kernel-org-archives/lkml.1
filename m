Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZASOPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZASOPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZASONn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:13:43 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36546 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZASONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=O6olhxZTm2nzKnrEK81o6Dn0C+FBTOc+tevQXrObZq5m+Y3QcJpnyWIL4cVcLJY2eH
         0ER4AW+y1+hFQjU6aurdtPbiD5F6+owOzLxVO8WqF+To/IMJiwzyM+CQi1Fg7PTj+hWE
         hdybZw1/UVQrMn2fnI4+zJbTcNf64HngKGor0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:14:03 +0100
Message-Id: <20090119141403.27613.79022.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/12] ide: handle IDE_HFLAG[_FORCE]_LEGACY_IRQS in ide_pci_init_{one,two}()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: handle IDE_HFLAG[_FORCE]_LEGACY_IRQS in ide_pci_init_{one,two}()

Move handling of IDE_HFLAG[_FORCE]_LEGACY_IRQS from ide_init_port()
to ide_pci_init_{one,two}().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 ----
 drivers/ide/setup-pci.c |   12 ++++++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1169,10 +1169,6 @@ static void ide_init_port(ide_hwif_t *hw
 	if (d->init_iops)
 		d->init_iops(hwif);
 
-	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
-	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
-		hwif->irq = port ? 15 : 14;
-
 	/* ->host_flags may be set by ->init_iops (or even earlier...) */
 	hwif->host_flags |= d->host_flags;
 	hwif->pio_mask = d->pio_mask;
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -570,6 +570,12 @@ int ide_pci_init_one(struct pci_dev *dev
 	/* fixup IRQ */
 	hw[1].irq = hw[0].irq = ret;
 
+	if ((ret == 0 && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
+	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS)) {
+		hw[0].irq = 14;
+		hw[1].irq = 15;
+	}
+
 	ret = ide_host_register(host, d, hws);
 	if (ret)
 		ide_host_free(host);
@@ -620,6 +626,12 @@ int ide_pci_init_two(struct pci_dev *dev
 
 		/* fixup IRQ */
 		hw[i*2 + 1].irq = hw[i*2].irq = ret;
+
+		if ((ret == 0 && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
+		    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS)) {
+			hw[i*2].irq = 14;
+			hw[i*2 + 1].irq = 15;
+		}
 	}
 
 	ret = ide_host_register(host, d, hws);
