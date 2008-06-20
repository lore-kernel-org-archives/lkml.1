Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYFTVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYFTVge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761719AbYFTVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761656AbYFTVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mglgJIHFGvw69+tXzibveyEsFbCHIYZDke2PMCMjeJjfc4DR1f4v6ZH2a/kuuYxcjw
         BxRfCQWYaiBAKknD/z067EAp5fQsm6LMJQNP/u/nhVGL7Q1jM3MY5ROc8uMpoNHIcy3Y
         WX+QdX9a58SPp2jdpV36C89pSkXg+XztaNuU8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:51 +0200
Message-Id: <20080620213451.13202.12671.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
+	ide_task_t task;
 
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
+
+	drive->hwif->tf_load(drive, &task);
 }
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
