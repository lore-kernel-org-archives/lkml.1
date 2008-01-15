Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYAOUO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYAOUO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYAOUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:14:17 -0500
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:33613 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752262AbYAOUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:14:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=tKSEm+/4AL+xJvhskERqnb5TEelNLzOxQfkvZNWtIM/vIgyUWKWLDu+DgFh2Dsx9sSkwg/IgWQnpY5IVT0Jbmn/h29uw7FmjOXSyzCFnGmRjjG4paxTDTr1JcTPLi8TJKcV0SLrpw35lI+ZhGQZd4O+bmn0QkHrGEKW2rYyDXQY=  ;
X-YMail-OSG: G19.daMVM1kqQFY_wmYljniAZ9BoqtoFODSFwwgT8.4Na5v4c.XrcnKWju8usyo82oeCCm7z4w--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Jan 2008 21:10:32 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Message-ID: <20080115201032.GB5699@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-10-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de> <200801142250.58201.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801142250.58201.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:50:58PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 13 January 2008, Borislav Petkov wrote:
> > ..and replace them with flag enums.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > ---
> >  drivers/ide/ide-floppy.c |  132 +++++++++++++++++++++++++--------------------
> >  1 files changed, 73 insertions(+), 59 deletions(-)
> 
> [...]
> 
> > @@ -506,14 +516,14 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  
> >  	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
> >  
> > -	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
> > +	if (PC_FLAG_DMA_IN_PROGRESS & pc->flags) {
> 
> the usual kernel convention is to put flag last, i.e.
> 
> pc->flags & PC_FLAG_DMA_IN_PROGRESS
> 
> [...]
> 
> > @@ -570,7 +581,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
> >  		return ide_do_reset(drive);
> >  	}
> > -	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
> > +	if (((ireason & IO) == IO) == (PC_FLAG_WRITING  & pc->flags)) {
> 
> - test_bit() returns 1 or 0 (=> boolean)
> - (pc->flags & PC_FLAG_WRITING) is 0x10 or 0
> 
> so the above comparison will fail
> 
> > @@ -607,7 +618,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  		xferfunc(drive, pc->current_position, bcount);
> >  	else
> >  		ide_floppy_io_buffers(drive, pc, bcount,
> > -				test_bit(PC_WRITING, &pc->flags));
> > +				(PC_FLAG_WRITING & pc->flags));
> 
> ditto, this may actually work but '(pc->flags & PC_FLAG_WRITING) ? 1 : 0'
> would be much safer from maintainability POV
> 
> [...]
> 
> > @@ -1720,13 +1731,16 @@ static int idefloppy_media_changed(struct gendisk *disk)
> >  {
> >  	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
> >  	ide_drive_t *drive = floppy->drive;
> > +	int ret;
> >  
> >  	/* do not scan partitions twice if this is a removable device */
> >  	if (drive->attach) {
> >  		drive->attach = 0;
> >  		return 0;
> >  	}
> > -	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
> > +	ret = IDEFLOPPY_FLAG_MEDIA_CHANGED & floppy->flags;
> > +	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
> > +	return ret;
> >  }
> 
> same issue
> 
> otherwise looks good, please fix/resubmit
> (together with patch #12)

.. this is the second one...


From: Borislav Petkov <bbpetkov@yahoo.de>
Date: Tue, 15 Jan 2008 20:49:18 +0100
Subject: [PATCH 16/18] ide-floppy: remove atomic test_*bit macros

..and replace them with flag enums.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

:100644 100644 8e9063f... 8a4791d... M	drivers/ide/ide-floppy.c

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8e9063f..8a4791d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -107,15 +107,19 @@ typedef struct idefloppy_packet_command_s {
 	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
 } idefloppy_pc_t;
 
-/*
- *	Packet command flag bits.
- */
-#define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA if possible */
-#define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
-#define	PC_DMA_ERROR			4	/* 1 when encountered problem during DMA */
-#define	PC_WRITING			5	/* Data direction */
-
-#define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
+/* Packet command flag bits. */
+enum {
+	/* 1 when we prefer to use DMA if possible */
+	PC_FLAG_DMA_RECOMMENDED	= (1 << 0),
+	/* 1 while DMA in progress */
+	PC_FLAG_DMA_IN_PROGRESS	= (1 << 1),
+	/* 1 when encountered problem during DMA */
+	PC_FLAG_DMA_ERROR	= (1 << 2),
+	/* Data direction */
+	PC_FLAG_WRITING		= (1 << 3),
+	/* Suppress error reporting */
+	PC_FLAG_SUPPRESS_ERROR	= (1 << 4),
+};
 
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
@@ -174,14 +178,19 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/*
- *	Floppy flag bits values.
- */
-#define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
-#define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
-#define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
-#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported in Clik drive */
-#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
+/* Floppy flag bits values. */
+enum {
+	/* DRQ interrupt device */
+	IDEFLOPPY_FLAG_DRQ_INTERRUPT		= (1 <<	0),
+	/* Media may have changed */
+	IDEFLOPPY_FLAG_MEDIA_CHANGED		= (1 << 1),
+	/* Format in progress */
+	IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS	= (1 << 2),
+	/* Avoid commands not supported in Clik drive */
+	IDEFLOPPY_FLAG_CLIK_DRIVE		= (1 << 3),
+	/* Requires BH algorithm for packets */
+	IDEFLOPPY_FLAG_ZIP_DRIVE		= (1 << 4),
+};
 
 /*
  *	Defines for the mode sense command
@@ -505,14 +514,14 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n",
 				drive->name,
 				rq_data_dir(rq) == WRITE ? "write" :"read");
 
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
@@ -526,11 +535,11 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	if ((stat & DRQ_STAT) == 0) {		/* No more interrupts */
 		debug_log("Packet command completed, %d bytes transferred\n",
 				pc->actually_transferred);
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
 		local_irq_enable_in_hardirq();
 
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("I/O error\n", drive->name);
 			rq->errors++;
@@ -552,7 +561,8 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-floppy: The floppy wants to issue "
 			"more interrupts in DMA mode\n");
 		ide_dma_off(drive);
@@ -569,7 +579,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -577,7 +587,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
@@ -597,7 +607,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 					" expected - allowing transfer\n");
 		}
 	}
-	if (test_bit(PC_WRITING, &pc->flags))
+	if (pc->flags & PC_FLAG_WRITING)
 		xferfunc = hwif->atapi_output_bytes;
 	else
 		xferfunc = hwif->atapi_input_bytes;
@@ -606,7 +616,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		xferfunc(drive, pc->current_position, bcount);
 	else
 		ide_floppy_io_buffers(drive, pc, bcount,
-				test_bit(PC_WRITING, &pc->flags));
+				!!(pc->flags & PC_FLAG_WRITING));
 
 	/* Update the current position */
 	pc->actually_transferred += bcount;
@@ -737,7 +747,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	floppy->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
-		if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags))
+		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
 		/* Giving up */
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
@@ -755,24 +765,25 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	pc->current_position = pc->buffer;
 	bcount = min(pc->request_transfer, 63 * 1024);
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags))
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
 		ide_dma_off(drive);
-
+	}
 	dma = 0;
 
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
 	if (dma) {	/* Begin DMA, if necessary */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (test_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags)) {
+	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
 		/* wait */
 		pkt_xfer_routine = &idefloppy_transfer_pc1;
 	} else {
@@ -780,7 +791,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 	
-	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -838,7 +849,7 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
 	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
 	pc->buffer_size=12;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->flags |= PC_FLAG_WRITING;
 }
 
 /*
@@ -900,10 +911,10 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 	pc->buffer = NULL;
 	pc->request_transfer = pc->buffer_size = blocks * floppy->block_size;
-	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+	pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static void
@@ -915,11 +926,10 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 	pc->buffer = rq->data;
 	if (rq->bio)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
-		
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
@@ -1060,7 +1070,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
 						 MODE_SENSE_CURRENT);
 
-	set_bit(PC_SUPPRESS_ERROR, &pc.flags);
+	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
 	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
 
@@ -1113,7 +1123,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buffer[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
+			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
                                 /*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -1159,7 +1169,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
+	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
@@ -1393,7 +1403,7 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
 	if (gcw.drq_type == 1)
-		set_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
 	/*
 	 *	We used to check revisions here. At this point however
 	 *	I'm giving up. Just assume they are all broken, its easier.
@@ -1406,7 +1416,7 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 */
 
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
-		set_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
@@ -1419,7 +1429,7 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	*/
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
-		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_CLIK_DRIVE;
 	}
 
 
@@ -1509,7 +1519,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
 		idefloppy_create_test_unit_ready_cmd(&pc);
@@ -1534,14 +1544,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
-		set_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (test_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags)) {
+	} else if (floppy->flags & IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1564,12 +1574,12 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 	}
 
 	floppy->openers--;
@@ -1598,7 +1608,7 @@ static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
 
 	/* The IOMEGA Clik! Drive doesn't support this command -
 	 * no room for an eject mechanism */
-	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
 		int prevent = arg ? 1 : 0;
 
 		if (cmd == CDROMEJECT)
@@ -1624,11 +1634,11 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		return -EBUSY;
 	}
 
-	set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+	floppy->flags |= IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 
 	/*
 	 * Send ATAPI_FORMAT_UNIT to the drive.
@@ -1660,7 +1670,7 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 
 out:
 	if (err)
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 	return err;
 }
 
@@ -1713,13 +1723,16 @@ static int idefloppy_media_changed(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
+	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
 	if (drive->attach) {
 		drive->attach = 0;
 		return 0;
 	}
-	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+	ret = floppy->flags & IDEFLOPPY_FLAG_MEDIA_CHANGED;
+	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
+	return ret;
 }
 
 static int idefloppy_revalidate_disk(struct gendisk *disk)
-- 
1.5.3.7


-- 
Regards/Gruﬂ,
    Boris.
