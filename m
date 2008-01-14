Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYANXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYANXrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYANXrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:47:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:58308 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYANXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gTrZfRK7ABWaiLMzM8BQ7H+hbYVRxBLw9DFNLdHNS1TuRLYd+ZsOHMNTwLBj6SdFfdHllVyJgIjsqnbHo70j+008JEcR+CXwEwFHHNODTvmPs+kUeKxV8rqVr5N6aLlL1K+5oJ4HW+oszE6uuWYPjTY/uLIe09TwJEAgHScDpyA=
Message-ID: <478BF473.9050602@gmail.com>
Date: Tue, 15 Jan 2008 08:46:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ondrej Zary <linux@rainbow-software.org>, Jeff Garzik <jgarzik@redhat.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH #upstream-fixes] libata: relocate sdev->manage_start_stop
 configuration
References: <20080114210805.GH9847@does.not.exist>
In-Reply-To: <20080114210805.GH9847@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 9b8e8de7, manage_start_stop configuration depends on valid ATA
device.  Move it into ata_scsi_dev_config().  This was detected by the
coverity checker.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
---
 drivers/ata/libata-scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7c13663..a6575b7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -872,9 +875,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev->class == ATA_DEV_ATA)
-		sdev->manage_start_stop = 1;
-
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
