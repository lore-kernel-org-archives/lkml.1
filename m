Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZGLGSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZGLGSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 02:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZGLGR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 02:17:59 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:35069 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZGLGR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 02:17:58 -0400
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sun, 12 Jul 2009 08:17:40 +0200
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop>
In-Reply-To: <1247336891.9978.32.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907120817.41560.henrik@austad.us>
X-SA-Exim-Connect-IP: 212.251.216.90
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on asterix.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 July 2009 20:28:11 Peter Zijlstra wrote:
> On Fri, 2009-07-10 at 23:50 +0200, Henrik Austad wrote:
> > Hi all!
> >
> > This is a proposal for a global [1], deadline driven scheduler for
> > real-time tasks in the Linux kernel. I thought I should send out an RFC
> > to gather some feedback instead of wildy hack away at it.
> >
> > This proposed scheduler is a modified MLLF (modified Least Laxity First)
> > called Earliest Failure First (EFF) as it orders tasks according to when
> > they will miss their deadlines, not when the actual deadline is.
>
> <snip>
>
> Everybody agrees we want a deadline scheduler, we'll probably put a user
> interface into -rt shortly which should work for all the involved
> research groups so that we can share tests and have better comparisons.

My plan is to start working on this with Bill's framework once that is stable 
enough and it has the expressiveness I need.

> The only thing (aside from an utter lack of time to work on things
> recently) that has been holding us back is a proper solution to the
> priority inversion issue.
>
> I haven't fully read through the proposed algorithm below, and left it
> in place for the new people on CC.
>
> As already mentioned on IRC, the fact that you push the work to the last
> possible moment indicates that this algorithm will utterly fall apart on
> overload and would thus be unsuited for soft-rt loads, but I guess we
> could implement things like EDF-fm and keep this as a hard-rt class.

Not pushing the work to the last instance per se, but scheduling out a running 
thread only when it is absolutely necessary to reduce the number of 
task-preemptions.

When a new task (A) arrives you compare it to the head of the waiting queue 
(B), and if A has a 'graver' need for running than B, you move on to look at 
the tail of the running queue (C). If A has higher need than C, you let A 
run, but only if not running A will cause a dl-miss and not for B.

> > [...]
> > There are still some issues left to solve, for instance how to best
> > handle sporadic tasks, and whether or not deadline-miss should be allow,
> > or just 'bounded deadline tardiness'. Either way, EFF should be able to
> > handle it. Then, there are problems concerning blocking of tasks. One
> > solution would be BWI or PEP, but I have not had the time to read
> > properly through those, but from what I've gathered a combination of BWI
> > and PEP looks promising (anyone with good info about BWI and PEP - feel
> > free to share! (-: ).
>
> Our SSSUP friends have a BWI paper here:
>
>   http://retis.sssup.it/~tommaso/publications/OSPERT-2008.pdf

thanks!

> The thing we call PEP was christened so by Douglas Niehaus (on CC), I'm
> not sure if he has any papers on it.

A general outline would also be great as I treat PEP the way I *think* it is 
after some discussions on IRC etc.

> Also, when talking about it at OSPERT last week Ted Baker (also on CC)
> said it reminded him of something else of which I seem to have forgotten
> the name.
>
> Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
> but SMP leaves things to be desired. Dhaval is currently working on a
> PEP implementation that will migrate all the blocked tasks to the
> owner's cpu, basically reducing it to the UP problem.

I think that PEP will work better on MP, at least for the entire system, but 
not for a single thread.

If you move the task holding the resource to the CPU of the blocked task, and 
let the holder consume part of the requestor's budget, it will be easier to 
to schedule the actual thread for running as you have complete control over 
the current CPU. More importantly, you can ensure that the total utilization 
is bounded, not only within the group (if you use EFF in a clustered setup), 
but also when the holder belongs to another group.

If several threads want to run the holder through the proxy, things will of 
course get complicated, but the same goes for BWI.

The downside of PEP, is that you introduce unpredictability with consumed 
resource as other threads can consume a threads resource. This makes it 
harder to analyze a single thread.


> > 1) Before you freeze at 'global' and get all caught up on "This won't
> >    ever scale to X", or "He will be haunted by Y" - I do not want to
> >    extend a global algorithm to 2000 cores. I would like to scale to a
> >    single *chip* and then we can worry about 2-way and 4-way systems
> >    later. For the record, I've donned my asbestos suit anyway.
>
> My preferred approach here is to find a distributed algorithm that
> converges to the global one.
>
> > 2) http://austad.us/kernel/thesis_henrikau.pdf
> >
> > 3) Anyone want to include LaTeX-notation into an email-rfc?
>
> Not unheard of ;-)

perhaps this 'Web 2.0' will come up with a solution :)

-- 
henrik
-- 
     henrik
