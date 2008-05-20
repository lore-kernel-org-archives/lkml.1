Return-Path: <linux-kernel-owner+w=401wt.eu-S934868AbYETWhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbYETWhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934997AbYETWfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:39727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934721AbYETWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 04/13] ide: fix race in device_create
Date: Tue, 20 May 2008 15:34:51 -0700
Message-Id: <1211322900-12705-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-probe.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 34b0d4f..655ec7e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -648,13 +648,12 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	get_device(&hwif->gendev);
 
-	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
-				      MKDEV(0, 0), hwif->name);
+	hwif->portdev = device_create_drvdata(ide_port_class, &hwif->gendev,
+					      MKDEV(0, 0), hwif, hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
 		device_unregister(&hwif->gendev);
 	}
-	dev_set_drvdata(hwif->portdev, hwif);
 out:
 	return ret;
 }
-- 
1.5.5.1

