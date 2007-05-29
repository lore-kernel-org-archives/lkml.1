Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXE2E0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXE2E0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXE2E0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:26:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbXE2E0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:26:42 -0400
From: Neil Brown <neilb@suse.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Tue, 29 May 2007 14:26:23 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18011.43887.825594.407340@notabene.brown>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Subject: Re: Block devices and barriers
In-Reply-To: message from Geert Uytterhoeven on Monday May 21
References: <Pine.LNX.4.62.0705211434150.8776@pademelon.sonytel.be>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 21, Geert.Uytterhoeven@sonycom.com wrote:
> 	Hi,
> 
> I'm adding cache flush support to the PS3 disk driver and have a few questions
> related to barriers.
> 
> In my driver, I do:
> 
>     blk_queue_issue_flush_fn(queue, ps3disk_issue_flush);
>     blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH, ps3disk_prepare_flush);
> 
> but I can't find a way to actually trigger the calling of ps3disk_issue_flush()
> and ps3disk_prepare_flush().
> 
>  1. My prepare_flush_fn() routine should be called from queue_flush(), which is
>     in turn called by start_ordered().
>     start_ordered() is called by blk_do_ordered(), but only if there's no
>     barrier (REQ_HARDBARRIER is not set).
>     Apart from drivers/block/pktcdvd.c and init_request_from_bio()
>     (BIO_RW_BARRIER is set by drivers/md/md.c only?), the only other way
>     REQ_HARDBARRIER can be set is in queue_flush(), which is not possible.

BIO_RW_BARRIER is set by various filesystems when mounted with
  -o barrier 
or
  -o barrier=1 (ext3)

See calls to set_buffer_ordered in fs/jbd/commit.c

> 
>   2. My issue_flush_fn() should be called from blkdev_issue_flush() (ignoring
>      drivers/md). But blkdev_issue_flush() is called by ReiserFS and XFS only.

Yeh, it isn't widely used at the moment.

> 
> I read the Block Device chapter in Linux Device Drivers 3rd edition, which says
> to check blk_barrier_rq(), but the barrier part seems to be obsolete, as we now
> have the prepare_flush_fn parameter of blk_queue_ordered().
> 
> Am I missing something? Should I care about barriers?

Yes, you should care about barriers, though it is true that there is
some confusion around them and it might be difficult.


> 
> Thanks!
> 
> BTW, Documentation/block/barrier.txt seems to be out-of-date. Patch to update
> it is below.

You might like to post this directly to
  Tejun Heo <htejun@gmail.com>

NeilBrown

> 
> ---
> 
> Documentation/block/barrier.txt is not in sync with the actual code:
>   - blk_queue_ordered() no longer has a gfp_mask parameter
>   - blk_queue_ordered_locked() no longer exists
>   - sd_prepare_flush() looks slightly different
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> --- a/Documentation/block/barrier.txt
> +++ b/Documentation/block/barrier.txt
> @@ -82,23 +82,12 @@ including draining and flushing.
>  typedef void (prepare_flush_fn)(request_queue_t *q, struct request *rq);
>  
>  int blk_queue_ordered(request_queue_t *q, unsigned ordered,
> -		      prepare_flush_fn *prepare_flush_fn,
> -		      unsigned gfp_mask);
> -
> -int blk_queue_ordered_locked(request_queue_t *q, unsigned ordered,
> -			     prepare_flush_fn *prepare_flush_fn,
> -			     unsigned gfp_mask);
> -
> -The only difference between the two functions is whether or not the
> -caller is holding q->queue_lock on entry.  The latter expects the
> -caller is holding the lock.
> +		      prepare_flush_fn *prepare_flush_fn);
>  
>  @q			: the queue in question
>  @ordered		: the ordered mode the driver/device supports
>  @prepare_flush_fn	: this function should prepare @rq such that it
>  			  flushes cache to physical medium when executed
> -@gfp_mask		: gfp_mask used when allocating data structures
> -			  for ordered processing
>  
>  For example, SCSI disk driver's prepare_flush_fn looks like the
>  following.
> @@ -106,9 +95,10 @@ following.
>  static void sd_prepare_flush(request_queue_t *q, struct request *rq)
>  {
>  	memset(rq->cmd, 0, sizeof(rq->cmd));
> -	rq->flags |= REQ_BLOCK_PC;
> +	rq->cmd_type = REQ_TYPE_BLOCK_PC;
>  	rq->timeout = SD_TIMEOUT;
>  	rq->cmd[0] = SYNCHRONIZE_CACHE;
> +	rq->cmd_len = 10;
>  }
>  
>  The following seven ordered modes are supported.  The following table
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
> Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
> Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
