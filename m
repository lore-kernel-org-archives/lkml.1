Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYBQShv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYBQShv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYBQShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:37:00 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:30516 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbYBQSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KUOg53XGa8STyakozmCaFptdAKon50UiCmp4rUVi4mFDCNWYVGjCU/ApnkmPkfRM+ZmmSFx8uFcUetl0uIabjf3cEaf6Rd7pFaEWNxDYPyuNvrWNc/aSI/TQLxy4bknQngfTuX0lsWtyM0hIta1XSk/tI0CPGmQgQmecTacycZQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Feb 2008 19:51:33 +0100
Message-Id: <20080217185133.16210.73293.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/5] ide-generic: use ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -90,18 +90,27 @@ static int __init ide_generic_init(void)
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif = &ide_hwifs[i];
+		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
 		hw_regs_t hw;
 
-		if (hwif->chipset == ide_unknown && io_addr) {
-			u8 oldnoprobe = hwif->noprobe;
+		if (io_addr) {
+			u8 oldnoprobe;
+
+			/*
+			 * Skip probing if the corresponding
+			 * slot entry is already occupied.
+			 */
+			hwif = ide_find_port();
+			if (hwif == NULL || hwif->index != i)
+				continue;
 
 			memset(&hw, 0, sizeof(hw));
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
-			ide_init_port_hw(hwif, &hw);
 
+			oldnoprobe = hwif->noprobe;
+			ide_init_port_hw(hwif, &hw);
 			hwif->noprobe = oldnoprobe;
 
 			idx[i] = i;
