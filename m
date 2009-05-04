Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZEDFqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZEDFqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZEDFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:46:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZEDFqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:46:30 -0400
Message-ID: <49FE8165.80709@cn.fujitsu.com>
Date: Mon, 04 May 2009 13:47:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: correct remap names
References: <20090430133627.D217.A69D9226@jp.fujitsu.com> <49F9D82D.50901@hp.com> <49F9D906.40300@hp.com>
In-Reply-To: <49F9D906.40300@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] blktrace: correct remap names
> 
> This attempts to clarify names utilized during block I/O remap operations
> (partition, volume manager). It correctly matches up the /from/ information for both device & sector. This takes in the concept from osaki Motohiro and extends it to include better naming for the "device_from" field.
> 

I also noticed this..

> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> ---
>  include/linux/blktrace_api.h |    4 ++--
>  include/trace/block.h        |    4 ++--
>  kernel/trace/blktrace.c      |   21 +++++++++++----------
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index d960889..da1a14e 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -116,9 +116,9 @@ struct blk_io_trace {
>   * The remap event
>   */
>  struct blk_io_trace_remap {
> -	__be32 device;
>  	__be32 device_from;
> -	__be64 sector;
> +	__be32 device_to;
> +	__be64 sector_from;
>  };
>  

If we are really fine with this change, then:

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

>  enum {
> diff --git a/include/trace/block.h b/include/trace/block.h
> index 8ac945b..5b12efa 100644
> --- a/include/trace/block.h
> +++ b/include/trace/block.h
> @@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
>  
>  DECLARE_TRACE(block_remap,
>  	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
> -		 sector_t to),
> -	      TP_ARGS(q, bio, dev, to));
> +		 sector_t from),
> +	      TP_ARGS(q, bio, dev, from));
>  
>  #endif
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 6eaef3b..1492d50 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -817,7 +817,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
>   *
>   **/
>  static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -				       dev_t dev, sector_t to)
> +				       dev_t dev, sector_t from)
>  {
>  	struct blk_trace *bt = q->blk_trace;
>  	struct blk_io_trace_remap r;
> @@ -825,9 +825,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
>  	if (likely(!bt))
>  		return;
>  
> -	r.device = cpu_to_be32(dev);
> -	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
> -	r.sector = cpu_to_be64(to);
> +	r.device_from = cpu_to_be32(dev);
> +	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
> +	r.sector_from = cpu_to_be64(from);
>  
>  	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
>  			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
> @@ -997,11 +997,11 @@ static void get_pdu_remap(const struct trace_entry *ent,
>  			  struct blk_io_trace_remap *r)
>  {
>  	const struct blk_io_trace_remap *__r = pdu_start(ent);
> -	__u64 sector = __r->sector;
> +	__u64 sector_from = __r->sector_from;
>  
> -	r->device = be32_to_cpu(__r->device);
>  	r->device_from = be32_to_cpu(__r->device_from);
> -	r->sector = be64_to_cpu(sector);
> +	r->device_to   = be32_to_cpu(__r->device_to);
> +	r->sector_from = be64_to_cpu(sector_from);
>  }
>  
>  typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
> @@ -1055,13 +1055,14 @@ static int blk_log_with_error(struct trace_seq *s,
>  
>  static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
>  {
> -	struct blk_io_trace_remap r = { .device = 0, };
> +	struct blk_io_trace_remap r = { .device_from = 0, };
>  
>  	get_pdu_remap(ent, &r);
>  	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
>  			       t_sector(ent),
> -			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
> -			       (unsigned long long)r.sector);
> +			       t_sec(ent), MAJOR(r.device_from),
> +			       MINOR(r.device_from),
> +			       (unsigned long long)r.sector_from);

Minor nits. I think this is better:

return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
			t_sector(ent), t_sec(ent),
			MAJOR(r.device_from), MINOR(r.device_from),
			(unsigned long long)r.sector_from);

or this:

return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
			t_sector(ent),
			t_sec(ent),
			MAJOR(r.device_from),
			MINOR(r.device_from),
			(unsigned long long)r.sector_from);

>  }
>  
>  static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
> -- 
> 1.6.0.4

