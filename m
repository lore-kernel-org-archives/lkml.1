Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXLCXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXLCXNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLCXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:13:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXLCXNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:13:22 -0500
Date: Mon, 03 Dec 2007 18:12:52 -0500 (EST)
Message-Id: <20071203.181252.58460084.k-ueda@ct.jp.nec.com>
To: bzolnier@gmail.com
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 24/28] blk_end_request: changing ide normal caller
 (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <200712012353.05187.bzolnier@gmail.com>
References: <20071130.183358.35360061.k-ueda@ct.jp.nec.com>
	<200712012353.05187.bzolnier@gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Sat, 1 Dec 2007 23:53:05 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> > This patch converts "normal" parts of ide to use blk_end_request().
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > ---
> >  drivers/ide/ide-cd.c |    6 +++---
> >  drivers/ide/ide-io.c |   17 ++++++-----------
> >  2 files changed, 9 insertions(+), 14 deletions(-)
> 
> [...]
> 
> > Index: 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> > ===================================================================
> > --- 2.6.24-rc3-mm2.orig/drivers/ide/ide-io.c
> > +++ 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> > @@ -78,14 +78,9 @@ static int __ide_end_request(ide_drive_t
> >  		ide_dma_on(drive);
> >  	}
> >  
> > -	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
> > -		add_disk_randomness(rq->rq_disk);
> > -		if (dequeue) {
> > -			if (!list_empty(&rq->queuelist))
> > -				blkdev_dequeue_request(rq);
> > +	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
> > +		if (dequeue)
> >  			HWGROUP(drive)->rq = NULL;
> > -		}
> > -		end_that_request_last(rq, uptodate);
> >  		ret = 0;
> >  	}
> 
> Hmmm, this seems to change the old behavior (the request should
> be dequeued from the queue only if 'dequeue' variable is set)
> and AFAIR some error handling code (in ide-cd?) depends on the
> old behavior so please revisit this patch.

blk_end_request() takes care of the dequeue like below,
so I think no problem.  (Please see PATCH 01)

> +	/* rq->queuelist of dequeued request should be list_empty() */
> +	if (!list_empty(&rq->queuelist))
> +		blkdev_dequeue_request(rq);

In the case of ide-cd,
  o 'dequeue' variable is 1 only when the request is still linked
    to the queue (i.e. rq->queuelist is not empty)
  o 'dequeue' variable is 0 only when the request has already been
    removed from the queue (i.e. rq->queuelist is empty)
So blk_end_request() can handle it correctly.


If there are any drivers which don't want dequeue the queued request,
the code above would not work.
But, as far as I investigated, I have never seen such a requirement
in device drivers.

Do you think that ide may still gets a problem for the 'dequeue'?

Thanks,
Kiyoshi Ueda
