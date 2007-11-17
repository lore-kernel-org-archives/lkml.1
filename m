Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXKQQi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXKQQi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXKQQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:38:51 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:53497 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbXKQQiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:38:50 -0500
Date: Sat, 17 Nov 2007 19:38:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] wait_task_stopped: tidy up the noreap case
Message-ID: <20071117163835.GA193@tv-sign.ru>
References: <20071116172413.GA7296@tv-sign.ru> <20071116202403.1CF0C26F8BA@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116202403.1CF0C26F8BA@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16, Roland McGrath wrote:
>
> This is good, but not quite enough.  The original intent behind having the
> test was never to return mismatched stale/fresh data.  (Not that it ever
> really worked as intended.)  That is, it's fine if the task has woken up
> and done other things while WNOWAIT reports it as stopped--that's stale
> data, but it just means the waitid call happened "before" the resumption.
> However, it should not report anything that could not possibly have been
> true before the resumption.  i.e. a changed exit_code, which now means an
> normal termination status or a death signal, not the stop signal.  This
> also applies to the uid, in case the thread called setuid upon resuming
> (and even to ptracedness, not that that one really matters).  (It doesn't
> matter for rusage, since that's not really an exact change of state with
> reliable ordering anyway.)
>
> So the setting of uid and why should also move before read_unlock.

Yes I agree, and I also realized this. In fact, I already tried to do this
a long ago: http://marc.info/?l=linux-kernel&m=112809846204068, please note
that !noreap branch should be changed as well.

This time I'am trying to cleanup (remove) the games with ->exit_state first.
I am mostly concerned about 3/3 patch, what do you think about it?

And. Please note that 3/3 removes the "It must also be done with the write
lock held to prevent a race with the EXIT_ZOMBIE case" comment. Afaics, we
don't need write_lock(tasklist) any longer, we can simplify things further
and remove the EGAIN case completely.

However, wait_task_stopped does:

	/* move to end of parent's list to avoid starvation */
	remove_parent(p);
	add_parent(p);

That is why we need write_lock(). Is this really so important? Yes, the next
do_wait() can find another "interesting" task a bit faster, but only a little
bit. wait_task_continued() could be optimized in a same manner...

Also. I think the locking is not complete. {read,write}_lock(tasklist) can't
really pin the task in TRACED/STOPPED state. We need ->siglock to ensure that
the child can't escape from get_signal_to_deliver() at least, so it can't do
exit/setuid/etc. I was going to try to do this later, because this needs nasty
changes...

Oh well. OK, we can ignore patches 2-3 for now. I'd like to know your opinion
before going further, perhaps I missed something else.

> While you're at it, you could fix the status argument to wait_noreap_copyout.
> It should be just exit_code, not the WIFSTOPPED bit format it does now.

OK, unless Scott is going to do this.

Oleg.

