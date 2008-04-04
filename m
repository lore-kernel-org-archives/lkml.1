Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYDDLtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYDDLtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYDDLtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:49:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22747 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbYDDLtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:49:07 -0400
Date: Fri, 4 Apr 2008 13:46:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fchecconi@gmail.com
Subject: Re: [PATCH] cfq-iosched: fix ioc_data leak
Message-ID: <20080404114616.GK29686@kernel.dk>
References: <20080404010105.GA52035@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404010105.GA52035@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04 2008, Fabio Checconi wrote:
> Hi,
>     stress testing module loading and unloading on a derived scheduler, I
> had crashes on cfq caused by what seemed to be an error in the caching of
> cic lookup results in the ioc_data field of io contexts.
> 
> As what's happening is a little bit involved (at least for me), I've put
> together some of the collected oopses with and without debug patches, the
> patches themselves, a script used to reproduce the problem and the .config
> used on kvm/qemu here, hoping that they can explain the problem better than
> words:
> 
>     http://feanor.sssup.it/~fabio/linux/cfq-ioc-data/
> 
> The patch below should fix the problem.
> 
> 
> Subject: cfq-iosched: do not leak ioc_data across iosched switches
> 
> When switching scheduler from cfq, cfq_exit_queue() does not clear
> ioc->ioc_data, leaving a dangling pointer that can deceive the following
> lookups when the iosched is switched back to cfq.  The pattern that can
> trigger that is the following:
> 
>     - elevator switch from cfq to something else;
>     - module unloading, with elv_unregister() that calls cfq_free_io_context()
>       on ioc freeing the cic (via the .trim op);
>     - module gets reloaded and the elevator switches back to cfq;
>     - reallocation of a cic at the same address as before (with a valid key).
> 
> To fix it just assign NULL to ioc_data in __cfq_exit_single_io_context(),
> that is called from the regular exit path and from the elevator switching
> code.  The only path that frees a cic and is not covered is the error handling
> one, but cic's freed in this way are never cached in ioc_data.
> 
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 0f962ec..67cd023 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1207,6 +1207,8 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
>  					 struct cfq_io_context *cic)
>  {
> +	struct io_context *ioc = cic->ioc;
> +
>  	list_del_init(&cic->queue_list);
>  
>  	/*
> @@ -1216,6 +1218,9 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
>  	cic->dead_key = (unsigned long) cic->key;
>  	cic->key = NULL;
>  
> +	if (ioc->ioc_data == cic)
> +		rcu_assign_pointer(ioc->ioc_data, NULL);
> +
>  	if (cic->cfqq[ASYNC]) {
>  		cfq_exit_cfqq(cfqd, cic->cfqq[ASYNC]);
>  		cic->cfqq[ASYNC] = NULL;
> @@ -1248,8 +1253,7 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
>   */
>  static void cfq_exit_io_context(struct io_context *ioc)
>  {
> -	rcu_assign_pointer(ioc->ioc_data, NULL);
>  	call_for_each_cic(ioc, cfq_exit_single_io_context);
>  }
>  
>  static struct cfq_io_context *
> @@ -1480,8 +1485,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
>  
>  	spin_lock_irqsave(&ioc->lock, flags);
>  
> -	if (ioc->ioc_data == cic)
> -		rcu_assign_pointer(ioc->ioc_data, NULL);
> +	BUG_ON(ioc->ioc_data == cic);
>  
>  	radix_tree_delete(&ioc->radix_root, (unsigned long) cfqd);
>  	hlist_del_rcu(&cic->cic_list);

Your analysis and fix looks correct, thanks a lot!

-- 
Jens Axboe

