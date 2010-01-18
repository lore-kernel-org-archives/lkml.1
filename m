Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0ARRRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0ARRRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193Ab0ARRRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:08 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63659 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0ARRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WqgV39j1fbF0UuOL06nr00LSI1Md93qO4XROIW+JEFuiJv+DD1NumMchkkOFDAPKnl
         JqbnTLe2CYP4MWl7/qnbsSsuKK9Y2Nz64Z5SlNNhNSbl1ZTWwSJVdDQt3swwrHd1ZUdZ
         0uZirbQcPGDFvjHbV9diCsmyG6Z0wMsL8T4D4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:47 +0100
Message-Id: <20100118171547.14623.54536.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 14/64] pata_cypress: fix PIO timings underclocking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cypress: fix PIO timings underclocking

Timing registers should be programmed with the desired number of clocks
minus one clock.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cypress.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: b/drivers/ata/pata_cypress.c
===================================================================
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -62,14 +62,16 @@ static void cy82c693_set_piomode(struct
 		return;
 	}
 
-	time_16 = clamp_val(t.recover, 0, 15) | (clamp_val(t.active, 0, 15) << 4);
-	time_8 = clamp_val(t.act8b, 0, 15) | (clamp_val(t.rec8b, 0, 15) << 4);
+	time_16 = clamp_val(t.recover - 1, 0, 15) |
+		  (clamp_val(t.active - 1, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b - 1, 0, 15) |
+		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
 
 	if (adev->devno == 0) {
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0x0F;	/* Mask bits */
-		addr |= clamp_val(t.setup, 0, 15);
+		addr |= clamp_val(t.setup - 1, 0, 15);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
@@ -79,7 +81,7 @@ static void cy82c693_set_piomode(struct
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0xF0;	/* Mask bits */
-		addr |= (clamp_val(t.setup, 0, 15) << 4);
+		addr |= (clamp_val(t.setup - 1, 0, 15) << 4);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
