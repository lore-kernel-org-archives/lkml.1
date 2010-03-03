Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0CCOdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:33:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0CCOdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:33:22 -0500
Date: Wed, 3 Mar 2010 09:33:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/1] io-controller: Add a new interface "policy" for IO
	Controller
Message-ID: <20100303143311.GA2866@redhat.com>
References: <4B8DFFD7.2000908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8DFFD7.2000908@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 02:21:11PM +0800, Gui Jianfeng wrote:
> Currently, IO Controller makes use of blkio.weight to assign weight for
> all devices. Here a new user interface "blkio.policy" is introduced to 
> assign different weights for different devices. blkio.weight becomes the
> default value for devices which are not configured by blkio.policy.
> 
> You can use the following format to assigned specific weight for a given
> device:
> #echo "major:minor weight" > blkio.policy
> 

Hi Gui,

Can we use a different name for per device weight file name than "blkio.policy".
May be "blkio.weight_device" or "blkio.weight_per_device" etc.

The reason being that "blkio.policy" name might be more suitable to switch
between differnt kind of BW control policies (proportional, max bandwidth etc),
once we implement some kind of max BW controlling policies also. So it
might be a good idea to not use that file name for specifying per device
weights.

Secondly, where is it useful. I mean do you have a scenario where you will
use it. Why I am asking is that we never had ioprio per device kind of
interface. ioprio was associated with task and was global and same on
every device in the system.

I am wondering, what are the scenarios where an application is more important
on one device and less important on other device to warrant different weights
on different devices.

Thanks
Vivek
 
 
> major:minor represents device number.
> 
> And you can remove a policy as following:
> #echo "major:minor 0" > blkio.policy
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c  |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  block/blk-cgroup.h  |    9 ++
>  block/cfq-iosched.c |    2 +-
>  3 files changed, 258 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index e7dbbaf..1fddb98 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/err.h>
>  #include "blk-cgroup.h"
> +#include <linux/genhd.h>
>  
>  static DEFINE_SPINLOCK(blkio_list_lock);
>  static LIST_HEAD(blkio_list);
> @@ -23,6 +24,12 @@ static LIST_HEAD(blkio_list);
>  struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>  
> +static inline void policy_insert_node(struct blkio_cgroup *blkcg,
> +				      struct io_policy_node *pn);
> +static inline void policy_delete_node(struct io_policy_node *pn);
> +static struct io_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
> +						 dev_t dev);
> +
>  bool blkiocg_css_tryget(struct blkio_cgroup *blkcg)
>  {
>  	if (!css_tryget(&blkcg->css))
> @@ -142,6 +149,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  	struct blkio_group *blkg;
>  	struct hlist_node *n;
>  	struct blkio_policy_type *blkiop;
> +	struct io_policy_node *pn;
>  
>  	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
>  		return -EINVAL;
> @@ -150,7 +158,13 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  	spin_lock(&blkio_list_lock);
>  	spin_lock_irq(&blkcg->lock);
>  	blkcg->weight = (unsigned int)val;
> +
>  	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		pn = policy_search_node(blkcg, blkg->dev);
> +
> +		if (pn)
> +			continue;
> +
>  		list_for_each_entry(blkiop, &blkio_list, list)
>  			blkiop->ops.blkio_update_group_weight_fn(blkg,
>  					blkcg->weight);
> @@ -199,8 +213,235 @@ void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>  #endif
>  
> +static int check_dev_num(dev_t dev)
> +{
> +	int part = 0;
> +	struct gendisk *disk;
> +
> +	disk = get_gendisk(dev, &part);
> +
> +	if (!disk || part)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int policy_parse_and_set(char *buf, struct io_policy_node *newpn)
> +{
> +	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
> +	int ret;
> +	unsigned long major, minor, temp;
> +	int i = 0;
> +	dev_t dev;
> +
> +	memset(s, 0, sizeof(s));
> +
> +	while ((p = strsep(&buf, " ")) != NULL) {
> +		if (!*p)
> +			continue;
> +
> +		s[i++] = p;
> +
> +		/* Prevent from inputing too many things */
> +		if (i == 3)
> +			break;
> +	}
> +
> +	if (i != 2)
> +		return -EINVAL;
> +
> +	p = strsep(&s[0], ":");
> +
> +	if (p != NULL)
> +		major_s = p;
> +	else
> +		return -EINVAL;
> +
> +	minor_s = s[0];
> +
> +	if (!minor_s)
> +		return -EINVAL;
> +
> +	ret = strict_strtoul(major_s, 10, &major);
> +	if (ret)
> +		return -EINVAL;
> +
> +	ret = strict_strtoul(minor_s, 10, &minor);
> +	if (ret)
> +		return -EINVAL;
> +
> +	dev = MKDEV(major, minor);
> +
> +	ret = check_dev_num(dev);
> +	if (ret)
> +		return ret;
> +
> +	newpn->dev = dev;
> +
> +	if (s[1] == NULL)
> +		return -EINVAL;
> +
> +	ret = strict_strtoul(s[1], 10, &temp);
> +	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
> +	    temp > BLKIO_WEIGHT_MAX)
> +		return -EINVAL;
> +
> +	newpn->weight =  temp;
> +
> +	return 0;
> +}
> +
> +unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
> +				    dev_t dev)
> +{
> +	struct io_policy_node *pn;
> +
> +	pn = policy_search_node(blkcg, dev);
> +
> +	if (pn)
> +		return pn->weight;
> +	else
> +		return blkcg->weight;
> +}
> +EXPORT_SYMBOL_GPL(blkcg_get_weight);
> +
> +static inline void policy_insert_node(struct blkio_cgroup *blkcg,
> +				      struct io_policy_node *pn)
> +{
> +	list_add(&pn->node, &blkcg->policy_list);
> +}
> +
> +/* Must be called with blkcg->lock held */
> +static inline void policy_delete_node(struct io_policy_node *pn)
> +{
> +	list_del(&pn->node);
> +}
> +
> +/* Must be called with blkcg->lock held */
> +static struct io_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
> +						 dev_t dev)
> +{
> +	struct io_policy_node *pn;
> +
> +	if (list_empty(&blkcg->policy_list))
> +		return NULL;
> +
> +	list_for_each_entry(pn, &blkcg->policy_list, node) {
> +		if (pn->dev == dev)
> +			return pn;
> +	}
> +
> +	return NULL;
> +}
> +
> +
> +static int blkiocg_policy_write(struct cgroup *cgrp, struct cftype *cft,
> +				const char *buffer)
> +{
> +	int ret = 0;
> +	char *buf;
> +	struct io_policy_node *newpn, *pn;
> +	struct blkio_cgroup *blkcg;
> +	struct blkio_group *blkg;
> +	int keep_newpn = 0;
> +	struct hlist_node *n;
> +	struct blkio_policy_type *blkiop;
> +
> +	buf = kstrdup(buffer, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	newpn = kzalloc(sizeof(*newpn), GFP_KERNEL);
> +	if (!newpn) {
> +		ret = -ENOMEM;
> +		goto free_buf;
> +	}
> +
> +	ret = policy_parse_and_set(buf, newpn);
> +	if (ret)
> +		goto free_newpn;
> +
> +	blkcg = cgroup_to_blkio_cgroup(cgrp);
> +
> +	spin_lock_irq(&blkcg->lock);
> +
> +	pn = policy_search_node(blkcg, newpn->dev);
> +	if (!pn) {
> +		if (newpn->weight != 0) {
> +			policy_insert_node(blkcg, newpn);
> +			keep_newpn = 1;
> +		}
> +		spin_unlock_irq(&blkcg->lock);
> +		goto update_io_group;
> +	}
> +
> +	if (newpn->weight == 0) {
> +		/* weight == 0 means deleteing a policy */
> +		policy_delete_node(pn);
> +		spin_unlock_irq(&blkcg->lock);
> +		goto update_io_group;
> +	}
> +	spin_unlock_irq(&blkcg->lock);
> +
> +	pn->weight = newpn->weight;
> +
> +update_io_group:
> +	/* update weight for each cfqg */
> +	spin_lock(&blkio_list_lock);
> +	spin_lock_irq(&blkcg->lock);
> +
> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		if (newpn->dev == blkg->dev) {
> +			list_for_each_entry(blkiop, &blkio_list, list)
> +				blkiop->ops.blkio_update_group_weight_fn(blkg,
> +						newpn->weight ?
> +						newpn->weight :
> +						blkcg->weight);
> +		}
> +	}
> +
> +	spin_unlock_irq(&blkcg->lock);
> +	spin_unlock(&blkio_list_lock);
> +
> +free_newpn:
> +	if (!keep_newpn)
> +		kfree(newpn);
> +free_buf:
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static int blkiocg_policy_read(struct cgroup *cgrp, struct cftype *cft,
> +			       struct seq_file *m)
> +{
> +	struct blkio_cgroup *blkcg;
> +	struct io_policy_node *pn;
> +
> +	blkcg = cgroup_to_blkio_cgroup(cgrp);
> +
> +	if (list_empty(&blkcg->policy_list))
> +		goto out;
> +
> +	seq_printf(m, "dev\tweight\n");
> +
> +	spin_lock_irq(&blkcg->lock);
> +	list_for_each_entry(pn, &blkcg->policy_list, node) {
> +		seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
> +			   MINOR(pn->dev), pn->weight);
> +	}
> +	spin_unlock_irq(&blkcg->lock);
> +out:
> +	return 0;
> +}
> +
>  struct cftype blkio_files[] = {
>  	{
> +		.name = "policy",
> +		.read_seq_string = blkiocg_policy_read,
> +		.write_string = blkiocg_policy_write,
> +		.max_write_len = 256,
> +	},
> +	{
>  		.name = "weight",
>  		.read_u64 = blkiocg_weight_read,
>  		.write_u64 = blkiocg_weight_write,
> @@ -234,6 +475,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  	struct blkio_group *blkg;
>  	void *key;
>  	struct blkio_policy_type *blkiop;
> +	struct io_policy_node *pn, *pntmp;
>  
>  	rcu_read_lock();
>  remove_entry:
> @@ -264,7 +506,12 @@ remove_entry:
>  		blkiop->ops.blkio_unlink_group_fn(key, blkg);
>  	spin_unlock(&blkio_list_lock);
>  	goto remove_entry;
> +
>  done:
> +	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
> +		policy_delete_node(pn);
> +		kfree(pn);
> +	}
>  	free_css_id(&blkio_subsys, &blkcg->css);
>  	rcu_read_unlock();
>  	kfree(blkcg);
> @@ -294,6 +541,7 @@ done:
>  	spin_lock_init(&blkcg->lock);
>  	INIT_HLIST_HEAD(&blkcg->blkg_list);
>  
> +	INIT_LIST_HEAD(&blkcg->policy_list);
>  	return &blkcg->css;
>  }
>  
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 4d316df..0551aa1 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -22,6 +22,7 @@ struct blkio_cgroup {
>  	unsigned int weight;
>  	spinlock_t lock;
>  	struct hlist_head blkg_list;
> +	struct list_head policy_list; /* list of io_policy_node */
>  };
>  
>  struct blkio_group {
> @@ -43,8 +44,16 @@ struct blkio_group {
>  	unsigned long sectors;
>  };
>  
> +struct io_policy_node {
> +	struct list_head node;
> +	dev_t dev;
> +	unsigned int weight;
> +};
> +
>  extern bool blkiocg_css_tryget(struct blkio_cgroup *blkcg);
>  extern void blkiocg_css_put(struct blkio_cgroup *blkcg);
> +extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
> +				     dev_t dev);
>  
>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
>  typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 023f4e6..3d0dea1 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -963,7 +963,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	if (!cfqg)
>  		goto done;
>  
> -	cfqg->weight = blkcg->weight;
>  	for_each_cfqg_st(cfqg, i, j, st)
>  		*st = CFQ_RB_ROOT;
>  	RB_CLEAR_NODE(&cfqg->rb_node);
> @@ -980,6 +979,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>  	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>  					MKDEV(major, minor));
> +	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
>  
>  	/* Add group on cfqd list */
>  	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
> -- 
> 1.5.4.rc3
