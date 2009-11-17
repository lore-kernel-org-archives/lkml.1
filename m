Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZKQSIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZKQSIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZKQSIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:08:00 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:27590 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbZKQSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:07:57 -0500
Subject: Re: [PATCH 08/16] blkio: Dynamic cfq group creation based on
 cgroup tasks belongs to
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
In-Reply-To: <1258134015-21632-9-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
	 <1258134015-21632-9-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 13:07:51 -0500
Message-ID: <1258481271.6084.294.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 12:40 -0500, Vivek Goyal wrote:
> o Determine the cgroup IO submitting task belongs to and create the cfq
>   group if it does not exist already.
> 
> o Also link cfqq and associated cfq group.
> 
> o Currently all async IO is mapped to root group.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 102 insertions(+), 11 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 4c05d45..9653caf 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -188,6 +188,10 @@ struct cfq_group {
>  	unsigned long saved_workload_slice;
>  	enum wl_type_t saved_workload;
>  	enum wl_prio_t saved_serving_prio;
> +	struct blkio_group blkg;
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +	struct hlist_node cfqd_node;
> +#endif
>  };
>  
>  /*
> @@ -267,8 +271,13 @@ struct cfq_data {
>  	struct cfq_queue oom_cfqq;
>  
>  	unsigned long last_end_sync_rq;
> +
> +	/* List of cfq groups being managed on this device*/
> +	struct hlist_head cfqg_list;
>  };
>  
> +static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> +
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>  					    enum wl_prio_t prio,
>  					    enum wl_type_t type,
> @@ -858,6 +867,91 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>  		cfqg->saved_workload_slice = 0;
>  }
>  
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
> +{
> +	if (blkg)
> +		return container_of(blkg, struct cfq_group, blkg);
> +	return NULL;
> +}
> +
> +static struct cfq_group *
> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +{
> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> +	struct cfq_group *cfqg = NULL;
> +	void *key = cfqd;
> +	int i, j;
> +
> +	/* Do we need to take this reference */
> +	if (!css_tryget(&blkcg->css))
> +		return NULL;;
> +
> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +	if (cfqg || !create)
> +		goto done;
> +
> +	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
> +	if (!cfqg)
> +		goto done;
> +
> +	cfqg->weight = blkcg->weight;
> +
> +	for (i = 0; i < 2; ++i)
> +		for (j = 0; j < 3; ++j)
> +			cfqg->service_trees[i][j] = CFQ_RB_ROOT;
> +	cfqg->service_tree_idle = CFQ_RB_ROOT;
> +	RB_CLEAR_NODE(&cfqg->rb_node);
> +
> +	/* Add group onto cgroup list */
> +	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
> +
> +	/* Add group on cfqd list */
> +	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
> +
> +done:
> +	css_put(&blkcg->css);
> +	return cfqg;
> +}
> +
> +/*
> + * Search for the cfq group current task belongs to. If create = 1, then also
> + * create the cfq group if it does not exist. request_queue lock must be held.

You might want to also note that if the creation fails, the root group
is used.

