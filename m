Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXCAHtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXCAHtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXCAHtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:49:01 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52555 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXCAHtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:49:00 -0500
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070228231156.75df7f97.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 28 Feb 2007 23:11:56 -0800)
Subject: Re: [patch 04/22] fix deadlock in throttle_vm_writeout
References: <20070227223809.684624012@szeredi.hu>
	<20070227223914.057085427@szeredi.hu> <20070228231156.75df7f97.akpm@linux-foundation.org>
Message-Id: <E1HMg1S-0001hR-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Mar 2007 08:48:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > This deadlock is similar to the one in balance_dirty_pages, but
> > instead of waiting in balance_dirty_pages after submitting a write
> > request, it happens during a memory allocation for filesystem B before
> > submitting a write request.
> > 
> > It is easy to reproduce on a machine with not too much memory.
> > E.g. try this on 2.6.21-rc1 UML with 32MB (works on physical hw as
> > well):
> > 
> >   dd if=/dev/zero of=/tmp/tmp.img bs=1048576 count=40
> >   mke2fs -j -F /tmp/tmp.img
> >   mkdir /tmp/img
> >   mount -oloop /tmp/tmp.img /tmp/img
> >   bash-shared-mapping /tmp/img/foo 30000000
> > 
> > The deadlock doesn't happen immediately, sometimes only after a few
> > minutes.
> > 
> > Simplified stack trace for bash-shared-mapping after the deadlock:
> > 
> >   io_schedule_timeout
> >   congestion_wait
> >   balance_dirty_pages
> >   balance_dirty_pages_ratelimited_nr
> >   generic_file_buffered_write
> >   __generic_file_aio_write_nolock
> >   generic_file_aio_write
> >   ext3_file_write
> >   do_sync_write
> >   vfs_write
> >   sys_pwrite64
> > 
> > and for [loop0]:
> > 
> >   io_schedule_timeout
> >   congestion_wait
> >   throttle_vm_writeout
> >   shrink_zone
> >   shrink_zones
> >   try_to_free_pages
> >   __alloc_pages
> >   find_or_create_page
> >   do_lo_send_aops
> >   lo_send
> >   do_bio_filebacked
> >   loop_thread
> > 
> > The requirement for the deadlock is that
> > 
> >   nr_writeback > dirty_thresh * 1.1 + margin
> > 
> > Again margin seems to be in the 100 page range.
> > 
> > The task of throttle_vm_writeout is to limit the rate at which
> > under-writeback pages are created due to swapping.  There's no other
> > way direct reclaim can increase the nr_writeback + nr_file_dirty.
> > 
> > So when there are few or no under-swap pages, it is safe for this
> > function to return.  This ensures, that there's progress with writing
> > back dirty pages.
> > 
> 
> Would this also be solved by the below just-submitted bugfix?  I guess not.
> 
> I think the basic problem here is that the loop thread is reponsible for cleaning
> memory, but in throttle_vm_writeout(), the loop thread can get stuck waiting
> for some other thread to clean memory, but that ain't going to happen.
> 
> throttle_vm_writeout() wasn't very well thought through, I suspect.
> 
> 
> I suspect we can just delete throttle_vm_writeout() now.  The original
> rationale was:
> 
>     [PATCH] vm: pageout throttling
>     
>     With silly pageout testcases it is possible to place huge amounts of memory
>     under I/O.  With a large request queue (CFQ uses 8192 requests) it is
>     possible to place _all_ memory under I/O at the same time.
>     
>     This means that all memory is pinned and unreclaimable and the VM gets
>     upset and goes oom.
>     
>     The patch limits the amount of memory which is under pageout writeout to be
>     a little more than the amount of memory at which balance_dirty_pages()
>     callers will synchronously throttle.
>     
>     This means that heavy pageout activity can starve heavy writeback activity
>     completely, but heavy writeback activity will not cause starvation of
>     pageout.  Because we don't want a simple `dd' to be causing excessive
>     latencies in page reclaim.
> 
> but now that we limit the amount of dirty MAP_SHARED memory, and given that
> the various pieces of the dirty-memory limiting puzzle also take the number
> of under-writeback pages into account, we should no longer be able to get
> in the situation where the total number of writeback+dirty pages exceeds
> dirty_ratio.

Only with swap, which can generate a lot of writeback pages, without
limiting.  Does this matter?  I guess that depends on the queue
length.  If a lot of swap requests are using up memory, than that's
bad.

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> throttle_vm_writeout() is designed to wait for the dirty levels to subside. 
> But if the caller holds IO or FS locks, we might be holding up that writeout.
> 
> So change it to take a single nap to give other devices a chance to clean some
> memory, then return.
> 

Why does it nap unconditionally for GFP_NOFS/NOIO?  That seems to be a
waste of time.

Btw, I did try not calling throttle_vm_writeout() for GFP_NOFS/NOIO
and IIRC it didn't help.  I'll check again.

Thanks,
Miklos


> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/writeback.h |    2 +-
>  mm/page-writeback.c       |   13 +++++++++++--
>  mm/vmscan.c               |    2 +-
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff -puN include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations include/linux/writeback.h
> --- a/include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
> +++ a/include/linux/writeback.h
> @@ -84,7 +84,7 @@ static inline void wait_on_inode(struct 
>  int wakeup_pdflush(long nr_pages);
>  void laptop_io_completion(void);
>  void laptop_sync_completion(void);
> -void throttle_vm_writeout(void);
> +void throttle_vm_writeout(gfp_t gfp_mask);
>  
>  /* These are exported to sysctl. */
>  extern int dirty_background_ratio;
> diff -puN mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/page-writeback.c
> --- a/mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
> +++ a/mm/page-writeback.c
> @@ -296,11 +296,21 @@ void balance_dirty_pages_ratelimited_nr(
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
>  
> -void throttle_vm_writeout(void)
> +void throttle_vm_writeout(gfp_t gfp_mask)
>  {
>  	long background_thresh;
>  	long dirty_thresh;
>  
> +	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
> +		/*
> +		 * The caller might hold locks which can prevent IO completion
> +		 * or progress in the filesystem.  So we cannot just sit here
> +		 * waiting for IO to complete.
> +		 */
> +		congestion_wait(WRITE, HZ/10);
> +		return;
> +	}
> +
>          for ( ; ; ) {
>  		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
>  
> @@ -317,7 +327,6 @@ void throttle_vm_writeout(void)
>          }
>  }
>  
> -
>  /*
>   * writeback at least _min_pages, and keep writing until the amount of dirty
>   * memory is less than the background threshold, or until we're all clean.
> diff -puN mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/vmscan.c
> --- a/mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
> +++ a/mm/vmscan.c
> @@ -952,7 +952,7 @@ static unsigned long shrink_zone(int pri
>  		}
>  	}
>  
> -	throttle_vm_writeout();
> +	throttle_vm_writeout(sc->gfp_mask);
>  
>  	atomic_dec(&zone->reclaim_in_progress);
>  	return nr_reclaimed;
