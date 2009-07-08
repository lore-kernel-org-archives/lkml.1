Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZGHOGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZGHOGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZGHOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:06:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZGHOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:06:40 -0400
Date: Wed, 8 Jul 2009 10:04:11 -0400
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
Subject: Re: [PATCH] io-controller: Get rid of css id from io cgroup
Message-ID: <20090708140411.GD24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-10-git-send-email-vgoyal@redhat.com> <4A51657B.7000008@cn.fujitsu.com> <20090706141650.GD8279@redhat.com> <4A52A77E.8050203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52A77E.8050203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:40:14AM +0800, Gui Jianfeng wrote:
> Get rid of css id from io cgroup since it's nothing
> more than keeping track of iocg. An alternative is
> caching iocg pointer in io group, just remove the
> complexity.
> 

Gui, one advantage of using css_id is that we store only 2 bytes of id
instead of 8 bytes of iocg* pointer (on 64bit). So saving of 6 bytes per
group. May be it is not a bad idea to keep the usage of css id around
because anyway we don't seem to gain much by getting rid of it.

So for the time being I tend to think that lets continue using css id.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   36 ++++++++++++------------------------
>  block/elevator-fq.h |    2 +-
>  2 files changed, 13 insertions(+), 25 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 7c83d1e..f499b54 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -191,25 +191,19 @@ static inline struct io_group *iog_parent(struct io_group *iog)
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
>  static void io_group_path(struct io_group *iog, char *buf, int buflen)
>  {
> -	unsigned short id = iog->iocg_id;
> -	struct cgroup_subsys_state *css;
> +	struct io_cgroup *iocg;
> +	int ret;
>  
>  	rcu_read_lock();
>  
> -	if (!id)
> +	iocg = iog->iocg;
> +	if (!iocg)
>  		goto out;
>  
> -	css = css_lookup(&io_subsys, id);
> -	if (!css)
> -		goto out;
> -
> -	if (!css_tryget(css))
> +	ret = cgroup_path(iocg->css.cgroup, buf, buflen);
> +	if (ret)
>  		goto out;
>  
> -	cgroup_path(css->cgroup, buf, buflen);
> -
> -	css_put(css);
> -
>  	rcu_read_unlock();
>  	return;
>  out:
> @@ -1847,7 +1841,6 @@ struct cgroup_subsys io_subsys = {
>  	.destroy = iocg_destroy,
>  	.populate = iocg_populate,
>  	.subsys_id = io_subsys_id,
> -	.use_id = 1,
>  };
>  
>  static inline unsigned int iog_weight(struct io_group *iog)
> @@ -1890,7 +1883,7 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
>  		if (!iog)
>  			goto cleanup;
>  
> -		iog->iocg_id = css_id(&iocg->css);
> +		iog->iocg = iocg;
>  
>  		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>  		iog->dev = MKDEV(major, minor);
> @@ -2201,7 +2194,7 @@ static struct io_group *io_alloc_root_group(struct request_queue *q,
>  	spin_lock_irq(&iocg->lock);
>  	rcu_assign_pointer(iog->key, key);
>  	hlist_add_head_rcu(&iog->group_node, &iocg->group_data);
> -	iog->iocg_id = css_id(&iocg->css);
> +	iog->iocg = iocg;
>  	spin_unlock_irq(&iocg->lock);
>  
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
> @@ -2397,7 +2390,7 @@ remove_entry:
>  			  group_node);
>  	efqd = rcu_dereference(iog->key);
>  	hlist_del_rcu(&iog->group_node);
> -	iog->iocg_id = 0;
> +	iog->iocg = NULL;
>  	spin_unlock_irqrestore(&iocg->lock, flags);
>  
>  	spin_lock_irqsave(efqd->queue->queue_lock, flags);
> @@ -2411,7 +2404,6 @@ done:
>  		kfree(pn);
>  	}
>  
> -	free_css_id(&io_subsys, &iocg->css);
>  	rcu_read_unlock();
>  	BUG_ON(!hlist_empty(&iocg->group_data));
>  	kfree(iocg);
> @@ -2427,20 +2419,16 @@ static void io_group_check_and_destroy(struct elv_fq_data *efqd,
>  {
>  	struct io_cgroup *iocg;
>  	unsigned long flags;
> -	struct cgroup_subsys_state *css;
>  
>  	rcu_read_lock();
>  
> -	css = css_lookup(&io_subsys, iog->iocg_id);
> -
> -	if (!css)
> +	iocg = iog->iocg;
> +	if (!iocg)
>  		goto out;
>  
> -	iocg = container_of(css, struct io_cgroup, css);
> -
>  	spin_lock_irqsave(&iocg->lock, flags);
>  
> -	if (iog->iocg_id) {
> +	if (iog->iocg) {
>  		hlist_del_rcu(&iog->group_node);
>  		__io_destroy_group(efqd, iog);
>  	}
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index f089a55..75fee82 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -251,7 +251,7 @@ struct io_group {
>  	unsigned int busy_rt_queues;
>  
>  	int deleting;
> -	unsigned short iocg_id;
> +	struct io_cgroup *iocg;
>  
>  	/* The device MKDEV(major, minor), this group has been created for */
>  	dev_t	dev;
> -- 
> 1.5.4.rc3 
> 
