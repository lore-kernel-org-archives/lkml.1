Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYGVFaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYGVFaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYGVFXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:17 -0400
Received: from mail.suse.de ([195.135.220.2]:53859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbYGVFXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/79] device create: spi: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:50 -0700
Message-Id: <1216703983-21448-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Switch over to use the shiny new device_create_drvdata() call
instead of the original device_create() calls, so this continues
to work after device_create() is  removed.

Note that this driver never had the race which motivated removing
the original call; it locked correctly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/spidev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index ddbe1a5..2833fd7 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -576,7 +576,8 @@ static int spidev_probe(struct spi_device *spi)
 		struct device *dev;
 
 		spidev->devt = MKDEV(SPIDEV_MAJOR, minor);
-		dev = device_create(spidev_class, &spi->dev, spidev->devt,
+		dev = device_create_drvdata(spidev_class, &spi->dev,
+				spidev->devt, spidev,
 				"spidev%d.%d",
 				spi->master->bus_num, spi->chip_select);
 		status = IS_ERR(dev) ? PTR_ERR(dev) : 0;
@@ -586,7 +587,6 @@ static int spidev_probe(struct spi_device *spi)
 	}
 	if (status == 0) {
 		set_bit(minor, minors);
-		spi_set_drvdata(spi, spidev);
 		list_add(&spidev->device_entry, &device_list);
 	}
 	mutex_unlock(&device_list_lock);
-- 
1.5.6.3

