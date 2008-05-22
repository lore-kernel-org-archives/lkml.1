Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbYEVHoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbYEVHoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYEVHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:43:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:6581 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbYEVHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=FPXxoGGrdjaZjJSlGRaQyzFyjTGgBhfnfi5ZxmDXLFZ4kIbzstVK9Dc8NwIoLngLolttzsYXbf/8v/uT95rXRzsrQQ16YOHih65TkOEZegkdZoulRozxdPWQRvUdyXM4a6/odzqIINctJDZc6TaNFINUuETBznHL0cR0ZN+W//8=
Date: Thu, 22 May 2008 09:43:54 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/40] ide: generic ATAPI support
Message-ID: <20080522074354.GB2414@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 08:54:28PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> This patch series unifies ATAPI support present in ide-{floppy,tape,scsi}
> device drivers and moves it out to the core IDE code (new ide-atapi.c file).
> 
> In the process many bugs were shaken out and ~300 LOC were removed.
> 
> diffstat:
> 
>  drivers/ide/Kconfig      |    6 
>  drivers/ide/Makefile     |    1 
>  drivers/ide/ide-atapi.c  |  296 ++++++++++++++++++++++
>  drivers/ide/ide-cd.c     |    5 
>  drivers/ide/ide-floppy.c |  431 +++++++-------------------------
>  drivers/ide/ide-tape.c   |  630 ++++++++++++++---------------------------------
>  drivers/scsi/ide-scsi.c  |  455 +++++++++++----------------------
>  include/linux/ide.h      |   28 +-
>  8 files changed, 777 insertions(+), 1075 deletions(-)
> 
> Now, while this is a big step in the right direction there are still some
> things left on TODO for generic ATAPI support to be complete:
> 
> - convert ide-cd to use generic ATAPI code
> 
> - kill pc and rq stacks in ide-{floppy,tape}
> 
> - generic handling of REQUEST SENSE command
> 
> - generic handling of MODE SENSE command for ide-{floppy,tape}
> 
> - convert ide-{cd,floppy,tape} to use scatterlists for PIO transers
>   (ala ide-scsi)
> 
> I know that Borislav is working on the first two items but other ones
> are free at the moment so if you feel brave you may give it a try :-).
> 
> PS I'll be travelling during this weekend and be rather busy with day job
>    so replies from me may be delayed a bit.

Hi Bart,

yep, these all look real good, makes all drivers really lightweight. Looks like
ide-cd will follow not too far behind. By the way, here's another one you count apply ontop:

From: Borislav Petkov <petkovbb@gmail.com>
Date: Thu, 22 May 2008 09:36:53 +0200
Subject: [PATCH] ide-tape: unify idetape_create_read/write_cmd

A straightforward one. There should be no functional change resulting from this
change.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   47 ++++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0afa109..da08a6a 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -952,40 +952,31 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc,
-		unsigned int length, struct idetape_bh *bh)
+static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc, unsigned int length,
+		struct idetape_bh *bh, int opcode)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = READ_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->bh = bh;
-	atomic_set(&bh->b_count, 0);
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
 	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_OK;
-}
 
-static void idetape_create_write_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc,
-		unsigned int length, struct idetape_bh *bh)
-{
-	idetape_init_pc(pc);
-	pc->c[0] = WRITE_6;
-	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
-	pc->c[1] = 1;
-	pc->flags |= PC_FLAG_WRITING;
-	pc->bh = bh;
-	pc->b_data = bh->b_data;
-	pc->b_count = atomic_read(&bh->b_count);
-	pc->buf = NULL;
-	pc->buf_size = length * tape->blk_size;
-	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->buffer_size)
-		pc->flags |= PC_FLAG_DMA_OK;
+	if (opcode == READ_6) {
+		pc->c[0] = READ_6;
+		atomic_set(&bh->b_count, 0);
+	}
+	else if (opcode == WRITE_6) {
+		pc->c[0] = WRITE_6;
+		pc->flags |= PC_FLAG_WRITING;
+		pc->b_data = bh->b_data;
+		pc->b_count = atomic_read(&bh->b_count);
+	} else
+		printk(KERN_ERR "%s: Invalid opcode: 0x%x\n", __func__, opcode);
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -1062,14 +1053,16 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
-					(struct idetape_bh *)rq->special);
+		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
+					(struct idetape_bh *)rq->special,
+					READ_6);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		pc = idetape_next_pc_storage(drive);
-		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
-					 (struct idetape_bh *)rq->special);
+		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
+					 (struct idetape_bh *)rq->special,
+					 WRITE_6);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
-- 
1.5.5.1

-- 
Regards/Gruﬂ,
    Boris.
