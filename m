Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYJ3BbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYJ3BbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYJ3Baw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:30:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:55048 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYJ3Bav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:30:51 -0400
Subject: ide: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:30:52 +0100
Message-Id: <1225330252.5970.89.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: ide: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1649ea5..74d8677 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -641,7 +641,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	int ret;
 
 	/* register with global device tree */
-	strlcpy(hwif->gendev.bus_id,hwif->name,BUS_ID_SIZE);
+	dev_set_name(&hwif->gendev, hwif->name);
 	hwif->gendev.driver_data = hwif;
 	if (hwif->gendev.parent == NULL) {
 		if (hwif->dev)
@@ -1351,7 +1351,7 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
-		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
+		dev_set_name(dev, "%u.%u", hwif->index, i);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
 		dev->driver_data = drive;


