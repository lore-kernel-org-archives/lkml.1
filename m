Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbXICSUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbXICSUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXICSU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:20:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1102 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbXICSU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:20:29 -0400
Date: Mon, 3 Sep 2007 20:20:52 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <1188745208.11196.59.camel@dhcp193.mvista.com>
Message-ID: <Pine.LNX.4.64.0709031522570.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> 
 <1188694367.11196.42.camel@dhcp193.mvista.com>  <Pine.LNX.4.64.0709021634370.1817@scrub.home>
 <1188745208.11196.59.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Daniel Walker wrote:

> For instance if there are three tasks in the system. Call them A,B, and
> C.
> 
> then 
> 
> time equals "time of A" + "time of B" + "time of C"

Ok, let's take a simple example. :)

If we have three task A, B, C, each with a weight of 1, 2, 3, so the 
weight sum is 6. If we let these three tasks run over a period of 12s, 
each task gets time/weight_sum*weight_{t} seconds, that is each task gets 
2, 4, 6 seconds of runtime.
The basic idea of CFS is now that using this formula, the time is
distributed to the active tasks and accounted against the runtime they
get. Let's assume a time slice of 1s, where each task gets
1s/weight_sum*weight_{t} of eligible runtime every second, so in the 
following table the task column contains the values (eligible runtime 
- obtained runtime):

time	current	A		B		C		fair_clock
1	C	1/6-0		2/6-0		3/6-1		1/6
2	C	2/6-0		4/6-0		6/6-2		2/6
3	C	3/6-0		6/6-0		9/6-3		3/6
4	B	4/6-0		8/6-1		12/6-3		4/6
5	B	5/6-0		10/6-2		15/6-3		5/6
6	A	6/6-1		12/6-2		18/6-3		6/6
7	C	7/6-1		14/6-2		21/6-4		7/6
8	C	8/6-1		16/6-2		24/6-5		8/6
9	C	9/6-1		18/6-2		27/6-6		9/6
10	B	10/6-1		20/6-3		30/6-6		10/6
11	B	11/6-1		22/6-4		33/6-6		11/6
12	A	12/6-2		24/6-4		36/6-6		12/6

Practically the eligible runtime part isn't updated constantly, but a
delta against the last update is used. If everything is working
correctly in the end the difference between the eligible and obtained
runtime is zero.

Peter's patches now make an interesting step, basically they change the
position of the weight_{t} variable, so every task get's now
1s/weight_sum per second and weight_{t} is now used to scale the
obtained runtime instead:

time	current	A		B		C		fair_clock
1	C	1/6-0/1		1/6-0/2		1/6-1/3		1/6
2	C	2/6-0/1		2/6-0/2		2/6-2/3		2/6
3	C	3/6-0/1		3/6-0/2		3/6-3/3		3/6
4	B	4/6-0/1		4/6-1/2		4/6-3/3		4/6
5	B	5/6-0/1		5/6-2/2		5/6-3/3		5/6
6	A	6/6-1/1		6/6-2/2		6/6-3/3		6/6
7	C	7/6-1/1		7/6-2/2		7/6-4/3		7/6
8	C	8/6-1/1		8/6-2/2		8/6-5/3		8/6
9	C	9/6-1/1		9/6-2/2		9/6-6/3		9/6
10	B	10/6-1/1	10/6-3/2	10/6-6/3	10/6
11	B	11/6-1/1	11/6-4/2	11/6-6/3	11/6
12	A	12/6-2/1	12/6-4/2	12/6-6/3	12/6

As you can see here the fair_clock part is the same for every task in 
every row, so that it can be removed, this is basically the step I do in 
my patch:

time	current	A		B		C		fair_clock
1	C	0/1		0/2		1/3		1/6
2	C	0/1		0/2		2/3		2/6
3	C	0/1		0/2		3/3		3/6
4	B	0/1		1/2		3/3		4/6
5	B	0/1		2/2		3/3		5/6
6	A	1/1		2/2		3/3		6/6
7	C	1/1		2/2		4/3		7/6
8	C	1/1		2/2		5/3		8/6
9	C	1/1		2/2		6/3		9/6
10	B	1/1		3/2		6/3		10/6
11	B	1/1		4/2		6/3		11/6
12	A	2/1		4/2		6/3		12/6

This means fair_clock isn't used in the runtime calculation anymore and
time isn't relative to fair_clock, but it's an absolute value. It looks
relatively simple, but it means all calculations involving fair_clock
deltas and wait_runtime values have to be redone in this context and
that's the part where I need some help with - some of the tuning
features aren't converted yet.
The importance of this step is that it removes a major error source for
the accuracy of the scheduler. All these fractions have to be rounded to
integer values at some point and the main problem here is that the
denominator in the fair_clock calculation is variable - it changes with
the number of active tasks and it requires quite some resolution, so the
error doesn't become noticable.

fair_clock isn't used here anymore, but it's still used to initialize the 
time value of new tasks. For this I can approximate it and that is the 
major part of the math involved to make it so accurate, that the error 
doesn't grow over time and stays within a certain limit.
The basic idea here is to compensate for the rounding errors which are 
inevitable. Let's look at the last row at time 12, if we add up the time 
values and denormalize them (remove the weight part), we get a sum like 
this: round(2/1)*1 + round(4/2)*2 + round(6/3)*3 ~= 12, that means I don't 
use the real time value 12, I use an approximated time value instead which 
is calculated from the individual task times so it includes the rounding 
errors that happened during the calculation of these task times.

Basically that's it and I hope that explains the basic math a bit easier. :-)

bye, Roman
