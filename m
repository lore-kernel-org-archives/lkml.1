Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZA2IBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZA2IBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZA2IBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:01:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbZA2IBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:01:34 -0500
Date: Thu, 29 Jan 2009 00:01:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: Re: [patch 1/2] epoll fix own poll()
Message-Id: <20090129000120.da7d249d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 12:54:38 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> 
> The follwing patch fixes a bug inside the epoll's f_op->poll() code, that
> returns POLLIN even though there are no actual ready monitored fds.
> The bug shows up if you add an epoll fd inside another fd container (poll,
> select, epoll).
> The problem is that callback-based wake ups used by epoll, does not carry
> (patches will follow, to fix this) any information about the events
> that actually happened. So the callback code, since it can't call the file*
> ->poll() inside the callback, chains the file* into a ready-list. So, suppose
> you added an fd with EPOLLOUT only, and some data shows up on the fd, the
> file* mapped by the fd will be added into the ready-list (via wakeup
> callback). During normal epoll_wait() use, this condition is sorted out
> at the time we're actually able to call the file*'s f_op->poll().
> Inside the old epoll's f_op->poll() though, only a quick check
> !list_empty(ready-list) was performed, and this could have led to reporting
> POLLIN even though no ready fds would show up at a following epoll_wait().
> In order to correctly report the ready status for an epoll fd, the ready-list
> must be checked to see if any really available fd+event would be ready in
> a following epoll_wait().
> Operation (calling f_op->poll() from inside f_op->poll()) that, like wake ups,
> must be handled with care because of the fact that epoll fds can be added
> to other epoll fds.

One reason why I break up paragraphs like this one when cleaning up
changelogs is so that I can actually read them :(

>  fs/eventpoll.c |  510 +++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 304 insertions(+), 206 deletions(-)

Holy cow man, this patch is HUGE!  I don't have a clue what it does nor
how it does it.  I'd be somewhat scared to merge it into 2.6.29.  How
serious is this bug?

Please use checkpatch?  The patch attempts to add a large amount of
crap, must notably lots of lines which for some reason start with
space-space-tab-tab-tab.  I doubt if you meant to do that (editor brain
damage), and checkpatch's main purpose is to tell you about things
which you didn't mean to do.

Minor nitpicks follow:

>
> ...
>
> +static int ep_scan_ready_list(struct eventpoll *ep,
> +			      int (*sproc)(struct eventpoll *,
> +					   struct list_head *, void *),
> +			      void *priv)
> +{
> +	int error, pwake = 0;
> +	unsigned long flags;
> +	struct epitem *epi, *nepi;
> +	struct list_head txlist;
> +
> +	INIT_LIST_HEAD(&txlist);

Could use

	LIST_HEAD(tx_list);

here

> +	/*
> +	 * We need to lock this because we could be hit by
> +	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
> +	 */
> +	mutex_lock(&ep->mtx);
> +
> +	/*
> +	 * Steal the ready list, and re-init the original one to the
> +	 * empty list. Also, set ep->ovflist to NULL so that events
> +	 * happening while looping w/out locks, are not lost. We cannot
> +	 * have the poll callback to queue directly on ep->rdllist,
> +	 * because we want the "sproc" callback to be able to do it
> +	 * in a lockless way.
> +	 */
> +	spin_lock_irqsave(&ep->lock, flags);
> +	list_splice(&ep->rdllist, &txlist);
> +	INIT_LIST_HEAD(&ep->rdllist);

list_splice_init()?

> +	ep->ovflist = NULL;
> +	spin_unlock_irqrestore(&ep->lock, flags);
> +
> +	/*
> +	 * Now call the callback function.
> +	 */
> +	error = (*sproc)(ep, &txlist, priv);
> +
> +	spin_lock_irqsave(&ep->lock, flags);
> +	/*
> +	 * During the time we spent inside the "sproc" callback, some
> +	 * other events might have been queued by the poll callback.
> +	 * We re-insert them inside the main ready-list here.
> +	 */
> +	for (nepi = ep->ovflist; (epi = nepi) != NULL;
> +	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
> +		/*
> +		 * We need to check if the item is already in the list.
> +		 * During the "sproc" callback execution time, items are
> +		 * queued into ->ovflist but the "txlist" might already
> +		 * contain them, and the list_splice() below takes care of them.
> +		 */
> +		if (!ep_is_linked(&epi->rdllink))
> +			list_add_tail(&epi->rdllink, &ep->rdllist);
> +	}
> +	/*
> +	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
> +	 * releasing the lock, events will be queued in the normal way inside
> +	 * ep->rdllist.
> +	 */
> +	ep->ovflist = EP_UNACTIVE_PTR;
> +
> +	/*
> +	 * Quickly re-inject items left on "txlist".
> +	 */
> +	list_splice(&txlist, &ep->rdllist);
> +
> +	if (!list_empty(&ep->rdllist)) {

Some places the code uses ep_is_linked(&ep->rdllist), other places it
uses open-coded list_empty().

ep_is_linked() is a fairly poor helper, really - it could be passed any
list_head at all.  I think that it would be better to do

static inline int ep_is_linked(struct epitem *ep)
{
	return !list_empty(&ep->rdllist);
}

and then use this consistently.

> +		/*
> +		 * Wake up (if active) both the eventpoll wait list and the ->poll()
> +		 * wait list (delayed after we release the lock).
> +		 */
> +		if (waitqueue_active(&ep->wq))
> +			wake_up_locked(&ep->wq);
> +		if (waitqueue_active(&ep->poll_wait))
> +			pwake++;
> +	}
> +	spin_unlock_irqrestore(&ep->lock, flags);
> +
> +	mutex_unlock(&ep->mtx);
> +
> +	/* We have to call this outside the lock */
> +	if (pwake)
> +		ep_poll_safewake(&ep->poll_wait);
> +
> +	return error;
> +}
>
> ...
>
> +static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head, void *priv)
> +{
> +	struct epitem *epi, *tmp;
> +
> +	list_for_each_entry_safe(epi, tmp, head, rdllink) {
> +		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
> +		    epi->event.events)
> +			return POLLIN | POLLRDNORM;
> +		else
> +			/*
> +			 * Item has been dropped into the ready list by the poll
> +			 * callback, but it's not actually ready, as far as
> +			 * caller requested events goes. We can remove it here.
> +			 */
> +			list_del_init(&epi->rdllink);

Please use braces around the comment and code when doing this. 
Otherwise readers can lose track of the fact that we're in a
single-statement leg of an `if' here.

> +	}
> +
> +	return 0;
> +}
> +
>
> ...
>
> -is_linked:
>  	/*
>  	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
>  	 * wait list.
> @@ -703,7 +863,7 @@
>  
>  	/* We have to call this outside the lock */
>  	if (pwake)
> -		ep_poll_safewake(&psw, &ep->poll_wait);
> +		ep_poll_safewake(&ep->poll_wait);
>  
>  	return 1;
>  }
> @@ -725,10 +885,9 @@
>  		add_wait_queue(whead, &pwq->wait);
>  		list_add_tail(&pwq->llink, &epi->pwqlist);
>  		epi->nwait++;
> -	} else {
> +	} else
>  		/* We have to signal that an error occurred */
>  		epi->nwait = -1;
> -	}

Please put the braces back?  The `if' clause has them, and most people
prefer that the `else' clause have them too.  Plus they nicely enclose
the comment as well, as described above.

>  }
>  
>
> ...
>

