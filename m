Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYF1VoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYF1VoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 17:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbYF1Vml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 17:42:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYF1Vma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 17:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=iyWxZB/bFlS9VGrqw/v6FUC0bG0auTWJZaKwFBVUG35iapbysxqivA5c8ow8ESl/Tj
         fA+TFoMk8AqPb8KGZkZzqPQmSB7egdph3B1+BRigRGhcncNbfwwialAM/kqlk5mj+B7J
         psYYuB7GFNrMcZZwyjpUMc3cgz9qswKkWQnGE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 28 Jun 2008 23:44:38 +0200
Message-Id: <20080628214438.21345.13127.sendpatchset@localhost.localdomain>
In-Reply-To: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
References: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/7] ide: allocate ide_hwif_t instances dynamically
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Allocate ide_hwif_t instances dynamically and remove ide_hwifs[].

  This cuts almost ~14kB from ide-probe.o (x86-32, MAX_HWIFS == 10):

   text    data     bss     dec     hex filename
   9140      40   14084   23264    5ae0 drivers/ide/ide-probe.o.before
   9169      40      44    9253    2425 drivers/ide/ide-probe.o.after

* Remove no longer needed ide_init_port_data() call from ide_unregister().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   10 ++++++----
 drivers/ide/ide.c       |    4 ----
 2 files changed, 6 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -39,8 +39,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-static ide_hwif_t ide_hwifs[MAX_HWIFS]; /* master data repository */
-
 /**
  *	generic_id		-	add a generic drive id
  *	@drive:	drive to make an ID block for
@@ -1589,15 +1587,18 @@ struct ide_host *ide_host_alloc_all(cons
 		if (hws[i] == NULL)
 			continue;
 
+		hwif = kzalloc(sizeof(*hwif), GFP_KERNEL);
+		if (hwif == NULL)
+			continue;
+
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
 			printk(KERN_ERR "%s: no free slot for interface\n",
 					d ? d->name : "ide");
+			kfree(hwif);
 			continue;
 		}
 
-		hwif = &ide_hwifs[idx];
-
 		ide_init_port_data(hwif, i);
 
 		host->ports[i] = hwif;
@@ -1761,6 +1762,7 @@ void ide_host_remove(struct ide_host *ho
 
 		ide_unregister(hwif);
 		ide_free_port_slot(hwif->index);
+		kfree(hwif);
 	}
 
 	kfree(host);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -232,10 +232,6 @@ void ide_unregister(ide_hwif_t *hwif)
 
 	if (hwif->dma_base)
 		ide_release_dma_engine(hwif);
-
-	/* restore hwif data to pristine status */
-	ide_init_port_data(hwif, hwif->index);
-
 abort:
 	spin_unlock_irq(&ide_lock);
 	mutex_unlock(&ide_cfg_mtx);
