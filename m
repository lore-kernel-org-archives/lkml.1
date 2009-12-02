Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZLBFpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZLBFpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLBFp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZLBFp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:45:28 -0500
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
X-Zippy-Says: FIRST, I was in a TRUCK...THEN, I was in a DINER...
Message-Id: <20091202054459.98AB5BD8F@magilla.sf.frob.com>
Date: Tue,  1 Dec 2009 21:44:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This above text seems inconsistent. First you say report_reap() is the
> final callback and should be used for cleanup, then you say
> report_death() is the penultimate callback but might not always happen
> and people would normally use that as cleanup.
>
> If we cannot rely on report_death() then I would suggest to simply
> recommend report_reap() as cleanup callback and leave it at that.

I'm sorry the explanation was not clear to you.  I'll try to make it clear
now and then I'd appreciate your suggestions on how the documentation could
be worded better.  (I do appreciate your suggestion here but it's one based
on an idea that's not factual, so I don't think we should follow it.)

There is no "unreliable" aspect to it.  If you call utrace_set_events() to
ask for report_death() callbacks then you will get that callback for that
task--guaranteed--unless utrace_set_events() returned an error code that
tells you unambiguously that you could not get that callback.

What's true is that report_reap() is the last callback you can ever
get for a given task.  If you had asked for report_death() callbacks,
then you always get report_death() and if you've asked for both these
callbacks then report_death() is always before report_reap().  
(This is a special ordering guarantee, because in actuality the
release_task() call that constitutes "reap" can happen in the parent
simultaneously with the task's own exit path.)

The one situation in which you cannot get report_death() is when the task
was already dead when you called utrace_set_events().  In that case, it
gives an error code as I mentioned above.  Even in that situation, you can
still ask to enable just the report_reap() callback.  With either of these,
if you enabled it successfully, then you are guaranteed to get it.

When you get report_death() and are not interested in getting report_reap()
afterwards, then you can return UTRACE_DETACH from report_death().  If you
don't detach, then you will get report_reap() later too.  The documentation
mentions using report_death() to detach and clean up because many kinds of
uses will have no interest in report_reap() at all.  The only reason to get
a report_reap() callback is if you are interested in tracking when a task's
(real) parent reaps it with wait* calls, but usually people are only really
interested in a task until it dies.

> > +  <para>
> > +    There is nothing a kernel module can do to keep a <structname>struct
> > +    task_struct</structname> alive outside of
> > +    <function>rcu_read_lock</function>. 
> 
> Sure there is, get_task_struct() comes to mind.

__put_task_struct() is not exported to modules and so put_task_struct()
cannot be used by modules.

> > +    still valid until <function>rcu_read_unlock</function>.  The
> > +    infrastructure never holds task references of its own.  
> 
> And here you imply its existence.

[I take it this refers to the next quoted bit:]

> >                                                             Though neither
> > +    <function>rcu_read_lock</function> nor any other lock is held while
> > +    making a callback, it's always guaranteed that the <structname>struct
> > +    task_struct</structname> and the <structname>struct
> > +    utrace_engine</structname> passed as arguments remain valid
> > +    until the callback function returns.

No, we do not imply that the utrace infrastructure holds any task
reference.  The current task_struct is always live while it's running
and until it's passed to release_task().  The task_struct passed to
callbacks is current.  That's all it means.  

The true facts are that utrace callbacks are all made in the current task
except for report_reap(), which is made at the start of release_task().
So the kernel's core logic is holding a task reference at all times that
utrace callbacks are made.  If you really think it is clearer to explain
that set of facts as "utrace holds a reference", then please suggest the
exact wording you have in mind.

> The above seems weird to me at best... why hold a pid around when you
> can keep a ref on the task struct? A pid might get reused leaving you
> with a completely different task than you thought you had.

The *_pid interfaces are only there because put_pid() can be used by
modules while put_task_struct() cannot.  If we can make __put_task_struct()
an exported symbol again, I would see no reason for these *_pid calls.

> Right, except you cannot generally rely on this report_death() thing, so
> a trace engine needs to deal with the report_reap() thing anyway.

This is a false antecedent.  I hope the explanation above made this
subject clear to you.

> > +  <sect2 id="interlock"><title>Interlock with final callbacks</title>
[...]
> Hrmm, better mention this earlier, or at least refer to this when
> describing the above cleanup bits.

This explanation is somewhat long and has its own whole section so as to
be thoroughly explicit and clear.  Do you think there should just be a
cross reference here in the earlier mention of report_reap() and
report_death()?  Or do you think that the "Final callbacks" text should
be merged together with the "Interlock" section?

> > +  an error if the task is not properly stopped and not dead. 
> 
> 'or' dead?

Yes, fixed.  Thanks!


I've relied on Oleg to review and fix the barrier-related logic.
So I'll leave it to him to hash out those parts of the review.

> Can the compiler optimize away the callsite using weak functions like
> this? If not I think the normal static inline stubs make more sense.

I'm not sure I understand the question.  If the !CONFIG_UTRACE case, this
all boils down to "if (0) utrace_foo(...);" calls after constant folding.
I think the compiler will always compile those out, but I'm not entirely
sure about all old compilers or about -O0.

> Also, what unoptimized compilation?

If there really is none then I guess there isn't a problem.  We can just
drop these weak attributes and the dead calls will be optimized away
before link time anyway.  If we are not positive that is going to fly
everywhere, then I have no objection to adding static inline stubs in the
#else branch if you think that is preferable.

> Right, so this lot doesn't seem very consistent.

Please explain what kind of consistency you have in mind.
I don't follow.

> At the very least I would put signal action and syscall action into
> different ranges.

Those two can never be used in the same place.  So I don't really
understand that.  It doesn't matter what their values are, so I don't
have a problem with changing them to be disjoint.  But I don't understand
why it would be better in any way at all.

> Sorry, the kernel is written in C, not C++.

We know that perfectly well, and I haven't been able ascertain what
benefit you gain by being snide.  Our code follows the instructions in
Documentation/kernel-doc-nano-HOWTO.txt, so if you have a complaint with
that established practice recommened for the kernel please take it up
with the appropriate maintainers.  We're following what the kernel's own
documentation tells us to do.

If you use /** for a struct and omit @field for some fields, then you get
warnings from make *docs.  If you omit all the fields (because none are
part of the documented API, such as in struct utrace_examiner), then you
get a build error.  So unless kernel-doc changes, the options are to
follow its specified /* private: */ convention as we do now, to add a
bunch of "@field: this is an internal field, do not touch it" comments,
or to punt on kernel-doc for these structs.  Which do you want?

> Again, its not C++, if you want a private state like that, use an opaque
> type, like:
> 
> struct utrace_examiner;
> 
> and only define the thing in utrace.c or something.

Again, we are following the kernel-doc instructions for this situation.
If you look at the uses of this type in the interface, you'll see that
its purpose is to have the caller allocate the space.  The only way to
make it opaque would be to use a pointer type and do dynamic allocation
inside some utrace.c function.  That would be inane for holding two words
needed momentarily during one caller's frame.

> Given that some functions have a lot of arguments (depleting regparam),
> isn't it more expensive to push current on the stack than it is to
> simply read it again?

Perhaps so.  The only callback where the task argument is not current is
report_reap().  That one already differs from the calling pattern of all
the others because it has no return value.  So I guess we could drop the
task argument to all the "normal" report_* calls.


I'll pick up with responding to the rest of your remarks as soon as I
can.  (Right now I have to prepare for an airplane early in the morning.)


Thanks,
Roland
