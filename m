Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZDWRB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZDWRB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZDWRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:01:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZDWRBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:01:18 -0400
Date: Thu, 23 Apr 2009 18:55:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090423165546.GA7117@redhat.com>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21209.1240504344@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, David Howells wrote:
>
> +	complete();
> +	try_to_wake_up();
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
> +After waking, and assuming it doesn't take a matching lock, the sleeper may
> +need to interpolate a read or full memory barrier before accessing that state
> +as finish_wait() does not imply a barrier either, and schedule() only implies a
> +barrier on entry.

Well. I am starting to suspect I missed something, but I disagree. Or I just
(this is very possible) misunderstand the above.

finish_wait() doesn't imply a barrier, but why this matters?

And if we don't use prepare_to_wait() and just do

	for (;;) {
		set_current_state(WHATEVER);
		if (!CONDITION)
			schedule();
		break;
	}

we do have mb(), but

> + *
> + * It should not be assumed that this function implies any sort of memory
> + * barrier.
>   */
>  static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)

unless try_to_wake_up() has a barrier semantics too, this code

	CONDITION = 1;
	wake_up_process(waiter);

is not right, and that mb above can't help.


Could you please give the code example which shows we need a barrier
after finish_wait() ?

I am just trying to understand what I missed.

Oleg.

