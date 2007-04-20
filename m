Return-Path: <linux-kernel-owner+w=401wt.eu-S1031174AbXDTAKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031174AbXDTAKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031164AbXDTAKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:10:50 -0400
Received: from omta04sl.mx.bigpond.com ([144.140.93.156]:53008 "EHLO
	omta04sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031145AbXDTAKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:10:49 -0400
Message-ID: <46280505.4020605@bigpond.net.au>
Date: Fri, 20 Apr 2007 10:10:45 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu>
In-Reply-To: <20070418175017.GA5250@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta08sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Fri, 20 Apr 2007 00:10:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>  - bugfix: use constant offset factor for nice levels instead of 
>    sched_granularity_ns. Thus nice levels work even if someone sets 
>    sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
>    address the many nice level related suggestions in -v4.

I have a suggestion I'd like to make that addresses both nice and 
fairness at the same time.  As I understand the basic principle behind 
this scheduler it to work out a time by which a task should make it onto 
the CPU and then place it into an ordered list (based on this value) of 
tasks waiting for the CPU.  I think that this is a great idea and my 
suggestion is with regard to a method for working out this time that 
takes into account both fairness and nice.

First suppose we have the following metrics available in addition to 
what's already provided.

rq->avg_weight_load /* a running average of the weighted load on the CPU */
p->avg_cpu_per_cycle /* the average time in nsecs that p spends on the 
CPU each scheduling cycle */

where a scheduling cycle for a task starts when it is placed on the 
queue after waking or being preempted and ends when it is taken off the 
CPU either voluntarily or after being preempted.  So 
p->avg_cpu_per_cycle is just the average amount of time p spends on the 
CPU each time it gets on to the CPU.  Sorry for the long explanation 
here but I just wanted to make sure there was no chance that "scheduling 
cycle" would be construed as some mechanism being imposed on the scheduler.)

We can then define:

effective_weighted_load = max(rq->raw_weighted_load, rq->avg_weighted_load)

If p is just waking (i.e. it's not on the queue and its load_weight is 
not included in rq->raw_weighted_load) and we need to queue it, we say 
that the maximum time (in all fairness) that p should have to wait to 
get onto the CPU is:

expected_wait = p->avg_cpu_per_cycle * effective_weighted_load / 
p->load_weight

Calculating p->avg_cpu_per_cycle costs one add, one multiply and one 
shift right per scheduling cycle of the task.  An additional cost is 
that you need a shift right to get the nanosecond value from value 
stored in the task struct. (i.e. the above code is simplified to give 
the general idea).  The average would be number of cycles based rather 
than time based and (happily) this simplifies the calculations.

If the expected time to get onto the CPU (i.e. expected_wait plus the 
current time) for p is earlier than the equivalent time for the 
currently running task then preemption of that task would be justified.

I appreciate that the notion of basing the expected wait on the task's 
average cpu use per scheduling cycle is counter intuitive but I believe 
that (if you think about it) you'll see that it actually makes sense.

Peter
PS Some reordering of calculation order within the expressions might be 
in order to keep them within the range of 32 bit arithmetic and so avoid 
64 bit arithmetic on 32 bit machines.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
