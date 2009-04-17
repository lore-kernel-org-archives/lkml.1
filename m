Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZDQHeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZDQHeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZDQHdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:33:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33713 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZDQHdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:33:50 -0400
Date: Fri, 17 Apr 2009 09:33:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] loop: use BIO list management functions
Message-ID: <20090417073349.GK4593@kernel.dk>
References: <20090417063217.GA3515@localhost.localdomain> <20090417064034.GG4593@kernel.dk> <20090417073031.GA3367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417073031.GA3367@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, Akinobu Mita wrote:
> On Fri, Apr 17, 2009 at 08:40:35AM +0200, Jens Axboe wrote:
> > On Fri, Apr 17 2009, Akinobu Mita wrote:
> > > Impact: cleanup
> > 
> > This looks good, but please provide a better description than just a
> > silly impact notice. I've filled it in for you for this one, but in the
> > future the description should say what the patch does.
> > 
> > It's queued for 2.6.31.
> 
> OK, I added the description and Christoph's feedbacks.

Technically, you should not include the bio.h change with this patch, as
it has nothing to do with loop at all.

> 
> Subject: loop: use BIO list management functions
> 
> There are BIO list management helpers in bio.h.
> This uses them to reduce code duplication in loopback driver.
> 
> Cc:  Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/block/loop.c |   42 +++++++-----------------------------------
>  include/linux/bio.h  |    2 +-
>  include/linux/loop.h |    3 +--
>  3 files changed, 9 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index ddae808..2b70545 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -506,35 +506,6 @@ out:
>  	return ret;
>  }
>  
> -/*
> - * Add bio to back of pending list
> - */
> -static void loop_add_bio(struct loop_device *lo, struct bio *bio)
> -{
> -	if (lo->lo_biotail) {
> -		lo->lo_biotail->bi_next = bio;
> -		lo->lo_biotail = bio;
> -	} else
> -		lo->lo_bio = lo->lo_biotail = bio;
> -}
> -
> -/*
> - * Grab first pending buffer
> - */
> -static struct bio *loop_get_bio(struct loop_device *lo)
> -{
> -	struct bio *bio;
> -
> -	if ((bio = lo->lo_bio)) {
> -		if (bio == lo->lo_biotail)
> -			lo->lo_biotail = NULL;
> -		lo->lo_bio = bio->bi_next;
> -		bio->bi_next = NULL;
> -	}
> -
> -	return bio;
> -}
> -
>  static int loop_make_request(struct request_queue *q, struct bio *old_bio)
>  {
>  	struct loop_device *lo = q->queuedata;
> @@ -550,7 +521,7 @@ static int loop_make_request(struct request_queue *q, struct bio *old_bio)
>  		goto out;
>  	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
>  		goto out;
> -	loop_add_bio(lo, old_bio);
> +	bio_list_add(&lo->lo_bio_list, old_bio);
>  	wake_up(&lo->lo_event);
>  	spin_unlock_irq(&lo->lo_lock);
>  	return 0;
> @@ -609,15 +580,16 @@ static int loop_thread(void *data)
>  
>  	set_user_nice(current, -20);
>  
> -	while (!kthread_should_stop() || lo->lo_bio) {
> +	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
>  
>  		wait_event_interruptible(lo->lo_event,
> -				lo->lo_bio || kthread_should_stop());
> +				!bio_list_empty(&lo->lo_bio_list) ||
> +				kthread_should_stop());
>  
> -		if (!lo->lo_bio)
> +		if (bio_list_empty(&lo->lo_bio_list))
>  			continue;
>  		spin_lock_irq(&lo->lo_lock);
> -		bio = loop_get_bio(lo);
> +		bio = bio_list_pop(&lo->lo_bio_list);
>  		spin_unlock_irq(&lo->lo_lock);
>  
>  		BUG_ON(!bio);
> @@ -841,7 +813,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
>  	lo->old_gfp_mask = mapping_gfp_mask(mapping);
>  	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
>  
> -	lo->lo_bio = lo->lo_biotail = NULL;
> +	bio_list_init(&lo->lo_bio_list);
>  
>  	/*
>  	 * set queue make_request_fn, and add limits based on lower level
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index b89cf2d..9388c55 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -505,7 +505,7 @@ static inline int bio_has_data(struct bio *bio)
>  }
>  
>  /*
> - * BIO list managment for use by remapping drivers (e.g. DM or MD).
> + * BIO list management for use by remapping drivers (e.g. DM or MD).
>   *
>   * A bio_list anchors a singly-linked list of bios chained through the bi_next
>   * member of the bio.  The bio_list also caches the last list member to allow
> diff --git a/include/linux/loop.h b/include/linux/loop.h
> index 4072544..66c194e 100644
> --- a/include/linux/loop.h
> +++ b/include/linux/loop.h
> @@ -56,8 +56,7 @@ struct loop_device {
>  	gfp_t		old_gfp_mask;
>  
>  	spinlock_t		lo_lock;
> -	struct bio 		*lo_bio;
> -	struct bio		*lo_biotail;
> +	struct bio_list		lo_bio_list;
>  	int			lo_state;
>  	struct mutex		lo_ctl_mutex;
>  	struct task_struct	*lo_thread;

-- 
Jens Axboe

