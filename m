Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYH2HML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYH2HML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYH2HL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:11:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42480 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYH2HL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:11:56 -0400
Date: Fri, 29 Aug 2008 09:11:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080829071153.GM20055@kernel.dk>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org> <20080828074830.GV20055@kernel.dk> <18614.24929.952454.829021@notabene.brown> <18615.36009.954947.757412@notabene.brown> <18615.36284.491484.331385@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18615.36284.491484.331385@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29 2008, Neil Brown wrote:
> On Friday August 29, neilb@suse.de wrote:
> > 
> > Here is my (untested yet) patch to address the problem.
> > I'll try to get some testing done and push it out early next week, but
> > if anyone could review and/or test that would be a great help.
> 
> Actually, that was my "haven't even compiled it yet" patch.  The one I
> meant to send was this one.
> 
> Sorry for the noise.
> 
> NeilBrown
> 
> 
> From 3a0646137016c69dbcaeed0114558f67daa4a6f0 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Fri, 29 Aug 2008 15:46:38 +1000
> Subject: [PATCH] Fix problem with waiting while holding rcu read lock in md/bitmap.c
> 
> A recent patch to protect the rdev list with rcu locking leaves us
> with a problem because we can sleep on memalloc while holding the
> rcu lock.
> 
> The rcu lock is only needed while walking the linked list as
> uninteresting devices (failed or spares) can be removed at any time.
> 
> So only take the rcu lock while actually walking the linked list.
> Take a refcount on the rdev during the time when we drop the lock
> and do the memalloc to start IO.
> When we return to the locked code, all the interesting devices
> on the list will not have moved, so we can simply use
> list_for_each_continue_rcu to pick up where we left off.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/bitmap.c |   44 +++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 7e65bad..c17eb4f 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -238,15 +238,46 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
>  
>  }
>  
> +static mdk_rdev_t *next_active_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
> +{
> +	/* Iterate the disks of an mddev, using rcu to protect access to the
> +	 * linked list, and raising the refcount of devices we return to ensure
> +	 * they don't disappear while in use.
> +	 * As devices are only added or removed when raid_disk is < 0 and
> +	 * nr_pending is 0 and In_sync is clear, the entries we return will
> +	 * still be in the same position on the list when we re-enter
> +	 * list_for_each_continue_rcu.
> +	 */
> +	struct list_head *pos;
> +	rcu_read_lock();
> +	if (rdev == NULL)
> +		/* start at the beginning */
> +		pos = &mddev->disks;
> +	else
> +		/* release the previous rdev */
> +		rdev_dec_pending(rdev, mddev);
> +	
> +	list_for_each_continue_rcu(pos, &mddev->disks) {
> +		rdev = list_entry(pos, mdk_rdev_t, same_set);
> +		if (rdev->raid_disk >= 0 &&
> +		    test_bit(In_sync, &rdev->flags) &&
> +		    !test_bit(Faulty, &rdev->flags)) {
> +			/* this is a usable devices */
> +			atomic_inc(&rdev->nr_pending);
> +			rcu_read_unlock();
> +			return rdev;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return NULL;
> +}
> +
>  static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  {
> -	mdk_rdev_t *rdev;
> +	mdk_rdev_t *rdev = NULL;
>  	mddev_t *mddev = bitmap->mddev;
>  
> -	rcu_read_lock();
> -	rdev_for_each_rcu(rdev, mddev)
> -		if (test_bit(In_sync, &rdev->flags)
> -		    && !test_bit(Faulty, &rdev->flags)) {
> +	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>  			int size = PAGE_SIZE;
>  			if (page->index == bitmap->file_pages-1)
>  				size = roundup(bitmap->last_page_size,
> @@ -281,8 +312,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  				       + page->index * (PAGE_SIZE/512),
>  				       size,
>  				       page);
> -		}
> -	rcu_read_unlock();
> +	}
>  
>  	if (wait)
>  		md_super_wait(mddev);
> -- 
> 1.5.6.5

Looks like an elegant solution to the problem Neil, good stuff!

-- 
Jens Axboe

