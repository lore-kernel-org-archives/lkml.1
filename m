Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYLCFcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYLCFcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLCFca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:32:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:50404 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYLCFc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:32:29 -0500
Date: Wed, 3 Dec 2008 14:32:00 +0900
To: mbroz@redhat.com
Cc: jens.axboe@oracle.com, agk@redhat.com, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix setting of max_segment_size and
 seg_boundary mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <493324D1.7010202@redhat.com>
References: <493324D1.7010202@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081203143112F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 00:42:09 +0100
Milan Broz <mbroz@redhat.com> wrote:

> Fix setting of max_segment_size and seg_boundary mask for stacked md/dm devices.
> 
> When stacking devices (LVM over MD over SCSI) some of the request queue
> parameters are not set up correctly in some cases by default, namely
> max_segment_size and and seg_boundary mask.
> 
> If you create MD device over SCSI, these attributes are zeroed.
> 
> Problem become when there is over this mapping next device-mapper
> mapping - queue attributes are set in DM this way:
> 
> request_queue   max_segment_size  seg_boundary_mask
> SCSI                65536             0xffffffff
> MD RAID1                0                      0
> LVM                 65536                 -1 (64bit)
> 
> Unfortunately bio_add_page (resp. bio_phys_segments) calculates number
> of physical segments according to these parameters.
> 
> During the generic_make_request() is segment cout recalculated and
> can increase bio->bi_phys_segments count over the allowed limit.
> (After bio_clone() in stack operation.)
> 
> Thi is specially problem in CCISS driver, where it produce OOPS here
>     BUG_ON(creq->nr_phys_segments > MAXSGENTRIES);
> (MAXSEGENTRIES is 31 by default.)
> 
> Sometimes even this command is enough to cause oops:
>   dd iflag=direct if=/dev/<vg>/<lv> of=/dev/null bs=128000 count=10
> 
> This command generates bios with 250 sectors, allocated in 32 4k-pages
> (last page uses only 1024 bytes).
> 
> For LVM layer, it allocates bio with 31 segments (still OK for CCISS),
> unfortunatelly on lower layer it is recalculated to 32 segments and
> this violates CCISS restriction and triggers BUG_ON().
> 
> Attached patch tries to fix it by:
>  * initializing attributes above in queue request constructor
>    blk_queue_make_request()
> 
>  * make sure that blk_queue_stack_limits() inherits setting
> 
>  (DM uses its own function to set the limits because
>  it blk_queue_stack_limits() was introduced later.
>  It should probably switch to use generic stack limit function too.)
> 
>  * sets the default seg_boundary value in one place (blkdev.h)
> 
>  * use this mask as default in DM (instead of -1, which differs in 64bit)
> 
> Bugs related to this:
> https://bugzilla.redhat.com/show_bug.cgi?id=471639
> http://bugzilla.kernel.org/show_bug.cgi?id=8672
> 
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Looks like the correct fix.


> ---
>  block/blk-core.c       |    2 +-
>  block/blk-settings.c   |    4 ++++
>  drivers/md/dm-table.c  |    2 +-
>  include/linux/blkdev.h |    2 ++
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 10e8a64..b7d646c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -592,7 +592,7 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>  				   1 << QUEUE_FLAG_STACKABLE);
>  	q->queue_lock		= lock;
>  
> -	blk_queue_segment_boundary(q, 0xffffffff);
> +	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
>  
>  	blk_queue_make_request(q, __make_request);
>  	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 41392fb..afa55e1 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -125,6 +125,9 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  	q->nr_requests = BLKDEV_MAX_RQ;
>  	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
>  	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
> +	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
> +	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);

Is it a bit strange to set segment_boundary and max_segment_size that
are hardware restrictions in a function used for mostly virtual
devices? max_hw_segments is also hardware restriction though.

It might make sense to share the setting initialization code between
blk_init_queue_node and blk_queue_make_request.


>  	q->make_request_fn = mfn;
>  	q->backing_dev_info.ra_pages =
>  			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
> @@ -314,6 +317,7 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
>  	/* zero is "infinity" */
>  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
>  	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
> +	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
>  
>  	t->max_phys_segments = min(t->max_phys_segments, b->max_phys_segments);
>  	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);

Theoretically, blk_queue_stack_limits() better use min_not_zero
instead of min for max_phys_segments, max_hw_segments, and
max_segment_size?


> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index a63161a..04e5fd7 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -668,7 +668,7 @@ static void check_for_valid_limits(struct io_restrictions *rs)
>  	if (!rs->max_segment_size)
>  		rs->max_segment_size = MAX_SEGMENT_SIZE;
>  	if (!rs->seg_boundary_mask)
> -		rs->seg_boundary_mask = -1;
> +		rs->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
>  	if (!rs->bounce_pfn)
>  		rs->bounce_pfn = -1;
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a135256..9573945 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -921,6 +921,8 @@ extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
>  
>  #define MAX_SEGMENT_SIZE	65536
>  
> +#define BLK_SEG_BOUNDARY_MASK	0xFFFFFFFFUL
> +
>  #define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)
>  
>  static inline int queue_hardsect_size(struct request_queue *q)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
