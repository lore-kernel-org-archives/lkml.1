Return-Path: <linux-kernel-owner+w=401wt.eu-S1767338AbXECCs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767338AbXECCs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767339AbXECCs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:48:26 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:57281 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767338AbXECCsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:48:25 -0400
Message-ID: <46394D6F.9090302@cs.umass.edu>
Date: Wed, 02 May 2007 22:48:15 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com>
In-Reply-To: <20070502174829.GX19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   As encouraged by some of you, I have started implementing EEVDF. 
However, I am quite new in this area, and may not be experienced enough 
to get it through quickly.  The main problems, I am facing now ,is how 
to treat the semantics of yeild() and yield_to(). I probably will throw 
a lot of questions along the way of my implementation.

   Also I found my previous email was not clear enough in describing the 
properties of CFS and EEVDF and caused some confusion, and there were 
also some mistakes too. In this email, I will try to make up for that.

*** Let's start from CFS:
    For simplicity, let's assume that CFS preempt the current task p1 by 
another tasks p2, when p1->key - p2->key >1, and the virtual time 
rq->fair_clock is initialized to be 0. Suppose, at time t = 0, we start 
n+1 tasks that run long enough. task 1 has weight n and all other tasks 
have weight 1. It is clear that, at time t=0, p_1->key = p_2->key = ... 
=p_(n+1)-> key = rq->fair_clock = 0
 
   Since all tasks has the same key, CFS breaks the ties arbitrarily, 
which leads to many possibilities. Let's consider 2 of them:
_Case One:_ p1, which has weight n, executes first:
          t = 1: rq->fair_clock = 1/2n,  p1->key = 1/n       // others 
are not changed.
          t = 2: rq->fair_clock = 2/2n,  p1->key = 2/n
                                   ...
          t = n: rq->fair_clock = n/2n,   p1->key = n/n = 1
    Only after p1 executes n ticks, the scheduler will pick another task 
for execution. Between time [0, n)
the amount of actual work done by p1 is n. The amount of work should be 
done in ideal fluid-flow system is n * n/2n = n/2. Therefore the lag is 
n/2 - n = -n/2, negative means p1 goes faster than the ideal case. As we 
can see this lag is O(n).
_Case Two:_ the scheduler executes the tasks in the order p2, p3, ..., 
p_(n+1), p1
          t = 1: rq->fair_clock = 1/2n,  p2->key = 1;         // others 
are not changed
          t = 2: rq->fair_clock = 2/2n,  p3->key = 1;
                                ....
          t = n: rq->fair_clock = n/2n,  p_(n+1)->key = 1;
    Then the scheduler picks p1 (weight n) for execution. Between time 
[0, n) the amount actual work done by p1 is 0, and the ideal amount is 
n/2. Therefore the lag is n/2 - 0, positive means p1 falls behind the 
ideal case. The lag here for p1 is also O(n).
    As I said in the previous email, p->fair_key only has the 
information of past execution of a task and reflects a fair start point. 
It does not have the information about weight.

*** Now, let's look at EEVDF.
I have to say that I missed a very important concept in EEVDF which 
leads to confusions here. EEVDF stands for _Eligible_ Earliest Virtual 
Deadline First, and I did not explain what is _eligible_.

EEVDF maintains a virtual start time ve_i and virtual deadline vd_i for 
each task p_i, as well as a virtual time vt. A newly started/waked task 
has its ve_i initialized to be the current virtual time. Once a 
timeslice l_i amount of work is done, the new virtual start time is set 
to be the previous virtual deadline, and then virtual deadline vd_i is 
recalculated.
             A task is eligible,  if and only if  ve_i  <=  current 
virtual time vt
EEVDF, at every tick, always picks the eligible task  which has the 
earliest virtual deadline for execution

Let's see how it works using a similar example as for CFS above.
Suppose, at time t = 0, we starts n+1 tasks. p1 has weight n, and all 
others have weight 1. For simplicity, we assume all task use timeslice 
l_i = 1, and virtual time vt is initialized to be 0.
   - at time t = 0, we have
             vt = 0;
             ve_1 = 0, vd_1 = ve_1 + l_1/w_1 = 1/n
             ve_2 = 0, vd_2 = ve_1 + l_2/w_2 = 1
                           ...
             ve_(n+1) = 0, vd_(n+1) = ve_(n+1) + l_(n+1)/w_(n+1) = 1;
    Since p1 is eligible and has the earliest deadline 1/n, the 
scheduler will executes it first. (Here, the weight which encoded in the 
deadline plays an important rule, and allows higher weight tasks to be 
executed first).
     - at time t = 1: 
              vt = 1/2n, 
              ve_1 = 1/n (previous vd_1), vd_1 = ve_1 + 1/n = 2/n
     Since ve_1 > vt, p1 is _not_ eligible. EEVDF picks another task for 
execution by breaking the tie, say
it executes p2.
    - at time t = 2:
              vt = 2/2n = 1/n,  ve_1 = 1/n, vd_1 = 2/n
              ve_2 = 1, ve_2 = ve_2 + 1/1 = 2             // this makes 
p2 not eligible
      Since vt = ve_1, p1 becomes eligible again and has the earliest 
deadline 2/n, it will be scheduled for execution.  As EEVDF repeats, it 
give a schedule like p1, p2, p1,p3, p1, p4, p1 ....  (presented by each 
tick).  As you can see, now p1 never falls behind/goes before the ideal 
case by 1.
    
      Now, let's check how timeslice l_i impacts the system. Suppose, we 
change the timeslice of p1 from 1 to 2, and keep others unchanged. EEVDF 
gives a schedule like:
            p1, p1, p2, p3, p1, p1, p4, p5, p1, p1, ....      (presented 
by each tick)
similarly if timeslice of p1 is set to be 3, EEVDF gives
            p1, p1, p1, p2, p3, p4, p1, p1, p1, ....            
(presented by each tick)
      As the timeslice of p1 increases, the system checks for reschedule 
less frequently, thus makes the lag of p1 becomes longer, but the lag 
will not be larger than the maximum timeslice used, as long as it is a 
fixed constant. On the other hand, increasing the timeslice of other 
tasks has no effect on when p1 is schedule. ( you can try to play the 
algorithm by yourself :-))

     In CFS, a task has to increases p->fair_key for a certain amount so 
that the scheduler can consider it to be preempted. Higher weight leads 
to less progress in p->fair_key, and then effectively large timeslice.
Suppose the preempt granularity is 5 virtual ticks, then a task of 
weight 1 needs to run 5 ticks, weight 2 need 10 ticks, weight 10 needs 
50 ticks. The effect is that the timeslice increases linearly w.r.t 
weight, and causes the O(n) lag. In fact, we use timeslice n for p1 in 
the above example for EEVDF, it behaves exactly as CFS.

    Now, I have fix an incorrect statement about EEVDF's lag bound in my 
previous email:
    Under EEVDF, a task's lag (difference between the amount work should 
be done in ideal fluid-flow system and the actual amount of work done) 
is bounded by the maximum timeslice used. (not occasionally as I said in 
my previous email). This actually means the maximum timeslice used 
controls the total responsiveness of the system. Also the combination of 
high weight and smaller timeslice will give better response guarantee 
for those bursty response-time sensitive tasks.

    Sorry for the late replay. I had an eye exam today and got my eyes 
dilated, which forced me to stay away from my computer for a while :-)

Ting


