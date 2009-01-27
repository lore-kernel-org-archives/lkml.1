Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZA0DaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZA0DaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZA0DaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 22:30:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZA0DaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 22:30:02 -0500
Date: Tue, 27 Jan 2009 04:23:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v5] wait: prevent exclusive waiter starvation
Message-ID: <20090127032359.GA17359@redhat.com>
References: <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com> <20090123095904.GA22890@cmpxchg.org> <20090123113541.GB12684@redhat.com> <20090123133050.GA19226@redhat.com> <20090126215957.GA3889@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126215957.GA3889@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Johannes Weiner wrote:
>
> Another iteration.  I didn't use a general finish_wait_exclusive() but
> a version of this function that just returns whether we were woken
> through the queue or not.

But if your helper (finish_wait_woken) returns true, we always need
to wakeup the next waiter, or we don't need to use it. So why not
place the wakeup in the helper itself?

> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -333,16 +333,20 @@ do {									\
>  	for (;;) {							\
>  		prepare_to_wait_exclusive(&wq, &__wait,			\
>  					TASK_INTERRUPTIBLE);		\
> -		if (condition)						\
> +		if (condition) {					\
> +			finish_wait(&wq, &__wait);			\
>  			break;						\
> +		}							\
>  		if (!signal_pending(current)) {				\
>  			schedule();					\
>  			continue;					\
>  		}							\
>  		ret = -ERESTARTSYS;					\
> +		if (finish_wait_woken(&wq, &__wait))			\
> +			__wake_up_common(&wq, TASK_INTERRUPTIBLE,	\

No, we can't use __wake_up_common() without wq->lock.

Oleg.

