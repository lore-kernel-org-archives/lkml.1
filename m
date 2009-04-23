Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZDWQlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZDWQlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZDWQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:40:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZDWQky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:40:54 -0400
Date: Thu, 23 Apr 2009 18:36:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090423163624.GA6732@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <20090422175753.GA14236@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422175753.GA14236@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Ingo Molnar wrote:
>
> * David Howells <dhowells@redhat.com> wrote:
>
> The dangerous pattern is lockless code doing wakeups. But lockless
> code always has to use proper barriers or atomics anyway, and has to
> be aware of the fact that kernel primitives they call are not
> necessarily full memory barriers.
>
> In fact i'd encourage to _not_ document try_to_lock() as a write
> barrier either - but rather have explicit barriers where they are
> needed. Then we could remove that barrier from try_to_wake_up() too
> ;-)

Well. I think in that case almost every try_to_wake_up/wake_up_process
needs mb().

For example:

	do_nanosleep:

		for (;;) {
			set_current_state(TASK_INTERRUPTIBLE);
			if (likely(t->task))
				schedule();
			break;
		}

	hrtimer_wakeup:

		task = t->task
		t->task = NULL;
		wake_up_process(task);

If try_to_wake_up() has no the barrier semantics, we can miss the event.
"t->task = NULL" and the reading of task->state must not be reordered.

Oleg.

