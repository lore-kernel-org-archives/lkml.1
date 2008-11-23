Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYKWMfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYKWMfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYKWMfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:35:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36287 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYKWMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:35:31 -0500
Date: Sun, 23 Nov 2008 05:35:14 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <teheo@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
Subject: Re: about TRIM/DISCARD support and barriers
Message-ID: <20081123123514.GI5707@parisc-linux.org>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4929023C.2060302@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 04:11:56PM +0900, Tejun Heo wrote:
> Hello,
> 
> cc'ing Matthew whom I forgot to cc in the first message.  Matthew, the
> original message is...
> 
>  http://lkml.org/lkml/2008/11/22/260
> 
> Tejun Heo wrote:
> > Dongjun Shin who works for Samsung SSD dep asked me about libata TRIM
> > support and pointed me to the new DISCARD support David Woodhouse got
> > merged for 2.6.28.  I took a look at the code and blk-layer
> > interface-wise we seemed to be ready both for filesystems and userland
> > (so that fsck or something which runs background can mark unused
> > blocks) but there doesn't seem to be any low level driver which
> > actually implements ->prepare_discard_fn or fs which sets the DISCARD
> > flag.

The current VFAT filesystem implements DISCARD.  Here's the patch I've
been testing -- it's not right; it causes SSDs from two different vendors
to hang.  I'm waiting for a free slot on the SATA protocol analyser to
figure out what's we're doing wrong.

Note that the SCSI UNMAP command does not yet have an official number,
so this patch cannot yet be applied (... how much longer until ATA is no
longer part of SCSI?)

We don't attempt to put non-contiguous ranges into a single TRIM yet.

We currently assume all SCSI devices support UNMAP instead of checking
the feature flag (because last time I looked, I couldn't tell what flag
I was supposed to check).  Once we do that, I need to set that flag in
libata-scsi depending on the support for the TRIM bit in the identify
command.

It's been a couple of weeks since I looked at this patch, there's
probably something other caveats too.

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 5c99ff8..531c18c 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -324,6 +324,8 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
 
+	if (bio_has_data(bio))
+		__free_page(bio_page(bio));
 	bio_put(bio);
 }
 
@@ -355,7 +357,7 @@ int blkdev_issue_discard(struct block_device *bdev,
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		bio = bio_alloc(gfp_mask, 0);
+		bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
 			return -ENOMEM;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index c3df30c..7ec7ab5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1085,6 +1085,8 @@ EXPORT_SYMBOL(blk_put_request);
 
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
+	might_sleep();
+
 	req->cpu = bio->bi_comp_cpu;
 	req->cmd_type = REQ_TYPE_FS;
 
@@ -1108,7 +1110,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_barrier(bio))
 			req->cmd_flags |= REQ_SOFTBARRIER;
-		req->q->prepare_discard_fn(req->q, req);
+		req->q->prepare_discard_fn(req->q, req, bio);
 	} else if (unlikely(bio_barrier(bio)))
 		req->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bbb30d8..303cc82 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1700,6 +1700,40 @@ nothing_to_do:
 	return 1;
 }
 
+static unsigned int ata_scsi_unmap_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct request *req = scmd->request;
+	char *buffer = bio_data(req->bio);
+	struct ata_taskfile *tf = &qc->tf;
+	unsigned i = 0, size;
+
+	/*
+	 * Ignore what SCSI has written to the buffer.  Will make it easier
+	 * to implement TRIM when ATA is no longer part of SCSI.
+	 */
+
+	i = ata_set_lba_range_entries(buffer, PAGE_SIZE / 8,
+					req->sector, req->nr_sectors);
+	size = ALIGN(i * 8, 512);
+	memset(buffer + i * 8, 0, size - i * 8);
+
+	qc->flags |= ATA_QCFLAG_IO;
+	qc->nbytes = size;
+
+	tf->command = 0x06;		/* Data Set Management */
+	tf->feature = 0x01;		/* TRIM */
+	tf->hob_feature = 0x00;
+	tf->nsect = size / 512;
+	tf->hob_nsect = (size / 512) >> 8;
+	tf->protocol = ATA_PROT_DMA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_WRITE |
+			ATA_TFLAG_LBA48 | ATA_TFLAG_LBA;
+	tf->device = ATA_LBA;
+
+	return 0;
+}
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
@@ -2936,6 +2970,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
 
+	case UNMAP:
+		return ata_scsi_unmap_xlat;
+
 	case ATA_12:
 	case ATA_16:
 		return ata_scsi_pass_thru;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index eb9fac4..db2ec75 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -409,6 +409,49 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	rq->special = task;
 }
 
+static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
+				   struct bio *bio)
+{
+	ide_task_t *task;
+	struct page *page;
+	char *buffer;
+	unsigned i, size;
+
+	/* FIXME: map struct ide_taskfile on rq->cmd[] */
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page) {
+		kfree(task);
+		return -ENOMEM;
+	}
+
+	buffer = page_address(page);
+	i = ata_set_lba_range_entries(buffer, PAGE_SIZE / 8,
+					bio->bi_sector, bio_sectors(bio));
+	size = ALIGN(i * 8, 512);
+	memset(buffer + i * 8, 0, size - i * 8);
+	bio_add_pc_page(q, bio, page, i * 8, 0);
+
+	task->tf.command = 0x06; /* Data Set Management */
+	task->tf.feature = 0x01; /* TRIM */
+	task->tf.hob_feature = 0x00;
+	task->tf.nsect = size / 512;
+	task->tf.hob_nsect = (size / 512) >> 8;
+
+	task->tf_flags	 = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
+			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			   IDE_TFLAG_DYN;
+	task->data_phase = TASKFILE_OUT_DMA;
+
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->special = task;
+
+	return 0;
+}
+
 ide_devset_get(multcount, mult_count);
 
 /*
@@ -526,6 +569,9 @@ static int set_wcache(ide_drive_t *drive, int arg)
 
 	update_ordered(drive);
 
+	if (ata_id_has_trim(drive->id))
+		blk_queue_set_discard(drive->queue, idedisk_prepare_discard);
+
 	return err;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7162d67..103a2cc 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -576,7 +576,12 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
 	if (hwif->sg_mapped)	/* needed by ide-scsi */
 		return;
 
-	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
+	if (blk_discard_rq(rq)) {
+		ide_task_t *task = rq->special;
+		unsigned len = (task->tf.hob_nsect << 8) + task->tf.nsect;
+		sg_init_one(sg, rq->buffer, len * 512);
+		hwif->sg_nents = 1;
+	} else if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	} else {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c9e1242..c54b5da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -49,6 +49,7 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -367,6 +368,32 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+/*
+ * sd_discard_fn - Prepare a discard request for transmission
+ * XXX: Add support for sending multiple extents to UNMAP.
+ */
+static int sd_discard_fn(struct request_queue *q, struct request *rq,
+							struct bio *bio)
+{
+	char *unmap;
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	bio_add_pc_page(q, bio, page, 24, 0);
+
+	unmap = bio_data(bio);
+	memset(unmap, 0, 12);
+	put_unaligned_be64(bio->bi_sector, unmap + 12);
+	put_unaligned_be32(bio_sectors(bio), unmap + 20);
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_len = 10;
+	rq->cmd[0] = UNMAP;
+	put_unaligned_be16(24, rq->cmd + 7);
+
+	return 0;
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -1894,6 +1921,7 @@ static int sd_probe(struct device *dev)
 	sd_revalidate_disk(gd);
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
+	blk_queue_set_discard(sdp->request_queue, sd_discard_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a53318b..d15196d 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -89,6 +89,7 @@ enum {
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
 	ATA_ID_CFA_POWER	= 160,
+	ATA_ID_DATA_SET_MGMT	= 169,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
 
@@ -717,6 +718,14 @@ static inline int ata_id_has_unload(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_trim(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_DATA_SET_MGMT] & 1))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -852,6 +861,29 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 #endif
 }
 
+/*
+ * Write up to 'max' LBA Range Entries to the buffer that will cover the
+ * extent from sector to sector + count.  This is used for TRIM and for
+ * ADD LBA(S) TO NV CACHE PINNED SET.
+ */
+static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
+						u64 sector, unsigned long count)
+{
+	__le64 *buffer = _buffer;
+	unsigned i = 0;
+	while (i < max) {
+		u64 entry = sector |
+			((u64)(count > 0xffff ? 0xffff : count) << 48);
+		buffer[i++] = __cpu_to_le64(entry);
+		if (count <= 0xffff)
+			break;
+		count -= 0xffff;
+		sector += 0xffff;
+	}
+
+	return i;
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a135256..79dd6d8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -259,7 +259,8 @@ typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
-typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
+typedef int (prepare_discard_fn) (struct request_queue *, struct request *,
+							struct bio *bio);
 
 struct bio_vec;
 struct bvec_merge_data {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..e91c0b7 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -93,6 +93,7 @@
 #define WRITE_LONG            0x3f
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
+#define UNMAP                 0x42	/* XXX: Provisional */
 #define READ_TOC              0x43
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
