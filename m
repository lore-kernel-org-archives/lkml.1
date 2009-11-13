Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZKMKsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZKMKsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZKMKsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:48:05 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60139 "EHLO kernel.dk"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbZKMKsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:48:03 -0500
Date: Fri, 13 Nov 2009 11:48:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 03/16] blkio: Keep queue on service tree until we
	expire   it
Message-ID: <20091113104808.GW8742@kernel.dk>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com> <1258068756-10766-4-git-send-email-vgoyal@redhat.com> <4e5e476b0911130239j3bfdef6q789fa78da36c6023@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911130239j3bfdef6q789fa78da36c6023@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13 2009, Corrado Zoccolo wrote:
> Hi Vivek,
> the following is probably not on a critical path, but maybe it can be
> written more efficiently.
> Now, it will cicle through all service trees multiple times, to
> retrieve the queues for the last one.
> What about having a cfq_for_each_queue that takes a function pointer
> and will apply it to all of them?

I thought the same when reading this. Or perhaps have a small bitmap
instead/with the counter to avoid looping around known empty groups.

I want to start merging the initial prep patches soon, so we can both
cut back on the size of your patchset while getting the simpler bits in.
Unfortunately I had to stop here, but with a few corrections it can be
merged too.

> 
> On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > +static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
> > +{
> > +       struct cfq_group *cfqg = &cfqd->root_group;
> > +       struct cfq_queue *cfqq;
> > +       int i, j;
> > +
> > +       if (!cfqd->rq_queued)
> > +               return NULL;
> > +
> > +       for (i = 0; i < 2; ++i) {
> > +               for (j = 0; j < 3; ++j) {
> > +                       cfqq = cfq_rb_first(&cfqg->service_trees[i][j]);
> > +                       if (cfqq)
> > +                               return cfqq;
> > +               }
> > +       }
> > +
> > +       cfqq = cfq_rb_first(&cfqg->service_tree_idle);
> > +       if (cfqq)
> > +               return cfqq;
> > +       return NULL;
> > +}
> > +
> >  /*
> >  * Get and set a new active queue for service.
> >  */
> > @@ -1590,16 +1633,8 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
> >  {
> >        struct cfq_queue *cfqq;
> >        int dispatched = 0;
> > -       int i, j;
> > -       struct cfq_group *cfqg = &cfqd->root_group;
> > -
> > -       for (i = 0; i < 2; ++i)
> > -               for (j = 0; j < 3; ++j)
> > -                       while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
> > -                               != NULL)
> > -                               dispatched += __cfq_forced_dispatch_cfqq(cfqq);
> >
> > -       while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
> > +       while ((cfqq = cfq_get_next_queue(cfqd)) != NULL)
> >                dispatched += __cfq_forced_dispatch_cfqq(cfqq);
> >
> >        cfq_slice_expired(cfqd, 0);
> > @@ -1770,13 +1805,14 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
> >        cfq_log_cfqq(cfqd, cfqq, "put_queue");
> >        BUG_ON(rb_first(&cfqq->sort_list));
> >        BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
> > -       BUG_ON(cfq_cfqq_on_rr(cfqq));
> >
> >        if (unlikely(cfqd->active_queue == cfqq)) {
> >                __cfq_slice_expired(cfqd, cfqq, 0);
> >                cfq_schedule_dispatch(cfqd);
> >        }
> >
> > +       BUG_ON(cfq_cfqq_on_rr(cfqq));
> > +
> >        kmem_cache_free(cfq_pool, cfqq);
> >  }
> >
> > --
> > 1.6.2.5
> >
> 
> 
> 
> Thanks
> Corrado

-- 
Jens Axboe

