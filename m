Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZBIChX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZBIChX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZBIChK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:37:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBIChJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:37:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
In-Reply-To: Oleg Nesterov's message of  Thursday, 5 February 2009 16:33:01 +0100 <20090205153301.GC20953@redhat.com>
References: <20090129080603.GA26882@redhat.com>
	<20090205024021.04DDDFC381@magilla.sf.frob.com>
	<20090205153301.GC20953@redhat.com>
X-Shopping-List: (1) Deboned turkeys
   (2) Harried prescriptions
   (3) Apathetic dogboy auditions
Message-Id: <20090209023626.03C7DFC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 18:36:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, I don't know how to reply ;) Because you didn't comment the
> previois patch

I think my remarks about using ->ptrace_entry covered my sentiments.

> Yes. But The code becomes much more readable for the new readers,
> it is immediately obvious waht forget_original_parent() does.

How so?  It's already "immediately obvious" that it cleans up ptrace stuff
and then does the father->children loop.

> And we don't mix things, imho. The "ptrace" logic is lives in
> the __ptrace_deatch(), so it stays separated.

The fact that task_struct.ptraced exists at all, much less that you need to
iterate on it, is purely part of the "ptrace logic".

> > In later cleanups, we will eventually separate ptrace linkage from
> > the tasklist_lock'd parent/child linkage more thoroughly.
> 
> Well, who knows how the code will involve ;) And when. But yes, sure,
> in that case we will need a lot of changes, including the new helper.

I think we know pretty much how it will evolve, because it will be us doing it.

> > For the same reasons, I am not entirely sanguine about overloading
> > ptrace_entry for any case not related to ptrace.
> 
> Yes. But I don't see a better soulution for now.

The clunky solution below works fine right now.  It perhaps theoretically
performs worse--when we actually hit this utterly obscure case, if that
ever actually happens in real life at all.

> But if reparent_thread returns true, we know the task is not traced
> and detached, so it must be safe to use ->ptrace_entry. And in fact
> this is not much worse than ptrace_exit() currently does.

Sure, we "know" it's safe because this code "knows" every intimate thing
about ptrace innards.  Great.  More of that instead of less is exactly what
we need, don't you think?  Or perhaps all these stages of clean-up had a
point, and it was to avoid exactly things like this.  ptrace_exit is itself
part of the ptrace innards to begin with; that's why it's called that!

> Yes, perhaps. But again, in that case we need a lot of other changes.

Not really so many.  I have thought about plan this from the beginning
when I did the cleanups creating ptrace_exit et al.  Because of the past
cleanups, pretty much all those changes are in places now called ptrace_*.
That's why those were cleanups: they made it easier to isolate such later
changes from the rest of the code.

> And. After the "[PATCH 3/4]" the code looks really bad. At least we
> should rename ptrace_exit_finish and ptrace_dead. But if you think
> this patch is buggy or you see the better fix, then of course this
> patch should be dropped too.

"Better" is obviously subjective.  I think you are only talking about
"better" in a micro-optimizing sense that here is only actually relevant to
optimizing rare cases that don't need it.  I think the "slow kludge" here
is "better" than overloading ptrace innards in any way because the "better"
comes from a sanity, readability and maintenance perspective that puts a
high value on isolating ptrace crud fully from core code, and because the
specific local cost in "slow" and "kludge" forms of "worse" is IMHO quite
marginal in this particular spot.

> Oh. We can do this right now. But I don't think this makes the code
> better. We should restart the list_for_each_entry_safe() loop again
> and againg until we can't find the task to reap.

Sure, but "restarting" doesn't mean walking any part of the list again--the
parts you've walked earlier are already gone.  It just means the pure
overhead of the restart (unlock/relock et al).

> And we have the small problem with atomicity, we should call
> find_new_reaper() every time we re-lock tasklist.

Ok.  That's right.  I don't think it hurts anything.


Thanks,
Roland
