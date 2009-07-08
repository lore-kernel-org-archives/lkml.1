Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZGHWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZGHWf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZGHWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:35:12 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:43266 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbZGHWfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:35:10 -0400
Subject: Re: [PATCH] Fix congestion_wait() sync/async vs read/write
 confusion
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, chris.mason@oracle.com
In-Reply-To: <20090708184703.GW23611@kernel.dk>
References: <20090708184703.GW23611@kernel.dk>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 18:35:04 -0400
Message-Id: <1247092504.9223.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 805 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: AD3F50B8C078BF65F0DC9E863F079163FFCBCB91
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 31 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 20:47 +0200, Jens Axboe wrote:
> Hi,
> 
> This one isn't great, we currently have broken congestion wait logic in
> the kernel. 2.6.30 is impacted as well, so this patch should go to
> stable too once it's in -git. I'll let this one simmer until tomorrow,
> then ask Linus to pull it. The offending commit breaking this is
> 1faa16d22877f4839bd433547d770c676d1d964c.
> 
> Meanwhile, it could potentially cause buffered writeout slowdowns in the
> kernel. Perhaps the 2.6.30 regression in that area is caused by this?
> Would be interesting if the submitter could test. I can't find the list,
> CC'ing Rafael.
> 
> diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
> index 7c8ca91..1f118d4 100644
> --- a/arch/x86/lib/usercopy_32.c
> +++ b/arch/x86/lib/usercopy_32.c
> @@ -751,7 +751,7 @@ survive:
>  
>  			if (retval == -ENOMEM && is_global_init(current)) {
>  				up_read(&current->mm->mmap_sem);
> -				congestion_wait(WRITE, HZ/50);
> +				congestion_wait(BLK_RW_ASYNC, HZ/50);
>  				goto survive;
>  			}
>  
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 83650e0..f7ebe74 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2595,7 +2595,7 @@ static int pkt_make_request(struct request_queue *q, struct bio *bio)
>  		set_bdi_congested(&q->backing_dev_info, WRITE);
>  		do {
>  			spin_unlock(&pd->lock);
> -			congestion_wait(WRITE, HZ);
> +			congestion_wait(BLK_RW_ASYNC, HZ);
>  			spin_lock(&pd->lock);
>  		} while(pd->bio_queue_size > pd->write_congestion_off);
>  	}
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 9933eb8..529e2ba 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -776,7 +776,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
>  		 * But don't wait if split was due to the io size restriction
>  		 */
>  		if (unlikely(out_of_pages))
> -			congestion_wait(WRITE, HZ/100);
> +			congestion_wait(BLK_RW_ASYNC, HZ/100);
>  
>  		/*
>  		 * With async crypto it is unsafe to share the crypto context
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index b28ea64..f042b96 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -134,7 +134,7 @@ static int fat_file_release(struct inode *inode, struct file *filp)
>  	if ((filp->f_mode & FMODE_WRITE) &&
>  	     MSDOS_SB(inode->i_sb)->options.flush) {
>  		fat_flush_inodes(inode->i_sb, inode, NULL);
> -		congestion_wait(WRITE, HZ/10);
> +		congestion_wait(BLK_RW_ASYNC, HZ/10);
>  	}
>  	return 0;
>  }
> diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> index 77f5bb7..9062220 100644
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -997,7 +997,7 @@ static int reiserfs_async_progress_wait(struct super_block *s)
>  	DEFINE_WAIT(wait);
>  	struct reiserfs_journal *j = SB_JOURNAL(s);
>  	if (atomic_read(&j->j_async_throttle))
> -		congestion_wait(WRITE, HZ / 10);
> +		congestion_wait(BLK_RW_ASYNC, HZ / 10);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
> index 1cd3b55..2d3f90a 100644
> --- a/fs/xfs/linux-2.6/kmem.c
> +++ b/fs/xfs/linux-2.6/kmem.c
> @@ -53,7 +53,7 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
>  			printk(KERN_ERR "XFS: possible memory allocation "
>  					"deadlock in %s (mode:0x%x)\n",
>  					__func__, lflags);
> -		congestion_wait(WRITE, HZ/50);
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (1);
>  }
>  
> @@ -130,7 +130,7 @@ kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
>  			printk(KERN_ERR "XFS: possible memory allocation "
>  					"deadlock in %s (mode:0x%x)\n",
>  					__func__, lflags);
> -		congestion_wait(WRITE, HZ/50);
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (1);
>  }
>  
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 1418b91..0c93c7e 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -412,7 +412,7 @@ _xfs_buf_lookup_pages(
>  
>  			XFS_STATS_INC(xb_page_retries);
>  			xfsbufd_wakeup(0, gfp_mask);
> -			congestion_wait(WRITE, HZ/50);
> +			congestion_wait(BLK_RW_ASYNC, HZ/50);
>  			goto retry;
>  		}
>  
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 493b468..c86edd2 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -283,7 +283,6 @@ static wait_queue_head_t congestion_wqh[2] = {
>  		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
>  	};
>  
> -
>  void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
>  {
>  	enum bdi_state bit;
> @@ -308,18 +307,18 @@ EXPORT_SYMBOL(set_bdi_congested);
>  
>  /**
>   * congestion_wait - wait for a backing_dev to become uncongested
> - * @rw: READ or WRITE
> + * @sync: SYNC or ASYNC IO
>   * @timeout: timeout in jiffies
>   *
>   * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
>   * write congestion.  If no backing_devs are congested then just wait for the
>   * next write to be completed.
>   */
> -long congestion_wait(int rw, long timeout)
> +long congestion_wait(int sync, long timeout)
>  {
>  	long ret;
>  	DEFINE_WAIT(wait);
> -	wait_queue_head_t *wqh = &congestion_wqh[rw];
> +	wait_queue_head_t *wqh = &congestion_wqh[sync];
>  
>  	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
>  	ret = io_schedule_timeout(timeout);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2fa20d..e717964 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1973,7 +1973,7 @@ try_to_free:
>  		if (!progress) {
>  			nr_retries--;
>  			/* maybe some writeback is necessary */
> -			congestion_wait(WRITE, HZ/10);
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);
>  		}
>  
>  	}
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7687879..81627eb 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -575,7 +575,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		if (pages_written >= write_chunk)
>  			break;		/* We've done our duty */
>  
> -		congestion_wait(WRITE, HZ/10);
> +		congestion_wait(BLK_RW_ASYNC, HZ/10);
>  	}
>  
>  	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> @@ -669,7 +669,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>                  if (global_page_state(NR_UNSTABLE_NFS) +
>  			global_page_state(NR_WRITEBACK) <= dirty_thresh)
>                          	break;
> -                congestion_wait(WRITE, HZ/10);
> +                congestion_wait(BLK_RW_ASYNC, HZ/10);
>  
>  		/*
>  		 * The caller might hold locks which can prevent IO completion
> @@ -715,7 +715,7 @@ static void background_writeout(unsigned long _min_pages)
>  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
>  			/* Wrote less than expected */
>  			if (wbc.encountered_congestion || wbc.more_io)
> -				congestion_wait(WRITE, HZ/10);
> +				congestion_wait(BLK_RW_ASYNC, HZ/10);
>  			else
>  				break;
>  		}
> @@ -787,7 +787,7 @@ static void wb_kupdate(unsigned long arg)
>  		writeback_inodes(&wbc);
>  		if (wbc.nr_to_write > 0) {
>  			if (wbc.encountered_congestion || wbc.more_io)
> -				congestion_wait(WRITE, HZ/10);
> +				congestion_wait(BLK_RW_ASYNC, HZ/10);
>  			else
>  				break;	/* All the old data is written */
>  		}
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e0f2cdf..2862bcf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1666,7 +1666,7 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
>  			preferred_zone, migratetype);
>  
>  		if (!page && gfp_mask & __GFP_NOFAIL)
> -			congestion_wait(WRITE, HZ/50);
> +			congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (!page && (gfp_mask & __GFP_NOFAIL));
>  
>  	return page;
> @@ -1831,7 +1831,7 @@ rebalance:
>  	pages_reclaimed += did_some_progress;
>  	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
>  		/* Wait for some write requests to complete then retry */
> -		congestion_wait(WRITE, HZ/50);
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  		goto rebalance;
>  	}
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5415526..dea7abd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1104,7 +1104,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
>  		 */
>  		if (nr_freed < nr_taken && !current_is_kswapd() &&
>  		    lumpy_reclaim) {
> -			congestion_wait(WRITE, HZ/10);
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);
>  
>  			/*
>  			 * The attempt at page out may have made some
> @@ -1721,7 +1721,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  
>  		/* Take a nap, wait for some writeback to complete */
>  		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
> -			congestion_wait(WRITE, HZ/10);
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);
>  	}
>  	/* top priority shrink_zones still had more to do? don't OOM, then */
>  	if (!sc->all_unreclaimable && scanning_global_lru(sc))
> @@ -1960,7 +1960,7 @@ loop_again:
>  		 * another pass across the zones.
>  		 */
>  		if (total_scanned && priority < DEF_PRIORITY - 2)
> -			congestion_wait(WRITE, HZ/10);
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);

Oh, great...

This particular change will affect _all_ users of
set_bdi_congested(WRITE)/clear_bdi_congested(WRITE). If you're going to
do this, then you had better be prepared to change them all. There's one
in fs/nfs/write.c...

Trond

>  		/*
>  		 * We do this so kswapd doesn't build up large priorities for
> @@ -2233,7 +2233,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  				goto out;
>  
>  			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
> -				congestion_wait(WRITE, HZ / 10);
> +				congestion_wait(BLK_RW_ASYNC, HZ / 10);
>  		}
>  	}
>  
> 


