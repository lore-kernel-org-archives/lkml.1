Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYHSSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYHSSiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYHSShX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:37:23 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:24430 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbYHSShS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=JWjfuqLg1UdphpgN6thgTbxzjPDOOVVBZn6VeoC6vTCuxpO/OpXf7qPvOWKd0sG2FC
         TWxhsr3W0nxXQ6FUnwWAgD94cLUcSWzE1edA56j4uQx6mmkrpYe7mVYAg2HabGwsD8FY
         xKA016KUu0mT1dw8CHGpdWiwm3n7zjhhV+tJU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] ide-generic: no need to probe all ports at once
Date: Tue, 19 Aug 2008 20:32:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192032.33287.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |   47 +++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -137,10 +137,9 @@ static void ide_generic_check_pci_legacy
 
 static int __init ide_generic_init(void)
 {
-	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
-	struct ide_host *host;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	unsigned long io_addr;
-	int i, rc, primary = 0, secondary = 0;
+	int i, rc = 0, primary = 0, secondary = 0;
 
 #ifdef CONFIG_MIPS
 	if (!ide_probe_legacy())
@@ -161,13 +160,9 @@ static int __init ide_generic_init(void)
 		printk(KERN_INFO DRV_NAME ": enforcing probing of I/O ports "
 			"upon user request\n");
 
-	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
-
 	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
 		io_addr = legacy_bases[i];
 
-		hws[i] = NULL;
-
 		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
@@ -184,45 +179,27 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			memset(&hw[i], 0, sizeof(hw[i]));
-			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
+			memset(&hw, 0, sizeof(hw));
+			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 #ifdef CONFIG_IA64
-			hw[i].irq = isa_irq_to_vector(legacy_irqs[i]);
+			hw.irq = isa_irq_to_vector(legacy_irqs[i]);
 #else
-			hw[i].irq = legacy_irqs[i];
+			hw.irq = legacy_irqs[i];
 #endif
-			hw[i].chipset = ide_generic;
+			hw.chipset = ide_generic;
 
-			hws[i] = &hw[i];
+			rc = ide_host_add(NULL, hws, NULL);
+			if (rc) {
+				release_region(io_addr + 0x206, 1);
+				release_region(io_addr, 8);
+			}
 		}
 	}
 
-	host = ide_host_alloc_all(NULL, hws);
-	if (host == NULL) {
-		rc = -ENOMEM;
-		goto err;
-	}
-
-	rc = ide_host_register(host, NULL, hws);
-	if (rc)
-		goto err_free;
-
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
 					 "class\n");
 
-	return 0;
-err_free:
-	ide_host_free(host);
-err:
-	for (i = 0; i < MAX_HWIFS; i++) {
-		if (hws[i] == NULL)
-			continue;
-
-		io_addr = hws[i]->io_ports.data_addr;
-		release_region(io_addr + 0x206, 1);
-		release_region(io_addr, 8);
-	}
 	return rc;
 }
 
