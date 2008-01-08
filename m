Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYAHMLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYAHMLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 07:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYAHMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 07:11:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYAHML3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 07:11:29 -0500
Date: Tue, 8 Jan 2008 07:11:22 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] SUNRPC: spin svc_rqst initialization to its own
 function
Message-ID: <20080108071122.3a386a57@tleilax.poochiereds.net>
In-Reply-To: <18307.4037.415675.519239@notabene.brown>
References: <1199534542-3384-1-git-send-email-jlayton@redhat.com>
	<1199534542-3384-2-git-send-email-jlayton@redhat.com>
	<18307.4037.415675.519239@notabene.brown>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 16:53:09 +1100
Neil Brown <neilb@suse.de> wrote:

> On Saturday January 5, jlayton@redhat.com wrote:
> > Move the initialzation in __svc_create_thread that happens prior to
> > thread creation to a new function. Export the function to allow
> > services to have better control over the svc_rqst structs.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  include/linux/sunrpc/svc.h |    2 ++
> >  net/sunrpc/svc.c           |   43
> > +++++++++++++++++++++++++++++++------------ 2 files changed, 33
> > insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> > index 8531a70..5f07300 100644
> > --- a/include/linux/sunrpc/svc.h
> > +++ b/include/linux/sunrpc/svc.h
> > @@ -382,6 +382,8 @@ struct svc_procedure {
> >   */
> >  struct svc_serv *  svc_create(struct svc_program *, unsigned int,
> >  			      void (*shutdown)(struct svc_serv*));
> > +struct svc_rqst *svc_prepare_thread(struct svc_serv *serv,
> > +					struct svc_pool *pool);
> >  int		   svc_create_thread(svc_thread_fn, struct
> > svc_serv *); void		   svc_exit_thread(struct svc_rqst
> > *); struct svc_serv *  svc_create_pooled(struct svc_program *,
> > unsigned int, diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> > index fca17d0..b29ed43 100644
> > --- a/net/sunrpc/svc.c
> > +++ b/net/sunrpc/svc.c
> > @@ -538,23 +538,14 @@ svc_release_buffer(struct svc_rqst *rqstp)
> >  			put_page(rqstp->rq_pages[i]);
> >  }
> >  
> > -/*
> > - * Create a thread in the given pool.  Caller must hold BKL.
> > - * On a NUMA or SMP machine, with a multi-pool serv, the thread
> > - * will be restricted to run on the cpus belonging to the pool.
> > - */
> > -static int
> > -__svc_create_thread(svc_thread_fn func, struct svc_serv *serv,
> > -		    struct svc_pool *pool)
> > +struct svc_rqst *
> > +svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool)
> >  {
> >  	struct svc_rqst	*rqstp;
> > -	int		error = -ENOMEM;
> > -	int		have_oldmask = 0;
> > -	cpumask_t	oldmask;
> >  
> >  	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
> >  	if (!rqstp)
> > -		goto out;
> > +		goto out_enomem;
> >  
> >  	init_waitqueue_head(&rqstp->rq_wait);
> >  
> > @@ -570,6 +561,34 @@ __svc_create_thread(svc_thread_fn func, struct
> > svc_serv *serv, spin_unlock_bh(&pool->sp_lock);
> >  	rqstp->rq_server = serv;
> >  	rqstp->rq_pool = pool;
> > +	return rqstp;
> > +
> > +out_thread:
> > +	svc_exit_thread(rqstp);
> 
> I realise that the bug existed before your change, but calling
> svc_exit_thread at this point is not good.
> The 'goto out_thread' is *before* "pool->sp_nrthreads++", but
> svc_exit_thread does "pool->sp_nrthreads--;".  Not good.
> 
> As you are playing is this code, do you feel like fixing that error
> path??
> 
> 
> Otherwise, patch looks good.
> Acked-By: NeilBrown <neilb@suse.de>
> 
> Thanks,
> NeilBrown

Good catch. That bug will be a NULL pointer dereference since
rqstp->rq_pool isn't even set yet. There's a similar bug with
serv->sv_nrthreads too.

Still looking over your other comments, but I'll plan to post an
updated patchset that includes a fix for that.

-- 
Jeff Layton <jlayton@redhat.com>
