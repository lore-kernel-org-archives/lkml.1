Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYBQVTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYBQVTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYBQVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:19:29 -0500
Received: from 1wt.eu ([62.212.114.60]:2015 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYBQVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:19:28 -0500
Date: Sun, 17 Feb 2008 22:19:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] libata: implement ATA_IOC_GET_IO32/ATA_IOC_SET_IO32 ioctls
Message-ID: <20080217211922.GA15327@1wt.eu>
References: <20080217211810.GA15001@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217211810.GA15001@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 40a8174d27cb9d93b859bc073c8f075b9ff71578 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Sun, 17 Feb 2008 21:11:46 +0100
Subject: [PATCH 1/2] libata: implement ATA_IOC_GET_IO32/ATA_IOC_SET_IO32 ioctls

This patch implements the aforementionned ioctls and get/set the
new ATA_DFLAG_32BIT_PIO ata flag accordingly for the device. It
only supports values 0 and 1 (disable/enable), as I have no plan
to implement the sync VLB transfers.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/ata/libata-scsi.c |   70 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/libata.h    |    1 +
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1cea18f..8b4ca45 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -448,22 +448,76 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
+/**
+ *	ata_get_io32 - Handler for ATA_IOC_GET_IO32 ioctl
+ *	@sdev: SCSI device to get identify data for
+ *	@arg: User buffer area for return value
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  We don't really care.
+ *
+ *	RETURNS:
+ *	Zero on success, negative errno on error.
+ */
+static int ata_get_io32(struct scsi_device *sdev, void __user *arg)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
+	int val;
+
+	if (!dev)
+		return -ENOMSG;
+
+	val = (dev->flags & ATA_DFLAG_32BIT_PIO) != 0;
+	if (copy_to_user(arg, &val, 1))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ *	ata_set_io32 - Handler for ATA_IOC_SET_IO32 ioctl
+ *	@sdev: SCSI device to get identify data for
+ *	@arg: boolean integer value passed by user
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  We don't really care.
+ *
+ *	RETURNS:
+ *	Zero on success, negative errno on error.
+ */
+static int ata_set_io32(struct scsi_device *sdev, void __user *arg)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
+
+	if (!dev)
+		return -ENOMSG;
+
+	switch ((unsigned long) arg) {
+	case 0:
+		dev->flags &= ~ATA_DFLAG_32BIT_PIO;
+		return 0;
+	case 1:
+		dev->flags |=  ATA_DFLAG_32BIT_PIO;
+		return 0;
+	default:
+		break;
+	}
+
+	return -EFAULT;
+}
+
 int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
 
 	switch (cmd) {
 	case ATA_IOC_GET_IO32:
-		val = 0;
-		if (copy_to_user(arg, &val, 1))
-			return -EFAULT;
-		return 0;
+		return ata_get_io32(scsidev, arg);
 
 	case ATA_IOC_SET_IO32:
-		val = (unsigned long) arg;
-		if (val != 0)
-			return -EINVAL;
-		return 0;
+		return ata_set_io32(scsidev, arg);
 
 	case HDIO_GET_IDENTITY:
 		return ata_get_identity(scsidev, arg);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc5a8d0..ea9e3fc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -138,6 +138,7 @@ enum {
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
 	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
 	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
+	ATA_DFLAG_32BIT_PIO	= (1 << 10), /* device supports 32-bit in PIO mode */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
-- 
1.5.3.8

