Return-Path: <linux-kernel-owner+w=401wt.eu-S935729AbXGRUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935729AbXGRUDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbXGRUDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:03:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096AbXGRUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:03:05 -0400
Date: Wed, 18 Jul 2007 12:57:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <200707172320.12141.bzolnier@gmail.com>
Message-ID: <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net>
 <200707172320.12141.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> On Tuesday 17 July 2007, Giacomo Catenazzi wrote:
> > 
> > last git changes to git give me the following error (repead very quickly):
> > 
> > sector 14657019, nr/cmr 0/0
> > bio f7b59280, biotail f7b59280, buffer 0000000, date 0000000, len 36
> > ide_do_rw_disk-bad command: dev hda: type 2, flags 104c8
> 
> ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well

Hmm. I started wondering about this. 

Sure, ide-disk doesn't like non-fs requests, but I'm wondering why the 
error apparently keeps repeating? We should error out once, and that 
should be it.

So I'm wondering whether the

	ide_end_request(drive, 0, 0);
	return ide_stopped;

is the real bug.

The thing is, non-fs requests won't have nr_sectors set, so the 0 will 
stay as a zero (the IDE layer has some "turn zero into current sector 
number", but that doesn't work for commands that aren't sector-based!), 
and as a result, we'll "complete" zero bytes, and the bio will stay 
active!

So the code should probably at the _least_ say that it's finished one 
whole sector, and it would probably be much better to make it be based on 
"rq->data_len", which should be reliable.

Of course, since the "ide_end_request()" takes the data in sectors, but 
the request layer does it in bytes, we have to round the thing up and the 
ide_end_request() thing will turn it into too many bytes, but that's ok - 
"end_that_request_first()" doesn't care if we complete "too many" bytes.

So a diff something like this is, I think, the right thing to do, and 
should make the IDE disk driver handle non-fs requests gracefully (it will 
*fail* them, of course, but that's another issue).

Bartlomiej? Am I missing soemthing?

		Linus

---
 drivers/ide/ide-disk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index b1304a7..fde2f79 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -311,8 +311,9 @@ static ide_startstop_t ide_do_rw_disk (ide_drive_t *drive, struct request *rq, s
 	BUG_ON(drive->blocked);
 
 	if (!blk_fs_request(rq)) {
+		int nsectors = (rq->data_len + 511) >> 9;
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
-		ide_end_request(drive, 0, 0);
+		ide_end_request(drive, 0, nsectors);
 		return ide_stopped;
 	}
 
