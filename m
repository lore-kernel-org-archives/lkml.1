Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXAaVbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXAaVbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXAaVbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:31:11 -0500
Received: from mail.screens.ru ([213.234.233.54]:51610 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305AbXAaVbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:31:10 -0500
Date: Thu, 1 Feb 2007 00:30:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070131213042.GA185@tv-sign.ru>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131211340.GA171@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Oleg Nesterov wrote:
> 
> +static inline void barrier_sync(struct barrier *b)
> +{
> +       might_sleep();
> +
> +       if (unlikely(atomic_read(&b->count))) {
> +               DEFINE_WAIT(wait);
> +               prepare_to_wait(&b->wait, &wait, TASK_UNINTERRUPTIBLE);
> +               while (atomic_read(&b->count))
> +                       schedule();
> +               finish_wait(&b->wait, &wait);
> +       }
> +}
> 
> This should be open-coded wait_event(), but wrong! With the scenario above this
> can hang forever! because the first wake_up removes the task from the &b->wait.

I am afraid I was not clear (as usual :). prepare_to_wait means autoremove_wake_function.
So, if barrier_unlock() wakes up the caller of barrier_sync(), it will be removed
from b->wait. If it goes to schedule() because another barrier_lock() incremented
b->count, we can't wake it via __wake_up(&b->wait, ...).

Oleg.

