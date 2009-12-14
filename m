Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZLNA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZLNA0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZLNA0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbZLNA0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:26:05 -0500
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
In-Reply-To: Peter Zijlstra's message of  Tuesday, 1 December 2009 20:54:02 +0100 <1259697242.1697.1075.camel@laptop>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091214002533.3052519@magilla.sf.frob.com>
Date: Sun, 13 Dec 2009 16:25:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for the delay.  I'm picking up with responding to the parts of
your review that I did not include in my first reply.  I appreciate very
much the discussion you've had with Oleg about the issues that I did not
address myself.  I look forward to your replies to my comments in that
first reply, which we have yet to see.

> Seems inconsistent on u32 vs enum utrace_resume_action.
> 
> Why force enum utrace_resume_action into a u32?

The first argument to almost all callbacks (all the ones made when the
task is alive) is called "action" and it's consistent that its low bits
contain an enum utrace_resume_action.  The argument is "u32 action" in
the report_signal and report_syscall_entry callbacks, where it combines
an enum utrace_resume_action with an enum utrace_{signal,syscall}_action
(respectively).  It would indeed be more consistent to use "u32 action"
throughout, but it seemed nicer not to have engine writers always
writing "utrace_resume_action(action)" for all the cases where there are
no other bits in there.

The return value is a mirror of the "u32 action" argument.  In many
calls, it has only an enum utrace_resume_action in it.  But in some it
combines that with another enum utrace_*_action.  There I went for
consistency (and less typing) in the return type, since it doesn't make
any difference to how you have to write the code in your callback
function.  The main reason I used "u32" at all instead of "unsigned int"
is just its shortness for less typing.

I don't really mind changing these details to whatever people think is
best.  The other people writing code to use the utrace API may have more
opinions than I do.  I guess it could even be OK to make the return
value and "action" argument always a plain enum utrace_resume_action,
and use a second in/out "enum utrace_{signal,syscall}_action *"
parameter in those particular calls.  But that does put some more
register pressure and loads/stores into this API.

> Seems inconsistent in the bitfield type, also it feels like that 3 the 7
> and the enum should be more tightly integrated, maybe add:
> 
> UTRACE_RESUME_MAX
> 
> #define UTRACE_RESUME_BITS (ilog2(UTRACE_RESUME_MAX))
> #define UTRACE_RESUME_MASK ((1 << UTRACE_RESUME_BITS) - 1)

Yes, that's a good cleanup.  Thanks.
(ilog2(7) is 2, so ilog2() + 1 is what you meant.)

> > +static struct utrace_engine *matching_engine(
[...]
> The function does a search, suggesting the function name ought to have
> something like find or search in it.

Ok, I'll make it find_matching_engine.

> Quite gross this.. can't we key off the
> tracehoook_report_clone_complete() and use a wakeup there?

Yes, we intended to clean this up at some point later.  But doing that
is just a distraction and complication right now so we put it off.  For
this case, however, I suppose we could just punt for the initial version.

This code exists to support the special semantics of calling
utrace_attach_task() from inside the parent's report_clone() callback.
That guarantees the parent that it wins any race with any third thread
calling utrace_attach_task().  This guarantees it will be first attacher
in the callback order, but the general subject of callback order is
already something we think we will want to revisit in the future after
we have more experience with lots of different engines trying to work
together.  It's most meaningful when using the UTRACE_ATTACH_EXCLUSIVE
flag--then you can use UTRACE_ATTACH_EXCLUSIVE|UTRACE_ATTACH_MATCH_OPS
to synchronize with other threads trying to attach the same kind of
engine to a task, and give special priority in that to the engine that
attaches in report_clone() from tracing the parent.

Really I came up with this special semantics originally just with ptrace
in mind.  ptrace is an engine that wants to exclude other tracer threads
attaching asynchronously with the same kind of engine, and that wants to
give special priority on a child to the parent's tracer (to implement
PTRACE_O_TRACECLONE et al).  However, Oleg's current ptrace code still
relies on the old hard-coded locking kludges to exclude the separate
attachers and to magically privilege the auto-attach from the parent's
tracer.  So we are not relying on this special semantics yet.

We could just punt utrace_attach_delay() and remove the associated
documentation about the special rights of report_clone() calling
utrace_attach_task().  If we decide it helps clean things up later when
we finish more cleanup of the ptrace world, then we can add the fancy
semantics back in later.

> Does this really need the inline?

It has one caller and that call is unconditional.

> Asymmetric locking like this is really better not done, and looking at
> the callsites its really no bother to clean that up, arguably even makes
> them saner.

By "assymetric" you mean that utrace_reap releases a lock (as the
__releases annotation indicates).  As should be obvious from the code, the
unlock is done before the loop that does ->report_reap callbacks and
utrace_engine_put() (which can make ->release callbacks).  Surely you are
not suggesting that all these callbacks should be made with a spin lock
held, because that would obviously be quite insane.

I tried splitting utrace_reap() into two functions, so the callers make the
first call, then unlock, and then make the second call.  Both callers do
this identically, so this just replaces 
		utrace_reap(task, utrace);
with:
		prepare_utrace_reap(task, utrace);
		spin_unlock(&utrace->lock);
		finish_utrace_reap(task, utrace);
in two places.  That change adds 13 source lines and 71 bytes of compiled
text (x86-64).  Is that what you had in mind?

> You could codify locking assumptions like here using:
> 
>   lockdep_assert_held(&utrace->lock);
> 
> Saves a comment and actually validates the assumption.

Ok, that is fine with me.

> > +	/*
> > +	 * If ptrace is among the reasons for this stop, do its
> > +	 * notification now.  This could not just be done in
> > +	 * ptrace's own event report callbacks because it has to
> > +	 * be done after we are in TASK_TRACED.  This makes the
> > +	 * synchronization with ptrace_do_wait() work right.
> > +	 */
> > +	ptrace_notify_stop(task);
> 
> Well, this is a bit disappointing isn't it? So we cannot implement
> ptrace on utrace without special purpose hooks?

It's more of an issue that ptrace is built around special-purpose hooks
in wait.  We do intend to clean this up later.  But it is as much about
cleaning up the remaining deep insanity of the old ptrace implementation
as about giving utrace better facilities for this wrinkle of
synchronization.  I don't doubt that the utrace API will get some
changes and improvements along the way as we move incrementally to all
of the ptrace internals being done in as clean and sane fashion as the
legacy ptrace userland ABI makes possible.  But Oleg has not yet gotten
to that part of the the ptrace cleanup, and the actual problem that
necessitates this kludge for ptrace is not an issue at all for many
other uses of utrace that don't have to tie into a broken old model of
things.  So being perfectly clean here is not something we should even
think we know how best to do yet, since there has been so little real
call for it.  It would be counterproductive to make this perfection an
obstacle to incremental merging of the current utrace pieces that
already enable other kinds of new functionality.

> If its a programming error, WARN_ON might be appropriate, no point in
> being nice about it.

Sure, except that any WARN_ON shows up as "oops in utrace.c" and then
people think the bug is in utrace rather than in the caller.

> Seriously ugly, again. Use a wakeup where appropriate.

> Its not entirely clear why we can check pending_attach outside of the
> utrace->lock and not be racy.

I think it can be racy sometimes but that does not matter.  
Maybe Oleg can verify my logic here.  If it's right, he can
add some comments to make it more clear.

There is only a very limited sort of "timeliness" guarantee about
getting your callbacks after utrace_attach_task()+utrace_set_events().
If you know somehow that the task was definitely still in TASK_STOPPED
or TASK_TRACED after utrace_attach_task() returned, then your engine
gets all possible callbacks starting from when it resumes.  Otherwise,
you can use utrace_control() with UTRACE_REPORT to ask to get some
callback "pretty soon".  The only callback events you are ever 100%
guaranteed about (after success return from utrace_set_events()) are for
DEATH and REAP, which have an unconditional lock-and-check before making
engine callbacks.

In the stopped cases, there are lots of locks and barriers and things
after resuming.  (Oleg?)

In the "pretty soon" case, that means set_notify_resume:
	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
		kick_process(task);
i.e. IPI after test_and_set.  The test_and_set implies an smp_mb().
So it should be the case that the set of utrace->pending_attach was seen
before the set of TIF_NOTIFY_RESUME.  In a race where the tracee just
saw utrace->pending_attach==0, then it has TIF_NOTIFY_RESUME set still
(or again), and so will go around again before getting back to user mode.

> > +	if (!engine_wants_stop(engine)) {
> > +		spin_lock(&utrace->lock);
> > +		/*
> > +		 * If utrace_control() came in and detached us
> > +		 * before we got the lock, we must not stop now.
> > +		 */
> > +		if (unlikely(engine->ops == &utrace_detached_ops))
> > +			report->detaches = true;
> > +		else
> > +			mark_engine_wants_stop(task, engine);
> > +		spin_unlock(&utrace->lock);
> > +	}
> > +}
> 
> I'm pretty sure that inline isn't really needed.

You mean mark_engine_wants_stop?  You prefer repeating the two lines of
code to using a helper to encapsulate the magic?  Really?

> Simply cond_resched() is sufficient, but that comment sucks, as it
> doesn't mention _why_ it is a good place.
> 
> It seems to turn out that finish_callback() is always the last thing we
> do in the engine iterations in REPORT_CALLBACKS() and
> utrace_get_signal().

Oh, sorry.  I didn't realize it wasn't obvious that finish_callback() is
called after every engine callback, given its name.  I've changed it to:

	/*
	 * We've just done an engine callback.  These are allowed to sleep,
	 * though all well-behaved ones restrict that to blocking kalloc()
	 * or quickly-acquired mutex_lock() and the like.  This is a good
	 * place to make sure tracing engines don't introduce too much
	 * latency under voluntary preemption.
	 */
	might_sleep();

> Also the documentation needs more whitespace, its very hard to digest in
> its current form.

Please make specific suggestions of exactly where you want what changes.  I
tend to use paragraph breaks between groups of sentences that work together
interdependently to communicate a single idea, like they taught me to write
English in elementary school.  In a few cases, I think the kernel-doc
formatting might force you to avoid extra blank lines or else you wind up
with the wrong kinds of grouping in HTML output or something (it's been a
while since I wrote some of the longer kernel-doc comments, and at the time
I looked carefully at how the make htmldocs and make mandocs results came
out to make them readable that way).  

Of course the purpose of comments and kernel-doc is to communicate clearly.
So I am happy to amend the comments in whatever fashions make them more
effective.  But you will have to cite exactly what you want.


Thanks,
Roland
