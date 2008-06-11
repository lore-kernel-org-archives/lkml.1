Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbYFKU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbYFKU0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYFKUZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:25:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60994 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYFKUZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Qyw2+WlIu15Ooopzzvj4X2ADhSldC8sLplDJ8MUFXFhkgN4In4sa8M2ireOSmIedkW
         xpXpW3nDdmTao3Tj3ImehF4fYAtHT7psXRVTQXELhydte/t3jaafCfyEXdwhJ+91yJ9p
         W+y0BU+v3I0rRxbYlsY81+UoNkwuNtQl6BwBU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide-cs: fix probing and add warm-plug support
Date: Wed, 11 Jun 2008 21:18:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112118.48980.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fix probing by using ide_port_scan() and moving "retry loop"
  from ide_config() to idecs_register().

* Don't fail probe if there are no devices attached to a port.

* Remove (now redundant) error message from ide_config().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide-cs.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -186,17 +186,25 @@ static ide_hwif_t *idecs_register(unsign
     if (hwif == NULL)
 	goto out_release;
 
-    i = hwif->index;
-
     ide_init_port_hw(hwif, &hw);
 
-    idx[0] = i;
+    idx[0] = hwif->index;
 
     ide_device_add(idx, &idecs_port_info);
 
     if (hwif->present)
 	return hwif;
 
+    /* retry registration in case device is still spinning up */
+    for (i = 0; i < 10; i++) {
+	msleep(100);
+	ide_port_scan(hwif);
+	if (hwif->present)
+	    return hwif;
+    }
+
+    return hwif;
+
 out_release:
     release_region(ctl, 1);
     release_region(io, 8);
@@ -225,7 +233,7 @@ static int ide_config(struct pcmcia_devi
 	cistpl_cftable_entry_t dflt;
     } *stk = NULL;
     cistpl_cftable_entry_t *cfg;
-    int i, pass, last_ret = 0, last_fn = 0, is_kme = 0;
+    int pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
     ide_hwif_t *hwif;
 
@@ -322,30 +330,15 @@ static int ide_config(struct pcmcia_devi
     if (is_kme)
 	outb(0x81, ctl_base+1);
 
-    /* retry registration in case device is still spinning up */
-    for (i = 0; i < 10; i++) {
-	hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-	if (hwif)
-	    break;
-	if (link->io.NumPorts1 == 0x20) {
+     hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+     if (hwif == NULL && link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
 	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
 				  link->irq.AssignedIRQ, link);
-	    if (hwif) {
-		io_base += 0x10;
-		ctl_base += 0x10;
-		break;
-	    }
-	}
-	msleep(100);
     }
 
-    if (hwif == NULL) {
-	printk(KERN_NOTICE "ide-cs: ide_register() at 0x%3lx & 0x%3lx"
-	       ", irq %u failed\n", io_base, ctl_base,
-	       link->irq.AssignedIRQ);
+    if (hwif == NULL)
 	goto failed;
-    }
 
     info->ndev = 1;
     sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
