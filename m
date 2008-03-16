Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYCPQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYCPQ5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYCPQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:57:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYCPQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:57:30 -0400
Date: Sun, 16 Mar 2008 09:56:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080316140118.891732DC044@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <200803101410.27877.rjw@sisk.pl> <200803101504.17219.bzolnier@gmail.com> <20080316140118.891732DC044@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Anders Eriksson wrote:
> 
> Many bisects later, now with taking care of making 'make oldconfig' off a 
> known good config for each iteration, and doing 10 reboots and 5 smartd 
> invocations for each version deemed good (not that anyone failed midway).

Ok, this is interesting. It's clearly a regression, so we need to undo it. 
However, it's not trivial to revert, since lots of things have changed 
around that area since.

In particular, commit 7267c3377443322588cddaf457cf106839a60463 ("ide: 
remove REQ_TYPE_ATA_CMD") ended up removing the whole drive_cmd_intr() 
function, because now all the commands are handled with the
REQ_TYPE_ATA_TASKFILE model instead, which uses a whole another path.

And quite frankly, I think the commit you bisected to really is very 
broken. It starts doing error handling *before* it has handled the DRQ 
bit, and that's bogus, since iirc a lot of controllers need to have their 
DRQ issues satisfied before anything else.

So what probably happens is that yes, you get an error, but the IDE drive 
still wants the code to flush the data it generated, and if we don't do 
that, it will never do anything else ever again. Resulting in a hang.

So Anders, can you try these two silly things:

 - there's a totally untested patch at the end here that tries to make the 
   error handling do that DRQ flush unconditionally. Does it make a 
   difference for you?

 - did you already try if ata_piix fixes it? 

but I do think that the commit you bisected is crap, crap, crap.

Bartlomiej?

		Linus
---
 drivers/ide/ide-io.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7153796..9105c09 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -462,8 +462,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8
 		}
 	}
 
-	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ &&
-	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0)
+	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ)
 		try_to_flush_leftover_data(drive);
 
 	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
