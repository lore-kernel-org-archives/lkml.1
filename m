Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYAGRr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYAGRr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYAGRrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:47:19 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47247 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYAGRrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:47:18 -0500
Date: Mon, 7 Jan 2008 20:49:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net,
       Davide Libenzi <davidel@xmailserver.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
Message-ID: <20080107174908.GB14880@tv-sign.ru>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de> <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu> <20080105071205.GA28936@gondor.apana.org.au> <1199552016.31975.41.camel@lappy> <1199552476.31975.45.camel@lappy> <20080107172239.GA14880@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107172239.GA14880@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Oleg Nesterov wrote:
>
> Consider this "just for illustration" patch,
> 
> --- t/kernel/lockdep.c	2007-11-09 12:57:31.000000000 +0300
> +++ t/kernel/lockdep.c	2008-01-07 19:43:50.000000000 +0300
> @@ -1266,10 +1266,13 @@ check_deadlock(struct task_struct *curr,
>  	struct held_lock *prev;
>  	int i;
>  
> -	for (i = 0; i < curr->lockdep_depth; i++) {
> +	for (i = curr->lockdep_depth; --i >= 0; ) {
>  		prev = curr->held_locks + i;
>  		if (prev->class != next->class)
>  			continue;
> +
> +		if (prev->trylock == -1)
> +			return 2;
>  		/*
>  		 * Allow read-after-read recursion of the same
>  		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
> -------------------------------------------------------------------------
> 
> Now,
> 
> 	// trylock == -1
> 	#define	spin_mark_nested(l)	\
> 		lock_acquire(&(l)->dep_map, 0, -1, 0, 2, _THIS_IP_)
> 	#define	spin_unmark_nested(l)	\
> 		lock_release(&(l)->dep_map, 1, _THIS_IP_)
> 
> and ep_poll_safewake() can do:
> 
> 	/* Do really wake up now */
> 	spin_mark_nested(&wq->lock);
> 	wake_up(wq);
> 	spin_unmark_nested(&wq->lock);

I tested the patch above with the following code,

	wait_queue_head_t w1, w2, w3;

	init_waitqueue_head(&w1);
	init_waitqueue_head(&w2);
	init_waitqueue_head(&w3);

	local_irq_disable();
	spin_lock(&w1.lock);

	spin_mark_nested(&w2.lock);
	spin_lock(&w2.lock);

	spin_mark_nested(&w3.lock);
	wake_up(&w3);
	spin_unmark_nested(&w3.lock);

	spin_unlock(&w2.lock);
	spin_unmark_nested(&w2.lock);

	spin_unlock(&w1.lock);
	local_irq_enable();

seems to work. What do you think?

Oleg.

