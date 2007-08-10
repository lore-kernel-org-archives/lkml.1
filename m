Return-Path: <linux-kernel-owner+w=401wt.eu-S935984AbXHJNwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935984AbXHJNwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759652AbXHJNwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:52:02 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4234 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632AbXHJNwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:52:00 -0400
Date: Fri, 10 Aug 2007 15:52:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070810054948.GA5908@elte.hu>
Message-ID: <Pine.LNX.4.64.0708101459530.1817@scrub.home>
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu>
 <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu>
 <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
 <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home>
 <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home>
 <20070810054948.GA5908@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 10 Aug 2007, Ingo Molnar wrote:

> > I disabled the jiffies logic and the result is still the same, so this 
> > problem isn't related to resolution at all.
> 
> how did you disable the jiffies logic?

I commented it out.

> Also, could you please send me 
> the cfs-debug-info.sh:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> captured _while_ the above workload is running. This is the third time 
> i've asked for that :-)

Is there any reason to believe my analysis is wrong?
So far you haven't answered a single question about the CFS design...

Anyway, I give you something better - the raw trace data for 2ms:

1186747669.274790012: update_curr 0xc7fb06f0,479587,319708,21288884188,159880,7360532
1186747669.274790375: dequeue_entity 0xc7fb06f0,21280402988,159880
1186747669.274792580: sched 2848,2846,0xc7432cb0,-7520413
1186747669.274820987: update_curr 0xc7432ce0,29302,-130577,21288913490,1,-7680293
1186747669.274821269: dequeue_entity 0xc7432ce0,21296077409,1
1186747669.274821930: enqueue_entity 0xc7432ce0,21296593783,1
1186747669.274826979: update_curr 0xc7432ce0,5707,5707,21288919197,1,-7680294
1186747669.274827724: enqueue_entity 0xc7432180,21280919197,639451
1186747669.274829948: update_curr 0xc7432ce0,1553,-318172,21288920750,319726,-8000000
1186747669.274831878: sched 2846,2847,0xc7432150,8000000
1186747669.275789883: update_curr 0xc7432180,479797,319935,21289400547,159864,7360339
1186747669.275790295: dequeue_entity 0xc7432180,21280919197,159864
1186747669.275792439: sched 2847,2846,0xc7432cb0,-7520203
1186747669.275820819: update_curr 0xc7432ce0,29238,-130625,21289429785,1,-7680067
1186747669.275821109: dequeue_entity 0xc7432ce0,21296593783,1
1186747669.275821763: enqueue_entity 0xc7432ce0,21297109852,1
1186747669.275826887: update_curr 0xc7432ce0,5772,5772,21289435557,1,-7680068
1186747669.275827652: enqueue_entity 0xc7fb0ca0,21281435557,639881
1186747669.275829826: update_curr 0xc7432ce0,1549,-318391,21289437106,319941,-8000000
1186747669.275831584: sched 2846,2849,0xc7fb0c70,8000000

About the values:

update_curr: sched_entity, delta_fair, delta_mine, fair_clock, sleeper_bonus, wait_runtime
	(final values at the end of __update_curr)
{en,de}queue_entity: sched_entity, fair_key, sleeper_bonus
	(at the start of __enqueue_entity/__dequeue_entity)
sched: prev_pid,pid,current,wait_runtime
	(at the end of scheduling, note that current has a small structure 
	offset to sched_entity)

It starts with a timer task going to sleep, the busy loop runs for a few 
usec until the timer tick, the next timer task is woken up (sleeper_bonus 
is increased). Before switching the tasks, current task is updated and 
it's punished with the sleeper_bonus.

These tests are done without the recent updates, but they don't seem to
change the basic logic. AFAICT the change to __update_curr() only makes it 
more unpredictable, which task is punished with the sleeper_bonus.

So again, what is this logic _supposed_ to do?

bye, Roman
