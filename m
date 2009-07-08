Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZGHN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZGHN7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZGHN7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:59:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZGHN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:59:33 -0400
Date: Wed, 8 Jul 2009 09:57:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request descriptor
	support
Message-ID: <20090708135721.GB24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-22-git-send-email-vgoyal@redhat.com> <4A54121D.5090008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A54121D.5090008@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:27:25AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  }
> > +#ifdef CONFIG_GROUP_IOSCHED
> > +static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
> > +{
> > +	return queue_var_show(q->nr_group_requests, (page));
> > +}
> > +
> > +static ssize_t
> > +queue_group_requests_store(struct request_queue *q, const char *page,
> > +					size_t count)
> > +{
> > +	unsigned long nr;
> > +	int ret = queue_var_store(&nr, page, count);
> > +	if (nr < BLKDEV_MIN_RQ)
> > +		nr = BLKDEV_MIN_RQ;
> > +
> > +	spin_lock_irq(q->queue_lock);
> > +	q->nr_group_requests = nr;
> > +	spin_unlock_irq(q->queue_lock);
> > +	return ret;
> > +}
> > +#endif
> 
> Hi Vivek,
> 
> Do we need to update the congestion thresholds for allocated io groups?
> 

Good catch Gui. Thanks. I will test the patch and queue up for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/blk-sysfs.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 577ed42..92b9f25 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -83,17 +83,32 @@ static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
>  	return queue_var_show(q->nr_group_requests, (page));
>  }
>  
> +extern void elv_io_group_congestion_threshold(struct request_queue *q,
> +					      struct io_group *iog);
> +
>  static ssize_t
>  queue_group_requests_store(struct request_queue *q, const char *page,
>  					size_t count)
>  {
> +	struct hlist_node *n;
> +	struct io_group *iog;
> +	struct elv_fq_data *efqd;
>  	unsigned long nr;
>  	int ret = queue_var_store(&nr, page, count);
> +
>  	if (nr < BLKDEV_MIN_RQ)
>  		nr = BLKDEV_MIN_RQ;
>  
>  	spin_lock_irq(q->queue_lock);
> +
>  	q->nr_group_requests = nr;
> +
> +	efqd = &q->elevator->efqd;
> +
> +	hlist_for_each_entry(iog, n, &efqd->group_list, elv_data_node) {
> +		elv_io_group_congestion_threshold(q, iog);
> +	}
> +
>  	spin_unlock_irq(q->queue_lock);
>  	return ret;
>  }
> -- 
> 1.5.4.rc3 
