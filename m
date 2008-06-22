Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYFVTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYFVTen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYFVTd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:33:58 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:35234 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638AbYFVTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Onut26IsYBnVXO0Te+IiMX3VcXGTfmcJggoQyWjhJ3jJBPpGj8/g1E2QZKgxo6k2m7
         pE9OpZBcM+6CdIudvgt9shJqCo2EP/eRMTdo/iodfEEyd8zjp7Dfs9U7G0qzPpELvvIb
         AWYpTg5lCxdEVU+/f3xzyyeMKuE94BSd5XwwQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2008 21:35:48 +0200
Message-Id: <20080622193548.5325.82258.sendpatchset@localhost.localdomain>
In-Reply-To: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
References: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/4] ide: add 'config' field to hw_regs_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'config' field to hw_regs_t and use it to set hwif->config_data in
ide_init_port_hw(), then convert ide_legacy_init_one() to use hw->config.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 +---
 drivers/ide/ide.c       |    1 +
 include/linux/ide.h     |    1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1695,14 +1695,12 @@ static void ide_legacy_init_one(u8 *idx,
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
 	hw->chipset = d->chipset;
+	hw->config = config;
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
 		hwif->chipset = hw->chipset;
 
-		if (config)
-			hwif->config_data = config;
-
 		hws[port_no] = hw;
 		idx[port_no] = hwif->index;
 	}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -286,6 +286,7 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 	hwif->dev = hw->dev;
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
+	hwif->config_data = hw->config;
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -172,6 +172,7 @@ typedef struct hw_regs_s {
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
 	struct device	*dev, *parent;
+	unsigned long	config;
 } hw_regs_t;
 
 void ide_init_port_data(struct hwif_s *, unsigned int);
