Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZBAC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZBAC52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 21:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZBAC4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 21:56:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:34845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZBAC4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 21:56:32 -0500
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] libata: export HPA size as alt_size
Date: Sun,  1 Feb 2009 11:55:51 +0900
Message-Id: <1233456951-992-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Feb 2009 02:56:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export HPA size as alt_size so that userland tools which need the BIOS
size can determine it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata-scsi.c |    2 ++
 include/linux/libata.h    |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88c2428..cfea50a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1537,6 +1537,8 @@ static int ata_hpa_resize(struct ata_device *dev)
 	}
 
 	/* let's unlock HPA */
+	dev->alt_n_sectors = sectors;
+
 	rc = ata_set_max_sectors(dev, native_sectors);
 	if (rc == -EACCES) {
 		/* if device aborted the command, skip HPA resizing */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3c4c5ae..911fe7c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1104,6 +1104,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
 		sdev->manage_start_stop = 1;
+
+		sdev->alt_capacity = dev->alt_n_sectors;
 	}
 
 	if (dev->flags & ATA_DFLAG_AN)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bca3ba2..97736d5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -582,6 +582,7 @@ struct ata_device {
 #endif
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			alt_n_sectors;	/* size bios wants us to see */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
-- 
1.6.0.2

