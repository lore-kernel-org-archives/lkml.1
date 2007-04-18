Return-Path: <linux-kernel-owner+w=401wt.eu-S2993060AbXDRTPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993060AbXDRTPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993059AbXDRTPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:15:52 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:26282 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993057AbXDRTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:15:51 -0400
Message-ID: <46266E5F.4060205@bigpond.net.au>
Date: Thu, 19 Apr 2007 05:15:43 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au> <20070417075146.GM2986@holomorphy.com> <462485B8.8090404@bigpond.net.au>
In-Reply-To: <462485B8.8090404@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Wed, 18 Apr 2007 19:15:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> William Lee Irwin III wrote:
>> Ingo Molnar wrote:
>>>> this is the second release of the CFS (Completely Fair Scheduler) 
>>>> patchset, against v2.6.21-rc7:
>>>>    http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
>>>> i'd like to thank everyone for the tremendous amount of feedback and 
>>>> testing the v1 patch got - i could hardly keep up with just reading 
>>>> the mails! Some of the stuff people addressed i couldnt implement 
>>>> yet, i mostly concentrated on bugs, regressions and debuggability.
>>
>> On Tue, Apr 17, 2007 at 04:46:57PM +1000, Peter Williams wrote:
>>> Have you considered using rq->raw_weighted_load instead of 
>>> rq->nr_running in calculating fair_clock?  This would take the nice 
>>> value (or RT priority) of the other tasks into account when 
>>> determining what's fair.
>>
>> I suspect you mean (curr->load_weight*delta_exec)/rq->raw_weighted_load
>> in update_curr().
> 
> Or something like that, yes. :-)

Actually, this formula can't be used for the migration thread itself as 
its load_weight isn't an accurate reflection of its static priority. 
But as the migration thread is a real time task this probably isn't an 
issue, right?

If this assumption is correct (i.e. curr is never a real time task) then 
my earlier caveat re division by zero being possible is invalid because 
the migration task will never be the only task on the runqueue when this 
code is called.

I'm also assuming here that (because of its name) curr is already on the 
runqueue when this code is called.  If it isn't the divisor in the above 
expression should be (rq->raw_weighted_load + curr->load_weight).  This 
would also preclude the possibility of divide by zero.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
