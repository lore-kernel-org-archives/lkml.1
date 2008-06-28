Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYF1Vnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYF1Vnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 17:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYF1Vmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 17:42:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYF1Vm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 17:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ndQr9BQz/0sCoV8eUPmEVE1hIOVDFnl1tXldbIJOokcC471HpuyZssp3YPxdqvrvBk
         BWUzHreGQpFiWdmBRTtKfoNymOSqq2HMgOksHPXJzQ/T10T+CNQsMwhWw6LH85ZlgRHM
         nE2cESZcIeNhuW3uNeXZAkwjqMo+ekeAwgwlI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 28 Jun 2008 23:44:31 +0200
Message-Id: <20080628214431.21345.80510.sendpatchset@localhost.localdomain>
In-Reply-To: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
References: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/7] ide: add ide_ports[]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_ports[] table keeping pointers to all initialized ports.

* Set ide_ports[] entry for a given port in init_irq() and clear it
  ide_remove_port_from_hwgroup().

* Convert init_irq() to use ide_ports[] instead of ide_hwifs[] for
  grouping ports into hwgroup.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -994,10 +994,14 @@ static void ide_port_setup_devices(ide_h
 	mutex_unlock(&ide_cfg_mtx);
 }
 
+static ide_hwif_t *ide_ports[MAX_HWIFS];
+
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 
+	ide_ports[hwif->index] = NULL;
+
 	spin_lock_irq(&ide_lock);
 	/*
 	 * Remove us from the hwgroup, and free
@@ -1056,8 +1060,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 * Group up with any other hwifs that share our irq(s).
 	 */
 	for (index = 0; index < MAX_HWIFS; index++) {
-		ide_hwif_t *h = &ide_hwifs[index];
-		if (h->hwgroup) {  /* scan only initialized hwif's */
+		ide_hwif_t *h = ide_ports[index];
+
+		if (h && h->hwgroup) {  /* scan only initialized ports */
 			if (hwif->irq == h->irq) {
 				hwif->sharing_irq = h->sharing_irq = 1;
 				if (hwif->chipset != ide_pci ||
@@ -1111,6 +1116,8 @@ static int init_irq (ide_hwif_t *hwif)
 		hwgroup->timer.data = (unsigned long) hwgroup;
 	}
 
+	ide_ports[hwif->index] = hwif;
+
 	/*
 	 * Allocate the irq, if not already obtained for another hwif
 	 */
