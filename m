Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYFBUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYFBUYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYFBUW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:22:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbYFBUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ll6f+kSItFTmSIVgMAYFIHz3AeAULt6kmlvncDIRkzmKiYZAUYzZ58ru6yMoE6AZE5oOr1X5HDOL3Luk+FXjdDZ0IsvFF6+hLshgSidenD4kFtmFIltMIDvCqQLQhyEElYj4DLcr+kI6Rhx4J8QODMgYor7LIzWMttMaVNkQzeI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:56 +0200
Message-Id: <20080602202356.7265.68692.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide_4drives: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info - as a nice side-effect
this fixes hwif->channel initialization.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide-4drives.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -11,6 +11,23 @@ static int probe_4drives;
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 
+static void ide_4drives_port_init_devs(ide_hwif_t *hwif)
+{
+	if (hwif->channel) {
+		hwif->drives[0].select.all ^= 0x20;
+		hwif->drives[1].select.all ^= 0x20;
+	}
+}
+
+static const struct ide_port_ops ide_4drives_port_ops = {
+	.port_init_devs		= ide_4drives_port_init_devs,
+};
+
+static const struct ide_port_info ide_4drives_port_info = {
+	.port_ops		= &ide_4drives_port_ops,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA,
+};
+
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
@@ -49,18 +66,10 @@ static int __init ide_4drives_init(void)
 	mate = ide_find_port();
 	if (mate) {
 		ide_init_port_hw(mate, &hw);
-		mate->drives[0].select.all ^= 0x20;
-		mate->drives[1].select.all ^= 0x20;
 		idx[1] = mate->index;
-
-		if (hwif) {
-			hwif->mate = mate;
-			mate->mate = hwif;
-			hwif->serialized = mate->serialized = 1;
-		}
 	}
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &ide_4drives_port_info);
 
 	return 0;
 }
