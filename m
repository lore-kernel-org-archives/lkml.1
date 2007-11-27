Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXK0U6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXK0U6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbXK0U5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:57:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:23124 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbXK0U5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hXN+eNmRznTHBcYFnM8+hZ7wghQJ02pkKU/3z3IqEaxueLebJ+9sHmfgkDznqsmTD4gHuG0yVyaJy0JmI++KdrhPpofk1mrCxz+AjPGnhyp8+Px7bP1mJIJdAn3NKGbuDGVa3h71wnZs1v7m6/v+QMReW71huKo5Fn+cAOY/P60=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
Date: Tue, 27 Nov 2007 22:02:37 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Denis Cheng <crquan@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <1196061373-6394-1-git-send-email-crquan@gmail.com> <20071127013119.d12b7791.akpm@linux-foundation.org> <200711272134.18527.bzolnier@gmail.com>
In-Reply-To: <200711272134.18527.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711272202.37410.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 27 November 2007, Andrew Morton wrote:
> > On Mon, 26 Nov 2007 15:16:13 +0800 Denis Cheng <crquan@gmail.com> wrote:
> > 
> > > these utilities implemented in lib/hexdump.c are more handy, please use this.
> > > 
> > > ...
> > >
> > > --- a/drivers/scsi/ide-scsi.c
> > > +++ b/drivers/scsi/ide-scsi.c
> > > @@ -242,16 +242,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
> > >  	}
> > >  }
> > >  
> > > -static void hexdump(u8 *x, int len)
> > > -{
> > > -	int i;
> > > -
> > > -	printk("[ ");
> > > -	for (i = 0; i < len; i++)
> > > -		printk("%x ", x[i]);
> > > -	printk("]\n");
> > > -}
> > > -
> > >  static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
> > >  {
> > >  	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
> > > @@ -282,7 +272,7 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
> > >  	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
> > >  	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
> > >  		printk ("ide-scsi: %s: queue cmd = ", drive->name);
> > > -		hexdump(pc->c, 6);
> > > +		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 6, 1);
> > >  	}
> > >  	rq->rq_disk = scsi->disk;
> > >  	return ide_do_drive_cmd(drive, rq, ide_preempt);
> > > @@ -337,7 +327,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
> > >  		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
> > >  		if (log) {
> > >  			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, 
> opc->scsi_cmd->serial_number);
> > > -			hexdump(pc->buffer,16);
> > > +			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->buffer, 16, 1);
> > >  		}
> > >  		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
> > >  		kfree(pc->buffer);
> > > @@ -816,10 +806,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
> > >  
> > >  	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
> > >  		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
> > > -		hexdump(cmd->cmnd, cmd->cmd_len);
> > > +		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, cmd->cmnd, cmd->cmd_len, 1);
> > >  		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
> > >  			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
> > > -			hexdump(pc->c, 12);
> > > +			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 12, 1);
> > >  		}
> > >  	}
> > >  
> 
> I applied the patch with a couple of fixes:
> - s/KERN_DEBUG/KERN_CONT/ as pointed out by Randy
> - s/DUMP_PREFIX_OFFSET/DUMP_PREFIX_NONE/
> - don't include ASCII dump
> - respect 80-columns limit
> 
> > Would you believe that this patch (which removes code) actually increases
> > drivers/scsi/ide-scsi.o .text by 75 bytes?
> 
> Yeah, it somehow shrank down to +58 bytes after fixes but this is still bad.

Heh, incremental (since I pushed the previous one to Linus already)
patch which cuts 85 bytes from ide-scsi...

[PATCH] ide-scsi: add ide_scsi_hex_dump() helper

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Cheng <crquan@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -242,6 +242,11 @@ static void idescsi_output_buffers (ide_
 	}
 }
 
+static void ide_scsi_hex_dump(u8 *data, int len)
+{
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
+}
+
 static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -272,8 +277,7 @@ static int idescsi_check_condition(ide_d
 	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, pc->c,
-			       6, 0);
+		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
@@ -328,8 +332,7 @@ static int idescsi_end_request (ide_driv
 		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, 
opc->scsi_cmd->serial_number);
-			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-				       pc->buffer, 16, 0);
+			ide_scsi_hex_dump(pc->buffer, 16);
 		}
 		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buffer);
@@ -808,12 +811,10 @@ static int idescsi_queue (struct scsi_cm
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-			       cmd->cmnd, cmd->cmd_len, 0);
+		ide_scsi_hex_dump(cmd->cmnd, cmd->cmd_len);
 		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
 			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
-			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-				       pc->c, 12, 0);
+			ide_scsi_hex_dump(pc->c, 12);
 		}
 	}
 
