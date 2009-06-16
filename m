Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbZFPF7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbZFPF7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935870AbZFPFv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:27 -0400
Received: from kroah.org ([198.145.64.141]:48406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935753AbZFPFvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: [PATCH 39/64] ide: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:28 -0700
Message-Id: <1245131213-24168-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-ide@vger.kernel.org
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-pm.c       |    6 ++++--
 drivers/ide/ide-probe.c    |    4 ++--
 drivers/ide/ide_platform.c |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index ba1488b..c14ca14 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -3,7 +3,8 @@
 
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
-	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
+	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
@@ -34,7 +35,8 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 int generic_ide_resume(struct device *dev)
 {
-	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
+	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index f371b0d..79e0af3 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -535,7 +535,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	/* register with global device tree */
 	dev_set_name(&hwif->gendev, hwif->name);
-	hwif->gendev.driver_data = hwif;
+	dev_set_drvdata(&hwif->gendev, hwif);
 	if (hwif->gendev.parent == NULL)
 		hwif->gendev.parent = hwif->dev;
 	hwif->gendev.release = hwif_release_dev;
@@ -987,9 +987,9 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 		int ret;
 
 		dev_set_name(dev, "%u.%u", hwif->index, i);
+		dev_set_drvdata(dev, drive);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
-		dev->driver_data = drive;
 		dev->release = drive_release_dev;
 
 		ret = device_register(dev);
diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index ee9b55e..b579fbe 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -112,7 +112,7 @@ out:
 
 static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
-	struct ide_host *host = pdev->dev.driver_data;
+	struct ide_host *host = dev_get_drvdata(&pdev->dev);
 
 	ide_host_remove(host);
 
-- 
1.6.3.2

