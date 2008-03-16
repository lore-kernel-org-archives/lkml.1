Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYCPTpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYCPTpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCPTpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:45:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:43221 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYCPTpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=nN/FNWv0yrdFGLOwtP08OdGOkGk/zj3xGY3FoTTAjUi9YHrqWaYlBxwECkmmKHp8KTdFPpFwEUe+NvVNYzkDjBGJVZLbmX55R2QvhQN2aFW/Wz9qUVPqmIslOSGLjaHhqHBupTeIePSmdgMVJwnQVBSlFMVmvZ15sReiROi/joA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 20:54:04 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803162054.04757.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Linus Torvalds wrote:
> 
> On Sun, 16 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > 
> > We don't do error handling for special commands (REQ_TYPE_ATA_*) at all,
> > ide_error() just dumps device's status/error register(s) and finishes early:
> 
> Well that sounds bogus too, for all the same reasons already outlined. The 
> DRQ flag needs to be cleared up on error!

OK, lets try it.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: correctly handle DRQ bit set on error also for special requests

commit 4d977e43d8ae758434e603cf2455d955f71c77c4 ("ide: check BUSY and ERROR 
status bits before reading data in drive_cmd_intr()") changed DRQ handling
logic (as pointed out by Linus).

Fix it by flushing leftover data for commands using PIO-in protocol
and special requests (rq->cmd_type == REQ_TYPE_ATA_TASKFILE).

Cc: Anders Eriksson <aeriksson@fastmail.fm>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against 2.6.25-rc5, untested

 drivers/ide/ide-io.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -540,12 +540,19 @@ EXPORT_SYMBOL_GPL(__ide_error);
  
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
 {
-	struct request *rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
 	u8 err;
 
+	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+		if (hwif->data_phase == TASKFILE_IN && (stat & DRQ_STAT) &&
+		    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
+			try_to_flush_leftover_data(drive);
+	}
+
 	err = ide_dump_status(drive, msg, stat);
 
-	if ((rq = HWGROUP(drive)->rq) == NULL)
+	if (rq == NULL)
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
