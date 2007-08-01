Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbXHAXzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbXHAXzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXHAXzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:55:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43228 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXHAXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:55:45 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801222201.GA316@tv-sign.ru>
References: <1185940340.2636.97.camel@imap.mvista.com>
	 <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru>
	 <1185992994.2636.142.camel@imap.mvista.com>
	 <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 19:53:59 -0400
Message-Id: <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 02:22 +0400, Oleg Nesterov wrote:

> 
> No.
> 
> > However, IIUC the point of flush_workqueue() is a barrier only relative
> > to your own submissions, correct?.  E.g. to make sure *your* requests
> > are finished, not necessarily the entire queue.
> 
> No,

You sure are a confident one ;)

> 
> > If flush_workqueue is supposed to behave differently than I describe,
> > then I agree its broken even in my original patch.
> 
> The comment near flush_workqueue() says:
> 
> 	* We sleep until all works which were queued on entry have been handled,
> 	* but we are not livelocked by new incoming ones.

Dude, of *course* says that.  It would be completely illogical for it to
say otherwise with the linear priority queue that mainline has.  Since
we are changing things here you have to read between the lines and ask
yourself "what is the intention of this barrier logic?".  Generally
speaking, the point of a barrier is to flush relevant work from your own
context, sometimes at the granularity of flushing everyone elses work
inadvertently if the flush mechanism isn't fine grained enough.  But
that is a side-effect, not a requirement.

So now my turn:

No. :P

But in all seriousness, let me ask you this:  Why do you need a barrier
that flushes *all* work instead of just *your* work.  Do you really
care?  If you do, could we adapt the API to support the notion of
"flush() and "flush_all".  Could we stay with one API call and make it
flush all work again and you are happy?

To be honest, I think you have made me realize there is actually a
legitimate problem w.r.t. what I mentioned earlier (unguarded local
PI-boost messing things up), and its my bad.  I originally wrote this
patch for a different RT subsystem which used an entirely different
barrier mechanism and therefore didn't have this problem(*).  I think it
just didn't translate in the port to workqueues directly, and now we
need to address it.

Even though I disagree with you on the semantics of flush_workqueue, the
fact that we don't protect against a local PI-boost means the current
mechanism isn't safe (and thank you for banging that home).  However,
you seem to have objections to the overall change in general aside from
this bug, and there we can agree to disagree.

(*)Basically, the signaling mechanisms in the original design were
tightly coupled to the work-units and therefore there was no
relationship between disparate items in the queue such as there is in
the workqueue subsystem.  

  
> 
> > > > 2) The priority of the workqueue task would be temporarily elevated to
> > > > RT99 so that the currently dispatched task will complete at the same
> > > > priority as the waiter.
> > > 
> > > _Which_ waiter?
> > 
> > The RT99 task that submitted the request.
> 
> Now, again, why do you think this task should wait?

I don't think it *should* wait.  It *will* wait and we don't want that.
And without PI-boost, it could wait indefinitely.  I think the detail
you are missing is that the RT kernel introduces some new workqueue APIs
that allow for "RPC" like behavior.  E.g. they are like
"smp_call_function()", but instead of using an IPI, it uses workqueues
to dispatch work to other CPUs.  I could go on and on about why this is,
but hopefully you just immediately understand that this is a *good*
thing to do, especially in RT.

So now, we are enhancing that RPC mechanism to be RT aware with this
proposed changeset so it A) priority-queues, and B) prevents inversion.
I hope that helps to clear it up.

Originally I had proposed this RPC mechanism to be a separate subsystem
from workqueues.  But it involved new kthreads, rt-queuing, and PI.  It
was sensibly suggested in review that the kthread work was redundant
with workqueues, but that the rt/pi stuff had general merit.  So it was
suggested that we port the rt/pi concepts to workqueues and base the
work on that.  So here we are.... ;)

> 
> > >  I can't understand at all why work_struct should "inherit"
> > > the priority of the task which queued it. 
> > 
> > Think about it:  If you are an RT99 task and you have work to do,
> > shouldn't *all* of the work you need be done at RT99 if possible. 
> 
> No, I don't think so. Quite opposite,

Ouch, there's that confidence again...

>  I think sometimes it makes
> sense to "offload" some low-priority work from RT99 to workqueue
> thread exactly because it has no rt policy.

The operative word in your statement being "sometimes"?  I could flip
your argument right around on you and say "sometimes we want to use
workqueues to remotely represent our high priority butts somewhere
else" ;)  Perhaps that is the key to compromise.  Perhaps the API needs
to be adjusted to deal with the fact that sometimes you want to inherit
priority, sometimes you don't.

> 
> And what about queue_work() from irq? Why should that work take a
> "random" priority?

Yes, you raise a legitimate point here.  In RT, the irq is a kthread
with an RT priority so it would inherit that as the patch stands right
now.  However, whether this is correct/desired and how this translates
to operation under non-RT is unclear.  Perhaps the next pass with
proposed API changes will solve this issue.

> 
> > Why
> > should something like a measly RT98 task block you from completing your
> > work. ;) The fact that you need to do some work via a workqueue (perhaps
> > because you need specific cpu routing) is inconsequential, IMHO.
> 
> In that case I think it is better to create a special workqueue
> and raise its priority.

I disagree with you here.  Why should we have a bunch of new workqueues
kicking around for all the different priorities and scenarios.  Like I
said, we are trying to build a RT-aware general RPC mechanism here.
Those "event/%d"s are just laying around idle.  Lets use em! ;)

Again, to be honest I somewhat see your point.  I originally used my own
kthreads (one per CPU) precisely because I didn't *want* to mess with
the workqueue infrastructure.  So you got one camp saying "don't create
your own homegrown workqueues!", and you got another saying "don't
change my workqueue infrastructure"!  I dont know what is the best
answer, but I can tell you this RT/PI stuff is a legitimate problem to
solve, at least from the RT perspective.  So lets put our heads together
and figure it out.

Regards
-Greg


