Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXDPHQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXDPHQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXDPHQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:16:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:42533 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbXDPHQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=VSTNOHoyITDBPUCCkTeyqkl5iGKIJ7gZMyGqdcE0QuKQN8OMqHT4CzfEQkks+zgNfLqICYpISaWHYoHT8vB0HZFqCWQbuRlER/BIn1kfNf975X0sDIbGxQlf9Sz34BQMxSpdMeqWq7Qw9xsaaoW/imFFyWw/WiuRr2dg5cEsan0=
Date: Mon, 16 Apr 2007 09:16:18 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Ingo Molnar <mingo@elte.hu>
cc: Esben Nielsen <nielsen.esben@googlemail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070415130416.GA4312@elte.hu>
Message-ID: <Pine.LNX.4.64.0704151553340.11750@frodo.shire>
References: <20070413202100.GA9957@elte.hu> <Pine.LNX.4.64.0704151419140.11750@frodo.shire>
 <20070415130416.GA4312@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007, Ingo Molnar wrote:

>
> * Esben Nielsen <nielsen.esben@googlemail.com> wrote:
>
>> I took a brief look at it. Have you tested priority inheritance?
>
> yeah, you are right, it's broken at the moment, i'll fix it. But the
> good news is that i think PI could become cleaner via scheduling
> classes.
>
>> As far as I can see rt_mutex_setprio doesn't have much effect on
>> SCHED_FAIR/SCHED_BATCH. I am looking for a place where such a task
>> change scheduler class when boosted in rt_mutex_setprio().
>
> i think via scheduling classes we dont have to do the p->policy and
> p->prio based gymnastics anymore, we can just have a clean look at
> p->sched_class and stack the original scheduling class into
> p->real_sched_class. It would probably also make sense to 'privatize'
> p->prio into the scheduling class. That way PI would be a pure property
> of sched_rt, and the PI scheduler would be driven purely by
> p->rt_priority, not by p->prio. That way all the normal_prio() kind of
> complications and interactions with SCHED_OTHER/SCHED_FAIR would be
> eliminated as well. What do you think?
>

Now I have not read your patch into detail. But agree it would be nice to 
have it more "OO" and remove cross references between schedulers. But 
first one should consider wether PI between SCHED_FAIR tasks or not is 
usefull or not. Does PI among dynamic priorities make sense at all? I think it
does: On heavy loaded systems where a nice 19 might not get the CPU for 
very long, a nice -20 task can be priority inverted for a very long 
time.
But I see no need it taking the dynamic part of the effective priorities 
into account. The current/old solution of mapping the static nice values 
into a global priority index which can incorporate the two scheduler 
classes is probably good enough - it just has to be "switched on" a again 
:-)

But what about other scheduler classes which some people want to add in
the future? What about having a "cleaner design"?

My thought was to generalize the concept of 'priority' to be an
object (a struct prio) to be interpreted with help from a scheduler class 
instead of globally interpreted integer.

int compare_prio(struct prio *a, struct prio *b)
{
 	if (a->sched_class->class_prio < b->sched_class->class_prio)
 		return -1;

 	if (a->sched_class->class_prio < b->sched_class->class_prio)
 		return +1;


 	return a->sched_class->compare_prio(a, b);

}

Problem 1: Performance.

Problem 2: Operations on a plist with these generalized priorities are not 
bounded because the number of different priorites are not bounded.

Problem 2 could be solved by using a combined plist (for rt priorities) 
and rbtree (for fair priorities) - making operations logarithmic just as 
the fair scheduler itself. But that would take more memory for every 
rtmutex.

I conclude that is too complicated and go on to the obvious idea:
Use a global priority index where each scheduler class get's it own 
range (rt: 0-99, fair 100-139 :-). Let the scheduler class have a 
function returning it instead of reading it directly from task_struct such
that new scheduler classes can return their own numbers.

Esben


> 	Ingo
>
