Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZBEPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZBEPfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZBEPfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:35:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEPfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:35:37 -0500
Date: Thu, 5 Feb 2009 16:33:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
Message-ID: <20090205153301.GC20953@redhat.com>
References: <20090129080603.GA26882@redhat.com> <20090205024021.04DDDFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205024021.04DDDFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Roland McGrath wrote:
>
> > - Fold ptrace_exit() into forget_original_parent(), it is trivial
> >   now. More importantly, this makes the code more symmetrical with
> >   reparent_thread().
>
> Please don't do this.

Roland, I don't know how to reply ;) Because you didn't comment the
previois patch

	[PATCH 3/4] reparent_thread: fix a zombie leak if /sbin/init ignores SIGCHLD
	http://marc.info/?l=linux-kernel&m=123321657429797

which hopefully fixes the ancient (but yes, minor) bug.


But I must admit, I disagree.

> The ptrace functions are separated not because they
> are large, but because they are the ptrace innards.  We have been moving
> away from the core task handling innards having intimate ptrace magic
> knowledge directly intertwined, and we don't want to move back the other
> way.

Yes. But The code becomes much more readable for the new readers,
it is immediately obvious waht forget_original_parent() does.

And we don't mix things, imho. The "ptrace" logic is lives in
the __ptrace_deatch(), so it stays separated.

> In later cleanups, we will eventually separate ptrace linkage from
> the tasklist_lock'd parent/child linkage more thoroughly.

Well, who knows how the code will involve ;) And when. But yes, sure,
in that case we will need a lot of changes, including the new helper.

> > - The same for ptrace_exit_finish(), and "ptrace_" is not correct
> >   any longer.
> >
> > - "ptrace_dead" doesn't match the reality, rename to "dead_list".
>
> For the same reasons, I am not entirely sanguine about overloading
> ptrace_entry for any case not related to ptrace.

Yes. But I don't see a better soulution for now.

But if reparent_thread returns true, we know the task is not traced
and detached, so it must be safe to use ->ptrace_entry. And in fact
this is not much worse than ptrace_exit() currently does.

And I think this is actually another reason to do all this work in
forget_original_parent(), this way we keep this hack "local".

> We want to be able to
> clean up the ptrace data structures in the future such that there may well
> not be any such list_head allocated in an untraced task_struct.

Yes, perhaps. But again, in that case we need a lot of other changes.


And. After the "[PATCH 3/4]" the code looks really bad. At least we
should rename ptrace_exit_finish and ptrace_dead. But if you think
this patch is buggy or you see the better fix, then of course this
patch should be dropped too.

> This case is sufficiently obscure, I can't see that anyone would really
> care about the marginal performance hit for just dropping the lock after
> reparent_thread returns true, call release_task(), re-lock and restart the
> loop on remaining children.  (And I don't see any atomicity problem with
> this unlock/relock.)

Oh. We can do this right now. But I don't think this makes the code
better. We should restart the list_for_each_entry_safe() loop again
and againg until we can't find the task to reap.

And we have the small problem with atomicity, we should call
find_new_reaper() every time we re-lock tasklist.

Oleg.

