Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbYBHAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbYBHAej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763273AbYBHAbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:23469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763210AbYBHAbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BqVZUfwAZPUWcUC4zfMVfYkzWugC508RGojXHKpA2MfJ1kI+smJaAzIytIN3AdtIMyyQ9E1VR5gLcI2HIx26/cphrGzltOP+OPT9Y0q/UImXnVhj46oao56/fztVfJi6AdvjD3marmzF+/upHboJbihYUafnIB8nt6667ynCMeU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:16 +0100
Message-Id: <20080208004516.17746.18498.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/18] ide: move ide_port_setup_devices() call to ide_device_add_all()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_cfg_mtx lock/unlock to ide_port_setup_devices() and then move
ide_port_setup_devices() call from init_irq() to ide_device_add_all().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -947,6 +947,7 @@ static void ide_port_setup_devices(ide_h
 {
 	int i;
 
+	mutex_lock(&ide_cfg_mtx);
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
@@ -961,6 +962,7 @@ static void ide_port_setup_devices(ide_h
 
 		ide_add_drive_to_hwgroup(drive);
 	}
+	mutex_unlock(&ide_cfg_mtx);
 }
 
 /*
@@ -1086,8 +1088,6 @@ static int init_irq (ide_hwif_t *hwif)
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
 	printk("\n");
 
-	ide_port_setup_devices(hwif);
-
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_unlink:
@@ -1443,6 +1443,8 @@ int ide_device_add_all(u8 *idx, const st
 			continue;
 		}
 
+		ide_port_setup_devices(hwif);
+
 		ide_acpi_init(hwif);
 		ide_acpi_port_init_devices(hwif);
 	}
