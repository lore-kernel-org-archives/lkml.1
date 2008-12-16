Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYLPTdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYLPTdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYLPTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:12 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64756 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbYLPTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=J3rX2IwQpCkaEZaSHjfiNJjc8qszgnRhNVf0mSGp/tWk54XlUYI7AHwWd3vBHPskTR
         xN03nNt/FwntRBNhDT1LI4g8TFR6/NbCxFbErS5fcM0Ktf5IJkEiukxju/VxU6DL8xDD
         TpMx9Wb+ZLrHcZdF0bd5BzLwpzrlfGwcKreEI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:31:57 +0100
Message-Id: <20081216193157.3959.80875.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide: remove local_irq_set() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove local_irq_set() macro

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c  |    3 ++-
 drivers/ide/ide-probe.c |    3 ++-
 include/linux/ide.h     |    2 --
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -503,7 +503,8 @@ static int __ide_wait_stat(ide_drive_t *
 	stat = tp_ops->read_status(hwif);
 
 	if (stat & ATA_BUSY) {
-		local_irq_set(flags);
+		local_irq_save(flags);
+		local_irq_enable_in_hardirq();
 		timeout += jiffies;
 		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
 			if (time_after(jiffies, timeout)) {
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -796,7 +796,8 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		disable_irq(hwif->irq);
 
-	local_irq_set(flags);
+	local_irq_save(flags);
+	local_irq_enable_in_hardirq();
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1585,8 +1585,6 @@ static inline void ide_set_max_pio(ide_d
 	ide_set_pio(drive, 255);
 }
 
-#define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
-
 char *ide_media_string(ide_drive_t *);
 
 extern struct device_attribute ide_dev_attrs[];
