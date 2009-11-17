Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZKQSHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZKQSHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZKQSHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:07:43 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:18833 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZKQSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:07:43 -0500
Subject: Re: [PATCH 02/16] blkio: Keep queue on service tree until we
 expire it
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
In-Reply-To: <1258134015-21632-3-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
	 <1258134015-21632-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 13:07:40 -0500
Message-ID: <1258481260.6084.292.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek - 

Some minor nit comments in this and the next three e-mails...

On Fri, 2009-11-13 at 12:40 -0500, Vivek Goyal wrote:

> @@ -1065,17 +1080,43 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
>   * Get next queue for service. Unless we have a queue preemption,
>   * we'll simply select the first cfqq in the service tree.
>   */
> -static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
> +static struct cfq_queue *__cfq_get_next_queue(struct cfq_data *cfqd)
>  {
>  	struct cfq_rb_root *service_tree =
>  		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
>  					cfqd->serving_type, cfqd);
>  
> +	if (!cfqd->rq_queued)
> +		return NULL;
> +
>  	if (RB_EMPTY_ROOT(&service_tree->rb))
>  		return NULL;
>  	return cfq_rb_first(service_tree);
>  }
>  
> +static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
> +{
> +	struct cfq_group *cfqg = &cfqd->root_group;
> +	struct cfq_queue *cfqq;
> +	int i, j;
> +
> +	if (!cfqd->rq_queued)
> +		return NULL;
> +
> +	for (i = 0; i < 2; ++i) {
> +		for (j = 0; j < 3; ++j) {

Is this double for-loop a good candidate for an iterator macro
construct? (I think this is used 6 times in your total patch set.)
 
> +			cfqq = cfq_rb_first(&cfqg->service_trees[i][j]);
> +			if (cfqq)
> +				return cfqq;
> +		}
> +	}
> +

Perhaps just change the 4 lines below with:

	return cfq_rb_first(&cfgg->service_tree_idle);

to be consistent (e.g. right above in __cfq_get_next_queue) and for less
code clutter?

> +	cfqq = cfq_rb_first(&cfqg->service_tree_idle);
> +	if (cfqq)
> +		return cfqq;
> +	return NULL;
> +}
> +


