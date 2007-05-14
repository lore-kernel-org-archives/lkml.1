Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbXENObZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbXENObZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXENObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:31:19 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50417 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754094AbXENObS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:31:18 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: fair clock use in CFS
Date: Mon, 14 May 2007 10:31:13 -0400
User-Agent: KMail/1.9.6
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de,
       tingy@cs.umass.edu, linux-kernel@vger.kernel.org
References: <20070514083358.GA29775@in.ibm.com> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu>
In-Reply-To: <20070514115049.GA28721@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141031.13528.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 07:50:49 Ingo Molnar wrote:
> * William Lee Irwin III <wli@holomorphy.com> wrote:
> > On Mon, May 14, 2007 at 12:31:20PM +0200, Ingo Molnar wrote:
> > > please clarify - exactly what is a mistake? Thanks,
> >
> > The variability in ->fair_clock advancement rate was the mistake, at
> > least according to my way of thinking. [...]
>
> you are quite wrong. Lets consider the following example:
>
> we have 10 tasks running (all at nice 0). The current task spends 20
> msecs on the CPU and a new task is picked. How much CPU time did that
> waiting task get entitled to during its 20 msecs wait? If fair_clock was
> constant as you suggest then we'd give it 20 msecs - but its true 'fair
> expectation' of CPU time was only 20/10 == 2 msecs!

Either you have a strange definition of fairness or you chose an extremely 
poor example, Ingo. In a fair scheduler I'd expect all tasks to get the exact 
same amount of time on the processor. So if there are 10 tasks running at 
nice 0 and the current task has run for 20msecs before a new task is swapped 
onto the CPU, the new task and *all* other tasks waiting to get onto the CPU 
should get the same 20msecs. What you've described above is fundamentally 
unfair - one process running for 20msecs while the 10 processes that are 
waiting for their chance each get a period that increases from a short period 
at a predictable rate.

Some numbers based on your above description:
Process 1 runs for 20msecs
Process 2 runs for 2msecs  (20/10 == 2msecs) 
Process 3 runs for 2.2msecs (has waited 22msecs, 22/10 == 2.2)
Process 4 runs for 2.4msecs (has waited 24.2msecs - rounded for brevity)
Process 5 runs for 2.7msecs (has waited 26.6msecs - rounded for brevity)
process 6 runs for 3msecs  (has waited 30.3msecs)
process 7 runs for 3.3msecs (has waited approx. 33msecs)
process 8 runs for 3.6msecs (has waited approx. 36msecs)
process 9 runs for 3.9msecs (has waited approx. 39msecs)
process 10 runs for 4.2msecs (has waited approx. 42msecs)

Now if the "process time" isn't scaled to match the length of time that the 
process has spent waiting to get on the CPU you get some measure of fairness 
back, but even then the description of CFS you've given shows a fundamental 
unfairness.

However, if you meant that "the new process has spent 20msecs waiting to get 
on the CPU", then the rest of your description does show what I'd expect from 
a fair scheduler. If not, then I guess that CFS is only "Completely Fair" for 
significantly large values of "fair".

(I will not, however, argue that CFS is'nt a damned good scheduler that has 
improved interactivity on the systems of those people that have tested it)

> So a 'constant' fair_clock would turn the whole equilibrium upside down
> (it would inflate p->wait_runtime values and the global sum would not be
> roughly constant anymore but would run up very fast), especially during
> fluctuating loads.

Hrm... Okay, so you're saying that "fair_clock" runs slower the more process 
there are running to keep the above run-up in "Time Spent on CPU" I noticed 
based solely on your initial example? If that is the case, then I can see the 
fairness - its just not visible from a really quick look at the code and the 
simplified description you gave earlier.

DRH
