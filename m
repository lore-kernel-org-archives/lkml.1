Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbZLPLSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbZLPLSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762064AbZLPLSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:18:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZLPLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:18:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
X-Fcc: ~/Mail/utrace
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Peter Zijlstra's message of  Monday, 14 December 2009 14:51:36 +0100 <1260798696.4165.316.camel@twins>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091214002533.3052519@magilla.sf.frob.com>
	<1260798696.4165.316.camel@twins>
X-Shopping-List: (1) Historic exclusion enemas
   (2) Sardonic reinforcement miscreants
   (3) Libelous soft-serve prosecutors
Message-Id: <20091216111824.0D6779E5@magilla.sf.frob.com>
Date: Wed, 16 Dec 2009 03:18:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> C does implicit casts from enum to integer types, right? So always using
> u32 here would not impose any extra typing on the user, or am I missing
> something subtle here?

No, that's right.  I had just been thinking of the documentation /
convenience issue.  I figured with u32 people might tend to think they
always had to write utrace_resume_action(action) like you do in
report_signal, or would want it to get the enum so e.g. you can write a
switch and have gcc give those warnings about covering all the enum cases.
But you have convinced me that the consistency of using u32 everywhere is
the what's really easiest to understand.

> I don't mind the sharing of the argument, it just looked odd to have the
> u32/unsigned int/enum thing intermixed, since you care about typing
> length (as good a criteria as any) I'd just be lazy and make everything
> u32 ;-)

That's good enough for me.

> As to the content, can't you accomplish the same thing by processing
> such exclusive parent registration before exposing the child in the
> pid-hash? Right before cgroup_fork_callback() in
> kernel/fork.c:copy_process() seems like the ideal site.

As Oleg mentioned, that would add some complications.  The task is not
really fully set up at that point and the clone might actually still fail.
The final stages where the clone can fail are necessarily inside some
important locks held while making the new task visible for lookup.

One of the key features of the utrace API is that callbacks are called in
uncomplicated contexts so you just don't have to worry about a lot of
strangeness and arcane constraints.  That means making such a callback
while holding any spin lock or suchlike is really out of the question.

So, either we have to make a callback where you suggest, before the task
really exists, or where we do now, after the task is visible to others.  An
unfinished task that doesn't yet have all its pointers in place, and still
might be freed before it could ever run, would add a whole lot of hair to
what the utrace API semantics would be.  If you get the callback that
early, then you can attach to it that early, and then you expect some
callbacks about it actually failing ever to exist.  And meanwhile, you
might have to know what you can and can't try to do with a task that is not
really set up yet.  It just seems like a really bad idea.

Hence, we are stuck with the post-clone callback being really post-clone so
that it's possible for other things in the system to see the new task and
try to utrace_attach it.  But, as I said, we are not actually relying on
having a way to rule that out at the utrace level today.  So I think we can
just take out this hack and reconsider it later when we have an active need.

> Best would be to fix up the utrace-ptrace implementation and get rid of
> those other kludges I think, not sure.. its all a bit involved and I'm
> not at all sure I'm fully aware of all the ptrace bits.

We haven't figured out all the best ways to clean up ptrace the rest of
the way yet.  We'd like to keep improving that incrementally after the
basics of utrace are in the tree.

> > [...] Surely you are
> > not suggesting that all these callbacks should be made with a spin lock
> > held, because that would obviously be quite insane.
> 
> Because there can be many engines attached? 

Because it's a callback API.  A callback is allowed to use mutex_lock(),
is expected to be preemptible, etc.  Having an interface where you let
somebody's function unwittingly run with spin locks held, preemption
disabled, and so forth, is just obviously a terrible interface.

> Or in case of utrace_reap() maybe push the spin_lock() into it?

I did a restructuring to make that possible.  IMHO it makes the control
flow a bit less clear.  But it came out a bit smaller in the text, so
I'll go with it.

> I'm well aware that ptrace had some quirky bits in, and this might well
> be one of the crazier parts of it, but to the un-initiated reviewer (me)
> this could have done with a comment explaining exactly why this
> particular site is not worth properly abstracting etc..

We'll add more comments there.

> Not if the comment right above the WARN_ON() says that its a clueless
> caller.. but if you're really worried about it, use something like:
> 
> WARN(cond, "Dumb-ass caller\n");

Oh, that's much better.  I've made all the WARN_ON's give some text.


Thanks,
Roland
