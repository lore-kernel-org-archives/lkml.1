Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZHDB1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZHDB1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbZHDB1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:27:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZHDB1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:27:52 -0400
Date: Mon, 3 Aug 2009 21:25:55 -0400
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
Subject: Re: [PATCH 20/25] io-controller: map async requests to appropriate
	cgroup
Message-ID: <20090804012555.GA2282@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-21-git-send-email-vgoyal@redhat.com> <4A7647DA.5050607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A7647DA.5050607@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 10:13:46AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +struct io_group *io_get_io_group_bio(struct request_queue *q, struct bio *bio,
> > +					int create)
> > +{
> > +	struct page *page = NULL;
> > +
> > +	/*
> > +	 * Determine the group from task context. Even calls from
> > +	 * blk_get_request() which don't have any bio info will be mapped
> > +	 * to the task's group
> > +	 */
> > +	if (!bio)
> > +		goto sync;
> > +
> > +	if (bio_barrier(bio)) {
> > +		/*
> > +		 * Map barrier requests to root group. May be more special
> > +		 * bio cases should come here
> > +		 */
> > +		return q->elevator->efqd.root_group;
> > +	}
> > +
> > +	/* Map the sync bio to the right group using task context */
> > +	if (elv_bio_sync(bio))
> > +		goto sync;
> > +
> > +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> > +	/* Determine the group from info stored in page */
> > +	page = bio_iovec_idx(bio, 0)->bv_page;
> > +	return io_get_io_group(q, page, create);
> > +#endif
> > +
> > +sync:
> > +	return io_get_io_group(q, NULL, create);
> 
> Fix build warning.
> 
> block/elevator-fq.c: In function ‘io_get_io_group_bio’:
> block/elevator-fq.c:2075: warning: unused variable ‘page’
> 

Thanks Gui. Will apply in next posting.

Vivek

> ---
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 66b10eb..d304f79 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2102,7 +2102,7 @@ struct io_group *io_get_io_group_bio(struct request_queue *q, struct bio *bio,
>  #endif
>  
>  sync:
> -	return io_get_io_group(q, NULL, create);
> +	return io_get_io_group(q, page, create);
>  }
>  EXPORT_SYMBOL(io_get_io_group_bio);
> 
> 
> > +}
> > +EXPORT_SYMBOL(io_get_io_group_bio);
> > +
> 
> 
> -- 
> Regards
> Gui Jianfeng
