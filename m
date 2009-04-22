Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZDVR6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZDVR6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZDVR62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:58:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZDVR62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:58:28 -0400
Date: Wed, 22 Apr 2009 19:57:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422175753.GA14236@elte.hu>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5591.1240417398@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> +WAKE UP OF PROCESSES
> +--------------------
> +
> +An unlock, write memory barrier or a full memory barrier may be needed before a
> +call to wake up another processes if the waker sets some state that the sleeper
> +will need to see.
> +
> +	complete();
> +	wake_up();
> +	wake_up_all();
> +	wake_up_bit();
> +	wake_up_interruptible();
> +	wake_up_interruptible_all();
> +	wake_up_interruptible_nr();
> +	wake_up_interruptible_poll();
> +	wake_up_interruptible_sync();
> +	wake_up_interruptible_sync_poll();
> +	wake_up_locked();
> +	wake_up_locked_poll();
> +	wake_up_nr();
> +	wake_up_poll();
> +
> +The sleeper may then need to interpolate a lock, read or full memory barrier
> +before accessing that state.

Why would an unlock be needed before a call to wake_up() variants?

If a piece of code does:

	wake_up*(&object->wq);
	...
	spin_unlock(&object->lock);

that's perfectly race-free, as long as the wakee always starts with 
something like:

	spin_lock(&object->lock);
	...

I.e. waking up sooner than dropping the lock always OK (and it's a 
frequent operation). Your text seems to imply that a barrier is 
needed (or the unlock needs to happen first) but that's wrong i 
think.

The dangerous pattern is lockless code doing wakeups. But lockless 
code always has to use proper barriers or atomics anyway, and has to 
be aware of the fact that kernel primitives they call are not 
necessarily full memory barriers.

In fact i'd encourage to _not_ document try_to_lock() as a write 
barrier either - but rather have explicit barriers where they are 
needed. Then we could remove that barrier from try_to_wake_up() too 
;-)

Hm?

	Ingo
