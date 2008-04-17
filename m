Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYDQWOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYDQWOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYDQWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:13:59 -0400
Received: from 1wt.eu ([62.212.114.60]:3201 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbYDQWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:13:58 -0400
Date: Fri, 18 Apr 2008 00:02:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: [PATCH] libata: implement support for 32-bit PIO transfers
Message-ID: <20080417220205.GA7748@1wt.eu>
References: <20080217211810.GA15001@1wt.eu> <20080217211922.GA15327@1wt.eu> <4807A9B0.3010108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4807A9B0.3010108@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

here's an update of the patch. Rebuilt and re-tested against 2.6.25.
I've added Alan's previous Acked-by too btw.

Regards,
Willy


>From 734d62ad5b63108bfc244433aedaf6190543e279 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Thu, 17 Apr 2008 23:59:41 +0200
Subject: libata: implement support for 32-bit PIO transfers

This patch implements ATA_IOC_GET_IO32/ATA_IOC_SET_IO32 ioctls and
gets/sets the new ATA_DFLAG_32BIT_PIO ata flag accordingly for the
device. It only supports values 0 and 1 (disable/enable), as I have
no plan to implement the sync VLB transfers.

When ATA_DFLAG_32BIT_PIO is set in ata flags, PIO transfers will be
performed in 32-bit, just like with the plain old IDE drivers.

16-bit transfers in libata are as slow as 16-bit transfers in plain
old IDE drivers, which are about 35% slower than 32-bit transfers
with various CF and DOM. This patch restores the performance to
pre-libata level, which is a nice improvement for many small systems
relying on such hardware. On an ALIX board equipped with a 64 MB CF
card, transfer speed went up from 1.49 MB/sec to 2.41 MB/s, which
represents a net gain of 61%.

To enable 32-bit transfers, simply proceed like before with
IDE :

  # hdparm -c 1 /dev/sda

Signed-off-by: Willy Tarreau <w@1wt.eu>
Acked-by: Alan Cox <alan@redhat.com>
---
 drivers/ata/libata-core.c |   46 ++++++++++++++++++--------
 drivers/ata/libata-scsi.c |   77 +++++++++++++++++++++++++++++++++++++-------
 include/linux/libata.h    |    1 +
 3 files changed, 97 insertions(+), 27 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index be95fdb..22c2643 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5036,7 +5036,7 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 }
 
 /**
- *	ata_data_xfer - Transfer data by PIO
+ *	ata_data_xfer - Transfer data by PIO (16 or 32-bit)
  *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
@@ -5055,30 +5055,48 @@ unsigned int ata_data_xfer(struct ata_device *dev, unsigned char *buf,
 {
 	struct ata_port *ap = dev->link->ap;
 	void __iomem *data_addr = ap->ioaddr.data_addr;
-	unsigned int words = buflen >> 1;
+	unsigned int words;
 
-	/* Transfer multiple of 2 bytes */
-	if (rw == READ)
-		ioread16_rep(data_addr, buf, words);
-	else
-		iowrite16_rep(data_addr, buf, words);
+	if (dev->flags & ATA_DFLAG_32BIT_PIO) {
+		/* Transfer in 32-bit words */
+		words = buflen >> 2;
+		if (rw == READ)
+			ioread32_rep(data_addr, buf, words);
+		else
+			iowrite32_rep(data_addr, buf, words);
+		words <<= 2;
+	} else {
+		/* Transfer in 16-bit words */
+		words = buflen >> 1;
+		if (rw == READ)
+			ioread16_rep(data_addr, buf, words);
+		else
+			iowrite16_rep(data_addr, buf, words);
+		words <<= 1;
+	}
 
-	/* Transfer trailing 1 byte, if any. */
-	if (unlikely(buflen & 0x01)) {
+	/* Transfer trailing 1, 2 or 3 bytes, if any. We know how many bytes
+	 * remain because <words> now contains the number of bytes transferred.
+	 */
+	while (buflen > words) {
 		__le16 align_buf[1] = { 0 };
-		unsigned char *trailing_buf = buf + buflen - 1;
+		unsigned char *trailing_buf = buf + words;
+		int len = buflen - words;
+
+		if (len > 2)
+			len = 2;
 
 		if (rw == READ) {
 			align_buf[0] = cpu_to_le16(ioread16(data_addr));
-			memcpy(trailing_buf, align_buf, 1);
+			memcpy(trailing_buf, align_buf, len);
 		} else {
-			memcpy(align_buf, trailing_buf, 1);
+			memcpy(align_buf, trailing_buf, len);
 			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
 		}
-		words++;
+		words += len;
 	}
 
-	return words << 1;
+	return words;
 }
 
 /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1579539..c0205de 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -448,22 +448,74 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
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
 {
-	int val = -EINVAL, rc = -EINVAL;
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
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
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
@@ -479,11 +531,10 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 		return ata_task_ioctl(scsidev, arg);
 
 	default:
-		rc = -ENOTTY;
-		break;
+		return -ENOTTY;
 	}
 
-	return rc;
+	return -EINVAL;
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 37ee881..1f1a9be 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -139,6 +139,7 @@ enum {
 	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
 	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
+	ATA_DFLAG_32BIT_PIO	= (1 << 11), /* device supports 32-bit in PIO mode */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
-- 
1.5.3.8

