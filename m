Return-Path: <linux-kernel-owner+w=401wt.eu-S965334AbXBUD4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965334AbXBUD4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXBUD4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:56:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:38742 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965334AbXBUD4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:56:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=RwqgVvQVKde0qp1Bq8VQQi70dVuyt42DU9JfGZX/P/WqlFXIjnS9yukuj+3atH+r7D1MDvBHOg36z+M7dx9dhqWl88v7wc3qkGyuUdp+e29jl8vU6BWjXNzEWtMZ1S+rd4ywzvIyLlOoUNxq1RhjKsDvkNQZ9JaOlwkfNlz41fU=
Message-ID: <45DBC2CE.6040408@gmail.com>
Date: Wed, 21 Feb 2007 12:55:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Marcus Haebler <haebler@gmail.com>
CC: Pablo Sebastian Greco <lkml@fliagreco.com.ar>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>	 <459CFE7B.6090306@fliagreco.com.ar>	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com>	 <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>	 <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com> <d72aa1340702201655o78975cc7vd67c82eea92bd519@mail.gmail.com>
In-Reply-To: <d72aa1340702201655o78975cc7vd67c82eea92bd519@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: multipart/mixed;
 boundary="------------070507020408060200060006"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070507020408060200060006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Marcus Haebler wrote:
> thanks for the patches! I am on an Intel P965/ICH8R.

I see.  That can happen too.  There was a race window where in-flight
r/w command which left SCSI midlayer but pending on libata gets executed
in the wrong mode.  If possible, please verify that it doesn't happen
with the patches applied.  I'm attaching combined patch against v2.6.20.

Thanks.

-- 
tejun

--------------070507020408060200060006
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 667acd2..348cc02 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -308,9 +308,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->flags |= tf_flags;
 
-	if ((dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
-			   ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ &&
-	    likely(tag != ATA_TAG_INTERNAL)) {
+	if (ata_ncq_enabled(dev) && likely(tag != ATA_TAG_INTERNAL)) {
 		/* yay, NCQ */
 		if (!lba_48_ok(block, n_block))
 			return -ERANGE;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 73902d3..ebb9185 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -945,29 +945,32 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
-	int max_depth;
 
-	if (queue_depth < 1)
+	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
 	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev || !ata_dev_enabled(dev))
 		return sdev->queue_depth;
 
-	max_depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
-	max_depth = min(ATA_MAX_QUEUE - 1, max_depth);
-	if (queue_depth > max_depth)
-		queue_depth = max_depth;
-
-	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
-
+	/* NCQ enabled? */
 	spin_lock_irqsave(ap->lock, flags);
-	if (queue_depth > 1)
-		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
-	else
+	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
+	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
+		queue_depth = 1;
+	}
 	spin_unlock_irqrestore(ap->lock, flags);
 
+	/* limit and apply queue depth */
+	queue_depth = min(queue_depth, sdev->host->can_queue);
+	queue_depth = min(queue_depth, ata_id_queue_depth(dev->id));
+	queue_depth = min(queue_depth, ATA_MAX_QUEUE - 1);
+
+	if (sdev->queue_depth == queue_depth)
+		return -EINVAL;
+
+	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
 	return queue_depth;
 }
 
@@ -1454,11 +1457,9 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 static int ata_scmd_need_defer(struct ata_device *dev, int is_io)
 {
 	struct ata_port *ap = dev->ap;
+	int is_ncq = is_io && ata_ncq_enabled(dev);
 
-	if (!(dev->flags & ATA_DFLAG_NCQ))
-		return 0;
-
-	if (is_io) {
+	if (is_ncq) {
 		if (!ata_tag_valid(ap->active_tag))
 			return 0;
 	} else {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 91bb8ce..4e4e365 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1035,6 +1035,21 @@ static inline u8 ata_chk_status(struct ata_port *ap)
 	return ap->ops->check_status(ap);
 }
 
+/**
+ *	ata_ncq_enabled - Test whether NCQ is enabled
+ *	@dev: ATA device to test for
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	1 if NCQ is enabled for @dev, 0 otherwise.
+ */
+static inline int ata_ncq_enabled(struct ata_device *dev)
+{
+	return (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
+			      ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
+}
 
 /**
  *	ata_pause - Flush writes and pause 400 nanoseconds.

--------------070507020408060200060006--
