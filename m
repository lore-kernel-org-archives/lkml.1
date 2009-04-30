Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbZD3Q4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbZD3Q4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763583AbZD3Q4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:56:21 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:20783 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763241AbZD3Q4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:56:20 -0400
Message-ID: <49F9D82D.50901@hp.com>
Date: Thu, 30 Apr 2009 12:56:13 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: swap arg name "from" and "to" of blk_add_trace_remap
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090430133627.D217.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] blktrace: swap arg name "from" and "to" of blk_add_trace_remap
> 
> Impact: cleanup for improve readability
> 
> Currently, blk_add_trace_remap has following prototype.
> 
> static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> 				       dev_t dev, sector_t from, sector_t to)
> 
> but caller pass "from" secter as 4th arg, "to" sector as 5th arg.
> 
> example,
> --------------------------------------------------------
> static inline void blk_partition_remap(struct bio *bio)
> {
> 	struct block_device *bdev = bio->bi_bdev;
> 
> 	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
> 		struct hd_struct *p = bdev->bd_part;
> 
> 		bio->bi_sector += p->start_sect;
> 		bio->bi_bdev = bdev->bd_contains;
> 
> 		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
> 				    bdev->bd_dev, bio->bi_sector,
> 				    bio->bi_sector - p->start_sect);
> 	}
> }
> --------------------------------------------------------
> 
> Oh my god, it's reverse order.
> Fortunately, print logic reverse again. the twice reversing hide problem.
> 
> but, but...
> It repeatedly confuse reviewer (include me!).
> Then, swapping argment name is better.
> 
> this patch doesn't change any behavior and ABI.
> 
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/blktrace_api.h |    2 +-
>  kernel/trace/blktrace.c      |   17 ++++++++---------
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> Index: b/include/linux/blktrace_api.h
> ===================================================================
> --- a/include/linux/blktrace_api.h	2009-04-30 13:17:56.000000000 +0900
> +++ b/include/linux/blktrace_api.h	2009-04-30 13:18:12.000000000 +0900
> @@ -118,7 +118,7 @@ struct blk_io_trace {
>  struct blk_io_trace_remap {
>  	__be32 device;
>  	__be32 device_from;
> -	__be64 sector;
> +	__be64 sector_from;
>  };
>  
>  enum {
> Index: b/kernel/trace/blktrace.c
> ===================================================================
> --- a/kernel/trace/blktrace.c	2009-04-30 13:18:09.000000000 +0900
> +++ b/kernel/trace/blktrace.c	2009-04-30 13:18:12.000000000 +0900
> @@ -839,7 +839,7 @@ static void blk_add_trace_split(struct r
>   *
>   **/
>  static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -				       dev_t dev, sector_t from, sector_t to)
> +				       dev_t dev, sector_t to, sector_t from)
>  {
>  	struct blk_trace *bt = q->blk_trace;
>  	struct blk_io_trace_remap r;
> @@ -847,11 +847,11 @@ static void blk_add_trace_remap(struct r
>  	if (likely(!bt))
>  		return;
>  
> -	r.device = cpu_to_be32(dev);
> +	r.device      = cpu_to_be32(dev);
>  	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
> -	r.sector = cpu_to_be64(to);
> +	r.sector_from = cpu_to_be64(from);
>  
> -	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
> +	__blk_add_trace(bt, to, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
>  			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
>  }
>  
> @@ -1028,11 +1028,10 @@ static void get_pdu_remap(const struct t
>  			  struct blk_io_trace_remap *r)
>  {
>  	const struct blk_io_trace_remap *__r = pdu_start(ent);
> -	__u64 sector = __r->sector;
>  
> -	r->device = be32_to_cpu(__r->device);
> -	r->device_from = be32_to_cpu(__r->device_from);
> -	r->sector = be64_to_cpu(sector);
> +	r->device	= be32_to_cpu(__r->device);
> +	r->device_from	= be32_to_cpu(__r->device_from);
> +	r->sector_from	= be64_to_cpu(__r->sector_from);
>  }
>  
>  typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
> @@ -1154,7 +1153,7 @@ static int blk_log_remap(struct trace_se
>  	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
>  			       t_sector(ent),
>  			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
> -			       (unsigned long long)r.sector);
> +			       (unsigned long long)r.sector_from);
>  }
>  
>  static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
> 
> 

I believe this may be more messed up than you believe: Consider the last
function: blk_log_remap. Notice how you are printing the /device/ and
/sector_from/ as one pair. Isn't that confusing too: wouldn't one expect
/device_from/ and /sector_from/ to be paired up?

I ran into this problem a long time ago - hence the current code in
blkparse contains:

        if (act[0] == 'A') {    /* Remap */
                get_pdu_remap(t, &r);
                t->device = r.device_from;
        }

Which puts the device_from out at the beginning of the line, and then
the 'device' + 'sector' (== 'sector_from') out at the end of the line.
(Which, of course, is all confusing.)

To really fix this, I think one needs to:

(a) adjust the kernel to make "r.device_from" and "r.sector_from" refer
to the same part of the trace, and the "r.device" and "t->sector" refer
to the other part of the trace.

(b) fix blkparse (& btt & ...) to do the same thing - not make
adjustments for the stupid naming...

If we leave the kernel->user space ABI alone:

first u32: device mapped /from/
second u32: device mapped /to/
u64: sector mapped from

We can then change the names. I've followed this e-mail up with a pair
of kernel-side patches and will submit user side fixes for blkptrace later.

Alan D. Brunelle
Hewlett-Packard


