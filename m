Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYCGS1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYCGS1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbYCGS0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:26:07 -0500
Received: from nebensachen.de ([195.34.83.29]:59645 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762597AbYCGS0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:26:04 -0500
X-Hashcash: 1:20:080307:alan@lxorguk.ukuu.org.uk::HBK/VKuzjDXPvIN8:000000000000000000000000000000000000032iX
X-Hashcash: 1:20:080307:linux-ide@vger.kernel.org::P+AnYMKw5/N6JrAQ:0000000000000000000000000000000000007VI6
X-Hashcash: 1:20:080307:linux-kernel@vger.kernel.org::SUOH0ExtYszjLn7x:0000000000000000000000000000000002nHf
X-Hashcash: 1:20:080307:jens.axboe@oracle.com::08A9SwI+fwQsEPmR:00000000000000000000000000000000000000002JT5
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/4] disk-protect: Add a REQ_TYPE_LINUX_BLOCK request handler
	to libata
Message-ID: <20080307181750.9981.16714.stgit@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
User-Agent: StGIT/0.12.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Fri, 07 Mar 2008 19:26:14 +0100
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines a generic handler to be used as the lb_request_fn() callback for
libata managed hosts. Support for REQ_LB_OP_FREEZE and REQ_LB_OP_THAW is
included as well.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ata/ahci.c        |    1 +
 drivers/ata/ata_piix.c    |    1 +
 drivers/ata/libata-scsi.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h    |    2 ++
 include/linux/libata.h    |    1 +
 5 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54f38c2..324c4fa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -273,6 +273,7 @@ static struct scsi_host_template ahci_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.lb_request_fn		= ata_scsi_lb_request_fn,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= AHCI_MAX_CMDS - 1,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b406b39..c2b7ad7 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -283,6 +283,7 @@ static struct scsi_host_template piix_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.lb_request_fn		= ata_scsi_lb_request_fn,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d0fd762..df25aa4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3123,6 +3123,59 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	}
 }
 
+/**
+ *	ata_scsi_lb_request_fn - process block request for libata-managed device
+ *	@req: REQ_TYPE_LINUX_BLOCK request to be processed
+ *
+ *	This function is the default handler for REQ_TYPE_LINUX_BLOCK
+ *	requests in libata.
+ *
+ *	LOCKING:
+ *	Releases queue lock, and obtains host lock.
+ *
+ *	RETURNS:
+ *	SUCCESS if opcode is known to us, FAILED otherwise.
+ */
+
+int ata_scsi_lb_request_fn(struct request *req)
+{
+	struct request_queue *q = req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ata_device *dev;
+	int rc = SUCCESS;
+
+	spin_unlock(q->queue_lock);
+	spin_lock(ap->lock);
+
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev)) {
+		req->errors = -ENXIO;
+		goto out;
+	}
+
+	switch (req->cmd[0]) {
+	case REQ_LB_OP_FREEZE:
+		ata_scsi_protect_dev(dev);
+		break;
+
+	case REQ_LB_OP_THAW:
+		ata_scsi_unprotect_dev(dev);
+		break;
+
+	default:
+		rc = FAILED;
+		goto out;
+	}
+
+out:
+	spin_unlock(ap->lock);
+	spin_lock(q->queue_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_scsi_lb_request_fn);
+
 int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5955b57..1854a69 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -164,6 +164,8 @@ enum {
 	 */
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
 	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+	REQ_LB_OP_FREEZE = 0x42,	/* freeze queue (protect device) */
+	REQ_LB_OP_THAW	= 0x3,		/* thaw queue */
 };
 
 /*
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2db23c3..4e97964 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -809,6 +809,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern int ata_scsi_lb_request_fn(struct request *req);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);


