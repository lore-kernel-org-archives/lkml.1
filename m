Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYFXNSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYFXNSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYFXNSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:18:45 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:37485 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYFXNSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:18:44 -0400
Message-Id: <4860BBF2.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 24 Jun 2008 07:18:42 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <tglx@linutronix.de>,
       "David Bahi" <DBahi@novell.com>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at
	leastone task has moved over
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
 <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
 <1214302406.4351.23.camel@twins>
In-Reply-To: <1214302406.4351.23.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jun 24, 2008 at  6:13 AM, in message <1214302406.4351.23.camel@twins>,
Peter Zijlstra <peterz@infradead.org> wrote: 
> On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
>> Inspired by Peter Zijlstra.
>> 
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>> 
>>  kernel/sched.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>> 
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 3efbbc5..c8e8520 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int 
> this_cpu, struct rq *busiest,
>>  				max_load_move - total_load_moved,
>>  				sd, idle, all_pinned, &this_best_prio);
>>  		class = class->next;
>> +
>> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
>> +			break;
>> +
>>  	} while (class && max_load_move > total_load_moved);
>>  
>>  	return total_load_moved > 0;
> 
> 
> right,.. uhm, except that you forgot all the other fixes and
> generalizations I had,..

Heh...well I intentionally simplified it, but perhaps that is out of ignorance.  I did say "inspired by" ;)

> 
> The LB_START/LB_COMPLETE stuff is needed to fix CFS load balancing. It
> now always iterates the first sysctl_sched_nr_migrate tasks, and if it
> doesn't find any there, just gives up - which isn't too big of a problem
> with it set to 32, but if you drop it to 2/4 stuff starts valing apart.
> 
> And the break I had here, only checks classes above and equal to the
> current class.
> 
> This again is needed when you have more classes.

Im not sure I understand/agree here (unless you plan on having a class below sched_idle()??)

The fact that we are going NEWLYIDLE to me implies that all the other classes are
"above or equal".  And rq->nr_running approximates all the per-class vtable work
that you had done to probe the higher classes.  We currently only hit this code when
rq->nr_running == 0, so rq->nr_running !=0 seems like a logical termination
condition.

I guess what I am not clear on is: "when would we be NEWLYIDLE in a higher class,
yet have tasks populated in lower classes such at nr_running is non-zero".
Additionally, even if we have that condition (e.g. with something like the EDF work you
are doing, perhaps?), shouldn't we patch the advanced form of this logic when the rest
of the code goes in?  For now, this seems like the most straight forward way to
accomplish the goal.  But I could be missing something ;)

Regards,
-Greg

