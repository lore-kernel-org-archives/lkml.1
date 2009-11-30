Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZK3Xz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZK3Xz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZK3Xz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:55:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZK3Xz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:55:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZxXQ4c2WXRq8pdY9YpQ8vePOBBNaZeoE9e0I517+ETj18SN/Ifj2BW0C6Ru4EE7sD
	Le0NdNdYjOyw3/FRrHQyg==
MIME-Version: 1.0
In-Reply-To: <1259549968-10369-6-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> 
	<1259549968-10369-6-git-send-email-vgoyal@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Tue, 1 Dec 2009 05:25:36 +0530
Message-ID: <af41c7c40911301555s48553e53o5e9998fe5c160f75@mail.gmail.com>
Subject: Re: [PATCH 05/21] blkio: Introduce the root service tree for cfq 
	groups
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 8:29 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o So far we just had one cfq_group in cfq_data. To create space for more than
>  one cfq_group, we need to have a service tree of groups where all the groups
>  can be queued if they have active cfq queues backlogged in these.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 133 insertions(+), 3 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a0d0a83..0a284be 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -77,8 +77,9 @@ struct cfq_rb_root {
>        struct rb_root rb;
>        struct rb_node *left;
>        unsigned count;
> +       u64 min_vdisktime;
>  };
> -#define CFQ_RB_ROOT    (struct cfq_rb_root) { RB_ROOT, NULL, 0, }
> +#define CFQ_RB_ROOT    (struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
>
>  /*
>  * Per process-grouping structure
> @@ -156,6 +157,16 @@ enum wl_type_t {
>
>  /* This is per cgroup per device grouping structure */
>  struct cfq_group {
> +       /* group service_tree member */
> +       struct rb_node rb_node;
> +
> +       /* group service_tree key */
> +       u64 vdisktime;
> +       bool on_st;
> +
> +       /* number of cfqq currently on this group */
> +       int nr_cfqq;
> +
>        /*
>         * rr lists of queues with requests, onle rr for each priority class.
>         * Counts are embedded in the cfq_rb_root
> @@ -169,6 +180,8 @@ struct cfq_group {
>  */
>  struct cfq_data {
>        struct request_queue *queue;
> +       /* Root service tree for cfq_groups */
> +       struct cfq_rb_root grp_service_tree;
>        struct cfq_group root_group;
>
>        /*
> @@ -251,6 +264,9 @@ static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>                                            enum wl_type_t type,
>                                            struct cfq_data *cfqd)
>  {
> +       if (!cfqg)
> +               return NULL;
> +
>        if (prio == IDLE_WORKLOAD)
>                return &cfqg->service_tree_idle;
>
> @@ -587,6 +603,17 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
>        return NULL;
>  }
>
> +static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
> +{
> +       if (!root->left)
> +               root->left = rb_first(&root->rb);
> +
> +       if (root->left)
> +               return rb_entry(root->left, struct cfq_group, rb_node);

Can you please define a cfqg_entry macro and reuse that at different
places in the code?
#define cfqg_entry(ptr)   rb_entry(ptr, struct cfq_group, rb_node)

> +
> +       return NULL;
> +}
> +
>  static void rb_erase_init(struct rb_node *n, struct rb_root *root)
>  {
>        rb_erase(n, root);
> @@ -643,6 +670,83 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>                   cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>  }
>
> +static inline s64
> +cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
> +{
> +       return cfqg->vdisktime - st->min_vdisktime;
> +}
> +
> +static void
> +__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
> +{
> +       struct rb_node **node = &st->rb.rb_node;
> +       struct rb_node *parent = NULL;
> +       struct cfq_group *__cfqg;
> +       s64 key = cfqg_key(st, cfqg);
> +       int left = 1;
> +
> +       while (*node != NULL) {
> +               parent = *node;
> +               __cfqg = rb_entry(parent, struct cfq_group, rb_node);
> +
> +               if (key < cfqg_key(st, __cfqg))
> +                       node = &parent->rb_left;
> +               else {
> +                       node = &parent->rb_right;
> +                       left = 0;
> +               }
> +       }
> +
> +       if (left)
> +               st->left = &cfqg->rb_node;
> +
> +       rb_link_node(&cfqg->rb_node, parent, node);
> +       rb_insert_color(&cfqg->rb_node, &st->rb);
> +}
> +
> +static void
> +cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +{
> +       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +       struct cfq_group *__cfqg;
> +       struct rb_node *n;
> +
> +       cfqg->nr_cfqq++;
> +       if (cfqg->on_st)
> +               return;
> +
> +       /*
> +        * Currently put the group at the end. Later implement something
> +        * so that groups get lesser vtime based on their weights, so that
> +        * if group does not loose all if it was not continously backlogged.
> +        */
> +       n = rb_last(&st->rb);
> +       if (n) {
> +               __cfqg = rb_entry(n, struct cfq_group, rb_node);
> +               cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
> +       } else
> +               cfqg->vdisktime = st->min_vdisktime;
> +
> +       __cfq_group_service_tree_add(st, cfqg);
> +       cfqg->on_st = true;
> +}
> +
> +static void
> +cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +{
> +       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +
> +       BUG_ON(cfqg->nr_cfqq < 1);
> +       cfqg->nr_cfqq--;
> +       /* If there are other cfq queues under this group, don't delete it */
> +       if (cfqg->nr_cfqq)
> +               return;
> +
> +       cfqg->on_st = false;
> +       if (!RB_EMPTY_NODE(&cfqg->rb_node))
> +               cfq_rb_erase(&cfqg->rb_node, st);
> +}
> +
>  /*
>  * The cfqd->service_trees holds all pending cfq_queue's that have
>  * requests waiting to be processed. It is sorted in the order that
> @@ -725,6 +829,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        rb_link_node(&cfqq->rb_node, parent, p);
>        rb_insert_color(&cfqq->rb_node, &service_tree->rb);
>        service_tree->count++;
> +       cfq_group_service_tree_add(cfqd, cfqq->cfqg);
>  }
>
>  static struct cfq_queue *
> @@ -835,6 +940,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>                cfqq->p_root = NULL;
>        }
>
> +       cfq_group_service_tree_del(cfqd, cfqq->cfqg);
>        BUG_ON(!cfqd->busy_queues);
>        cfqd->busy_queues--;
>  }
> @@ -1111,6 +1217,9 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
>        if (!cfqd->rq_queued)
>                return NULL;
>
> +       /* There is nothing to dispatch */
> +       if (!service_tree)
> +               return NULL;
>        if (RB_EMPTY_ROOT(&service_tree->rb))
>                return NULL;
>        return cfq_rb_first(service_tree);
> @@ -1480,6 +1589,12 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>        unsigned count;
>        struct cfq_rb_root *st;
>
> +       if (!cfqg) {
> +               cfqd->serving_prio = IDLE_WORKLOAD;
> +               cfqd->workload_expires = jiffies + 1;
> +               return;
> +       }
> +
>        /* Choose next priority. RT > BE > IDLE */
>        if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
>                cfqd->serving_prio = RT_WORKLOAD;
> @@ -1538,10 +1653,21 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>        cfqd->noidle_tree_requires_idle = false;
>  }
>
> +static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
> +{
> +       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +
> +       if (RB_EMPTY_ROOT(&st->rb))
> +               return NULL;
> +       return cfq_rb_first_group(st);
> +}
> +
>  static void cfq_choose_cfqg(struct cfq_data *cfqd)
>  {
> -       cfqd->serving_group = &cfqd->root_group;
> -       choose_service_tree(cfqd, &cfqd->root_group);
> +       struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
> +
> +       cfqd->serving_group = cfqg;
> +       choose_service_tree(cfqd, cfqg);
>  }
>
>  /*
> @@ -3017,10 +3143,14 @@ static void *cfq_init_queue(struct request_queue *q)
>        if (!cfqd)
>                return NULL;
>
> +       /* Init root service tree */
> +       cfqd->grp_service_tree = CFQ_RB_ROOT;
> +
>        /* Init root group */
>        cfqg = &cfqd->root_group;
>        for_each_cfqg_st(cfqg, i, j, st)
>                *st = CFQ_RB_ROOT;
> +       RB_CLEAR_NODE(&cfqg->rb_node);
>
>        /*
>         * Not strictly needed (since RB_ROOT just clears the node and we
> --
> 1.6.2.5
>
>
