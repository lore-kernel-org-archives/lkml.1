Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZGLPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZGLPcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZGLPcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 11:32:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZGLPcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 11:32:21 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Douglas Niehaus <niehaus@ittc.ku.edu>
Cc: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>
In-Reply-To: <4A594D2D.3080101@ittc.ku.edu>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
Content-Type: text/plain
Date: Sun, 12 Jul 2009 17:31:48 +0200
Message-Id: <1247412708.6704.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 21:40 -0500, Douglas Niehaus wrote:
> Peter:
>     Perhaps you could expand on what you meant when you said:
> 
> 	Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
> 	but SMP leaves things to be desired. Dhaval is currently working on a
> 	PEP implementation that will migrate all the blocked tasks to the
> 	owner's cpu, basically reducing it to the UP problem.
> 
> What is left to be desired with PEP on SMP? I am not saying it is 
> perfect, as I can think of a few things I would like to improve or 
> understand better, but I am curious what you have in mind.

Right, please don't take this as a critism against PEP, any scheme I
know of has enormous complications on SMP ;-)

But the thing that concerns me most, there seem to be a few O(n)
consequences. Suppose that for each resource (or lock) R_i, there is a
block graph G_i, which consists of n nodes and would be m deep.

Functionally (generalized) PIP and PEP are identical, their big
difference is that PIP uses waitqueues to encode the block graph G,
whereas PEP leaves everybody on the runqueue and uses the proxy field to
encode the block graph G.

The downside of PIP is that the waitqueue needs to re-implement the full
schedule function in order to evaluate the highest prio task on the
waitqueue. Ttraditionally this was rather easy, since you'd only
consider the limited SCHED_FIFO static prio range, leaving you with a
O(1) evaluation, when you add more complex scheduling functions things
get considerably more involved. Let's call this cost S.

So for PIP you get O(m*S) evaluations whenever you get a change to the
block graph.

Now for PEP, you get an increased O(m) cost on schedule, which can be
compared to the PIP cost.

However PEP on SMP needs to ensure all n tasks in G_i are on the same
cpu, because otherwise we can end up wanting to execute the resource
owner on multiple cpus at the same time, which is bad.

This can of course be amortized, but you end up having to migrate the
task (or an avatar thereof) to the owner's cpu (if you'd want to migrate
the owner to the blocker's cpu, then you're quickly into trouble when
there's multiple blockers), but any way around this ends up being O(n).

Also, when the owner gets blocked on something that doesn't have an
owner (io completion, or a traditional semaphore), you have to take all
n tasks from the runqueue (and back again when they do become runnable).

PIP doesn't suffer this, but does suffer the pain from having to
reimplement the full schedule function on the waitqueues, which when you
have hierarchical scheduling means you have to replicate the full
hierarchy per waitqueue.

Furthermore we cannot assume locked sections are short, and we must
indeed assume that its any resource in the kernel associated with any
service which can be used by any thread, worse, it can be any odd
userspace resource/thread too, since we expose the block graph to
userspace processes through PI-futexes.

