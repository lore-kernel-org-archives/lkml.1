Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbZIWOgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbZIWOgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZIWOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:36:40 -0400
Received: from nskntmtas06p.mx.bigpond.com ([61.9.168.152]:31749 "EHLO
	nskntmtas06p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbZIWOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:36:40 -0400
Message-ID: <4ABA3279.3050703@bigpond.net.au>
Date: Thu, 24 Sep 2009 00:36:41 +1000
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
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx01p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Wed, 23 Sep 2009 14:36:41 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150205.4ABA327A.006B,ss=1,fgs=0
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

The recent sched_reset_on_fork changes to sched_fork() invalidate my 
statement (above) about p->normal_prio as they do not set it to the 
correct value (in all cases).  But it now means that the only useful 
work done by the above line in wake_up_new_task() is the side effect of 
setting p->normal_prio.  I think it would be better if it was set 
properly in sched_fork().  I'll send a patch tomorrow.

>>
>> Am I correct or have I missed something?
>
> Yuck @ all that prio code..
>
> I think you're right,  sched_fork() resets the prio, so poking at it in
> wake_up_new_task() seems superfluous.
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

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
