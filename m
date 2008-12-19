Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYLSQxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYLSQxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYLSQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:52:55 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39486 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYLSQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:52:54 -0500
Date: Fri, 19 Dec 2008 10:52:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
	doing very slow work items [ver #41]
Message-ID: <20081219165252.GA15773@us.ibm.com>
References: <10438.1229686960@redhat.com> <20081219041401.GA29316@us.ibm.com> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk> <10752.1229688754@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10752.1229688754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> David Howells <dhowells@redhat.com> wrote:
> 
> > I guess I need to stick a comment in slow_work_enqueue() to detail this,
> > though the comments in slow_work_execute() do talk about it.
> 
> How about this:
> 
> diff --git a/kernel/slow-work.c b/kernel/slow-work.c
> index f638f36..adf9b78 100644
> --- a/kernel/slow-work.c
> +++ b/kernel/slow-work.c
> @@ -195,12 +195,32 @@ int slow_work_enqueue(struct slow_work *work)
>  	BUG_ON(!work->ops);
>  	BUG_ON(!work->ops->get_ref);
> 
> +	/* when honouring an enqueue request, we only promise that we will run
> +	 * the work function in the future; we do not promise to run it once
> +	 * per enqueue request

That, there, is precisely what i needed to hear :)

> +	 * we use the PENDING bit to merge together repeat requests without
> +	 * having to disable IRQs and take the spinlock, whilst still
> +	 * maintaining our promise
> +	 */
>  	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
>  		spin_lock_irqsave(&slow_work_queue_lock, flags);
> 
> +		/* we promise that we will not attempt to execute the work
> +		 * function in more than one thread simultaneously
> +		 *
> +		 * this, however, leaves us with a problem if we're asked to
> +		 * enqueue the work whilst someone is executing the work
> +		 * function as simply queueing the work immediately means that
> +		 * another thread may try executing it whilst it is already
> +		 * under execution
> +		 *
> +		 * to deal with this, we set the ENQ_DEFERRED bit instead of
> +		 * enqueueing, and the thread currently executing the work
> +		 * function will enqueue the work item when the work function
> +		 * returns and it has cleared the EXECUTING bit
> +		 */
>  		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
> -			/* can't queue lest we cause multiple threads to try
> -			 * executing this item, so defer for later */
>  			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
>  		} else {
>  			if (work->ops->get_ref(work) < 0)
> 
> David

thanks,
-serge
