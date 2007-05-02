Return-Path: <linux-kernel-owner+w=401wt.eu-S2992644AbXEBDHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992644AbXEBDHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992621AbXEBDHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:07:08 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:48298 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992644AbXEBDHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:07:05 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 23:07:05 EDT
Message-ID: <4637FE0A.7090405@cs.umass.edu>
Date: Tue, 01 May 2007 22:57:14 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu>
In-Reply-To: <20070501212223.GA29867@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Ingo

  My name is Ting Yang, a graduate student from UMASS. I am currently 
studying the linux scheduler and virtual memory manager to solve some 
page swapping problems. I am very excited with the new scheduler CFS. 
After I read through your code, I think that you might be interested in 
reading this paper:

  "A Proportional Share REsource Allocation Algorithm for Real-Time, 
Time-Shared Systems", by Ion Stoica. You can find the paper here: 
http://citeseer.ist.psu.edu/37752.html

  Authors of this paper proposed a scheduler: Earlist Eligible Virtual 
Deadline First (EEVDF). EEVDF uses exactly the same method as CFS to 
track the execution of each running task. The only difference between 
EEVDF and CFS is that EEVDF tries to _deadline_ fair while CFS is 
_start-time_ fair. Scheduling based on deadline gives better reponse 
time bound and seems to more fair.

  In the following part of this email, I will try to explain the 
similarities and differences between EEVDF and CFS. Hopefully, this 
might provide you with some useful information w.r.t your current work 
on CFS.

Similarities:
1. both EEVDF and CFS use virtual time to track the system's progress.
 
  CFS maintains rq->fair_clock for each cpu, which is updated every 
tick  by:
                SCALE/sum(p_i->loadweight)
  where p_i->loadweight is the weight of each task mapped from its nice  
value in prio_to_load_shift[], given that the default weight is SCALE (1024)
 
  EEVDF maintains a virtual time, which is advanced every tick by:
                1/sum(w_i) 
  where w_i is the weight of each task, given that the default weight is 1.

  Therefore, EEVDF and CFS monitors system progress in the same way,  
except normalized to different scale.

2. EEVDF and CFS monitors the progress in the same way.
 
  CFS maintains a p->fair_key which indicating the amount of work done 
by this task. When p executes for a period t, then p->fair_key 
incremented by:
           t * SCALE/p->loadweight //the default weight is SCALE
           (based on solving equations in your code :-))
 
  EEVDF does the same thing with assumption that the default weight is 
1,  it uses the same equation to calculate deadlines for running tasks.

Differences:
  The main difference between CFS and EEVDF lies in the scheduling 
policy, although they follow the same model for tracking tasks.

***  CFS: When a task starts, it gets p->fair_key from the current 
virtual time rq->fair_clock. It will not be scheduled for execution 
until all other running tasks' fair_key go beyond p->fair_key by certain 
virtual ticks (which is 5 ticks for the current setting of CFS).
 
  (I wish I could show examples with graphs, instead of my not-so-good 
english, but I am not sure if it appropriate to attach figures on this 
maillist)

  EXAMPLE: assume the system runs at 1000 tick/second, i.e. 1ms a tick, 
and the granularity of pre-exemption for CFS is 5 virtual ticks (the 
current setting). If, at time t=0, we start 2 tasks: p1 and p2, both 
have nice value 0 (weight 1024), and rq->fair_clock is initialized to 0. 
Now we have: 
        p1->fair_key = p2->fair_key = rq->fair_clock = 0.
CFS breaks the tie arbitrarily, say it executes p1. After 1 system tick 
(1ms later) t=1, we have:
        rq->fair_clock = 1/2, p1->fair_key = 1,  p2->fair_key = 0.
Suppose, a new task p3 starts with nice value -10 at this moment, that 
is p3->fair_key=1/2. In this case, CFS will not schedule p3 for 
execution until the fair_keys of p1 and p2 go beyond 5+1/2 (which 
translates to about 10ms later in this setting), _regardless_ the 
priority (weight) of p3. Further imagine, if we starts n tasks at time 
t=0 and then start a task p_(n+1) at time t = 1, the delay of task 
p_(n+1) actually is proportional to the number of running tasks n.

  Formally speaking, CFS can has a *O(n)* lag w.r.t the ideal 
proportional shared fluid-flow system, which can be arbitrarily fine 
granularity. The cause of this problem is that p->fair_key only reflects 
a fair point that a task should be started, but does not has any 
information about how urgent the task is (i.e. the priority or weight of 
the task).

***  In EEVDF, each task p_i is specified by 2 parameters: weight w_i 
and timeslice length l_i. EEVDF tries to schedule tasks based on the 
virtual deadline vd_i where a timeslice l_i should be finished.
     EEVDF keeps a virtual start (ve_i) and virtual deadline (vd_i) for 
each tasks. When a tasks starts, its ve_i is initialized to be the 
current virtual time, and calculates its virtual deadline as:
        vd_i = ve_i + l_i/w_i  //the same method as CFS updates fair_key.
When l_i amount of work is done, the just finished vd_i becomes the new 
ve_i. That is the virtual start time of next l_i amount work is the 
deadline of previous finished timeslice. The virtual deadline vd_i is 
then updated using the above equation.

     EEVDF schedule policy: always executes the task with the _earliest_ 
virtual deadline.

   EXAMPLE: Assume the system has 1000 ticks per second. At time t = 0, 
we start 2 tasks: p1 and p2, such that w_1 = w_2 = 1 and l_1 = l_2 = 5 
ticks, i.e 5ms (which reflects the similar setting in CFS case). 
Furthermore,  the system virtual time vt is initialized to be 0. Now at 
time t = 0, we have
            vt = 0,
            ve_1 = 0, vd_1 = ve_1 + l_1/w_1 = 5
            ve_2 = 0, vd_2 = vd_2 + l_2/w_2 = 5
As p1 and p2 have the same virtual deadline, EEVDF breaks the tie 
arbitrarily, say it executes p1. After 1 system tick (1ms later), we have:
      vt = 0 + 1 / (w_1 + w_2) = 1/2 //just as CFS updates rq->fair_clock
      ve_1 = 0, vd_1 = 5             //not changed
      ve_2 = 0, vd_1 = 5             //not changed
Suppose, we starts a new task p2 at this moment, with weight w_3 = 2 and 
timeslice l_3 = 5 ticks (5ms), Then
      ve_3 = vt = 1/2
      vd_3 = ve_3 + l_3/w_2 = 1/2 + 5/2 = 3
hmmm, the scheduler now will execute task p3 first since it has the 
earliest deadline. The deadline implicitly contains some very important 
information that the CFS fair_key does not have: how urgent this amount of
work has to be done, which comes from the weight of a task.

   Formally speaking, EEVDF has a constant O(1) lag w.r.t the ideal 
proportional shared fluid-flow system. (Please look at the paper for 
detail proofs.) Under normal cases, for a task p_i, EEVDF ensures that 
it does not fall behind the ideal system by more than l_i time. 
Occasionally, the delay can be max(l_i), the maximum timeslice used by 
all active tasks, due to the dynamic entering and leaving of tasks. 
(Again, the paper give more detailed explanation on this).

   We can see that here the timeslice l_i used by a task p_i actually 
controls accuracy of scheduling p_i. The smaller l_i, the closer to the 
ideal system during p_i's execution. For example, in above case, if p3 
has w_3 = 1 (the same as p1 and p2) and l_3 = 3 (3ms). Since vd_3 = 1/2 
+ l_3/w_3 = 7/2, the scheduler still executes p3 first, even though 
p1,p2 and p3 have the same weight. Smaller l_i leads the scheduler to 
handle p_i in finer granularity.  Intuitively, it makes scheduler checks 
the deadline of p_i more frequently
and ensures each small piece of work is done on time, while larger l_i 
does the reverse.

  The decouple of weight w_i and timeslice l_i is important. Generally 
speaking, weight determines throughput and timeslice determines the 
responsiveness of a task. In normal situation, high priority tasks 
usually need more cpu capacity within short period of time (bursty, such 
as keyboard, mouse move, X updates, daemons, etc), and need to be 
processed as quick as possible (responsiveness and interactiveness). 
Follow the analysis above, we know that for higher priority tasks we 
should give _higher weight_ to ensure its CPU throughput, and at the 
same time give _smaller timeslice_ to ensure better responsiveness.  
This is a bit counter-intuitive against the current linux 
implementation: smaller nice value leads to higher weight and larger 
timeslice.

  Now let's see what happens in the Real-Time world. Usually a real-time 
application is specified with (C_i, T_i), where C_i is the amount of 
work  and T_i is the period of time that the work has to be finished. 
For example, (20ms, 50ms) says the scheduler has to do 20ms work within 
a window of 50ms for this task. Smaller T_i gives tighter response 
constraints. Note that Bi = Ci/Ti is really the CPU proportion for the 
task during its execution. In our proportional time share world, weight 
w_i decides the cpu proportion which maps to Bi, and timeslice l_i gives 
the amount works should be done each time, which maps Ci. Then using w_i 
and l_i, we can get a window size, which actually maps Ti. Therefore 
smaller l_i leads to smaller Ti which means tighter response 
constraints. It seems to me all these make a lot sense in both 
proportional time share and real-time world.  

  Based on my understanding, adopting something like EEVDF in CFS should 
not be very difficult given their similarities, although I do not have 
any idea on how this impacts the load balancing for SMP. Does this worth 
a try?

  Sorry for such a long email :-)

Ting

