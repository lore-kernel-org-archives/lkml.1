Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXJASYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXJASYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXJASYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:24:06 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3174 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXJASYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:24:05 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Mon, 1 Oct 2007 11:23:56 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071001173159.GB2492@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 11:23:53 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 11:23:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> These are generic statements, but i'm _really_ interested in the
> specifics. Real, specific code that i can look at. The typical Linux
> distro consists of in execess of 500 millions of lines of code, in tens
> of thousands of apps, so there really must be some good, valid and
> "right" use of sched_yield() somewhere in there, in some mainstream app,
> right? (because, as you might have guessed it, in the past decade of
> sched_yield() existence i _have_ seen my share of sched_yield()
> utilizing user-space code, and at the moment i'm not really impressed by
> those examples.)

Maybe, maybe not. Even if so, it would be very difficult to find. Simply
grepping for sched_yield is not going to help because determining whether a
given use of sched_yield is smart is not going to be easy.

> (user-space spinlocks are broken beyond words for anything but perhaps
> SCHED_FIFO tasks.)

User-space spinlocks are broken so spinlocks can only be implemented in
kernel-space? Even if you use the kernel to schedule/unschedule the tasks,
you still have to spin in user-space.

> > One example I know of is a defragmenter for a multi-threaded memory
> > allocator, and it has to lock whole pools. When it releases these
> > locks, it calls yield before re-acquiring them to go back to work. The
> > idea is to "go to the back of the line" if any threads are blocking on
> > those mutexes.

> at a quick glance this seems broken too - but if you show the specific
> code i might be able to point out the breakage in detail. (One
> underlying problem here appears to be fairness: a quick unlock/lock
> sequence may starve out other threads. yield wont solve that fundamental
> problem either, and it will introduce random latencies into apps using
> this memory allocator.)

You are assuming that random latencies are necessarily bad. Random latencies
may be significantly better than predictable high latency.


> > Can you explain what the current sched_yield behavior *is* for CFS and
> > what the tunable does to change it?

> sure. (and i described that flag on lkml before) The sched_yield flag
> does two things:

>  - if 0 ("opportunistic mode"), then the task will reschedule to any
>    other task that is in "bigger need for CPU time" than the currently
>    running task, as indicated by CFS's ->wait_runtime metric. (or as
>    indicated by the similar ->vruntime metric in sched-devel.git)
>
>  - if 1 ("agressive mode"), then the task will be one-time requeued to
>    the right end of the CFS rbtree. This means that for one instance,
>    all other tasks will run before this task will run again - after that
>    this task's natural ordering within the rbtree is restored.

Thank you. Unfortunately, neither of these does what sched_yiled is really
supposed to do. Opportunistic mode does too little and agressive mode does
too much.

> > The desired behavior is for the current thread to not be rescheduled
> > until every thread at the same static priority as this thread has had
> > a chance to be scheduled.

> do you realize that this "desired behavior" you just described is not
> achieved by the old scheduler, and that this random behavior _is_ the
> main problem here? If yield was well-specified then we could implement
> it in a well-specified way - even if the API was poor.

> But fact is that it is _not_ well-specified, and apps grew upon a random
> scheduler implementation details in random ways. (in the lkml discussion
> about this topic, Linus offered a pretty sane theoretical definition for
> yield but it's not simple to implement [and no scheduler implements it
> at the moment] - nor will it map to the old scheduler's yield behavior
> so we'll end up breaking more apps.)

I don't have a problem with failing to emulate the old scheduler's behavior
if we can show that the new behavior has saner semantics. Unfortunately, in
this case, I think CFS' semantics are pretty bad. Neither of these is what
sched_yield is supposed to do.

Note that I'm not saying this is a particularly big deal. And I'm not
calling CFS' behavior a regression, since it's not really better or worse
than the old behavior, simply different.

I'm not familiar enough with CFS' internals to help much on the
implementation, but there may be some simple compromise yield that might
work well enough. How about simply acting as if the task used up its
timeslice and scheduling the next one? (Possibly with a slight reduction in
penalty or reward for not really using all the time, if possible?)

DS


