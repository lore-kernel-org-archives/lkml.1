Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYCPROB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYCPROB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 13:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYCPRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 13:13:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYCPRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 13:13:54 -0400
Date: Sun, 16 Mar 2008 10:13:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803160958260.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <200803101410.27877.rjw@sisk.pl> <200803101504.17219.bzolnier@gmail.com> <20080316140118.891732DC044@tippex.mynet.homeunix.org>
 <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Linus Torvalds wrote:
> 
>  - there's a totally untested patch at the end here that tries to make the 
>    error handling do that DRQ flush unconditionally. Does it make a 
>    difference for you?

Ok, it's not going to make any difference, because that 
IDE_HFLAG_ERROR_STOPS_FIFO flag won't be set for you anyway.

So assuming it's about a pending DRQ issue that needs to be flushed before 
the controller will generate any more interrupts (which your bisect 
implies it is), maybe we have one of

 - this ide_ata_error() case isn't called at all.

   This happens for at least WIN_SPECIFY (see ide_ata_error() - it 
   returns early)

   Could you add a printk() to ide_ata_error() and see if it gets called 
   when your machine hangs, and if so, what the case was.

 - try_to_flush_leftover_data() doesn't work (it does have a test for only 
   acting on disk drives - is this perhaps a CD-ROM?)

 - or rq_data_dir(rq) is wrong for the offending command (again, maybe 
   the printk() could help with that).

IOW, try something like this instead of the previous patch.

		Linus

---
 drivers/ide/ide-io.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7153796..6a98937 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -414,6 +414,7 @@ static void try_to_flush_leftover_data (ide_drive_t *drive)
 {
 	int i = (drive->mult_count ? drive->mult_count : 1) * SECTOR_WORDS;
 
+printk("try_to_flush(%d,%d)\n", i, drive->media == ide_disk);
 	if (drive->media != ide_disk)
 		return;
 	while (i > 0) {
@@ -440,7 +441,10 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (stat & BUSY_STAT || ((stat & WRERR_STAT) && !drive->nowerr)) {
+printk("ide_ata_error() stat=%02x err=%02x dir=%d CMD=%02x\n",
+	stat, err, rq_data_dir(rq), hwif->INB(IDE_COMMAND_REG));
+
+	if ((stat & BUSY_STAT) || ((stat & WRERR_STAT) && !drive->nowerr)) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else if (stat & ERR_STAT) {
@@ -462,8 +466,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		}
 	}
 
-	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
-	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
+	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ)
 		try_to_flush_leftover_data(drive);
 
 	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
