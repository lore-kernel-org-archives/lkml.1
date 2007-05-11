Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbXEKN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbXEKN4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXEKN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:56:15 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:35034 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXEKN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fOpeLGzaG5aDpKzl0TI2mRGnqX1jzP3mmSNl+pFqn28KpErl1CzHFDQArU1MeP2XvAJLEONh7dxns9bw6sp6uKtE8WimAzwaEYhVt1G3Li6eygiwn6gDOMxENUbRpP3lnydlSxGsHxRo01cPJ/PlJzzgnf6nMXdWweStO5Gbvv0=
Message-ID: <464475EB.3000408@gmail.com>
Date: Fri, 11 May 2007 15:55:55 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru>
In-Reply-To: <20070503204226.GA212@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

Oleg Nesterov wrote:
> +	/*
> +	 * Ensure that we get the right work->data if we see the
> +	 * result of list_add() below, see try_to_grab_pending().
> +	 */
> +	smp_wmb();

I don't think we need this

> +	if (!list_empty(&work->entry)) {
> +		/*
> +		 * This work is queued, but perhaps we locked the wrong cwq.
> +		 * In that case we must see the new value after rmb(), see
> +		 * insert_work()->wmb().
> +		 */
> +		smp_rmb();
> +		if (cwq == get_wq_data(work)) {
> +			list_del_init(&work->entry);
> +			ret = 1;
> +		}

and this.  After grabbing cwq lock, compare it to get_wq_data() first,
if they are the same, both are using the same lock so there's no
reason for the barriers.  If they are different, it doesn't matter
anyway.  We need to retry the locking.

  retry:
	cwq = get_sw_data(work);
	if (!cwq)
		return ret;

	spin_lock_irq(&cwq->lock);
	if (unlikely(cwq != get_wq_data(work))) {
		/* oops wrong cwq */
		spin_unlock_irq(&cwq->lock);
		goto retry;	/* or just return 0; */
	}
	if (!list_empty(&work->entry)) {
		list_del_init(&work->entry);
		ret = 1;
	}
	spin_unlock_irq(&cwq->lock);

Although grabbing cwq->lock doesn't mean anything to other cwqs, it
does guarantee work->wq_data can't be changed to or from it, so the
cwq equality test is guaranteed to work.

> + * It is possible to use this function if the work re-queues itself. It can
> + * cancel the work even if it migrates to another workqueue, however in that
> + * case it only garantees that work->func() has completed on the last queued
> + * workqueue.

We first prevent requeueing from happening; then, wait for each cwq to
finish the work, so I think we're guaranteed that they're finished on
all cpus.  Otherwise, the 'sync' part isn't too useful as it means all
rearming tasks might be running on completion of cancel_work_sync().

Thanks a lot for fixing this.

-- 
tejun
