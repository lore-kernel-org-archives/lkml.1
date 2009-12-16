Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZLPLJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZLPLJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbZLPLJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:09:14 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:34593 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZLPLJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vgsnag1xU4N7sDSMo654bipn+phloFKxIKleuKBiWB92rJxc7ypg0M0LMf+29SLSNb
         A2BF5jRnBTUHDi0iM6Iq6ZHF5tQ67CX+f9SGDWDuAU9v6I/5tJDjbpXFCIVhCsSx1RY9
         ly8LaNSY8tbTAGHqRD7Ff94VgNjUCLs86rJsU=
MIME-Version: 1.0
In-Reply-To: <4B289C93.3070603@cn.fujitsu.com>
References: <4B289C93.3070603@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 12:09:10 +0100
Message-ID: <4e5e476b0912160309o100f538fo2462c8ac98dca844@mail.gmail.com>
Subject: Re: [PATCH] cfq: Remove useless css reference get
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gui,
maybe you can add a comment that cfq_find_alloc_cfqg can now be called
only under rcu_read_lock().

On Wed, Dec 16, 2009 at 9:38 AM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> There's no need to take css reference here, for the caller
> has already called rcu_read_lock() to prevent cgroup from
> being removed.
>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c  |   14 --------------
>  block/blk-cgroup.h  |    3 ---
>  block/cfq-iosched.c |    5 -----
>  3 files changed, 0 insertions(+), 22 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 1fa2654..cba28f4 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -23,20 +23,6 @@ static LIST_HEAD(blkio_list);
>  struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>
> -bool blkiocg_css_tryget(struct blkio_cgroup *blkcg)
> -{
> -       if (!css_tryget(&blkcg->css))
> -               return false;
> -       return true;
> -}
> -EXPORT_SYMBOL_GPL(blkiocg_css_tryget);
> -
> -void blkiocg_css_put(struct blkio_cgroup *blkcg)
> -{
> -       css_put(&blkcg->css);
> -}
> -EXPORT_SYMBOL_GPL(blkiocg_css_put);
> -
>  struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  {
>        return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 4d316df..84bf745 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -43,9 +43,6 @@ struct blkio_group {
>        unsigned long sectors;
>  };
>
> -extern bool blkiocg_css_tryget(struct blkio_cgroup *blkcg);
> -extern void blkiocg_css_put(struct blkio_cgroup *blkcg);
> -
>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
>  typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
>                                                unsigned int weight);
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e2f8046..5d6b427 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -958,10 +958,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>        struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>        unsigned int major, minor;
>
> -       /* Do we need to take this reference */
> -       if (!blkiocg_css_tryget(blkcg))
> -               return NULL;;
> -
>        cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
>        if (cfqg || !create)
>                goto done;
> @@ -992,7 +988,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>        hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
>
>  done:
> -       blkiocg_css_put(blkcg);
>        return cfqg;
>  }
>
> --
> 1.5.4.rc3

Thanks,
Corrado
