Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYADVR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYADVR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYADVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:14:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYADVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Xu07lUiu/t/Gu6CDyTASK9L0GDkh9WB8UIdtgh+jv0bLMPAR4m31EYlzNMqzlx4rn7m3WkQKh7EVjrnM0uwZERzE2vv6GVOE8biMwro8UQGt9wL6+tpr54YdgrOP0H+enNAWWx8jgq01nyQRUAq6gqg/rwaFUOYtfmAQ6gSIzWM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:26:13 +0100
Message-Id: <20080104212613.6978.76964.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/15] ide: factor out code for tuning devices from ide_probe_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out code for tuning devices from ide_probe_port()
  to ide_port_tune_devices().

* Move ide_port_tune_devices() call from ide_probe_port()
  to ide_device_add_all().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -794,6 +794,13 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (!hwif->present)
 		return -ENODEV;
 
+	return 0;
+}
+
+static void ide_port_tune_devices(ide_hwif_t *hwif)
+{
+	int unit;
+
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
@@ -827,8 +834,6 @@ static int ide_probe_port(ide_hwif_t *hw
 		else
 			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
 	}
-
-	return 0;
 }
 
 #if MAX_HWIFS > 1
@@ -1309,8 +1314,12 @@ int ide_device_add_all(u8 *idx)
 			continue;
 		}
 
-		if (ide_probe_port(hwif) < 0)
+		if (ide_probe_port(hwif) < 0) {
 			ide_hwif_release_regions(hwif);
+			continue;
+		}
+
+		ide_port_tune_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
