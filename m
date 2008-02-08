Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbYBHAeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbYBHAeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763019AbYBHAbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:00 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:45438 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762931AbYBHAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tn4vUFrH/LFsYbMW1W7InWwyyvOukg9bSAU4T7d6JWq0xcsLxQ0LJ7EbbpvhpGPV0dje2/u6Jv48+YpPMgMixGf2CT4tu80UXZF8JmWQjo+fxNGlrUy9FbLxKt7OLj5ZQJP58VE1ViibrkVXlcjUphQbRtpdF2+GJ2GDTw5Aews=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:09 +0100
Message-Id: <20080208004509.17746.70379.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/18] ide: factor out devices init from ide_init_port_data()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out devices init from ide_init_port_data() to
  ide_port_init_devices_data().

While at it:

* Add explicit clearing of IDE device structure.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -109,13 +109,13 @@ ide_hwif_t ide_hwifs[MAX_HWIFS];	/* mast
 
 EXPORT_SYMBOL(ide_hwifs);
 
+static void ide_port_init_devices_data(ide_hwif_t *);
+
 /*
  * Do not even *think* about calling this!
  */
 void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 {
-	unsigned int unit;
-
 	/* bulk initialize hwif & drive info with zeros */
 	memset(hwif, 0, sizeof(ide_hwif_t));
 
@@ -134,8 +134,20 @@ void ide_init_port_data(ide_hwif_t *hwif
 
 	default_hwif_iops(hwif);
 	default_hwif_transport(hwif);
+
+	ide_port_init_devices_data(hwif);
+}
+EXPORT_SYMBOL_GPL(ide_init_port_data);
+
+static void ide_port_init_devices_data(ide_hwif_t *hwif)
+{
+	int unit;
+
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
+		u8 j = (hwif->index * MAX_DRIVES) + unit;
+
+		memset(drive, 0, sizeof(*drive));
 
 		drive->media			= ide_disk;
 		drive->select.all		= (unit<<4)|0xa0;
@@ -147,15 +159,14 @@ void ide_init_port_data(ide_hwif_t *hwif
 		drive->special.b.set_geometry	= 1;
 		drive->name[0]			= 'h';
 		drive->name[1]			= 'd';
-		drive->name[2]			= 'a' + (index * MAX_DRIVES) + unit;
+		drive->name[2]			= 'a' + j;
 		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
-		drive->using_dma		= 0;
-		drive->vdma			= 0;
+
 		INIT_LIST_HEAD(&drive->list);
 		init_completion(&drive->gendev_rel_comp);
 	}
 }
-EXPORT_SYMBOL_GPL(ide_init_port_data);
+
 
 static void init_hwif_default(ide_hwif_t *hwif, unsigned int index)
 {
