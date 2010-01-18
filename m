Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443Ab0ARR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0ARR1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827Ab0ARRVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:21:12 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab0ARRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wk6zEbJQlg91GPpmCQ/zBxLtd1jVdHOq5sgzEHizntor6peJe9lqi8w5iSvHdeCKjU
         9WHdut9kTw0gC8pcfUYaQIRYNOlqUz/qgK7+yhVjXh1OPYwra27bEgURu1aV60e/1sgg
         qylipSGmKelv9xkGYnK8XuBM08XnEr7NnoAoM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:00 +0100
Message-Id: <20100118172000.14623.73749.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 42/64] via82cxxx: workaround h/w bugs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: workaround h/w bugs

Add custom struct ide_tp_ops instance to fix the internal bug of some VIA
chipsets which will reset the device register after changing the nIEN bit
in the device control register.

Based on commit bfce5e0 for pata_via host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -107,6 +107,7 @@ struct via82cxxx_dev
 {
 	struct via_isa_bridge *via_config;
 	unsigned int via_80w;
+	u8 cached_device[2];
 };
 
 /**
@@ -382,10 +383,66 @@ static const struct ide_port_ops via_por
 	.cable_detect		= via82cxxx_cable_detect,
 };
 
+static void via_write_devctl(ide_hwif_t *hwif, u8 ctl)
+{
+	struct via82cxxx_dev *vdev = hwif->host->host_priv;
+
+	outb(ctl, hwif->io_ports.ctl_addr);
+	outb(vdev->cached_device[hwif->channel], hwif->io_ports.device_addr);
+}
+
+static void __via_dev_select(ide_drive_t *drive, u8 select)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct via82cxxx_dev *vdev = hwif->host->host_priv;
+
+	outb(select, hwif->io_ports.device_addr);
+	vdev->cached_device[hwif->channel] = select;
+}
+
+static void via_dev_select(ide_drive_t *drive)
+{
+	__via_dev_select(drive, drive->select | ATA_DEVICE_OBS);
+}
+
+static void via_tf_load(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+
+	if (valid & IDE_VALID_FEATURE)
+		outb(tf->feature, io_ports->feature_addr);
+	if (valid & IDE_VALID_NSECT)
+		outb(tf->nsect, io_ports->nsect_addr);
+	if (valid & IDE_VALID_LBAL)
+		outb(tf->lbal, io_ports->lbal_addr);
+	if (valid & IDE_VALID_LBAM)
+		outb(tf->lbam, io_ports->lbam_addr);
+	if (valid & IDE_VALID_LBAH)
+		outb(tf->lbah, io_ports->lbah_addr);
+	if (valid & IDE_VALID_DEVICE)
+		__via_dev_select(drive, tf->device);
+}
+
+const struct ide_tp_ops via_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= via_write_devctl,
+
+	.dev_select		= via_dev_select,
+	.tf_load		= via_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
+	.tp_ops		= &via_tp_ops,
 	.port_ops	= &via_port_ops,
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
 			  IDE_HFLAG_POST_SET_MODE |
