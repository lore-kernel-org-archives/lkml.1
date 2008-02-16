Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYBPUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYBPUNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYBPUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:14552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbYBPUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z1HxCut9Rdfn6pGNO67xqlOeL6o4xwQMiXDYfxqynG2iWfM6KCmMQsM1ClN7I6A/eitECGbg3fvK/Nlo8IPhb8p+iCR9RjWx4EUc2tkRMopPZyVihC1aXqCLinF/ROn0yEx+nkU+C63+Tns6NOUnjgtSZaOQQiRuNM9KOcZbNPw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:26:55 +0100
Message-Id: <20080216202655.25536.76193.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] cmd640: use ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -744,20 +744,21 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
 
-	cmd_hwif0 = &ide_hwifs[0];
-	cmd_hwif1 = &ide_hwifs[1];
+	cmd_hwif0 = ide_find_port();
 
 	/*
 	 * Initialize data for primary port
 	 */
-	oldnoprobe = cmd_hwif0->noprobe;
-	ide_init_port_hw(cmd_hwif0, &hw[0]);
-	cmd_hwif0->noprobe = oldnoprobe;
+	if (cmd_hwif0) {
+		oldnoprobe = cmd_hwif0->noprobe;
+		ide_init_port_hw(cmd_hwif0, &hw[0]);
+		cmd_hwif0->noprobe = oldnoprobe;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
+		cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
-	idx[0] = cmd_hwif0->index;
+		idx[0] = cmd_hwif0->index;
+	}
 
 	/*
 	 * Ensure compatibility by always using the slowest timings
@@ -772,7 +773,7 @@ static int __init cmd640x_init(void)
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1->noprobe) {
+	if (cmd_hwif1 && cmd_hwif1->noprobe) {
 		port2 = "not probed";
 	} else {
 		b = get_cmd640_reg(CNTRL);
@@ -803,7 +804,7 @@ static int __init cmd640x_init(void)
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640) {
+	if (second_port_cmd640 && cmd_hwif1) {
 		oldnoprobe = cmd_hwif1->noprobe;
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
 		cmd_hwif1->noprobe = oldnoprobe;
@@ -813,7 +814,7 @@ static int __init cmd640x_init(void)
 
 		idx[1] = cmd_hwif1->index;
 	}
-	printk(KERN_INFO "%s: %sserialized, secondary interface %s\n", cmd_hwif1->name,
+	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
 	/*
@@ -823,10 +824,15 @@ static int __init cmd640x_init(void)
 	for (index = 0; index < (2 + (second_port_cmd640 << 1)); index++) {
 		ide_drive_t *drive;
 
-		if (index > 1)
+		if (index > 1) {
+			if (cmd_hwif1 == NULL)
+				continue;
 			drive = &cmd_hwif1->drives[index & 1];
-		else
+		} else  {
+			if (cmd_hwif0 == NULL)
+				continue;
 			drive = &cmd_hwif0->drives[index & 1];
+		}
 
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		if (drive->autotune || ((index > 1) && second_port_toggled)) {
