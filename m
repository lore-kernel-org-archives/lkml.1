Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbZDXRee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbZDXRee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbZDXReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:34:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbZDXReY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:34:24 -0400
Date: Fri, 24 Apr 2009 19:28:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090424172845.GB13026@redhat.com>
References: <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26028.1240573601@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, David Howells wrote:
>
>  (2) wake_up() interpolates a write memory barrier before clearing the task
>      state - _if_ it wakes anything up - then there's no problem in the waker
>      either.
>
[...snip...]
>
> +A write memory barrier is implied by wake_up() and co. if and only if they wake
> +something up.  The barrier occurs before the task state is cleared, and so sits
> +between the STORE to indicate the event and the STORE to set TASK_RUNNING:

Very minor nit. Perhaps it makes sense to mention that we also need the
barrier before _reading_ the task->state as well. Or not, I am not sure ;)
Just in case...

	event_indicated = 1;
	wake_up_process(event_daemon);

Suppose that "event_indicated = 1" leaks into try_to_wake_up() after we
read p->state. In this case we have

	try_to_wake_up:

		if (!(p->state & state))
			goto out;		// do nothing

		// WINDOW

		event_indicated = 1;		// leaked

In that case the whole

	set_current_state(TASK_UNINTERRUPTIBLE);
	if (event_indicated)
		break;
	schedule();

can happen in the WINDOW above.

But again, this is the real nitpick, and probably just the "implementation
details" which should not be documented.

Oleg.

