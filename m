Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZIUXxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZIUXxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZIUXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:53:14 -0400
Received: from nschwmtas02p.mx.bigpond.com ([61.9.189.140]:57406 "EHLO
	nschwmtas02p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbZIUXxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:53:13 -0400
Message-ID: <4AB811EA.5050807@bigpond.net.au>
Date: Tue, 22 Sep 2009 09:53:14 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sched: Am I missing something?
References: <4AB77E21.6020805@bigpond.net.au> <1253541183.8439.168.camel@twins>
In-Reply-To: <1253541183.8439.168.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx03p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Mon, 21 Sep 2009 23:53:15 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4AB811EB.00C2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/09/09 23:53, Peter Zijlstra wrote:
> On Mon, 2009-09-21 at 23:22 +1000, Peter Williams wrote:
>> Or is the line:
>>
>> 	p->prio = effective_prio(p);
>>
>> in wake_up_new_task() an expensive no op.
>>
>> As far as I can tell from reading the code, it will always be the case
>> that EITHER rt_prio(p->prio) is true OR p->prio == p->normal_prio when
>> this call is made and, in either case, the value of p->prio will be
>> unchanged.  In addition, when this call is made p->normal_prio is
>> already equal to to normal_prio(p), so the side effects of the function
>> (setting p->normal_prio) are also unnecessary.
>>
>> Am I correct or have I missed something?
>
> Yuck @ all that prio code..
>
> I think you're right,  sched_fork() resets the prio, so poking at it in
> wake_up_new_task() seems superfluous.

After more thought, I also think it would be dangerous if it did 
actually change the value from/to a real time priority to/from a non 
real time priority as it runs the risk of leaving p with an 
inappropriate sched_class if CONFIG_RT_MUTEXES is defined.  It seems to 
me that if CONFIG_RT_MUTEXES is defined then any changes to a task's 
prio field needs to be accompanied by code to ensure the task has the 
correct sched_class value as well.

>
> I've been meaning to re-write most of the PI code one of these days, but
> so far I've not had time to.
>
> My initial goal is to replace plist with a rb-tree and fix some of the
> boost paths to be inside the scheduler. That is, we currently have the
> fun situation that we boost a lock owner, which becomes runnable, gets
> pushed to another cpu, then current blocks and reschedules, leaving this
> cpu to again sort out work.
>
> It would be much easier if we'd first dequeue current, then boost and
> then select the owner. Saves a bit of bouncing around.
>
> The rb-tree is needed for things like PI on CFS (yes, you can do a form
> of PI on proportional schedulers), and we're going to look at doing a
> full sporadic task model deadline scheduler, which needs both deadline
> inheritance and bandwidth inheritance.

I think that the __normal_prio(), normal_prio() and effective_prio() 
code are inefficient remnants of the old cpu scheduler that missed out 
on being cleaned up during the switch to CFS.  I think that they can be 
cleaned up a bit independently of the changes to the PI code that you 
mention.  I'll look at it further and see if I can come up with a patch.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
