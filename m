Return-Path: <linux-kernel-owner+w=401wt.eu-S934995AbYBNA2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995AbYBNA2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934102AbYBNAXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:23:01 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:47260 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934557AbYBNAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Fpl3w50jDe/LNBdLLRZb+jM/7IlnQQ60bFwiHODBtgurOEL7PxALTXGIA7GPlcJD37ki3Bq3cQJJ0tzpSoWUrM5SSHsWVP5lyFbdQenc78hu+yNBp7uc/LeP62UhMHXOv9aAj7eqoTVgeUbjdU3uI0ADDYanq1TIQV2BOcJK0YM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:37:22 +0100
Message-Id: <20080214003722.12879.2412.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/11] ppc/pplus: remove ppc_ide_md.ide_init_hwif hook
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call ide_init_default_irq() for pplus in init_ide_data().

* Remove no longer needed pplus_ide_init_hwif_ports().

There should be no functional changes caused by this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/platforms/pplus.c |   23 -----------------------
 drivers/ide/ide.c          |    2 +-
 2 files changed, 1 insertion(+), 24 deletions(-)

Index: b/arch/ppc/platforms/pplus.c
===================================================================
--- a/arch/ppc/platforms/pplus.c
+++ b/arch/ppc/platforms/pplus.c
@@ -695,28 +695,6 @@ static unsigned long pplus_ide_default_i
 		return 0;
 	}
 }
-
-static void __init
-pplus_ide_init_hwif_ports(hw_regs_t * hw, unsigned long data_port,
-			  unsigned long ctrl_port, int *irq)
-{
-	unsigned long reg = data_port;
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg;
-		reg += 1;
-	}
-
-	if (ctrl_port)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-	else
-		hw->io_ports[IDE_CONTROL_OFFSET] =
-		    hw->io_ports[IDE_DATA_OFFSET] + 0x206;
-
-	if (irq != NULL)
-		*irq = pplus_ide_default_irq(data_port);
-}
 #endif
 
 #ifdef CONFIG_SMP
@@ -887,7 +865,6 @@ platform_init(unsigned long r3, unsigned
 #if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
 	ppc_ide_md.default_irq = pplus_ide_default_irq;
 	ppc_ide_md.default_io_base = pplus_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = pplus_ide_init_hwif_ports;
 #endif
 
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -214,7 +214,7 @@ static void __init init_ide_data (void)
 		memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
 #endif
 		hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
-#if !defined(CONFIG_PPC32) || !defined(CONFIG_PCI)
+#if !defined(CONFIG_PPC32) || defined(CONFIG_PPLUS) || !defined(CONFIG_PCI)
 		hwif->irq =
 			ide_init_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
 #endif
