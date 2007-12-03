Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXLCTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXLCTMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLCTMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:12:24 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1995 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbXLCTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:12:23 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Christopher Friesen" <cfriesen@nortel.com>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 11:12:06 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <47543EEC.7010900@nortel.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 11:13:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 11:13:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Friesen wrote:

> David Schwartz wrote:

> > 	I've asked versions of this question at least three times
> > and never gotten
> > anything approaching a straight answer:
> >
> > 	1) What is the current default 'sched_yield' behavior?
> >
> > 	2) What is the current alternate 'sched_yield' behavior?

> I'm pretty sure I've seen responses from Ingo describing this multiple
> times in various threads.  Google should have them.

> If I remember right, the default is to simply recalculate the task's
> position in the tree and reinsert it, and the alternate is to yield to
> everything currently runnable.

The meaning of the default behavior then depends upon where in the tree it
reinserts it.

> > 	3) Are either of them sensible? Simply acting as if the
> > current thread's
> > timeslice was up should be sufficient.

> The new scheduler doesn't really have a concept of "timeslice".  This is
> one of the core problems with determining what to do on sched_yield().

Then it should probably just not support 'sched_yield' and return ENOSYS.
Applications should work around an ENOSYS reply (since some versions of
Solaris return this, among other reasons). Perhaps for compatability, it
could also yield 'lightly' just in case applications ignore the return
value.

It could also handle it the way it handles the smallest sleep time that it
supports. This is sub-optimal if no other task are ready-to-run at the same
static priority level and that might be an expensive check.

If CFS really can't support sched_yield's semantics, then it should just
not, and that's that. Return ENOSYS and admit that the behavior sched_yield
is documented to have simply can't be supported by the scheduler.

> > The implication I keep getting is that neither the default
> > behavior nor the
> > alternate behavior are sensible. What is so hard about simply
> > scheduling the
> > next thread?

> The problem is where do we insert the task that is yielding?  CFS is
> based around a tree structure ordered by time.

We put it exactly where we would have when its timeslice ran out. If we can
reward it a little bit, that's great. But if not, we can live with that.
Just imagine that the timer interrupt fired to indicate the end of the
thread's run time when the thread called 'sched_yield'.

> The old scheduler was priority-based, so you could essentially yield to
> everyone of the same niceness level.
>
> With the new scheduler, this would be possible, but would involve extra
> work tracking the position of the rightmost task at each priority level.
> This additional overhead is what Ingo is trying to avoid.

Then what does he do when the task runs out of run time? It's hard to
imagine we can't do that when the task calls sched_yield.

> > 	We don't need perfection, but it sounds like we have two
> > alternatives of
> > which neither is sensible.

> sched_yield() isn't a great API.

I agree.

> It just says to delay the task,
> without specifying how long or what the task is waiting *for*.

That is not true. The task is waiting for something that will be done by
another thread that is ready-to-run and at the same priority level. The task
does not need to wait until the thing is guaranteed done but wishes to wait
until it is more likely to be done. This is an often-misused but sometimes
sensible thing to do.

I think the API gets blamed for two things that are not its fault:

1) It's often misunderstood and misused.

2) It was often chosen as a "best available" solution because no truly good
solutions were available.

> Other
> constructs are much more useful because they give the scheduler more
> information with which to make a decision.

Sure, if there is more information. But if all you really want to do is wait
until other threads at the same static priority level have had a chance to
run, then sched_yield is the right API.

DS


