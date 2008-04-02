Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYDBNhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYDBNhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYDBNhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:37:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43971 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYDBNhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:37:40 -0400
Date: Wed, 2 Apr 2008 06:32:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402133232.GE2813@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <1207133961.8514.768.camel@twins> <20080402113327.GC41073@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402113327.GC41073@gandalf.sssup.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 01:33:27PM +0200, Fabio Checconi wrote:
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed, Apr 02, 2008 12:59:21PM +0200
> >
> > On Wed, 2008-04-02 at 03:55 -0700, Paul E. McKenney wrote:
> > > On Wed, Apr 02, 2008 at 09:28:46AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > On Wed, Apr 02 2008, Pekka J Enberg wrote:
> > > > > > On Wed, 2 Apr 2008, Jens Axboe wrote:
> > > > > > > Good catch, I wonder why it didn't complain in my testing. I've added a
> > > > > > > patch to fix that, please see it here:
> > > > > > 
> > > > > > You probably don't have kmemcheck in your kernel ;-)
> > > > > 
> > > > > Ehm no, you are right :)
> > > > 
> > > > ... and you can get kmemcheck by testing on x86.git/latest:
> > > > 
> > > >   http://people.redhat.com/mingo/x86.git/README
> > > > 
> > > > ;-)
> > > 
> > > I will check this when I get back to some bandwidth -- but in the meantime,
> > > does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> > > newly-freed items in that case, as long as you did rcu_read_lock()
> > > before gaining a reference to them and don't hold the reference past
> > > the matching rcu_read_unlock().
> > 
> > I don't think it does.
> > 
> > It would have to register an call_rcu callback itself in order to mark
> > it freed - and handle the race with the object being handed out again.
> 
> I had the same problem while debugging a cfq-derived i/o scheduler,
> and I found nothing preventing the reuse of the freed memory.
> The patch below seemed to fix the logic.

Looks good to me from a strictly RCU viewpoint -- I must confess great
ignorance of the CFQ code.  :-/

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 0f962ec..f26da2b 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1143,24 +1143,37 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
>  }
> 
>  /*
> - * Call func for each cic attached to this ioc. Returns number of cic's seen.
> + * Call func for each cic attached to this ioc.
>   */
> -static unsigned int
> +static void
>  call_for_each_cic(struct io_context *ioc,
>  		  void (*func)(struct io_context *, struct cfq_io_context *))
>  {
>  	struct cfq_io_context *cic;
>  	struct hlist_node *n;
> -	int called = 0;
> 
>  	rcu_read_lock();
> -	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list) {
> +	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list)
>  		func(ioc, cic);
> -		called++;
> -	}
>  	rcu_read_unlock();
> +}
> +
> +static void cfq_cic_free_rcu(struct rcu_head *head)
> +{
> +	struct cfq_io_context *cic;
> +
> +	cic = container_of(head, struct cfq_io_context, rcu_head);
> +
> +	kmem_cache_free(cfq_ioc_pool, cic);
> +	elv_ioc_count_dec(ioc_count);
> +
> +	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> +		complete(ioc_gone);
> +}
> 
> -	return called;
> +static void cfq_cic_free(struct cfq_io_context *cic)
> +{
> +	call_rcu(&cic->rcu_head, cfq_cic_free_rcu);
>  }
> 
>  static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
> @@ -1174,24 +1187,18 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
>  	hlist_del_rcu(&cic->cic_list);
>  	spin_unlock_irqrestore(&ioc->lock, flags);
> 
> -	kmem_cache_free(cfq_ioc_pool, cic);
> +	cfq_cic_free(cic);
>  }
> 
>  static void cfq_free_io_context(struct io_context *ioc)
>  {
> -	int freed;
> -
>  	/*
> -	 * ioc->refcount is zero here, so no more cic's are allowed to be
> -	 * linked into this ioc. So it should be ok to iterate over the known
> -	 * list, we will see all cic's since no new ones are added.
> +	 * ioc->refcount is zero here, or we are called from elv_unregister(),
> +	 * so no more cic's are allowed to be linked into this ioc.  So it
> +	 * should be ok to iterate over the known list, we will see all cic's
> +	 * since no new ones are added.
>  	 */
> -	freed = call_for_each_cic(ioc, cic_free_func);
> -
> -	elv_ioc_count_mod(ioc_count, -freed);
> -
> -	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> -		complete(ioc_gone);
> +	call_for_each_cic(ioc, cic_free_func);
>  }
> 
>  static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> @@ -1458,15 +1465,6 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
>  	return cfqq;
>  }
> 
> -static void cfq_cic_free(struct cfq_io_context *cic)
> -{
> -	kmem_cache_free(cfq_ioc_pool, cic);
> -	elv_ioc_count_dec(ioc_count);
> -
> -	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> -		complete(ioc_gone);
> -}
> -
>  /*
>   * We drop cfq io contexts lazily, so we may find a dead one.
>   */
> @@ -2138,7 +2136,7 @@ static int __init cfq_slab_setup(void)
>  	if (!cfq_pool)
>  		goto fail;
> 
> -	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, SLAB_DESTROY_BY_RCU);
> +	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, 0);
>  	if (!cfq_ioc_pool)
>  		goto fail;
> 
> @@ -2286,7 +2284,6 @@ static void __exit cfq_exit(void)
>  	smp_wmb();
>  	if (elv_ioc_count_read(ioc_count))
>  		wait_for_completion(ioc_gone);
> -	synchronize_rcu();
>  	cfq_slab_kill();
>  }
> 
> diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
> index 1b4ccf2..50e448c 100644
> --- a/include/linux/iocontext.h
> +++ b/include/linux/iocontext.h
> @@ -54,6 +54,8 @@ struct cfq_io_context {
> 
>  	void (*dtor)(struct io_context *); /* destructor */
>  	void (*exit)(struct io_context *); /* called on task exit */
> +
> +	struct rcu_head rcu_head;
>  };
> 
>  /*
