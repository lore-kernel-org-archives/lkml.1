Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZKMKkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZKMKkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbZKMKj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:39:58 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:65195 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZKMKj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sDZzAHDWZlaGL5n15/DGZ1vOxG7H0FNx/6Dq6tm0KwtJrsLPjWmn3aGLPnb0WpHfQ4
         b72jo811C+ME4c/duZRpSP8jjAAePmlBJKS8BD0jPiWslWmFtM47lsK8GlCWKghhEHzw
         4vbykcnRWr9yP9cLmC6hdoIx6qKIEFo6TCE8U=
MIME-Version: 1.0
In-Reply-To: <1258068756-10766-4-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
	 <1258068756-10766-4-git-send-email-vgoyal@redhat.com>
Date: Fri, 13 Nov 2009 11:39:51 +0100
Message-ID: <4e5e476b0911130239j3bfdef6q789fa78da36c6023@mail.gmail.com>
Subject: Re: [PATCH 03/16] blkio: Keep queue on service tree until we expire 
	it
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
the following is probably not on a critical path, but maybe it can be
written more efficiently.
Now, it will cicle through all service trees multiple times, to
retrieve the queues for the last one.
What about having a cfq_for_each_queue that takes a function pointer
and will apply it to all of them?

On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> +static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
> +{
> +       struct cfq_group *cfqg = &cfqd->root_group;
> +       struct cfq_queue *cfqq;
> +       int i, j;
> +
> +       if (!cfqd->rq_queued)
> +               return NULL;
> +
> +       for (i = 0; i < 2; ++i) {
> +               for (j = 0; j < 3; ++j) {
> +                       cfqq = cfq_rb_first(&cfqg->service_trees[i][j]);
> +                       if (cfqq)
> +                               return cfqq;
> +               }
> +       }
> +
> +       cfqq = cfq_rb_first(&cfqg->service_tree_idle);
> +       if (cfqq)
> +               return cfqq;
> +       return NULL;
> +}
> +
>  /*
>  * Get and set a new active queue for service.
>  */
> @@ -1590,16 +1633,8 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
>  {
>        struct cfq_queue *cfqq;
>        int dispatched = 0;
> -       int i, j;
> -       struct cfq_group *cfqg = &cfqd->root_group;
> -
> -       for (i = 0; i < 2; ++i)
> -               for (j = 0; j < 3; ++j)
> -                       while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
> -                               != NULL)
> -                               dispatched += __cfq_forced_dispatch_cfqq(cfqq);
>
> -       while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
> +       while ((cfqq = cfq_get_next_queue(cfqd)) != NULL)
>                dispatched += __cfq_forced_dispatch_cfqq(cfqq);
>
>        cfq_slice_expired(cfqd, 0);
> @@ -1770,13 +1805,14 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
>        cfq_log_cfqq(cfqd, cfqq, "put_queue");
>        BUG_ON(rb_first(&cfqq->sort_list));
>        BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
> -       BUG_ON(cfq_cfqq_on_rr(cfqq));
>
>        if (unlikely(cfqd->active_queue == cfqq)) {
>                __cfq_slice_expired(cfqd, cfqq, 0);
>                cfq_schedule_dispatch(cfqd);
>        }
>
> +       BUG_ON(cfq_cfqq_on_rr(cfqq));
> +
>        kmem_cache_free(cfq_pool, cfqq);
>  }
>
> --
> 1.6.2.5
>



Thanks
Corrado
