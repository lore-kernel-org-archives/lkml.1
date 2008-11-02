Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYKBUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYKBUz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYKBUzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:55:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:15197 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbYKBUzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=XusK5tvVrpyeDPpwY3tC7dzgwrcDh6wv6V6qmLmfdPeLpchTctR6u+s/H9znBoGzK5
         RSz/PLwrY7sQOsT4fd8ISBsFH25zSrVw5hhypILtdnCQM+Z46UObanci64cZIxM10obh
         CFucdaoIX9OIjyU/gPtnLKzlQboUBjxs9xsV8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes #1
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 2 Nov 2008 21:52:37 +0100
Message-Id: <200811022152.38034.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide-cd DVD burning regression fix (Borislav Petkov), ide-gd media
revalidation fix (also from Borislav), fixups for new tx4938ide driver
(Atsushi Nemoto) and Alan Cox's email update (from Alan himself).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/alim15x3.c        |    2 +-
 drivers/ide/hpt366.c          |    2 +-
 drivers/ide/ide-cd.c          |    3 ++-
 drivers/ide/ide-disk.c        |    2 +-
 drivers/ide/ide-gd.c          |    7 ++++++-
 drivers/ide/ide-iops.c        |    2 +-
 drivers/ide/ide-pci-generic.c |    2 +-
 drivers/ide/ide-proc.c        |    2 +-
 drivers/ide/it821x.c          |    2 +-
 drivers/ide/jmicron.c         |    2 +-
 drivers/ide/piix.c            |    2 +-
 drivers/ide/scc_pata.c        |    2 +-
 drivers/ide/siimage.c         |    2 +-
 drivers/ide/tx4938ide.c       |   41 +++++++++++++++++++++++++++--------------
 14 files changed, 46 insertions(+), 27 deletions(-)


Alan Cox (1):
      ide: Switch to a common address

Atsushi Nemoto (3):
      tx4938ide: Check minimum cycle time and SHWT range (v2)
      tx4938ide: Do not call devm_ioremap for whole 128KB
      tx4938ide: Avoid underflow on calculation of a wait cycle

Borislav Petkov (2):
      ide-cd: fix DMA alignment regression
      ide-gd: re-get capacity on revalidate


diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index daf9dce..e56c7b7 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 1998-2000 Andre Hedrick (andre@linux-ide.org)
  *  May be copied or modified under the terms of the GNU General Public License
- *  Copyright (C) 2002 Alan Cox <alan@redhat.com>
+ *  Copyright (C) 2002 Alan Cox
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
  *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
  *  Copyright (C) 2007 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index a7909e9..f5afd46 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -52,7 +52,7 @@
  * different clocks on read/write. This requires overloading rw_disk and
  * other deeply crazy things. Thanks to <http://www.hoerstreich.de> for
  * keeping me sane. 
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * - fix the clock turnaround code: it was writing to the wrong ports when
  *   called for the secondary channel, caching the current clock mode per-
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 48b5eda..42ab6d8 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1250,7 +1250,8 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * separate masks.
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-		if ((unsigned long)buf & alignment || rq->data_len & alignment
+		if ((unsigned long)buf & alignment
+		    || rq->data_len & q->dma_pad_mask
 		    || object_is_on_stack(buf))
 			drive->dma = 0;
 	}
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index e5adebe..eb9fac4 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -2,7 +2,7 @@
  *  Copyright (C) 1994-1998	   Linus Torvalds & authors (see below)
  *  Copyright (C) 1998-2002	   Linux ATA Development
  *				      Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003		   Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		   Red Hat
  *  Copyright (C) 2003-2005, 2007  Bartlomiej Zolnierkiewicz
  */
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 7b66628..b8078b3 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -281,7 +281,12 @@ static int ide_gd_media_changed(struct gendisk *disk)
 static int ide_gd_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
-	set_capacity(disk, ide_gd_capacity(idkp->drive));
+	ide_drive_t *drive = idkp->drive;
+
+	if (ide_gd_media_changed(disk))
+		drive->disk_ops->get_capacity(drive);
+
+	set_capacity(disk, ide_gd_capacity(drive));
 	return 0;
 }
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index bb7a1ed..5d6ba14 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2000-2002	Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		Red Hat
  *
  */
 
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 474f96a..bddae2b 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- *  Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
+ *  Portions (C) Copyright 2002  Red Hat Inc
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index c31d0dd..f3cddd1 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 1997-1998	Mark Lord
- *  Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003		Red Hat
  *
  *  Some code was moved here from ide.c, see it for original copyrights.
  */
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 995e18b..ef00408 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004		Red Hat <alan@redhat.com>
+ * Copyright (C) 2004		Red Hat
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
diff --git a/drivers/ide/jmicron.c b/drivers/ide/jmicron.c
index 9a68433..bf2be64 100644
--- a/drivers/ide/jmicron.c
+++ b/drivers/ide/jmicron.c
@@ -1,6 +1,6 @@
 
 /*
- * Copyright (C) 2006		Red Hat <alan@redhat.com>
+ * Copyright (C) 2006		Red Hat
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index d63f9fd..61d2d92 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -1,7 +1,7 @@
 /*
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2003 Red Hat
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
  *  May be copied or modified under the terms of the GNU General Public License
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index f26aa5d..0f48f9d 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -5,7 +5,7 @@
  *
  * This code is based on drivers/ide/pci/siimage.c:
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2003		Red Hat <alan@redhat.com>
+ * Copyright (C) 2003		Red Hat
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index c3107df..7d622d2 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2003		Red Hat <alan@redhat.com>
+ * Copyright (C) 2003		Red Hat
  * Copyright (C) 2007-2008	MontaVista Software, Inc.
  * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
  *
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index fa660f9..9120063 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -26,12 +26,13 @@ static void tx4938ide_tune_ebusc(unsigned int ebus_ch,
 	unsigned int sp = (cr >> 4) & 3;
 	unsigned int clock = gbus_clock / (4 - sp);
 	unsigned int cycle = 1000000000 / clock;
-	unsigned int wt, shwt;
+	unsigned int shwt;
+	int wt;
 
 	/* Minimum DIOx- active time */
 	wt = DIV_ROUND_UP(t->act8b, cycle) - 2;
 	/* IORDY setup time: 35ns */
-	wt = max(wt, DIV_ROUND_UP(35, cycle));
+	wt = max_t(int, wt, DIV_ROUND_UP(35, cycle));
 	/* actual wait-cycle is max(wt & ~1, 1) */
 	if (wt > 2 && (wt & 1))
 		wt++;
@@ -39,10 +40,17 @@ static void tx4938ide_tune_ebusc(unsigned int ebus_ch,
 	/* Address-valid to DIOR/DIOW setup */
 	shwt = DIV_ROUND_UP(t->setup, cycle);
 
+	/* -DIOx recovery time (SHWT * 4) and cycle time requirement */
+	while ((shwt * 4 + wt + (wt ? 2 : 3)) * cycle < t->cycle)
+		shwt++;
+	if (shwt > 7) {
+		pr_warning("tx4938ide: SHWT violation (%d)\n", shwt);
+		shwt = 7;
+	}
 	pr_debug("tx4938ide: ebus %d, bus cycle %dns, WT %d, SHWT %d\n",
 		 ebus_ch, cycle, wt, shwt);
 
-	__raw_writeq((cr & ~(0x3f007ull)) | (wt << 12) | shwt,
+	__raw_writeq((cr & ~0x3f007ull) | (wt << 12) | shwt,
 		     &tx4938_ebuscptr->cr[ebus_ch]);
 }
 
@@ -228,7 +236,7 @@ static int __init tx4938ide_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct tx4938ide_platform_info *pdata = pdev->dev.platform_data;
 	int irq, ret, i;
-	unsigned long mapbase;
+	unsigned long mapbase, mapctl;
 	struct ide_port_info d = tx4938ide_port_info;
 
 	irq = platform_get_irq(pdev, 0);
@@ -242,38 +250,43 @@ static int __init tx4938ide_probe(struct platform_device *pdev)
 				     res->end - res->start + 1, "tx4938ide"))
 		return -EBUSY;
 	mapbase = (unsigned long)devm_ioremap(&pdev->dev, res->start,
-					      res->end - res->start + 1);
-	if (!mapbase)
+					      8 << pdata->ioport_shift);
+	mapctl = (unsigned long)devm_ioremap(&pdev->dev,
+					     res->start + 0x10000 +
+					     (6 << pdata->ioport_shift),
+					     1 << pdata->ioport_shift);
+	if (!mapbase || !mapctl)
 		return -EBUSY;
 
 	memset(&hw, 0, sizeof(hw));
 	if (pdata->ioport_shift) {
 		unsigned long port = mapbase;
+		unsigned long ctl = mapctl;
 
 		hw.io_ports_array[0] = port;
 #ifdef __BIG_ENDIAN
 		port++;
+		ctl++;
 #endif
 		for (i = 1; i <= 7; i++)
 			hw.io_ports_array[i] =
 				port + (i << pdata->ioport_shift);
-		hw.io_ports.ctl_addr =
-			port + 0x10000 + (6 << pdata->ioport_shift);
+		hw.io_ports.ctl_addr = ctl;
 	} else
-		ide_std_init_ports(&hw, mapbase, mapbase + 0x10006);
+		ide_std_init_ports(&hw, mapbase, mapctl);
 	hw.irq = irq;
 	hw.dev = &pdev->dev;
 
-	pr_info("TX4938 IDE interface (base %#lx, irq %d)\n", mapbase, hw.irq);
+	pr_info("TX4938 IDE interface (base %#lx, ctl %#lx, irq %d)\n",
+		mapbase, mapctl, hw.irq);
 	if (pdata->gbus_clock)
 		tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, 0);
 	else
 		d.port_ops = NULL;
 	ret = ide_host_add(&d, hws, &host);
-	if (ret)
-		return ret;
-	platform_set_drvdata(pdev, host);
-	return 0;
+	if (!ret)
+		platform_set_drvdata(pdev, host);
+	return ret;
 }
 
 static int __exit tx4938ide_remove(struct platform_device *pdev)
