Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXAaXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXAaXaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030464AbXAaXaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:30:39 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54358 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030460AbXAaXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:30:37 -0500
Date: Thu, 1 Feb 2007 00:30:44 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Message-ID: <20070131233044.GX3754@stusta.de>
References: <20070130195319.GA10994@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <20070130195319.GA10994@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2007 at 08:53:19PM +0100, Luca Tettamanti wrote:
> Hi,
> pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> is written to the device is lost after umount.
> I rarely use pktcdvd but at some point it used to work on my system.
> 
> This is what I'm doing:
> 
> root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> using device /dev/scd0
> 1029KB internal buffer
> setting write speed to 12x
> Settings for /dev/scd0:
>         Fixed packets, size 32
>         Mode-2 disc
>...

Does 2.6.20-rc7 work?
If no, does it work after applying the attached patch?
If no, does 2.6.19.2 work?

> Luca

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pktcdvd

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 6246219..7c95c76 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -765,34 +765,47 @@ static inline struct bio *pkt_get_list_first(struct bio **list_head, struct bio
  */
 static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
 {
-	request_queue_t *q = bdev_get_queue(pd->bdev);
+	char sense[SCSI_SENSE_BUFFERSIZE];
+	request_queue_t *q;
 	struct request *rq;
-	int ret = 0;
-
-	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
-			     WRITE : READ, __GFP_WAIT);
-
-	if (cgc->buflen) {
-		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
-			goto out;
-	}
+	DECLARE_COMPLETION_ONSTACK(wait);
+	int err = 0;
 
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
-	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
-		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
+	q = bdev_get_queue(pd->bdev);
 
+	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ? WRITE : READ,
+			     __GFP_WAIT);
+	rq->errors = 0;
+	rq->rq_disk = pd->bdev->bd_disk;
+	rq->bio = NULL;
+	rq->buffer = NULL;
 	rq->timeout = 60*HZ;
+	rq->data = cgc->buffer;
+	rq->data_len = cgc->buflen;
+	rq->sense = sense;
+	memset(sense, 0, sizeof(sense));
+	rq->sense_len = 0;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;
+	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
+		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+
+	rq->ref_count++;
+	rq->end_io_data = &wait;
+	rq->end_io = blk_end_sync_rq;
+	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
+	generic_unplug_device(q);
+	wait_for_completion(&wait);
+
+	if (rq->errors)
+		err = -EIO;
 
-	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
-	ret = rq->errors;
-out:
 	blk_put_request(rq);
-	return ret;
+	return err;
 }
 
 /*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f02f48a..6fe1e82 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -998,14 +998,25 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	int		   count;
 
 	/*
-	 * We used to not use scatter-gather for single segment request,
+	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
+	 */
+	if (blk_pc_request(req) && !req->bio) {
+		cmd->request_bufflen = req->data_len;
+		cmd->request_buffer = req->data;
+		req->buffer = req->data;
+		cmd->use_sg = 0;
+		return 0;
+	}
+
+	/*
+	 * we used to not use scatter-gather for single segment request,
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
 	cmd->use_sg = req->nr_phys_segments;
 
 	/*
-	 * If sg table allocation fails, requeue request later.
+	 * if sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
@@ -1013,21 +1024,24 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 		return BLKPREP_DEFER;
 	}
 
-	req->buffer = NULL;
 	cmd->request_buffer = (char *) sgpnt;
+	cmd->request_bufflen = req->nr_sectors << 9;
 	if (blk_pc_request(req))
 		cmd->request_bufflen = req->data_len;
-	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+	req->buffer = NULL;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
+
+	/*
+	 * mapped well, send it off
+	 */
 	if (likely(count <= cmd->use_sg)) {
 		cmd->use_sg = count;
-		return BLKPREP_OK;
+		return 0;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
@@ -1057,27 +1071,6 @@ static int scsi_issue_flush_fn(request_queue_t *q, struct gendisk *disk,
 	return -EOPNOTSUPP;
 }
 
-static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
-		struct request *req)
-{
-	struct scsi_cmnd *cmd;
-
-	if (!req->special) {
-		cmd = scsi_get_command(sdev, GFP_ATOMIC);
-		if (unlikely(!cmd))
-			return NULL;
-		req->special = cmd;
-	} else {
-		cmd = req->special;
-	}
-
-	/* pull a tag out of the request if we have one */
-	cmd->tag = req->tag;
-	cmd->request = req;
-
-	return cmd;
-}
-
 static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
@@ -1090,37 +1083,9 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	scsi_io_completion(cmd, cmd->request_bufflen);
 }
 
-static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
+static void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd)
 {
-	struct scsi_cmnd *cmd;
-
-	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd))
-		return BLKPREP_DEFER;
-
-	/*
-	 * BLOCK_PC requests may transfer data, in which case they must
-	 * a bio attached to them.  Or they might contain a SCSI command
-	 * that does not transfer data, in which case they may optionally
-	 * submit a request without an attached bio.
-	 */
-	if (req->bio) {
-		int ret;
-
-		BUG_ON(!req->nr_phys_segments);
-
-		ret = scsi_init_io(cmd);
-		if (unlikely(ret))
-			return ret;
-	} else {
-		BUG_ON(req->data_len);
-		BUG_ON(req->data);
-
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
-		req->buffer = NULL;
-	}
+	struct request *req = cmd->request;
 
 	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
@@ -1136,138 +1101,154 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
 	cmd->done = scsi_blk_pc_done;
-	return BLKPREP_OK;
-}
-
-/*
- * Setup a REQ_TYPE_FS command.  These are simple read/write request
- * from filesystems that still need to be translated to SCSI CDBs from
- * the ULD.
- */
-static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
-{
-	struct scsi_cmnd *cmd;
-	struct scsi_driver *drv;
-	int ret;
-
-	/*
-	 * Filesystem requests must transfer data.
-	 */
-	BUG_ON(!req->nr_phys_segments);
-
-	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd))
-		return BLKPREP_DEFER;
-
-	ret = scsi_init_io(cmd);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * Initialize the actual SCSI command for this request.
-	 */
-	drv = *(struct scsi_driver **)req->rq_disk->private_data;
-	if (unlikely(!drv->init_command(cmd))) {
-		scsi_release_buffers(cmd);
-		scsi_put_command(cmd);
-		return BLKPREP_KILL;
-	}
-
-	return BLKPREP_OK;
 }
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
-	int ret = BLKPREP_OK;
+	struct scsi_cmnd *cmd;
+	int specials_only = 0;
 
 	/*
-	 * If the device is not in running state we will reject some
-	 * or all commands.
+	 * Just check to see if the device is online.  If it isn't, we
+	 * refuse to process any commands.  The device must be brought
+	 * online before trying any recovery commands
 	 */
+	if (unlikely(!scsi_device_online(sdev))) {
+		sdev_printk(KERN_ERR, sdev,
+			    "rejecting I/O to offline device\n");
+		goto kill;
+	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
-		switch (sdev->sdev_state) {
-		case SDEV_OFFLINE:
-			/*
-			 * If the device is offline we refuse to process any
-			 * commands.  The device must be brought online
-			 * before trying any recovery commands.
-			 */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to offline device\n");
-			ret = BLKPREP_KILL;
-			break;
-		case SDEV_DEL:
-			/*
-			 * If the device is fully deleted, we refuse to
-			 * process any commands as well.
-			 */
+		/* OK, we're not in a running state don't prep
+		 * user commands */
+		if (sdev->sdev_state == SDEV_DEL) {
+			/* Device is fully deleted, no commands
+			 * at all allowed down */
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to dead device\n");
-			ret = BLKPREP_KILL;
-			break;
-		case SDEV_QUIESCE:
-		case SDEV_BLOCK:
-			/*
-			 * If the devices is blocked we defer normal commands.
-			 */
-			if (!(req->cmd_flags & REQ_PREEMPT))
-				ret = BLKPREP_DEFER;
-			break;
-		default:
-			/*
-			 * For any other not fully online state we only allow
-			 * special commands.  In particular any user initiated
-			 * command is not allowed.
-			 */
-			if (!(req->cmd_flags & REQ_PREEMPT))
-				ret = BLKPREP_KILL;
-			break;
+			goto kill;
 		}
-
-		if (ret != BLKPREP_OK)
-			goto out;
+		/* OK, we only allow special commands (i.e. not
+		 * user initiated ones */
+		specials_only = sdev->sdev_state;
 	}
 
-	switch (req->cmd_type) {
-	case REQ_TYPE_BLOCK_PC:
-		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-		break;
-	case REQ_TYPE_FS:
-		ret = scsi_setup_fs_cmnd(sdev, req);
-		break;
-	default:
+	/*
+	 * Find the actual device driver associated with this command.
+	 * The SPECIAL requests are things like character device or
+	 * ioctls, which did not originate from ll_rw_blk.  Note that
+	 * the special field is also used to indicate the cmd for
+	 * the remainder of a partially fulfilled request that can 
+	 * come up when there is a medium error.  We have to treat
+	 * these two cases differently.  We differentiate by looking
+	 * at request->cmd, as this tells us the real story.
+	 */
+	if (blk_special_request(req) && req->special)
+		cmd = req->special;
+	else if (blk_pc_request(req) || blk_fs_request(req)) {
+		if (unlikely(specials_only) && !(req->cmd_flags & REQ_PREEMPT)){
+			if (specials_only == SDEV_QUIESCE ||
+			    specials_only == SDEV_BLOCK)
+				goto defer;
+			
+			sdev_printk(KERN_ERR, sdev,
+				    "rejecting I/O to device being removed\n");
+			goto kill;
+		}
+			
 		/*
-		 * All other command types are not supported.
-		 *
-		 * Note that these days the SCSI subsystem does not use
-		 * REQ_TYPE_SPECIAL requests anymore.  These are only used
-		 * (directly or via blk_insert_request) by non-SCSI drivers.
+		 * Now try and find a command block that we can use.
 		 */
+		if (!req->special) {
+			cmd = scsi_get_command(sdev, GFP_ATOMIC);
+			if (unlikely(!cmd))
+				goto defer;
+		} else
+			cmd = req->special;
+		
+		/* pull a tag out of the request if we have one */
+		cmd->tag = req->tag;
+	} else {
 		blk_dump_rq_flags(req, "SCSI bad req");
-		ret = BLKPREP_KILL;
-		break;
+		goto kill;
 	}
+	
+	/* note the overloading of req->special.  When the tag
+	 * is active it always means cmd.  If the tag goes
+	 * back for re-queueing, it may be reset */
+	req->special = cmd;
+	cmd->request = req;
+	
+	/*
+	 * FIXME: drop the lock here because the functions below
+	 * expect to be called without the queue lock held.  Also,
+	 * previously, we dequeued the request before dropping the
+	 * lock.  We hope REQ_STARTED prevents anything untoward from
+	 * happening now.
+	 */
+	if (blk_fs_request(req) || blk_pc_request(req)) {
+		int ret;
 
- out:
-	switch (ret) {
-	case BLKPREP_KILL:
-		req->errors = DID_NO_CONNECT << 16;
-		break;
-	case BLKPREP_DEFER:
 		/*
-		 * If we defer, the elv_next_request() returns NULL, but the
-		 * queue must be restarted, so we plug here if no returning
-		 * command will automatically do that.
+		 * This will do a couple of things:
+		 *  1) Fill in the actual SCSI command.
+		 *  2) Fill in any other upper-level specific fields
+		 * (timeout).
+		 *
+		 * If this returns 0, it means that the request failed
+		 * (reading past end of disk, reading offline device,
+		 * etc).   This won't actually talk to the device, but
+		 * some kinds of consistency checking may cause the	
+		 * request to be rejected immediately.
 		 */
-		if (sdev->device_busy == 0)
-			blk_plug_device(q);
-		break;
-	default:
-		req->cmd_flags |= REQ_DONTPREP;
+
+		/* 
+		 * This sets up the scatter-gather table (allocating if
+		 * required).
+		 */
+		ret = scsi_init_io(cmd);
+		switch(ret) {
+			/* For BLKPREP_KILL/DEFER the cmd was released */
+		case BLKPREP_KILL:
+			goto kill;
+		case BLKPREP_DEFER:
+			goto defer;
+		}
+		
+		/*
+		 * Initialize the actual SCSI command for this request.
+		 */
+		if (blk_pc_request(req)) {
+			scsi_setup_blk_pc_cmnd(cmd);
+		} else if (req->rq_disk) {
+			struct scsi_driver *drv;
+
+			drv = *(struct scsi_driver **)req->rq_disk->private_data;
+			if (unlikely(!drv->init_command(cmd))) {
+				scsi_release_buffers(cmd);
+				scsi_put_command(cmd);
+				goto kill;
+			}
+		}
 	}
 
-	return ret;
+	/*
+	 * The request is now prepped, no need to come back here
+	 */
+	req->cmd_flags |= REQ_DONTPREP;
+	return BLKPREP_OK;
+
+ defer:
+	/* If we defer, the elv_next_request() returns NULL, but the
+	 * queue must be restarted, so we plug here if no returning
+	 * command will automatically do that. */
+	if (sdev->device_busy == 0)
+		blk_plug_device(q);
+	return BLKPREP_DEFER;
+ kill:
+	req->errors = DID_NO_CONNECT << 16;
+	return BLKPREP_KILL;
 }
 
 /*

--aT9PWwzfKXlsBJM1--
