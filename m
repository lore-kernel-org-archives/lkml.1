Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZBPTKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZBPTKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZBPTKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:10:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:28130 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZBPTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vj15rnwY60wcgr3Ks7MmQFNsUT+VL+rCw3qWHRJO3d9TwHuzj2gjAdqn4dAZjiQhYE
         XcljUU68aMDWjjJYfvRNRu0OeaEVFwVzkIl03IR9mc4kDbfdTaki14xTl3MNgATGUb04
         Oy0XUxnixgK7jlVI6VfPmSDIDP7tFvqoZGUCk=
Date: Mon, 16 Feb 2009 21:09:50 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: pavel@suse.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 12713] Hang on resume from hibernation, apparently as
	result of 213d9417fec
Message-ID: <20090216190949.GA6868@google.com>
References: <8f53421d0902151605v56c92642ib8c2dcf34fd92ad1@mail.gmail.com> <8f53421d0902151607w2985dce6yc1bef7e717166fc@mail.gmail.com> <20090216072711.GJ30821@kernel.dk> <8f53421d0902160012y219b4737u37f3cfb0913b228f@mail.gmail.com> <20090216084732.GK30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216084732.GK30821@kernel.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 09:47:32AM +0100, Jens Axboe wrote:
> On Mon, Feb 16 2009, Michael S. Tsirkin wrote:
> > On Mon, Feb 16, 2009 at 9:27 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Mon, Feb 16 2009, Michael S. Tsirkin wrote:
> > >> On Mon, Feb 16, 2009 at 2:05 AM, Michael S. Tsirkin
> > >> <m.s.tsirkin@gmail.com> wrote:
> > >> > Summary: seem to need to revert 213d9417fec62ef4c3675621b9364a667954d4dd
> > >> > to fix resume from hibernation. Bugzilla entry created:
> > >> > http://bugzilla.kernel.org/show_bug.cgi?id=12713
> > >>
> > >> Looking over this, I see something strange in the commit in question:
> > >>
> > >> diff --git a/include/linux/bio.h b/include/linux/bio.h
> > >> index 5175aa3..f53568c 100644
> > >> --- a/include/linux/bio.h
> > >> +++ b/include/linux/bio.h
> > >> @@ -163,12 +163,15 @@ struct bio {
> > >>  #define BIO_RW         0       /* Must match RW in req flags (blkdev.h) */
> > >>  #define BIO_RW_AHEAD   1       /* Must match FAILFAST in req flags */
> > >>  #define BIO_RW_BARRIER 2
> > >> -#define BIO_RW_SYNC    3
> > >> -#define BIO_RW_META    4
> > >> -#define BIO_RW_DISCARD 5
> > >> -#define BIO_RW_FAILFAST_DEV            6
> > >> -#define BIO_RW_FAILFAST_TRANSPORT      7
> > >> -#define BIO_RW_FAILFAST_DRIVER         8
> > >> +#define BIO_RW_SYNCIO  3
> > >> +#define BIO_RW_UNPLUG  4
> > >> +#define BIO_RW_META    5
> > >> +#define BIO_RW_DISCARD 6
> > >> +#define BIO_RW_FAILFAST_DEV            7
> > >> +#define BIO_RW_FAILFAST_TRANSPORT      8
> > >> +#define BIO_RW_FAILFAST_DRIVER         9
> > >> +
> > >> +#define BIO_RW_SYNC    (BIO_RW_SYNCIO | BIO_RW_UNPLUG)
> > >>
> > >>  /*
> > >>   * upper 16 bits of bi_rw define the io priority of this bio
> > >>
> > >> I haven't read the code in depth, but taking running numbers and doing
> > >> bitwise "or"
> > >> on them looks a bit strange to me.
> > >> So here BIO_RW_SYNC is (3 | 4) = 7, that is the same as BIO_RW_FAILFAST_DEV.
> > >> So for example bio_failfast_dev and bio_sync are the same.
> > >>
> > >> Jens, could you comment on this please? Is this intentional?
> > >
> > > That's clearly a braino, you can't OR the shift values of course. I'll
> > > get it fixed up asap!
> > 
> > Cool, send me a patch, I'll test.
> 
> Try this. Not a huge fan of this approach, but it should bring behaviour
> back to what it used to be.

I verified that applying this patch on top of 2.6.29-rc5 fixes
hibernation for me.

> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 39cc3bf..7cf9d1f 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -142,7 +142,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  
>  	what |= ddir_act[rw & WRITE];
>  	what |= MASK_TC_BIT(rw, BARRIER);
> -	what |= MASK_TC_BIT(rw, SYNC);
> +	what |= MASK_TC_BIT(rw, SYNCIO);
>  	what |= MASK_TC_BIT(rw, AHEAD);
>  	what |= MASK_TC_BIT(rw, META);
>  	what |= MASK_TC_BIT(rw, DISCARD);
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index a343385..f14813b 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -328,7 +328,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
>  	struct dpages old_pages = *dp;
>  
>  	if (sync)
> -		rw |= (1 << BIO_RW_SYNC);
> +		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
>  
>  	/*
>  	 * For multiple regions we need to be careful to rewind
> diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
> index 3073618..0a225da 100644
> --- a/drivers/md/dm-kcopyd.c
> +++ b/drivers/md/dm-kcopyd.c
> @@ -344,7 +344,7 @@ static int run_io_job(struct kcopyd_job *job)
>  {
>  	int r;
>  	struct dm_io_request io_req = {
> -		.bi_rw = job->rw | (1 << BIO_RW_SYNC),
> +		.bi_rw = job->rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG),
>  		.mem.type = DM_IO_PAGE_LIST,
>  		.mem.ptr.pl = job->pages,
>  		.mem.offset = job->offset,
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4495104..03b4cd0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -474,7 +474,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
>  	 * causes ENOTSUPP, we allocate a spare bio...
>  	 */
>  	struct bio *bio = bio_alloc(GFP_NOIO, 1);
> -	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNC);
> +	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNCIO) | (1<<BIO_RW_UNPLUG);
>  
>  	bio->bi_bdev = rdev->bdev;
>  	bio->bi_sector = sector;
> @@ -531,7 +531,7 @@ int sync_page_io(struct block_device *bdev, sector_t sector, int size,
>  	struct completion event;
>  	int ret;
>  
> -	rw |= (1 << BIO_RW_SYNC);
> +	rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
>  
>  	bio->bi_bdev = bdev;
>  	bio->bi_sector = sector;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 2aa283a..1b16108 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -171,8 +171,6 @@ struct bio {
>  #define BIO_RW_FAILFAST_TRANSPORT	8
>  #define BIO_RW_FAILFAST_DRIVER		9
>  
> -#define BIO_RW_SYNC	(BIO_RW_SYNCIO | BIO_RW_UNPLUG)
> -
>  #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
>  
>  /*
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index 25379cb..6e91587 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -15,6 +15,7 @@ enum blktrace_cat {
>  	BLK_TC_WRITE	= 1 << 1,	/* writes */
>  	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
>  	BLK_TC_SYNC	= 1 << 3,	/* sync IO */
> +	BLK_TC_SYNCIO	= BLK_TC_SYNC,
>  	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
>  	BLK_TC_REQUEUE	= 1 << 5,	/* requeueing */
>  	BLK_TC_ISSUE	= 1 << 6,	/* issue */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6022f44..67857dc 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -87,10 +87,10 @@ struct inodes_stat_t {
>  #define WRITE 1
>  #define READA 2		/* read-ahead  - don't block if no resources */
>  #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
> -#define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
> +#define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define READ_META	(READ | (1 << BIO_RW_META))
> -#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
> -#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNC))
> +#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
> +#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
>  #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
>  #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 6da1435..505f319 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -60,6 +60,7 @@ static struct block_device *resume_bdev;
>  static int submit(int rw, pgoff_t page_off, struct page *page,
>  			struct bio **bio_chain)
>  {
> +	const int bio_rw = rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
>  	struct bio *bio;
>  
>  	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
> @@ -80,7 +81,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
>  	bio_get(bio);
>  
>  	if (bio_chain == NULL) {
> -		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
> +		submit_bio(bio_rw, bio);
>  		wait_on_page_locked(page);
>  		if (rw == READ)
>  			bio_set_pages_dirty(bio);
> @@ -90,7 +91,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
>  			get_page(page);	/* These pages are freed later */
>  		bio->bi_private = *bio_chain;
>  		*bio_chain = bio;
> -		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
> +		submit_bio(bio_rw, bio);
>  	}
>  	return 0;
>  }
> diff --git a/mm/page_io.c b/mm/page_io.c
> index dc6ce0a..3023c47 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -111,7 +111,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  		goto out;
>  	}
>  	if (wbc->sync_mode == WB_SYNC_ALL)
> -		rw |= (1 << BIO_RW_SYNC);
> +		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
>  	count_vm_event(PSWPOUT);
>  	set_page_writeback(page);
>  	unlock_page(page);
> 
> -- 
> Jens Axboe

-- 
MST
